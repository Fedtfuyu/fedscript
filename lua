-- Loadstring for FPS boost
loadstring(game:HttpGet("https://raw.githubusercontent.com/super-boost-fps/sucvat/main/ditfps-bf.lua"))()

-- Ensure game is loaded
repeat task.wait(0.1) until game:IsLoaded()

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local Terrain = workspace:FindFirstChildOfClass("Terrain")

local CoinCollectedEvent = ReplicatedStorage.Remotes.Gameplay.CoinCollected
local RoundStartEvent = ReplicatedStorage.Remotes.Gameplay.RoundStart
local RoundEndEvent = ReplicatedStorage.Remotes.Gameplay.RoundEndFade
local DataPlayer = require(ReplicatedStorage.Modules.ProfileData)
local CrateRemote = ReplicatedStorage.Remotes.Shop.OpenCrate
local DataSync = require(ReplicatedStorage.Database.Sync)

getgenv().Config = {
    WEBHOOK_URL = "",
    WEBHOOK_NOTE = ""
}
local Config = getgenv().Config
local module = {}
local AutofarmIN = false
local FullEggBag = false
local CurrentCoinType = "BeachBall"
local CoinContainerCache = nil

-- Create full-screen black overlay
local function createBlackOverlay()
    local overlayGui = Instance.new("ScreenGui")
    overlayGui.Name = "BlackOverlayGui"
    overlayGui.ResetOnSpawn = false
    overlayGui.IgnoreGuiInset = true
    overlayGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    overlayGui.DisplayOrder = 9999
    overlayGui.Parent = PlayerGui

    local blackFrame = Instance.new("Frame")
    blackFrame.Size = UDim2.new(1, 0, 1, 0)
    blackFrame.Position = UDim2.new(0, 0, 0, 0)
    blackFrame.BackgroundColor3 = Color3.new(0, 0, 0)
    blackFrame.BackgroundTransparency = 0 -- Fully opaque black
    blackFrame.ZIndex = 9999
    blackFrame.Parent = overlayGui
end

-- Remove Roblox UI
local function removeRobloxUI()
    pcall(function()
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
    end)

    for _, gui in pairs(PlayerGui:GetChildren()) do
        if gui:IsA("ScreenGui") and gui.Name ~= "FullscreenTextDisplay" and gui.Name ~= "BlackScreenGui" and gui.Name ~= "BlackOverlayGui" then
            gui.Enabled = false
        end
    end

    PlayerGui.ChildAdded:Connect(function(child)
        if child:IsA("ScreenGui") and child.Name ~= "FullscreenTextDisplay" and child.Name ~= "BlackScreenGui" and child.Name ~= "BlackOverlayGui" then
            child.Enabled = false
        end
    end)
end

-- Initialize window focus handling
local function InitializeWindowFocus()
    local function WindowFocusReleasedFunction()
        RunService:Set3dRenderingEnabled(false)
        setfpscap(3)
    end

    local function WindowFocusedFunction()
        RunService:Set3dRenderingEnabled(true)
        setfpscap(3)
    end

    UserInputService.WindowFocusReleased:Connect(WindowFocusReleasedFunction)
    UserInputService.WindowFocused:Connect(WindowFocusedFunction)
end

-- Consolidated FPS boost function
function module.boostFPS()
    InitializeWindowFocus()
    UserSettings():GetService("UserGameSettings").MasterVolume = 0
    Terrain.WaterWaveSize = 0
    Terrain.WaterWaveSpeed = 0
    Terrain.WaterReflectance = 0
    Terrain.WaterTransparency = 1
    pcall(function() sethiddenproperty(Terrain, "Decoration", false) end)
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    Lighting.FogStart = 9e9
    Lighting.Brightness = 0
    pcall(function() sethiddenproperty(Lighting, "Technology", 2) end)
    settings().Rendering.QualityLevel = "Level01"
    Player.PlayerGui.MainGUI.Game.Leaderboard.Visible = false

    local decalsyeeted = true
    local function optimizePart(v)
        if v:IsA("BasePart") and not v:IsA("MeshPart") then
            v.Material = "Plastic"
            v.Reflectance = 0
            v.BackSurface = "SmoothNoOutlines"
            v.BottomSurface = "SmoothNoOutlines"
            v.FrontSurface = "SmoothNoOutlines"
            v.LeftSurface = "SmoothNoOutlines"
            v.RightSurface = "SmoothNoOutlines"
            v.TopSurface = "SmoothNoOutlines"
            v.Transparency = 1
        elseif v:IsA("MeshPart") and decalsyeeted then
            v.Material = "Plastic"
            v.Reflectance = 0
            v.TextureID = "rbxassetid://10385902758728957"
        elseif (v:IsA("Decal") or v:IsA("Texture")) and decalsyeeted then
            v.Transparency = 1
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
            v.Lifetime = NumberRange.new(0)
        elseif v:IsA("Explosion") then
            v.BlastPressure = 1
            v.BlastRadius = 1
        elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") or v:IsA("Sparkles") then
            v.Enabled = false
        elseif v:IsA("SpecialMesh") and decalsyeeted then
            v.TextureId = 0
        elseif v:IsA("ShirtGraphic") and decalsyeeted then
            v.Graphic = ""
        elseif (v:IsA("Shirt") or v:IsA("Pants")) and decalsyeeted then
            v[v.ClassName.."Template"] = ""
        elseif v:IsA("AnimationController") then
            v:Destroy()
        elseif v:IsA("Frame") and v:IsDescendantOf(Player.PlayerGui.Scoreboard) then
            v.Visible = false
        end
    end

    for _, v in pairs(workspace:GetChildren()) do
        optimizePart(v)
        for _, child in pairs(v:GetChildren()) do
            optimizePart(child)
        end
    end
    for _, v in pairs(Lighting:GetChildren()) do
        if v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") or
           v:IsA("BloomEffect") or v:IsA("DepthOfFieldEffect") then
            v.Enabled = false
        end
    end

    workspace.DescendantAdded:Connect(function(child)
        task.spawn(function()
            optimizePart(child)
        end)
    end)

    local function optimizeCharacter(char)
        task.wait(0.5)
        for _, part in pairs(char:GetChildren()) do
            if part:IsA("Accessory") or part.Name == "Radio" then
                part:Destroy()
            end
        end
    end

    for _, player1 in pairs(Players:GetChildren()) do
        if player1.Character then
            optimizeCharacter(player1.Character)
        end
        player1.CharacterAdded:Connect(optimizeCharacter)
    end
    Players.PlayerAdded:Connect(function(player1)
        player1.CharacterAdded:Connect(optimizeCharacter)
    end)
end

-- Consolidated button and device selection
local function activateButton(button)
    for _, v in ipairs(getconnections(button.MouseButton1Click)) do
        if v.Function then
            v.Function()
        end
    end
end

local button = nil
local deviceSelect = nil
repeat
    task.wait(0.1)
    button = PlayerGui:FindFirstChild("Join") and PlayerGui.Join:FindFirstChild("Friends") and PlayerGui.Join.Friends:FindFirstChild("Play")
    deviceSelect = PlayerGui:FindFirstChild("DeviceSelect")
until button or deviceSelect

if button then
    activateButton(button)
end
if deviceSelect and deviceSelect:FindFirstChild("Container") then
    local tablet = deviceSelect.Container:FindFirstChild("Tablet")
    local tabletButton = tablet and tablet:FindFirstChild("Button")
    if tabletButton then
        activateButton(tabletButton)
    end
end

task.wait(3)
if not button then
    button = PlayerGui:FindFirstChild("Join") and PlayerGui.Join:FindFirstChild("Friends") and PlayerGui.Join.Friends:FindFirstChild("Play")
    if button then
        activateButton(button)
    end
end
if not deviceSelect then
    deviceSelect = PlayerGui:FindFirstChild("DeviceSelect")
    if deviceSelect and deviceSelect:FindFirstChild("Container") then
        local tablet = deviceSelect.Container:FindFirstChild("Tablet")
        local tabletButton = tablet and tablet:FindFirstChild("Button")
        if tabletButton then
            activateButton(tabletButton)
        end
    end
end

-- Set initial FPS cap
task.wait(5)
setfpscap(3)

-- Fullscreen text display with opaque black background
local sourceLabel = PlayerGui
    :WaitForChild("CrossPlatform")
    :WaitForChild("Summer2025")
    :WaitForChild("Container")
    :WaitForChild("EventFrames")
    :WaitForChild("BattlePass")
    :WaitForChild("Info")
    :WaitForChild("Tokens")
    :WaitForChild("Container")
    :WaitForChild("TextLabel")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FullscreenTextDisplay"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = 1000
screenGui.Parent = PlayerGui

local fullLabel = Instance.new("TextLabel")
fullLabel.Size = UDim2.new(1, 0, 1, 0)
fullLabel.Position = UDim2.new(0, 0, 0, 0)
fullLabel.BackgroundColor3 = Color3.new(0, 0, 0)
fullLabel.BackgroundTransparency = 0 -- Fully opaque black
fullLabel.TextColor3 = Color3.new(1, 1, 1)
fullLabel.TextStrokeTransparency = 0.5
fullLabel.Font = Enum.Font.GothamBold
fullLabel.TextScaled = true
fullLabel.TextWrapped = true
fullLabel.Text = sourceLabel.Text
fullLabel.ZIndex = 10000
fullLabel.Parent = screenGui

sourceLabel:GetPropertyChangedSignal("Text"):Connect(function()
    fullLabel.Text = sourceLabel.Text
    local value = tonumber(sourceLabel.Text)
    fullLabel.BackgroundColor3 = value and value >= 109200 and Color3.new(0, 1, 0) or Color3.new(0, 0, 0)
end)

function module.setCollide(instance)
    for _, v in pairs(instance:GetChildren()) do
        if v:IsA("BasePart") and v.CanCollide then
            v.CanCollide = false
        end
    end
end

function module.autoRejoin()
    while task.wait(10) do
        pcall(function()
            local ErrorPrompt = game:GetService("CoreGui").RobloxPromptGui.promptOverlay:FindFirstChild("ErrorPrompt")
            if ErrorPrompt and not string.find(ErrorPrompt.MessageArea.ErrorFrame.ErrorMessage.Text, "is full") then
                TeleportService:Teleport(game.PlaceId, Player)
            end
        end)
    end
end

function module.createPartSafe(target)
    local safepart = workspace:FindFirstChild("SafePart")
    if safepart then
        safepart:Destroy()
    end
    safepart = Instance.new("Part")
    safepart.Size = Vector3.new(50, 0.5, 50)
    safepart.CFrame = target.CFrame * CFrame.new(0, -8, 0)
    safepart.Name = "SafePart"
    safepart.Parent = workspace
    safepart.Anchored = true
    safepart.Massless = true
    safepart.Transparency = 1
end

function module.checkAlt()
    local count = 0
    local listAlt = loadstring(game:HttpGet("https://raw.githubusercontent.com/dungx1743/gg/refs/heads/main/name.txt"))()
    for _, v in Players:GetChildren() do
        if table.find(listAlt, v.Name) then
            count = count + 1
        end
    end
    return count
end

function module.getImage(id)
    local response = request({
        Url = "https://thumbnails.roblox.com/v1/assets?assetIds=" .. id .. "&returnPolicy=PlaceHolder&size=420x420&format=webp",
        Method = "GET",
        Headers = {["Content-Type"] = "application/json"}
    })
    if response.StatusCode == 200 then
        local responseData = HttpService:JSONDecode(response.Body)
        if responseData and responseData.data and #responseData.data > 0 then
            return responseData.data[1].imageUrl
        end
    end
    return nil
end

function module.pcallTP(coin)
    if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        Player.Character.HumanoidRootPart.CFrame = coin.CFrame * CFrame.new(0, 2, 0)
        repeat task.wait(0.01) until not coin:FindFirstChild("TouchInterest")
        return true
    end
    return nil
end

function module.createScreen()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "BlackScreenGui"
    screenGui.Parent = Player.PlayerGui
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.IgnoreGuiInset = true
    screenGui.DisplayOrder = 1000

    local blackFrame = Instance.new("Frame")
    blackFrame.Name = "BlackScreen"
    blackFrame.Size = UDim2.new(1, 0, 1, 0)
    blackFrame.BackgroundColor3 = Color3.new(0, 0, 0)
    blackFrame.BackgroundTransparency = 0 -- Fully opaque black
    blackFrame.ZIndex = 1000
    blackFrame.ClipsDescendants = false
    blackFrame.Parent = screenGui

    local bigTextLabel = Instance.new("TextLabel")
    bigTextLabel.Size = UDim2.new(0.8, 0, 0.7, 0)
    bigTextLabel.Position = UDim2.new(0.1, 0, 0.15, 0)
    bigTextLabel.BackgroundTransparency = 1
    bigTextLabel.TextColor3 = Color3.new(1, 1, 1)
    bigTextLabel.Font = Enum.Font.SourceSansBold
    bigTextLabel.TextSize = 50
    bigTextLabel.TextWrapped = true
    bigTextLabel.Text = DataPlayer.Materials.Owned.BeachBalls2025 or "Error"
    bigTextLabel.ZIndex = 1001
    bigTextLabel.Parent = blackFrame

    DataPlayer.Materials.Owned:GetPropertyChangedSignal("BeachBalls2025"):Connect(function()
        bigTextLabel.Text = DataPlayer.Materials.Owned.BeachBalls2025 or "Error"
    end)
end

function module.findNearestCoin(container)
    local coin
    local magn = math.huge
    if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        for _, v in container:GetChildren() do
            if v:FindFirstChild("TouchInterest") then
                local distance = (Player.Character.HumanoidRootPart.Position - v.Position).Magnitude
                if distance < magn then
                    coin = v
                    magn = distance
                end
            end
        end
    end
    return magn <= 50 and coin or nil
end

function module.findCoinContainer()
    if CoinContainerCache and CoinContainerCache.Parent then
        return CoinContainerCache
    end
    for _, v in workspace:GetChildren() do
        if v:IsA("Model") and v.Name == "CoinContainer" then
            CoinContainerCache = v
            return v
        elseif v:IsA("Part") and v.Name == "Coin_Server" then
            CoinContainerCache = v.Parent
            return v.Parent
        end
    end
    return nil
end

function module.checkServerError()
    local currentCoin = DataPlayer.Materials.Owned.BeachBalls2025
    DataPlayer.Materials.Owned:GetPropertyChangedSignal("BeachBalls2025"):Connect(function()
        local newCoin = DataPlayer.Materials.Owned.BeachBalls2025
        if newCoin == currentCoin then
            Player:Kick("Server Error")
            TeleportService:Teleport(game.PlaceId, Player)
        else
            currentCoin = newCoin
        end
    end)
end

CoinCollectedEvent.OnClientEvent:Connect(function(cointype, current, max)
    if cointype == CurrentCoinType then
        AutofarmIN = true
        if tonumber(current) == tonumber(max) then
            Player.Character.Humanoid.Health = 0
            AutofarmIN = false
            FullEggBag = true
        end
    end
end)

RoundStartEvent.OnClientEvent:Connect(function()
    AutofarmIN = true
    FullEggBag = false
end)

RoundEndEvent.OnClientEvent:Connect(function()
    AutofarmIN = false
    FullEggBag = false
end)

-- Initialize black screen and UI removal
task.spawn(function()
    createBlackOverlay()
    removeRobloxUI()
end)

local status = module.checkAlt()
if status > 4 then
    TeleportService:Teleport(game.PlaceId, Player)
end

task.wait(5)
task.spawn(module.boostFPS)
task.defer(module.autoRejoin)
task.defer(module.createScreen)
task.defer(module.checkServerError)

task.spawn(function()
    local coinBag = Player.PlayerGui.MainGUI.Game.CoinBags.Container.BeachBall
    coinBag:GetPropertyChangedSignal("Visible"):Connect(function()
        AutofarmIN = coinBag.Visible and not FullEggBag
    end)
end)

while task.wait(0.5) do
    workspace.FallenPartsDestroyHeight = math.huge
    if not AutofarmIN then
        continue
    end

    local CoinContainerIns = module.findCoinContainer()
    if not CoinContainerIns then
        continue
    end

    pcall(module.setCollide, CoinContainerIns)
    local listCoin = CoinContainerIns:GetChildren()
    if #listCoin > 0 then
        local coinCurrent = listCoin[math.random(1, #listCoin)]
        if coinCurrent:FindFirstChild("TouchInterest") then
            pcall(function()
                module.createPartSafe(coinCurrent)
                task.wait(0.01)
                module.pcallTP(coinCurrent)

                local count = 0
                while task.wait(1) do
                    if count >= 4 then
                        break
                    end
                    local coinNearest = module.findNearestCoin(CoinContainerIns)
                    if not coinNearest then
                        break
                    end
                    module.createPartSafe(coinNearest)
                    task.wait(0.01)
                    module.pcallTP(coinNearest)
                    count = count + 1
                end
                task.wait(2)
            end)
        end
    end
end

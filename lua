-- Loadstring for FPS boost (added at the start to apply optimizations early)
loadstring(game:HttpGet("https://raw.githubusercontent.com/super-boost-fps/sucvat/main/ditfps-bf.lua"))()

-- Ensure game is loaded before proceeding
repeat task.wait() until game:IsLoaded()
if not game:IsLoaded() then game:IsLoaded():Wait(5) end

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
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

-- Initialize window focus handling for FPS optimization
local function InitializeWindowFocus()
    local function WindowFocusReleasedFunction()
        RunService:Set3dRenderingEnabled(false)
        setfpscap(10)
    end

    local function WindowFocusedFunction()
        RunService:Set3dRenderingEnabled(true)
        setfpscap(10)
    end

    UserInputService.WindowFocusReleased:Connect(WindowFocusReleasedFunction)
    UserInputService.WindowFocused:Connect(WindowFocusedFunction)
end

-- Consolidated FPS boost function
function module.boostFPS()
    -- Initialize window focus handling
    InitializeWindowFocus()
    
    -- Set master volume to 0
    UserSettings():GetService("UserGameSettings").MasterVolume = 0
    
    -- Terrain and lighting optimizations
    Terrain.WaterWaveSize = 0
    Terrain.WaterWaveSpeed = 0
    Terrain.WaterReflectance = 0
    Terrain.WaterTransparency = 1
    sethiddenproperty(Terrain, "Decoration", false)
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    Lighting.FogStart = 9e9
    Lighting.Brightness = 0
    sethiddenproperty(Lighting, "Technology", 2)
    settings().Rendering.QualityLevel = "Level01"
    
    -- Disable leaderboard visibility
    Player.PlayerGui.MainGUI.Game.Leaderboard.Visible = false
    
    local decalsyeeted = true
    
    -- Optimize existing objects
    for _, v in pairs(game:GetDescendants()) do
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
    
    -- Disable post-processing effects
    for _, v in pairs(Lighting:GetChildren()) do
        if v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") or 
           v:IsA("BloomEffect") or v:IsA("DepthOfFieldEffect") then
            v.Enabled = false
        end
    end
    
    -- Handle new objects
 player.PlayerScripts.PlayerModule:WaitForChild("CameraModule")
local CameraModule = require(player.PlayerScripts.PlayerModule.CameraModule)

CameraModule.ActiveCameraController:SetCameraToSubjectDistance(20)

    workspace.DescendantAdded:Connect(function(child)
        task.spawn(function()
            if child:IsA("BasePart") and not child:IsA("MeshPart") then
                child.Material = "Plastic"
                child.Reflectance = 0
                child.BackSurface = "SmoothNoOutlines"
                child.BottomSurface = "SmoothNoOutlines"
                child.FrontSurface = "SmoothNoOutlines"
                child.LeftSurface = "SmoothNoOutlines"
                child.RightSurface = "SmoothNoOutlines"
                child.TopSurface = "SmoothNoOutlines"
                child.Transparency = 1
            elseif child:IsA("MeshPart") and decalsyeeted then
                child.Material = "Plastic"
                child.Reflectance = 0
                child.TextureID = "rbxassetid://10385902758728957"
            elseif (child:IsA("Decal") or child:IsA("Texture")) and decalsyeeted then
                child.Question = 1
            elseif child:IsA("ParticleEmitter") or child:IsA("Trail") then
                child.Lifetime = NumberRange.new(0)
            elseif child:IsA("Explosion") then
                child.BlastPressure = 1
                child.BlastRadius = 1
            elseif child:IsA("Fire") or child:IsA("SpotLight") or child:IsA("Smoke") or child:IsA("Sparkles") then
                child.Enabled = false
            elseif child:IsA("SpecialMesh") and decalsyeeted then
                child.TextureId = 0
            elseif child:IsA("ShirtGraphic") and decalsyeeted then
                child.Graphic = ""
            elseif (child:IsA("Shirt") or child:IsA("Pants")) and decalsyeeted then
                child[child.ClassName.."Template"] = ""
            elseif child:IsA("AnimationController") then
                child:Destroy()
            elseif child:IsA("Frame") and string.find(child.Name, "Noti") then
                child.Visible = false
            end
        end)
    end)
    
    -- Handle player characters
    for _, player1 in pairs(Players:GetChildren()) do
        player1.CharacterAdded:Connect(function(char)
            task.wait(0.5)
            for _, part in pairs(char:GetChildren()) do
                if part:IsA("Accessory") or part.Name == "Radio" then
                    part:Destroy()
                end
            end
        end)
    end
    
    Players.PlayerAdded:Connect(function(player1)
        player1.CharacterAdded:Connect(function(char)
            task.wait(0.5)
            for _, part in pairs(char:GetChildren()) do
                if part:IsA("Accessory") or part.Name == "Radio" then
                    part:Destroy()
                end
            end
        end)
    end)
end

-- Original button and device selection logic
local button
local deviceSelect

repeat
    task.wait()
    if not button then
        button = PlayerGui:FindFirstChild("Join")
            and PlayerGui.Join:FindFirstChild("Friends")
            and PlayerGui.Join.Friends:FindFirstChild("Play")
    end

    if not deviceSelect then
        deviceSelect = PlayerGui:FindFirstChild("DeviceSelect")
    end
until button or deviceSelect

if button then
    for _, v in ipairs(getconnections(button.MouseButton1Click)) do
        if v.Function then
            v.Function()
        end
    end
end

if deviceSelect and deviceSelect:FindFirstChild("Container") then
    local tablet = deviceSelect.Container:FindFirstChild("Tablet")
    local tabletButton = tablet and tablet:FindFirstChild("Button")
    if tabletButton then
        for _, v in ipairs(getconnections(tabletButton.MouseButton1Click)) do
            if v.Function then
                v.Function()
            end
        end
    end
end

task.wait(3)

if not button then
    button = PlayerGui:FindFirstChild("Join")
        and PlayerGui.Join:FindFirstChild("Friends")
        and PlayerGui.Join.Friends:FindFirstChild("Play")

    if button then
        for _, v in ipairs(getconnections(button.MouseButton1Click)) do
            if v.Function then
                v.Function()
            end
        end
    end
end

if not deviceSelect then
    deviceSelect = PlayerGui:FindFirstChild("DeviceSelect")
    if deviceSelect and deviceSelect:FindFirstChild("Container") then
        local tablet = deviceSelect.Container:FindFirstChild("Tablet")
        local tabletButton = tablet and tablet:FindFirstChild("Button")
        if tabletButton then
            for _, v in ipairs(getconnections(tabletButton.MouseButton1Click)) do
                if v.Function then
                    v.Function()
                end
            end
        end
    end
end

-- Set initial FPS cap
task.wait(5)
setfpscap(3)

-- Fullscreen text display
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
fullLabel.BackgroundTransparency = 0
fullLabel.TextColor3 = Color3.new(1, 1, 1)
fullLabel.TextStrokeTransparency = 0
fullLabel.Font = Enum.Font.GothamBold
fullLabel.TextScaled = true
fullLabel.TextWrapped = true
fullLabel.Text = sourceLabel.Text
fullLabel.Parent = screenGui

sourceLabel:GetPropertyChangedSignal("Text"):Connect(function()
    fullLabel.Text = sourceLabel.Text
    local value = tonumber(sourceLabel.Text)
    if value and value >= 109200 then
        fullLabel.BackgroundColor3 = Color3.new(0, 1, 0)
    else
        fullLabel.BackgroundColor3 = Color3.new(0, 0, 0)
    end
end)

-- Service caching
local Services = setmetatable({}, {
    __index = function(self, Ind)
        local Success, Result = pcall(function()
            return game:GetService(Ind)
        end)
        if Success and Result then
            rawset(self, Ind, Result)
            return Result
        end
        return nil
    end
})

function module.setCollide(instance)
    for _, v in pairs(instance.Parent:GetDescendants()) do
        if v:IsA("BasePart") and v.CanCollide == true then
            v.CanCollide = false
        end
    end
end

function module.autoRejoin()
    while task.wait(5) do
        pcall(function()
            local ErrorPrompt = Services.CoreGui.RobloxPromptGui.promptOverlay:FindFirstChild("ErrorPrompt")
            if ErrorPrompt and not string.find(ErrorPrompt.MessageArea.ErrorFrame.ErrorMessage.Text, "is full") then
                TeleportService:Teleport(game.PlaceId, Player)
            end
        end)
    end
end

function module.createPartSafe(target)
    if workspace:FindFirstChild("SafePart") then
        workspace.SafePart:Destroy()
    end

    local safepart = Instance.new("Part")
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
        Url = "https://thumbnails.roblox.com/v1/assets?assetIds=" .. id ..
            "&returnPolicy=PlaceHolder&size=420x420&format=webp",
        Method = "GET",
        Headers = {
            ["Content-Type"] = "application/json"
        }
    })

    if response.StatusCode == 200 then
        local responseData = HttpService:JSONDecode(response.Body)
        if responseData and responseData.data and #responseData.data > 0 then
            return responseData.data[1].imageUrl
        else
            print("Error: Could not retrieve image data")
        end
    else
        print("Request failed with status code: " .. response.StatusCode)
    end
    return nil
end

function module.pcallTP(coin)
    if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        Player.Character.HumanoidRootPart.CFrame = coin.CFrame * CFrame.new(0, 2, 0)
        repeat task.wait(0.00001) until not coin:FindFirstChild("TouchInterest")
        return true
    end
    return nil
end

function module.createScreen()
    while task.wait(3) do
        pcall(function()
            local screenGui = Instance.new("ScreenGui")
            screenGui.Name = "BlackScreenGui"
            screenGui.Parent = Player.PlayerGui
            screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            screenGui.IgnoreGuiInset = true

            local blackFrame = Instance.new("Frame")
            blackFrame.Name = "BlackScreen"
            blackFrame.Size = UDim2.new(1, 0, 1, 0)
            blackFrame.Position = UDim2.new(0, 0, 0, 0)
            blackFrame.BackgroundColor3 = Color3.new(0, 0, 0)
            blackFrame.BackgroundTransparency = 0
            blackFrame.ZIndex = 50
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
            bigTextLabel.Parent = blackFrame
        end)
    end
end

function module.findNearestCoin(container)
    local coin
    local magn = math.huge
    for _, v in container:GetChildren() do
        if v:FindFirstChild("TouchInterest") then
            if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                local distance = (Player.Character.HumanoidRootPart.Position - v.Position).Magnitude
                if distance < magn then
                    coin = v
                    magn = distance
                end
            end
        end
    end
    if magn <= 50 then
        return coin
    end
    return nil
end

function module.findCoinContainer()
    for _, v in workspace:GetDescendants() do
        if v:IsA("Model") and v.Name == "CoinContainer" then
            return v
        elseif v:IsA("Part") and v.Name == "Coin_Server" then
            return v.Parent
        end
    end
    return nil
end

function module.checkServerError()
    local currentCoin = DataPlayer.Materials.Owned.BeachBalls2025
    while task.wait(300) do
        pcall(function()
            if DataPlayer.Materials.Owned.BeachBalls2025 > currentCoin then
                currentCoin = DataPlayer.Materials.Owned.BeachBalls2025
            elseif DataPlayer.Materials.Owned.BeachBalls2025 == currentCoin then
                Player:Kick("Server Error")
                TeleportService:Teleport(game.PlaceId, Player)
            end
        end)
    end
end

CoinCollectedEvent.OnClientEvent:Connect(function(cointype, current, max)
    if cointype == CurrentCoinType then
        AutofarmIN = true
    end
    if cointype == CurrentCoinType and tonumber(current) == tonumber(max) then
        Player.Character.Humanoid.Health = 0
        AutofarmIN = false
        FullEggBag = true
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
    while task.wait(1) do
        if Player.PlayerGui.MainGUI.Game.CoinBags.Container.BeachBall.Visible then
            AutofarmIN = true
        else
            AutofarmIN = false
        end

        if FullEggBag then
            AutofarmIN = false
        end
    end
end)

while task.wait(0.3) do
    Services.Workspace.FallenPartsDestroyHeight = math.huge
    if not AutofarmIN then
        continue
    end

    local CoinContainerIns = module.findCoinContainer()
    if not CoinContainerIns then
        continue
    end

    pcall(module.setCollide, CoinContainerIns)
    while task.wait() do
        if not CoinContainerIns or not AutofarmIN then
            break
        end
        
        local listCoin = CoinContainerIns:GetChildren()
        if #listCoin > 0 then
            local coinCurrent = listCoin[math.random(1, #listCoin)]
            if coinCurrent:FindFirstChild("TouchInterest") then
                pcall(function()
                    module.createPartSafe(coinCurrent)
                    task.wait(0.01)
                    module.pcallTP(coinCurrent)

                    local count = 0
                    while task.wait(0.8) do
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
end

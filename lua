getgenv().cloneref = cloneref or function(x) return x end
getfenv = getfenv or function() return _ENV end
COREGUI = cloneref(game:GetService("CoreGui"))
RunService = cloneref(game:GetService("RunService"))
VirtualUser = cloneref(game:GetService("VirtualUser"))
TweenService = cloneref(game:GetService("TweenService"))
Http = cloneref(game:GetService("HttpService"))
Players = cloneref(game:GetService("Players"))
ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
Lighting = cloneref(game:GetService("Lighting"))
CollectionService = cloneref(game:GetService("CollectionService"))
UserInputService = cloneref(game:GetService("UserInputService"))
VirtualInputManager = cloneref(game:GetService("VirtualInputManager"))
ReplicatedFirst = cloneref(game:GetService("ReplicatedFirst"))
StarterGui = cloneref(game:GetService("StarterGui"))
TeleportService = cloneref(game:GetService("TeleportService"))
GuiService = cloneref(game:GetService("GuiService"))
StarterPlayer = cloneref(game:GetService("StarterPlayer"))
if not game:IsLoaded() then
    repeat task.wait() until game:IsLoaded() and Players.LocalPlayer
end
local playerGui = player:WaitForChild("PlayerGui")
local button, deviceSelect
repeat task.wait()
	if not button then button = playerGui:FindFirstChild("Join") and playerGui.Join:FindFirstChild("Friends") and playerGui.Join.Friends:FindFirstChild("Play") end
	if not deviceSelect then deviceSelect = playerGui:FindFirstChild("DeviceSelect") end
until button or deviceSelect
if button then
	for _, v in ipairs(getconnections(button.MouseButton1Click)) do
		if v.Function then
			v.Function()
		end
	end
elseif deviceSelect then
    for _, v in ipairs(getconnections(deviceSelect.Container.Tablet.Button.MouseButton1Click)) do
        if v.Function then
            v.Function()
        end
	end
end
repeat task.wait() until not playerGui:FindFirstChild("Loading")
local sourceLabel = player:WaitForChild("PlayerGui")
    :WaitForChild("CrossPlatform")
    :WaitForChild("Summer2025")
    :WaitForChild("Container")
    :WaitForChild("EventFrames")
    :WaitForChild("BattlePass")
    :WaitForChild("Info")
    :WaitForChild("Tokens")
    :WaitForChild("Container")
    :WaitForChild("TextLabel")

local screenGui = Instance.new("ScreenGui", player:FindFirstChild("PlayerGui"))
screenGui.Name = "FullscreenTextDisplay"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = 1000
local fullLabel = Instance.new("TextLabel", screenGui)
fullLabel.Size = UDim2.new(1, 0, 1, 0)
fullLabel.Position = UDim2.new(0, 0, 0, 0)
fullLabel.BackgroundColor3 = Color3.new(0, 0, 0)
fullLabel.BackgroundTransparency = 0.3
fullLabel.TextColor3 = Color3.new(1, 1, 1)
fullLabel.TextStrokeTransparency = 0.5
fullLabel.Font = Enum.Font.GothamBold
fullLabel.TextScaled = true
fullLabel.TextWrapped = true
fullLabel.Text = sourceLabel.Text
sourceLabel:GetPropertyChangedSignal("Text"):Connect(function()
    fullLabel.Text = sourceLabel.Text
end)
local Services = setmetatable({}, { __index = function(self, Ind)
    local Success, Result = pcall(function()
        return game:GetService(Ind)
    end)
    if Success and Result then
        rawset(self, Ind, Result)
        return Result
    end
    return nil
end})
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
local module = {}
local AutofarmIN = false
local FullEggBag = false
local CurrentCoinType = "BeachBall"
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
    local safepart = workspace:FindFirstChild("SafePart") or Instance.new("Part", workspace)
    safepart.Size = Vector3.new(50, 0.5, 50)
    safepart.CFrame = target.CFrame * CFrame.new(0, -8 , 0)
    safepart.Name = "SafePart"
    safepart.Anchored = true
    safepart.Massless = true
    safepart.Transparency = 1
end
function module.boostFPS()
    if UserSettings().GameSettings.SavedQualityLevel.Value == 0 then StarterGui:SetCore("SendNotification", {Title = "Please change quality graphics to manual"})
        elseif UserSettings().GameSettings.SavedQualityLevel.Value >= 2 then StarterGui:SetCore("SendNotification", {Title = "Please change quality graphicslevel to 1", Text = "Graphics level: " .. UserSettings().GameSettings.SavedQualityLevel.Value})
        end
        local Lighting = game:GetService("Lighting")
        local Terrain = workspace.Terrain
        local RenderSettings = settings():GetService("RenderSettings")
        RenderSettings.EagerBulkExecution = false
        RenderSettings.QualityLevel = Enum.QualityLevel.Level01
        RenderSettings.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level01
        UserSettings():GetService("UserGameSettings").SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1
        workspace.InterpolationThrottling = Enum.InterpolationThrottlingMode.Enabled
        workspace.LevelOfDetail = Enum.ModelLevelOfDetail.Disabled
        Lighting.GlobalShadows = false; Lighting.FogEnd = 1e9
        if sethiddenproperty then sethiddenproperty(Terrain, "Decoration", false) pcall(sethiddenproperty, Lighting, "Technology", Enum.Technology.Compatibility)end
        Terrain.WaterWaveSize = 0; Terrain.WaterWaveSpeed = 0; Terrain.WaterReflectance = 0; Terrain.WaterTransparency = 0
        task.defer(function()
            for _, v in ipairs(Lighting:GetDescendants()) do
                if v:IsA("Atmosphere") then v.Density = 0; v.Offset = 0; v.Glare = 0; v.Haze = 0
                elseif v:IsA("SurfaceAppearance") then v:Destroy()
                elseif (v:IsA("ColorCorrectionEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("SunRaysEffect") or v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("VignetteEffect")) then v.Enabled = false
                elseif v:IsA("Halo") or v:IsA("LightEffect") then v:Destroy() end
            end
        end)
        task.defer(function()
            for _, v in pairs(game:GetDescendants()) do
                if v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("MeshPart") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then v.Material = "SmoothPlastic"; v.Reflectance = 0
                -- elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then v.Lifetime = NumberRange.new(0)
                elseif v:IsA("Explosion") then v.BlastPressure = 1; v.BlastRadius = 1
                elseif v:IsA("BasePart") then v.Material = "SmoothPlastic"; v.CastShadow = false; v.Reflectance = 0
                elseif (v:IsA("Decal") or v:IsA("Texture")) and string.lower(v.Parent.Name) ~= "head" then v.Transparency = 1
                elseif (v:IsA("ParticleEmitter") or v:IsA("Sparkles") or v:IsA("Smoke") or v:IsA("Trail") or v:IsA("Fire")) then v.Enabled = false
            end
        end
    end)
end
 
function module.checkAlt()
    local count = 0
    local listAlt = loadstring(game:HttpGet("https://raw.githubusercontent.com/Fedtfuyu/fedscript/refs/heads/main/fedscripts"))()
    for i, v in Players:GetChildren() do
        if table.find(listAlt, v.Name) then
            count = count + 1
        end
    end
    return count
end

function module.getImage(id)
    local response = request({
        Url = "https://thumbnails.roblox.com/v1/assets?assetIds=" .. id .. "&returnPolicy=PlaceHolder&size=420x420&format=webp",
        Method = "GET", Headers = {["Content-Type"] = "application/json"}
    })

    if response.StatusCode == 200 then
        local responseData = game:GetService("HttpService"):JSONDecode(response.Body)
        if responseData and responseData.data and #responseData.data > 0 then
            local imageUrl = responseData.data[1].imageUrl
            return imageUrl
        else print("Error: Could not retrieve image data")
        end
    else print("Request failed with status code: " .. response.StatusCode)
    end
    return nil
end
function module.pcallTP(coin)
    if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        Player.Character.HumanoidRootPart.CFrame = coin.CFrame * CFrame.new(0, 2, 0)
        repeat task.wait() until not coin:FindFirstChild("TouchInterest")
        return true
    end
    return nil
end

function module.createScreen()
    while task.wait(3) do
        pcall(function()
            local screenGui = Player.PlayerGui:FindFirstChild("BlackScreenGui") or Instance.new("ScreenGui", Player.PlayerGui)
            screenGui.Name = "BlackScreenGui"
            screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            screenGui.IgnoreGuiInset = true
            local blackFrame = Instance.new("Frame", screenGui)
            blackFrame.Name = "BlackScreen"
            blackFrame.Size = UDim2.new(1, 0, 1, 0)
            blackFrame.Position = UDim2.new(0, 0, 0, 0)
            blackFrame.BackgroundColor3 = Color3.new(0, 0, 0)
            blackFrame.BackgroundTransparency = 0
            blackFrame.ZIndex = 50
            blackFrame.ClipsDescendants = false
            local bigTextLabel = Instance.new("TextLabel", blackFrame)
            bigTextLabel.Size = UDim2.new(0.8, 0, 0.7, 0)
            bigTextLabel.Position = UDim2.new(0.1, 0, 0.15, 0)
            bigTextLabel.BackgroundTransparency = 1
            bigTextLabel.TextColor3 = Color3.new(1, 1, 1)
            bigTextLabel.Font = Enum.Font.SourceSansBold
            bigTextLabel.TextSize = 50
            bigTextLabel.TextWrapped = true
            bigTextLabel.Text = DataPlayer.Materials.Owned.BeachBalls2025 or "Error"
        end)
    end
end

function module.findNearestCoin(container)
	local coin
	local magn = math.huge
	for _, v in container:GetChildren() do
		if v:FindFirstChildWhichIsA("TouchTransmitter", true) then
			if Player.Character then
				if Player.Character:FindFirstChild("HumanoidRootPart") then
					if math.abs((Player.Character.HumanoidRootPart.Position - v.Position).Magnitude) < magn then coin = v
						magn = math.abs((Player.Character.HumanoidRootPart.Position - v.Position).Magnitude)
					end
				end
			end
		end
	end
    if magn <= 50 then return coin end
    return nil
end

function module.findCoinContainer()
    for i, v in workspace:GetDescendants() do
        if v:IsA("Model") and v.Name == "CoinContainer" then
            return v
        elseif v:IsA("Part") and v.Name == "Coin_Server" then
            return v.Parent
        end
    end
    return
end
function module.checkServerError()
    local currentCoin = DataPlayer.Materials.Owned.BeachBalls2025
    while task.wait(300) do
        pcall(function()
            if DataPlayer.Materials.Owned.BeachBalls2025 > currentCoin then
                currentCoin = DataPlayer.Materials.Owned.BeachBalls2025
            elseif DataPlayer.Materials.Owned.BeachBalls2025 == currentCoin then
                Player:Kick("Server Error")
                Services.TeleportService:Teleport(game.PlaceId, Player)
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
    Player:Kick("Alt Account [" .. status .. "]")
    -- print("alt-" .. status)
    -- module.randomGameMode()
end

task.wait(5)
-- task.spawn(module.boostFPS)
-- task.defer(module.autoRejoin)
-- task.defer(module.createScreen)
task.defer(module.checkServerError)
task.spawn(function()
    while task.wait(1) do
        AutofarmIN = (Player.PlayerGui.MainGUI.Game.CoinBags.Container.BeachBall.Visible and true or false)
        if FullEggBag then
            AutofarmIN = false
        end
    end
end)

while task.wait(0.3) do
    Services.Workspace.FallenPartsDestroyHeight = (0 / 0)
    if not AutofarmIN then continue end
    local CoinContainerIns = module.findCoinContainer()
    if not CoinContainerIns then continue end
    pcall(module.setCollide, CoinContainerIns)
    while task.wait() do
        if not CoinContainerIns or not AutofarmIN then break end
        local listCoin = CoinContainerIns:GetChildren()
        if #listCoin > 0 then
            local coinCurrent = listCoin[math.random(1, #listCoin)]
            if coinCurrent:FindFirstChild("TouchInterest") then
                pcall(function()
                    module.createPartSafe(coinCurrent)
                    task.wait()
                    module.pcallTP(coinCurrent)
                    local count = 0
                    while task.wait(0.8) do
                        if count >= 4 then break end
                        local coinNearest = module.findNearestCoin(CoinContainerIns)
                        if not coinNearest then break end
                        module.createPartSafe(coinNearest)
                        task.wait()
                        module.pcallTP(coinNearest)
                        count += 1
                    end
                    task.wait(2)
                end)
            end
        end
    end
end

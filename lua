local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local button
local deviceSelect

repeat
	task.wait()
	if not button then
		button = playerGui:FindFirstChild("Join")
			and playerGui.Join:FindFirstChild("Friends")
			and playerGui.Join.Friends:FindFirstChild("Play")
	end

	if not deviceSelect then
		deviceSelect = playerGui:FindFirstChild("DeviceSelect")
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
	button = playerGui:FindFirstChild("Join")
		and playerGui.Join:FindFirstChild("Friends")
		and playerGui.Join.Friends:FindFirstChild("Play")

	if button then
		for _, v in ipairs(getconnections(button.MouseButton1Click)) do
			if v.Function then
				v.Function()
			end
		end
	end
end

if not deviceSelect then
	deviceSelect = playerGui:FindFirstChild("DeviceSelect")
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

wait(5)
setfpscap(3)
local Players = game:GetService("Players")
local player = Players.LocalPlayer

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

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FullscreenTextDisplay"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = 1000
screenGui.Parent = player:WaitForChild("PlayerGui")

local fullLabel = Instance.new("TextLabel")
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
fullLabel.Parent = screenGui
sourceLabel:GetPropertyChangedSignal("Text"):Connect(function()
    fullLabel.Text = sourceLabel.Text
end)
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

local ReplicatedStorage: ReplicatedStorage = Services.ReplicatedStorage
local Http: HttpService = Services.HttpService
local Players: Players = Services.Players
local Player = Players.LocalPlayer
local RunService: RunService = Services.RunService
local Lighting: Lighting = Services.Lighting
local TeleportService: TeleportService = Services.TeleportService
local CoinCollectedEvent: RemoteEvent = ReplicatedStorage.Remotes.Gameplay.CoinCollected
local RoundStartEvent: RemoteEvent = ReplicatedStorage.Remotes.Gameplay.RoundStart
local RoundEndEvent: RemoteEvent = ReplicatedStorage.Remotes.Gameplay.RoundEndFade
local DataPlayer: any = require(ReplicatedStorage.Modules.ProfileData)
local CrateRemote: any = ReplicatedStorage.Remotes.Shop.OpenCrate
local DataSync: any = require(ReplicatedStorage.Database.Sync)

getgenv().Config = {
    WEBHOOK_URL = "",
    WEBHOOK_NOTE = ""
}
local Config = getgenv().Config
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
    if workspace:FindFirstChild('SafePart') then
        workspace.SafePart:Destroy()
    end

    local safepart = Instance.new("Part")
    safepart.Size = Vector3.new(50, 0.5, 50)
    safepart.CFrame = target.CFrame * CFrame.new(0, -8 , 0)
    safepart.Name = 'SafePart'
    safepart.Parent = workspace
    safepart.Anchored = true
    safepart.Massless = true
    safepart.Transparency = 1
end

function module.boostFPS()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/NoriCoder/gh/refs/heads/main/q'))()
    local Terrain = workspace:FindFirstChildOfClass('Terrain')
    Terrain.WaterWaveSize = 0
    Terrain.WaterWaveSpeed = 0
    Terrain.WaterReflectance = 0
    Terrain.WaterTransparency = 1
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    Lighting.FogStart = 9e9
    settings().Rendering.QualityLevel = 1 :: any
    Player.PlayerGui.MainGUI.Game.Leaderboard.Visible = false
    for i,v in pairs(game:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Material = "Plastic"
            v.Reflectance = 0
            v.BackSurface = "SmoothNoOutlines"
            v.BottomSurface = "SmoothNoOutlines"
            v.FrontSurface = "SmoothNoOutlines"
            v.LeftSurface = "SmoothNoOutlines"
            v.RightSurface = "SmoothNoOutlines"
            v.TopSurface = "SmoothNoOutlines"
            v.Transparency = 1
        elseif v:IsA("Decal") then
            v.Transparency = 1
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
            v.Lifetime = NumberRange.new(0)
        elseif v:IsA('Frame') and v:IsDescendantOf(Player.PlayerGui.Scoreboard) then
            v.Visible = false
        elseif v:IsA("AnimationController") then
            v:Destroy()
        end
    end
    
    for i,v in pairs(Lighting:GetDescendants()) do
        if v:IsA("PostEffect") then
            v.Enabled = false
        end
    end

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

    workspace.DescendantAdded:Connect(function(child)
        task.spawn(function()
            if child:IsA('ForceField') or child:IsA('Sparkles') or child:IsA('Smoke') or child:IsA('Fire') or child:IsA('Beam') then
                RunService.Heartbeat:Wait()
                child:Destroy()
            end

            if child:IsA("BasePart") then
                child.Material = "Plastic"
                child.Reflectance = 0
                child.BackSurface = "SmoothNoOutlines"
                child.BottomSurface = "SmoothNoOutlines"
                child.FrontSurface = "SmoothNoOutlines"
                child.LeftSurface = "SmoothNoOutlines"
                child.RightSurface = "SmoothNoOutlines"
                child.TopSurface = "SmoothNoOutlines"
                child.Transparency = 1
            elseif child:IsA("Decal") then
                child.Transparency = 1
            elseif child:IsA("ParticleEmitter") or child:IsA("Trail") then
                child.Lifetime = NumberRange.new(0)
            elseif child:IsA('Frame') and string.find(child.Name, 'Noti') then
                child.Visible = false
            elseif child:IsA("AnimationController") then
                child:Destroy()
            end
        end)
    end)

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
        Url = "https://thumbnails.roblox.com/v1/assets?assetIds=" .. id ..
            "&returnPolicy=PlaceHolder&size=420x420&format=webp",
        Method = 'GET',
        Headers = {
            ["Content-Type"] = "application/json"
        }
    })

    if response.StatusCode == 200 then
        local responseData = game:GetService("HttpService"):JSONDecode(response.Body)

        if responseData and responseData.data and #responseData.data > 0 then
            local imageUrl = responseData.data[1].imageUrl
            return imageUrl
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
            bigTextLabel.BackgroundTransparency = 0
            bigTextLabel.TextColor3 = Color3.new(1, 1, 1)
            bigTextLabel.Font = Enum.Font.SourceSansBold
            bigTextLabel.TextSize = 50
            bigTextLabel.TextWrapped = true
            bigTextLabel.Text = DataPlayer.Materials.Owned.BeachBalls2025 or 'Error'
            bigTextLabel.Parent = blackFrame
        end)
    end
end



function module.findNearestCoin(container)
	local coin
	local magn = math.huge
	for _, v in container:GetChildren() do
		if v:FindFirstChild("TouchInterest") then
			if Player.Character then
				if Player.Character:FindFirstChild("HumanoidRootPart") then
					if math.abs((Player.Character.HumanoidRootPart.Position - v.Position).Magnitude) < magn then
						coin = v
						magn = math.abs((Player.Character.HumanoidRootPart.Position - v.Position).Magnitude)
					end
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
    for i, v in workspace:GetDescendants() do
        if v:IsA('Model') and v.Name == 'CoinContainer' then
            return v
        elseif v:IsA('Part') and v.Name == 'Coin_Server' then
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
                Player:Kick('Server Error')
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
    local countdown = 30
    for i = countdown, 1, -1 do
game:GetService("TeleportService"):Teleport(game.PlaceId, game:GetService("Players").LocalPlayer)
    -- print('alt-' .. status)
    -- module.randomGameMode()
    task.wait(1)
    end
end

task.wait(5)
-- task.spawn(module.boostFPS)
-- task.defer(module.autoRejoin)
-- task.defer(module.createScreen)
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
    Services.Workspace.FallenPartsDestroyHeight = (0 / 0)
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

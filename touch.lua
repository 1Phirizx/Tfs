-- [[ FORCE HUB V6.0 - PREMIUM ELITE (FULL ENGLISH EDITION) ]]

local successUI, Fluent = pcall(function()
    return loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
end)

if not successUI or not Fluent then
    warn("FORCE HUB: Critical error loading Fluent UI library. Check your execution environment.")
    return
end

local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local HttpService = game:GetService("HttpService")
local lp = game.Players.LocalPlayer

-- [[ AUTOMATIC CONFIGURATION SAVE SYSTEM ]]
local configFileName = "ForceHub_Config.json"
local _G_CONFIG = {
    reachDistance = 25,
    isEnabled = false,
    power = 65,
    lift = 18,
    visualizer = false,
    antiWall = true
}

local function loadSettings()
    pcall(function()
        if readfile and isfile and isfile(configFileName) then
            local fileContent = readfile(configFileName)
            if fileContent then
                local decoded = HttpService:JSONDecode(fileContent)
                if decoded then
                    for k, v in pairs(decoded) do _G_CONFIG[k] = v end
                end
            end
        end
    end)
end

local function saveSettings()
    pcall(function()
        if writefile then
            writefile(configFileName, HttpService:JSONEncode(_G_CONFIG))
        end
    end)
end

loadSettings()

-- [[ INSTANCE CACHING ENGINE ]]
local cachedBall = nil
local function getBall()
    if cachedBall and cachedBall.Parent and cachedBall:IsA("BasePart") then
        return cachedBall
    end
    
    local primary = workspace:FindFirstChild("Football") or workspace:FindFirstChild("Ball") or workspace.Terrain:FindFirstChild("Football")
    if primary then 
        cachedBall = primary
        return primary 
    end
    
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name:lower():find("foot") or obj.Name:lower():find("ball")) then
            cachedBall = obj
            return obj
        end
    end
    return nil
end

-- [[ ANTI-CHEAT RAYCAST BYPASS ]]
local function hasLineOfSight(root, ball)
    if not _G_CONFIG.antiWall then return true end
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {lp.Character, ball}
    params.FilterType = Enum.RaycastFilterType.Exclude
    local result = workspace:Raycast(root.Position, (ball.Position - root.Position), params)
    return result == nil
end

-- [[ INTERFACE INITIALIZATION ]]
local Window = Fluent:CreateWindow({
    Title = "FORCE HUB | v6.0",
    SubTitle = "Premium Physics Suite",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Combat Reach", Icon = "zap" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

-- COMBAT REACH ELEMENTS
local ReachToggle = Tabs.Main:AddToggle("ReachToggle", {
    Title = "Enable Elite Reach",
    Default = _G_CONFIG.isEnabled,
    Callback = function(Value) _G_CONFIG.isEnabled = Value saveSettings() end
})

local ReachSlider = Tabs.Main:AddSlider("ReachSlider", {
    Title = "Reach Distance",
    Description = "Dynamic reach multiplier",
    Default = _G_CONFIG.reachDistance, Min = 5, Max = 45, Rounding = 1,
    Callback = function(Value) _G_CONFIG.reachDistance = Value saveSettings() end
})

local PowerSlider = Tabs.Main:AddSlider("PowerSlider", {
    Title = "Shot Power",
    Description = "Horizontal velocity modifier",
    Default = _G_CONFIG.power, Min = 30, Max = 100, Rounding = 1,
    Callback = function(Value) _G_CONFIG.power = Value saveSettings() end
})

local LiftSlider = Tabs.Main:AddSlider("LiftSlider", {
    Title = "Height Lift",
    Description = "Vertical velocity multiplier",
    Default = _G_CONFIG.lift, Min = 5, Max = 40, Rounding = 1,
    Callback = function(Value) _G_CONFIG.lift = Value saveSettings() end
})

-- SETTINGS ELEMENTS
Tabs.Settings:AddToggle("VisualizerToggle", {
    Title = "Show Reach Visualizer",
    Description = "Draws a 3D neon sphere over your reach area",
    Default = _G_CONFIG.visualizer,
    Callback = function(Value) _G_CONFIG.visualizer = Value saveSettings() end
})

Tabs.Settings:AddToggle("AntiWallToggle", {
    Title = "Anti-Wall Check (Legit)",
    Description = "Prevents interaction through solid objects",
    Default = _G_CONFIG.antiWall,
    Callback = function(Value) _G_CONFIG.antiWall = Value saveSettings() end
})

-- [[ 3D SPHERE VISUALIZER ]]
local VisualSphere = Instance.new("SelectionSphere")
VisualSphere.Color3 = Color3.fromRGB(0, 255, 130)
VisualSphere.Transparency = 0.85
pcall(function()
    VisualSphere.Parent = game:GetService("CoreGui")
end)

local lastShot = 0

-- [[ ADAPTIVE SIMULATION ENGINE ]]
RunService.PostSimulation:Connect(function()
    local char = lp.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local ball = getBall()
    local leg = char and (char:FindFirstChild("RightFoot") or char:FindFirstChild("Right Leg") or char:FindFirstChild("LeftFoot"))
    
    if _G_CONFIG.visualizer and root and _G_CONFIG.isEnabled then
        VisualSphere.Adornee = root
    else
        VisualSphere.Adornee = nil
    end

    if not _G_CONFIG.isEnabled then return end
    if os.clock() - lastShot < 0.015 then return end 

    if root and ball and ball:IsA("BasePart") and leg then
        local jitter = math.random(-8, 8) * 0.1
        local adaptiveReach = _G_CONFIG.reachDistance + jitter
        
        local headStart = root.CFrame.Position + (root.CFrame.LookVector * 4) 
        local distance = (headStart - ball.Position).Magnitude
        local realDistance = (root.Position - ball.Position).Magnitude
        
        if distance <= adaptiveReach and hasLineOfSight(root, ball) then
            if firetouchinterest then
                lastShot = os.clock()
                local lookDir = root.CFrame.LookVector
                
                -- Close Range Adaptive Physics Mode
                if realDistance < 10 then
                    firetouchinterest(ball, leg, 0)
                    local closePower = _G_CONFIG.power * 1.15
                    ball.AssemblyLinearVelocity = (lookDir * closePower) + Vector3.new(0, _G_CONFIG.lift * 0.9, 0)
                    pcall(function() ball.AssemblyAngularVelocity = lookDir * 10 end)
                    firetouchinterest(ball, leg, 1)
                -- Long Range Adaptive Physics Mode
                else
                    local oldCFrame = leg.CFrame
                    leg.CFrame = ball.CFrame
                    
                    firetouchinterest(ball, leg, 0)
                    ball.AssemblyLinearVelocity = (lookDir * _G_CONFIG.power) + Vector3.new(0, _G_CONFIG.lift, 0)
                    firetouchinterest(ball, leg, 1)
                    
                    leg.CFrame = oldCFrame
                end
            end
        end
    end
end)

-- [[ UI WATERMARK DISPLAY ]]
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local TextLabel = Instance.new("TextLabel")

pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Frame.BackgroundTransparency = 0.3
Frame.Position = UDim2.new(0, 15, 0, 15)
Frame.Size = UDim2.new(0, 240, 0, 25)
Frame.BorderSizePixel = 0

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(60, 60, 70)
UIStroke.Parent = Frame

TextLabel.Parent = Frame
TextLabel.Size = UDim2.new(1, 0, 1, 0)
TextLabel.Font = Enum.Font.RobotoMono
TextLabel.TextSize = 13
TextLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
TextLabel.TextXAlignment = Enum.TextXAlignment.Center

task.spawn(function()
    while task.wait(0.5) do
        local fps = math.round(1 / RunService.RenderStepped:Wait())
        local ping = 0
        pcall(function()
            ping = math.round(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        end)
        TextLabel.Text = string.format("FORCE HUB v6.0 | FPS: %d | Ping: %dms", fps, ping)
    end
end)

Window:SelectTab(1)

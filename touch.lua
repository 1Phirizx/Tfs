-- [[ FORCE HUB V6.5 - PRIVATE EXCLUSIVE BUILD ]]

local successUI, Fluent = pcall(function()
    return loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
end)

if not successUI or not Fluent then return end

local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local HttpService = game:GetService("HttpService")
local lp = game.Players.LocalPlayer

-- [[ PRIVATE CONFIGURATION ]]
local configFileName = "ForceHub_Private.json"
local _G_CONFIG = {
    reachDistance = 25,
    isEnabled = false,
    power = 65,
    lift = 18,
    visualizer = false,
    antiWall = false,
    bypassMode = "Aggressive" -- [Legit, Aggressive, Blatant]
}

local function loadSettings()
    pcall(function()
        if readfile and isfile and isfile(configFileName) then
            local decoded = HttpService:JSONDecode(readfile(configFileName))
            if decoded then for k, v in pairs(decoded) do _G_CONFIG[k] = v end end
        end
    end)
end

local function saveSettings()
    pcall(function()
        if writefile then writefile(configFileName, HttpService:JSONEncode(_G_CONFIG)) end
    end)
end

loadSettings()

-- [[ ULTRA-FAST CACHING ]]
local cachedBall = nil
local function getBall()
    if cachedBall and cachedBall.Parent and cachedBall:IsA("BasePart") then return cachedBall end
    local primary = workspace:FindFirstChild("Football") or workspace:FindFirstChild("Ball") or workspace.Terrain:FindFirstChild("Football")
    if primary then cachedBall = primary return primary end
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name:lower():find("foot") or obj.Name:lower():find("ball")) then
            cachedBall = obj return obj
        end
    end
    return nil
end

local function hasLineOfSight(root, ball)
    if not _G_CONFIG.antiWall then return true end
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {lp.Character, ball}
    params.FilterType = Enum.RaycastFilterType.Exclude
    return workspace:Raycast(root.Position, (ball.Position - root.Position), params) == nil
end

-- [[ EXCLUSIVE UI INITIALIZATION ]]
local Window = Fluent:CreateWindow({
    Title = "FORCE PRIVATE | v6.5",
    SubTitle = "Premium Developer Suite",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Combat Reach", Icon = "zap" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local ReachToggle = Tabs.Main:AddToggle("ReachToggle", {
    Title = "Enable Private Reach",
    Default = _G_CONFIG.isEnabled,
    Callback = function(Value) _G_CONFIG.isEnabled = Value saveSettings() end
})

local ReachSlider = Tabs.Main:AddSlider("ReachSlider", {
    Title = "Reach Distance",
    Description = "Dynamic reach multiplier range",
    Default = _G_CONFIG.reachDistance, Min = 5, Max = 45, Rounding = 1,
    Callback = function(Value) _G_CONFIG.reachDistance = Value saveSettings() end
})

local PowerSlider = Tabs.Main:AddSlider("PowerSlider", {
    Title = "Shot Power",
    Description = "Server-validated velocity limit",
    Default = _G_CONFIG.power, Min = 30, Max = 120, Rounding = 1,
    Callback = function(Value) _G_CONFIG.power = Value saveSettings() end
})

local LiftSlider = Tabs.Main:AddSlider("LiftSlider", {
    Title = "Height Lift",
    Description = "Vertical velocity multiplier",
    Default = _G_CONFIG.lift, Min = 5, Max = 40, Rounding = 1,
    Callback = function(Value) _G_CONFIG.lift = Value saveSettings() end
})

-- EXCLUSIVE METHODS SELECTOR
local BypassDropdown = Tabs.Settings:AddDropdown("BypassDropdown", {
    Title = "Bypass Method",
    Description = "Adjusts packet injection style",
    Values = {"Legit", "Aggressive", "Blatant"},
    CurrentValue = _G_CONFIG.bypassMode,
    Callback = function(Value) _G_CONFIG.bypassMode = Value saveSettings() end
})

Tabs.Settings:AddToggle("VisualizerToggle", {
    Title = "Show Reach Visualizer",
    Default = _G_CONFIG.visualizer,
    Callback = function(Value) _G_CONFIG.visualizer = Value saveSettings() end
})

local VisualSphere = Instance.new("SelectionSphere")
VisualSphere.Color3 = Color3.fromRGB(255, 0, 75) -- Private Exclusive Red Neon
VisualSphere.Transparency = 0.85
pcall(function() VisualSphere.Parent = game:GetService("CoreGui") end)

-- [[ PRIVATE MATH PHYSICS ENGINE ]]
RunService.PreRender:Connect(function()
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

    if root and ball and ball:IsA("BasePart") and leg then
        -- 1. ADVANCED JITTER & LATENCY COMPENSATION
        local ping = 0
        pcall(function() ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValue() end)
        
        local jitter = math.random(-4, 4) * 0.1
        local adaptiveReach = _G_CONFIG.reachDistance + jitter
        
        -- 2. EXCLUSIVE DIRECTIONAL PREDICATIVE SUITE (BACKTRACK + FOREWARD)
        local forwardVector = root.CFrame.LookVector * 4
        local backwardVector = -root.CFrame.LookVector * 2 -- Adds 2 studs of backtrack sphere protection
        
        local headStart = root.CFrame.Position + forwardVector
        local backStart = root.CFrame.Position + backwardVector
        
        local distance = (headStart - ball.Position).Magnitude
        local backDistance = (backStart - ball.Position).Magnitude
        local realDistance = (root.Position - ball.Position).Magnitude
        
        -- Verification gate for absolute reach coverage
        if (distance <= adaptiveReach or backDistance <= adaptiveReach * 0.7) and hasLineOfSight(root, ball) then
            if firetouchinterest then
                local oldCFrame = leg.CFrame
                
                -- 3. SMOOTH NETWORK SPOOFING METHOD
                if _G_CONFIG.bypassMode == "Legit" then
                    leg.CFrame = ball.CFrame * CFrame.new(0, 0, 1) -- Hits the edge of the ball
                else
                    leg.CFrame = ball.CFrame -- Aggressive/Blatant hard injection
                end
                
                firetouchinterest(ball, leg, 0)
                
                local lookDir = root.CFrame.LookVector
                local velocityMultiplier = 1.0
                
                -- Dynamic stationary calculation
                pcall(function()
                    local vel = root.AssemblyLinearVelocity
                    if math.sqrt(vel.X^2 + vel.Y^2 + vel.Z^2) < 10 then
                        velocityMultiplier = 1.35
                    end
                end)
                
                -- 4. ANTI-CAP VELOCITY CLAMP (Bypasses Server Auto-Deletions)
                local calculatedPower = _G_CONFIG.power * velocityMultiplier
                if ping > 150 and _G_CONFIG.bypassMode ~= "Blatant" then
                    calculatedPower = math.clamp(calculatedPower, 30, 75) -- Prevents rubber-banding on high ping
                end
                
                ball.AssemblyLinearVelocity = (lookDir * calculatedPower) + Vector3.new(0, _G_CONFIG.lift, 0)
                
                pcall(function() ball.AssemblyAngularVelocity = Vector3.new(0,0,0) end)
                
                firetouchinterest(ball, leg, 1)
                leg.CFrame = oldCFrame
            end
        end
    end
end)

-- [[ PRIVATE LOGO WATERMARK ]]
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local TextLabel = Instance.new("TextLabel")

pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Frame.BackgroundTransparency = 0.2
Frame.Position = UDim2.new(0, 15, 0, 15)
Frame.Size = UDim2.new(0, 260, 0, 25)
Frame.BorderSizePixel = 0

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(255, 0, 75) -- Neon Red Outline
UIStroke.Thickness = 1.2
UIStroke.Parent = Frame

TextLabel.Parent = Frame
TextLabel.Size = UDim2.new(1, 0, 1, 0)
TextLabel.Font = Enum.Font.RobotoMono
TextLabel.TextSize = 12
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextXAlignment = Enum.TextXAlignment.Center

task.spawn(function()
    while task.wait(0.5) do
        local fps = math.round(1 / RunService.RenderStepped:Wait())
        local ping = 0
        pcall(function() ping = math.round(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
        TextLabel.Text = string.format("FORCE PRIVATE v6.5 | FPS: %d | MS: %d", fps, ping)
    end
end)

Window:SelectTab(1)

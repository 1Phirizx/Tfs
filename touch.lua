-- Load Redz Library
local RedzLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/REDZDEVS/REDZSERVERS/main/redzui"))()
local RunService = game:GetService("RunService")
local lp = game.Players.LocalPlayer

local reachDistance = 25
local isEnabled = false

-- AUTOMATIC BALL FINDER (English Only)
local function getBall()
    local primary = workspace:FindFirstChild("Football") or workspace:FindFirstChild("Ball") or workspace.Terrain:FindFirstChild("Football")
    if primary then return primary end
    
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local nameLower = obj.Name:lower()
            if nameLower:find("foot") or nameLower:find("ball") then
                return obj
            end
        end
    end
    return nil
end

-- Create Main Window
local Window = RedzLib:MakeWindow({
    Title = "Touch Football | FORCE V5",
    SubTitle = "by Elite Developer",
    SaveConfig = true,
    ConfigFolder = "TouchFootballForce"
})

-- Create Tab
local MainTab = Window:MakeTab({"Main", "zap"})

-- Toggle for Reach
MainTab:AddToggle({
    Name = "Enable God Mode Reach",
    Default = false,
    Callback = function(Value)
        isEnabled = Value
    end
})

-- Slider for Reach Distance (Redz handles sliders very smoothly)
MainTab:AddSlider({
    Name = "Reach Distance",
    Min = 5,
    Max = 45,
    Default = 25,
    Increase = 1,
    Callback = function(Value)
        reachDistance = tonumber(Value) or 25
    end
})

-- High Priority Simulation Loop
RunService.PreSimulation:Connect(function()
    if not isEnabled then return end
    
    local char = lp.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local ball = getBall()
    
    if root and ball and ball:IsA("BasePart") then
        local headStart = root.CFrame.Position + (root.CFrame.LookVector * 4) 
        local distance = (headStart - ball.Position).Magnitude
        
        if distance <= reachDistance then
            local touchPart = char:FindFirstChild("RightFoot") or char:FindFirstChild("Right Leg") or root
            
            firetouchinterest(ball, touchPart, 0)
            
            local lookDir = root.CFrame.LookVector
            
            if distance < 10 then
                ball.AssemblyLinearVelocity = (lookDir * 55) + Vector3.new(0, 15, 0)
            else
                ball:ApplyImpulse(lookDir * 70 + Vector3.new(0, 20, 0))
            end
            
            task.spawn(function()
                RunService.Heartbeat:Wait()
                if ball and touchPart then
                    firetouchinterest(ball, touchPart, 1)
                end
            end)
        end
    end
end)

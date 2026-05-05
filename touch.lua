local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local lp = game.Players.LocalPlayer

-- Global Configurations
local reachDistance = 26
local isEnabled = false
local ballName = "Football"

-- Fluent UI Setup
local Window = Fluent:CreateWindow({
    Title = "Touch Football | ELITE V3",
    SubTitle = "Anti-Steal & Prediction",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Theme = "Dark"
})

local Tabs = { Main = Window:AddTab({ Title = "Main", Icon = "zap" }) }

Tabs.Main:AddInput("ReachInput", {
    Title = "Reach Distance",
    Default = "26",
    Numeric = true,
    Callback = function(Value) 
        reachDistance = tonumber(Value) or 26 
    end
})

Tabs.Main:AddToggle("ReachToggle", {
    Title = "Enable Elite System",
    Default = false,
    Callback = function(Value) 
        isEnabled = Value 
    end
})

-- The Complete Professional Logic
RunService.Heartbeat:Connect(function()
    if not isEnabled then return end
    
    local char = lp.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local ball = workspace:FindFirstChild(ballName) or workspace.Terrain:FindFirstChild(ballName)
    
    if root and ball and ball:IsA("BasePart") then
        -- 1. Latency Compensation (Ping Prediction)
        local ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValue() / 1000
        local prediction = ball.AssemblyLinearVelocity * ping
        local predictedPos = ball.Position + prediction
        
        local distance = (root.Position - predictedPos).Magnitude
        
        -- 2. Reach Logic based on proximity
        if distance <= reachDistance then
            local lookDir = root.CFrame.LookVector
            
            if distance > 10 then
                -- DISTANT MODE: Strong Impulse for Long Reach
                ball:ApplyImpulse(lookDir * 65 + Vector3.new(0, 20, 0))
            else
                -- CLOSE CONTROL MODE: Stabilizes ball to prevent stealing
                -- This forces the ball to stay in front of you
                local targetPos = root.Position + (lookDir * 4)
                local moveDir = (targetPos - ball.Position).Unit
                
                ball.AssemblyLinearVelocity = (moveDir * 45) + Vector3.new(0, 5, 0)
                ball.AssemblyAngularVelocity = Vector3.new(0, 0, 0) -- Stops the spin
            end
        end
    end
end)

Window:SelectTab(1)

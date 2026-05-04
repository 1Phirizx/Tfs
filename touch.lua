local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local RunService = game:GetService("RunService")
local lp = game.Players.LocalPlayer

-- Configuration
local reachDistance = 26
local isEnabled = false
local ballName = "Football"

-- UI
local Window = Fluent:CreateWindow({
    Title = "Touch Football | ELITE",
    SubTitle = "Priority Logic",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Theme = "Dark"
})

local Tabs = { Main = Window:AddTab({ Title = "Settings", Icon = "shield" }) }

Tabs.Main:AddInput("ReachInput", {
    Title = "Reach Range",
    Default = "26",
    Numeric = true,
    Callback = function(Value) reachDistance = tonumber(Value) or 26 end
})

Tabs.Main:AddToggle("ReachToggle", {
    Title = "Enable Elite Reach",
    Default = false,
    Callback = function(Value) isEnabled = Value end
})

-- High Priority Execution
-- Using PreSimulation to run BEFORE the physics engine solves collisions
RunService.PreSimulation:Connect(function()
    if not isEnabled then return end
    
    local char = lp.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local ball = workspace:FindFirstChild(ballName) or workspace.Terrain:FindFirstChild(ballName)
    
    if root and ball and ball:IsA("BasePart") then
        local mag = (root.Position - ball.Position).Magnitude
        
        if mag <= reachDistance then
            -- Directional Vector for accurate hitting
            local hitDir = root.CFrame.LookVector
            local force = (hitDir * 65) + Vector3.new(0, 20, 0)
            
            -- ApplyImpulse is more reliable than setting Velocity directly
            ball:ApplyImpulse(force)
        end
    end
end)

Window:SelectTab(1)

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Touch Football | ELITE V5",
    SubTitle = "Prediction & Domain",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Theme = "Dark"
})

local Tabs = { Main = Window:AddTab({ Title = "Main", Icon = "target" }) }

local reachDistance = 25
local isReachActive = false
local ballName = "Football"
local lp = game.Players.LocalPlayer

local function touchLogic()
    if isReachActive and lp.Character then
        local ball = workspace:FindFirstChild(ballName)
        local char = lp.Character
        local root = char:FindFirstChild("HumanoidRootPart")
        
        if ball and root and ball:IsA("BasePart") then
            local velocity = ball.Velocity
            local predictedPos = ball.Position + (velocity * 0.15)
            local dist = (root.Position - predictedPos).Magnitude
            
            if dist <= reachDistance then
                pcall(function()
                    local parts = {
                        char:FindFirstChild("Right Foot"),
                        char:FindFirstChild("Left Foot"),
                        char:FindFirstChild("HumanoidRootPart")
                    }
                    
                    for i = 1, 35 do
                        for _, part in pairs(parts) do
                            if part then
                                firetouchinterest(part, ball, 0)
                                firetouchinterest(part, ball, 1)
                            end
                        end
                    end
                end)
            end
        end
    end
end

game:GetService("RunService").Heartbeat:Connect(touchLogic)
game:GetService("RunService").RenderStepped:Connect(touchLogic)

Tabs.Main:AddInput("ReachInput", {
    Title = "Reach Distance",
    Default = "25",
    Numeric = true,
    Finished = true,
    Callback = function(Value)
        local num = tonumber(Value)
        if num then reachDistance = num end
    end
})

Tabs.Main:AddToggle("ReachToggle", {
    Title = "Enable Anti-Pass System",
    Default = false,
    Callback = function(Value)
        isReachActive = Value
    end
})

Window:SelectTab(1)

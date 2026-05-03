local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Touch Football | God Mode",
    SubTitle = "Total Domain System",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Theme = "Dark"
})

local Tabs = { Main = Window:AddTab({ Title = "Main", Icon = "target" }) }

local reachDistance = 35
local isReachActive = false
local targetBall = "Football"
local lp = game.Players.LocalPlayer

local function masterTouch()
    if isReachActive and lp.Character then
        local ball = workspace:FindFirstChild(targetBall)
        local root = lp.Character:FindFirstChild("HumanoidRootPart")
        
        if ball and root and ball:IsA("BasePart") then
            local mag = (root.Position - ball.Position).Magnitude
            if mag <= reachDistance then
                pcall(function()
                    local rFoot = lp.Character["Right Foot"]
                    local lFoot = lp.Character["Left Foot"]
                    
                    -- Triple-layer touch injection for total domain
                    for i = 1, 8 do
                        firetouchinterest(rFoot, ball, 0)
                        firetouchinterest(rFoot, ball, 1)
                        firetouchinterest(lFoot, ball, 0)
                        firetouchinterest(lFoot, ball, 1)
                    end
                end)
            end
        end
    end
end

-- Extreme priority execution
game:GetService("RunService").Stepped:Connect(masterTouch)
game:GetService("RunService").Heartbeat:Connect(masterTouch)

Tabs.Main:AddInput("ReachInput", {
    Title = "High-Scale Reach Distance",
    Default = "35",
    Numeric = true,
    Finished = true,
    Callback = function(Value)
        local num = tonumber(Value)
        if num then reachDistance = num end
    end
})

Tabs.Main:AddToggle("ReachToggle", {
    Title = "Activate Total Domain",
    Default = false,
    Callback = function(Value) isReachActive = Value end
})

Window:SelectTab(1)

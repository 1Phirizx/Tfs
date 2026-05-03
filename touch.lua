local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Touch Football | ELITE X",
    SubTitle = "Maximum Power Mode",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Theme = "Dark"
})

local Tabs = { Main = Window:AddTab({ Title = "Main", Icon = "target" }) }

local reachDistance = 15
local isReachActive = false
local targetBall = "Football"
local lp = game.Players.LocalPlayer

local function powerTouch()
    if isReachActive and lp.Character then
        local ball = workspace:FindFirstChild(targetBall)
        local char = lp.Character
        local root = char:FindFirstChild("HumanoidRootPart")
        
        if ball and root and ball:IsA("BasePart") then
            local mag = (root.Position - ball.Position).Magnitude
            
            if mag <= reachDistance then
                pcall(function()
                    local rFoot = char:FindFirstChild("Right Foot")
                    local lFoot = char:FindFirstChild("Left Foot")
                    
                    for i = 1, 50 do
                        if rFoot then
                            firetouchinterest(rFoot, ball, 0)
                            firetouchinterest(rFoot, ball, 1)
                        end
                        if lFoot then
                            firetouchinterest(lFoot, ball, 0)
                            firetouchinterest(lFoot, ball, 1)
                        end
                        firetouchinterest(root, ball, 0)
                        firetouchinterest(root, ball, 1)
                    end
                end)
            end
        end
    end
end

game:GetService("RunService").RenderStepped:Connect(powerTouch)
game:GetService("RunService").Heartbeat:Connect(powerTouch)

Tabs.Main:AddInput("ReachInput", {
    Title = "Reach Power",
    Default = "15",
    Numeric = true,
    Finished = true,
    Callback = function(Value)
        local num = tonumber(Value)
        if num then reachDistance = num end
    end
})

Tabs.Main:AddToggle("ReachToggle", {
    Title = "Enable Overpower Reach",
    Default = false,
    Callback = function(Value) isReachActive = Value end
})

Window:SelectTab(1)

llocal Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Touch Football | FORCE",
    SubTitle = "No Limits",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Theme = "Dark"
})

local Tabs = { Main = Window:AddTab({ Title = "Main", Icon = "target" }) }

local reachDistance = 45
local isReachActive = false
local ballName = "Football"
local lp = game.Players.LocalPlayer

local function getBall()
    return workspace:FindFirstChild(ballName) or workspace.Terrain:FindFirstChild(ballName)
end

task.spawn(function()
    game:GetService("RunService").PostSimulation:Connect(function()
        if isReachActive and lp.Character then
            local ball = getBall()
            local char = lp.Character
            local root = char:FindFirstChild("HumanoidRootPart")
            
            if ball and root and ball:IsA("BasePart") then
                local mag = (root.Position - ball.Position).Magnitude
                
                if mag <= reachDistance then
                    pcall(function()
                        local parts = {
                            char:FindFirstChild("Right Foot"),
                            char:FindFirstChild("Left Foot"),
                            char:FindFirstChild("Right Lower Leg"),
                            char:FindFirstChild("Left Lower Leg"),
                            root
                        }

                        for i = 1, 20 do
                            for _, p in pairs(parts) do
                                if p then
                                    firetouchinterest(p, ball, 0)
                                    firetouchinterest(p, ball, 1)
                                end
                            end
                        end
                    end)
                end
            end
        end
    end)
end)

Tabs.Main:AddInput("ReachInput", {
    Title = "Reach Distance",
    Default = "45",
    Numeric = true,
    Finished = true,
    Callback = function(Value)
        local num = tonumber(Value)
        if num then reachDistance = num end
    end
})

Tabs.Main:AddToggle("ReachToggle", {
    Title = "Activate",
    Default = false,
    Callback = function(Value)
        isReachActive = Value
    end
})

Window:SelectTab(1)

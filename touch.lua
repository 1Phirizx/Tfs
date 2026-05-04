local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Touch Football | FORCE",
    SubTitle = "Open Source Edition",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Theme = "Dark"
})

local Tabs = { Main = Window:AddTab({ Title = "Main", Icon = "target" }) }

local reachDistance = 26
local isReachActive = false
local ballName = "Football"
local lp = game.Players.LocalPlayer

local function getBall()
    return workspace:FindFirstChild(ballName) or workspace.Terrain:FindFirstChild(ballName)
end

task.spawn(function()
    local RunService = game:GetService("RunService")
    
    RunService.Heartbeat:Connect(function()
        if isReachActive and lp.Character then
            local ball = getBall()
            local char = lp.Character
            local root = char:FindFirstChild("HumanoidRootPart")
            
            if ball and root and ball:IsA("BasePart") then
                -- Prediction logic to compensate for latency
                local predictedPosition = ball.Position + (ball.AssemblyLinearVelocity * 0.1)
                
                -- Maximum safe distance constraint (Safety Lock: 26)
                local currentDistance = (root.Position - predictedPosition).Magnitude
                local safeReach = math.min(reachDistance, 26)

                if currentDistance <= safeReach then
                    pcall(function()
                        local contactParts = {
                            char:FindFirstChild("Right Foot"),
                            char:FindFirstChild("Left Foot"),
                            root
                        }

                        for _, part in pairs(contactParts) do
                            if part then
                                firetouchinterest(ball, part, 0)
                                firetouchinterest(ball, part, 1)
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
    Default = "26",
    Numeric = true,
    Finished = true,
    Callback = function(Value)
        local num = tonumber(Value)
        if num then reachDistance = num end
    end
})

Tabs.Main:AddToggle("ReachToggle", {
    Title = "Active Status",
    Default = false,
    Callback = function(Value)
        isReachActive = Value
    end
})

Window:SelectTab(1)

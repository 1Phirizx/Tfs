local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Touch Football | FORCE",
    SubTitle = "VNG Edition | 80ms Optimized",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Theme = "Dark"
})

local Tabs = { Main = Window:AddTab({ Title = "Main", Icon = "target" }) }

local reachDistance = 26
local isReachActive = false
local ballName = "Football"
local lp = game.Players.LocalPlayer
local statsService = game:GetService("Stats")
local runService = game:GetService("RunService")

local function getBall()
    return workspace:FindFirstChild(ballName) or workspace.Terrain:FindFirstChild(ballName)
end

task.spawn(function()
    runService.Stepped:Connect(function()
        if not isReachActive then return end
        
        local char = lp.Character
        if not char then return end
        
        local root = char:FindFirstChild("HumanoidRootPart")
        local ball = getBall()
        
        if ball and root then
            local ping = statsService.Network.ServerStatsItem["Data Ping"]:GetValue()
            -- Adjusted prediction for 80ms (Lower factor for better close-range control)
            local prediction = math.clamp(ping / 1000, 0.02, 0.12)
            
            local ballPos = ball.Position
            local predictedPos = ballPos + (ball.AssemblyLinearVelocity * prediction)
            
            -- We check distance for both actual and predicted position
            local distActual = (root.Position - ballPos).Magnitude
            local distPredicted = (root.Position - predictedPos).Magnitude
            
            local limit = math.min(reachDistance, 26)

            -- The "Anti-Counter" Logic: Triggers if either position is within reach
            if distActual <= limit or distPredicted <= limit then
                local contactParts = {root}
                
                -- Add feet only if close to save CPU on weak devices
                if distActual < 15 then
                    table.insert(contactParts, char:FindFirstChild("Right Foot"))
                    table.insert(contactParts, char:FindFirstChild("Left Foot"))
                end

                for _, part in pairs(contactParts) do
                    if part then
                        firetouchinterest(ball, part, 0)
                        firetouchinterest(ball, part, 1)
                    end
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

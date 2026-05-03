local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Touch Football | TURBO ELITE",
    SubTitle = "Extreme Priority & No Limits",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Theme = "Dark"
})

local Tabs = { Main = Window:AddTab({ Title = "Main", Icon = "target" }) }

local reachDistance = 35
local isReachActive = false
local ballName = "Football"
local lp = game.Players.LocalPlayer

local function getBall()
    return workspace:FindFirstChild(ballName) or workspace.Terrain:FindFirstChild(ballName)
end

task.spawn(function()
    game:GetService("RunService").Heartbeat:Connect(function()
        if isReachActive and lp.Character then
            local ball = getBall()
            local char = lp.Character
            local root = char:FindFirstChild("HumanoidRootPart")
            
            if ball and root and ball:IsA("BasePart") then
                local mag = (root.Position - ball.Position).Magnitude
                
                if mag <= reachDistance then
                    pcall(function()
                        -- Lista expandida para garantir que NAO pegue apenas nos pes
                        local bodyParts = {
                            char:FindFirstChild("Right Foot"),
                            char:FindFirstChild("Left Foot"),
                            char:FindFirstChild("Right Lower Leg"),
                            char:FindFirstChild("Left Lower Leg"),
                            char:FindFirstChild("Right Upper Leg"),
                            char:FindFirstChild("Left Upper Leg"),
                            root -- Centro de massa (tronco)
                        }
                        
                        -- MULTIPLICADOR TURBO: 60 disparos por frame
                        -- Isso satura a prioridade de rede do Delta
                        for i = 1, 60 do
                            for _, part in pairs(bodyParts) do
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
    end)
end)

Tabs.Main:AddInput("ReachInput", {
    Title = "Turbo Reach Power (No Limit)",
    Default = "35",
    Numeric = true,
    Finished = true,
    Callback = function(Value)
        local num = tonumber(Value)
        if num then 
            reachDistance = num 
            Fluent:Notify({
                Title = "Turbo Active",
                Content = "Current Scale: " .. reachDistance,
                Duration = 2
            })
        end
    end
})

Tabs.Main:AddToggle("ReachToggle", {
    Title = "Enable Turbo Priority",
    Default = false,
    Callback = function(Value)
        isReachActive = Value
    end
})

Window:SelectTab(1)

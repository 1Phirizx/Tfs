local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Touch Football | Lux Style",
    SubTitle = "God Priority System",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Theme = "Dark"
})

local Tabs = { Main = Window:AddTab({ Title = "Main", Icon = "target" }) }

local reachDistance = 20
local isReachActive = false
local targetBall = "Football"
local lp = game.Players.LocalPlayer

task.spawn(function()
    while true do
        game:GetService("RunService").RenderStepped:Wait()
        
        if isReachActive and lp.Character then
            local ball = workspace:FindFirstChild(targetBall)
            local root = lp.Character:FindFirstChild("HumanoidRootPart")
            
            if ball and root and ball:IsA("BasePart") then
                local mag = (root.Position - ball.Position).Magnitude
                
                if mag <= reachDistance then
                    for _ = 1, 10 do 
                        pcall(function()
                            local character = lp.Character
                            local rFoot = character["Right Foot"]
                            local lFoot = character["Left Foot"]
                            
                            firetouchinterest(rFoot, ball, 0)
                            firetouchinterest(rFoot, ball, 1)
                            firetouchinterest(lFoot, ball, 0)
                            firetouchinterest(lFoot, ball, 1)
                        end)
                    end
                end
            end
        end
    end
end)

Tabs.Main:AddInput("ReachInput", {
    Title = "Aggressive Reach Distance",
    Default = "20",
    Numeric = true,
    Finished = true,
    Callback = function(Value)
        local num = tonumber(Value)
        if num then
            reachDistance = num
            Fluent:Notify({
                Title = "Priority Set",
                Content = "Distance: " .. reachDistance,
                Duration = 2
            })
        end
    end
})

Tabs.Main:AddToggle("ReachToggle", {
    Title = "Enable God Mode Reach",
    Default = false,
    Callback = function(Value)
        isReachActive = Value
    end
})

Window:SelectTab(1)

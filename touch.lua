local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Touch Football | Lux Style",
    SubTitle = "Elite Priority System",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Theme = "Dark"
})

local Tabs = { 
    Main = Window:AddTab({ Title = "Main", Icon = "target" }) 
}

local reachDistance = 15
local isReachActive = false
local targetBall = "Football"
local lp = game.Players.LocalPlayer

task.spawn(function()
    while true do
        game:GetService("RunService").Heartbeat:Wait() 
        
        if isReachActive and lp.Character then
            local root = lp.Character:FindFirstChild("HumanoidRootPart")
            local ball = workspace:FindFirstChild(targetBall)
            
            if root and ball and ball:IsA("BasePart") then
                local mag = (root.Position - ball.Position).Magnitude
                if mag <= reachDistance then
                    for i = 1, 5 do 
                        pcall(function()
                            local char = lp.Character
                            firetouchinterest(char["Right Foot"], ball, 0)
                            firetouchinterest(char["Right Foot"], ball, 1)
                            firetouchinterest(char["Left Foot"], ball, 0)
                            firetouchinterest(char["Left Foot"], ball, 1)
                        end)
                    end
                end
            end
        end
    end
end)

Tabs.Main:AddInput("ReachInput", {
    Title = "Reach Distance",
    Description = "Set distance to kick before others",
    Default = "15",
    Numeric = true,
    Finished = true,
    Callback = function(Value)
        local num = tonumber(Value)
        if num then
            reachDistance = num
            Fluent:Notify({
                Title = "Reach System",
                Content = "Priority Distance set to: " .. reachDistance,
                Duration = 3
            })
        end
    end
})

Tabs.Main:AddToggle("ReachToggle", {
    Title = "Enable Priority Reach",
    Default = false,
    Callback = function(Value)
        isReachActive = Value
    end
})

Window:SelectTab(1)

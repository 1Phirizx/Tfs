local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Touch Football | Lux Style",
    SubTitle = "Magnitude Reach System",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Theme = "Dark"
})

local Tabs = { Main = Window:AddTab({ Title = "Reach", Icon = "target" }) }

local reachDistance = 10
local isReachActive = false
local ballName = "Football"
local player = game.Players.LocalPlayer

task.spawn(function()
    while task.wait() do
        if isReachActive and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local ball = workspace:FindFirstChild(ballName)
            if ball and ball:IsA("BasePart") then
                local distance = (player.Character.HumanoidRootPart.Position - ball.Position).Magnitude
                if distance <= reachDistance then
                    firetouchinterest(player.Character["Right Foot"], ball, 0)
                    firetouchinterest(player.Character["Right Foot"], ball, 1)
                    firetouchinterest(player.Character["Left Foot"], ball, 0)
                    firetouchinterest(player.Character["Left Foot"], ball, 1)
                end
            end
        end
    end
end)

Tabs.Main:AddInput("ReachInput", {
    Title = "Reach Magnitude (1-30)",
    Default = "10",
    Numeric = true,
    Finished = true,
    Callback = function(Value)
        local num = tonumber(Value)
        if num then
            reachDistance = math.clamp(num, 1, 30)
            Fluent:Notify({Title = "Reach", Content = "Distancia definida para: " .. reachDistance})
        end
    end
})

Tabs.Main:AddToggle("ReachToggle", {
    Title = "Ativar Magnitude Reach",
    Default = false,
    Callback = function(Value)
        isReachActive = Value
    end
})

Window:SelectTab(1)

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local RunService = game:GetService("RunService")
local lp = game.Players.LocalPlayer

local reachDistance = 25
local isEnabled = false

-- AUTOMATIC BALL FINDER (English Only)
local function getBall()
    local primary = workspace:FindFirstChild("Football") or workspace:FindFirstChild("Ball") or workspace.Terrain:FindFirstChild("Football")
    if primary then return primary end
    
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local nameLower = obj.Name:lower()
            if nameLower:find("foot") or nameLower:find("ball") then
                return obj
            end
        end
    end
    return nil
end

local Window = Fluent:CreateWindow({
    Title = "Touch Football | FORCE V6",
    SubTitle = "Lux Bypass Edition",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Theme = "Dark"
})

local Tabs = { Main = Window:AddTab({ Title = "Main", Icon = "zap" }) }

Tabs.Main:AddToggle("ReachToggle", {
    Title = "Enable Lux-Style Reach",
    Default = false,
    Callback = function(Value) isEnabled = Value end
})

Tabs.Main:AddSlider("ReachSlider", {
    Title = "Reach Distance",
    Description = "Bypass hitbox multiplier",
    Default = 25, Min = 5, Max = 45, Rounding = 1,
    Callback = function(Value) reachDistance = Value end
})

-- LUX HUB ENGINE (PostSimulation Spoofing)
RunService.PostSimulation:Connect(function()
    if not isEnabled then return end
    
    local char = lp.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local ball = getBall()
    local leg = char and (char:FindFirstChild("RightFoot") or char:FindFirstChild("Right Leg") or char:FindFirstChild("LeftFoot"))
    
    if root and ball and ball:IsA("BasePart") and leg then
        local distance = (root.Position - ball.Position).Magnitude
        
        if distance <= reachDistance then
            -- Guarda a posição real da perna
            local oldCFrame = leg.CFrame
            
            -- Teleporta a perna para a bola para o servidor validar o toque
            leg.CFrame = ball.CFrame
            
            firetouchinterest(ball, leg, 0)
            
            local lookDir = root.CFrame.LookVector
            
            -- Injeta velocidade direta na rede da bola
            if distance < 10 then
                ball.AssemblyLinearVelocity = (lookDir * 60) + Vector3.new(0, 15, 0)
            else
                ball.AssemblyLinearVelocity = (lookDir * 75) + Vector3.new(0, 20, 0)
            end
            
            firetouchinterest(ball, leg, 1)
            
            -- Devolve a perna instantaneamente
            leg.CFrame = oldCFrame
        end
    end
end)

Window:SelectTab(1)

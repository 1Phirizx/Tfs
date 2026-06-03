local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local RunService = game:GetService("RunService")
local lp = game.Players.LocalPlayer

local reachDistance = 25
local isEnabled = false
local lastShot = 0 -- Controla o delay entre os processamentos

-- AUTOMATIC BALL FINDER (Optimized)
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
    SubTitle = "Anti-Lag Bypass",
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

-- LUX HUB ENGINE (Optimized & Slower Rate to prevent FPS drops)
RunService.PostSimulation:Connect(function()
    if not isEnabled then return end
    
    -- Só roda a checagem pesada se passou um intervalo mínimo (Evita travar o processador)
    if os.clock() - lastShot < 0.03 then return end
    
    local char = lp.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local ball = getBall()
    local leg = char and (char:FindFirstChild("RightFoot") or char:FindFirstChild("Right Leg") or char:FindFirstChild("LeftFoot"))
    
    if root and ball and ball:IsA("BasePart") and leg then
        local distance = (root.Position - ball.Position).Magnitude
        
        if distance <= reachDistance then
            lastShot = os.clock() -- Registra o momento do chute
            
            -- Armazena CFrame original de forma limpa
            local oldCFrame = leg.CFrame
            
            -- Teleporte ultra-rápido apenas no frame de disparo
            leg.CFrame = ball.CFrame
            firetouchinterest(ball, leg, 0)
            
            local lookDir = root.CFrame.LookVector
            
            -- Aplica a velocidade sem sobrecarregar a rede do jogo
            if distance < 10 then
                ball.AssemblyLinearVelocity = (lookDir * 55) + Vector3.new(0, 15, 0)
            else
                ball.AssemblyLinearVelocity = (lookDir * 70) + Vector3.new(0, 20, 0)
            end
            
            firetouchinterest(ball, leg, 1)
            
            -- Retorno imediato
            leg.CFrame = oldCFrame
        end
    end
end)

Window:SelectTab(1)

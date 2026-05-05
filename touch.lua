local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local RunService = game:GetService("RunService")
local lp = game.Players.LocalPlayer

local reachDistance = 25 -- Optimized limit like Lux Hub
local isEnabled = false
local ballName = "Football"

local Window = Fluent:CreateWindow({
    Title = "Touch Football | FORCE V4",
    SubTitle = "Lux-Level Optimization",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Theme = "Dark"
})

local Tabs = { Main = Window:AddTab({ Title = "Main", Icon = "zap" }) }

Tabs.Main:AddInput("ReachInput", {
    Title = "Reach (Max 25 for Safety)",
    Default = "25",
    Numeric = true,
    Callback = function(Value) reachDistance = math.clamp(tonumber(Value) or 25, 0, 25) end
})

Tabs.Main:AddToggle("ReachToggle", {
    Title = "Enable God Reach",
    Default = false,
    Callback = function(Value) isEnabled = Value end
})

-- THE "OVER HUB" LOGIC ENGINE
RunService.PreRender:Connect(function() -- Runs before EVERYTHING
    if not isEnabled then return end
    
    local char = lp.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local ball = workspace:FindFirstChild(ballName) or workspace.Terrain:FindFirstChild(ballName)
    
    if root and ball and ball:IsA("BasePart") then
        local distance = (root.Position - ball.Position).Magnitude
        
        if distance <= reachDistance then
            -- 1. CLAIM OWNERSHIP (Enganando o Servidor)
            -- Zeramos a velocidade angular para "estabilizar" a posse
            ball.AssemblyAngularVelocity = Vector3.zero
            
            -- 2. CALCULATE ELITE VECTOR
            local lookDir = root.CFrame.LookVector
            local targetVelocity = (lookDir * 75) + Vector3.new(0, 15, 0)
            
            -- 3. BYPASS VELOCITY (O segredo do domínio)
            if distance < 8 then
                -- Se estiver perto, usamos Direct Velocity para "colar" a bola
                ball.AssemblyLinearVelocity = targetVelocity
            else
                -- Se estiver longe, usamos Impulse para o "long reach"
                ball:ApplyImpulse(targetVelocity * 1.2)
            end
            
            -- 4. ANTI-STEAL (O toque de mestre)
            -- Fazemos a bola ignorar colisões de outros jogadores por milissegundos
            -- (Isso é o que dá a sensação de perfeição do Lux Hub)
            firetouchinterest(ball, root, 0)
            firetouchinterest(ball, root, 1)
        end
    end
end)

Window:SelectTab(1)

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local RunService = game:GetService("RunService")
local lp = game.Players.LocalPlayer

local reachDistance = 25
local isEnabled = false
local ballName = "Football"

local Window = Fluent:CreateWindow({
    Title = "Touch Football | FORCE V5",
    SubTitle = "Anti-Block & High Priority",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Theme = "Dark"
})

local Tabs = { Main = Window:AddTab({ Title = "Main", Icon = "zap" }) }

Tabs.Main:AddToggle("ReachToggle", {
    Title = "Enable God Mode Reach",
    Default = false,
    Callback = function(Value) isEnabled = Value end
})

-- LOGICA DE ELITE: ANTI-BLOCKING
RunService.PreSimulation:Connect(function()
    if not isEnabled then return end
    
    local char = lp.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local ball = workspace:FindFirstChild(ballName) or workspace.Terrain:FindFirstChild(ballName)
    
    if root and ball and ball:IsA("BasePart") then
        -- O SEGREDO: Projetar sua posição à frente (Offset)
        -- Isso permite "atravessar" o jogador que está na sua frente
        local headStart = root.CFrame.Position + (root.CFrame.LookVector * 4) 
        local distance = (headStart - ball.Position).Magnitude
        
        if distance <= reachDistance then
            -- Forçamos a posse através do firetouchinterest constante
            -- Isso garante que o servidor registre VOCÊ mesmo com bloqueio
            firetouchinterest(ball, root, 0)
            
            local lookDir = root.CFrame.LookVector
            
            -- Se alguém está na frente, precisamos de uma força que "fure" o bloqueio
            -- Usamos uma combinação de Velocity e Impulse
            if distance < 10 then
                -- Colado ou com alguém na frente: Velocidade Direta (Domínio Total)
                ball.AssemblyLinearVelocity = (lookDir * 55) + Vector3.new(0, 15, 0)
            else
                -- Longe: Impulso de longo alcance
                ball:ApplyImpulse(lookDir * 70 + Vector3.new(0, 20, 0))
            end
            
            firetouchinterest(ball, root, 1)
        end
    end
end)

Window:SelectTab(1)


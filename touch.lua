local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local RunService = game:GetService("RunService")
local lp = game.Players.LocalPlayer

local reachDistance = 25
local isEnabled = false

-- SISTEMA INTELIGENTE DE BUSCA (Fura atualizações de nome)
local function getBall()
    -- 1. Tenta achar pelos nomes clássicos
    local common = workspace:FindFirstChild("Football") or workspace:FindFirstChild("Ball") or workspace.Terrain:FindFirstChild("Football")
    if common then return common end
    
    -- 2. Se mudaram de pasta ou nome, procura por propriedades físicas de uma bola de futebol
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name:lower():find("foot") or obj.Name:lower():find("ball")) then
            -- Se for uma esfera ou tiver formato de bola, encontramos!
            if obj.Shape == Enum.PartType.Ball or obj:FindFirstChildOfClass("SpecialMesh") then
                return obj
            end
        end
    end
    return nil
end

local Window = Fluent:CreateWindow({
    Title = "Touch Football | FORCE V5 .REV",
    SubTitle = "Anti-Block & Anti-Update",
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

-- Mantendo seu PreSimulation de alta prioridade
RunService.PreSimulation:Connect(function()
    if not isEnabled then return end
    
    local char = lp.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    
    -- Usando o buscador inteligente automático
    local ball = getBall()
    
    if root and ball and ball:IsA("BasePart") then
        -- Sua lógica brilhante de Offset (Garante o chute mesmo bloqueado)
        local headStart = root.CFrame.Position + (root.CFrame.LookVector * 4) 
        local distance = (headStart - ball.Position).Magnitude
        
        if distance <= reachDistance then
            -- ALTERAÇÃO PRO: Envia o toque para a perna ou para o Root se o jogo exigir
            local touchPart = char:FindFirstChild("RightFoot") or char:FindFirstChild("Right Leg") or root
            
            -- Simula o toque fisicamente
            firetouchinterest(ball, touchPart, 0)
            
            local lookDir = root.CFrame.LookVector
            
            -- Sua lógica de força dividida por distância (Velocidade vs Impulso)
            if distance < 10 then
                -- Colado: Velocidade Direta para furar a zaga
                ball.AssemblyLinearVelocity = (lookDir * 55) + Vector3.new(0, 15, 0)
            else
                -- Longe: Impulso perfeito
                ball:ApplyImpulse(lookDir * 70 + Vector3.new(0, 20, 0))
            end
            
            -- Um pequeno delay imperceptível antes de desligar o toque evita que o servidor anule a física
            task.spawn(function()
                RunService.Heartbeat:Wait()
                if ball and touchPart then
                    firetouchinterest(ball, touchPart, 1)
                end
            end)
        end
    end
end)

Window:SelectTab(1)

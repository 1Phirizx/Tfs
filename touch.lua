local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local RunService = game:GetService("RunService")
local lp = game.Players.LocalPlayer

local reachDistance = 25
local isEnabled = false
local lastShot = 0 -- Evita o spam que causa o travamento

-- BUSCADOR AUTOMÁTICO (Caso mudem o nome da bola na atualização)
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
    Title = "Touch Football | FORCE V5 .PRO",
    SubTitle = "Anti-Block & Anti-Lag",
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

-- Alterado para Slider para dar mais controle profissional
Tabs.Main:AddSlider("ReachSlider", {
    Title = "Reach Distance",
    Description = "Alcance adaptativo preditivo",
    Default = 25, Min = 5, Max = 45, Rounding = 1,
    Callback = function(Value) reachDistance = Value end
})

-- Usando PostSimulation para garantir o Network Ownership da bola igual ao Lux
RunService.PostSimulation:Connect(function()
    if not isEnabled then return end
    
    -- CONTROLE DE LAG: Só processa a física em intervalos seguros (Micro-debounce)
    if os.clock() - lastShot < 0.02 then return end
    
    local char = lp.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local ball = getBall()
    -- SEGREDO: Usar a perna em vez do RootPart fura o anti-cheat de toque de longe
    local leg = char and (char:FindFirstChild("RightFoot") or char:FindFirstChild("Right Leg") or char:FindFirstChild("LeftFoot"))
    
    if root and ball and ball:IsA("BasePart") and leg then
        -- Sua lógica original de Offset projetado para frente (Excelente contra bloqueios)
        local headStart = root.CFrame.Position + (root.CFrame.LookVector * 4) 
        local distance = (headStart - ball.Position).Magnitude
        
        if distance <= reachDistance then
            lastShot = os.clock() -- Reseta o temporizador anti-lag
            
            -- Armazena a posição real da perna para o spoofing
            local oldCFrame = leg.CFrame
            
            -- Teleporta a perna instantaneamente na bola para o servidor validar
            leg.CFrame = ball.CFrame
            firetouchinterest(ball, leg, 0)
            
            local lookDir = root.CFrame.LookVector
            
            -- INTERAÇÃO DE FORÇA LIMPA (Substituído o Impulse por Velocity direto, que não buga a rede)
            if distance < 10 then
                ball.AssemblyLinearVelocity = (lookDir * 55) + Vector3.new(0, 15, 0)
            else
                ball.AssemblyLinearVelocity = (lookDir * 70) + Vector3.new(0, 18, 0)
            end
            
            firetouchinterest(ball, leg, 1)
            
            -- Retorna a perna antes que o jogo renderize visualmente
            leg.CFrame = oldCFrame
        end
    end
end)

Window:SelectTab(1)

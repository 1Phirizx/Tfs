local RedzLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/REDZDEVS/REDZSERVERS/main/redzui"))()
local RunService = game:GetService("RunService")
local lp = game.Players.LocalPlayer

local reachDistance = 25
local isEnabled = false

-- AUTOMATIC BALL FINDER
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

local Window = RedzLib:MakeWindow({
    Title = "Touch Football | FORCE V6",
    SubTitle = "Lux Bypass Edition",
    SaveConfig = true,
    ConfigFolder = "TouchFootballForce"
})

local MainTab = Window:MakeTab({"Main", "zap"})

MainTab:AddToggle({
    Name = "Enable Lux-Style Reach",
    Default = false,
    Callback = function(Value) isEnabled = Value end
})

MainTab:AddSlider({
    Name = "Reach Distance",
    Min = 5, Max = 45, Default = 25, Increase = 1,
    Callback = function(Value) reachDistance = tonumber(Value) or 25 end
})

-- MÉTODO LUX HUB: Simulação Física por Interpolação de Posição
RunService.PostSimulation:Connect(function()
    if not isEnabled then return end
    
    local char = lp.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local ball = getBall()
    
    -- Detecta a perna do seu personagem (R15 ou R6)
    local leg = char and (char:FindFirstChild("RightFoot") or char:FindFirstChild("Right Leg") or char:FindFirstChild("LeftFoot"))
    
    if root and ball and ball:IsA("BasePart") and leg then
        -- Calcula a distância real até a bola
        local distance = (root.Position - ball.Position).Magnitude
        
        if distance <= reachDistance then
            -- SEGREDO DOS HUBS: Estender o Hitbox da perna em direção à bola no frame exato da simulação
            -- Isso faz o Servidor registrar um toque legítimo do seu personagem
            local oldCFrame = leg.CFrame
            
            -- Move temporariamente a perna para a posição da bola
            leg.CFrame = ball.CFrame
            
            -- Dispara o interesse físico e a velocidade na direção que você está olhando
            firetouchinterest(ball, leg, 0)
            
            local lookDir = root.CFrame.LookVector
            
            -- Força injetada direto na rede da bola (Ignora bloqueios locais)
            if distance < 10 then
                ball.AssemblyLinearVelocity = (lookDir * 60) + Vector3.new(0, 15, 0)
            else
                ball.AssemblyLinearVelocity = (lookDir * 75) + Vector3.new(0, 20, 0)
            end
            
            firetouchinterest(ball, leg, 1)
            
            -- Devolve a perna para a posição original instantaneamente para ninguém ver você esticado
            leg.CFrame = oldCFrame
        end
    end
end)

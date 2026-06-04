-- [[ CORE ENGINE (ADAPTIVE PHYSICS OVERRIDE) ]]
RunService.PostSimulation:Connect(function()
    local char = lp.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local ball = getBall()
    local leg = char and (char:FindFirstChild("RightFoot") or char:FindFirstChild("Right Leg") or char:FindFirstChild("LeftFoot"))
    
    -- Update 3D Visualizer Sphere Position
    if _G_CONFIG.visualizer and root and _G_CONFIG.isEnabled then
        VisualSphere.Adornee = root
    else
        VisualSphere.Adornee = nil
    end

    if not _G_CONFIG.isEnabled then return end
    if os.clock() - lastShot < 0.015 then return end -- Reduzido delay para resposta instantânea de perto

    if root and ball and ball:IsA("BasePart") and leg then
        -- HUMANIZER (Jitter Reach)
        local jitter = math.random(-8, 8) * 0.1
        local adaptiveReach = _G_CONFIG.reachDistance + jitter
        
        -- Sua lógica de Offset avançada
        local headStart = root.CFrame.Position + (root.CFrame.LookVector * 4) 
        local distance = (headStart - ball.Position).Magnitude
        local realDistance = (root.Position - ball.Position).Magnitude -- Distância real do corpo até a bola
        
        if distance <= adaptiveReach and hasLineOfSight(root, ball) then
            lastShot = os.clock()
            
            local lookDir = root.CFrame.LookVector
            
            -- [[ SISTEMA ADAPTATIVO: DISTÂNCIA CRÍTICA (DE PERTO) ]]
            if realDistance < 10 then
                -- Se você está colado ou devagar, usamos Injeção Direta + Força de Torque
                -- Isso evita que a bola fique presa no seu boneco e fura qualquer bloqueio
                firetouchinterest(ball, leg, 0)
                
                -- Multiplica a força de perto para compensar a falta de velocidade do jogador
                local closePower = _G_CONFIG.power * 1.15
                ball.AssemblyLinearVelocity = (lookDir * closePower) + Vector3.new(0, _G_CONFIG.lift * 0.9, 0)
                ball.AssemblyAngularVelocity = lookDir * 10 -- Adiciona rotação para a bola "desgrudar" do corpo
                
                firetouchinterest(ball, leg, 1)
            else
                -- [[ SISTEMA ADAPTATIVO: LONGO ALCANCE (DE LONGE) ]]
                -- Mantém o CFrame Spoofing agressivo estilo Lux Hub que você gostou
                local oldCFrame = leg.CFrame
                leg.CFrame = ball.CFrame
                
                firetouchinterest(ball, leg, 0)
                
                ball.AssemblyLinearVelocity = (lookDir * _G_CONFIG.power) + Vector3.new(0, _G_CONFIG.lift, 0)
                
                firetouchinterest(ball, leg, 1)
                leg.CFrame = oldCFrame
            end
        end
    end
end)

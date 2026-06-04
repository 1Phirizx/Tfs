-- [[ CORE ENGINE (UNIFIED AGGRESSIVE PHYSICS - FULL BYPASS) ]]
RunService.PreSimulation:Connect(function()
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
    if os.clock() - lastShot < 0.012 then return end -- Ultra-fast response time for instant dynamic hits

    if root and ball and ball:IsA("BasePart") and leg then
        -- HUMANIZER (Subtle Jitter Reach)
        local jitter = math.random(-5, 5) * 0.1
        local adaptiveReach = _G_CONFIG.reachDistance + jitter
        
        -- Your brilliant predictive forward offset logic
        local headStart = root.CFrame.Position + (root.CFrame.LookVector * 4) 
        local distance = (headStart - ball.Position).Magnitude
        
        if distance <= adaptiveReach and hasLineOfSight(root, ball) then
            if firetouchinterest then
                lastShot = os.clock()
                
                -- [[ UNIFIED SYSTEM: ALWAYS SPOOF CFRAME TO DOMINATE OWNER SHUTDOWN ]]
                -- This teleports the leg directly inside the ball instantly at ALL ranges
                local oldCFrame = leg.CFrame
                leg.CFrame = ball.CFrame
                
                firetouchinterest(ball, leg, 0)
                
                local lookDir = root.CFrame.LookVector
                local currentVelocity = root.AssemblyLinearVelocity.Magnitude
                local velocityMultiplier = 1.0
                
                -- COMPENSATION ENGINE: If you decelerate or stand still, boost the power
                if currentVelocity < 12 then
                    velocityMultiplier = 1.25 -- 25% extra power injection when moving slow or stopped
                end
                
                -- Apply brutal absolute linear velocity directly into the server stream
                local finalPower = _G_CONFIG.power * velocityMultiplier
                ball.AssemblyLinearVelocity = (lookDir * finalPower) + Vector3.new(0, _G_CONFIG.lift, 0)
                ball.AssemblyAngularVelocity = Vector3.new(0, 0, 0) -- Force perfect stability without weird physics bounces
                
                firetouchinterest(ball, leg, 1)
                leg.CFrame = oldCFrame
            end
        end
    end
end)

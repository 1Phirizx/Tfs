local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()
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

-- Create Window
local Window = Rayfield:CreateWindow({
    Name = "Touch Football | FORCE V6",
    LoadingTitle = "Loading Lux Bypass Engine...",
    LoadingSubtitle = "by Elite Developer",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "TouchFootballForce",
        FileName = "Config"
    }
})

local MainTab = Window:CreateTab("Main", 4483362458) -- Title, ImageID

-- Toggle
MainTab:CreateToggle({
    Name = "Enable Lux-Style Reach",
    CurrentValue = false,
    Callback = function(Value)
        isEnabled = Value
    end,
})

-- Slider
MainTab:CreateSlider({
    Name = "Reach Distance",
    Info = "Alcance dinâmico preditivo",
    Min = 5,
    Max = 45,
    CurrentValue = 25,
    Increment = 1,
    Callback = function(Value)
        reachDistance = tonumber(Value) or 25
    end,
})

-- LUX HUB METHOD (PostSimulation Spoofing)
RunService.PostSimulation:Connect(function()
    if not isEnabled then return end
    
    local char = lp.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local ball = getBall()
    local leg = char and (char:FindFirstChild("RightFoot") or char:FindFirstChild("Right Leg") or char:FindFirstChild("LeftFoot"))
    
    if root and ball and ball:IsA("BasePart") and leg then
        local distance = (root.Position - ball.Position).Magnitude
        
        if distance <= reachDistance then
            -- Hitbox Spoofing (Teleporta a perna pro servidor validar)
            local oldCFrame = leg.CFrame
            leg.CFrame = ball.CFrame
            
            firetouchinterest(ball, leg, 0)
            
            local lookDir = root.CFrame.LookVector
            
            if distance < 10 then
                ball.AssemblyLinearVelocity = (lookDir * 60) + Vector3.new(0, 15, 0)
            else
                ball.AssemblyLinearVelocity = (lookDir * 75) + Vector3.new(0, 20, 0)
            end
            
            firetouchinterest(ball, leg, 1)
            leg.CFrame = oldCFrame
        end
    end
end)

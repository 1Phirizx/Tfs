local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Touch Football Hub",
    SubTitle = "Custom Reach System",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false,
    Theme = "Dark"
})

local Tabs = {
    Main = Window:AddTab({ Title = "Reach", Icon = "target" })
}

-- Variáveis de controle
local reachValue = 2
local ballName = "Football"

-- Função mestre para aplicar o alcance
local function ApplyReach()
    local ball = workspace:FindFirstChild(ballName)
    if ball then
        ball.Size = Vector3.new(reachValue, reachValue, reachValue)
        ball.CanCollide = false
        ball.Transparency = 0.5 -- Para você enxergar o tamanho do alcance
    end
end

-- Componente de Input (Igual ao Lux Hub)
Tabs.Main:AddInput("ReachInput", {
    Title = "Definir Reach (1-30)",
    Default = "2",
    Placeholder = "Digite o valor...",
    Numeric = true, -- Aceita apenas números
    Finished = true, -- Só aplica quando você der 'Enter' ou desclicar
    Callback = function(Value)
        local num = tonumber(Value)
        if num then
            -- Limita entre 1 e 30 para evitar bugs ou banimentos imediatos
            if num > 30 then num = 30 end
            if num < 1 then num = 1 end
            
            reachValue = num
            ApplyReach()
            
            Fluent:Notify({
                Title = "Reach Atualizado",
                Content = "Alcance definido para: " .. tostring(num),
                Duration = 3
            })
        end
    end
})

-- Toggle para manter o Reach sempre ativo (Anti-Reset)
Tabs.Main:AddToggle("AutoReach", {Title = "Auto-Apply Reach", Default = false})

-- Loop de verificação em segundo plano
task.spawn(function()
    while true do
        if Fluent.Options.AutoReach.Value then
            ApplyReach()
        end
        task.wait(1) -- Verifica a cada 1 segundo
    end
end)

Window:SelectTab(1)

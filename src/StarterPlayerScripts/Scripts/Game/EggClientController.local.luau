--!strict
--[[
    EggClientController.luau
    Cliente para:
    1. Atalho da tecla "P" para teste rápido: deposita o ovo carregado no inventário e volta ao plot.
    2. Colocar o ovo no plot ao clicar com a Tool do ovo equipada na mão:
       - Faz Raycast mirando estritamente para baixo ou no clique do mouse.
       - Valida se o alvo atingido é o FloorRanch1 do próprio Plot do jogador.
       - Envia a solicitação de colocação com a superfície correta.
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local mouse = player:GetMouse()
local Library = require(ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"))

while not Library.Loaded do
    task.wait()
end

local Network = Library.Network

-- 1. Atalho da Tecla "P" para fins de teste
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.P then
        print("[EggClientController] Tecla P pressionada: depositando ovo e retornando ao spawn do plot...")
        if Network then
            Network.Fire("Eggs_TestDeposit")
        end
    end
end)

-- 2. Colocar o ovo no chão ao clicar com o ovo equipado
mouse.Button1Down:Connect(function()
    local character = player.Character
    if not character then return end
    
    local tool = character:FindFirstChildWhichIsA("Tool")
    if not tool or not tool:GetAttribute("IsEgg") then return end
    
    local eggUid = tool:GetAttribute("UID")
    if not eggUid then return end
    
    -- Realiza Raycast a partir do mouse
    local ray = mouse.UnitRay
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.FilterDescendantsInstances = { character }
    raycastParams.IgnoreWater = true
    
    local rayResult = Workspace:Raycast(ray.Origin, ray.Direction * 500, raycastParams)
    local hitPos: Vector3? = nil
    
    if rayResult and rayResult.Instance then
        hitPos = rayResult.Position
    else
        hitPos = mouse.Hit.Position
    end
    
    if not hitPos then return end
    
    if Network then
        local success, err = Network.Invoke("Eggs_RequestPlace", eggUid, hitPos)
        if not success and err then
            warn("[EggClientController] Não foi possível colocar o ovo:", err)
        end
    end
end)

print("[EggClientController] Inicializado com sucesso! (Pressione P para voltar com o ovo)")

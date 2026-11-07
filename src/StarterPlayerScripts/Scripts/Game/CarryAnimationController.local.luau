--!strict
--[[
    CarryAnimationController.local.luau
    Toca a animação de carregar ovo (131342831254185) quando o jogador
    pega um ovo selvagem na caverna (escutando o atributo "Carrying").
    Desativa a animação quando o ovo é entregue na SafeZone ou chocado.
]]

local Players = game:GetService("Players")

local player = Players.LocalPlayer
local CARRY_ANIMATION_ID = "rbxassetid://131342831254185"

local animInstance = Instance.new("Animation")
animInstance.AnimationId = CARRY_ANIMATION_ID

local activeTrack: AnimationTrack? = nil

local function updateCarryAnimation(character: Model?)
    local char = character or player.Character
    if not char then return end

    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    local isCarrying = player:GetAttribute("Carrying") ~= nil

    if isCarrying then
        if not activeTrack or not activeTrack.IsPlaying then
            local animator = humanoid:FindFirstChildOfClass("Animator")
            if not animator then
                animator = Instance.new("Animator")
                animator.Parent = humanoid
            end

            local ok, track = pcall(function()
                return animator:LoadAnimation(animInstance)
            end)

            if ok and track then
                activeTrack = track
                track.Priority = Enum.AnimationPriority.Action
                track.Looped = true
                track:Play(0.15)
            end
        end
    else
        if activeTrack then
            activeTrack:Stop(0.15)
            activeTrack = nil
        end
    end
end

-- Escuta mudança de estado do atributo
player:GetAttributeChangedSignal("Carrying"):Connect(function()
    updateCarryAnimation()
end)

-- Conecta ao recriar o personagem
player.CharacterAdded:Connect(function(char)
    activeTrack = nil
    char:WaitForChild("Humanoid", 10)
    task.wait(0.2)
    updateCarryAnimation(char)
end)

if player.Character then
    updateCarryAnimation(player.Character)
end

print("[CarryAnimationController] Inicializado com sucesso! (ID: 131342831254185)")


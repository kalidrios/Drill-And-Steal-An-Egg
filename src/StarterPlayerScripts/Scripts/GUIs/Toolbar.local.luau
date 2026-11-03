--!strict
--[[
	Toolbar.local.luau: Controlador da barra de ferramentas inferior (Toolbar)
	Baseado na arquitetura do ref_BreakAndStealAnEgg, ref_StealAnEgg e ref_MinePerClick.

	Responsabilidades:
	- Desativa a CoreGui nativa de Backpack (Enum.CoreGuiType.Backpack) para nunca exibir a hotbar padrão do Roblox
	- Gerencia os slots dinâmicos dentro de PlayerGui.Main.Frame.Toolbar usando ReplicatedStorage.Assets.UI.ToolBar.Template
	- Não deixa templates vazios à toa: apenas ferramentas reais possuem slot visível
	- O Slot 1 é obrigatoriamente reservado para a Picareta; novos slots (2, 3...) só aparecem quando o jogador pega um ovo/item
	- Exibe o TextLabel KeyboardNumber apenas para PC (Teclado/Mouse)
	- Configura a imagem em .Frame.Icon (ImageTransparency = 0, ImageRectSize = 0,0, ScaleType = Fit)
	- Alterna equipar/desequipar ao clicar no botão do slot ou pressionar as teclas numéricas (1, 2, 3...)
]]

local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local TextChatService = game:GetService("TextChatService")
local UserInputService = game:GetService("UserInputService")

-- Desativa imediatamente a hotbar nativa do Roblox (com retry para garantir mesmo antes/depois do Intro)
local function DisableDefaultBackpackGui()
	pcall(function()
		StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
	end)
end

DisableDefaultBackpackGui()
task.spawn(function()
	for _ = 1, 20 do
		DisableDefaultBackpackGui()
		task.wait(0.25)
	end
end)

local Library = require(ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"))

while not Library.Loaded do
	RunService.Heartbeat:Wait()
end

DisableDefaultBackpackGui()

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")
local mainGui = playerGui:WaitForChild("Main")
local mainFrame = mainGui:WaitForChild("Frame")
local toolbar = mainFrame:WaitForChild("Toolbar") :: Frame

-- Busca o Template em ReplicatedStorage.Assets.UI.ToolBar.Template
local assetsFolder = ReplicatedStorage:WaitForChild("Assets")
local pickaxesFolder = assetsFolder:FindFirstChild("Pickaxes")
local uiAssets = assetsFolder:WaitForChild("UI")
local toolbarAssets = uiAssets:WaitForChild("ToolBar")
local template = toolbarAssets:WaitForChild("Template") :: Frame

-- Garante que o template original nunca fique visível se estiver dentro da UI por engano
for _, child in ipairs(toolbar:GetChildren()) do
	if child:IsA("GuiObject") then
		child:Destroy()
	end
end

type ActiveSlot = {
	Frame: Frame,
	Tool: Tool,
	SlotIndex: number,
	IsPickaxe: boolean,
	Connections: { RBXScriptConnection },
}

local activeSlots: { [Tool]: ActiveSlot } = {}
local orderedTools: { Tool } = {} -- Índices 1..N (1 é sempre a Picareta)
local characterConnections: { RBXScriptConnection } = {}
local backpackConnections: { RBXScriptConnection } = {}

-- Cores e espessuras do destaque (equipado na mão vs guardado na mochila)
local COLOR_EQUIPPED_STROKE = Color3.fromRGB(255, 225, 75)
local COLOR_DEFAULT_STROKE = Color3.fromRGB(208, 208, 208)
local THICKNESS_EQUIPPED = 0.06
local THICKNESS_DEFAULT = 0.03

-- Detecta se o dispositivo atual é PC (possui teclado ativo e não está usando toque/gamepad como último input)
local function IsPCInput(): boolean
	local lastInput = UserInputService:GetLastInputType()
	if lastInput == Enum.UserInputType.Touch then
		return false
	end
	if
		lastInput == Enum.UserInputType.Gamepad1
		or lastInput == Enum.UserInputType.Gamepad2
		or lastInput == Enum.UserInputType.Gamepad3
		or lastInput == Enum.UserInputType.Gamepad4
	then
		return false
	end
	if
		lastInput == Enum.UserInputType.Keyboard
		or lastInput == Enum.UserInputType.MouseButton1
		or lastInput == Enum.UserInputType.MouseButton2
		or lastInput == Enum.UserInputType.MouseButton3
		or lastInput == Enum.UserInputType.MouseMovement
		or lastInput == Enum.UserInputType.MouseWheel
	then
		return true
	end
	return UserInputService.KeyboardEnabled and not UserInputService.TouchEnabled
end

-- Verifica se uma Tool é uma Picareta
local function IsPickaxeTool(tool: Tool): boolean
	if tool:GetAttribute("Pickaxe") == true then
		return true
	end
	if pickaxesFolder and pickaxesFolder:FindFirstChild(tool.Name) then
		return true
	end
	if string.find(string.lower(tool.Name), "pickaxe", 1, true) ~= nil then
		return true
	end
	return false
end

-- Resolve o ícone da Tool (TextureId da própria Tool, atributo Icon ou asset original em ReplicatedStorage.Assets.Pickaxes)
local function ResolveToolIcon(tool: Tool): string
	if tool.TextureId ~= "" then
		return tool.TextureId
	end

	local attrIcon = tool:GetAttribute("Icon") or tool:GetAttribute("TextureId")
	if typeof(attrIcon) == "string" and attrIcon ~= "" then
		return attrIcon
	end

	if pickaxesFolder then
		local pickaxeName = tool:GetAttribute("PickaxeName")
		local lookupName = if typeof(pickaxeName) == "string" and pickaxeName ~= "" then pickaxeName else tool.Name
		local assetTool = pickaxesFolder:FindFirstChild(lookupName)
		if assetTool and assetTool:IsA("Tool") and assetTool.TextureId ~= "" then
			return assetTool.TextureId
		end
	end

	return ""
end

-- Obtém o Humanoid atual do personagem
local function GetHumanoid(): Humanoid?
	local character = localPlayer.Character
	if not character then
		return nil
	end
	return character:FindFirstChildOfClass("Humanoid")
end

-- Atualiza o visual do slot (ícone, número do teclado visível apenas para PC e borda de equipado)
local function UpdateSlotVisual(slotData: ActiveSlot)
	local tool = slotData.Tool
	local slotFrame = slotData.Frame
	if not slotFrame or not slotFrame.Parent then
		return
	end

	slotFrame.LayoutOrder = slotData.SlotIndex

	local keyboardLabel = slotFrame:FindFirstChild("KeyboardNumber") :: TextLabel?
	if keyboardLabel then
		local textNum = if slotData.SlotIndex < 10
			then tostring(slotData.SlotIndex)
			elseif slotData.SlotIndex == 10 then "0"
			else ""
		keyboardLabel.Text = textNum
		keyboardLabel.Visible = IsPCInput() and textNum ~= ""
	end

	local innerFrame = slotFrame:FindFirstChild("Frame") :: Frame?
	if innerFrame then
		local icon = innerFrame:FindFirstChild("Icon") :: ImageLabel?
		if icon then
			local iconUri = ResolveToolIcon(tool)
			icon.Image = iconUri
			-- O Template original no Studio está com ImageTransparency = 1 e ImageRectSize = 100, 100; resetamos para exibir o ícone
			icon.ImageRectOffset = Vector2.zero
			icon.ImageRectSize = Vector2.zero
			icon.ScaleType = Enum.ScaleType.Fit
			icon.ImageTransparency = if iconUri ~= "" then 0 else 1
			icon.Visible = (iconUri ~= "")
		end

		local stroke = innerFrame:FindFirstChildOfClass("UIStroke")
		if stroke then
			local character = localPlayer.Character
			local isEquipped = (character ~= nil and tool.Parent == character)
			stroke.Color = if isEquipped then COLOR_EQUIPPED_STROKE else COLOR_DEFAULT_STROKE
			stroke.Thickness = if isEquipped then THICKNESS_EQUIPPED else THICKNESS_DEFAULT
		end
	end
end

-- Reordena todos os slots ativos garantindo que a Picareta seja obrigatoriamente o Slot 1 e os ovos/itens venham em 2, 3...
local function ReindexSlots()
	local pickaxeTools: { Tool } = {}
	local otherTools: { Tool } = {}

	for _, tool in ipairs(orderedTools) do
		if activeSlots[tool] then
			if activeSlots[tool].IsPickaxe then
				table.insert(pickaxeTools, tool)
			else
				table.insert(otherTools, tool)
			end
		end
	end

	table.clear(orderedTools)

	-- Slot 1 obrigatoriamente é a Picareta
	for _, tool in ipairs(pickaxeTools) do
		table.insert(orderedTools, tool)
	end
	for _, tool in ipairs(otherTools) do
		table.insert(orderedTools, tool)
	end

	for index, tool in ipairs(orderedTools) do
		local slotData = activeSlots[tool]
		if slotData then
			slotData.SlotIndex = index
			UpdateSlotVisual(slotData)
		end
	end
end

-- Equipa ou desequipa a Tool ao clicar ou usar atalho numérico
local function ToggleToolEquip(tool: Tool)
	local humanoid = GetHumanoid()
	if not humanoid or humanoid.Health <= 0 then
		return
	end

	local character = localPlayer.Character
	if not character then
		return
	end

	if tool.Parent == character then
		humanoid:UnequipTools()
	else
		local backpack = localPlayer:FindFirstChildOfClass("Backpack")
		if backpack and tool.Parent == backpack then
			humanoid:EquipTool(tool)
		end
	end
end

-- Remove um slot quando a Tool deixa de pertencer ao jogador (ex: ovo colocado/dropado)
local function RemoveToolSlot(tool: Tool)
	local slotData = activeSlots[tool]
	if not slotData then
		return
	end

	activeSlots[tool] = nil

	local idx = table.find(orderedTools, tool)
	if idx then
		table.remove(orderedTools, idx)
	end

	for _, conn in ipairs(slotData.Connections) do
		conn:Disconnect()
	end
	table.clear(slotData.Connections)

	if slotData.Frame then
		slotData.Frame:Destroy()
	end

	ReindexSlots()
end

-- Cria um slot na Toolbar apenas quando uma Tool real entra na mochila ou mão do jogador
local function RegisterToolSlot(tool: Tool)
	if activeSlots[tool] then
		UpdateSlotVisual(activeSlots[tool])
		return
	end

	local isPickaxe = IsPickaxeTool(tool)

	-- Se for uma nova picareta e já havia outra registrada (troca de picareta), remove a antiga
	if isPickaxe then
		for existingTool, existingSlot in pairs(activeSlots) do
			if existingSlot.IsPickaxe and existingTool ~= tool then
				RemoveToolSlot(existingTool)
			end
		end
	end

	local slotClone = template:Clone()
	slotClone.Name = string.format("Slot_%s", tool.Name)
	slotClone.Visible = true

	local slotData: ActiveSlot = {
		Frame = slotClone,
		Tool = tool,
		SlotIndex = 1,
		IsPickaxe = isPickaxe,
		Connections = {},
	}

	local innerFrame = slotClone:FindFirstChild("Frame") :: Frame?
	if innerFrame then
		local button = innerFrame:FindFirstChild("Button") :: TextButton?
		if button then
			table.insert(
				slotData.Connections,
				button.Activated:Connect(function()
					ToggleToolEquip(tool)
				end)
			)
		end
	end

	table.insert(
		slotData.Connections,
		tool.Changed:Connect(function(property)
			if property == "TextureId" or property == "Name" or property == "Parent" then
				if activeSlots[tool] then
					UpdateSlotVisual(slotData)
				end
			end
		end)
	)

	table.insert(
		slotData.Connections,
		tool.AttributeChanged:Connect(function()
			if activeSlots[tool] then
				slotData.IsPickaxe = IsPickaxeTool(tool)
				ReindexSlots()
			end
		end)
	)

	table.insert(
		slotData.Connections,
		tool.AncestryChanged:Connect(function(_, parent)
			task.defer(function()
				local character = localPlayer.Character
				local backpack = localPlayer:FindFirstChildOfClass("Backpack")
				if parent == nil or (parent ~= character and parent ~= backpack) then
					RemoveToolSlot(tool)
				elseif activeSlots[tool] then
					-- Atualiza todos os slots para refletir qual está na mão agora
					for _, data in pairs(activeSlots) do
						UpdateSlotVisual(data)
					end
				end
			end)
		end)
	)

	slotClone.Parent = toolbar
	activeSlots[tool] = slotData

	if isPickaxe then
		table.insert(orderedTools, 1, tool)
	else
		table.insert(orderedTools, tool)
	end

	ReindexSlots()
end

-- Limpa ferramentas órfãs que não estão mais no Character nem no Backpack
local function PruneLostTools()
	local character = localPlayer.Character
	local backpack = localPlayer:FindFirstChildOfClass("Backpack")
	local toRemove: { Tool } = {}

	for tool in pairs(activeSlots) do
		local parent = tool.Parent
		if parent == nil or (parent ~= character and parent ~= backpack) then
			table.insert(toRemove, tool)
		end
	end

	for _, tool in ipairs(toRemove) do
		RemoveToolSlot(tool)
	end
end

-- Conecta listeners na mochila (Backpack) atual do jogador
local function HookBackpack(backpack: Backpack)
	for _, conn in ipairs(backpackConnections) do
		conn:Disconnect()
	end
	table.clear(backpackConnections)

	table.insert(
		backpackConnections,
		backpack.ChildAdded:Connect(function(child)
			if child:IsA("Tool") then
				RegisterToolSlot(child)
			end
		end)
	)

	table.insert(
		backpackConnections,
		backpack.ChildRemoved:Connect(function(child)
			if child:IsA("Tool") then
				task.defer(function()
					local character = localPlayer.Character
					if child.Parent ~= character and child.Parent ~= backpack then
						RemoveToolSlot(child)
					elseif activeSlots[child] then
						UpdateSlotVisual(activeSlots[child])
					end
				end)
			end
		end)
	)

	for _, child in ipairs(backpack:GetChildren()) do
		if child:IsA("Tool") then
			RegisterToolSlot(child)
		end
	end
end

-- Conecta listeners no personagem (Character) atual do jogador
local function HookCharacter(character: Model)
	for _, conn in ipairs(characterConnections) do
		conn:Disconnect()
	end
	table.clear(characterConnections)

	PruneLostTools()

	table.insert(
		characterConnections,
		character.ChildAdded:Connect(function(child)
			if child:IsA("Tool") then
				RegisterToolSlot(child)
				for _, data in pairs(activeSlots) do
					UpdateSlotVisual(data)
				end
			end
		end)
	)

	table.insert(
		characterConnections,
		character.ChildRemoved:Connect(function(child)
			if child:IsA("Tool") then
				task.defer(function()
					local backpack = localPlayer:FindFirstChildOfClass("Backpack")
					if child.Parent ~= character and child.Parent ~= backpack then
						RemoveToolSlot(child)
					else
						for _, data in pairs(activeSlots) do
							UpdateSlotVisual(data)
						end
					end
				end)
			end
		end)
	)

	for _, child in ipairs(character:GetChildren()) do
		if child:IsA("Tool") then
			RegisterToolSlot(child)
		end
	end

	local backpack = localPlayer:FindFirstChildOfClass("Backpack") or localPlayer:WaitForChild("Backpack", 10)
	if backpack and backpack:IsA("Backpack") then
		HookBackpack(backpack)
	end
end

-- Atualiza a visibilidade de KeyboardNumber caso o tipo de input mude (PC <-> Mobile/Gamepad)
UserInputService.LastInputTypeChanged:Connect(function()
	for _, slotData in pairs(activeSlots) do
		UpdateSlotVisual(slotData)
	end
end)

-- Verifica se o chat está focado para não trocar de tool enquanto digita números
local function IsChatFocused(): boolean
	local chatInputBar = TextChatService:FindFirstChildOfClass("ChatInputBarConfiguration")
	if chatInputBar and chatInputBar.IsFocused then
		return true
	end
	return false
end

local KEYCODE_TO_SLOT: { [Enum.KeyCode]: number } = {
	[Enum.KeyCode.One] = 1,
	[Enum.KeyCode.Two] = 2,
	[Enum.KeyCode.Three] = 3,
	[Enum.KeyCode.Four] = 4,
	[Enum.KeyCode.Five] = 5,
	[Enum.KeyCode.Six] = 6,
	[Enum.KeyCode.Seven] = 7,
	[Enum.KeyCode.Eight] = 8,
	[Enum.KeyCode.Nine] = 9,
	[Enum.KeyCode.Zero] = 10,
}

-- Suporte a atalhos do teclado (1 = Picareta, 2..9 = Ovos/Itens)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then
		return
	end
	if GuiService.MenuIsOpen or UserInputService:GetFocusedTextBox() or IsChatFocused() then
		return
	end

	local slotPressed = KEYCODE_TO_SLOT[input.KeyCode]
	if slotPressed then
		local targetTool = orderedTools[slotPressed]
		if targetTool and activeSlots[targetTool] then
			ToggleToolEquip(targetTool)
		end
	end
end)

-- Escuta trocas de Backpack e Character
localPlayer.ChildAdded:Connect(function(child)
	if child:IsA("Backpack") then
		HookBackpack(child)
	end
end)

localPlayer.CharacterAdded:Connect(HookCharacter)
if localPlayer.Character then
	task.spawn(HookCharacter, localPlayer.Character)
else
	local backpack = localPlayer:FindFirstChildOfClass("Backpack")
	if backpack then
		HookBackpack(backpack)
	end
end

print("[Toolbar] Controlador da Toolbar customizada inicializado com sucesso!")

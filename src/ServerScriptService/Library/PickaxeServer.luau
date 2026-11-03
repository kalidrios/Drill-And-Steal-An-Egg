--!strict
--[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⣿⣿⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
	Velvet Groups rbx.lua Framework
	-+-+-+- SPECIFICS -+-+-+-
	ServerScriptService.Library.PickaxeServer
	Serviço de Equipamento e Entrega de Picaretas aos Jogadores
	Engenharia Reversa baseada em ref_MinePerClick/PickaxeService
	===========
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PickaxeServer = {}
local Library: any = nil

--- Busca o asset ou template de picareta e cria um Tool equipado
function PickaxeServer.GivePickaxeTool(player: Player, pickaxeName: string?)
	local character = player.Character
	if not character then return end

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid or humanoid.Health <= 0 then return end

	local backpack = player:FindFirstChild("Backpack")

	-- Remove picaretas anteriores do inventário e do personagem
	if backpack then
		for _, tool in ipairs(backpack:GetChildren()) do
			if tool:IsA("Tool") and tool:GetAttribute("Pickaxe") then
				tool:Destroy()
			end
		end
	end

	for _, tool in ipairs(character:GetChildren()) do
		if tool:IsA("Tool") and tool:GetAttribute("Pickaxe") then
			tool:Destroy()
		end
	end

	-- Determina qual picareta entregar (do save ou fallback)
	local chosenName = pickaxeName
	if not chosenName or chosenName == "" then
		local savingModule = Library and Library.Saving
		local playerData = savingModule and savingModule.Get(player)
		chosenName = (playerData and playerData.EquippedPickaxe) or "Wood Pickaxe"
	end

	local assets = ReplicatedStorage:FindFirstChild("Assets")
	local pickaxesFolder = assets and (assets:FindFirstChild("Pickaxes") or assets:FindFirstChild("Picaxe"))

	local pickaxeAsset: Instance? = nil
	if pickaxesFolder then
		pickaxeAsset = pickaxesFolder:FindFirstChild(chosenName :: string)
		if not pickaxeAsset then
			-- Tenta encontrar por matching parcial ou primeira picareta disponível
			for _, item in ipairs(pickaxesFolder:GetChildren()) do
				if item.Name:lower():find("pickaxe") or item.Name:lower():find("acid") or item.Name:lower():find("wood") then
					pickaxeAsset = item
					break
				end
			end
			if not pickaxeAsset and #pickaxesFolder:GetChildren() > 0 then
				pickaxeAsset = pickaxesFolder:GetChildren()[1]
			end
		end
	end

	local tool: Tool
	if pickaxeAsset and pickaxeAsset:IsA("Tool") then
		tool = pickaxeAsset:Clone() :: Tool
	elseif pickaxeAsset and pickaxeAsset:IsA("Model") then
		tool = Instance.new("Tool")
		tool.Name = pickaxeAsset.Name
		tool.CanBeDropped = false
		tool.RequiresHandle = true

		local existingHandle = pickaxeAsset:FindFirstChild("Handle")
		if existingHandle and existingHandle:IsA("BasePart") then
			local h = existingHandle:Clone()
			h.Parent = tool
		else
			local primary = pickaxeAsset.PrimaryPart or pickaxeAsset:FindFirstChildWhichIsA("BasePart")
			if primary then
				local h = primary:Clone()
				h.Name = "Handle"
				h.Parent = tool
			else
				local h = Instance.new("Part")
				h.Name = "Handle"
				h.Size = Vector3.new(1, 1, 3)
				h.Transparency = 1
				h.Parent = tool
			end
		end

		for _, child in ipairs(pickaxeAsset:GetChildren()) do
			if child.Name ~= "Handle" and child:IsA("BasePart") then
				local partClone = child:Clone()
				partClone.Parent = tool
				local weld = Instance.new("WeldConstraint")
				weld.Part0 = tool:FindFirstChild("Handle") :: BasePart
				weld.Part1 = partClone
				weld.Parent = tool:FindFirstChild("Handle")
			end
		end
	else
		-- Fallback elegante com Handle funcional
		tool = Instance.new("Tool")
		tool.Name = chosenName :: string
		tool.CanBeDropped = false
		tool.RequiresHandle = true

		local handle = Instance.new("Part")
		handle.Name = "Handle"
		handle.Size = Vector3.new(1, 1, 3.5)
		handle.Color = Color3.fromRGB(139, 90, 43)
		handle.Material = Enum.Material.Wood
		handle.Parent = tool
	end

	tool:SetAttribute("Pickaxe", true)
	tool:SetAttribute("PickaxeName", chosenName)

	-- Coloca a ferramenta no Backpack e equipa na mão do personagem
	if backpack then
		tool.Parent = backpack
		task.delay(0.1, function()
			if humanoid and humanoid.Parent and tool and tool.Parent == backpack then
				humanoid:EquipTool(tool)
			end
		end)
	else
		tool.Parent = character
	end

	print(string.format("[PickaxeServer] Picareta '%s' entregue para %s!", tool.Name, player.Name))
end

function PickaxeServer.OnCharacterAdded(player: Player, character: Model)
	task.wait(0.4)
	PickaxeServer.GivePickaxeTool(player)
end

function PickaxeServer.Start(lib: any)
	Library = lib

	Players.PlayerAdded:Connect(function(player)
		player.CharacterAdded:Connect(function(character)
			PickaxeServer.OnCharacterAdded(player, character)
		end)

		if player.Character then
			task.spawn(PickaxeServer.OnCharacterAdded, player, player.Character)
		end
	end)

	for _, player in ipairs(Players:GetPlayers()) do
		player.CharacterAdded:Connect(function(character)
			PickaxeServer.OnCharacterAdded(player, character)
		end)

		if player.Character then
			task.spawn(PickaxeServer.OnCharacterAdded, player, player.Character)
		end
	end

	print("[PickaxeServer] Serviço de picaretas Velvet inicializado com sucesso!")
end

return PickaxeServer

--[[
	Chat Tags - Client Side
	Calcula as tags usando ranks de grupo e gamepasses.
	No TextChatService, o OnIncomingMessage roda no CLIENT.
]]

--------|    Reference    |--------
local TextChatService = game:GetService("TextChatService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")

--------|     Library     |--------
local _L = require(ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"))
while (not _L.Loaded) do game:GetService("RunService").Heartbeat:Wait() end

--------|    Variables    |--------
local playerTagsCache = {} -- Cache local de tags
local GROUP_ID = 3112828 -- ID do grupo do jogo

-- Mapeamento de ranks para tags (255 = Owonner, vai diminuindo)
local RANK_TAGS = {
	[255] = { tag = "⚡God", tagColor = Color3.fromRGB(236, 255, 0) },           -- Owonner
	[254] = { tag = "🛠️Admin", tagColor = Color3.fromRGB(157, 23, 240) },       -- Manager
	[253] = { tag = "🔨Dev", tagColor = Color3.fromRGB(255, 56, 114) },          -- Developer
	[252] = { tag = "🌴CM", tagColor = Color3.fromRGB(56, 255, 189) },           -- Community Manager
	[251] = { tag = "🔧Mod", tagColor = Color3.fromRGB(220, 162, 247) },         -- Helper
	[250] = { tag = "💗Beloved", tagColor = Color3.fromRGB(255, 207, 249) },     -- Beloved
	[249] = { tag = "🔥Partner", tagColor = Color3.fromRGB(255, 136, 0) },       -- Partner
	[248] = { tag = "🧪Tester", tagColor = Color3.fromRGB(135, 255, 239) },      -- Tester
	[247] = { tag = "⭐Active", tagColor = Color3.fromRGB(255, 215, 0) },        -- Active
}
local VIP_TAG = { tag = "👑VIP", tagColor = Color3.fromRGB(221, 229, 66) }
local FAN_TAG = { tag = "Fan", tagColor = Color3.fromRGB(229, 151, 86) }

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--- Função para converter Color3 para hex
local function ColorToHex(color: Color3): string
	return string.format("#%02X%02X%02X", 
		math.floor(color.R * 255), 
		math.floor(color.G * 255), 
		math.floor(color.B * 255)
	)
end

--- Verifica se o jogador tem VIP
local function HasVIP(player: Player): boolean
	local success, hasVip = pcall(function()
		local vipId = _L.Directory and _L.Directory.Gamepasses and _L.Directory.Gamepasses["VIP"] and _L.Directory.Gamepasses["VIP"].ID
		if vipId then
			return MarketplaceService:UserOwnsGamePassAsync(player.UserId, vipId)
		end
		return false
	end)
	return success and hasVip
end

--- Calcula a tag do jogador baseado no rank do grupo e gamepasses
local function GetPlayerTag(player: Player)
	local rankSuccess, rank = pcall(function()
		return player:GetRankInGroup(GROUP_ID)
	end)
	rank = rankSuccess and rank or 0

	-- Primeiro verifica ranks especiais (staff)
	if RANK_TAGS[rank] then
		return RANK_TAGS[rank]
	end

	-- VIP (tem prioridade sobre Fan)
	if HasVIP(player) then
		return VIP_TAG
	end

	-- Fan (qualquer membro do grupo)
	if rank > 0 then
		return FAN_TAG
	end

	return nil -- Não está no grupo
end

--- Função para buscar e cachear a tag de um jogador
local function FetchAndCacheTag(player: Player)
	task.spawn(function()
		-- Espera um pouco para garantir que os dados carregaram
		task.wait(2)

		local tagData = GetPlayerTag(player)
		if tagData then
			playerTagsCache[player.UserId] = tagData
			print("[Chat Tags] ✅ Tag cacheada para", player.Name, ":", tagData.tag)
		else
			print("[Chat Tags] Jogador", player.Name, "não está no grupo")
		end
	end)
end

--- Cacheia tags de todos os jogadores existentes
for _, player in ipairs(Players:GetPlayers()) do
	FetchAndCacheTag(player)
end

--- Quando um novo jogador entra
Players.PlayerAdded:Connect(FetchAndCacheTag)

--- Quando um jogador sai
Players.PlayerRemoving:Connect(function(player)
	playerTagsCache[player.UserId] = nil
end)

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--- Configurar o callback de mensagens no TextChatService
local function SetupChatCallback()
	local textChannels = TextChatService:WaitForChild("TextChannels", 10)
	if not textChannels then
		warn("[Chat Tags] TextChannels não encontrado.")
		return
	end

	local generalChannel = textChannels:WaitForChild("RBXGeneral", 10)
	if not generalChannel then
		warn("[Chat Tags] Canal RBXGeneral não encontrado.")
		return
	end

	-- Configura o callback - NÃO PODE YIELDAR AQUI!
	generalChannel.OnIncomingMessage = function(message: TextChatMessage)
		local properties = Instance.new("TextChatMessageProperties")

		if message.TextSource then
			local userId = message.TextSource.UserId
			local tagData = playerTagsCache[userId]

			if tagData and tagData.tag then
				local tagHex = ColorToHex(tagData.tagColor)
				properties.PrefixText = string.format('<font color="%s">[%s]</font>', tagHex, tagData.tag)
			end
		end

		return properties
	end

	print("[Chat Tags] ✅ Sistema de chat tags configurado!")
end

-- Inicia
task.spawn(SetupChatCallback)

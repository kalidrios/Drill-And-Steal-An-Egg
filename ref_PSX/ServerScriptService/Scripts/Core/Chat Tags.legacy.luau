--[[
	Chat Tags - Server Side
	Gerencia as tags dos jogadores e responde às requisições do cliente.
]]

--------|     Library     |--------
local _L = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"))
while (not _L.Loaded) do game:GetService("RunService").Heartbeat:Wait() end

--------|    Reference    |--------
local Players = game:GetService("Players")

--------|    Variables    |--------
local playerTags = {} -- Cache de tags por jogador

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--- Return the correct chat tag style for this player
function GetStyle(player)
	local function FindCustomTag(userId)
		if _L.Settings and _L.Settings.CustomChatTags then
			for _, customData in ipairs(_L.Settings.CustomChatTags) do
				if _L.Functions.SearchArray(customData.userIds, userId) then
					return customData.tag
				end
			end
		end
	end

	-- save
	local save = _L.Saving.Get(player)
	if not save then
		return nil
	end

	--- Find correct tag
	local customTag = FindCustomTag(player.UserId)
	if customTag then
		return customTag

	elseif _L.Admins.IsAdmin(player) then
		local rank = player:GetRankInGroup(1072042)

		--- Owner
		if rank == 255 or rank == 254 then
			return {
				tag = "⚡God", 
				tagColor = Color3.fromRGB(236, 255, 0), 
			}
			--- Developer
		elseif rank == 100 then
			return {
				tag = "�Developer", 
				tagColor = Color3.fromRGB(255, 56, 114),
			}
			--- Community Manager
		elseif rank == 10 then
			return {
				tag = "🌴CM",
				tagColor = Color3.fromRGB(56, 255, 189), 
			}
			--- Admin
		elseif rank == 3 then
			return {
				tag = "🛠️Admin", 
				tagColor = Color3.fromRGB(157, 23, 240), 
			}
			--- Moderator
		else
			return {
				tag = "🔧Mod", 
				tagColor = Color3.fromRGB(220, 162, 247), 
			}
		end

	else
		local rank = player:GetRankInGroup(3112828)
		local rankWorldwide = _L.Signal.Invoke("Get Leaderboard Position", player) or 0
		local pwrRankWorldwide = _L.Signal.Invoke("Get Power Leaderboard Position", player) or 0
		if rankWorldwide < pwrRankWorldwide then
			rankWorldwide = pwrRankWorldwide
		end

		--- Partner
		if rank == 5 then
			return {
				tag = "🔥Partner", 
				tagColor = Color3.fromRGB(255, 136, 0),
			}
		elseif rank == 10 then
			return {
				tag = "💗Booster", 
				tagColor = Color3.fromRGB(255, 207, 249),
			}
			--- Top 100 Rank
		elseif rankWorldwide and rankWorldwide <= 100 and rankWorldwide >= 1 then
			return {
				tag = "🌎#" .. rankWorldwide,
				tagColor = Color3.fromRGB(135, 255, 239)
			}
			--- Affiliate
		elseif rank == 15 then
			return {
				tag = "🛠Affiliate", 
				tagColor = Color3.fromRGB(135, 255, 239),
			}
			--- VIP
		elseif _L.Gamepasses.Owns(player, _L.Directory.Gamepasses["VIP"].ID) then
			return {
				tag = "👑VIP", 
				tagColor = Color3.fromRGB(221, 229, 66), 
			}
			--- Verified
		elseif save.IsFollowingOnTwitter then
			return {
				tag = "✅Verified", 
				tagColor = Color3.fromRGB(113, 220, 99)
			}
			--- Fan
		elseif player:IsInGroup(3112828) then
			return {
				tag = "Fan", 
				tagColor = Color3.fromRGB(229, 151, 86)
			}
		end
	end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--- Função para cachear a tag do jogador
local function CachePlayerTag(player: Player)
	task.spawn(function()
		task.wait(3) -- Espera o save carregar
		local styleData = GetStyle(player)
		if styleData then
			playerTags[player.UserId] = styleData
		end
	end)
end

--- Quando jogador entra
Players.PlayerAdded:Connect(CachePlayerTag)

--- Quando jogador sai
Players.PlayerRemoving:Connect(function(player)
	playerTags[player.UserId] = nil
end)

--- Cachear jogadores existentes
for _, player in ipairs(Players:GetPlayers()) do
	CachePlayerTag(player)
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--- Signal para o cliente pegar a tag
_L.Signal.Invoked("Get Player Chat Tag").OnInvoke = function(targetPlayer)
	-- Retorna do cache ou calcula na hora
	if targetPlayer and playerTags[targetPlayer.UserId] then
		return playerTags[targetPlayer.UserId]
	elseif targetPlayer then
		return GetStyle(targetPlayer)
	end
	return nil
end

print("[Chat Tags Server] ✅ Sistema de tags carregado!")

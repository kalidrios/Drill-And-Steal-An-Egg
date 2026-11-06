_G.FireworkCACHE = {}

local _L = require(game.ReplicatedStorage:WaitForChild("Library")) _L.Load()

function Equip(player, hacky)
	if _G.FireworkCACHE[tostring(player.UserId)] == true then
		return
	end
	
	_G.FireworkCACHE[tostring(player.UserId)] = true
	player:SetAttribute("FireworkLauncher", true)
	if hacky then
		_L.Network.FireAll("FireworkLauncher_HackyEquip", player)
		return
	end
	
	_L.Network.FireAll("FireworkLauncher_Equip", player)
end

function Unequip(player)
	if _G.FireworkCACHE[tostring(player.UserId)] == false then
		return
	end
	
	_G.FireworkCACHE[tostring(player.UserId)] = false
	player:SetAttribute("FireworkLauncher", false)
	_L.Network.FireAll("FireworkLauncher_Unequip", player)
end

function GetPlayersEquipped()
	local equipped = {}
	for i, v in pairs(_G.FireworkCACHE) do
		if v == true then
			table.insert(equipped, i)
		end
	end
	return equipped
end

_L.Network.Fired("FireworkLauncher_FireProjectile"):Connect(function(player, WorldPosition, atan2, atan, bn)
	for i, v in ipairs(_L.Players:GetPlayers()) do
		if v.UserId ~= player.UserId then
			_L.Network.Fire("FireworkLauncher_OtherPlayerFiredProjectile", v, player, WorldPosition, atan2, atan, bn)
		end
	end
end)

_L.Network.Fired("FireworkLauncher_UnequipServer"):Connect(function(player, unequipPlayer)
	Unequip(unequipPlayer)
end)

_L.Network.Invoked("FireworkLauncher_GetPlayersEquipped").OnInvoke = GetPlayersEquipped
_L.Signal.Fired("FireworkLauncher_Equip"):Connect(Equip)

--[[_L.Signal.Fired("Player Added"):Connect(function(player)
	player.Chatted:Connect(function(msg)
		if msg == "test launcher" then
			Equip(player)
		end
	end)
end)]]--
--[[ Last synced 9/21/2025 04:57                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         Às vezes é mais fácil desistir mesmo ]]    --[[                                                                                                  ]]--
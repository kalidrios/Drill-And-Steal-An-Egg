--------|     Setting     |--------
local notifyEnabled = true
local ping = "<@1037898275229020250>" --"@everyone"

--------|     Library     |--------
local _L = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"))
while (not _L.Loaded) do game:GetService("RunService").Heartbeat:Wait() end

--------|    Reference    |--------

--------|    Variables    |--------
local roles = {
	["Fan"] = false;
	["Partner"] = true;
	["Tester"] = true;
	["Affiliate"] = true;
	["Community Manager"] = true;
	["Developer"] = true;
	["Manager"] = true;
	["Owner"] = true;
}
local staffRoles = {
	["Moderator"] = true;
	["Admin"] = true;
	["Community Manager"] = true;
	["Developer"] = true;
	["Manager"] = true;
	["Owner"] = true;
}
local groupId = 3112828
local staffGroupId = 1072042

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function notifyPlayer(plr, role, group)
	if notifyEnabled then
		_G.HasLoaded(plr)
		_L.Network.Fire("Notification", plr, "Detected that you're in the \""..group.."\" group ranked as \""..role.."\".", {time = 5, color = Color3.fromRGB(255, 0, 0), force = true})
	end
end

function getGameLink(id)
	return "https://www.roblox.com/games/"..tostring(id)
end

function sendWebook(plr, role, isStaffGroup)
	local groupName = isStaffGroup and "Velvet Games Staff" or "Velvet Games™"
	local gameLink = getGameLink(game.PlaceId)
	notifyPlayer(plr, role, groupName)
	_G.SendWebhook({
		["username"] = "Velvet Games Detection",
		["content"] = ping.."\n **Username:** "..plr.Name.."\n **GameLink:** "..gameLink.."\n **Role:** "..role.."\n **Group:** "..groupName
		---"@everyone "..plr.Name.." has joined "..gameLink.." and is roled "..role.." in the "..groupName.." group!"
	})
end

_L.Signal.Fired("Player Added"):Connect(function(plr)
	local isInGroup, isInStaffGroup = plr:IsInGroup(groupId), plr:IsInGroup(staffGroupId)
	local groupRank, staffGroupRank = plr:GetRankInGroup(groupId), plr:GetRankInGroup(staffGroupId)
	local groupRole, staffGroupRole = plr:GetRoleInGroup(groupId), plr:GetRoleInGroup(staffGroupId)
	if isInStaffGroup and staffGroupRole and staffRoles[staffGroupRole] then
		sendWebook(plr, staffGroupRole, true)
	elseif isInGroup and groupRole and roles[groupRole] then
		sendWebook(plr, groupRole, false)
	end
end)
--[[ Last synced 9/21/2025 04:56                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         Às vezes é mais fácil desistir mesmo ]]    --[[                                                                                                  ]]--
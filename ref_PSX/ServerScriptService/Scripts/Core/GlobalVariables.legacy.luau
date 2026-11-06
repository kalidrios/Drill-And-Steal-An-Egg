--------|     Library     |--------

--------|     Setting     |--------

--------|    Reference    |--------
local HttpService = game:GetService("HttpService")

--------|    Variables    |--------

--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------

function GetLibrary()
	local _L = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"))
	while (not _L.Loaded) do  game:GetService("RunService").Heartbeat:Wait()  end
	return _L
end

_G.Webhook = "" -- Coloque seu webhook aqui
_G.SendWebhook = function(data)
	return -- Webhook temporariamente desativado
	--[[
	DataFormat
	{
	["username"] = "Join Checker",
	["content"] = "This is a message."
	} 
	
	_G.SendWebhook({
		["username"] = "lol"; 
		["content"] = "wsg";
	})
	
	local json = HttpService:JSONEncode(data) 
	HttpService:PostAsync(_G.Webhook, json) 
	]]
end 

_G.UnlockHoverboard = function(player, hoverboard)
	local _L = GetLibrary()
	
	local save = _L.Saving.Get(player)
	if not save then
		_L.Print("[bold] COULDNT GET PLAYER "..player.Name.." SAVE [/bold]")
		return 
	end

	local search = _L.Functions.SearchArray(save.Hoverboards, hoverboard)
	if not search then
		table.insert(save.Hoverboards, hoverboard)
		save.EquippedHoverboard = hoverboard

		_L.Network.Fire("Hoverboard Unlocked", player, hoverboard)
	end
end

-- Global Default Data --
--[[
    Default data is held here to easily be changed
    and gotten from multiple scripts. - kalidrios
--]]
_G.GetDefaultData = function(type)
	local _L = GetLibrary()
	
	if type == "player" then
		return {
			Banks = {},
			Invites = {},
			OutgoingInvites = {}
		}
	elseif type == "vote" then
		return {
			PlayerVote = nil
		}
	elseif type == "defaultstats" then
		return require(game.ReplicatedStorage.Library.Modules.DefaultStats)
	elseif type == "bank" then
		return {
			Storage = {
				Pets = {},
				Currency = {
					Diamonds = 0
				}
			},
			Owner = nil,
			BUID = nil,
			Tier = 1,
			Players = {},
			History = {},
			Banned = false
		}
	elseif type == "invite" then
		return {
			Sender = nil,
			BUID = nil,
			Timestamp = workspace:GetServerTimeNow()
		}
	elseif type == "outgoing invites" then
		return {
			Target = nil,
		}
	elseif type == "mail" then
		return {
			Inbox = {},
			Settings = {
				Rarities = {
					Basic = false,
					Rare = false,
					Epic = false,
					Legendary = false,
					Mythical = false,
					Secret = false,
					Event = false,
					Exclusive = false
				},
				OtherSettings = {
					HugesSetting = false,
					EnabledSetting = true,
					RequiredPetSetting = false,
					FriendsOnlySetting = false
				}
			}
		}
	elseif type == "dupe" then
		return {
			Pets = {},
			HasChecked = false,
			FirstTime = true,
			LastCheck = nil
		}
	end

	_L.Print("[bold] Failed to get default data "..type.." [/bold]")
	return nil
end

local hasLoaded = nil
_G.HasLoaded = function(player): boolean
	local _L = GetLibrary()
	--repeat wait() until _L.Network.Invoke("Has Loaded", player) == true
	--while _L.Network.Invoke("Has Loaded", player) ~= true do
	--	if not player or not player.Parent then
	--		break
	--	end
	--	task.wait()
	--end
	if not hasLoaded then
		while not hasLoaded do
			if not player or not player.Parent then break end
			hasLoaded = _L.Network.Invoke("Has Loaded", player)
			task.wait()
		end
	end	
	return true
end

local TimeLimit = 5
_G.ProcessPending = function(player, stop)
	local _L = GetLibrary()
	--print(stop)
	local event = stop and "Process Pending Stop" or "Process Pending Start"
	_L.Network.Fire(event, player)
	local _starttick = tick()
	task.spawn(function() -- incase smth is wrong...
		if not stop then
			while wait() do
				if tick() - _starttick > TimeLimit then
					_L.Network.Fire("Process Pending Stop", player)
				end
			end
		end	
	end)
end

_G.GetGameData = function()
	local GameID = game.PlaceId
	local GameFavoritesProxy = "" -- "https://games.roproxy.com/v1/games/%s/favorites/count"
	if GameFavoritesProxy ~= "" then
		local GameDATA = HttpService:GetAsync(string.format(GameFavoritesProxy, 4491159178))
		GameDATA = HttpService:JSONDecode(GameDATA)
	end
end

--- adfiowedf
local rng = Random.new()
local _base = [[~`1!2@3#4$5%6^7&8*9(0)-_=+QWERTYUIOP[{]}\|ASDFGHJKL;:"'ZXCVBNM,<.>/?]]
local default = 24
function GenerateRandomString(length)
	local _string = ""
	for i = 1, length or default do
		local l = rng:NextInteger(1, #_base)
		local int = string.sub(_base, l, l)
		_string = _string .. int
	end
	return _string
end

--[[ Last synced 9/21/2025 04:52                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         Às vezes é mais fácil desistir mesmo ]]    --[[                                                                                                  ]]--
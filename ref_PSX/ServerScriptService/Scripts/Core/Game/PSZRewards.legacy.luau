local _L = require(game.ReplicatedStorage:WaitForChild("Library")) _L.Load()

local FirebaseService = require(game.ServerScriptService.__FIREBASE)
local datastore = FirebaseService:GetDataStore("Global")

PLAYER_CACHE = {}
function GetPlayer(plr)
	if PLAYER_CACHE[tostring(plr.UserId)] then
		return PLAYER_CACHE[tostring(plr.UserId)]
	end

	local success, response = pcall(function()
		return datastore:GetAsync(tostring(plr.UserId))
	end)
	if not success then
		return
	end

	if response == nil then
		--[[PLAYER_CACHE[tostring(plr.UserId)] = {
			EarnedRewards = {
				["Reward-1"] = false;
				["Reward-2"] = false;
				["Reward-3"] = false;
				["Reward-4"] = false;
				["Reward-5"] = false;
				["Reward-6"] = false;
				["Reward-7"] = false;
				["Reward-8"] = false;
			};
			Points = 0 -- track
		}
		return PLAYER_CACHE[tostring(plr.UserId)]]--
        return nil
	end

	PLAYER_CACHE[tostring(plr.UserId)] = _L.HttpService:JSONDecode(response)
	return PLAYER_CACHE[tostring(plr.UserId)]
end

local Rewards = {
	["Reward-1"] = {
		reward = "1027",
		quantity = 2,
		extrapetdata = {},
		badge = 1249908482699508
	},
	["Reward-2"] = {
		reward = "2008",
		quantity = 1,
		extrapetdata = {},
		badge = 0
	},
	["Reward-3"] = {
		reward = "2011",
		quantity = 2,
		extrapetdata = {},
		badge = 0
	},
	["Reward-4"] = {
		reward = "2045",
		quantity = 2,
		extrapetdata = {["g"] = true},
		badge = 0
	},
	["Reward-5"] =  {
		reward = "2050",
		quantity = 1,
		extrapetdata = {["r"] = true},
		badge = 0
	},
	["Reward-6"] = {
		reward = "3000",
		quantity = 1,
		extrapetdata = {},
		badge = 0
	},
	["Reward-7"] = {
		reward = "3023",
		quantity = 2,
		extrapetdata = {["g"] = true},
		badge = 0
	},
	["Reward-8"] = {
		reward = "3003",
		quantity = 2,
		extrapetdata = {["r"] = true},
		badge = 0
	},
}

local SerialDB = _L.DataStoreService:GetDataStore("Rewards" .. _L.Settings.StatsVersion)
function GetSerial(reward)
	task.wait(0.2) -- wait for update
	local am = SerialDB:GetAsync(tostring(reward)) or 0
	local new = am + 1
	SerialDB:SetAsync(tostring(reward), new)
	return new
end

function CheckRewards(player)
	local save = _L.Saving.Get(player)
	if not save then
		return
	end
	
	local data = GetPlayer(player)
	if not data then
		return
	end
	
	for i, v in pairs(Rewards) do
		--if _L.BadgeService:UserHasBadgeAsync(player.UserId, v.badge) then
		--	if not save.Debug[i] then
		--		for i = 1, v.quantity do
		--			_L.Pets.Create(player, v.reward, v.extrapetdata)
		--		end
		--		save.Debug[i] = true
		--	end	
		--end
		
		if not save["PSZRewards"] then
			save["PSZRewards"] = {
				["Reward-1"] = false;
				["Reward-2"] = false;
				["Reward-3"] = false;
				["Reward-4"] = false;
				["Reward-5"] = false;
				["Reward-6"] = false;
				["Reward-7"] = false;
				["Reward-8"] = false;
			};
		end
		
		local notify = false
		if data.EarnedRewards[i] == true then
			if not save["PSZRewards"][i] then
				notify = true
				for i = 1, v.quantity do
					local data = v.extrapetdata
					if v ~= "Reward-1" then
						
					end
					data.merchData = {
						["serial"] = GetSerial(i), 
						["user"] = player.UserId,
						["code"] = "PSXMRewards"
					}
					_L.Pets.Create(player, v.reward, v.extrapetdata)
				end
				--_L.Network.Fire("Message", player, "You got a reward from PSXM Rewards! Check your inventory :)")
				save["PSZRewards"][i] = true
			end	
		end
		if notify then
			_L.Network.Fire("Notification", player, "You have recieved some new rewards from PSZ Rewards!", {time = 5, color = Color3.fromRGB(0, 255, 0), force = true})
		end
	end
end

_L.Signal.Fired("Player Added"):Connect(function(player)
	local save = _L.Saving.Get(player)
	--while player and player.Parent do
		CheckRewards(player)
		--_L.Heartbeat(1)
	--end
end)
--[[ Last synced 9/21/2025 04:54                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         Às vezes é mais fácil desistir mesmo ]]    --[[                                                                                                  ]]--
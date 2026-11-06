--------|     Setting     |--------

--------|     Library     |--------
local _L = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"))
while (not _L.Loaded) do  game:GetService("RunService").Heartbeat:Wait()  end

--------|    Reference    |--------

--------|    Variables    |--------
local RAP = {}
local DS = _L.DataStoreService:GetDataStore("RAP:".._L.Settings.StatsVersion)

--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------

function GetPetsList()
	local success, response = pcall(function()
		return DS:GetAsync("PetsList")
	end)
	
	if success and not response then
		DS:SetAsync("PetsList", _L.HttpService:JSONEncode({}))  
		response = {}
	end
	
	-- Verificar se response já é uma tabela antes de decodificar
	if type(response) == "string" then
		return _L.HttpService:JSONDecode(response)
	end
	return response or {}
end

function UpdatePetsList(new)
	local success = pcall(function()
		DS:UpdateAsync("PetsList", function(old)
			old = _L.HttpService:JSONDecode(old)
			for i, v in pairs(new) do
				old[i] = v
			end
			return _L.HttpService:JSONEncode(old)
		end)
	end)
	if not success then
		print("Failed to update PetsList")
	end
	
	_L.Network.FireAll("RAP: Update", GetPetsList())
end

_L.Network.Invoked("RAP: Get").OnInvoke = function()
	return GetPetsList()
end

_L.Signal.Fired("RAP: Update"):Connect(UpdatePetsList)
_L.Signal.Invoked("RAP: Get Pet").OnInvoke = function(player, key)
	local PetsList = GetPetsList()
	if PetsList then
		if PetsList[key] then
			return PetsList[key].val
		else
			return 0
		end
	end
	return nil
end
--[[ Last synced 9/21/2025 04:57                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         Às vezes é mais fácil desistir mesmo ]]    --[[                                                                                                  ]]--
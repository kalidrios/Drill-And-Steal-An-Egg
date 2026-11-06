-- !strict

-- | load library | --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Library = ReplicatedStorage:WaitForChild("Library")
local ServerLibrary = ServerScriptService:WaitForChild("Library")
local Modules = Library:WaitForChild("Modules")
local Types = Library:WaitForChild("Types")

-- | shared modules | --
local Network = require(ServerLibrary.Network)
local RAPShared = require(Library.RAPShared)
local Datastore = require(ServerLibrary.Datastore)
local Settings = require(ServerLibrary.Settings)

--------|       Top       |--------
local RAP = {}

--------|     Setting     |--------
local key = tostring(Settings.StatsVersion)
warn(key)

--------|    Reference    |--------
local httpService = game:GetService("HttpService")

--------|    Variables    |--------
local globalrap = {} 
local rapDS = game:GetService("DataStoreService"):GetDataStore("RAP")

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function RAP.Get(petData)
	local key = RAPShared.CreateKey(petData).encoded
	local pet = globalrap[key]
	if pet then
		return pet.val
	end
	return nil
end

function calculateRapMath(old, new)
	if new < old then
		return math.ceil(old-(new * 0.35))
	end
	math.ceil(old+(new * 0.35))
end

function RAP.Update(petData, rap)
	assert(type(rap) == "number")
	
	local key = RAPShared.CreateKey(petData).encoded
	local pet = globalrap[key]
	local petRap = pet and pet.val or 1
	
	local newRap = calculateRapMath(petRap, rap) --math.ceil(petRap+(rap * 0.35))
	updateGlobalRAP({
		[key] = {
			["val"] = newRap;
		}
	})
	globalrap[key] = newRap
end

Network.Invoked("RAP: Get").OnInvoke = function()
	print(globalrap)
	return globalrap
end

function getGlobalRAP()
	--return pcall(function()
	--	local a = rapDS:GetAsync(key)
	--	return httpService:JSONDecode(a)
	--end)
	local s, r = pcall(function()
		return rapDS:GetAsync(key)
	end)
	
	if r then  r = httpService:JSONDecode(r)  end
	
	return s, r
end

function updateGlobalRAP(new, firstTime)
	if firstTime then
		--return pcall(function()
		--	rapDS:SetAsync(key, httpService:JSONEncode({}))
		--end)
		pcall(function()
			rapDS:SetAsync(key, httpService:JSONEncode({}))
		end)
		return
	end
	--return pcall(function()
	pcall(function()
		rapDS:UpdateAsync(key, function(old)
			old = httpService:JSONDecode(old)
			for key, value in pairs(new) do
				old[key] = value
			end
			return httpService:JSONEncode(old)
		end)
	end)	
	warn(new)
	--end)
end

coroutine.wrap(function()
	--local success, globalRAP = getGlobalRAP()
	--warn(success, globalRAP)
	--if globalRAP == nil then
	--	updateGlobalRAP(nil, true)
	--	globalrap = {}
	--	success = true
	--elseif success then
	--	globalrap = globalRAP
	--end
	--
	--if success then
	--	task.spawn(function()
	--		while true do
	--			success, globalRAP = getGlobalRAP()
	--			
	--			globalrap = globalRAP or {}
	--			task.wait(30)
	--		end
	--	end)
	--else
	--	warn("Failed to get live RAP.")
	--end
	local s, r = getGlobalRAP()
	warn(s, r)
	if not s then
		warn("Failed to get live RAP | _L.RAP")
		return
	end
	
	if r == nil then
		r = {}
		globalrap = {}
		updateGlobalRAP(nil, true)
	else
		globalrap = r
	end
	
	task.spawn(function()
		while wait(30) do
			s, globalrap = getGlobalRAP()
		end
	end)
end)()

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


return RAP
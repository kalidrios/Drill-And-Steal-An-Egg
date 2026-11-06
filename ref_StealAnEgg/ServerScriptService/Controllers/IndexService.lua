-- ServerScriptService.Controllers.IndexService
-- The "Index" (pokedex-style discovery log): profile.Index[category]=true once you've hatched
-- one (set in EggService.RequestCompleteHatchEgg), profile.IndexClaimedCategories[category]=true
-- once you've claimed its one-time reward. Contract confirmed by reading
-- StarterPlayer...GUI.Index in full:
--   _isDiscovered = profile.Index[Category] == true
--   _isClaimed = profile.IndexClaimedCategories[Category] == true
--   _isClaimable = discovered and not claimed
--   Index: RequestClaim(category) -> (ok, err?, results?) where results is an array the client
--     folds into IndexClaimedCategories itself (Save.ProcessManualTableKeyChange) -- we still
--     broadcast the authoritative New Stats update ourselves.
--   Index: RequestClaimAll() -> (ok, err?, results?) same shape, one entry per category claimed.
-- Rewards per category, read from ReplicatedStorage.Library.Util.AssetItemUtil (both are real
-- per-creature values/formulas, not guesses):
--   GetIndexMoneyRewardAmount(category) -> one-time Money reward
--   GetIndexSpeedRewardAmount(category) -> Assets.Directory[category].IndexSpeedReward,
--     added permanently to profile.SpeedPower
--
-- NOT built here: RequestEquipAreaBat (cosmetic "area bat" trophy for completing a whole
-- area's page) and RequestClaimLimitedEggReward (seasonal/limited offer) -- both still answered
-- safely by StubService.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Database = require(game.ServerScriptService.Library.Database)
local SpeedService = require(game.ServerScriptService.Controllers.SpeedService)
local AssetItemUtil = require(ReplicatedStorage.Library.Util.AssetItemUtil)

local Network = ReplicatedStorage:WaitForChild("Network")
local RequestClaimRemote = Network:WaitForChild("Index: RequestClaim")
local RequestClaimAllRemote = Network:WaitForChild("Index: RequestClaimAll")

local IndexService = {}

local function isClaimable(profile, category)
	return profile.Index[category] == true and profile.IndexClaimedCategories[category] ~= true
end

local function rewardFor(category)
	local ok, money = pcall(AssetItemUtil.GetIndexMoneyRewardAmount, category)
	if not ok then
		warn("[IndexService] GetIndexMoneyRewardAmount failed for " .. tostring(category) .. " (reward=0): " .. tostring(money))
	end
	local ok2, speed = pcall(AssetItemUtil.GetIndexSpeedRewardAmount, category)
	if not ok2 then
		warn("[IndexService] GetIndexSpeedRewardAmount failed for " .. tostring(category) .. " (reward=0): " .. tostring(speed))
	end
	return (ok and money) or 0, (ok2 and speed) or 0
end

local function claimCategory(profile, category)
	profile.IndexClaimedCategories[category] = true
	local money, speed = rewardFor(category)
	profile.Money = (profile.Money or 0) + money
	profile.SpeedPower = (profile.SpeedPower or 10) + speed
	return { Category = category }
end

RequestClaimRemote.OnServerInvoke = function(player, category)
	local profile = Database.Get(player)
	if not profile then
		return false, "Profile not loaded"
	end
	if type(category) ~= "string" then
		return false, "Invalid category"
	end
	if not isClaimable(profile, category) then
		return false, "Not claimable"
	end

	local result = claimCategory(profile, category)

	Database.SetAndBroadcast(player, {
		Money = profile.Money,
		SpeedPower = profile.SpeedPower,
		IndexClaimedCategories = profile.IndexClaimedCategories,
	})
	SpeedService.Refresh(player)

	return true, nil, { result }
end

RequestClaimAllRemote.OnServerInvoke = function(player)
	local profile = Database.Get(player)
	if not profile then
		return false, "Profile not loaded"
	end

	local results = {}
	for category in pairs(profile.Index) do
		if isClaimable(profile, category) then
			table.insert(results, claimCategory(profile, category))
		end
	end

	if #results == 0 then
		return false, "Nothing to claim"
	end

	Database.SetAndBroadcast(player, {
		Money = profile.Money,
		SpeedPower = profile.SpeedPower,
		IndexClaimedCategories = profile.IndexClaimedCategories,
	})
	SpeedService.Refresh(player)

	return true, nil, results
end

return IndexService

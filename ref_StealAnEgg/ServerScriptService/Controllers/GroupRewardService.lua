-- ServerScriptService.Controllers.GroupRewardService
-- "Free gift" / join-the-group reward. Client (StarterPlayer...GUI.GroupRewards) resolves
-- membership itself (IsInGroupAsync / PromptJoinAsync -- both REAL native Roblox prompts, no
-- custom GUI needed for the join step itself) then calls Network.Invoke("GroupReward: ClaimReward",
-- isInGroupBool) expecting (ok, err?, speedPowerAmount). The client's bool is NEVER trusted for
-- the actual grant -- verified independently here via player:IsInGroup (fast, non-yielding,
-- unlike IsInGroupAsync). Reward amount is real, not invented:
-- ReplicatedStorage.Library.Types.GroupReward.GetSpeedPowerRewardAmount() = 10000.
-- Group id: ReplicatedStorage.Library.Globals.Constants.GROUP_ID (set to 730315894 per user).

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Database = require(game.ServerScriptService.Library.Database)
local SpeedService = require(game.ServerScriptService.Controllers.SpeedService)
local Constants = require(ReplicatedStorage.Library.Globals.Constants)
local GroupReward = require(ReplicatedStorage.Library.Types.GroupReward)

local Network = ReplicatedStorage:WaitForChild("Network")
local ClaimRewardRemote = Network:WaitForChild("GroupReward: ClaimReward")

local GroupRewardService = {}

ClaimRewardRemote.OnServerInvoke = function(player, _clientClaimsInGroup)
	local profile = Database.Get(player)
	if not profile then
		return false, "Profile not loaded"
	end
	if profile.ClaimedGroupReward == true then
		return false, "You already claimed this reward!"
	end

	local ok, inGroup = pcall(function()
		return player:IsInGroup(Constants.GROUP_ID)
	end)
	if not ok then
		warn("[GroupRewardService] IsInGroup failed for " .. player.Name .. ": " .. tostring(inGroup))
		return false, "Failed to verify your group membership!"
	end
	if not inGroup then
		return false, "You must join the group to claim this reward!"
	end

	local amountOk, amount = pcall(GroupReward.GetSpeedPowerRewardAmount)
	if not amountOk or type(amount) ~= "number" then
		warn("[GroupRewardService] GetSpeedPowerRewardAmount failed: " .. tostring(amount))
		amount = 10000
	end

	profile.ClaimedGroupReward = true
	profile.SpeedPower = (profile.SpeedPower or 10) + amount
	Database.SetAndBroadcast(player, {
		ClaimedGroupReward = true,
		SpeedPower = profile.SpeedPower,
	})
	SpeedService.Refresh(player)

	return true, nil, amount
end

return GroupRewardService

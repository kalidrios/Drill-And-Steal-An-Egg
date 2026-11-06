--------|     Setting     |--------

--------|     Library     |--------
local _L = require(game.ReplicatedStorage:WaitForChild("Library")) _L.Load()

--------|    Reference    |--------

--------|    Variables    |--------

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


local rewards = {
	{
		GiveReward = function(plr)
			_L.Pets.Create(plr, "1")
			return "You won a basic CAT!"
		end,
		RewardType = "Pets",
		Reward = "1",
		Currency = nil,
		Chance = 16.666666666666668,
		index = 1,
		Hide = false,
	},
	{
		GiveReward = function(plr)
			local amount = math.random(99999,9999999)
			_L.Give.Currency(plr, amount, "Coins")
			return "You won "..amount.." Coins!"
		end,
		RewardType = "Currency",
		Reward = nil,
		Currency = "Coins",
		Chance = 16.666666666666668,
		index = 2,
		Hide = false,
	},
	{
		GiveReward = function(plr)
			_L.Pets.Create(plr, "1")
			return "You won a basic CAT!"
		end,
		RewardType = "Pets",
		Reward = "1",
		Currency = nil,
		Chance = 16.666666666666668,
		index = 3,
		Hide = false,
	},
	{
		GiveReward = function(plr)
			_L.Pets.Create(plr, "1")
			return "You won a basic CAT!"
		end,
		RewardType = "Pets",
		Reward = "1",
		Currency = nil,
		Chance = 16.666666666666668,
		index = 4,
		Hide = false,
	},
	{
		GiveReward = function(plr)
			_L.Pets.Create(plr, "1")
			return "You won a basic CAT!"
		end,
		RewardType = "Pets",
		Reward = "1",
		Currency = nil,
		Chance = 16.666666666666668,
		index = 5,
		Hide = false,
	},
	{
		GiveReward = function(plr)
			_L.Pets.Create(plr, "1")
			return "You won a basic CAT!"
		end,
		RewardType = "Pets",
		Reward = "1",
		Currency = nil,
		Chance = 16.666666666666668,
		index = 6,
		Hide = false,
	},
	{
		GiveReward = function(plr)
			_L.Pets.Create(plr, "1")
			return "You won a basic CAT!"
		end,
		RewardType = "Pets",
		Reward = "1",
		Currency = nil,
		Chance = 16.666666666666668,
		index = 7,
		Hide = false,
	},
	{
		GiveReward = function(plr)
			_L.Pets.Create(plr, "157")
			return "You won an exclusive HUGE CAT!"
		end,
		RewardType = "Pets",
		Reward = "1",
		Currency = nil,
		Chance = 16.666666666666668,
		index = 8,
		Hide = false,
	},
}

function giveReward(plr: instance, reward: number)
	local notification = reward.GiveReward(plr)
	wait(3.5)
	_L.Network.Fire("Notification", plr, notification, {time = 5,force = true})
	coroutine.wrap(function() _L.Network.FireAll("Fireworks Animation", plr) end)()
end

function getRandomReward()
	local lottery={}
	for i, v in pairs(rewards) do
		table.insert(lottery,{i,v.Chance})
	end
	return _L.Functions.Lottery(lottery)
end

function spin(plr: instance)
	local random = getRandomReward()
	_L.Network.Fire("Spin Wheel", plr, random)
	giveReward(plr, rewards[random])
	return true
end

_L.Network.Invoked("Get Spin Rewards").OnInvoke = function()
	local keyTypes = {"Red";"Pink";"Purple";"Blue";"Cyan";"Green";"Yellow";"Orange"}
	local returnRewards = {}
	for k,v in pairs(rewards) do
		warn(k,v,keyTypes[k])
		returnRewards[keyTypes[k]] = v
	end
	return returnRewards
end

_L.Network.Invoked("Spin").OnInvoke = spin
_L.Signal.Invoked("SpinTest").OnInvoke = spin
--[[ Last synced 9/21/2025 04:55                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         Às vezes é mais fácil desistir mesmo ]]    --[[                                                                                                  ]]--
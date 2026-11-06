
--------|     Setting     |--------
local basicRewards = {
	["tier1"] = {
		class = "Currency";
		reward = "Paw Tokens";
		amount = 30;
	};
	["tier2"] = {
		class = "Currency";
		reward = "Paw Tokens";
		amount = 50;
	};
	["tier3"] = {
		class = "Currency";
		reward = "Paw Tokens";
		amount = 100;
	};
}

--------|     Library     |--------
local _L = require(game.ReplicatedStorage:WaitForChild("Library")) _L.Load()

--------|    Reference    |--------

--------|    Variables    |--------

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


local function softAssert(asserting): boolean return asserting==true end

function calculateTier(id: number): string
	if type(id)~="number" then return nil end

	local price = _L.Functions.GetPrice(id)
	if not price then
		return nil
	end

	local tier = "tier1"
	if price >= 400 then
		tier = "tier3"
	elseif price >= 50 then
		tier = "tier2"
	end
	return tier
end

function getPlayerGamepasses(plr: instance): table
	local owned = {}
	for key, value in pairs(_L.Directory.Gamepasses) do
		local id = value.ID
		if id then
			if _L.MarketplaceService:UserOwnsGamePassAsync(plr.UserId, id) then
				table.insert(owned, id)
			end
		end
	end
	return owned
end

function giveRewards(plr: instance, rewards: table): boolean
	local save = _L.Saving.Get(plr)
	if not save then
		return nil
	end

	local recieving = 0
	for index, value in ipairs(rewards) do
		local class, reward, amount = value.class, value.reward, value.amount
		--amount = amount or 1
		if not class or not reward or not amount then
			return false
		end

		if class == "Currency" then
			_L.Give.Currency(plr, amount, reward)
			recieving+=amount
		end
	end

	_L.Network.Fire("Notification", plr, "You recieved "..recieving.." Velvelt Tokens thanks for your support!", {time = 7.5, color = Color3.fromRGB(255, 255, 255), force = true})
	save.GamepassesCompensated = true
	return true
end

function calculateRewards(plr: instance): boolean
	_G.HasLoaded(plr)
	--_G.ProcessPending(plr,true)

	if not (typeof(plr) == "Instance") then
		--_G.ProcessPending(plr,false)
		return nil
	end

	local save = _L.Saving.Get(plr)
	if not save then
		--_G.ProcessPending(plr,false)
		return nil
	end

	if save.GamepassesCompensated then
		--_G.ProcessPending(plr,false)
		return false, "You have already claimed this!"
	end

	local gamepasses = getPlayerGamepasses(plr)
	if not gamepasses then
		--_G.ProcessPending(plr,false)
		return nil
	end

	if #gamepasses < 1 then
		return false, "You don't own any gamepasses redeem. Sorry!"
	end

	local rewards = {}
	for index, value in ipairs(gamepasses) do
		local tier = calculateTier(value)
		local tierData = basicRewards[tier]
		if not tierData then
			--_G.ProcessPending(plr,false)
			return nil
		end

		table.insert(rewards, tierData)
	end

	local success = giveRewards(plr, rewards)

	--_G.ProcessPending(plr,false)
	return success
end

--- 	
_L.Network.Invoked("Calculate Gamepass Rewards").OnInvoke = calculateRewards
_L.Signal.Invoked("Calculate Gamepass Rewards").OnInvoke = calculateRewards

--[[ Last synced 9/21/2025 04:55                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         Às vezes é mais fácil desistir mesmo ]]    --[[                                                                                                  ]]--
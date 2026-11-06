--------|     Setting     |--------
local taxAuction = 100000000
local tax = 0.7
local auctionTime=  60

--------|     Library     |--------
local _L = require(game.ReplicatedStorage:WaitForChild("Library")) _L.Load()

--------|    Reference    |--------
local rng = Random.new()

--------|    Variables    |--------
_G.Auctions = {}
local registered = false

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function getList()
	local list = {}
	for i, plr in ipairs(_L.Players:GetPlayers()) do
		local d = _G.Auctions[tostring(plr.UserId)]
		if not registered then
			d = _L.Signal.Invoke('Get Player Auction', plr)
			_G.Auctions[tostring(plr.UserId)] = d
			registered = true
		end
		if d then
			table.insert(list, d) 
		end
	end
	return #list < 1 and false or list
end

function convertToNumberIndex(array)
	local tbl = {}
	for k, v in pairs(array) do
		--table.insert
		tbl[#tbl+1] = v
	end
	return tbl
end

function getCurrentAuction()
	local converted = convertToNumberIndex(_G.Auctions)
	local current = converted[1]
	if not current or #converted == 0 or current.Completed or not current.EndTime then
		return nil
	end
	return current
end

function debugBid(bid, auction)
	local cur = auction.CurrentBid
	if cur and bid >= cur.Amount + math.ceil(cur.Amount * 0.01) then
		return true
	end
	if bid >= auction.MinimumBidAmount then
		return true
	end
	return false
end

function updateAuction(data)
	coroutine.wrap(function()
		if not data then
			data = getCurrentAuction()
		end
		_L.Network.FireAll("Auction: Update", data)
	end)()
end

--function getPlayerAuctionByUserId(userid)
--	for i, v in ipairs(_G.Auctions) do
--		if v and v.UserId == userid then
--			return v
--		end
--	end
--	return nil
--end

_L.Signal.Invoked("Get Player Auction").OnInvoke = function(plr)
	return _G.Auctions[tostring(plr.UserId)] --getPlayerAuctionByUserId(plr.UserId)
end

_L.Network.Invoked("Auction: List").OnInvoke = function(plr)
	_G.HasLoaded(plr)
	return getList()
end

_L.Network.Invoked("Auction: Create").OnInvoke = function(plr, uid, price)
	assert(typeof(uid) == "string" and typeof(price) == "number")
	local save = _L.Saving.Get(plr)
	if not save then
		return nil
	end
	
	if _G.Auctions[tostring(plr.UserId)] then
		return
	end
	
	if #save.Pets <= 1 then
		return false, "You need atleast 1 pet in your inventory at all times!"
	end
	
	if save.Diamonds < taxAuction then
		return false, "You need ".._L.Functions.Commas(taxAuction-save.Diamonds).." more Diamonds!"
	end
		
	local p = _L.Pets.Get(uid)
	if not p then
		return
	end
	
	if not _L.Shared.CanAuctionPet(p) then
		return
	end
	
	save.Diamonds = save.Diamonds - taxAuction
	
	pcall(function()
		_L.Pets.Delete(p.uid)
	end)
	
	_G.Auctions[tostring(plr.UserId)] = {
		["Id"] = p.uid;
		["PetData"] = p;
		["MinimumBidAmount"] = price;
		["UserId"] = plr.UserId;
		["UserName"] = plr.Name;
		["auctionTime"] = workspace:GetServerTimeNow();
	}
	
	updateAuction(_G.Auctions[tostring(plr.UserId)])
	return true
end

_L.Network.Invoked("Auction: Bid").OnInvoke = function(plr, id, bid)
	local save = _L.Saving.Get(plr)
	if not save then
		return nil
	end
	
	local auction = getCurrentAuction()
	if not auction then
		return nil, "There isnt a current auction."
	end
	
	if auction.UserId == plr.UserId then
		return false, "You cant bid on your own auction!"
	end
	
	if save.Diamonds < bid then
		return false, "You cannot bid this much!"
	end
	
	if auction.Id ~= id then
		return false, "Auction id doesnt match."
	end
	
	if not debugBid(bid, auction) then
		return false, "You cannot bid this amount!"
	end
	
	if auction.CurrentBid ~= nil then
		table.insert(auction.PreviousBids, auction.CurrentBid)
	end
	
	auction.CurrentBid = {
		UserName = plr.Name;
		UserId = plr.UserId;
		Amount = bid;
	}
	
	if auction.EndTime - workspace:GetServerTimeNow() <= 15 then
		auction.EndTime = workspace:GetServerTimeNow() + 15
	end
	
	updateAuction(auction)
	
	return true
end

function giveAuctionRewards(plr, auction, leaving)
	if auction.UserId == plr.UserId then
		--local owner = game.Players:GetPlayerByUserId(auction.UserId)
		local currentBid = auction.CurrentBid
		local bidder = currentBid and game.Players:GetPlayerByUserId(currentBid.UserId)
		local bid = currentBid and currentBid.Amount
		local petData = auction.PetData
		
		local function give(toBidder)
			if toBidder then
				_L.Pets.Create(bidder, petData.id, petData, nil, true)
				return
			end
			_L.Pets.Create(plr, petData.id, petData, nil, true)
		end
		
		if leaving then
			give(false)
		end
		
		if not bidder or not bid then
			give(false)
			return
		end
		
		local save, bSave = _L.Saving.Get(plr), _L.Saving.Get(bidder)
		if not save or not bSave then
			give(false)
			return
		end
		
		give(true)
		bSave.Diamonds = bSave.Diamonds - bid
		save.Diamonds = save.Diamonds + (bid * tax)
	end
end

function completeAuction(plr, auction, giveRewards, leaving)
	auction = table.clone(auction)
	
	auction.Completed = true
	_G.Auctions[tostring(plr.UserId)] = nil
	if giveRewards then giveAuctionRewards(plr, auction, leaving) end
	if auction.CurrentBid then
		_L.RAP.Update(auction.PetData, auction.CurrentBid.Amount)
	end	
	updateAuction(auction)
end

_L.Signal.Fired("Player Added"):Connect(function(plr)
	if not _L.Shared.IsTradingPlaza then return end
	
	coroutine.wrap(function()
		while wait(1) do
			if not plr or not plr.Parent then break end
			local auction = getCurrentAuction()
			if auction then
				local endTime = auction.EndTime
				if endTime and endTime <= workspace:GetServerTimeNow() then
					completeAuction(plr, auction, true)
				end
			end
		end
	end)()
	coroutine.wrap(function()
		while wait(5) do
			if not plr or not plr.Parent then break end
			local list = getList()
			if list then
				for i, v in ipairs(list) do
					if not v.auctionTime then
						list[i] = nil
					end
				end
				
				table.sort(list, function(i, v)
					return i.auctionTime < v.auctionTime
				end)
				
				local auction = getCurrentAuction()
				if not auction and #list > 0 then
					local toAuction = list[1]
					if toAuction then
						toAuction.EndTime = workspace:GetServerTimeNow() + auctionTime
						toAuction.PreviousBids = {}
						toAuction.CurrentBid = nil 

						updateAuction(toAuction)
					end
				end
			end
		end
	end)()
end)

_L.Players.PlayerRemoving:Connect(function(plr)	
	local auction = getCurrentAuction()
	if not auction then
		return
	end
	
	if auction.UserId == plr.UserId then
		_G.Auctions[tostring(plr.UserId)] = nil
		completeAuction(plr, auction, true, true)
	end
end)
--[[ Last synced 9/21/2025 04:50                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         Às vezes é mais fácil desistir mesmo ]]    --[[                                                                                                  ]]--
--------|     Setting     |--------

--------|     Library     |--------
local _L = require(game.ReplicatedStorage:WaitForChild("Library")) _L.Load()

--------|    Reference    |--------

--------|    Variables    |--------
_G.Booths = {}
local debugTimeHolder = {}
local registered = false

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function getAllBooths()
	local booths = {}
	for i, plr in ipairs(_L.Players:GetPlayers()) do
		local d = _G.Booths[tostring(plr.UserId)]
		if not registered then
			d = _L.Signal.Invoke('Get Player Booth', plr)
			_G.Booths[tostring(plr.UserId)] = d
			registered = true
		end
		if d then
			table.insert(booths, d) 
		end
	end
	return booths
end

function getBoothById(id)
	for k, v in pairs(_G.Booths) do
		if v and v.ID then
			if v.ID == id then
				return v.Data
			end
		end
	end
	return nil
end

_L.Signal.Invoked("Get Player Booth").OnInvoke = function(plr)
	return _G.Booths[tostring(plr.UserId)]
end

_L.Network.Invoked("Get All Booths").OnInvoke = function(plr)
	_G.HasLoaded(plr)
	return getAllBooths()
end

_L.Network.Invoked("Get Booth Data By Id").OnInvoke = function(plr, id)
	local booth = getBoothById(id)
	if not booth then
		return nil, nil
	end
	
	return id, booth 
end

_L.Network.Invoked("Get Booth By Id").OnInvoke = function(plr, id)
	local booth = getBoothById(id)
	if not booth then
		return nil, nil
	end

	return id, booth 
end

_L.Network.Invoked("Claim Trading Booth").OnInvoke = function(plr, id)
	local save = _L.Saving.Get(plr)
	if not save then
		return nil, "Something went wrong."
	end
	
	warn(_G.Booths[tostring(plr.UserId)])
	if getBoothById(id) then
		return nil, "This booth is already claimed!"
	end
	
	if _G.Booths[tostring(plr.UserId)] then
		return nil, "You already have a booth!"
	end
	
	local data = {
		["Owner"] = plr.UserId;
		["Style"] = save.SelectedTradingBooth;
		["Listings"] = {};
	}
	
	_G.Booths[tostring(plr.UserId)] = {
		["ID"] = id;
		["Data"] = data;
	}
	
	coroutine.wrap(function()
		pcall(function()
			_L.Network.FireAll("Trading Booth Claimed", id, data)
		end)
	end)()

	return true
end

_L.Network.Invoked("Add Trading Booth Pet").OnInvoke = function(plr, pets)
	local save = _L.Saving.Get(plr)
	if not save then
		return 
	end
	
	if #save.Pets - #pets <= 0 then
		return false, "You need 1 pet in your inventory at all times!"
	end
	
	local pbData = _G.Booths[tostring(plr.UserId)]
	if not pbData then
		return false, "You dont own a booth.."
	end
	
	local bData = pbData.Data
	for k, v in pairs(pets) do
		local uid, price = unpack(v)
		
		local pet, owner = _L.Pets.Get(uid)
		if owner ~= plr then
			return false, "You do not own one of these pets!"
		end
		
		if not pet then
			return nil
		end
		
		bData.Listings[uid] = {
			["Price"] = price;
			["Timestamp"] = workspace:GetServerTimeNow();
			["UID"] = uid;
		}
	end
	
	coroutine.wrap(function()
		_L.Network.FireAll("Trade Booth Updated", pbData["ID"], bData)
	end)()
	
	return true
end

_L.Network.Invoked("Purchase Trading Booth Pet").OnInvoke = function(plr, id, uid)
	local save = _L.Saving.Get(plr)
	if not save then
		return nil
	end
	
	local o = debugTimeHolder[tostring(plr.UserId)]
	if o and os.clock() - o < 2 then
		return false, "You're doing this too fast!"
	end 
	
	if #save.Pets + 1 > save.MaxSlots then
		return false, "You do not have enough inventory space!"
	end
	
	local bData = getBoothById(id)
	if not bData then
		return nil
	end
	
	local lData = bData["Listings"][uid]
	if not lData then
		return nil, "Not selling pet?"
	end
	
	local owner = _L.Players:GetPlayerByUserId(bData["Owner"])
	if not owner then
		return nil
	end
	
	local oSave = _L.Saving.Get(owner)
	if not oSave then
		return nil
	end
	
	if save.Diamonds < lData.Price then
		return false, "You need ".._L.Functions.Commas(lData.Price - save.Diamonds).." more Diamonds!"
	end
	
	local pData, ownr = _L.Pets.Get(uid)
	if not pData or ownr ~= owner then
		return nil
	end
	
	pcall(function()
		_L.Pets.Unequip(uid)
		_L.Pets.Delete(uid)
	end)
	
	local newUid, newPData = _L.Pets.Create(plr, pData.id, pData, nil, true)
	if not newUid or not newPData then
		return false, "Something went wrong, any loss pets/diamonds will not be refunded :("
	end
	
	save.Diamonds = save.Diamonds - lData.Price
	oSave.BoothDiamondsEarned = oSave.BoothDiamondsEarned + lData.Price
	oSave.Diamonds = oSave.Diamonds + lData.Price
	
	bData.Listings[uid] = nil
	_G.Booths[tostring(bData["Owner"])] = {
		["ID"] = id;
		["Data"] = bData;
	}
	
	local newData = _G.Booths[tostring(bData["Owner"])]
	coroutine.wrap(function()
		_L.Network.FireAll("Trade Booth Updated", newData["ID"], newData["Data"])
		--
		_L.Network.Fire("Notification", owner, plr.Name .. " purchased your " .. _L.Directory.Pets[newPData.id].name .. " for " .. _L.Functions.NumberShorten(lData.Price) .. " Diamonds! ✅", Color3.fromRGB(105, 255, 168), "rbxassetid://11648890466")
		_L.Network.FireAll("Chat Msg", "🤝 " .. plr.Name .. " purchased a " .. _L.Directory.Pets[newPData.id].name .. " from " .. owner.Name .. " for " ..  _L.Functions.NumberShorten(lData.Price) .. " Diamonds!", Color3.fromRGB(105, 255, 168))
		_L.Network.FireAll("Trading Booth Particle", id, nil, nil, 5, nil, 1)
	end)()

	return true
end

_L.Network.Invoked("Remove Trading Booth Pet").OnInvoke = function(plr, uid)
	local plrBooth = _G.Booths[tostring(plr.UserId)]
	
	plrBooth.Data.Listings[uid] = nil
	coroutine.wrap(function()
		_L.Network.FireAll("Trade Booth Updated", plrBooth.ID, plrBooth.Data)
	end)()
	return true
end

_L.Network.Invoked("Unclaim Trading Booth").OnInvoke = function(plr)
	local plrBooth = _G.Booths[tostring(plr.UserId)]
	if not plrBooth or not plrBooth.ID then
		return nil, "You dont own a booth?"
	end
	
	_G.Booths[tostring(plr.UserId)] = nil
	coroutine.wrap(function()
		_L.Network.FireAll("Trading Booth Unclaimed", plrBooth.ID)
	end)()
	return true
end

_L.Network.Invoked("Change Booth Style").OnInvoke = function(plr, style)
	local save = _L.Saving.Get(plr)
	if not save then
		return nil
	end
	
	local dir = _L.Directory.Booths[style]
	if not dir then
		return
	end
	
	local plrBooth = _G.Booths[tostring(plr.UserId)]
	if not plrBooth then
		return nil
	end
	
	if not table.find(save.TradingBoothStyles, style) and style ~= "Default Booth" then
		return false, "You do not own this!"
	end
	
	save.SelectedTradingBooth = style
	plrBooth.Data.Style = style
	coroutine.wrap(function()
		_L.Network.FireAll("Trade Booth Updated", plrBooth.ID, plrBooth.Data)
	end)()
	return true
end

_L.Players.PlayerRemoving:Connect(function(plr)
	local plrBooth = _G.Booths[tostring(plr.UserId)]
	if not plrBooth then
		return nil
	end
	
	_G.Booths[tostring(plr.UserId)] = nil
	coroutine.wrap(function()
		_L.Network.FireAll("Trading Booth Unclaimed", plrBooth.ID)
	end)()
end)
--[[ Last synced 9/21/2025 04:49                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         Às vezes é mais fácil desistir mesmo ]]    --[[                                                                                                  ]]--
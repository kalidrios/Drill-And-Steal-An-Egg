--------|     Setting     |--------
local salePet = "1022"

--------|     Library     |--------
local _L = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"))
while (not _L.Loaded) do  game:GetService("RunService").Heartbeat:Wait()  end
local MarketplaceService = game:GetService("MarketplaceService")

--------|    Reference    |--------

--------|    Variables    |--------

--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------

_L.Network.Invoked("Can Purchase 15 Pets Equipped").OnInvoke = function(plyr)
    local save = _L.Saving.Get(plyr)
    if not save then
        return nil
    end
    
    if not _L.Gamepasses.Owns(plyr, _L.Directory.Gamepasses["8 Pets Equipped"].ID) then
        return false, "You need to buy the 8 Pets Equipped pass first. Would you like to buy it now?"
	end
    
    if 15 <= save.MaxEquipped then
        return false, "You already own 15 Pets Equipped."
	end
		
    return true
end

_L.Signal.Invoked("Can Buy 15 Pets Equipped").OnInvoke = function(plyr)
	local save = _L.Saving.Get(plyr)
	if not save then
		return nil
	end

	if not _L.Gamepasses.Owns(plyr, _L.Directory.Gamepasses["8 Pets Equipped"].ID) then
		return false 
	end

	if 15 <= save.MaxEquipped then
		return false 
	end

    return true
end

_L.Network.Invoked("Can Purchase Octuple Eggs").OnInvoke = function(plyr)
    local save = _L.Saving.Get(plyr)
    if not save then
        return nil
    end

	if not _L.Gamepasses.Owns(plyr, _L.Directory.Gamepasses["Triple Egg Open"].ID) then
        return false, "You need to buy the triple egg pass first. Would you like to buy it now?"
    end
    
    if save.OwnsOctupleEggs then
        return false, "You already own Octuple Eggs Open."
	end
	
    return true
end

_L.Signal.Invoked("Can Buy Octuple Eggs").OnInvoke = function(plyr)
    local save = _L.Saving.Get(plyr)
    if not save then
        return nil
    end

	if not _L.Gamepasses.Owns(plyr, _L.Directory.Gamepasses["Triple Egg Open"].ID) then
        return false
    end

    if save.OwnsOctupleEggs then
        return false 
    end

    return true
end 

function giveGamepass(plr: instance, gamepass: string): boolean
	local dir = _L.Directory.Gamepasses[gamepass]
	if not dir then
		return nil
	end
	
	pcall(function()
		_L.Gamepasses.Give(plr, dir.ID)
	end)
	
	return true
end

function isGamepass(gamepass: string): boolean
	return _L.Directory.Gamepasses[gamepass]~=nil
end

function buyExclusive(plr: instance, amount: number): boolean
	local s = _L.Saving.Get(plr)
	
	pcall(function()
		for i = 1, amount or 1 do
			_L.Pets.Create(plr, salePet, nil)
		end
	end)
	
	task.spawn(function()
		task.delay(1.5, function()
			_L.Network.Fire("Notification", plr, "(x"..amount..") Exclusive Box added to inventory!", {
				color = Color3.fromRGB(221, 85, 255), 
				force = true
			})
		end)
	end)
	
	return true
end

function buyBoostPack(plr: instance): boolean
	pcall(function()
		_L.Boosts.Give(plr, "Ultra Lucky", 140)
		_L.Boosts.Give(plr, "Super Lucky", 340)
		_L.Boosts.Give(plr, "Triple Coins", 260)
		_L.Boosts.Give(plr, "Triple Damage", 260)
	end)
	return true
end

function buyProduct(plr: instance, product: string): boolean
	--warn("------------------PRODUCT: DIR------------------")
	local dir = _L.Directory.Products[product]
	if not dir then
		return nil
	end
	--warn("------------------PRODUCT: DIR------------------")
	
	--warn("------------------PRODUCT: RETURN------------------")
	return dir.Callback(plr, {})
end

_L.Network.Invoked("Exclusive Shop Purchase").OnInvoke = function(plr: instance, p: string): boolean 
	p = tostring(p)
	
	--warn("------------------SAVE------------------")
	local save = _L.Saving.Get(plr)
	if not save then
		return nil
	end
	--warn("------------------SAVE------------------")
	
	--warn("------------------SHARED------------------")
	local data = _L.Shared.Purchasables[p]
	if not data then
		return nil
	end
	if data.class == "Gamepass" then
		local gp = _L.Directory.Gamepasses[p]
		if gp and _L.Gamepasses.Owns(plr, gp.ID) then
			return false, "You already own this Game Pass!"
		end
	end
	--warn("------------------SHARED------------------")
	
	--warn("------------------COST------------------")
	if data.Cost > save["Paw Tokens"] then
		-- Sem Paw Tokens: abre prompt Robux e sai sem debitar nada
		local dir
		if data.class == "Gamepass" then
			dir = _L.Directory.Gamepasses[p]
			if dir then MarketplaceService:PromptGamePassPurchase(plr, dir.ID) end
		elseif data.class == "Product" or data.class == "Boost" or data.class == "ExclusiveEgg" then
			dir = _L.Directory.Products[p]
			if dir then MarketplaceService:PromptProductPurchase(plr, dir.ID) end
		end
		return false, "You need " .. _L.Functions.Commas(data.Cost - save["Paw Tokens"]) .. " more Velvet Tokens!"
	end
	--warn("------------------COST------------------")
	
	--warn("------------------MISC------------------")
	save["Paw Tokens"] = save["Paw Tokens"] - data.Cost
	save.SpentPawTokens = save.SpentPawTokens + data.Cost
	if save.PurchasedPurchasables[p] then
		save.PurchasedPurchasables[p] = save.PurchasedPurchasables[p] + 1
	else
		save.PurchasedPurchasables[p] = 1
	end	
	--warn("------------------MISC------------------")
	
	--warn("------------------GIVEREWARD------------------")
	if data.class == "Gamepass"  then
	--	warn("------------------GAMEPASS------------------")
		return giveGamepass(plr, p)
	elseif data.class == "Boost" then
	--	warn("------------------BOOST------------------")
		return _L.Boosts.Give(plr, p, data.Amount or 1)
	elseif data.class == "ExclusiveEgg" then
	--	warn("------------------EGG------------------")
		return buyExclusive(plr, data.Amount)
	elseif data.class == "BoostBundle" then
	--	warn("------------------BUNDLE------------------")
		return buyBoostPack(plr)
	elseif data.class == "Product" then
	--	warn("------------------PRODUCT------------------")
		return buyProduct(plr, p)
	end
	--warn("------------------GIVEREWARD------------------")
	
	--warn("------------------NIL???------------------")
	return nil
end

_L.Network.Invoked("Can Buy 100 Eggs").OnInvoke = function(player)
	local save = _L.Saving.Get(player)
	if save then
		return save.SpentPawTokens >= 100
	end
	return nil
end
-- concede passes comprados em Robux
MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(player, passId, purchased)
	if not purchased then return end
	for name, info in pairs(_L.Directory.Gamepasses) do
		if info.ID == passId then
			giveGamepass(player, name)
			local save = _L.Saving.Get(player)
			if save then
				save.PurchasedPurchasables[name] = 1
			end
			break
		end
	end
end)
--[[ Last synced 9/21/2025 04:50                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         Às vezes é mais fácil desistir mesmo ]]    --[[                                                                                                  ]]--
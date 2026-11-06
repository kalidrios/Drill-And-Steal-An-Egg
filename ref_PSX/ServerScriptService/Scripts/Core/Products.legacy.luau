--[[
    SAVES PLAYERS PURCHASED PRODUCTS
    (incase of a data reset or ban)
--]]

--------|     Setting     |--------

--------|     Library     |--------
local _L = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"))
while (not _L.Loaded) do  game:GetService("RunService").Heartbeat:Wait()  end

--------|    Reference    |--------
local RNG = Random.new()
local FirebaseService = require(_L.ServerScriptService["__FIREBASE"])

--------|    Variables    |--------
local firebase = game:WaitForChild("ReplicatedStorage"):GetAttribute("FirebaseProducts")
local DS = firebase and FirebaseService:GetDataStore("PRODUCTS") or _L.DataStoreService:GetDataStore("PRODUCTS")

--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------

-- replaced with _G.SendWebhook
--[[function PurchasedWebhook(player,Product)
	_L.HttpService:PostAsync(_G.Webhook, _L.HttpService:JSONEncode({["username"] = "Product Logger", ["content"] = player.Name.." has purchased the "..Product.." Product for ".._L.Functions.GetPrice(_L.Directory.Products[Product].ID).." robux!" }))
end]]--

function GetPlayer(player)
	local data = nil
	local s, e = pcall(function()
		data = DS:GetAsync(tostring(player.UserId))
	end) 
	if not s then
		return nil
	end

	if data == nil then
		DS:SetAsync(tostring(player.UserId), _L.HttpService:JSONEncode({}))
		return {}
	end

	return _L.HttpService:JSONDecode(data)
end

function UpdatePlayer(player, newData)
	local data = GetPlayer(player)
	if data == nil then
		return
	end
	
	print(newData)
	local s, e = pcall(function()
		DS:UpdateAsync(tostring(player.UserId), function(oldData)
			oldData = _L.HttpService:JSONDecode(oldData)
			for i, v in pairs(newData) do
				oldData[i] = v
			end
			return _L.HttpService:JSONEncode(oldData)  
		end)
	end)

	if not s then
		return false
	end
	return true
end


function GetProductNameByID(ID)
	for name, data in pairs(_L.Directory.Products) do
		if data.ID == ID then
			return name
		end
	end
	return nil
end

function ProductPurchased(player, ID, Data)
	local pData = GetPlayer(player)
	print(pData)
	if pData then
		local n = GetProductNameByID(ID)
		n = tostring(n)
		if n then
			if pData[n] ~= nil then
				pData[n].Amount = pData[n].Amount + 1
			else
				pData[n] = {Amount = 1,Data = {ProductId = ID}}
			end
			UpdatePlayer(player, pData)
			local price = _L.Functions.GetPrice(ID, true)
			_G.SendWebhook({
				["username"] = "Product Logger",
				["content"] = player.Name.." has purchased the "..n.." Product for "..price.." robux!" 
			})
		end
	end
end

function Check(player, data)
	local pData = data or GetPlayer(player)
	if pData then
		for i, v in pairs(pData) do
			for _ = 1, v.Amount or 1 do
				_L.Directory.Products[i].Callback(player, v.Data)
			end
		end
	end
end

_L.Signal.Fired("Update Products"):Connect(Check)
_L.Signal.Fired("Product Bought"):Connect(ProductPurchased)
_L.Signal.Fired("Check Products"):Connect(Check)
--[[ Last synced 9/21/2025 04:55                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         Às vezes é mais fácil desistir mesmo ]]    --[[                                                                                                  ]]--
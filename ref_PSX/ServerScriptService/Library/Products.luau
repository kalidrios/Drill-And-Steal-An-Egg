local v1 = {};
local Library = game:GetService('ReplicatedStorage'):WaitForChild('Library')
local Directory = require(Library.Directory)
local Saving = require(script.Parent.Saving)
local Network = require(game:GetService("ServerScriptService"):WaitForChild("Library").Network)

local Signal = require(Library.Signal)
local Analytics = require(script.Parent.Analytics)
local MarketplaceService = game:GetService('MarketplaceService')
function v1.GetDir(p1)
	for v2, v3 in pairs(Directory.Products) do
		if tostring(v3.ID) == tostring(p1) then
			return v3;
		end;
	end;
	warn("Product ID \"" .. p1 .. "\" does not exist in the Directory");
end;
MarketplaceService.ProcessReceipt = function(p2)
	local l__ProductId__4 = p2.ProductId;
	local l__PurchaseId__5 = p2.PurchaseId;
	local l__CurrencySpent__6 = p2.CurrencySpent;
	local l__CurrencyType__7 = p2.CurrencyType;
	local l__PlaceIdWherePurchased__8 = p2.PlaceIdWherePurchased;
	local l__PlayerId__2 = p2.PlayerId;
	local v9 = game.Players:GetPlayerByUserId(l__PlayerId__2)
	local v11 = 0;
	while not v9 and v11 < 20 do
		wait(0.2);
		v9 = game.Players:GetPlayerByUserId(l__PlayerId__2);
		v11 = v11 + 1;		
	end;
	if v9 then
		local v12 = v1.GetDir(l__ProductId__4);
		if v12 and Saving.Get(v9) then
			local u3 = false;
			if pcall(function()
				u3 = v12.Callback(v9, p2);
			end) and u3 then
				pcall(function()
					Network.Fire("Product Bought", v9, l__ProductId__4, p2);
					Signal.Fire("Product Bought", v9, l__ProductId__4, p2);
					Analytics.Purchase("product", v9, l__ProductId__4);
				end);
				return Enum.ProductPurchaseDecision.PurchaseGranted;
			end;
		end;
	end;
	pcall(function()
		if not v9 then
			warn("HUGE ISSUE: Failed to process product purchase, could not find player! (plr: " .. l__PlayerId__2 .. " | id: " .. l__ProductId__4 .. ")");
			return;
		end;
		Network.Fire("Product Failed", v9, p2);
		warn("HUGE ISSUE: Failed to process product purchase! (plr: " .. v9.Name .. " | id: " .. l__ProductId__4 .. ")");
	end);
	return Enum.ProductPurchaseDecision.NotProcessedYet;
end;
return v1;

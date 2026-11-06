-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local MarketplaceService = game:GetService("MarketplaceService")

return {
	GetProductPrice = function(p1, p2) --[[ GetProductPrice | Line: 6 | Upvalues: MarketplaceService (copy) ]]
		local ok, result = pcall(function() --[[ Line: 7 | Upvalues: MarketplaceService (ref), p2 (copy) ]]
			return MarketplaceService:GetProductInfoAsync(p2, Enum.InfoType.Product)
		end)

		if ok and result then
			return result.PriceInRobux
		end

		return false
	end,
	GetGamepassPrice = function(p1, p2) --[[ GetGamepassPrice | Line: 18 | Upvalues: MarketplaceService (copy) ]]
		local ok, result = pcall(function() --[[ Line: 19 | Upvalues: MarketplaceService (ref), p2 (copy) ]]
			return MarketplaceService:GetProductInfoAsync(p2, Enum.InfoType.GamePass)
		end)

		if ok and result then
			return result.PriceInRobux
		end

		return false
	end
}
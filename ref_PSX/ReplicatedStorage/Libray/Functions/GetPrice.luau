-- | load library | --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Library = ReplicatedStorage:WaitForChild("Library")
local ClientLibrary = Library:WaitForChild("Client")
local Modules = Library:WaitForChild("Modules")
local Types = Library:WaitForChild("Types")

-- | shared modules | --

--------|     Setting     |--------

--------|    Reference    |--------

--------|    Variables    |--------
local cachedProductInfo = {}
local ProductCache = require(game:GetService("ReplicatedStorage"):WaitForChild("X").ProductCache)

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


--- Returns market robux price for item ID (price, onSale)


return function(id, product)
	if id == 0 then
		return 0, false
	end
	
	local productInfo = ProductCache.getProductInfo(id, product and Enum.InfoType.Product or Enum.InfoType.GamePass).Info
	
	if productInfo then
		if not productInfo.IsForSale then
			return 0, false
		else
			return productInfo.PriceInRobux, true
		end
	end
	
	warn("Failed to grab price for ID (" .. id .. ")")
	return 0, false
end

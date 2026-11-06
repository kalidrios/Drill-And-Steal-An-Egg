-- https://github.com/kalidrios

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local m_ProductCache = require(ReplicatedStorage:WaitForChild("X").ProductCache);
return function(p1, p2) -- Line: 18
	--[[
		Upvalues:
			[1] = m_ProductCache
	--]]
	return m_ProductCache.getProductInfo(p1, p2 or Enum.InfoType.Product).Info;
end;

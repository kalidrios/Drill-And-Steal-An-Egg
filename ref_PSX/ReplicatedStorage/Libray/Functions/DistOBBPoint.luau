-- https://github.com/kalidrios

local m_DistAABBPoint = require(script.Parent.DistAABBPoint);
return function(p1, p2, p3) -- Line: 7
	--[[
		Upvalues:
			[1] = m_DistAABBPoint
	--]]
	local PointToObjectSpace_ret = p1:PointToObjectSpace(p3);
	local v1, v2, v3 = m_DistAABBPoint(p2, PointToObjectSpace_ret);
	local PointToWorldSpace_ret = p1:PointToWorldSpace(v2);
	return v1, PointToWorldSpace_ret, v3;
end;

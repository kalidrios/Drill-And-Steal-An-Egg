-- https://github.com/kalidrios

local math_pi = math.pi;
local u1 = math.pi * 2;
return function(p1, p2) -- Line: 11
	--[[
		Upvalues:
			[1] = math_pi
			[2] = u1
	--]]
	local v1 = p2 - p1;
	if math_pi < v1 then
		return v1 - u1;
	end
	if v1 < -math_pi then
		v1 = v1 + u1;
	end
	return v1;
end;

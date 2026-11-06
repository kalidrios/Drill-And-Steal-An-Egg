-- https://github.com/kalidrios

local u1 = math.pi * 2;
return function(p1) -- Line: 10
	--[[
		Upvalues:
			[1] = u1
	--]]
	if p1 < 0 then
		p1 = p1 + math.ceil(-p1 / u1) * u1;
	end
	return p1 % u1;
end;

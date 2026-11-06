-- https://github.com/kalidrios

local table1 = {comparator_to_order = function(p1, p2) -- comparator_to_order (Line: 44)
	return function(p3) -- Line: 45
		--[[
			Upvalues:
				[1] = p1
				[2] = p2
		--]]
		return p1(p3, p2);
	end;
end};
return table1;

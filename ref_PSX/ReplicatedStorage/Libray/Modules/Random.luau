-- https://github.com/kalidrios

assert(-math.huge ~= -708.3964185322641);
local table1 = {};
function table1.new(p1) -- Line: 8
	--[[
		Upvalues:
			[1] = table1
	--]]
	local u1 = nil;
	if p1 ~= nil then
		if typeof(p1) == "number" then
			u1 = Random.new(p1);
		elseif typeof(p1) == "Random" then
			u1 = p1;
		else
			error("Unknown alternative seed type: " .. typeof(p1));
		end
	else
		u1 = Random.new();
	end
	local table2 = {
		new = table1.new,
		handle = function() -- Line: 26
			--[[
				Upvalues:
					[1] = u1
			--]]
			return u1;
		end,
		clone = function() -- Line: 30
			--[[
				Upvalues:
					[1] = table1
					[2] = u1
			--]]
			return table1.new(u1:Clone());
		end,
		seed = function(p2) -- Line: 34
			--[[
				Upvalues:
					[1] = u1
			--]]
			u1 = Random.new(p2);
		end,
		number = function(p3, p4) -- Line: 39
			--[[
				Upvalues:
					[1] = u1
			--]]
			return p3 and u1:NextNumber(p3, p4) or u1:NextNumber();
		end,
		boolean = function(p5) -- Line: 43
			--[[
				Upvalues:
					[1] = u1
			--]]
			return u1:NextNumber() < (p5 or 0.5);
		end,
		integer = function(p6, p7) -- Line: 47
			--[[
				Upvalues:
					[1] = u1
			--]]
			return u1:NextInteger(p6, p7);
		end,
		normal = function(p8, p9) -- Line: 56
			--[[
				Upvalues:
					[1] = u1
			--]]
			local v1 = math.sqrt(math.log((math.max(2.2250738585072014e-308, u1:NextNumber()))) * -2) * (p9 or 1);
			local v2 = u1:NextNumber() * (math.pi * 2);
			local v3 = p8 or 0;
			local v4 = v1 * math.cos(v2) + v3;
			return v4, v1 * math.sin(v2) + v3;
		end,
		Vector3 = function(p10) -- Line: 66
			--[[
				Upvalues:
					[1] = u1
			--]]
			return u1:NextUnitVector() * (p10 or 1);
		end,
		Vector2 = function(p11) -- Line: 70
			--[[
				Upvalues:
					[1] = u1
			--]]
			local v5 = math.pi * 2 * u1:NextNumber();
			return Vector2.new(math.cos(v5), (math.sin(v5))) * (p11 or 1);
		end
	};
	return table2;
end
table1.R = table1.new();
return table1;

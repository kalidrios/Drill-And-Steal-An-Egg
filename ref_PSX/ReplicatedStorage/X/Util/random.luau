-- https://github.com/kalidrios

local table1 = {};
function table1.new(p1) -- Line: 10
	--[[
		Upvalues:
			[1] = table1
	--]]
	local v1 = nil;
	if p1 ~= nil then
		if typeof(p1) == "number" then
			v1 = Random.new(p1);
		elseif typeof(p1) == "Random" then
			v1 = p1;
		else
			error("Unknown alternative seed type: " .. typeof(p1));
		end
	else
		v1 = Random.new();
	end
	local table2 = {handle = v1};
	local new_mt = setmetatable(table2, {__index = table1});
	return new_mt;
end
function table1.clone(p2) -- Line: 30
	--[[
		Upvalues:
			[1] = table1
	--]]
	return table1.new(p2.handle:Clone());
end
function table1.set_seed(p3, p4) -- Line: 34
	p3.handle = Random.new(p4);
end
function table1.next_boolean(p5, p6) -- Line: 38
	return p5:next() < (p6 or 0.5);
end
function table1.next_int(p7, p8, p9) -- Line: 42
	return p7.handle:NextInteger(p8 or 0, p9 or 1);
end
function table1.next(p10, p11, p12) -- Line: 47
	return p10.handle:NextNumber(p11 or 0, p12 or 1);
end
function table1.next_normal(p13, p14, p15) -- Line: 52
	local next_ret = p13:next();
	local next_ret2 = p13:next();
	local math_sqrt_ret = math.sqrt(math.log(next_ret) * -2 * (p14 or 1));
	local v2 = math.pi * 2 * next_ret2;
	local v3 = p15 or 0;
	local v4 = math_sqrt_ret * math.cos(v2) + v3;
	return v4, math_sqrt_ret * math.sin(v2) + v3;
end
function table1.next_vector3(p16, p17) -- Line: 64
	return p16.handle:NextUnitVector() * (p17 or 1);
end
function table1.next_vector2(p18, p19) -- Line: 76
	local v5 = math.pi * 2 * p18:next();
	return Vector2.new(math.cos(v5), (math.sin(v5))) * (p19 or 1);
end
table1.R = table1.new();
return table1;

-- https://github.com/kalidrios

local table1 = {
	k = 1000,
	m = 1000000,
	b = 1000000000,
	t = 1000000000000,
	q = 1000000000000000
};
return function(p1) -- Line: 11
	--[[
		Upvalues:
			[1] = table1
	--]]
	local v1 = 1;
	if typeof(p1) == "string" then
		p1 = p1:gsub("[,%s%c%z]", "");
		if #p1 > 0 then
			local v3 = table1[p1:sub(#p1):lower()];
			if v3 then
				v1 = v3;
				p1 = p1:sub(1, #p1 - 1);
			end
		end
	end
	local v2 = tonumber(p1);
	if v2 then
		v2 = v2 * v1;
	end
	return v2;
end;

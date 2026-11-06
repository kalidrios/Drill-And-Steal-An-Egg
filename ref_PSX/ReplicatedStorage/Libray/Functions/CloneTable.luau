-- https://github.com/kalidrios

local HttpService = game:GetService("HttpService");
local function deepcopy(p1, p2) -- Line: 19
	--[[
		Upvalues:
			[1] = deepcopy
	--]]
	p2 = p2 or {};
	if type(p1) == "table" then
		if p2[p1] then
			return p2[p1];
		end
		local table1 = {};
		p2[p1] = table1;
		for key1, val1 in next, p1 do
			table1[deepcopy(key1, p2)] = deepcopy(val1, p2);
		end
		setmetatable(table1, (deepcopy(getmetatable(p1), p2)));
		return table1;
	end
	return p1;
end
return function(p3, p4) -- Line: 41
	--[[
		Upvalues:
			[1] = deepcopy
			[2] = HttpService
	--]]
	if p4 then
		return deepcopy(p3);
	end
	return HttpService:JSONDecode(HttpService:JSONEncode(p3));
end;

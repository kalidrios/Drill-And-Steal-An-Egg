-- https://github.com/kalidrios

local HttpService = game:GetService("HttpService");
return function(p1) -- Line: 5
	--[[
		Upvalues:
			[1] = HttpService
	--]]
	local table1 = {};
	for key1, val1 in pairs(p1) do
		assert(typeof(key1) == "string");
		assert(typeof(val1) == "string" and true or typeof(val1) == "number" and true or typeof(val1) == "boolean");
		table.insert(table1, {
			key1,
			tostring(val1)
		});
	end
	table.sort(table1, function(p2, p3) -- Line: 13
		return p2[1] < p3[1];
	end);
	local v1 = "?";
	for _, val2 in ipairs(table1) do
		v1 = v1 .. HttpService:UrlEncode(val2[1]) .. "=" .. HttpService:UrlEncode(val2[2]) .. "&";
	end
	return v1:sub(1, v1:len() - 1);
end;

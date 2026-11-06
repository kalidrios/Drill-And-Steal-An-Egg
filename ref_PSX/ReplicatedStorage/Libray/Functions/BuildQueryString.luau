-- https://github.com/kalidrios

local HttpService = game:GetService("HttpService");
return function(p1) -- Line: 5
	--[[
		Upvalues:
			[1] = HttpService
	--]]
	local v1 = "?";
	for key1, val1 in pairs(p1) do
		assert(typeof(key1) == "string");
		assert(typeof(val1) == "string");
		v1 = v1 .. HttpService:UrlEncode(key1) .. "=" .. HttpService:UrlEncode(val1) .. "&";
	end
	return v1:sub(1, v1:len() - 1);
end;

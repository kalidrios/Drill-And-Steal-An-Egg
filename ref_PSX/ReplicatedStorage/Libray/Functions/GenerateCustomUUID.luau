-- https://github.com/kalidrios

local HttpService = game:GetService("HttpService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local X = ReplicatedStorage:WaitForChild("X");
local m_MD5 = require(X:WaitForChild("Util").MD5);
return function(p1, p2, p3, p4) -- Line: 11
	--[[
		Upvalues:
			[1] = m_MD5
			[2] = HttpService
	--]]
	local v1;
	if p4 then
		v1 = m_MD5.sumhexa(tostring(p4));
		if not p3 then
			v1 = v1:upper();
		end
		if p2 then
			v1 = v1:sub(1, 8) .. "-" .. v1:sub(9, 12) .. "-" .. v1:sub(13, 16) .. "-" .. v1:sub(17, 20) .. "-" .. v1:sub(21, 32);
		end
		if p1 then
			return "{" .. v1 .. "}";
		end
	else
		v1 = HttpService:GenerateGUID(p1);
		if not p2 then
			v1 = v1:gsub("%-", "");
		end
		if p3 then
			v1 = v1:lower();
		end
	end
	return v1;
end;

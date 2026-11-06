-- https://github.com/kalidrios

local HttpService = game:GetService("HttpService");
return function()  
	local GenerateGUID_ret = HttpService:GenerateGUID(false);
	local string_gsub_ret = string.gsub(GenerateGUID_ret, "-", "");
	return string_gsub_ret;
end;


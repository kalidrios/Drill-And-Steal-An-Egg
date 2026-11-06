-- https://github.com/kalidrios

local RunService = game:GetService("RunService");
local HttpService = game:GetService("HttpService");
local v1 = game.JobId;
if #v1 == 0 or v1 == "00000000-0000-0000-0000-000000000000" then
	assert(RunService:IsStudio());
	if RunService:IsServer() then
		v1 = HttpService:GenerateGUID(false):lower();
	else
		v1 = script:WaitForChild("Custom").Value;
	end
end
if RunService:IsServer() then
	local Custom = script:WaitForChild("Custom");
	Custom.Value = v1;
end
return v1;

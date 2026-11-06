-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

local v1 = {};
for v2, v3 in ipairs(script.Parent:GetChildren()) do
	if v3:IsA("Folder") then
		local v5 = v3:FindFirstChildOfClass("ModuleScript");
		if v5 then
			v1[v3.Name] = require(v5);
		end;
	end;
end;
return v1;

-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

local v1 = {};
for v2, v3 in ipairs(script.Parent:GetChildren()) do
	if v3:IsA("Folder") then
		for v5, v6 in ipairs(v3:GetChildren()) do
			if v6:IsA("Folder") then
				for v8, v9 in ipairs(v6:GetChildren()) do
					if v9:IsA("ModuleScript") then
						v1[v9.Name] = require(v9);
					end;				
				end;
			end;		
		end;
	end;
end;
return v1;

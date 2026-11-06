-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

local l__Library__1 = game:GetService("ReplicatedStorage"):WaitForChild("Library");
local v2 = require(l__Library__1.Functions);
local v3 = require(l__Library__1:WaitForChild("Types").Quests);
local v4 = require(l__Library__1:WaitForChild("Modules").Areas);
local v5 = {};
for v6, v7 in ipairs(script.Parent:GetChildren()) do
	if v7:IsA("Folder") then
		local l__Name__9 = v7.Name;
		for v10, v11 in ipairs(v7:GetChildren()) do
			if v11:IsA("ModuleScript") then
				local l__Name__13 = v11.Name;
				local v14 = require(v11);
				for v15, v16 in pairs(v14) do
					v16.AreaId = l__Name__13;
					v16.Name = v15;
					assert(v16.Amount > 0);
					assert(v3.Tiers[v16.Tier]);
				end;
				v5[l__Name__13] = v14;
			end;		
		end;
	end;
end;
return v5;

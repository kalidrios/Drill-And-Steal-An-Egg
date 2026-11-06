-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

local l__Library__1 = game:GetService("ReplicatedStorage"):WaitForChild("Library");
local v2 = require(l__Library__1.Asserts);
local v3 = require(l__Library__1:WaitForChild("Types").Quests);
local v4 = {};
for v5, v6 in ipairs(script.Parent:GetChildren()) do
	if v6:IsA("Folder") then
		for v8, v9 in ipairs(v6:GetChildren()) do
			if v9:IsA("ModuleScript") then
				local v11 = require(v9);
				v11.Name = v9.Name;
				if not v11.Amount then
					v11.Amount = 1;
				end;
				v2.natural(v11.Cost);
				v2.natural(v11.Amount);
				assert(v11.Pet or (v11.Hoverboard or (v11.Booth or (v11.Boosts or (v11.Currency or (v11.PetEquips or v11.PetSlots))))));
				v4[v11.Name] = v11;
			end;		
		end;
	end;
end;
return v4;

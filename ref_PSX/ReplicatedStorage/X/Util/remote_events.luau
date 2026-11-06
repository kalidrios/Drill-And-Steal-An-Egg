-- https://github.com/kalidrios

local Players = game:GetService("Players");
local table1 = {fire_nearby = function(p1, p2, p3, _, ...) -- fire_nearby (Line: 7)
	--[[
		Upvalues:
			[1] = Players
	--]]
	for _, val1 in pairs(Players:GetPlayers()) do
		local t_Character = val1.Character;
		if not t_Character then continue end
		local t_PrimaryPart = t_Character.PrimaryPart;
		if not t_PrimaryPart or p3 < (t_PrimaryPart.Position - p2).Magnitude then continue end
		p1:FireClient(val1, ...);
	end
end};
return table1;

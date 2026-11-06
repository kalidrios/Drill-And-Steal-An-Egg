-- https://github.com/kalidrios

local Players = game:GetService("Players");
local ScreenGui = Instance.new("ScreenGui");
ScreenGui.Name = "GUIFX Holder";
ScreenGui.DisplayOrder = 999;
ScreenGui.Parent = Players.LocalPlayer;
return function() -- Line: 10
	--[[
		Upvalues:
			[1] = ScreenGui
	--]]
	return ScreenGui;
end;

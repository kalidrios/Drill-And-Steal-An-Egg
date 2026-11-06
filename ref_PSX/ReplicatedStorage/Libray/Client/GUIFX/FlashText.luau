-- https://github.com/kalidrios

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Library = ReplicatedStorage:WaitForChild("Library");
local m_Settings = require(Library:WaitForChild("Client").Settings);
local m_Functions = require(Library.Functions);
local m_CacheProperty = require(script.Parent.CacheProperty);
local t_UIEasingStyle = m_Settings.UIEasingStyle;
return function(p1, p2) -- Line: 37
	--[[
		Upvalues:
			[1] = m_CacheProperty
			[2] = m_Functions
			[3] = t_UIEasingStyle
	--]]
	local v1 = p2 or 1;
	local v2 = m_CacheProperty(p1, "TextColor3");
	if Color3.new(1, 1, 1) == v2 then
		p1.TextColor3 = Color3.new(v2.r / 2, v2.g / 2, v2.b / 2);
	else
		p1.TextColor3 = Color3.new(v2.r * 2, v2.g * 2, v2.b * 2);
	end
	local _ = m_Functions.Tween(p1, {TextColor3 = v2}, {
		v1,
		t_UIEasingStyle
	});
end;

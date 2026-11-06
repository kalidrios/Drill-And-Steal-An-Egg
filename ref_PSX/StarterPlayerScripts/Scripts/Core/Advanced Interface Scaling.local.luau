-- https://github.com/kalidrios

local table1 = {
	"Chat",
	"TouchGui"
};
local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local u1 = m_Library.Player.PlayerGui();
local t_Scale9Slice = m_Library.Settings.Scale9Slice;
local t_ScaleStrokes = m_Library.Settings.ScaleStrokes;
local t_ScalePadding = m_Library.Settings.ScalePadding;
local t_ScaleLists = m_Library.Settings.ScaleLists;
local t_ScaleGrids = m_Library.Settings.ScaleGrids;
local table2 = {};
function ScaleElement(p1) -- Line: 41
	--[[
		Upvalues:
			[1] = table2
			[2] = m_Library
	--]]
	if not p1 or not p1.Parent or not table2[p1] then return end
	local v1 = table2[p1];
	local math_min_ret = math.min(1 - (1 - (m_Library.Variables.ResolutionScale or 1)) * 0.65, 1);
	if p1.ClassName == "UIStroke" then
		p1.Thickness = v1 * math_min_ret;
		return true;
	end
	if (p1.ClassName == "ImageLabel" or p1.ClassName == "ImageButton") and p1.ScaleType == Enum.ScaleType.Slice then
		p1.SliceScale = v1 * math_min_ret;
		return true;
	end
	if p1.ClassName == "UIPadding" then
		p1.PaddingTop = UDim.new(p1.PaddingTop.Scale, v1.PaddingTop.Offset * math_min_ret);
		p1.PaddingBottom = UDim.new(p1.PaddingBottom.Scale, v1.PaddingBottom.Offset * math_min_ret);
		p1.PaddingLeft = UDim.new(p1.PaddingLeft.Scale, v1.PaddingLeft.Offset * math_min_ret);
		p1.PaddingRight = UDim.new(p1.PaddingRight.Scale, v1.PaddingRight.Offset * math_min_ret);
		return true;
	end
	if p1.ClassName == "UIListLayout" then
		p1.Padding = UDim.new(p1.Padding.Scale, v1.Offset * math_min_ret);
		return true;
	end
	if p1.ClassName == "UIGridLayout" then
		p1.CellPadding = UDim2.new(p1.CellPadding.X.Scale, v1.X.Scale * math_min_ret, p1.CellPadding.Y.Scale, v1.Y.Offset * math_min_ret);
		return true;
	end
end
function ScaleAll() -- Line: 77
	--[[
		Upvalues:
			[1] = table2
			[2] = m_Library
	--]]
	local v2 = 0;
	for key1, _ in pairs(table2) do
		v2 = v2 + 1;
		if v2 % 100 == 0 then
			m_Library.RenderStepped();
		end
		local ScaleElement_ret = ScaleElement(key1);
		if ScaleElement_ret then continue end
		table2[key1] = nil;
	end
end
function AddUIElement(p2) -- Line: 93
	--[[
		Upvalues:
			[1] = table2
			[2] = t_ScaleStrokes
			[3] = t_Scale9Slice
			[4] = t_ScalePadding
			[5] = t_ScaleLists
			[6] = t_ScaleGrids
	--]]
	if table2[p2] then return end
	if t_ScaleStrokes and p2.ClassName == "UIStroke" then
		table2[p2] = p2.Thickness;
	elseif t_Scale9Slice and (p2.ClassName == "ImageLabel" or p2.ClassName == "ImageButton") and p2.ScaleType == Enum.ScaleType.Slice then
		table2[p2] = p2.SliceScale;
	elseif t_ScalePadding and p2.ClassName == "UIPadding" then
		table2[p2] = {
			PaddingTop = p2.PaddingTop,
			PaddingBottom = p2.PaddingBottom,
			PaddingLeft = p2.PaddingLeft,
			PaddingRight = p2.PaddingRight
		};
	elseif t_ScaleLists and p2.ClassName == "UIListLayout" then
		table2[p2] = p2.Padding;
	elseif t_ScaleGrids and p2.ClassName == "UIGridLayout" then
		table2[p2] = p2.CellPadding;
	end
	if table2[p2] then
		ScaleElement(p2);
	end
end
function InitScreen(p3) -- Line: 116
	--[[
		Upvalues:
			[1] = m_Library
			[2] = table1
	--]]
	if p3.ClassName ~= "ScreenGui" and p3.ClassName ~= "BillboardGui" and p3.ClassName ~= "SurfaceGui" then return end
	if m_Library.Functions.SearchArray(table1, p3.Name) then return end
	for _, descendant2 in ipairs(p3:GetDescendants()) do
		if not descendant2:IsA("GuiObject") and not descendant2:IsA("UIComponent") then continue end
		AddUIElement(descendant2);
	end
	p3.DescendantAdded:Connect(function(descendant) -- Line: 131
		if descendant:IsA("GuiObject") or descendant:IsA("UIComponent") then
			AddUIElement(descendant);
		end
	end);
end
function Init() -- Line: 139
	--[[
		Upvalues:
			[1] = u1
	--]]
	for _, child3 in ipairs(u1:GetChildren()) do
		local coroutine_wrap_ret = coroutine.wrap(function() -- Line: 141
			--[[
				Upvalues:
					[1] = child3
			--]]
			InitScreen(child3);
		end);
		coroutine_wrap_ret();
	end
	u1.ChildAdded:Connect(function(child) -- Line: 146
		InitScreen(child);
	end);
end
function GarbageCleanup() -- Line: 155
	--[[
		Upvalues:
			[1] = table2
			[2] = m_Library
	--]]
	local v3 = 0;
	for key4, _ in pairs(table2) do
		v3 = v3 + 1;
		if v3 % 100 == 0 then
			m_Library.RenderStepped();
		end
		if key4 and key4.Parent then continue end
		table2[key4] = nil;
	end
end
local coroutine_wrap_ret2 = coroutine.wrap(function() -- Line: 170
	while true do
		wait(30);
		GarbageCleanup();
	end
end);
coroutine_wrap_ret2();
Init();
local function track(...) -- Line: 190
	for _, val5 in ipairs(table.pack(...)) do
		for _, descendant6 in ipairs(val5:GetDescendants()) do
			if descendant6.ClassName ~= "UIStroke" then continue end
			ScaleElement(descendant6);
		end
		val5.DescendantAdded:Connect(function(descendant2_0) -- Line: 199
			if descendant2_0.ClassName == "UIStroke" then
				ScaleElement(descendant2_0);
			end
		end);
	end
end
local __MAP = workspace:FindFirstChild("__MAP");
if __MAP then
	track(__MAP);
end
workspace.ChildAdded:Connect(function(child2) -- Line: 211
	--[[
		Upvalues:
			[1] = track
	--]]
	if child2.Name == "__MAP" then
		track(child2);
	end
end);
task.spawn(function() -- Line: 217
	--[[
		Upvalues:
			[1] = track
	--]]
	track(workspace:WaitForChild("__THINGS"):WaitForChild("ExclusiveEggPets"));
end);
m_Library.Signal.Fired("Resolution Changed"):Connect(function() -- Line: 222
	task.defer(function() -- Line: 223
		ScaleAll();
	end);
end);

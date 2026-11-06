-- https://github.com/kalidrios

local table1 = {
	"💕 Valentine's Event!",
	"💌 Valentine's Gram! Send a love message globally!",
	"🎁 Giant Valentines Chest!",
	"🏝️ Cozy Cove Area!",
	"🐾 New Valentine Pets!",
	"💎 Free UGC in Cave!",
	"✨ New Mythic Rarity!",
	"🎮 New Gamepasses: Triple Box, Auto Open, Box Skip & Teleport!",
	"🐛 Bug Fixes & Improvements"
};
local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local t_UpdateLog = m_Library.GUI.UpdateLog;
local bool1 = false;
function Show() -- Line: 33
	--[[
		Upvalues:
			[1] = t_UpdateLog
			[2] = table1
			[3] = m_Library
	--]]
	t_UpdateLog.Desc.Text = "Valentine's Update! (" .. "February 14th, 2026" .. ")";
	for key1, val1 in ipairs(table1) do
		local Clone_ret = m_Library.Assets.UI.Changelog.Change:Clone();
		Clone_ret.Label.Text = val1;
		Clone_ret.LayoutOrder = key1;
		Clone_ret.Parent = t_UpdateLog.Changes;
	end
	local UIListLayout = t_UpdateLog.Changes:FindFirstChildOfClass("UIListLayout");
	local UIPadding = t_UpdateLog.Changes:FindFirstChildOfClass("UIPadding");
	UIListLayout:ApplyLayout();
	t_UpdateLog.Changes.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + UIPadding.PaddingTop.Offset + UIPadding.PaddingBottom.Offset);
	t_UpdateLog.Gui.Enabled = true;
end
function DoShow() -- Line: 52
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local v1 = m_Library.Save.Get();
	if v1.LastUpdateLog == m_Library.Shared.UpdateLogId then return end
	if m_Library.Variables.PickingStarter or not v1.PickedStarter then return end
	return true;
end
function Close() -- Line: 67
	--[[
		Upvalues:
			[1] = t_UpdateLog
			[2] = m_Library
	--]]
	t_UpdateLog.Gui.Enabled = false;
	m_Library.Audio.Play(113921203653235, script, 1, 0.65);
	m_Library.Network.Fire("Read Changelog");
end
if DoShow() then
	Show();
end
t_UpdateLog.Close.Activated:Connect(function() -- Line: 82
	--[[
		Upvalues:
			[1] = bool1
	--]]
	if not bool1 then
		bool1 = true;
		Close();
		bool1 = false;
	end
end);
t_UpdateLog.Ok.Activated:Connect(function() -- Line: 91
	--[[
		Upvalues:
			[1] = bool1
	--]]
	if not bool1 then
		bool1 = true;
		Close();
		bool1 = false;
	end
end);
m_Library.GUIFX.ButtonFX(t_UpdateLog.Ok);
m_Library.GUIFX.ButtonFX(t_UpdateLog.Close);

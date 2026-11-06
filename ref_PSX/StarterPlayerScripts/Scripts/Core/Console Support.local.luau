-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local t_FusePets = m_Library.GUI.FusePets;
local t_Golden = m_Library.GUI.Golden;
local t_DarkMatter = m_Library.GUI.DarkMatter;
local t_EnchantPets = m_Library.GUI.EnchantPets;
local t_Rainbow = m_Library.GUI.Rainbow;
local _ = m_Library.GUI.Trading;
local t_Mailbox = m_Library.GUI.Mailbox;
local t_Trading = m_Library.GUI.Trading;
local t_Bank = m_Library.GUI.Bank;
local t_ListPet = m_Library.GUI.ListPet;
local u1 = 1;
local table1 = {
	"Inventory",
	"Trading",
	"Achievements",
	"Mastery",
	"ExclusiveShop",
	"Settings"
};
function setupGui() -- Line: 29
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local t_Keybind = m_Library.GUI.Main.Left.Tools.Hoverboard.Keybind;
	t_Keybind.Xbox.Visible = m_Library.Variables.Console;
	t_Keybind.Desktop.Visible = m_Library.Variables.Desktop;
	local t_Keybind2 = m_Library.GUI.Main.Left.Tools.AutoSettings.Keybind;
	t_Keybind2.Visible = m_Library.Variables.Console;
	local t_Keybind3 = m_Library.GUI.Main.Left.Tools.Teleport.Keybind;
	t_Keybind3.Visible = m_Library.Variables.Console;
	local t_Keybind4 = m_Library.GUI.FreeGiftsTop.Keybind;
	t_Keybind4.Visible = m_Library.Variables.Console;
	local t_Keybind5 = m_Library.GUI.Main.Bottom.Inventory.Keybind;
	t_Keybind5.Xbox.Visible = m_Library.Variables.Console;
	t_Keybind5.Visible = m_Library.Variables.Console;
end
function hideHud() -- Line: 48
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local t_Keybind6 = m_Library.GUI.Main.Left.Tools.Hoverboard.Keybind;
	t_Keybind6.Xbox.Visible = false;
	t_Keybind6.Desktop.Visible = m_Library.Variables.Desktop;
	m_Library.GUI.Main.Left.Tools.AutoSettings.Keybind.Visible = false;
	m_Library.GUI.Main.Left.Tools.Teleport.Keybind.Visible = false;
	m_Library.GUI.FreeGiftsTop.Keybind.Visible = false;
	local t_Keybind7 = m_Library.GUI.Main.Bottom.Inventory.Keybind;
	t_Keybind7.Xbox.Visible = false;
	t_Keybind7.Visible = false;
end
setupGui();
m_Library.Signal.Fired("Changed Platform"):Connect(setupGui);
m_Library.Signal.Fired("Hide HUD Keybinds"):Connect(hideHud);
m_Library.Signal.Fired("Show HUD Keybinds"):Connect(setupGui);
m_Library.Signal.Invoked("Is Console Blocking").OnInvoke = function() -- Line: 75
	--[[
		Upvalues:
			[1] = t_Trading
			[2] = t_Bank
			[3] = m_Library
	--]]
	local bool1 = false;
	if t_Trading.Gui.Enabled or t_Bank.Gui.Enabled then
		bool1 = true;
	end
	return m_Library.Variables.Console and bool1;
end
m_Library.UserInputService.InputEnded:Connect(function(input, gameProcessedEvent) -- Line: 85
	--[[
		Upvalues:
			[1] = t_Trading
			[2] = t_Bank
			[3] = t_ListPet
			[4] = t_Mailbox
			[5] = m_Library
	--]]
	if input.KeyCode ~= Enum.KeyCode.ButtonL1 and input.KeyCode ~= Enum.KeyCode.ButtonR1 or not t_Trading.Gui.Enabled and not t_Bank.Gui.Enabled and not t_ListPet.Gui.Enabled and (not t_Mailbox.Gui.Enabled or not t_Mailbox.Gui.Frame.GiftPet.Visible) then return end
	if input.KeyCode == Enum.KeyCode.ButtonL1 then
		m_Library.Signal.Fire("Xbox Stop Subtract");
	end
	if input.KeyCode == Enum.KeyCode.ButtonR1 then
		m_Library.Signal.Fire("Xbox Stop Add");
	end
end);
m_Library.UserInputService.InputBegan:Connect(function(input2, gameProcessedEvent2) -- Line: 99
	--[[
		Upvalues:
			[1] = m_Library
			[2] = t_Trading
			[3] = t_Bank
			[4] = t_ListPet
			[5] = t_Mailbox
			[6] = u1
			[7] = table1
			[8] = t_FusePets
			[9] = t_Golden
			[10] = t_DarkMatter
			[11] = t_EnchantPets
			[12] = t_Rainbow
	--]]
	if gameProcessedEvent2 then return end
	if input2.KeyCode == Enum.KeyCode.DPadLeft and not m_Library.GUI.Teleport.Gui.Enabled then
		if m_Library.GUI.Trading.Trade.Visible then
			m_Library.Signal.Fire("Attempt Cancel Trade");
			return;
		end
		if not m_Library.Signal.Invoke("Close Open Window") then return end
		m_Library.GUI.Teleport.Gui.Enabled = true;
		m_Library.GuiService.SelectedObject = m_Library.GUI.Teleport.Gui.Frame.Container.Holder;
		return;
	end
	if input2.KeyCode == Enum.KeyCode.DPadDown and not m_Library.GUI.AutoSettings.Gui.Enabled then
		if m_Library.GUI.Trading.Trade.Visible then
			m_Library.Signal.Fire("Attempt Cancel Trade");
			return;
		end
		if not m_Library.Signal.Invoke("Close Open Window") then return end
		m_Library.GUI.AutoSettings.Gui.Enabled = true;
		m_Library.GuiService.SelectedObject = m_Library.GUI.AutoSettings.Gui.Frame.AutoDelete.Raritys.Basic;
		return;
	end
	if input2.KeyCode == Enum.KeyCode.DPadRight and not m_Library.GUI.FreeGifts.Gui.Enabled then
		if m_Library.GUI.Trading.Trade.Visible then
			m_Library.Signal.Fire("Attempt Cancel Trade");
			return;
		end
		if not m_Library.Signal.Invoke("Close Open Window") then return end
		m_Library.GUI.FreeGifts.Gui.Enabled = true;
		task.defer(function() -- Line: 151
			--[[
				Upvalues:
					[1] = m_Library
			--]]
			for _, child2 in ipairs(m_Library.GUI.FreeGifts.Frame.Container.Gifts:GetChildren()) do
				if child2:isA("UIAspectRatioConstraint") or not child2:isA("TextButton") then continue end
				print("Set selected obj");
				m_Library.GuiService.SelectedObject = child2;
				return;
			end
		end);
		return;
	end
	if input2.KeyCode == Enum.KeyCode.ButtonL1 or input2.KeyCode == Enum.KeyCode.ButtonR1 then
		if t_Trading.Gui.Enabled or t_Bank.Gui.Enabled or t_ListPet.Gui.Enabled or t_Mailbox.Gui.Enabled and t_Mailbox.Gui.Frame.GiftPet.Visible then
			if input2.KeyCode == Enum.KeyCode.ButtonL1 then
				m_Library.Signal.Fire("Xbox Start Subtract");
			end
			if input2.KeyCode == Enum.KeyCode.ButtonR1 then
				m_Library.Signal.Fire("Xbox Start Add");
			end
			return;
		end
		local t_Bottom = m_Library.GUI.Main.Bottom;
		for _, child1 in ipairs(t_Bottom:GetChildren()) do
			if not child1:isA("TextButton") or child1.Visible then continue end
			return;
		end
		if input2.KeyCode == Enum.KeyCode.ButtonL1 then
			u1 = math.max(1, u1 - 1);
			local FindFirstChild_ret2 = t_Bottom:FindFirstChild(table1[u1]);
			m_Library.GuiService.SelectedObject = FindFirstChild_ret2;
		elseif input2.KeyCode == Enum.KeyCode.ButtonR1 then
			u1 = math.min(#table1, u1 + 1);
			local FindFirstChild_ret = t_Bottom:FindFirstChild(table1[u1]);
			m_Library.GuiService.SelectedObject = FindFirstChild_ret;
		end
	end
	if input2.KeyCode == Enum.KeyCode.ButtonX then
		if t_FusePets.Gui.Enabled then
			m_Library.Signal.Fire("Attempt Fuse");
			return;
		end
		if t_Golden.Gui.Enabled then
			m_Library.Signal.Fire("Attempt Golden");
			return;
		end
		if t_DarkMatter.Gui.Enabled then
			m_Library.Signal.Fire("Attempt Dark Matter");
			return;
		end
		if t_EnchantPets.Gui.Enabled then
			m_Library.Signal.Fire("Attempt Enchant");
			return;
		end
		if t_Rainbow.Gui.Enabled then
			m_Library.Signal.Fire("Attempt Rainbow");
			return;
		end
		if t_Trading.Gui.Enabled then
			m_Library.Signal.Fire("Attempt Accept Trade");
		end
	end
end);

-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local t_TradingPlazaChoice = m_Library.GUI.TradingPlazaChoice;
local bool1 = false;
function Setup(p1) -- Line: 20
	--[[
		Upvalues:
			[1] = t_TradingPlazaChoice
			[2] = bool1
			[3] = m_Library
	--]]
	t_TradingPlazaChoice.VoiceButton.Activated:Connect(function() -- Line: 22
		--[[
			Upvalues:
				[1] = bool1
				[2] = p1
				[3] = m_Library
				[4] = t_TradingPlazaChoice
		--]]
		if not bool1 then
			bool1 = true;
			if not p1 then
				bool1 = false;
				return;
			end
			m_Library.Signal.Fire("Trading Plaza Request", "VOICE");
			t_TradingPlazaChoice.Gui.Enabled = false;
			bool1 = false;
		end
	end);
	t_TradingPlazaChoice.VoiceButton.ImageColor3 = p1 and Color3.new(1, 1, 1) or Color3.new(0.5, 0.5, 0.5);
	local u1 = m_Library.Shared.HasProTradingAccess();
	t_TradingPlazaChoice.ProButton.Activated:Connect(function() -- Line: 45
		--[[
			Upvalues:
				[1] = bool1
				[2] = u1
				[3] = m_Library
				[4] = t_TradingPlazaChoice
		--]]
		if not bool1 then
			bool1 = true;
			if not u1 then
				bool1 = false;
				return;
			end
			m_Library.Signal.Fire("Trading Plaza Request", "PRO");
			t_TradingPlazaChoice.Gui.Enabled = false;
			bool1 = false;
		end
	end);
	t_TradingPlazaChoice.ProButton.ImageColor3 = u1 and Color3.new(1, 1, 1) or Color3.new(0.5, 0.5, 0.5);
	t_TradingPlazaChoice.NormalButton.Activated:Connect(function() -- Line: 69
		--[[
			Upvalues:
				[1] = bool1
				[2] = m_Library
				[3] = t_TradingPlazaChoice
		--]]
		if not bool1 then
			bool1 = true;
			m_Library.Signal.Fire("Trading Plaza Request", "DEFAULT");
			t_TradingPlazaChoice.Gui.Enabled = false;
			bool1 = false;
		end
	end);
	t_TradingPlazaChoice.NormalButton.ImageColor3 = Color3.new(1, 1, 1) or Color3.new(0.5, 0.5, 0.5);
	t_TradingPlazaChoice.Gui.Enabled = true;
end
t_TradingPlazaChoice.Close.Activated:Connect(function() -- Line: 91
	--[[
		Upvalues:
			[1] = bool1
			[2] = t_TradingPlazaChoice
	--]]
	if not bool1 then
		bool1 = true;
		t_TradingPlazaChoice.Gui.Enabled = false;
		bool1 = false;
	end
end);
m_Library.GUIFX.ButtonFX(t_TradingPlazaChoice.Close);
m_Library.GUIFX.ButtonFX(t_TradingPlazaChoice.ProButton);
m_Library.GUIFX.ButtonFX(t_TradingPlazaChoice.VoiceButton);
m_Library.GUIFX.ButtonFX(t_TradingPlazaChoice.NormalButton);
m_Library.Signal.Fired("Show Trading Plaza Choice"):Connect(Setup);

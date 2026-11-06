-- https://github.com/kalidrios

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Assets = ReplicatedStorage:WaitForChild("Assets");
local Library = ReplicatedStorage:WaitForChild("Library");
local Client = Library:WaitForChild("Client");
local m_Functions = require(Library.Functions);
local m_Directory = require(Library.Directory);
local m_GUI = require(Client.GUI);
local m_GIF = require(Client.GIF);
local m_CacheProperty = require(script.Parent.CacheProperty);
local bool1 = false;
return function(p1) -- Line: 35
	--[[
		Upvalues:
			[1] = m_GUI
			[2] = m_Directory
			[3] = bool1
			[4] = RunService
			[5] = m_CacheProperty
			[6] = m_GIF
			[7] = m_Functions
			[8] = Assets
	--]]
	local t_Loading = m_GUI.Loading;
	local v1 = m_Directory.Worlds[p1];
	while bool1 do
		RunService.RenderStepped:Wait();
	end
	bool1 = true;
	local u1 = m_CacheProperty(t_Loading.GIF, "Position");
	local u2 = u1 + UDim2.new(0, 0, 0.05, 0);
	local u3 = m_CacheProperty(t_Loading.Info, "Position");
	local u4 = u3 + UDim2.new(0, 0, 0.05, 0);
	t_Loading.Black.Size = UDim2.new(0, 0, 2, 0);
	t_Loading.GIF.Position = u2;
	t_Loading.GIF.Transparency = 1;
	t_Loading.Black.BackgroundTransparency = 0;
	t_Loading.Info.Position = u4;
	t_Loading.Label.TextTransparency = 1;
	t_Loading.Location.TextTransparency = 1;
	t_Loading.Location.Text = v1 and v1.display or p1 or "";
	local u5 = m_GIF.Create(t_Loading.GIF, {
		146,
		146
	}, {
		7,
		6
	}, 39, 1);
	local function FadeIn() -- Line: 66
		--[[
			Upvalues:
				[1] = m_Functions
				[2] = t_Loading
				[3] = u1
				[4] = u3
		--]]
		m_Functions.Tween(t_Loading.GIF, {
			Position = u1,
			ImageTransparency = 1 -- 0
		}, {
			1, -- 0.8
			"Sine",
			"Out"
		});
		m_Functions.Tween(t_Loading.Info, {Position = u3}, {
			0.8,
			"Sine",
			"Out"
		});
		m_Functions.Tween(t_Loading.Label, {TextTransparency = 0}, {
			0.7,
			"Sine",
			"Out"
		});
		m_Functions.Tween(t_Loading.Location, {TextTransparency = 0}, {
			0.9,
			"Sine",
			"Out"
		});
		m_Functions.Tween(t_Loading.Black, {Size = UDim2.new(1, 0, 2, 0)}, {
			0.15,
			"Linear"
		});
		t_Loading.Gui.Enabled = true;
	end
	local function FadeOut() -- Line: 77
		--[[
			Upvalues:
				[1] = m_Functions
				[2] = t_Loading
				[3] = u2
				[4] = u4
		--]]
		m_Functions.Tween(t_Loading.GIF, {
			Position = u2,
			ImageTransparency = 1
		}, {
			1, -- 0.5
			"Sine",
			"Out"
		});
		m_Functions.Tween(t_Loading.Info, {Position = u4}, {
			0.5,
			"Sine",
			"Out"
		});
		m_Functions.Tween(t_Loading.Label, {TextTransparency = 1}, {
			0.4,
			"Sine",
			"Out"
		});
		m_Functions.Tween(t_Loading.Location, {TextTransparency = 1}, {
			0.4,
			"Sine",
			"Out"
		});
		m_Functions.Wait(1);
		t_Loading.Gui.Enabled = false;
	end
	local function MakeCircles() -- Line: 87
		--[[
			Upvalues:
				[1] = Assets
				[2] = t_Loading
				[3] = m_Functions
		--]]
		local v4 = 0;
		for index1 = 0, 16 do
			for index2 = 0, 20 do
				v4 = v4 + 1;
				local Clone_ret = Assets.UI.Loading.Circle:Clone();
				Clone_ret.Position = UDim2.new(index2 * 0.05, 0, index1 * 0.0625, 0);
				Clone_ret.Size = UDim2.new(0.25, 0, 0.3125, 0);
				Clone_ret.Parent = t_Loading.Black;
				local v5 = Clone_ret.Position.X.Scale * 2 * (Clone_ret.Position.Y.Scale * 2) / 3;
				m_Functions.Tween(Clone_ret, {Size = UDim2.new(0, 0, 0, 0)}, {
					v5 + 0.2,
					"Linear"
				}).Completed:Connect(function() -- Line: 101
					--[[
						Upvalues:
							[1] = Clone_ret
					--]]
					Clone_ret:Destroy();
				end);
			end
		end
		t_Loading.Black.BackgroundTransparency = 1;
	end
	local function Stop() -- Line: 111
		--[[
			Upvalues:
				[1] = MakeCircles
				[2] = FadeOut
				[3] = u5
				[4] = bool1
		--]]
		MakeCircles();
		FadeOut();
		u5();
		bool1 = false;
	end
	FadeIn();
	return Stop;
end;

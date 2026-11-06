-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local Color3_fromRGB_ret = Color3.fromRGB(255, 214, 112);
local Color3_fromRGB_ret2 = Color3.fromRGB(0, 187, 255);
local u1 = nil;
local u2 = nil;
local u3 = nil;
local u4 = true;
local bool1 = false;
local u5 = 0;
local Connect_ret = nil;
function Update() -- Line: 26
	--[[
		Upvalues:
			[1] = u4
			[2] = u2
			[3] = u3
			[4] = u1
			[5] = u4
			[6] = m_Library
			[7] = bool1
			[8] = Connect_ret
			[9] = u5
			[10] = Color3_fromRGB_ret2
			[11] = Color3_fromRGB_ret
	--]]
	local v1 = u4 and u2 or u3;
	if not u1 or not v1 or not u1:FindFirstChild("Main") then return end
	local SurfaceGui = u1.Main:FindFirstChildOfClass("SurfaceGui");
	local PowerTitle = SurfaceGui:FindFirstChild("PowerTitle");
	PowerTitle.Visible = not u4;
	local RAPTitle = SurfaceGui:FindFirstChild("RAPTitle");
	RAPTitle.Visible = u4;
	if u4 ~= u4 then
		local v4 = m_Library.Functions.DictionaryLength(u2);
		local v5 = m_Library.Functions.DictionaryLength(u3);
		if u4 == true and v4 < v5 then
			local _ = v5 - v4;
			for index1 = v4 + 1, v5 do
				local FindFirstChild_ret2 = SurfaceGui.Frame:FindFirstChild("Spot" .. index1);
				if FindFirstChild_ret2 then
					FindFirstChild_ret2:Destroy();
				end
			end
		elseif u4 == false and v5 < v4 then
			local _ = v4 - v5;
			for index2 = v5 + 1, v4 do
				local FindFirstChild_ret = SurfaceGui.Frame:FindFirstChild("Spot" .. index2);
				if FindFirstChild_ret then
					FindFirstChild_ret:Destroy();
				end
			end
		end
	end
	u4 = u4;
	for key1, val1 in ipairs(v1) do
		local v6 = SurfaceGui.Frame:FindFirstChild("Spot" .. key1);
		if not v6 then
			local v7 = key1 <= 3;
			v6 = m_Library.Assets.UI.Leaderboard.Spot:Clone();
			v6.LayoutOrder = key1;
			v6.Rank.Text = "#" .. key1;
			v6.Name = "Spot" .. key1;
			v6.Size = UDim2.new(1, 0, 0, v7 and 50 or 45);
			v6.Rank.TextColor3 = v7 and Color3.fromRGB(180, 170, 31) or Color3.fromRGB(102, 102, 102);
			v6.Parent = SurfaceGui.Frame;
		end
		v6.Icon.Visible = u4 == true;
		v6.PetIcon.Visible = u4 == false;
		v6.Score.Text = m_Library.Functions.NumberShorten(val1.level, false);
		v6.Username.Text = "@" .. val1.username;
		if val1.username == m_Library.LocalPlayer.Name then
			v6.Username.TextColor3 = Color3.fromRGB(103, 255, 103);
			continue;
		end
		v6.Username.TextColor3 = Color3.fromRGB(121, 121, 121);
	end
	local Buttons = SurfaceGui:FindFirstChild("Buttons");
	local Power = Buttons:FindFirstChild("Power"):FindFirstChild("Power");
	local RAP = Buttons:FindFirstChild("RAP"):FindFirstChild("RAP");
	if not bool1 then
		Power.Visible = true;
		RAP.Visible = true;
		Power.Activated:Connect(function() -- Line: 95
			--[[
				Upvalues:
					[1] = Connect_ret
					[2] = u5
					[3] = u4
					[4] = Power
					[5] = RAP
					[6] = Color3_fromRGB_ret2
					[7] = Color3_fromRGB_ret
					[8] = m_Library
			--]]
			if Connect_ret then
				Connect_ret:Disconnect();
			end
			u5 = 0;
			u4 = false;
			Power.Image = u4 and "rbxassetid://11632629004" or "rbxassetid://11632629074";
			RAP.Image = u4 and "rbxassetid://11632629074" or "rbxassetid://11632629004";
			Power.ImageColor3 = u4 and Color3_fromRGB_ret2 or Color3_fromRGB_ret;
			RAP.ImageColor3 = u4 and Color3_fromRGB_ret or Color3_fromRGB_ret2;
			Update();
			m_Library.Signal.Fire("Local Leaderboard: Update");
		end);
		RAP.Activated:Connect(function() -- Line: 108
			--[[
				Upvalues:
					[1] = Connect_ret
					[2] = u5
					[3] = u4
					[4] = Power
					[5] = RAP
					[6] = Color3_fromRGB_ret2
					[7] = Color3_fromRGB_ret
					[8] = m_Library
			--]]
			if Connect_ret then
				Connect_ret:Disconnect();
			end
			u5 = 0;
			u4 = true;
			Power.Image = u4 and "rbxassetid://11632629004" or "rbxassetid://11632629074";
			RAP.Image = u4 and "rbxassetid://11632629074" or "rbxassetid://11632629004";
			Power.ImageColor3 = u4 and Color3_fromRGB_ret2 or Color3_fromRGB_ret;
			RAP.ImageColor3 = u4 and Color3_fromRGB_ret or Color3_fromRGB_ret2;
			Update();
			m_Library.Signal.Fire("Local Leaderboard: Update");
		end);
		m_Library.GUIFX.ButtonFX(Power);
		m_Library.GUIFX.ButtonFX(RAP);
		bool1 = true;
	end
	Power.Image = u4 and "rbxassetid://11632629004" or "rbxassetid://11632629074";
	RAP.Image = u4 and "rbxassetid://11632629074" or "rbxassetid://11632629004";
	SurfaceGui.Frame.CanvasSize = UDim2.new(0, 0, 0, SurfaceGui.Frame:FindFirstChildOfClass("UIListLayout").AbsoluteContentSize.Y);
end
function Grab() -- Line: 135
	--[[
		Upvalues:
			[1] = m_Library
			[2] = u2
			[3] = u3
	--]]
	local v2 = m_Library.Network.Invoke("Get Global Leaderboard");
	if v2 then
		u2 = v2;
		Update();
	end
	local v3 = m_Library.Network.Invoke("Get Global Power Leaderboard");
	if v3 then
		u3 = v3;
		Update();
	end
end
function Check() -- Line: 150
	--[[
		Upvalues:
			[1] = m_Library
			[2] = u1
	--]]
	local Map = m_Library.WorldCmds.GetMap();
	if Map:FindFirstChild("Interactive") then
		u1 = Map.Interactive:FindFirstChild("Leaderboard");
		if u1 then
			Update();
		end
	end
end
m_Library.Signal.Fired("World Changed"):Connect(function() -- Line: 166
	--[[
		Upvalues:
			[1] = u1
			[2] = bool1
	--]]
	u1 = nil;
	bool1 = false;
	Check();
end);
m_Library.Signal.Invoked("Leaderboard: Is Displaying RAP").OnInvoke = function() -- Line: 172
	--[[
		Upvalues:
			[1] = u4
	--]]
	return u4;
end
task.delay(10, function() -- Line: 176
	--[[
		Upvalues:
			[1] = Connect_ret
			[2] = m_Library
			[3] = u1
			[4] = u5
			[5] = u4
			[6] = Color3_fromRGB_ret2
			[7] = Color3_fromRGB_ret
	--]]
	Connect_ret = m_Library.RunService.Heartbeat:Connect(function(p1) -- Line: 177
		--[[
			Upvalues:
				[1] = u1
				[2] = u5
				[3] = u4
				[4] = Color3_fromRGB_ret2
				[5] = Color3_fromRGB_ret
				[6] = m_Library
		--]]
		if not u1 then return end
		u5 = u5 + p1;
		if u5 >= 60 then
			u5 = 0;
			u4 = not u4;
			local SurfaceGui2 = u1.Main:FindFirstChildOfClass("SurfaceGui");
			local Buttons2 = SurfaceGui2:FindFirstChild("Buttons");
			local Power2 = Buttons2:FindFirstChild("Power"):FindFirstChild("Power");
			local RAP2 = Buttons2:FindFirstChild("RAP"):FindFirstChild("RAP");
			Power2.Image = u4 and "rbxassetid://11632629004" or "rbxassetid://11632629074";
			RAP2.Image = u4 and "rbxassetid://11632629074" or "rbxassetid://11632629004";
			Power2.ImageColor3 = u4 and Color3_fromRGB_ret2 or Color3_fromRGB_ret;
			RAP2.ImageColor3 = u4 and Color3_fromRGB_ret or Color3_fromRGB_ret2;
			Update();
			m_Library.Signal.Fire("Local Leaderboard: Update");
		end
	end);
end);
local coroutine_wrap_ret = coroutine.wrap(function() -- Line: 204
	--[[
		Upvalues:
			[1] = u1
	--]]
	while true do
		if u1 then
			Grab();
		end
		wait(10);
	end
end);
coroutine_wrap_ret();

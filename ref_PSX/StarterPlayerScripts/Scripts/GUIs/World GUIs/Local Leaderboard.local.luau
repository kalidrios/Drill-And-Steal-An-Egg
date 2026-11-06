-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local u1 = nil;
local u2 = nil;
local u3 = nil;
local u4 = nil;
function Update() -- Line: 19
	--[[
		Upvalues:
			[1] = m_Library
			[2] = u4
			[3] = u2
			[4] = u3
			[5] = u1
	--]]
	local v1 = m_Library.Signal.Invoke("Leaderboard: Is Displaying RAP");
	if u4 == nil then
		u4 = v1;
	end
	local v2 = v1 and u2 or u3;
	if not u1 or not v2 or not u1:FindFirstChild("Main") then return end
	local SurfaceGui = u1.Main:FindFirstChildOfClass("SurfaceGui");
	if u4 ~= v1 then
		local v5 = m_Library.Functions.DictionaryLength(u2);
		local v6 = m_Library.Functions.DictionaryLength(u3);
		if v1 == true and v5 < v6 then
			local _ = v6 - v5;
			for index1 = v5 + 1, v6 do
				local FindFirstChild_ret2 = SurfaceGui.Frame:FindFirstChild("Spot" .. index1);
				if FindFirstChild_ret2 then
					FindFirstChild_ret2:Destroy();
				end
			end
		elseif v1 == false and v6 < v5 then
			local _ = v5 - v6;
			for index3 = v6 + 1, v5 do
				local FindFirstChild_ret = SurfaceGui.Frame:FindFirstChild("Spot" .. index3);
				if FindFirstChild_ret then
					FindFirstChild_ret:Destroy();
				end
			end
		end
	end
	u4 = v1;
	if u4 ~= v1 then
		local v7 = m_Library.Functions.DictionaryLength(u2);
		local v8 = m_Library.Functions.DictionaryLength(u3);
		if v1 == true and v7 < v8 then
			local _ = v8 - v7;
			for index2 = v7 + 1, v8 do
				local FindFirstChild_ret4 = SurfaceGui.Frame:FindFirstChild("Spot" .. index2);
				if FindFirstChild_ret4 then
					FindFirstChild_ret4:Destroy();
				end
			end
		elseif v1 == false and v8 < v7 then
			local _ = v7 - v8;
			for index4 = v8 + 1, v7 do
				local FindFirstChild_ret3 = SurfaceGui.Frame:FindFirstChild("Spot" .. index4);
				if FindFirstChild_ret3 then
					FindFirstChild_ret3:Destroy();
				end
			end
		end
	end
	u4 = v1;
	for key1, val1 in ipairs(v2) do
		local t_player = val1.player;
		local _ = val1.level;
		local v9 = SurfaceGui.Frame:FindFirstChild(t_player.Name);
		if not v9 then
			v9 = m_Library.Assets.UI.Leaderboard.Spot:Clone();
			v9.Name = t_player.Name;
			v9.Size = UDim2.new(1, 0, 0, 46);
			v9.Rank.Visible = false;
			v9.Parent = SurfaceGui.Frame;
		end
		v9.Icon.Visible = v1 == true;
		v9.PetIcon.Visible = v1 == false;
		v9.Score.Text = m_Library.Functions.NumberShorten(val1.level, false);
		v9.Username.Text = t_player.DisplayName .. " (@" .. t_player.Name .. ")";
		v9.LayoutOrder = key1;
		if t_player == m_Library.LocalPlayer then
			v9.Username.TextColor3 = Color3.fromRGB(103, 255, 103);
			continue;
		end
		v9.Username.TextColor3 = Color3.fromRGB(121, 121, 121);
	end
	for _, child2 in ipairs(SurfaceGui.Frame:GetChildren()) do
		if child2.ClassName ~= "Frame" or game.Players:FindFirstChild(child2.Name) then continue end
		child2:Destroy();
	end
	SurfaceGui.Frame.CanvasSize = UDim2.new(0, 0, 0, SurfaceGui.Frame:FindFirstChildOfClass("UIListLayout").AbsoluteContentSize.Y);
end
function Grab() -- Line: 118
	--[[
		Upvalues:
			[1] = m_Library
			[2] = u2
			[3] = u3
	--]]
	local v3 = m_Library.Network.Invoke("Get Local Leaderboard");
	if v3 then
		u2 = v3;
	end
	local v4 = m_Library.Network.Invoke("Get Local Power Leaderboard");
	if v4 then
		u3 = v4;
	end
	Update();
end
function Check() -- Line: 133
	--[[
		Upvalues:
			[1] = m_Library
			[2] = u1
	--]]
	local Map = m_Library.WorldCmds.GetMap();
	if Map:FindFirstChild("Interactive") then
		u1 = Map.Interactive:FindFirstChild("Local Leaderboard");
		if u1 then
			Update();
		end
	end
end
m_Library.Signal.Fired("Local Leaderboard: Update"):Connect(Update);
m_Library.Signal.Fired("World Changed"):Connect(function() -- Line: 150
	--[[
		Upvalues:
			[1] = u1
	--]]
	u1 = nil;
	Check();
end);
local coroutine_wrap_ret = coroutine.wrap(function() -- Line: 156
	--[[
		Upvalues:
			[1] = u1
	--]]
	while true do
		if u1 then
			Grab();
		end
		wait(2);
	end
end);
coroutine_wrap_ret();


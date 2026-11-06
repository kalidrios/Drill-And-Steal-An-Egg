-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local t_CoinGrabDistance = m_Library.Settings.CoinGrabDistance;
local Coins = m_Library.Things:WaitForChild("Coins");
local u1 = m_Library.Player.Camera();
local u2 = nil;
local u3 = nil;
function SelectCoin(p1, p2) -- Line: 20
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local Attribute = p1:GetAttribute("Area");
	local v1 = m_Library.WorldCmds.HasArea(Attribute);
	local Coin = p1:FindFirstChild("Coin");
	if Coin and Coin:GetAttribute("PreventClick") then return end
	if v1 then
		if p2 then
			m_Library.Signal.Fire("Group Select Coin", p1);
			return;
		end
		m_Library.Signal.Fire("Select Coin", p1);
	end
end
function ProcessInput(p3) -- Line: 40
	--[[
		Upvalues:
			[1] = m_Library
			[2] = u1
			[3] = Coins
			[4] = t_CoinGrabDistance
	--]]
	if not m_Library.WorldCmds.CanDoAction() then return end
	local ScreenPointToRay_ret = u1:ScreenPointToRay(p3.X, p3.Y);
	local RaycastParams_new_ret = RaycastParams.new();
	RaycastParams_new_ret.FilterDescendantsInstances = {Coins};
	RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Whitelist;
	local Raycast_ret = game.Workspace:Raycast(ScreenPointToRay_ret.Origin, ScreenPointToRay_ret.Direction * 1000, RaycastParams_new_ret);
	if Raycast_ret and Raycast_ret.Instance then
		local v2 = Raycast_ret.Instance;
		if m_Library.LocalPlayer:DistanceFromCharacter(v2.CFrame.p) <= t_CoinGrabDistance then
			while true do
				v2 = v2.Parent;
				if not v2 then break end
				if not v2:GetAttribute("ID") then continue end
				return v2;
			end
		end
	end
end
function InputDown(p4) -- Line: 70
	--[[
		Upvalues:
			[1] = m_Library
			[2] = u3
			[3] = u2
	--]]
	local ProcessInput_ret = ProcessInput(p4);
	if ProcessInput_ret or m_Library.Variables.Desktop then
		u3 = ProcessInput_ret;
		u2 = os.clock();
	end
end
function InputUp(p5) -- Line: 79
	--[[
		Upvalues:
			[1] = u2
			[2] = u3
			[3] = m_Library
	--]]
	local ProcessInput_ret2 = ProcessInput(p5);
	if ProcessInput_ret2 and u2 and (u3 == ProcessInput_ret2 or m_Library.Variables.Desktop) then
		SelectCoin(ProcessInput_ret2, os.clock() - u2 > 0.35);
	end
	u2 = nil;
	u3 = nil;
end
m_Library.UserInputService.TouchStarted:Connect(function(p6, p7) -- Line: 95
	if not p7 then
		InputDown(p6.Position);
	end
end);
m_Library.UserInputService.TouchEnded:Connect(function(hit, p8) -- Line: 102
	if not p8 then
		InputUp(hit.Position);
	end
end);
m_Library.UserInputService.InputBegan:Connect(function(input, gameProcessedEvent) -- Line: 110
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local t_UserInputType = input.UserInputType;
	local _ = input.UserInputState;
	local t_KeyCode = input.KeyCode;
	if not gameProcessedEvent and (t_UserInputType == Enum.UserInputType.MouseButton1 or t_KeyCode == Enum.KeyCode.ButtonX or t_KeyCode == Enum.KeyCode.ButtonR2 or t_KeyCode == Enum.KeyCode.ButtonL2) then
		InputDown(m_Library.UserInputService:GetMouseLocation() - Vector2.new(0, 36));
	end
end);
m_Library.UserInputService.InputEnded:Connect(function(input2, gameProcessedEvent2) -- Line: 119
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local t_UserInputType2 = input2.UserInputType;
	local _ = input2.UserInputState;
	local t_KeyCode2 = input2.KeyCode;
	if not gameProcessedEvent2 and (t_UserInputType2 == Enum.UserInputType.MouseButton1 or t_KeyCode2 == Enum.KeyCode.ButtonX or t_KeyCode2 == Enum.KeyCode.ButtonR2 or t_KeyCode2 == Enum.KeyCode.ButtonL2) then
		InputUp(m_Library.UserInputService:GetMouseLocation() - Vector2.new(0, 36));
	end
end);

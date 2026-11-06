-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local t_PetGrabDistance = m_Library.Settings.PetGrabDistance or 300;
local Pets = m_Library.Things:WaitForChild("Pets");
local u1 = m_Library.Player.Camera();
local u2 = nil;
local u3 = nil;
function SelectPet(p1, p2) -- Line: 20
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	m_Library.Signal.Fire("Select Pet", p1, p2);
end
function ProcessInput(p3) -- Line: 25
	--[[
		Upvalues:
			[1] = m_Library
			[2] = u1
			[3] = Pets
			[4] = t_PetGrabDistance
	--]]
	if not m_Library.WorldCmds.CanDoAction() then return end
    local ScreenPointToRay_ret = u1:ScreenPointToRay(p3.X, p3.Y);
	local RaycastParams_new_ret = RaycastParams.new();
	RaycastParams_new_ret.FilterDescendantsInstances = { game:GetService("Workspace"):WaitForChild("__THINGS"):WaitForChild("Pets") };
    RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Whitelist;
    
    local Raycast_ret = workspace:Raycast(ScreenPointToRay_ret.Origin, ScreenPointToRay_ret.Direction * 1000, RaycastParams_new_ret);
    
	if Raycast_ret and Raycast_ret.Instance then
		local t_Instance = Raycast_ret.Instance;
        if m_Library.LocalPlayer:DistanceFromCharacter(t_Instance.CFrame.p) <= t_PetGrabDistance then
			return t_Instance;
		end
	end
end
function InputDown(p4) -- Line: 47
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
function InputUp(p5) -- Line: 56
	--[[
		Upvalues:
			[1] = u2
			[2] = u3
			[3] = m_Library
	--]]
    local ProcessInput_ret2 = ProcessInput(p5);
	if ProcessInput_ret2 and u2 and (u3 == ProcessInput_ret2 or m_Library.Variables.Desktop) then
		SelectPet(ProcessInput_ret2, os.clock() - u2 > 0.35);
	end
	u2 = nil;
	u3 = nil;
end
m_Library.UserInputService.TouchStarted:Connect(function(p6, p7) -- Line: 72
	if not p7 then
		InputDown(p6.Position);
	end
end);
m_Library.UserInputService.TouchEnded:Connect(function(hit, p8) -- Line: 79
	if not p8 then
		InputUp(hit.Position);
	end
end);
m_Library.UserInputService.InputBegan:Connect(function(input, gameProcessedEvent) -- Line: 87
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
m_Library.UserInputService.InputEnded:Connect(function(input2, gameProcessedEvent2) -- Line: 96
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

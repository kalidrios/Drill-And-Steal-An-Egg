-- https://github.com/kalidrios

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Library = ReplicatedStorage:WaitForChild("Library");
local m_Functions = require(Library.Functions);
local m_Variables = require(Library.Variables);
local m_CacheProperty = require(script.Parent.CacheProperty);
local m_InteractSound = require(script.Parent.InteractSound);
return function(p1, _)
	local table1 = {};
	local u1 = false;
	local u2 = false;
	local u3 = p1:FindFirstChildOfClass("UIScale");
	if not u3 then
		local ButtonUIScale = Instance.new("UIScale");
		ButtonUIScale.Name = "ButtonUIScale";
		ButtonUIScale.Parent = p1;
		u3 = ButtonUIScale;
	end
	assert(u3);
	local table2 = {};
	for _, child1 in ipairs(p1:GetChildren()) do
		if not child1:IsA("TextLabel") or not child1.Visible then continue end
		table2[child1] = m_CacheProperty(child1, "Position");
	end
	local function Down() 
		if not u1 then
			u1 = not u1;
			m_Functions.Tween(u3, {Scale = 0.9}, {
				0.065,
				Enum.EasingStyle.Exponential,
				"Out"
			});
		end
	end
	local function Up() 
		if u1 then
			u1 = not u1;
			m_Functions.Tween(u3, {Scale = 1}, {
				0.25,
				Enum.EasingStyle.Circular,
				"Out"
			});
		end
	end
	local function MouseLeave() 
		if u2 then
			u2 = not u2;
			if not u1 then
				m_Functions.Tween(u3, {Scale = 1}, {
					0.035,
					Enum.EasingStyle.Exponential,
					"Out"
				});
			end
		end
	end
	local function MouseEnter() 
		if not u2 then
			u2 = not u2;
			if not u1 then
				m_Functions.Tween(u3, {Scale = 1.05}, {
					0.05,
					Enum.EasingStyle.Circular,
					"Out"
				});
			end
		end
	end
	local function Events() 
		table1[#table1 + 1] = p1.InputBegan:Connect(function(input) 
			if not p1.Active then return end
			local t_UserInputType = input.UserInputType;
			local t_UserInputState = input.UserInputState;
			local t_KeyCode = input.KeyCode;
			if t_UserInputType == Enum.UserInputType.MouseButton1 or t_UserInputType == Enum.UserInputType.Touch and t_UserInputState == Enum.UserInputState.Begin or t_KeyCode == Enum.KeyCode.ButtonA then
				Down();
			end
		end);
		table1[#table1 + 1] = p1.InputEnded:Connect(function(input2) 
			if not p1.Active then return end
			local t_UserInputType2 = input2.UserInputType;
			local _ = input2.UserInputState;
			local t_KeyCode2 = input2.KeyCode;
			if t_UserInputType2 == Enum.UserInputType.MouseButton1 or t_UserInputType2 == Enum.UserInputType.Touch or t_KeyCode2 == Enum.KeyCode.ButtonA then
				Up();
			end
		end);
		table1[#table1 + 1] = p1.MouseEnter:Connect(function() 
			if not p1.Active then return end
			if m_Variables.Desktop then
				MouseEnter();
			end
		end);
		table1[#table1 + 1] = p1.MouseLeave:Connect(function() 
			if not p1.Active then return end
			if m_Variables.Desktop then
				MouseLeave();
			end
		end);
	end
	Events();
	local u8 = m_InteractSound(p1, "mousedown", "rbxassetid://7000714975", 0.1, true);
	local u9 = m_InteractSound(p1, "mouseup", "rbxassetid://7000715003", 0.1, true);
	return function() 
		for _, val2 in ipairs(table1) do
			val2:Disconnect();
		end
		u8();
		u9();
	end;
end;

-- https://github.com/kalidrios

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Library = ReplicatedStorage:WaitForChild("Library");
local Client = Library:WaitForChild("Client");
local m_Audio = require(Library.Audio);
local _ = require(Client.Settings);
return function(p1, p2, p3, p4, p5) -- Line: 37
	--[[
		Upvalues:
			[1] = m_Audio
	--]]
	local table1 = {};
	p2 = string.lower(p2);
	local u1 = p4 or 0.15;
	local u2 = p5 ~= nil and p5 or false;
	if p2 == "mousedown" then
		table1[#table1 + 1] = p1.InputBegan:Connect(function(input2) -- Line: 47
			--[[
				Upvalues:
					[1] = m_Audio
					[2] = p3
					[3] = u2
					[4] = u1
			--]]
			local t_UserInputType2 = input2.UserInputType;
			local t_UserInputState2 = input2.UserInputState;
			local t_KeyCode2 = input2.KeyCode;
			if t_UserInputType2 == Enum.UserInputType.MouseButton1 or t_UserInputType2 == Enum.UserInputType.Touch and t_UserInputState2 == Enum.UserInputState.Begin or t_KeyCode2 == Enum.KeyCode.ButtonA then
				m_Audio.Play(p3, script, u2 and math.random(95, 105) / 100 or 1, u1 * 2);
			end
		end);
	elseif p2 == "mouseup" then
		table1[#table1 + 1] = p1.InputEnded:Connect(function(input) -- Line: 56
			--[[
				Upvalues:
					[1] = m_Audio
					[2] = p3
					[3] = u2
					[4] = u1
			--]]
			local t_UserInputType = input.UserInputType;
			local t_UserInputState = input.UserInputState;
			local t_KeyCode = input.KeyCode;
			if t_UserInputType == Enum.UserInputType.MouseButton1 or t_UserInputType == Enum.UserInputType.Touch and t_UserInputState == Enum.UserInputState.End or t_KeyCode == Enum.KeyCode.ButtonA then
				m_Audio.Play(p3, script, u2 and math.random(95, 105) / 100 or 1, u1 * 2);
			end
		end);
	elseif p2 == "mouseenter" then
		table1[#table1 + 1] = p1.MouseEnter:Connect(function() -- Line: 65
			--[[
				Upvalues:
					[1] = m_Audio
					[2] = p3
					[3] = u2
					[4] = u1
			--]]
			m_Audio.Play(p3, script, u2 and math.random(95, 105) / 100 or 1, u1);
		end);
	elseif p2 == "mouseleave" then
		table1[#table1 + 1] = p1.MouseLeave:Connect(function() -- Line: 71
			--[[
				Upvalues:
					[1] = m_Audio
					[2] = p3
					[3] = u2
					[4] = u1
			--]]
			m_Audio.Play(p3, script, u2 and math.random(95, 105) / 100 or 1, u1);
		end);
	elseif p2 == "mouseclick" then
		table1[#table1 + 1] = p1.Activated:Connect(function() -- Line: 77
			--[[
				Upvalues:
					[1] = m_Audio
					[2] = p3
					[3] = u2
					[4] = u1
			--]]
			m_Audio.Play(p3, script, u2 and math.random(95, 105) / 100 or 1, u1);
		end);
	end
	return function() -- Line: 83
		--[[
			Upvalues:
				[1] = table1
		--]]
		for _, val1 in ipairs(table1) do
			val1:Disconnect();
		end
	end;
end;

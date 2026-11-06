-- https://github.com/kalidrios

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local m_Functions = require(ReplicatedStorage:WaitForChild("Library").Functions);
return function(p1) -- Line: 35
	--[[
		Upvalues:
			[1] = m_Functions
	--]]
	if p1.ClassName ~= "TextLabel" then
		warn("Only supports TextLabel");
		return function() -- Line: 38
		end;
	end
	local Clone_ret = p1:Clone();
	Clone_ret.AutoLocalize = false;
	Clone_ret.Name = p1.Name .. "_odometerGUIFX";
	Clone_ret.Text = p1.Text;
	Clone_ret.Parent = p1.Parent;
	p1.Visible = false;
	local u1 = nil;
	local u2 = 0;
	local function Update() -- Line: 53
		--[[
			Upvalues:
				[1] = u2
				[2] = p1
				[3] = u1
				[4] = Clone_ret
				[5] = m_Functions
		--]]
		u2 = u2 + 1;
		local u4 = u2;
		local string_gsub_ret = string.gsub(p1.Text, ",", "");
		local tonumber_ret = tonumber(string_gsub_ret);
		local u5;
		if tonumber_ret == nil then
			u5 = false;
		else
			u5 = tostring(tonumber_ret) ~= p1.Text;
		end
		if u1 and tonumber_ret then
			local coroutine_wrap_ret = coroutine.wrap(function() -- Line: 62
				--[[
					Upvalues:
						[1] = u1
						[2] = tonumber_ret
						[3] = u4
						[4] = u2
						[5] = Clone_ret
						[6] = u5
						[7] = m_Functions
						[8] = p1
				--]]
				local v1 = u1;
				local v2 = tonumber_ret - v1;
				local math_clamp_ret = math.clamp(math.abs(v2), 1, 15);
				local math_round_ret = math.round(v2 / math_clamp_ret);
				for index1 = 1, math_clamp_ret do
					if u4 ~= u2 or not Clone_ret or not Clone_ret.Parent then return end
					local v3 = v1 + math_round_ret * index1;
					Clone_ret.Text = u5 and m_Functions.Commas(v3) or tostring(v3);
					m_Functions.Wait(0.01);
				end
				if u4 == u2 and Clone_ret and Clone_ret.Parent then
					Clone_ret.Text = p1.Text;
				end
			end);
			coroutine_wrap_ret();
		elseif Clone_ret then
			Clone_ret.Text = p1.Text;
		end
		if tonumber_ret then
			u1 = tonumber_ret;
		end
	end
	local function Delete() -- Line: 93
		--[[
			Upvalues:
				[1] = Clone_ret
				[2] = p1
		--]]
		Clone_ret:Destroy();
		if p1 then
			p1.Visible = true;
		end
	end
	p1:GetPropertyChangedSignal("Text"):Connect(function() -- Line: 101
		--[[
			Upvalues:
				[1] = Update
		--]]
		Update();
	end);
	p1.AncestryChanged:Connect(function() -- Line: 105
		--[[
			Upvalues:
				[1] = p1
				[2] = Clone_ret
		--]]
		if not p1 or not p1.Parent then
			Clone_ret:Destroy();
			if p1 then
				p1.Visible = true;
			end
		end
	end);
	Update();
	return function() -- Line: 115
		--[[
			Upvalues:
				[1] = Clone_ret
				[2] = p1
		--]]
		Clone_ret:Destroy();
		if p1 then
			p1.Visible = true;
		end
	end;
end;

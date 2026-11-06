-- https://github.com/kalidrios

local m_math_helper = require(script.Parent.math_helper);
local t_EPSILON = m_math_helper.EPSILON;
local vec3 = Vector3.new();
local table1 = {
	EPSILON = t_EPSILON,
	ID = vec3
};
local vec3_2 = Vector3.new(1, 0, 1);
function table1.interpolate_dash(p1, p2, p3, p4) -- Line: 14
	--[[
		Upvalues:
			[1] = t_EPSILON
			[2] = vec3_2
	--]]
	if not p3 and not p4 then
		return 1, 0, 0, 0;
	end
	local v1 = t_EPSILON;
	p2 = p2 * vec3_2;
	local t_Magnitude = p2.Magnitude;
	if t_Magnitude <= v1 then
		return 1, 0, 0, 0;
	end
	p2 = p2 / t_Magnitude;
	p2 = p1:VectorToObjectSpace(p2) * vec3_2;
	local t_Magnitude2 = p2.Magnitude;
	if t_Magnitude2 <= v1 then
		return 1, 0, 0, 0;
	end
	p2 = p2 / t_Magnitude2;
	if not p4 then
		if v1 < p2.Z then
			return 0, 1, 0, 0;
		end
		return 1, 0, 0, 0;
	end
	local v2 = 0;
	local v3 = 0;
	local t_Z = p2.Z;
	if p3 then
		if t_Z < -v1 then
			v2 = math.clamp(-t_Z, 0, 1);
		elseif v1 < t_Z then
			v3 = math.clamp(t_Z, 0, 1);
		end
	else
		local math_abs_ret = math.abs(t_Z);
		if v1 < math_abs_ret then
			v2 = math.clamp(math_abs_ret, 0, 1);
		end
	end
	local v4 = 0;
	local v5 = 0;
	local t_X = p2.X;
	if t_X < -v1 then
		v4 = math.clamp(-t_X, 0, 1);
	elseif v1 < t_X then
		v5 = math.clamp(t_X, 0, 1);
	end
	local math_max_ret = math.max(v2, (math.max(v3, (math.max(v4, v5)))));
	if math_max_ret <= v1 then
		return 1, 0, 0, 0;
	end
	local v6 = v2 / math_max_ret;
	local v7 = v3 / math_max_ret;
	local v8 = v4 / math_max_ret;
	return v6, v7, v8, v5 / math_max_ret;
end
function table1.huge() -- Line: 87
	return Vector3.new(math.huge, math.huge, math.huge);
end
function table1.len(p5) -- Line: 91
	return p5.Magnitude;
end
function table1.abs(p6) -- Line: 95
	return Vector3.new(math.abs(p6.X), math.abs(p6.Y), (math.abs(p6.Z)));
end
function table1.len_sq(p7) -- Line: 100
	local t_X2 = p7.X;
	local t_Y = p7.Y;
	local t_Z2 = p7.Z;
	return t_X2 * t_X2 + t_Y * t_Y + t_Z2 * t_Z2;
end
function table1.dist(p8, p9) -- Line: 107
	--[[
		Upvalues:
			[1] = table1
	--]]
	return table1.len(p9 - p8);
end
function table1.dist_sq(p10, p11) -- Line: 111
	--[[
		Upvalues:
			[1] = table1
	--]]
	return table1.len_sq(p11 - p10);
end
function table1.min(p12, p13) -- Line: 115
	return Vector3.new(math.min(p12.X, p13.X), math.min(p12.Y, p13.Y), (math.min(p12.Z, p13.Z)));
end
function table1.max(p14, p15) -- Line: 119
	return Vector3.new(math.max(p14.X, p15.X), math.max(p14.Y, p15.Y), (math.max(p14.Z, p15.Z)));
end
function table1.equals(p16, p17, p18) -- Line: 123
	--[[
		Upvalues:
			[1] = t_EPSILON
	--]]
	if p16 then
		if p17 then
			return p16:FuzzyEq(p17, p18 or t_EPSILON);
		end
		return false;
	end
	if p17 then
		return false;
	end
	return true;
end
function table1.from_color(p19) -- Line: 135
	return Vector3.new(p19.R, p19.G, p19.B);
end
function table1.to_color(p20) -- Line: 139
	return Color3.new(p20.X, p20.Y, p20.Z);
end
function table1.cframe_rad_delta(p21, p22) -- Line: 143
	--[[
		Upvalues:
			[1] = table1
	--]]
	return table1.rad_delta(Vector3.new(p21:ToOrientation()), (Vector3.new(p22:ToOrientation())));
end
function table1.cframe_deg_delta(p23, p24) -- Line: 150
	--[[
		Upvalues:
			[1] = table1
	--]]
	return table1.rad2deg(table1.cframe_rad_delta(p23, p24));
end
function table1.rad2deg(p25) -- Line: 155
	return Vector3.new(math.deg(p25.X), math.deg(p25.Y), (math.deg(p25.Z)));
end
function table1.deg2rad(p26) -- Line: 160
	return Vector3.new(math.rad(p26.X), math.rad(p26.Y), (math.rad(p26.Z)));
end
function table1.deg_norm(p27) -- Line: 165
	--[[
		Upvalues:
			[1] = m_math_helper
	--]]
	return Vector3.new(m_math_helper.deg_norm(p27.X), m_math_helper.deg_norm(p27.Y), m_math_helper.deg_norm(p27.Z));
end
function table1.rad_norm(p28) -- Line: 170
	--[[
		Upvalues:
			[1] = m_math_helper
	--]]
	return Vector3.new(m_math_helper.rad_norm(p28.X), m_math_helper.rad_norm(p28.Y), m_math_helper.rad_norm(p28.Z));
end
function table1.deg_delta_unsafe(p29, p30) -- Line: 175
	--[[
		Upvalues:
			[1] = m_math_helper
	--]]
	return Vector3.new(m_math_helper.deg_delta_unsafe(p29.X, p30.X), m_math_helper.deg_delta_unsafe(p29.Y, p30.Y), m_math_helper.deg_delta_unsafe(p29.Z, p30.Z));
end
function table1.deg_delta(p31, p32) -- Line: 179
	--[[
		Upvalues:
			[1] = m_math_helper
	--]]
	return Vector3.new(m_math_helper.deg_delta(p31.X, p32.X), m_math_helper.deg_delta(p31.Y, p32.Y), m_math_helper.deg_delta(p31.Z, p32.Z));
end
function table1.rad_delta_unsafe(p33, p34) -- Line: 184
	--[[
		Upvalues:
			[1] = m_math_helper
	--]]
	return Vector3.new(m_math_helper.rad_delta_unsafe(p33.X, p34.X), m_math_helper.rad_delta_unsafe(p33.Y, p34.Y), m_math_helper.rad_delta_unsafe(p33.Z, p34.Z));
end
function table1.rad_delta(p35, p36) -- Line: 188
	--[[
		Upvalues:
			[1] = m_math_helper
	--]]
	return Vector3.new(m_math_helper.rad_delta(p35.X, p36.X), m_math_helper.rad_delta(p35.Y, p36.Y), m_math_helper.rad_delta(p35.Z, p36.Z));
end
function table1.compute_meeting_point(p37, p38, p39, p40, p41) -- Line: 194
	--[[
		Upvalues:
			[1] = t_EPSILON
	--]]
	p40 = p40.Unit;
	local v9 = p39 - p37;
	local t_Magnitude3 = v9.Magnitude;
	local v10 = v9 / t_Magnitude3;
	if t_Magnitude3 <= t_EPSILON then
		return p39;
	end
	if p38 <= t_EPSILON then
		if p41 <= t_EPSILON then
			return nil;
		end
	elseif p41 <= t_EPSILON then
		return nil;
	end
	local _ = Vector3.new(0, 1, 0);
	local _ = p40:Cross(v10).Magnitude;
	local _ = p40:Dot(v10);
	return nil;
end
function table1.detect(p42, p43, p44, p45) -- Line: 230
	--[[
		Upvalues:
			[1] = table1
	--]]
	return table1.detect_dist(p42, p43, p44) and table1.detect_fov(p42, p43, p45);
end
function table1.detect_dist(p46, p47, p48) -- Line: 235
	if not p46 or not p47 then
		return false;
	end
	if p48 and p48 < math.huge then
		if p48 < 0 then
			return false;
		end
		if p48 < (p47 - p46.Position).Magnitude then
			return false;
		end
	end
	return true;
end
function table1.detect_fov(p49, p50, p51) -- Line: 256
	--[[
		Upvalues:
			[1] = table1
	--]]
	if not p49 or not p50 then
		return false;
	end
	if p51 and p51 < 360 then
		if p51 < 0 then
			return false;
		end
		local CFrame_lookAt_ret = CFrame.lookAt(p49.Position, p50);
		local v12 = table1.cframe_rad_delta(p49, CFrame_lookAt_ret);
		if math.abs(v12.X) > math.rad(p51) or math.abs(v12.Y) > math.rad(p51) then
			return false;
		end
	end
	return true;
end
local function check_stack(p52, p53) -- Line: 281
	local v11 = p52 and p52 or 0;
	if p53 <= v11 then
		warn("Psuedo-Stack overflow: " .. tostring(v11));
		return nil;
	end
	return v11 + 1;
end
function table1.to_vector3(p54, p55) -- Line: 298
	--[[
		Upvalues:
			[1] = table1
	--]]
	if p54 then
		local typeof_ret = typeof(p54);
		if typeof_ret == "table" then
			local t_Position = p54.Position;
			if typeof(t_Position) == "Vector3" then
				return t_Position;
			end
			local t_Value = p54.Value;
			if t_Value then
				local v13 = p55;
				local v14 = v13 and v13 or 0;
				if v14 >= 1 then
					warn("Psuedo-Stack overflow: " .. tostring(v14));
					p55 = nil;
				else
					p55 = v14 + 1;
				end
				if not p55 then
					return nil;
				end
				local v15 = table1.to_vector3(t_Value, p55);
				if v15 then
					return v15;
				end
			end
		else
			if typeof_ret == "CFrame" then
				return p54.Position;
			end
			if typeof_ret == "Vector3" then
				return p54;
			end
			if typeof_ret == "function" then
				local v16 = p55;
				local v17 = v16 and v16 or 0;
				if v17 >= 1 then
					warn("Psuedo-Stack overflow: " .. tostring(v17));
					p55 = nil;
				else
					p55 = v17 + 1;
				end
				if not p55 then
					return nil;
				end
				local v18 = table1.to_vector3(p54(), p55);
				if v18 then
					return v18;
				end
			elseif typeof_ret == "Instance" then
				if p54:IsA("BasePart") then
					return p54.Position;
				end
				if p54:IsA("Attachment") then
					return p54.Position;
				end
				if p54:IsA("Model") then
					local t_PrimaryPart2 = p54.PrimaryPart;
					if t_PrimaryPart2 then
						return t_PrimaryPart2.Position;
					end
				elseif p54:IsA("Humanoid") then
					local t_RootPart = p54.RootPart;
					if t_RootPart then
						return t_RootPart.Position;
					end
				elseif p54:IsA("Player") then
					local t_Character = p54.Character;
					if t_Character then
						local t_PrimaryPart = t_Character.PrimaryPart;
						if t_PrimaryPart then
							return t_PrimaryPart.Position;
						end
					end
				elseif p54:IsA("ObjectValue") then
					local v19 = p55;
					local v20 = v19 and v19 or 0;
					if v20 >= 1 then
						warn("Psuedo-Stack overflow: " .. tostring(v20));
						p55 = nil;
					else
						p55 = v20 + 1;
					end
					if not p55 then
						return nil;
					end
					local v21 = table1.to_vector3(p54.Value, p55);
					if v21 then
						return v21;
					end
				end
			end
		end
	end
	return nil;
end
return table1;

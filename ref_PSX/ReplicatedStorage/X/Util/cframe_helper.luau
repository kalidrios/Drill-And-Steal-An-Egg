-- https://github.com/kalidrios

local m_math_helper = require(script.Parent.math_helper);
local m_objects = require(script.Parent.objects);
local m_IntrCanonicalBox3Cylinder3 = require(script.Parent.IntrCanonicalBox3Cylinder3);
local t_EPSILON = m_math_helper.EPSILON;
local table1 = {EPSILON = t_EPSILON};
function table1.set_cframe(p1, p2, p3, p4) -- Line: 12
	--[[
		Upvalues:
			[1] = table1
	--]]
	if p3 then
		if p4 then
			return p2;
		end
		return table1.set_position(p1, p2);
	end
	if p4 then
		return table1.set_orientation(p1, p2);
	end
	return p1;
end
function table1.set_position(p5, p6) -- Line: 26
	return p5 + (p6.Position - p5.Position);
end
function table1.set_position_vec(p7, p8) -- Line: 30
	return p7 + (p8 - p7.Position);
end
function table1.set_orientation(p9, p10) -- Line: 34
	return p10 + (p9.Position - p10.Position);
end
function table1.get_position(p11) -- Line: 38
	return CFrame.new(p11.Position);
end
function table1.get_orientation(p12) -- Line: 42
	return p12 - p12.Position;
end
function table1.orient_up(p13) -- Line: 48
	local GetComponents_ret1, GetComponents_ret2, GetComponents_ret3, GetComponents_ret4, _, GetComponents_ret6, GetComponents_ret7, _, GetComponents_ret9, GetComponents_ret10, _, GetComponents_ret12 = p13:GetComponents();
	return CFrame.new(GetComponents_ret1, GetComponents_ret2, GetComponents_ret3, GetComponents_ret4, 0, GetComponents_ret6, GetComponents_ret7, 1, GetComponents_ret9, GetComponents_ret10, 0, GetComponents_ret12);
end
function table1.volume_contains_point(_, _, _, _, _) -- Line: 53
	return false;
end
function table1.volume_intersects_box(_, _, _, _, _) -- Line: 58
	return false;
end
function table1.model_to_min_max(p14) -- Line: 64
	--[[
		Upvalues:
			[1] = m_objects
	--]]
	local v1 = math.huge;
	local v2 = math.huge;
	local v3 = math.huge;
	local v4 = -math.huge;
	local v5 = -math.huge;
	local v6 = -math.huge;
	for _, descendant1 in pairs(p14:GetDescendants()) do
		if not descendant1:IsA("BasePart") then continue end
		local v20 = m_objects.type_cast(descendant1);
		local t_CFrame = v20.CFrame;
		local t_Size = v20.Size;
		local t_X = t_Size.X;
		local t_Y = t_Size.Y;
		local t_Z = t_Size.Z;
		local GetComponents_ret1_2, GetComponents_ret2_2, GetComponents_ret3_2, GetComponents_ret4_2, GetComponents_ret5, GetComponents_ret6_2, GetComponents_ret7_2, GetComponents_ret8, GetComponents_ret9_2, GetComponents_ret10_2, GetComponents_ret11, GetComponents_ret12_2 = t_CFrame:GetComponents();
		local v21 = (math.abs(GetComponents_ret4_2) * t_X + math.abs(GetComponents_ret5) * t_Y + math.abs(GetComponents_ret6_2) * t_Z) * 0.5;
		local v22 = (math.abs(GetComponents_ret7_2) * t_X + math.abs(GetComponents_ret8) * t_Y + math.abs(GetComponents_ret9_2) * t_Z) * 0.5;
		local v23 = (math.abs(GetComponents_ret10_2) * t_X + math.abs(GetComponents_ret11) * t_Y + math.abs(GetComponents_ret12_2) * t_Z) * 0.5;
		if GetComponents_ret1_2 - v21 < v1 then
			v1 = GetComponents_ret1_2 - v21;
		end
		if GetComponents_ret2_2 - v22 < v2 then
			v2 = GetComponents_ret2_2 - v22;
		end
		if GetComponents_ret3_2 - v23 < v3 then
			v3 = GetComponents_ret3_2 - v23;
		end
		if v4 < GetComponents_ret1_2 + v21 then
			v4 = GetComponents_ret1_2 + v21;
		end
		if v5 < GetComponents_ret2_2 + v22 then
			v5 = GetComponents_ret2_2 + v22;
		end
		if v6 >= GetComponents_ret3_2 + v23 then continue end
		v6 = GetComponents_ret3_2 + v23;
	end
	if v1 == math.huge then
		return Vector3.new(), Vector3.new();
	end
	return Vector3.new(v1, v2, v3), Vector3.new(v4, v5, v6);
end
function table1.model_to_region(p15) -- Line: 100
	--[[
		Upvalues:
			[1] = table1
	--]]
	return Region3.new(table1.model_to_min_max(p15));
end
function table1.part_to_min_max(p16) -- Line: 105
	--[[
		Upvalues:
			[1] = table1
	--]]
	return table1.to_min_max(p16.CFrame, p16.Size);
end
function table1.part_to_region(p17) -- Line: 109
	--[[
		Upvalues:
			[1] = table1
	--]]
	return Region3.new(table1.part_to_min_max(p17));
end
function table1.to_min_max(p18, p19) -- Line: 115
	local t_X2 = p19.X;
	local t_Y2 = p19.Y;
	local t_Z2 = p19.Z;
	local GetComponents_ret1_3, GetComponents_ret2_3, GetComponents_ret3_3, GetComponents_ret4_3, GetComponents_ret5_2, GetComponents_ret6_3, GetComponents_ret7_3, GetComponents_ret8_2, GetComponents_ret9_3, GetComponents_ret10_3, GetComponents_ret11_2, GetComponents_ret12_3 = p18:GetComponents();
	local v7 = (math.abs(GetComponents_ret4_3) * t_X2 + math.abs(GetComponents_ret5_2) * t_Y2 + math.abs(GetComponents_ret6_3) * t_Z2) * 0.5;
	local v8 = (math.abs(GetComponents_ret7_3) * t_X2 + math.abs(GetComponents_ret8_2) * t_Y2 + math.abs(GetComponents_ret9_3) * t_Z2) * 0.5;
	local v9 = (math.abs(GetComponents_ret10_3) * t_X2 + math.abs(GetComponents_ret11_2) * t_Y2 + math.abs(GetComponents_ret12_3) * t_Z2) * 0.5;
	local v10 = GetComponents_ret1_3 - v7;
	local v11 = GetComponents_ret2_3 - v8;
	local v12 = GetComponents_ret3_3 - v9;
	local v13 = GetComponents_ret1_3 + v7;
	local v14 = GetComponents_ret2_3 + v8;
	local v15 = GetComponents_ret3_3 + v9;
	return Vector3.new(v10, v11, v12), Vector3.new(v13, v14, v15);
end
function table1.to_region(p20, p21) -- Line: 137
	--[[
		Upvalues:
			[1] = table1
	--]]
	return Region3.new(table1.to_min_max(p20, p21));
end
function table1.intersect_aabb_obb(p22, p23, p24, p25) -- Line: 143
	--[[
		Upvalues:
			[1] = t_EPSILON
	--]]
	local t_Position = p24.Position;
	local t_XVector = p24.XVector;
	local t_YVector = p24.YVector;
	local t_ZVector = p24.ZVector;
	local v16 = 1 - t_EPSILON;
	local bool1 = false;
	local v17 = t_Position - p22;
	local vec3 = Vector3.new(t_XVector.X, t_YVector.X, t_ZVector.X);
	local vec3_2 = Vector3.new(math.abs(vec3.X), math.abs(vec3.Y), (math.abs(vec3.Z)));
	if v16 <= vec3_2.X or v16 <= vec3_2.Y or v16 <= vec3_2.Z then
		bool1 = true;
	end
	if math.abs(v17.X) > p23.X + (p25.X * vec3_2.X + p25.Y * vec3_2.Y + p25.Z * vec3_2.Z) then
		return false;
	end
	local vec3_3 = Vector3.new(t_XVector.Y, t_YVector.Y, t_ZVector.Y);
	local vec3_4 = Vector3.new(math.abs(vec3_3.X), math.abs(vec3_3.Y), (math.abs(vec3_3.Z)));
	if v16 <= vec3_4.X or v16 <= vec3_4.Y or v16 <= vec3_4.Z then
		bool1 = true;
	end
	if math.abs(v17.Y) > p23.Y + (p25.X * vec3_4.X + p25.Y * vec3_4.Y + p25.Z * vec3_4.Z) then
		return false;
	end
	local vec3_5 = Vector3.new(t_XVector.Z, t_YVector.Z, t_ZVector.Z);
	local vec3_6 = Vector3.new(math.abs(vec3_5.X), math.abs(vec3_5.Y), (math.abs(vec3_5.Z)));
	if v16 <= vec3_6.X or v16 <= vec3_6.Y or v16 <= vec3_6.Z then
		bool1 = true;
	end
	if math.abs(v17.Z) > p23.Z + (p25.X * vec3_6.X + p25.Y * vec3_6.Y + p25.Z * vec3_6.Z) then
		return false;
	end
	if math.abs((v17:Dot(t_XVector))) > p23.X * vec3_2.X + p23.Y * vec3_4.X + p23.Z * vec3_6.X + p25.X then
		return false;
	end
	if math.abs((v17:Dot(t_YVector))) > p23.X * vec3_2.Y + p23.Y * vec3_4.Y + p23.Z * vec3_6.Y + p25.Y then
		return false;
	end
	if math.abs((v17:Dot(t_ZVector))) > p23.X * vec3_2.Z + p23.Y * vec3_4.Z + p23.Z * vec3_6.Z + p25.Z then
		return false;
	end
	if bool1 then
		return true;
	end
	if math.abs(v17.Z * vec3_3.X - v17.Y * vec3_5.X) > p23.Y * vec3_6.X + p23.Z * vec3_4.X + (p25.Y * vec3_2.Z + p25.Z * vec3_2.Y) then
		return false;
	end
	if math.abs(v17.Z * vec3_3.Y - v17.Y * vec3_5.Y) > p23.Y * vec3_6.Y + p23.Z * vec3_4.Y + (p25.X * vec3_2.Z + p25.Z * vec3_2.X) then
		return false;
	end
	if math.abs(v17.Z * vec3_3.Z - v17.Y * vec3_5.Z) > p23.Y * vec3_6.Z + p23.Z * vec3_4.Z + (p25.X * vec3_2.Y + p25.Y * vec3_2.X) then
		return false;
	end
	if math.abs(v17.X * vec3_5.X - v17.Z * vec3.X) > p23.X * vec3_6.X + p23.Z * vec3_2.X + (p25.Y * vec3_4.Z + p25.Z * vec3_4.Y) then
		return false;
	end
	if math.abs(v17.X * vec3_5.Y - v17.Z * vec3.Y) > p23.X * vec3_6.Y + p23.Z * vec3_2.Y + (p25.X * vec3_4.Z + p25.Z * vec3_4.X) then
		return false;
	end
	if math.abs(v17.X * vec3_5.Z - v17.Z * vec3.Z) > p23.X * vec3_6.Z + p23.Z * vec3_2.Z + (p25.X * vec3_4.Y + p25.Y * vec3_4.X) then
		return false;
	end
	if math.abs(v17.Y * vec3.X - v17.X * vec3_3.X) > p23.X * vec3_4.X + p23.Y * vec3_2.X + (p25.Y * vec3_6.Z + p25.Z * vec3_6.Y) then
		return false;
	end
	if math.abs(v17.Y * vec3.Y - v17.X * vec3_3.Y) > p23.X * vec3_4.Y + p23.Y * vec3_2.Y + (p25.X * vec3_6.Z + p25.Z * vec3_6.X) then
		return false;
	end
	if math.abs(v17.Y * vec3.Z - v17.X * vec3_3.Z) > p23.X * vec3_4.Z + p23.Y * vec3_2.Z + (p25.X * vec3_6.Y + p25.Y * vec3_6.X) then
		return false;
	end
	return true;
end
function table1.contains_aabb_point(p26, p27) -- Line: 355
	if p27.X < -p26.X or p27.X > p26.X then
		return false;
	end
	if p27.Y < -p26.Y or p27.Y > p26.Y then
		return false;
	end
	if p27.Z < -p26.Z or p27.Z > p26.Z then
		return false;
	end
	return true;
end
function table1.contains_aabb_obb(p28, p29, p30) -- Line: 368
	--[[
		Upvalues:
			[1] = table1
	--]]
	if table1.contains_aabb_point(p28, p29 * Vector3.new(-p30.X, -p30.Y, -p30.Z)) and table1.contains_aabb_point(p28, p29 * Vector3.new(-p30.X, -p30.Y, p30.Z)) and table1.contains_aabb_point(p28, p29 * Vector3.new(p30.X, -p30.Y, -p30.Z)) and table1.contains_aabb_point(p28, p29 * Vector3.new(p30.X, -p30.Y, p30.Z)) and table1.contains_aabb_point(p28, p29 * Vector3.new(-p30.X, p30.Y, -p30.Z)) and table1.contains_aabb_point(p28, p29 * Vector3.new(-p30.X, p30.Y, p30.Z)) and table1.contains_aabb_point(p28, p29 * Vector3.new(p30.X, p30.Y, -p30.Z)) and table1.contains_aabb_point(p28, p29 * Vector3.new(p30.X, p30.Y, p30.Z)) then
		return true;
	end
	return false;
end
function table1.prep_cylinder_point_size(p31) -- Line: 390
	return Vector3.new(p31.X * p31.X, p31.Y, p31.Z * p31.Z);
end
function table1.contains_cyclinder_point(p32, p33) -- Line: 395
	if p33.Y < -p32.Y or p33.Y > p32.Y then
		return false;
	end
	if p33.X * p33.X / p32.X + p33.Z * p33.Z / p32.Z > 1 then
		return false;
	end
	return true;
end
function table1.contains_cylinder_block_prepped(p34, p35, p36) -- Line: 411
	--[[
		Upvalues:
			[1] = table1
	--]]
	if table1.contains_cyclinder_point(p34, p35 * Vector3.new(-p36.X, -p36.Y, -p36.Z)) and table1.contains_cyclinder_point(p34, p35 * Vector3.new(-p36.X, -p36.Y, p36.Z)) and table1.contains_cyclinder_point(p34, p35 * Vector3.new(p36.X, -p36.Y, -p36.Z)) and table1.contains_cyclinder_point(p34, p35 * Vector3.new(p36.X, -p36.Y, p36.Z)) and table1.contains_cyclinder_point(p34, p35 * Vector3.new(-p36.X, p36.Y, -p36.Z)) and table1.contains_cyclinder_point(p34, p35 * Vector3.new(-p36.X, p36.Y, p36.Z)) and table1.contains_cyclinder_point(p34, p35 * Vector3.new(p36.X, p36.Y, -p36.Z)) and table1.contains_cyclinder_point(p34, p35 * Vector3.new(p36.X, p36.Y, p36.Z)) then
		return true;
	end
	return false;
end
function table1.contains_cylinder_block(p37, p38, p39) -- Line: 432
	--[[
		Upvalues:
			[1] = table1
	--]]
	return table1.contains_cylinder_block_prepped(table1.prep_cylinder_point_size(p37), p38, p39);
end
function table1.dist_cyclinder_point(p40, p41) -- Line: 438
	if p41.Y < -p40.Y or p41.Y > p40.Y then
		return math.huge;
	end
	if p41.X * p41.X / p40.X + p41.Z * p41.Z / p40.Z > 1 then
		return math.huge;
	end
	return 1;
end
function table1.dist_cylinder_block_prepped(p42, p43, p44) -- Line: 454
	--[[
		Upvalues:
			[1] = table1
	--]]
	local v18 = table1.dist_cyclinder_point(p42, p43 * Vector3.new(-p44.X, -p44.Y, -p44.Z));
	local math_min_ret = math.min(v18, table1.dist_cyclinder_point(p42, p43 * Vector3.new(-p44.X, -p44.Y, p44.Z)));
	local math_min_ret2 = math.min(math_min_ret, table1.dist_cyclinder_point(p42, p43 * Vector3.new(p44.X, -p44.Y, -p44.Z)));
	local math_min_ret3 = math.min(math_min_ret2, table1.dist_cyclinder_point(p42, p43 * Vector3.new(p44.X, -p44.Y, p44.Z)));
	local math_min_ret4 = math.min(math_min_ret3, table1.dist_cyclinder_point(p42, p43 * Vector3.new(-p44.X, p44.Y, -p44.Z)));
	local math_min_ret5 = math.min(math_min_ret4, table1.dist_cyclinder_point(p42, p43 * Vector3.new(-p44.X, p44.Y, p44.Z)));
	local math_min_ret6 = math.min(math_min_ret5, table1.dist_cyclinder_point(p42, p43 * Vector3.new(p44.X, p44.Y, -p44.Z)));
	local math_min_ret7 = math.min(math_min_ret6, table1.dist_cyclinder_point(p42, p43 * Vector3.new(p44.X, p44.Y, p44.Z)));
	return math_min_ret7;
end
function table1.dist_cylinder_block(p45, p46, p47) -- Line: 473
	--[[
		Upvalues:
			[1] = table1
	--]]
	return table1.dist_cylinder_block_prepped(table1.prep_cylinder_point_size(p45), p46, p47);
end
function table1.to_array(p48) -- Line: 478
	local GetComponents_ret1_4, GetComponents_ret2_4, GetComponents_ret3_4, GetComponents_ret4_4, GetComponents_ret5_3, GetComponents_ret6_4, GetComponents_ret7_4, GetComponents_ret8_3, GetComponents_ret9_4, GetComponents_ret10_4, GetComponents_ret11_3, GetComponents_ret12_4 = p48:GetComponents();
	return {
		GetComponents_ret1_4,
		GetComponents_ret2_4,
		GetComponents_ret3_4,
		GetComponents_ret4_4,
		GetComponents_ret5_3,
		GetComponents_ret6_4,
		GetComponents_ret7_4,
		GetComponents_ret8_3,
		GetComponents_ret9_4,
		GetComponents_ret10_4,
		GetComponents_ret11_3,
		GetComponents_ret12_4
	};
end
function table1.from_array(p49) -- Line: 483
	return CFrame.new(p49[1], p49[2], p49[3], p49[4], p49[5], p49[6], p49[7], p49[8], p49[9], p49[10], p49[11], p49[12]);
end
function table1.try_to_array(p50) -- Line: 487
	--[[
		Upvalues:
			[1] = table1
	--]]
	if typeof(p50) == "CFrame" then
		return table1.to_array(p50);
	end
	return nil;
end
function table1.try_from_array(p51) -- Line: 494
	--[[
		Upvalues:
			[1] = table1
	--]]
	if typeof(p51) == "table" and #p51 == 12 then
		return table1.from_array(p51);
	end
	return nil;
end
function table1.intersect_obb_cylinder(p52, p53, p54, p55, p56) -- Line: 501
	--[[
		Upvalues:
			[1] = m_IntrCanonicalBox3Cylinder3
	--]]
	local v19 = p52:Inverse() * p54;
	return m_IntrCanonicalBox3Cylinder3.Intersects(p53 * 0.5, v19.Position, v19.UpVector, p55, p56);
end
return table1;

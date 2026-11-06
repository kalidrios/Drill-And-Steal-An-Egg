-- https://github.com/kalidrios

local m_instances = require(script.Parent.instances);
local m_math_helper = require(script.Parent.math_helper);
local m_vector_helper = require(script.Parent.vector_helper);
local m_objects = require(script.Parent.objects);
local m_string_helper = require(script.Parent.string_helper);
local table1 = {
	apply_primary = function(p57, p58) -- apply_primary (Line: 13)
		if p57.PrimaryPart then
			p58(p57.PrimaryPart);
			return;
		end
		local Connect_ret = nil;
		Connect_ret = p57.ChildAdded:Connect(function(child) -- Line: 18
			--[[
				Upvalues:
					[1] = Connect_ret
					[2] = p58
			--]]
			if child:IsA("BasePart") and child.Name == "HumanoidRootPart" then
				Connect_ret:Disconnect();
				p58(child);
			end
		end);
	end,
	apply_humanoid = function(p59, p60) -- apply_humanoid (Line: 27)
		local Humanoid = p59:FindFirstChildOfClass("Humanoid");
		if Humanoid then
			p60(Humanoid);
			return;
		end
		local Connect_ret2 = nil;
		Connect_ret2 = p59.ChildAdded:Connect(function(child2) -- Line: 33
			--[[
				Upvalues:
					[1] = Connect_ret2
					[2] = p60
			--]]
			if child2:IsA("Humanoid") then
				Connect_ret2:Disconnect();
				p60(child2);
			end
		end);
	end,
	get_humanoid = function(p61) -- get_humanoid (Line: 42)
		--[[
			Upvalues:
				[1] = m_instances
				[2] = m_objects
		--]]
		local v22 = m_instances.type_cast_any(p61, "Model");
		if v22 then
			local v53 = m_objects.type_cast(v22:FindFirstChildOfClass("Humanoid"));
			if v53 then
				return v53;
			end
		end
		return nil;
	end
};
function table1.is_humanoid(p1) -- Line: 53
	--[[
		Upvalues:
			[1] = table1
	--]]
	return table1.get_humanoid(p1) ~= nil;
end
function table1.type_cast_humanoid(p2) -- Line: 57
	--[[
		Upvalues:
			[1] = table1
			[2] = m_objects
	--]]
	if table1.is_humanoid(p2) then
		return m_objects.type_cast(p2);
	end
	return nil;
end
function table1.get_humanoid_root_part(p3) -- Line: 64
	--[[
		Upvalues:
			[1] = table1
	--]]
	local _humanoid = table1.get_humanoid(p3);
	if _humanoid then
		return _humanoid.RootPart;
	end
	return nil;
end
function table1.get_head(p4) -- Line: 72
	--[[
		Upvalues:
			[1] = table1
			[2] = m_instances
	--]]
	local v1 = table1.type_cast_humanoid(p4);
	if v1 then
		local _child_any = m_instances.get_child_any(v1, "Head", "BasePart");
		if _child_any then
			return _child_any;
		end
	end
	return nil;
end
function table1.compute_cframe_center_front_facing_custom(p5, p6, p7, p8) -- Line: 95
	--[[
		Upvalues:
			[1] = m_math_helper
	--]]
	local v2 = p6;
	local v3 = p6 + p6.LookVector * Vector3.new(0, 0, p5.Z / 2);
	local v4 = p6 - p6.Position;
	if p7 or p8 then
		if p7 then
			v2 = p7;
			v4 = v2 - v2.Position;
		end
		if p8 then
			v3 = p8;
			v4 = v3 - v3.Position;
		end
		if p7 ~= p8 then
			local v54 = v3.Position - v2.Position;
			if v54.Magnitude > m_math_helper.EPSILON then
				v4 = CFrame.lookAt(Vector3.new(0, 0, 0), v54);
			end
		end
	end
	return p6, v2, v3, v4;
end
local table2 = {
	Model = {"PrimaryPart"},
	JointInstance = {
		"Part0",
		"Part1"
	},
	PartAdornment = {"Adornee"},
	Constraint = {
		"Attachment0",
		"Attachment1"
	},
	NoCollisionConstraint = {
		"Part0",
		"Part1"
	},
	WeldConstraint = {
		"Part0",
		"Part1"
	}
};
function table1.replace_reference(p9, p10, p11) -- Line: 143
	--[[
		Upvalues:
			[1] = m_objects
			[2] = table2
	--]]
	local v5 = m_objects.type_cast(p9);
	for key1, val1 in pairs(table2) do
		if key1 ~= "" and not p9:IsA(key1) then continue end
		for _, val14 in ipairs(val1) do
			if v5[val14] ~= p10 then continue end
			v5[val14] = p11;
		end
	end
end
function table1.compute_path(p12, p13) -- Line: 156
	if p12 == p13 then
		return {};
	end
	local table3 = {};
	table.insert(table3, p13.Name);
	local v6 = p13;
	local table4;
	while true do
		local t_Parent = v6.Parent;
		if t_Parent then
			if t_Parent ~= p12 then
				table.insert(table3, t_Parent.Name);
				v6 = t_Parent;
				continue;
			end
			table4 = {};
			for index1 = #table3, 1, -1 do
				table.insert(table4, table3[index1]);
			end
			break;
		end
		warn("nil parent");
		return nil;
	end
	return table4;
end
function table1.get_from_path(p14, p15) -- Line: 187
	local v7 = p14;
	for _, val2 in ipairs(p15) do
		local FindFirstChild_ret = v7:FindFirstChild(val2);
		if FindFirstChild_ret then
			v7 = FindFirstChild_ret;
			continue;
		end
		warn("not found in path");
		return nil;
	end
	return v7;
end
function table1.scale(p16, p17, p18, p19) -- Line: 201
	local ToObjectSpace_ret = p16:ToObjectSpace(p18);
	p18 = p16:ToWorldSpace(ToObjectSpace_ret + (ToObjectSpace_ret.Position * p17 - ToObjectSpace_ret.Position));
	p19 = p19 * p17;
	return p18, p19;
end
function table1.scale_npc_inplace(p20, p21, p22) -- Line: 210
	--[[
		Upvalues:
			[1] = m_instances
			[2] = table1
			[3] = m_objects
	--]]
	local GetBoundingBox_ret1, GetBoundingBox_ret2 = p20:GetBoundingBox();
	local v8 = GetBoundingBox_ret1;
	local t_PrimaryPart = p20.PrimaryPart;
	if t_PrimaryPart then
		v8 = t_PrimaryPart.CFrame;
	end
	for _, descendant3 in ipairs(p20:GetDescendants()) do
		local v23 = m_instances.type_cast_any(descendant3, "Attachment");
		if not v23 then continue end
		local _value3 = m_instances.get_value(v23, "OriginalPosition", "Vector3Value");
		if _value3 then continue end
		m_instances.set_value(v23, "OriginalPosition", "Vector3Value", v23.Position);
	end
	for _, descendant4 in ipairs(p20:GetDescendants()) do
		local v24 = m_instances.type_cast_any(descendant4, "JointInstance");
		if v24 then
			v24.C0 = v24.C0 + (v24.C0.Position * p21 - v24.C0.Position);
			v24.C1 = v24.C1 + (v24.C1.Position * p21 - v24.C1.Position);
			continue;
		end
		local v25 = m_instances.type_cast_any(descendant4, "KeyframeSequence");
		if v25 then continue end
		local v26 = m_instances.type_cast_any(descendant4, "Pose");
		if v26 then
			v26.CFrame = v26.CFrame + (v26.CFrame.Position * p21 - v26.CFrame.Position);
			continue;
		end
		local v27 = m_instances.type_cast_any(descendant4, "SpecialMesh");
		if v27 then
			local t_Scale = v27.Scale;
			v27.Scale = t_Scale * p21;
			local _value2 = m_instances.get_value(v27, "OriginalScale", "Vector3Value");
			if _value2 then continue end
			m_instances.set_value(v27, "OriginalScale", "Vector3Value", t_Scale);
			continue;
		end
		local v28 = m_instances.type_cast_any(descendant4, "BasePart");
		if not v28 then continue end
		local t_CFrame = v28.CFrame;
		local t_Size = v28.Size;
		local v29, v30 = table1.scale(v8, p21, t_CFrame, t_Size);
		v28.Size = v30;
		v28.CFrame = v29;
		local _value = m_instances.get_value(v28, "OriginalSize", "Vector3Value");
		if _value then continue end
		m_instances.set_value(v28, "OriginalSize", "Vector3Value", t_Size);
	end
	local v9 = m_objects.type_cast(p20:FindFirstChildOfClass("Humanoid"));
	if v9 then
		v9.HipHeight = v9.HipHeight * p21.Y;
	end
	if p22 then
		local v31 = GetBoundingBox_ret1 * CFrame.new(0, -GetBoundingBox_ret2.Y / 2, 0);
		local v32, _ = table1.scale(GetBoundingBox_ret1, p21, v31, (Vector3.new(0, 0, 0)));
		p20:TranslateBy(v31.Position - v32.Position);
	end
	return p20;
end
function table1.scale_npc(p23, p24, p25) -- Line: 317
	--[[
		Upvalues:
			[1] = m_instances
			[2] = table1
	--]]
	local v10 = m_instances.clone(p23);
	return table1.scale_npc_inplace(v10, p24, p25);
end
function table1.scale_npc_old(p26, p27) -- Line: 329
	--[[
		Upvalues:
			[1] = m_instances
			[2] = table1
			[3] = m_objects
	--]]
	local GetBoundingBox_ret1_2, GetBoundingBox_ret2_2 = p26:GetBoundingBox();
	local v11 = GetBoundingBox_ret1_2;
	local v12 = m_instances.clone(p26);
	local _child_any2 = m_instances.get_child_any(v12, "HumanoidRootPart", "BasePart");
	if _child_any2 then
		v11 = _child_any2.CFrame;
		_child_any2.CanCollide = true;
		_child_any2.Massless = false;
		_child_any2.Anchored = true;
		_child_any2.Material = Enum.Material.SmoothPlastic;
		_child_any2.Transparency = 0.25;
		_child_any2.Color = Color3.new(1, 1, 1);
	end
	local v13 = m_instances.clone(v12);
	v13.PrimaryPart = nil;
	local _child_any3 = m_instances.get_child_any(v13, "HumanoidRootPart", "BasePart");
	if _child_any3 then
		_child_any3:Destroy();
	end
	local table5 = {};
	for _, descendant5 in ipairs(v12:GetDescendants()) do
		table.insert(table5, descendant5);
	end
	for _, val6 in ipairs(table5) do
		local v33 = m_instances.type_cast_any(val6, "SpecialMesh");
		if v33 then
			v33:Destroy();
			continue;
		end
		local v34 = m_instances.type_cast_any(val6, "BasePart");
		if not v34 or v34 == _child_any2 then continue end
		v34.Transparency = 1;
		v34.CanCollide = false;
		v34.Massless = true;
		v34.Anchored = false;
		v34.Material = Enum.Material.SmoothPlastic;
		v34.Transparency = 0.5;
		v34.Color = Color3.new(1, 0, 1);
	end
	local table6 = {};
	for _, descendant7 in ipairs(v13:GetDescendants()) do
		table.insert(table6, descendant7);
	end
	for _, val8 in ipairs(table6) do
		local v35 = m_instances.type_cast_any(val8, "SpecialMesh");
		if v35 then
			v35.Scale = v35.Scale * p27;
			continue;
		end
		local v36 = m_instances.type_cast_any(val8, "BasePart");
		if v36 then
			local v55 = table1.compute_path(v13, v36);
			if v55 then
				local v61 = m_instances.type_cast_any(table1.get_from_path(v12, v55), "BasePart");
				if v61 then
					v36.CanCollide = false;
					v36.Massless = true;
					v36.Anchored = false;
					local t_CFrame2 = v36.CFrame;
					local t_Size2 = v36.Size;
					local v62, v63 = table1.scale(v11, p27, t_CFrame2, t_Size2);
					v36.Size = v63;
					v36.CFrame = v62;
					local ToObjectSpace_ret2 = t_CFrame2:ToObjectSpace(v62);
					local cf = CFrame.new();
					local Weld = Instance.new("ManualWeld");
					Weld.Name = "Weld";
					Weld.Part0 = v61;
					Weld.Part1 = v36;
					Weld.C0 = ToObjectSpace_ret2;
					Weld.C1 = cf;
					Weld.Parent = v36;
					v36.Transparency = 0.5;
					continue;
				end
				print("base_part_a = nil");
			else
				print("path = nil");
			end
		end
		val8:Destroy();
	end
	if _child_any2 then
		local v37, v38 = table1.scale(v11, p27, _child_any2.CFrame, _child_any2.Size);
		_child_any2.Size = v38;
		_child_any2.CFrame = v37;
	end
	local v14 = m_objects.type_cast(v12:FindFirstChildOfClass("Humanoid"));
	if v14 then
		v14.HipHeight = v14.HipHeight * p27.Y;
	end
	v13.Name = "Skin";
	v13.Parent = v12;
	local v15 = GetBoundingBox_ret1_2 * CFrame.new(0, -GetBoundingBox_ret2_2.Y / 2, 0);
	local v16, _ = table1.scale(GetBoundingBox_ret1_2, p27, v15, (Vector3.new(0, 0, 0)));
	v12:TranslateBy(v15.Position - v16.Position);
	return v12;
end
function table1.convert_npc(p28) -- Line: 463
	--[[
		Upvalues:
			[1] = m_instances
			[2] = table1
	--]]
	local v17 = m_instances.clone(p28);
	local table7 = {};
	for _, descendant9 in ipairs(v17:GetDescendants()) do
		table.insert(table7, descendant9);
	end
	for _, val10 in ipairs(table7) do
		local v39 = m_instances.type_cast(val10, "MeshPart");
		if not v39 then continue end
		local Part = Instance.new("Part");
		Part.BrickColor = v39.BrickColor;
		Part.CastShadow = v39.CastShadow;
		Part.Color = v39.Color;
		Part.Material = v39.Material;
		Part.Reflectance = v39.Reflectance;
		Part.Transparency = v39.Transparency;
		Part.Name = v39.Name;
		Part.CFrame = v39.CFrame;
		Part.Anchored = v39.Anchored;
		Part.CanCollide = v39.CanCollide;
		Part.CollisionGroupId = v39.CollisionGroupId;
		Part.Locked = v39.Locked;
		Part.Massless = v39.Massless;
		Part.CustomPhysicalProperties = v39.CustomPhysicalProperties;
		Part.RootPriority = v39.RootPriority;
		Part.Shape = Enum.PartType.Block;
		Part.Size = v39.Size;
		Part.AssemblyAngularVelocity = v39.AssemblyAngularVelocity;
		Part.AssemblyLinearVelocity = v39.AssemblyLinearVelocity;
		local _child_any5 = m_instances.get_child_any(v39, "OriginalSize", "Vector3Value");
		local _child_any6 = m_instances.get_child_any(v39, "OriginalPosition", "Vector3Value");
		local v40 = v39.Size / v39.MeshSize;
		local Mesh = Instance.new("SpecialMesh");
		Mesh.Name = "Mesh";
		Mesh.MeshType = Enum.MeshType.FileMesh;
		Mesh.MeshId = v39.MeshId;
		Mesh.Offset = Vector3.new(0, 0, 0);
		Mesh.Scale = v40;
		Mesh.TextureId = v39.TextureID;
		Mesh.VertexColor = Vector3.new(1, 1, 1);
		if _child_any5 then
			_child_any5.Parent = Mesh;
		end
		if _child_any6 then
			_child_any6.Parent = Mesh;
		end
		Mesh.Parent = Part;
		local table8 = {};
		for _, child15 in ipairs(v39:GetChildren()) do
			table.insert(table8, child15);
		end
		for _, val16 in ipairs(table8) do
			val16.Parent = Part;
		end
		Part.Parent = v39.Parent;
		table1.replace_reference(v17, v39, Part);
		for _, descendant17 in ipairs(v17:GetDescendants()) do
			table1.replace_reference(descendant17, v39, Part);
		end
		v39:Destroy();
	end
	local _child_any4 = m_instances.get_child_any(v17, "AnimationController", "AnimationController");
	if _child_any4 then
		_child_any4:Destroy();
	end
	return v17;
end
function table1.compute_hip_height(p29, p30) -- Line: 566
	--[[
		Upvalues:
			[1] = m_objects
	--]]
	local GetBoundingBox_ret1_3, GetBoundingBox_ret2_3 = p29:GetBoundingBox();
	local v18 = GetBoundingBox_ret1_3;
	local t_PrimaryPart2 = p29.PrimaryPart;
	if t_PrimaryPart2 then
		v18 = t_PrimaryPart2.CFrame * CFrame.new(0, -t_PrimaryPart2.Size.Y / 2, 0);
	end
	local t_Magnitude = (v18.Position - (GetBoundingBox_ret1_3 * CFrame.new(0, -GetBoundingBox_ret2_3.Y / 2, 0)).Position).Magnitude;
	if p30 then
		local v41 = m_objects.type_cast(p29:FindFirstChildOfClass("Humanoid"));
		if v41 then
			v41.HipHeight = t_Magnitude;
		end
	end
	return t_Magnitude;
end
function table1.retexture_model(p31, p32) -- Line: 591
	--[[
		Upvalues:
			[1] = m_instances
			[2] = m_string_helper
	--]]
	for _, descendant11 in ipairs(p31:GetDescendants()) do
		local v42 = m_instances.type_cast_any(descendant11, "FileMesh");
		if v42 then
			local t_TextureId = v42.TextureId;
			local v56 = m_string_helper.replace(t_TextureId, "rbxassetid://", "");
			local v57 = p32[m_string_helper.replace(v56, "http://www.roblox.com/asset/?id=", "")];
			if not v57 then continue end
			v42.TextureId = "rbxassetid://" .. v57;
			continue;
		end
		local v43 = m_instances.type_cast_any(descendant11, "MeshPart");
		if not v43 then continue end
		local t_TextureID = v43.TextureID;
		local v44 = m_string_helper.replace(t_TextureID, "rbxassetid://", "");
		local v45 = p32[m_string_helper.replace(v44, "http://www.roblox.com/asset/?id=", "")];
		if not v45 then continue end
		v43.TextureID = "rbxassetid://" .. v45;
	end
	return p31;
end
function table1.compute_color_dist(p33, p34) -- Line: 623
	return (p34 - p33).Magnitude;
end
function table1.recolor(p35, p36) -- Line: 643
	--[[
		Upvalues:
			[1] = m_vector_helper
			[2] = table1
			[3] = m_objects
			[4] = m_math_helper
	--]]
	local vec3 = Vector3.new(p35:ToHSV());
	local v19 = m_vector_helper.from_color(p35);
	local table9 = {};
	local v20 = 0;
	for _, val12 in ipairs(p36) do
		local math_clamp_ret = math.clamp(1 - table1.compute_color_dist(vec3, (Vector3.new(val12.a:ToHSV()))), 0, 1);
		if m_objects.optional(val12.threshold, 0) > math_clamp_ret then continue end
		local v46 = math_clamp_ret;
		local t_response = val12.response;
		if t_response then
			v46 = m_math_helper.eval_sequence(t_response, v46);
		end
		if v46 <= 0 then continue end
		local v47 = m_objects.optional(val12.weight, 1) * v46;
		if v47 <= 0 then continue end
		v20 = v20 + v47;
		table.insert(table9, {
			ratio = v46,
			weight = v47,
			color = m_vector_helper.from_color(val12.b)
		});
	end
	if v20 > 0 then
		local v48 = Vector3.new();
		for _, val18 in ipairs(table9) do
			v48 = v48 + (v19 * (1 - val18.ratio) + val18.color * val18.ratio) * val18.weight;
		end
		v19 = v48 / v20;
	end
	return m_vector_helper.to_color(v19);
end
function table1.recolor_model(p37, p38) -- Line: 689
	--[[
		Upvalues:
			[1] = m_instances
			[2] = table1
	--]]
	local table10 = {};
	for _, descendant13 in ipairs(p37:GetDescendants()) do
		local v49 = m_instances.type_cast_any(descendant13, "BasePart");
		if not v49 then continue end
		local t_Color = v49.Color;
		local v50 = table10[tostring(t_Color)];
		if v50 then
			v49.Color = v50;
			continue;
		end
		local v51 = table1.recolor(t_Color, p38);
		local _ = t_Color == v51;
		table10[tostring(t_Color)] = v51;
		v49.Color = v51;
	end
end
function table1.compute_cframe_center_front_facing(p39) -- Line: 713
	--[[
		Upvalues:
			[1] = m_instances
			[2] = table1
	--]]
	local t_Size3 = p39.Size;
	local t_CFrame3 = p39.CFrame;
	local t_WorldCFrame = nil;
	local t_WorldCFrame2 = nil;
	local _child_any7 = m_instances.get_child_any(p39, "FaceCenterAttachment", "Attachment");
	if _child_any7 then
		t_WorldCFrame = _child_any7.WorldCFrame;
	end
	local _child_any8 = m_instances.get_child_any(p39, "FaceFrontAttachment", "Attachment");
	if _child_any8 then
		t_WorldCFrame2 = _child_any8.WorldCFrame;
	end
	return table1.compute_cframe_center_front_facing_custom(t_Size3, t_CFrame3, t_WorldCFrame, t_WorldCFrame2);
end
function table1.get_head_cframe_unsafe(p40, _, p41) -- Line: 730
	--[[
		Upvalues:
			[1] = m_instances
	--]]
	local _child_any9 = m_instances.get_child_any(p40, "Head", "BasePart");
	if _child_any9 then
		local t_CFrame5 = _child_any9.CFrame;
		local t_Size5 = _child_any9.Size;
		return t_CFrame5 + t_CFrame5:VectorToWorldSpace((Vector3.new(t_Size5.X / 2, 0, t_Size5.Z / 2)));
	end
	local t_CFrame4 = p41.CFrame;
	local t_Size4 = p41.Size;
	return t_CFrame4 + t_CFrame4:VectorToWorldSpace((Vector3.new(t_Size4.X / 2, t_Size4.Y / 2, t_Size4.Z / 2)));
end
function table1.get_head_cframe_unsafe_custom(p42, _, p43, p44, p45) -- Line: 747
	--[[
		Upvalues:
			[1] = m_instances
	--]]
	local _child_any10 = m_instances.get_child_any(p42, "Head", "BasePart");
	if _child_any10 then
		local t_CFrame7 = _child_any10.CFrame;
		local t_Size7 = _child_any10.Size;
		return t_CFrame7 + t_CFrame7:VectorToWorldSpace((Vector3.new(t_Size7.X / 2, 0, t_Size7.Z / 2)));
	end
	local t_CFrame6 = p43.CFrame;
	local t_Size6 = p43.Size;
	if p44 and p45 then
		local v52 = p45 * t_CFrame6;
		local _ = v52 + v52:VectorToWorldSpace((Vector3.new(p44.X / 2, 0, p44.Z / 2)));
		return t_CFrame6;
	end
	return t_CFrame6 + t_CFrame6:VectorToWorldSpace((Vector3.new(t_Size6.X / 2, t_Size6.Y / 2, t_Size6.Z / 2)));
end
function table1.get_feet_pos_unsafe(_, p46, p47) -- Line: 775
	local t_CFrame8 = p47.CFrame;
	return t_CFrame8.Position - t_CFrame8:VectorToWorldSpace((Vector3.new(0, p47.Size.Y / 2, 0))) - t_CFrame8:VectorToWorldSpace((Vector3.new(0, p46.HipHeight, 0)));
end
function table1.get_feet_cframe_unsafe(p48, p49, p50) -- Line: 783
	--[[
		Upvalues:
			[1] = m_instances
			[2] = table1
	--]]
	local _child_any11 = m_instances.get_child_any(p48, "Head", "BasePart");
	local v21 = _child_any11 and _child_any11.CFrame or p50.CFrame;
	return v21 + (table1.get_feet_pos_unsafe(p48, p49, p50) - v21.Position);
end
function table1.get_head_cframe(p51) -- Line: 796
	--[[
		Upvalues:
			[1] = table1
			[2] = m_objects
	--]]
	local _humanoid2 = table1.get_humanoid(p51);
	if _humanoid2 then
		local t_RootPart = _humanoid2.RootPart;
		if t_RootPart then
			local v58 = m_objects.type_cast(p51);
			return table1.get_head_cframe_unsafe(v58, _humanoid2, t_RootPart);
		end
	end
	return nil;
end
function table1.get_head_pos(p52) -- Line: 808
	--[[
		Upvalues:
			[1] = table1
	--]]
	local _head_cframe = table1.get_head_cframe(p52);
	if _head_cframe then
		return _head_cframe.Position;
	end
	return nil;
end
function table1.get_feet_cframe(p53) -- Line: 817
	--[[
		Upvalues:
			[1] = table1
			[2] = m_objects
	--]]
	local _humanoid3 = table1.get_humanoid(p53);
	if _humanoid3 then
		local t_RootPart2 = _humanoid3.RootPart;
		if t_RootPart2 then
			local v59 = m_objects.type_cast(p53);
			local _feet_cframe_unsafe = table1.get_feet_cframe_unsafe(v59, _humanoid3, t_RootPart2);
			return _feet_cframe_unsafe;
		end
	end
	return nil;
end
function table1.get_feet_pos(p54) -- Line: 830
	--[[
		Upvalues:
			[1] = table1
			[2] = m_objects
	--]]
	local _humanoid4 = table1.get_humanoid(p54);
	if _humanoid4 then
		local t_RootPart3 = _humanoid4.RootPart;
		if t_RootPart3 then
			local v60 = m_objects.type_cast(p54);
			local _feet_pos_unsafe = table1.get_feet_pos_unsafe(v60, _humanoid4, t_RootPart3);
			return _feet_pos_unsafe;
		end
	end
	return nil;
end
function table1.get_root_cframe(p55) -- Line: 844
	--[[
		Upvalues:
			[1] = table1
	--]]
	local _humanoid_root_part = table1.get_humanoid_root_part(p55);
	if _humanoid_root_part then
		return _humanoid_root_part.CFrame;
	end
	return nil;
end
function table1.get_root_pos(p56) -- Line: 852
	--[[
		Upvalues:
			[1] = table1
	--]]
	local _root_cframe = table1.get_root_cframe(p56);
	if _root_cframe then
		return _root_cframe.Position;
	end
	return nil;
end
return table1;

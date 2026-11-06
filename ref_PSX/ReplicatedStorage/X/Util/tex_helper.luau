-- https://github.com/kalidrios

local m_instances = require(script.Parent.instances);
local table1 = {};
local table2 = {
	[Enum.NormalId.Top] = function(p9) -- Line: 8
		return Vector2.new(p9.X, p9.Z);
	end,
	[Enum.NormalId.Bottom] = function(p10) -- Line: 11
		return Vector2.new(p10.X, p10.Z);
	end,
	[Enum.NormalId.Back] = function(p11) -- Line: 14
		return Vector2.new(p11.X, p11.Y);
	end,
	[Enum.NormalId.Front] = function(p12) -- Line: 17
		return Vector2.new(p12.X, p12.Y);
	end,
	[Enum.NormalId.Right] = function(p13) -- Line: 20
		return Vector2.new(p13.Z, p13.Y);
	end,
	[Enum.NormalId.Left] = function(p14) -- Line: 23
		return Vector2.new(p14.Z, p14.Y);
	end
};
local table3 = {
	[Enum.NormalId.Top] = "TexTop",
	[Enum.NormalId.Bottom] = "TexBottom",
	[Enum.NormalId.Back] = "TexBack",
	[Enum.NormalId.Front] = "TexFront",
	[Enum.NormalId.Right] = "TexRight",
	[Enum.NormalId.Left] = "TexLeft"
};
function table1.compute_face_size(p1, p2) -- Line: 38
	--[[
		Upvalues:
			[1] = table2
	--]]
	return table2[p1](p2);
end
function table1.fix_blender_rect(p3) -- Line: 43
	return Rect.new(p3.Min.X, 1 - p3.Min.Y, p3.Max.X, 1 - p3.Max.Y);
end
function table1.update_texture(p4, p5, p6) -- Line: 47
	--[[
		Upvalues:
			[1] = table1
	--]]
	p6 = table1.fix_blender_rect(p6);
	local v1 = p5.X / p6.Width;
	local v2 = p5.Y / p6.Height;
	local v3 = p6.Min.X * v1;
	local v4 = p6.Min.Y * v2;
	p4.StudsPerTileU = v1;
	p4.StudsPerTileV = v2;
	p4.OffsetStudsU = v3;
	p4.OffsetStudsV = v4;
end
function table1.update_part_textures(p7) -- Line: 61
	--[[
		Upvalues:
			[1] = table3
			[2] = m_instances
			[3] = table1
	--]]
	for key1, val1 in pairs(table3) do
		local _attr = m_instances.get_attr(p7, val1, "Rect");
		if not _attr then continue end
		local v6 = m_instances.get_child_any(p7, val1, "Texture");
		local v7 = v6 ~= nil;
		if not v7 then
			v6 = Instance.new("Texture");
			v6.Name = val1;
			v6.Color3 = Color3.new(1, 1, 1);
			local v9 = m_instances.type_cast_any(p7, "MeshPart");
			if v9 then
				v6.Texture = v9.TextureID;
			end
			v6.Transparency = 0;
			v6.ZIndex = 1;
		end
		v6.Face = key1;
		table1.update_texture(v6, table1.compute_face_size(key1, p7.Size), _attr);
		if v7 then continue end
		v6.Parent = p7;
	end
end
function table1.update_all_textures(p8) -- Line: 96
	--[[
		Upvalues:
			[1] = m_instances
			[2] = table1
	--]]
	local v5 = m_instances.type_cast_any(p8, "BasePart");
	if v5 then
		table1.update_part_textures(v5);
	end
	for _, descendant2 in ipairs(p8:GetDescendants()) do
		local v8 = m_instances.type_cast_any(descendant2, "BasePart");
		if not v8 then continue end
		table1.update_part_textures(v8);
	end
end
return table1;

-- https://github.com/kalidrios

local m_objects = require(script.Parent.objects);
local m_instances = require(script.Parent.instances);
local m_vector_helper = require(script.Parent.vector_helper);
local table1 = {prototype = {}};
table1.__index = table1.prototype;
function table1._type() -- Line: 60
	--[[
		Upvalues:
			[1] = table1
	--]]
	local table2 = {
		_parent = nil,
		_shaders = nil,
		_current_parts = nil,
		_current_meshes = nil,
		_prev_parts = nil,
		_prev_meshes = nil
	};
	setmetatable(table2, table1);
	return table2;
end
function table1.new(p1) -- Line: 79
	--[[
		Upvalues:
			[1] = table1
	--]]
	local table3 = {};
	local table4 = {};
	local table5 = {};
	local table6 = {};
	local _ = {};
	local table7 = {
		_parent = p1,
		_shaders = table3,
		_current_parts = table4,
		_current_meshes = table5,
		_prev_parts = table6,
		_prev_meshes = table5
	};
	setmetatable(table7, table1);
	return table7;
end
local function destroy(p2) -- Line: 97
	p2._shaders = {};
	p2._current_parts = {};
	p2._current_meshes = {};
	p2._prev_parts = {};
	p2._prev_meshes = {};
end
table1.prototype.destroy = destroy;
function table1.new_number(p3, p4) -- Line: 105
	local table8 = {
		base = p3,
		value = p4,
		sum = 0,
		weight = 0,
		priority = 0,
		changed = false
	};
	return table8;
end
function table1.new_vector3(p5, p6) -- Line: 116
	local table9 = {
		base = p5,
		value = p6,
		sum = Vector3.new(),
		weight = 0,
		priority = 0,
		changed = false
	};
	return table9;
end
function table1.base(p7, p8, p9, p10) -- Line: 127
	--[[
		Upvalues:
			[1] = m_instances
	--]]
	local v8 = "_Original" .. p8;
	local _value = m_instances.get_value(p7, v8, p9);
	if _value ~= nil then
		return _value;
	end
	m_instances.set_value(p7, v8, p9, p10);
	return p10;
end
local function update_part(p11, p12) -- Line: 137
	--[[
		Upvalues:
			[1] = m_vector_helper
			[2] = table1
	--]]
	local v9 = p11._current_parts[p12];
	if v9 then
		return v9;
	end
	local v10 = m_vector_helper.from_color(p12.Color);
	local t_Reflectance = p12.Reflectance;
	local t_Transparency = p12.Transparency;
	local v11 = p11._prev_parts[p12];
	if v11 then
		p11._prev_parts[p12] = nil;
		p11._current_parts[p12] = v11;
		v11.color.value = v10;
		v11.reflectance.value = t_Reflectance;
		v11.transparency.value = t_Transparency;
		v11.meshes = {};
		return v11;
	end
	local v12 = table1.base(p12, "Color", "Vector3Value", v10);
	local v13 = table1.base(p12, "Reflectance", "NumberValue", t_Reflectance);
	local v14 = table1.base(p12, "Transparency", "NumberValue", t_Transparency);
	local table10 = {
		roblox = p12,
		color = table1.new_vector3(v12, v10),
		reflectance = table1.new_number(v13, t_Reflectance),
		transparency = table1.new_number(v14, t_Transparency),
		meshes = {}
	};
	p11._current_parts[p12] = table10;
	return table10;
end
table1.prototype.update_part = update_part;
local function update_mesh(p13, p14) -- Line: 175
	--[[
		Upvalues:
			[1] = table1
	--]]
	local v15 = p13._current_meshes[p14];
	if v15 then
		return v15;
	end
	local t_VertexColor = p14.VertexColor;
	local v16 = p13._prev_meshes[p14];
	if v16 then
		p13._prev_meshes[p14] = nil;
		p13._current_meshes[p14] = v16;
		v16.vertex_color.value = t_VertexColor;
		return v16;
	end
	local v17 = table1.base(p14, "VertexColor", "Vector3Value", t_VertexColor);
	local table11 = {
		roblox = p14,
		vertex_color = table1.new_vector3(v17, t_VertexColor)
	};
	p13._current_meshes[p14] = table11;
	return table11;
end
table1.prototype.update_mesh = update_mesh;
local function update_instance(p15, p16, p17) -- Line: 203
	--[[
		Upvalues:
			[1] = m_objects
	--]]
	if p16:IsA("BasePart") then
		local v24 = m_objects.type_cast(p16);
		p15:update_part(v24);
		return;
	end
	if p17 and p16.ClassName == "SpecialMesh" then
		local v25 = m_objects.type_cast(p16);
		local t_Parent = v25.Parent;
		if t_Parent and t_Parent:IsA("BasePart") then
			local v33 = m_objects.type_cast(t_Parent);
			p15:update_part(v33).meshes[v25] = p15:update_mesh(v25);
		end
	end
end
table1.prototype.update_instance = update_instance;
local function update_parts(p18) -- Line: 220
	p18._prev_parts = p18._current_parts or {};
	p18._prev_meshes = p18._current_meshes or {};
	p18._current_parts = {};
	p18._current_meshes = {};
	local t__parent = p18._parent;
	p18:update_instance(t__parent, false);
	for _, descendant1 in ipairs(t__parent:GetDescendants()) do
		p18:update_instance(descendant1, true);
	end
	p18._prev_parts = {};
	p18._prev_meshes = {};
	return p18._current_parts;
end
table1.prototype.update_parts = update_parts;
function table1.sum_number(p19, p20, p21, p22) -- Line: 238
	local t_desired = p19.desired;
	if t_desired then
		p19.desired = nil;
		if p20 > 0 then
			if p19.weight <= 0 or p19.priority < p21 then
				p19.sum = 0;
				p19.weight = 0;
				p19.priority = p21;
			end
			p19.sum = p19.sum + (t_desired * p22 + p19.base * (1 - p22)) * p20;
			p19.weight = p19.weight + p20;
		end
	end
end
function table1.sum_vector3(p23, p24, p25, p26) -- Line: 255
	local t_desired2 = p23.desired;
	if t_desired2 then
		p23.desired = nil;
		if p24 > 0 then
			if p23.weight <= 0 or p23.priority < p25 then
				p23.sum = Vector3.new();
				p23.weight = 0;
				p23.priority = p25;
			end
			p23.sum = p23.sum + (t_desired2 * p26 + p23.base * (1 - p26)) * p24;
			p23.weight = p23.weight + p24;
		end
	end
end
function table1.sum_mesh(p27, p28, p29, p30) -- Line: 272
	--[[
		Upvalues:
			[1] = table1
	--]]
	table1.sum_vector3(p27.vertex_color, p28, p29, p30);
end
function table1.sum_part(p31, p32, p33, p34) -- Line: 276
	--[[
		Upvalues:
			[1] = table1
	--]]
	table1.sum_vector3(p31.color, p32, p33, p34);
	table1.sum_number(p31.reflectance, p32, p33, p34);
	table1.sum_number(p31.transparency, p32, p33, p34);
	for _, val2 in pairs(p31.meshes) do
		table1.sum_mesh(val2, p32, p33, p34);
	end
end
function table1.render_number(p35) -- Line: 286
	if p35.weight > 0 then
		local v26 = p35.sum / p35.weight;
		p35.weight = 0;
		p35.changed = p35.base ~= v26;
		return v26;
	end
	if p35.changed then
		p35.changed = false;
		if p35.base ~= p35.value then
			return p35.base;
		end
	end
	return nil;
end
function table1.render_vector3(p36) -- Line: 302
	if p36.weight > 0 then
		local v27 = p36.sum / p36.weight;
		p36.weight = 0;
		p36.changed = p36.base ~= v27;
		return v27;
	end
	if p36.changed then
		p36.changed = false;
		if p36.base ~= p36.value then
			return p36.base;
		end
	end
	return nil;
end
function table1.render_mesh(p37) -- Line: 318
	--[[
		Upvalues:
			[1] = table1
	--]]
	local v18 = table1.render_vector3(p37.vertex_color);
	if v18 then
		p37.roblox.VertexColor = v18;
	end
end
function table1.render_part(p38) -- Line: 325
	--[[
		Upvalues:
			[1] = table1
			[2] = m_vector_helper
	--]]
	local v19 = table1.render_vector3(p38.color);
	if v19 then
		p38.roblox.Color = m_vector_helper.to_color(v19);
	end
	local v20 = table1.render_number(p38.reflectance);
	if v20 then
		p38.roblox.Reflectance = v20;
	end
	local v21 = table1.render_number(p38.transparency);
	if v21 then
		p38.roblox.Transparency = v21;
	end
	for _, val3 in pairs(p38.meshes) do
		table1.render_mesh(val3);
	end
end
local function render_stepped(p39, p40) -- Line: 344
	--[[
		Upvalues:
			[1] = table1
	--]]
	local t__shaders = p39._shaders;
	if #t__shaders <= 0 then return end
	local update_parts_ret = p39:update_parts();
	local bool1 = false;
	local pairs_ret1_3, pairs_ret2_3, pairs_ret3 = pairs(update_parts_ret);
	local v22, _ = pairs_ret1_3(pairs_ret2_3, pairs_ret3);
	if --[[generic for]] v22 then
		bool1 = true;
	end
	if not bool1 then return end
	local v23 = 1;
	while v23 <= #t__shaders do
		local v28 = t__shaders[v23];
		local t_config = v28.config;
		local t_duration = t_config.duration;
		local math_min_ret = math.min(v28.t, t_duration);
		local math_min_ret2 = math.min(p40, t_duration - math_min_ret);
		local v29 = math_min_ret + math_min_ret2;
		local v30 = 1;
		if v29 < t_config.fade_in then
			local v34 = v29 / t_config.fade_in;
			v30 = v30 * math.pow(v34, t_config.fade_in_exp or 1);
		end
		local v31 = t_duration - t_config.fade_out;
		if v31 < v29 then
			local v35 = (v29 - v31) / t_config.fade_out;
			v30 = v30 * (1 - math.pow(v35, t_config.fade_out_exp or 1));
		end
		local v32 = t_config.weight * v30;
		local t_priority = t_config.priority;
		for _, val5 in pairs(update_parts_ret) do
			t_config.callback(math_min_ret, math_min_ret2, val5);
			table1.sum_part(val5, v32, t_priority, v30);
		end
		v28.t = v28.t + p40;
		if v28.t >= t_config.duration then
			table.remove(t__shaders, v23);
		else
			v23 = v23 + 1;
		end
	end
	for _, val4 in pairs(update_parts_ret) do
		table1.render_part(val4);
	end
end
table1.prototype.render_stepped = render_stepped;
local function add(p41, p42) -- Line: 412
	local table12 = {
		t = 0,
		config = p42
	};
	table.insert(p41._shaders, table12);
end
table1.prototype.add = add;
return table1;

-- https://github.com/kalidrios

local table1 = {
	assert_type = function(p30, p31, p32) -- assert_type (Line: 7)
		if typeof(p30) == "Instance" then
			if p30.ClassName == p31 then
				return p30;
			end
			error(string.format("%s must be a %s", p32, p31), 2);
			return;
		end
		error(string.format("%s must be a %s", p32, p31), 2);
	end,
	assert_type_any = function(p33, p34, p35) -- assert_type_any (Line: 19)
		if typeof(p33) == "Instance" then
			if p33:IsA(p34) then
				return p33;
			end
			error(p35 .. " must be a " .. p34, 2);
			return;
		end
		error(p35 .. " must be a " .. p34, 2);
	end,
	clone = function(p36) -- clone (Line: 31)
		return p36:Clone();
	end,
	type_check = function(p37, p38) -- type_check (Line: 35)
		if typeof(p37) == "Instance" then
			if not p38 then
				return true;
			end
			if p37.ClassName == p38 then
				return true;
			end
		end
		return false;
	end,
	type_check_any = function(p39, p40) -- type_check_any (Line: 48)
		if typeof(p39) == "Instance" then
			if not p40 then
				return true;
			end
			if p39:IsA(p40) then
				return true;
			end
		end
		return false;
	end,
	type_cast = function(p41, p42) -- type_cast (Line: 61)
		if typeof(p41) == "Instance" then
			if not p42 then
				return p41;
			end
			if p41.ClassName == p42 then
				return p41;
			end
		end
		return nil;
	end,
	type_cast_any = function(p43, p44) -- type_cast_any (Line: 74)
		if typeof(p43) == "Instance" then
			if not p44 then
				return p43;
			end
			if p43:IsA(p44) then
				return p43;
			end
		end
		return nil;
	end,
	get_attr = function(p45, p46, p47, p48) -- get_attr (Line: 88)
		local Attribute = p45:GetAttribute(p46);
		if Attribute ~= nil then
			if not p47 then
				return Attribute;
			end
			if typeof(Attribute) == p47 then
				return Attribute;
			end
		end
		return p48;
	end,
	set_attr = function(p49, p50, p51) -- set_attr (Line: 102)
		p49:SetAttribute(p50, p51);
	end,
	get_child = function(p52, p53, p54, p55) -- get_child (Line: 106)
		local FindFirstChild_ret = p52:FindFirstChild(p53, p55);
		if FindFirstChild_ret then
			if not p54 then
				return FindFirstChild_ret;
			end
			if FindFirstChild_ret.ClassName == p54 then
				return FindFirstChild_ret;
			end
		end
		return nil;
	end,
	get_child_any = function(p56, p57, p58, p59) -- get_child_any (Line: 120)
		local FindFirstChild_ret2 = p56:FindFirstChild(p57, p59);
		if FindFirstChild_ret2 then
			if not p58 then
				return FindFirstChild_ret2;
			end
			if FindFirstChild_ret2:IsA(p58) then
				return FindFirstChild_ret2;
			end
		end
		return nil;
	end,
	wait_child = function(p60, p61, p62, p63) -- wait_child (Line: 134)
		local WaitForChild_ret = p60:WaitForChild(p61, p63);
		if WaitForChild_ret then
			if not p62 then
				return WaitForChild_ret;
			end
			if WaitForChild_ret.ClassName == p62 then
				return WaitForChild_ret;
			end
		end
		return nil;
	end,
	wait_child_any = function(p64, p65, p66, p67) -- wait_child_any (Line: 148)
		local WaitForChild_ret2 = p64:WaitForChild(p65, p67);
		if WaitForChild_ret2 then
			if not p66 then
				return WaitForChild_ret2;
			end
			if WaitForChild_ret2:IsA(p66) then
				return WaitForChild_ret2;
			end
		end
		return nil;
	end
};
function table1.get_first_child(p1, p2, p3, p4) -- Line: 162
	--[[
		Upvalues:
			[1] = table1
	--]]
	for _, val1 in ipairs(p1) do
		local _child = table1.get_child(val1, p2, p3);
		if not _child then continue end
		return _child;
	end
	return p4;
end
function table1.get_value_old2(p5, p6, p7, p8) -- Line: 172
	local FindFirstChild_ret3 = p5:FindFirstChild(p6);
	if FindFirstChild_ret3 then
		if not p7 then
			return FindFirstChild_ret3.Value;
		end
		if FindFirstChild_ret3.ClassName == p7 then
			return FindFirstChild_ret3.Value;
		end
	end
	return p8;
end
function table1.get_first_value(p9, p10, p11, p12) -- Line: 186
	--[[
		Upvalues:
			[1] = table1
	--]]
	for _, val2 in ipairs(p9) do
		local _value = table1.get_value(val2, p10, p11);
		if _value == nil then continue end
		return _value;
	end
	return p12;
end
function table1.in_workspace(p13) -- Line: 196
	return workspace:IsAncestorOf(p13);
end
function table1.new_value_old2(p14, p15, p16, p17) -- Line: 200
	local Instance_new_ret = Instance.new(p16);
	Instance_new_ret.Name = p15;
	Instance_new_ret.Value = p17;
	Instance_new_ret.Parent = p14;
	return Instance_new_ret;
end
function table1.set_value_old2(p18, p19, p20, p21) -- Line: 208
	--[[
		Upvalues:
			[1] = table1
	--]]
	local FindFirstChild_ret4 = p18:FindFirstChild(p19);
	if p21 == nil then
		if FindFirstChild_ret4 then
			FindFirstChild_ret4:Destroy();
		end
		return nil;
	end
	if FindFirstChild_ret4 then
		if FindFirstChild_ret4.ClassName == p20 then
			FindFirstChild_ret4.Value = p21;
			return FindFirstChild_ret4;
		end
		FindFirstChild_ret4:Destroy();
	end
	return table1.new_value_old2(p18, p19, p20, p21);
end
local table2 = {
	BoolValue = "boolean",
	BrickColorValue = "BrickColor",
	CFrameValue = "CFrame",
	Color3Value = "Color3",
	IntValue = "int",
	NumberValue = "number",
	ObjectValue = "Instance",
	RayValue = "Ray",
	StringValue = "string",
	Vector3Value = "Vector3"
};
table1.value_to_lua = table2;
local table3 = {
	boolean = "BoolValue",
	BrickColor = "BrickColorValue",
	CFrame = "CFrameValue",
	Color3 = "Color3Value",
	int = "IntValue",
	number = "NumberValue",
	Instance = "ObjectValue",
	Ray = "RayValue",
	string = "StringValue",
	Vector3 = "Vector3Value"
};
table1.lua_to_value = table3;
function table1.set_value(p22, p23, p24, p25) -- Line: 257
	--[[
		Upvalues:
			[1] = table2
			[2] = table1
	--]]
	local FindFirstChild_ret5 = p22:FindFirstChild(p23);
	if table2[p24] then
		if p25 ~= nil then
			if FindFirstChild_ret5 then
				if FindFirstChild_ret5.ClassName == p24 then
					FindFirstChild_ret5.Value = p25;
					return FindFirstChild_ret5;
				end
				FindFirstChild_ret5:Destroy();
			end
			local Instance_new_ret2 = Instance.new(p24);
			Instance_new_ret2.Name = p23;
			Instance_new_ret2.Value = p25;
			Instance_new_ret2.Parent = p22;
			return Instance_new_ret2;
		end
		if FindFirstChild_ret5 then
			FindFirstChild_ret5:Destroy();
		end
	else
		if FindFirstChild_ret5 then
			FindFirstChild_ret5:Destroy();
		end
		if p25 ~= nil then
			local v1 = table1.clone(p25);
			v1.Name = p23;
			v1.Parent = p22;
			return v1;
		end
	end
	return nil;
end
function table1.get_value(p26, p27, p28, p29) -- Line: 292
	--[[
		Upvalues:
			[1] = table2
	--]]
	local FindFirstChild_ret6 = p26:FindFirstChild(p27);
	if FindFirstChild_ret6 then
		if not p28 then
			if table2[FindFirstChild_ret6.ClassName] then
				return FindFirstChild_ret6.Value;
			end
			return FindFirstChild_ret6;
		end
		if FindFirstChild_ret6:IsA(p28) then
			if table2[p28] then
				return FindFirstChild_ret6.Value;
			end
			return FindFirstChild_ret6;
		end
	end
	return p29;
end
return table1;

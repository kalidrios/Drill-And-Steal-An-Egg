-- https://github.com/kalidrios

local m_humanoid_helper = require(script.Parent.humanoid_helper);
local _ = require(script.Parent.lambda);
local m_instances = require(script.Parent.instances);
local m_objects = require(script.Parent.objects);
local table1 = {apply_character = function(p14, p15) -- apply_character (Line: 12)
	if p14.Character then
		p15(p14.Character);
		return;
	end
	local Connect_ret = nil;
	Connect_ret = p14.CharacterAdded:Connect(function(character) -- Line: 17
		--[[
			Upvalues:
				[1] = Connect_ret
				[2] = p15
		--]]
		Connect_ret:Disconnect();
		p15(character);
	end);
end};
function table1.player_data(p1) -- Line: 24
	--[[
		Upvalues:
			[1] = table1
			[2] = m_objects
			[3] = m_instances
	--]]
	if table1.is_player(p1) then
		local v2 = m_objects.type_cast(p1);
		return m_instances.get_child(v2, "Folder", "PlayerData");
	end
	return nil;
end
function table1.vars(p2) -- Line: 34
	--[[
		Upvalues:
			[1] = m_objects
	--]]
	if p2 then
		local v3 = m_objects.type_cast(p2.Character);
		if v3 then
			local v5 = m_objects.type_cast(v3:FindFirstChildOfClass("Humanoid"));
			if v5 then
				local t_RootPart = v5.RootPart;
				if t_RootPart then
					return p2, v3, v5, t_RootPart;
				end
			end
		end
	end
	return nil, nil, nil, nil;
end
function table1.vars_all(p3) -- Line: 51
	--[[
		Upvalues:
			[1] = m_objects
			[2] = m_instances
	--]]
	if p3 then
		local v4 = m_objects.type_cast(p3.Character);
		if v4 then
			local v6 = m_objects.type_cast(v4:FindFirstChildOfClass("Humanoid"));
			if v6 then
				local t_RootPart2 = v6.RootPart;
				if t_RootPart2 then
					local _child = m_instances.get_child(p3, "PlayerData", "Configuration");
					if _child then
						local _child2 = m_instances.get_child(_child, "stats", "StringValue");
						if _child2 then
							return p3, v4, v6, t_RootPart2, _child, _child2;
						end
					end
				end
			end
		end
	end
	return nil, nil, nil, nil, nil, nil;
end
function table1.get_character(p4) -- Line: 74
	--[[
		Upvalues:
			[1] = m_instances
	--]]
	local v1 = m_instances.type_cast(p4, "Player");
	if v1 then
		return v1.Character;
	end
	return nil;
end
function table1.is_player(p5) -- Line: 82
	--[[
		Upvalues:
			[1] = table1
	--]]
	return table1.get_character(p5) ~= nil;
end
function table1.get_humanoid_root_part(p6) -- Line: 86
	--[[
		Upvalues:
			[1] = m_humanoid_helper
			[2] = table1
	--]]
	return m_humanoid_helper.get_humanoid_root_part(table1.get_character(p6));
end
function table1.get_head(p7) -- Line: 90
	--[[
		Upvalues:
			[1] = m_humanoid_helper
			[2] = table1
	--]]
	return m_humanoid_helper.get_head(table1.get_character(p7));
end
function table1.get_head_cframe(p8) -- Line: 95
	--[[
		Upvalues:
			[1] = m_humanoid_helper
			[2] = table1
	--]]
	return m_humanoid_helper.get_head_cframe(table1.get_character(p8));
end
function table1.get_head_pos(p9) -- Line: 99
	--[[
		Upvalues:
			[1] = m_humanoid_helper
			[2] = table1
	--]]
	return m_humanoid_helper.get_head_pos(table1.get_character(p9));
end
function table1.get_feet_cframe(p10) -- Line: 104
	--[[
		Upvalues:
			[1] = m_humanoid_helper
			[2] = table1
	--]]
	return m_humanoid_helper.get_feet_cframe(table1.get_character(p10));
end
function table1.get_feet_pos(p11) -- Line: 108
	--[[
		Upvalues:
			[1] = m_humanoid_helper
			[2] = table1
	--]]
	return m_humanoid_helper.get_feet_pos(table1.get_character(p11));
end
function table1.get_root_cframe(p12) -- Line: 113
	--[[
		Upvalues:
			[1] = m_humanoid_helper
			[2] = table1
	--]]
	return m_humanoid_helper.get_root_cframe(table1.get_character(p12));
end
function table1.get_root_pos(p13) -- Line: 117
	--[[
		Upvalues:
			[1] = m_humanoid_helper
			[2] = table1
	--]]
	return m_humanoid_helper.get_root_pos(table1.get_character(p13));
end
return table1;

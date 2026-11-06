-- https://github.com/kalidrios

local m_instances = require(script.Parent.instances);
local _ = require(script.Parent.math_helper);
local _ = require(script.Parent.objects);
local table1 = {prototype = {}};
table1.__index = table1.prototype;
function table1.new(p1, _, p2) -- Line: 41
	--[[
		Upvalues:
			[1] = m_instances
			[2] = table1
	--]]
	local GetBoundingBox_ret1, GetBoundingBox_ret2 = p1:GetBoundingBox();
	local table2 = {
		character = {box = {
			cframe = GetBoundingBox_ret1,
			size = GetBoundingBox_ret2
		}},
		root_part = {box = {
			cframe = p2.CFrame,
			size = p2.Size
		}}
	};
	local _child_any = m_instances.get_child_any(p1, "Head", "BasePart");
	if _child_any then
		local table4 = {box = {
			cframe = _child_any.CFrame,
			size = _child_any.Size
		}};
		local _child_any2 = m_instances.get_child_any(_child_any, "FaceCenterAttachment", "Attachment");
		if _child_any2 then
			table4.face_center_att = {
				axis = _child_any2.Axis,
				cframe = _child_any2.CFrame
			};
		end
		local _child_any3 = m_instances.get_child_any(_child_any, "FaceFrontAttachment", "Attachment");
		if _child_any3 then
			table4.face_front_att = {
				axis = _child_any3.Axis,
				cframe = _child_any3.CFrame
			};
		end
		table2.head = table4;
	end
	local table3 = {_humanoid = table2};
	setmetatable(table3, table1.prototype);
	return table3;
end
local function compute(_, _, _) -- Line: 94
end
table1.prototype.compute = compute;
return table1;

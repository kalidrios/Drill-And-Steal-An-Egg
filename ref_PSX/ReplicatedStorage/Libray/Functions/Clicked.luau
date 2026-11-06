-- https://github.com/kalidrios

local _ = require(script.Parent.IsEmpty);
local Players = game:GetService("Players");
local table1 = {};
local bool1 = false;
function Create(p1, p2) -- Line: 22
	--[[
		Upvalues:
			[1] = table1
	--]]
	p2 = p2:lower();
	if p2 ~= "mouse1down" and p2 ~= "mouse1up" and p2 ~= "mouse1click" and p2 ~= "mouse2down" and p2 ~= "mouse2up" and p2 ~= "mouse2click" then
		error('_L.Functions.Clicked - "' .. p2 .. '" is an invalid event type. Check spelling!');
	end
	local v1 = table1[p1];
	if not v1 then
		v1 = {};
		table1[p1] = v1;
	end
	local v2 = v1[p2];
	if v2 then
		return v2;
	end
	local BindableEvent = Instance.new("BindableEvent");
	v1[p2] = BindableEvent;
	return BindableEvent;
end
function Fire(p3) -- Line: 45
	--[[
		Upvalues:
			[1] = Players
			[2] = table1
	--]]
	p3 = p3:lower();
	local t_Target = Players.LocalPlayer.GetMouse().Target;
	local v3 = t_Target.ClassName == "Folder" and true or t_Target.ClassName == "Model";
	if t_Target and t_Target.Parent then
		for key1, val1 in pairs(table1) do
			if (not v3 or (key1.ClassName ~= "Folder" or not true) and key1.ClassName ~= "Model" or not t_Target:IsDescendantOf(key1)) and t_Target ~= key1 or not val1[p3] then continue end
			val1[p3]:Fire();
			return;
		end
	end
end
function Init() -- Line: 64
	--[[
		Upvalues:
			[1] = bool1
			[2] = Players
	--]]
	bool1 = true;
	local Mouse = Players.LocalPlayer.GetMouse();
	Mouse.Button1Down:Connect(function() -- Line: 68
		--[[
			Upvalues:
				[1] = Mouse
		--]]
		Fire("mouse1down");
		Mouse.Button1Up:Wait();
		Fire("mouse1click");
	end);
	Mouse.Button1Up:Connect(function() -- Line: 74
		Fire("mouse1up");
	end);
	Mouse.Button2Down:Connect(function() -- Line: 78
		--[[
			Upvalues:
				[1] = Mouse
		--]]
		Fire("mouse2down");
		Mouse.Button2Up:Wait();
		Fire("mouse2click");
	end);
	Mouse.Button2Up:Connect(function() -- Line: 84
		Fire("mouse2up");
	end);
end
return function(p4, p5) -- Line: 90
	--[[
		Upvalues:
			[1] = bool1
	--]]
	if not bool1 then
		Init();
	end
	return Create(p4, p5 or "mouse1click");
end;

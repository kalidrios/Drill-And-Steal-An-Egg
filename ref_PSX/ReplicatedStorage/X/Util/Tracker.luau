-- https://github.com/kalidrios

local table1 = {};
function call(p1, ...) -- Line: 7
	p1:track(...);
end
function table1.new() -- Line: 16
	--[[
		Upvalues:
			[1] = table1
	--]]
	local table2 = {objects = {}};
	local new_mt = setmetatable(table2, {
		__index = table1,
		__call = call
	});
	return new_mt;
end
function table1.track(p2, ...) -- Line: 24
	for _, val1 in ipairs(table.pack(...)) do
		table.insert(p2.objects, val1);
	end
end
function table1.destroy(p3) -- Line: 30
	local t_objects = p3.objects;
	p3.objects = {};
	for _, val2 in ipairs(t_objects) do
		local success, pcall_ret2 = pcall(function() -- Line: 34
			--[[
				Upvalues:
					[1] = val2
			--]]
			if typeof(val2) == "Instance" then
				val2:Destroy();
				return;
			end
			if typeof(val2) == "RBXScriptConnection" then
				val2:Disconnect();
				return;
			end
			if typeof(val2) == "function" then
				val2();
			end
		end);
		if success then continue end
		warn(string.format("[Tracker] Destruction failed for type '%s': %s", typeof(val2), tostring(pcall_ret2)));
	end
	return true;
end
return table1;

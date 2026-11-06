-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

function call(p1, ...)
	p1:track(...);
end;
local u1 = {}
	u1 = {
	new = function()
		return setmetatable({
			objects = {}
		}, {
			__index = u1, 
			__call = call
		});
	end, 
	track = function(p2, ...)
		for v1, v2 in ipairs(table.pack(...)) do
			table.insert(p2.objects, v2);		
		end;
	end, 
	destroy = function(p3)
		p3.objects = {};
		for v4, v5 in ipairs(p3.objects) do
			local v7, v8 = pcall(function()
				if typeof(v5) == "Instance" then
					v5:Destroy();
					return;
				end;
				if typeof(v5) == "RBXScriptConnection" then
					v5:Disconnect();
					return;
				end;
				if typeof(v5) == "function" then
					v5();
				end;
			end);
			if not v7 then
				warn(string.format("[Tracker] Destruction failed for type '%s': %s", typeof(v5), tostring(v8)));
			end;		
		end;
		return true;
	end
};
return function()
	return u1.new();
end;

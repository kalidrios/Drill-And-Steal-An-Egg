-- https://github.com/kalidrios

return function(p1, p2) -- Line: 14
	assert(typeof(p2) == "function");
	if typeof(p1) == "Instance" then
		local Children = p1:GetChildren();
		for _, val1 in ipairs(Children) do
			if not p2(val1) then continue end
			return val1;
		end
	else
		assert(typeof(p1) == "table");
		for _, val2 in ipairs(p1) do
			assert(typeof(val2) == "Instance");
			if not p2(val2) then continue end
			return val2;
		end
	end
	return nil;
end;

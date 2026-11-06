-- https://github.com/kalidrios

return function() -- Line: 3
	local table1 = {};
	return function(p1, p2, p3) -- Line: 7
		--[[
			Upvalues:
				[1] = table1
		--]]
		if table1[p1] then return end
		table1[p1] = true;
		task.delay(p2, function() -- Line: 12
			--[[
				Upvalues:
					[1] = table1
					[2] = p1
			--]]
			table1[p1] = nil;
		end);
		p3();
	end;
end;

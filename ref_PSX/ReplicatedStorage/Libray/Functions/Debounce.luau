-- https://github.com/kalidrios

return function() -- Line: 12
	local bool1 = false;
	return function(p1, p2) -- Line: 16
		--[[
			Upvalues:
				[1] = bool1
		--]]
		if bool1 then return end
		bool1 = true;
		task.delay(p1, function() -- Line: 21
			--[[
				Upvalues:
					[1] = bool1
			--]]
			bool1 = false;
		end);
		p2();
	end;
end;

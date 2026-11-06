-- https://github.com/kalidrios

local RunService = game:GetService("RunService");
return function(p1, p2, p3) -- Line: 29
	--[[
		Upvalues:
			[1] = RunService
	--]]
	local u1 = p3 or 1;
	local bool1 = true;
	task.spawn(function() -- Line: 36
		--[[
			Upvalues:
				[1] = p1
				[2] = bool1
				[3] = u1
				[4] = p2
				[5] = RunService
		--]]
		local os_clock_ret = os.clock();
		while p1 and p1.Parent and bool1 do
			local v1 = (os.clock() - os_clock_ret) * (1 / u1);
			if v1 >= 1 then
				os_clock_ret = os.clock();
				v1 = 0;
			end
			p1[p2] = Color3.fromHSV(v1, 1, 1);
			RunService.Stepped:Wait();
		end
	end);
	return function() -- Line: 56
		--[[
			Upvalues:
				[1] = bool1
		--]]
		bool1 = false;
	end;
end;

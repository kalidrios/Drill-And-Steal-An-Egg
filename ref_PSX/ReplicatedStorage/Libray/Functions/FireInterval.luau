-- https://github.com/kalidrios

return function(p1, p2, p3, p4, p5) -- Line: 3
	assert(typeof(p1) == "number");
	assert(typeof(p2) == "number");
	assert(typeof(p3) == "function");
	while workspace:GetServerTimeNow() > p1 do
		p1 = p1 + p2;
	end
	local u1 = p1;
	local u2 = p1 - p4;
	local bool1 = false;
	local _ = game:GetService("RunService").Heartbeat:Connect(function(_) -- Line: 19
		--[[
			Upvalues:
				[1] = u1
				[2] = p3
				[3] = p2
				[4] = u2
				[5] = p4
				[6] = bool1
				[7] = p5
		--]]
		task.spawn(function() -- Line: 20
			--[[
				Upvalues:
					[1] = u1
					[2] = p3
					[3] = p2
					[4] = u2
					[5] = p4
					[6] = bool1
			--]]
			if workspace:GetServerTimeNow() < u1 then return end
			local success, pcall_ret2 = pcall(p3);
			if success then
				if not pcall_ret2 then return end
			else
				warn(tostring(pcall_ret2));
			end
			u1 = workspace:GetServerTimeNow() + p2;
			u2 = workspace:GetServerTimeNow() + (p2 - p4);
			bool1 = false;
		end);
		task.spawn(function() -- Line: 44
			--[[
				Upvalues:
					[1] = p5
					[2] = bool1
					[3] = u2
			--]]
			if not p5 or bool1 then return end
			if workspace:GetServerTimeNow() < u2 then return end
			local success2, pcall_ret2_2 = pcall(p5);
			if success2 then
				if not pcall_ret2_2 then return end
			else
				warn(tostring(pcall_ret2_2));
			end
			bool1 = true;
		end);
	end);
end;

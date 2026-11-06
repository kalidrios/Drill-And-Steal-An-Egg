-- https://github.com/kalidrios

return function(p1, p2, p3) -- Line: 3
	assert(typeof(p1) == "number");
	assert(typeof(p2) == "function");
	if not p3 and workspace:GetServerTimeNow() > p1 then return end
	local bool1 = false;
	local Connect_ret = nil;
	Connect_ret = game:GetService("RunService").Heartbeat:Connect(function(_) -- Line: 15
		--[[
			Upvalues:
				[1] = bool1
				[2] = p1
				[3] = p2
				[4] = Connect_ret
		--]]
		if bool1 then return end
		if workspace:GetServerTimeNow() < p1 then return end
		local success, pcall_ret2 = pcall(p2);
		if success then
			if not pcall_ret2 then return end
		else
			warn(tostring(pcall_ret2));
		end
		bool1 = true;
		Connect_ret:Disconnect();
	end);
end;

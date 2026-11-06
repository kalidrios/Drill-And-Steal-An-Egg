-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

local l__RunService__1 = game:GetService("RunService");
return function(p1, p2, p3, p4)
	assert(typeof(p1) == "function");
	if p2 ~= nil then
		assert(typeof(p2) == "number");
		assert(p2 > 0);
		assert(p2 == p2);
	end;
	local v1 = {};
	local u2 = nil;
	local u3 = {};
	function v1.Disconnect(p5)
		if u2 then	
			u2:Disconnect();
			u2 = nil;
		end;
		if #u3 > 0 then
			u3 = {};
			for v2, v3 in ipairs(u3) do
				v3();			
			end;
		end;
	end;
	function v1.IsConnected(p6)
		return u2 ~= nil;
	end;
	function v1.Then(p7, p8)
		assert(typeof(p8) == "function");
		if u2 then
			table.insert(u3, p8);
			return;
		end;
		p8();
	end;
	function v1.Wait(p9)
		while p9:IsConnected() do
			task.wait();		
		end;
	end;
	local u4 = p2 or math.huge;
	local u5 = 0;
	u2 = l__RunService__1.Heartbeat:Connect(function(p10)
		if not p4 then
			p10 = math.min(p10, u4 - u5);
		end;
		u5 = u5 + p10;
		if not p4 then
			u5 = math.min(u5, u4);
		end;
		local v5 = p10;
		local v6 = u5;
		if p3 and u4 ~= math.huge then
			v5 = v5 / u4;
			v6 = v6 / u4;
			if not p4 then
				v5 = math.min(v5, 1 - v6);
				v6 = math.min(v6, 1);
			end;
		end;
		if p1(v5, v6) or u4 <= u5 then
			v1:Disconnect();
		end;
	end);
	return v1;
end;

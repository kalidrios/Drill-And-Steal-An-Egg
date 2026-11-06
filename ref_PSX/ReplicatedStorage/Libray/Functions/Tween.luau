--------|     Setting     |--------

--------|    Reference    |--------

--------|    Variables    |--------

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


--[[
	
	Quicker (and limited) way to use TweenService since the default synax takes up a paragraph. Supports tuple of instances.
	
	Functions.Tween(
		instance,				<-- |REQ| 	Instance that will be tweened
		{property = 300},		<-- |REQ|	Dictionary of properties and their values 			
		{speed, style, dir}		<-- |REQ|	Array: Speed (sec), Style (str), Direction (str)	[defaults to: {1, "Sine", "InOut"}]
	)
	
--]]

local TweenService = game:GetService("TweenService");
return function(p1, p2, p3, p4) -- Line: 18
	--[[
		Upvalues:
			[1] = TweenService
	--]]
	local v1 = typeof(p1) == "table" and p1 or {p1};
	local table1 = {};
	for _, val1 in ipairs(v1) do
		local v2;
		if p3 == nil then
			local table2 = {
				1,
				Enum.EasingStyle.Linear,
				Enum.EasingDirection.Out
			};
			v2 = table2;
		else
			v2 = p3;
			if v2[2] == nil then
				v2[2] = Enum.EasingStyle.Sine;
			elseif type(v2[2]) == "string" then
				if string.lower(v2[2]) == "expo" then
					v2[2] = Enum.EasingStyle.Exponential;
				else
					v2[2] = Enum.EasingStyle[v2[2]];
				end
			end
			if v2[3] == nil then
				v2[3] = Enum.EasingDirection.InOut;
			elseif type(v2[3]) == "string" then
				v2[3] = Enum.EasingDirection[v2[3]];
			end
		end
		local TweenInfo_new_ret = TweenInfo.new(unpack(v2));
		local Create_ret = TweenService:Create(val1, TweenInfo_new_ret, p2);
		if p4 then
			task.delay(p4, function() -- Line: 73
				--[[
					Upvalues:
						[1] = Create_ret
				--]]
				Create_ret:Play();
			end);
		else
			Create_ret:Play();
		end
		table.insert(table1, Create_ret);
	end
	
	return unpack(table1);
end;

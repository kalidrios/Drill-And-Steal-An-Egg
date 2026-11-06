-- https://github.com/kalidrios

local Random_new_ret = Random.new();
return function(p1, p2) -- Line: 5
	--[[
		Upvalues:
			[1] = Random_new_ret
	--]]
	local t_Keypoints = p1.Keypoints;
	if #t_Keypoints == 0 then
		return 0;
	end
	p2 = math.clamp(p2, 0, 1);
	if p2 < 1 then
		for index1 = 1, #t_Keypoints - 1 do
			local v1 = t_Keypoints[index1];
			local v2 = t_Keypoints[index1 + 1];
			if v1.Time > p2 or p2 >= v2.Time then continue end
			local v3 = (p2 - v1.Time) / (v2.Time - v1.Time);
			local v4 = v1.Value + (v2.Value - v1.Value) * v3;
			local v5 = v1.Envelope + (v2.Envelope - v1.Envelope) * v3;
			if v5 > 0 then
				v4 = v4 + Random_new_ret:NextNumber(-v5, v5);
			end
			return v4;
		end
	end
	return t_Keypoints[#t_Keypoints].Value;
end;

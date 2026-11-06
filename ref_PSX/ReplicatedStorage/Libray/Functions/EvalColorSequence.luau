-- https://github.com/kalidrios

local _ = Random.new();
return function(p1, p2) -- Line: 5
	local t_Keypoints = p1.Keypoints;
	if #t_Keypoints == 0 then
		return Color3.new();
	end
	p2 = math.clamp(p2, 0, 1);
	if p2 < 1 then
		for index1 = 1, #t_Keypoints - 1 do
			local v1 = t_Keypoints[index1];
			local v2 = t_Keypoints[index1 + 1];
			if v1.Time <= p2 and p2 < v2.Time then
				local v3 = (p2 - v1.Time) / (v2.Time - v1.Time);
				return Color3.new(v1.Value.R + (v2.Value.R - v1.Value.R) * v3, v1.Value.G + (v2.Value.G - v1.Value.G) * v3, v1.Value.B + (v2.Value.B - v1.Value.B) * v3);
			end
		end
	end
	return t_Keypoints[#t_Keypoints].Value;
end;

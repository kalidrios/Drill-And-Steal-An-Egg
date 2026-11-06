-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

return function(p1, p2)
	local v1 = Vector3.new(p1:ToHSV());
	local v2 = Vector3.new(p1.R, p1.G, p1.B);
	local v3 = {};
	local v4 = 0;
	for v5, v6 in ipairs(p2) do
		local l__a__8 = v6.a;
		local v9 = 1 - math.clamp((v2 - Vector3.new(l__a__8.R, l__a__8.G, l__a__8.B)).Magnitude / 1.7320508075688772, 0, 1);
		local l__response__10 = v6.response;
		if l__response__10 then
			v9 = math.clamp(l__response__10(v9), 0, 1);
		end;
		if not (v9 <= (v6.threshold or 1E-06)) and v9 == v9 then
			local v11 = v9;
			if v6.weight then
				v11 = v11 * v6.weight;
			end;
			v4 = v4 + v11;
			table.insert(v3, {
				ratio = v9, 
				weight = v11, 
				keypoint = v6
			});
		end;	
	end;
	if not (v4 > 0) then
		return p1;
	end;
	local v12 = Vector3.zero;
	for v13, v14 in ipairs(v3) do
		local l__b__16 = v14.keypoint.b;
		v12 = v12 + (v2 * (1 - v14.ratio) + Vector3.new(l__b__16.R, l__b__16.G, l__b__16.B) * v14.ratio) * v14.weight;	
	end;
	local v17 = v12 / v4;
	return Color3.new(math.clamp(v17.X, 0, 1), math.clamp(v17.Y, 0, 1), (math.clamp(v17.Z, 0, 1)));
end;

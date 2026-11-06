-- https://github.com/kalidrios

return function(p1, p2) -- Line: 4
	local t_X = p2.X;
	local t_Y = p2.Y;
	local t_Z = p2.Z;
	local GetComponents_ret1, GetComponents_ret2, GetComponents_ret3, GetComponents_ret4, GetComponents_ret5, GetComponents_ret6, GetComponents_ret7, GetComponents_ret8, GetComponents_ret9, GetComponents_ret10, GetComponents_ret11, GetComponents_ret12 = p1:GetComponents();
	local v1 = (math.abs(GetComponents_ret4) * t_X + math.abs(GetComponents_ret5) * t_Y + math.abs(GetComponents_ret6) * t_Z) * 0.5;
	local v2 = (math.abs(GetComponents_ret7) * t_X + math.abs(GetComponents_ret8) * t_Y + math.abs(GetComponents_ret9) * t_Z) * 0.5;
	local v3 = (math.abs(GetComponents_ret10) * t_X + math.abs(GetComponents_ret11) * t_Y + math.abs(GetComponents_ret12) * t_Z) * 0.5;
	local v4 = GetComponents_ret1 - v1;
	local v5 = GetComponents_ret2 - v2;
	local v6 = GetComponents_ret3 - v3;
	local v7 = GetComponents_ret1 + v1;
	local v8 = GetComponents_ret2 + v2;
	local v9 = GetComponents_ret3 + v3;
	return Vector3.new(v4, v5, v6), Vector3.new(v7, v8, v9);
end;

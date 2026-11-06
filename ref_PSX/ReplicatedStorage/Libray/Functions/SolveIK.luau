-- https://github.com/kalidrios

return function(p1, p2, p3, p4) -- Line: 16
	local PointToObjectSpace_ret = p1:PointToObjectSpace(p2);
	local t_Unit = PointToObjectSpace_ret.Unit;
	local t_Magnitude = PointToObjectSpace_ret.Magnitude;
	local Cross_ret = Vector3.new(0, 0, -1):Cross(t_Unit);
	local math_acos_ret = math.acos(-t_Unit.Z);
	local v1 = p1 * CFrame.fromAxisAngle(Cross_ret, math_acos_ret);
	if math.max(p4, p3) - math.min(p4, p3) > t_Magnitude then
		return v1 * CFrame.new(0, 0, math.max(p4, p3) - math.min(p4, p3) - t_Magnitude), -math.pi / 2, math.pi;
	end
	if p3 + p4 < t_Magnitude then
		return v1, math.pi / 2, 0;
	end
	local v2 = -math.acos((-(p4 * p4) + p3 * p3 + t_Magnitude * t_Magnitude) / (p3 * 2 * t_Magnitude));
	return v1, v2 + math.pi / 2, math.acos((p4 * p4 - p3 * p3 + t_Magnitude * t_Magnitude) / (p4 * 2 * t_Magnitude)) - v2;
end;

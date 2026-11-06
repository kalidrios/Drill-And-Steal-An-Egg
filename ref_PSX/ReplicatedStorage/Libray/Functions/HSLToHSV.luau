-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

return function(p1)
	local l__Y__1 = p1.Y;
	local v2 = (2 * l__Y__1 + p1.Z * (1 - math.abs(2 * l__Y__1 - 1))) / 2;
	local v3 = 0;
	if v2 ~= 0 and v2 ~= 1 then
		v3 = (v2 - l__Y__1) / math.min(v2, 1 - v2);
	end;
	return Vector3.new(p1.X, v3, v2);
end;

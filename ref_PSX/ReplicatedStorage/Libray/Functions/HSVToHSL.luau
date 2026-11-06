-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

return function(p1)
	local l__Y__1 = p1.Y;
	local l__Z__2 = p1.Z;
	local v3 = (2 - l__Y__1) * l__Z__2 / 2;
	local v4
	if v3 ~= 0 then
		if v3 == 1 then
			v4 = 0;
		elseif v3 < 0.5 then
			v4 = l__Y__1 * l__Z__2 / (v3 * 2);
		else
			v4 = l__Y__1 * l__Z__2 / (2 - v3 * 2);
		end;
	else
		v4 = 0;
	end;
	return Vector3.new(p1.X, v4, v3);
end;

-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

function hue2rgb(p1, p2, p3)
	if p3 < 0 then
		p3 = p3 + 1;
	end;
	if 1 < p3 then
		p3 = p3 - 1;
	end;
	if p3 < 0.16666666666666666 then
		return p1 + (p2 - p1) * 6 * p3;
	end;
	if p3 < 0.5 then
		return p2;
	end;
	if p3 < 0.6666666666666666 then

	else
		return p1;
	end;
	return p1 + (p2 - p1) * (0.6666666666666666 - p3) * 6;
end;
return function(p4)
	local l__X__1 = p4.X;
	local l__Y__2 = p4.Y;
	local l__Z__3 = p4.Z;
	local v7 
	local v4
	local v5
	local v6
	if l__Y__2 == 0 then
		v4 = l__Z__3;
		v5 = l__Z__3;
		v6 = l__Z__3;
	else
		if l__Z__3 < 0.5 then
			v7 = l__Z__3 * (1 + l__Y__2);
		else
			v7 = l__Z__3 + l__Y__2 - l__Z__3 * l__Y__2;
		end;
		local v8 = 2 * l__Z__3 - v7;
		v4 = hue2rgb(v8, v7, l__X__1 + 0.3333333333333333);
		v5 = hue2rgb(v8, v7, l__X__1);
		v6 = hue2rgb(v8, v7, l__X__1 - 0.3333333333333333);
	end;
	return Color3.new(v4, v5, v6);
end;

-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

return function(p1)
	local l__R__1 = p1.R;
	local l__G__2 = p1.G;
	local l__B__3 = p1.B;
	local v4 = math.max(l__R__1, l__G__2, l__B__3);
	local v5 = math.min(l__R__1, l__G__2, l__B__3);
	local v6 = (v4 + v5) / 2;
	local v7 = nil;
	local v8
	local v9
	if v4 == v5 then
		v8 = 0;
		v9 = 0;
	else
		local v10 = v4 - v5;
		if v6 > 0.5 then
			v9 = v10 / (2 - v4 - v5);
		else
			v9 = v10 / (v4 + v5);
		end;
		if v4 == l__R__1 then
			v7 = (l__G__2 - l__B__3) / v10;
			if l__G__2 < l__B__3 then
				v7 = v7 + 6;
			end;
		elseif v4 == l__G__2 then
			v7 = (l__B__3 - l__R__1) / v10 + 2;
		elseif v4 == l__B__3 then
			v7 = (l__R__1 - l__G__2) / v10 + 4;
		end;
		v8 = v7 / 6;
	end;
	return Vector3.new(v8, v9, v6);
end;

-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

local u1 = require(script.Parent.InverseLerp);
return function(p1, p2)
	local l__R__1 = p1.R;
	local l__G__2 = p1.G;
	local l__B__3 = p1.B;
	local v4 = l__R__1 * 0.299 + l__G__2 * 0.587 + l__B__3 * 0.114;
	local v5 = 1 + p2;
	return Color3.new(u1(v4, l__R__1, v5), u1(v4, l__G__2, v5), (u1(v4, l__B__3, v5)));
end;

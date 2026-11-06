-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

return function(p1)
	local v1 = #p1;
	for v2 = 1, math.floor(v1 / 2) do
		p1[v2] = p1[v1 - v2 + 1];
		p1[v1 - v2 + 1] = p1[v2];
	end;
	return p1;
end;

-- https://github.com/kalidrios

return function(p1, p2) -- Line: 3
	local v1 = 1;
	local v2 = #p1;
	while v1 <= v2 do
		if not p2(p1[v1]) then
			table.remove(p1, v1);
			v2 = v2 - 1;
		else
			v1 = v1 + 1;
		end
	end
end;

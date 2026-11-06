-- https://github.com/kalidrios

return function(p1, p2) -- Line: 15
	local table_find_ret = table.find(p1, p2);
	if table_find_ret then
		table.remove(p1, table_find_ret);
	end
	return p1;
end;

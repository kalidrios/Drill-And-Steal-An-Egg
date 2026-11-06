-- https://github.com/kalidrios

return function(p1) -- Line: 9
	if typeof(p1) == "table" then
		local table1 = {};
		for _, val1 in pairs(p1) do
			table.insert(table1, val1);
		end
		return table1;
	end
	return nil;
end;

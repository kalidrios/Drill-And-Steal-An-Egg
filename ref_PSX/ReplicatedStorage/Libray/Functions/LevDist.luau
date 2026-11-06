-- https://github.com/kalidrios

return function(p1, p2) -- Line: 9
	local v1 = #p1;
	local v2 = #p2;
	local table1 = {};
	for index1 = 0, v1 do
		table1[index1] = {[0] = index1};
	end
	for index2 = 0, v2 do
		table1[0][index2] = index2;
	end
	for index3 = 1, v1 do
		for index4 = 1, v2 do
			table1[index3][index4] = math.min(table1[index3 - 1][index4] + 1, table1[index3][index4 - 1] + 1, table1[index3 - 1][index4 - 1] + (p1:sub(index3, index3) == p2:sub(index4, index4) and 0 or 1));
		end
	end
	return table1[v1][v2];
end;

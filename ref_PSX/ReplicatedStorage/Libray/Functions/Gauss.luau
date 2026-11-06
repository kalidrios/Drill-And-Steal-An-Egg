-- https://github.com/kalidrios

return function(p1, p2) -- Line: 3
	local v1 = #p1;
	p1 = table.clone(p1);
	for key1, val1 in ipairs(p1) do
		p1[key1] = table.clone(val1);
	end
	p2 = table.clone(p2);
	for index1 = 1, v1 - 1 do
		local v2 = index1;
		for index3 = index1 + 1, v1 do
			if math.abs(p1[index3][index1]) > math.abs(p1[v2][index1]) then
				v2 = index3;
			end
		end
		if index1 ~= v2 then
			local v3 = p1[v2];
			local v4 = p1[index1];
			p1[index1] = v3;
			p1[v2] = v4;
			local v5 = p2[v2];
			local v6 = p2[index1];
			p2[index1] = v5;
			p2[v2] = v6;
		end
		for index4 = index1 + 1, v1 do
			local v7 = p1[index4][index1] / p1[index1][index1];
			p2[index4] = p2[index4] - v7 * p2[index1];
			for index6 = index1, v1 do
				local v8 = p1[index4];
				v8[index6] = v8[index6] - v7 * p1[index1][index6];
			end
		end
	end
	local table_create_ret = table.create(v1, 0);
	for index2 = v1, 1, -1 do
		table_create_ret[index2] = p2[index2];
		for index5 = index2 + 1, v1 do
			table_create_ret[index2] = table_create_ret[index2] - p1[index2][index5] * table_create_ret[index5];
		end
		table_create_ret[index2] = table_create_ret[index2] / p1[index2][index2];
	end
	return table_create_ret;
end;

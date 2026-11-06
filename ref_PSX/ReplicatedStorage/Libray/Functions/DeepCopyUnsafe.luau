-- https://github.com/kalidrios

function deep_copy(p1) -- Line: 3
	if typeof(p1) ~= "table" then
		return p1;
	end
	local table1 = {};
	local v1 = #p1;
	if v1 > 0 then
		for index1 = 1, v1 do
			table.insert(table1, deep_copy(p1[index1]));
		end
	else
		for key1, val1 in next, p1 do
			table1[deep_copy(key1)] = deep_copy(val1);
		end
	end
	return table1;
end
return deep_copy;

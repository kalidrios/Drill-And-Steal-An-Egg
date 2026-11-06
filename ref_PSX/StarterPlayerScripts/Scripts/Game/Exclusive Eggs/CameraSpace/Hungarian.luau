-- https://github.com/kalidrios

local table1 = {};
function Hungarian(p1) -- Line: 5
	local v1 = #p1;
	local table2 = {};
	local table3 = {};
	local table4 = {};
	local table5 = {};
	local table6 = {};
	for index1 = 1, v1 do
		table4[index1] = 0;
		table6[index1] = 0;
	end
	for index2 = 1, v1 do
		for index5 = 1, v1 do
			table5[index5] = math.huge;
		end
		while true do
			local v4 = 0;
			local v5 = 0;
			for index7 = 1, v1 do
				if table4[index7] == 0 and table5[index7] == 0 then
					local bool1 = true;
					for index10 = 1, v1 do
						if table4[index10] == index7 then
							bool1 = false;
							break;
						end
					end
					if bool1 then
						v4 = index7;
						break;
					end
				end
			end
			if v4 == 0 then break end
			local v6 = math.huge;
			for index8 = 1, v1 do
				if table4[index8] == 0 then
					local v7 = p1[v4][index8] - table2[v4] - table3[index8];
					if v7 < table5[index8] then
						table5[index8] = v7;
						table6[index8] = v4;
					end
					if table5[index8] < v6 then
						v6 = table5[index8];
						v5 = index8;
					end
				end
			end
			for index9 = 0, v1 do
				if table4[index9] == v5 then
					v4 = index9;
					break;
				end
			end
			table2[v4] = table2[v4] + v6;
			table3[v5] = table3[v5] - v6;
			table4[v5] = v4;
		end
	end
	local table7 = {};
	for index3 = 1, v1 do
		if table4[index3] > 0 then
			table7[table4[index3]] = index3;
		end
	end
	return table7;
end
function table1.minimize_distance(p2, p3) -- Line: 88
	local v2 = #p2;
	local v3 = #p3;
	local table8 = {};
	for index4 = 1, v2 do
		table8[index4] = {};
		for index6 = 1, v3 do
			table8[index4][index6] = (p2[index4] - p3[index6]).Magnitude;
		end
	end
	return Hungarian(table8);
end
return table1;

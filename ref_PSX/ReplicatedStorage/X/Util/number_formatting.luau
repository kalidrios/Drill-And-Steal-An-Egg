-- https://github.com/kalidrios

local table1 = {
	ROUNDING_MODE_NEAREST = 0,
	ROUNDING_MODE_FLOOR = 1
};
function table1.round(p1, p2) -- Line: 8
	--[[
		Upvalues:
			[1] = table1
	--]]
	if p1 ~= p1 then
		return p1;
	end
	if p1 == math.huge then
		return p1;
	end
	if p1 == -math.huge then
		return p1;
	end
	if p2 == table1.ROUNDING_MODE_FLOOR then
		if p1 >= 0 then
			p1 = math.floor(p1);
		else
			p1 = -math.floor(-p1);
		end
	elseif p1 >= 0 then
		p1 = math.floor(p1 + 0.5);
	else
		p1 = -math.floor(-p1 + 0.5);
	end
	if p1 == -0 then
		p1 = 0;
	end
	return p1;
end
function table1.comma_integer(p3) -- Line: 41
	local v1 = "";
	local v2 = #p3;
	local v3 = v2 % 3;
	local v4 = 1;
	if v3 > 0 then
		v1 = v1 .. p3:sub(v4, v4 + v3 - 1);
		v4 = v4 + v3;
	end
	while v4 <= v2 do
		if v4 > 1 then
			v1 = v1 .. ",";
		end
		v1 = v1 .. p3:sub(v4, v4 + 2);
		v4 = v4 + 3;
	end
	return v1;
end
function table1.to_string(p4, p5, p6, p7) -- Line: 63
	--[[
		Upvalues:
			[1] = table1
	--]]
	local v5, v6 = table1.format(p4, p5, p6, p7);
	if v6 then
		v5 = "-" .. v5;
	end
	return v5;
end
function table1.format(p8, p9, p10, p11) -- Line: 71
	--[[
		Upvalues:
			[1] = table1
	--]]
	p8 = tonumber(p8);
	if not p8 then
		return "nil", false;
	end
	local v7 = p8;
	local v8 = p9 and p9 or 0;
	local str1 = "";
	if p11 then
		if v7 >= 1000000000000000 then
			v7 = v7 / 1000000000000000;
			str1 = "q";
		elseif v7 >= 1000000000000 then
			v7 = v7 / 1000000000000;
			str1 = "t";
		elseif v7 >= 1000000000 then
			v7 = v7 / 1000000000;
			str1 = "b";
		elseif v7 >= 1000000 then
			v7 = v7 / 1000000;
			str1 = "m";
			v8 = math.max(2, v8);
		elseif v7 >= 1000 then
			v7 = v7 / 1000;
			str1 = "k";
			v8 = math.max(2, v8);
		end
	end
	local v9 = table1.round(v7 * math.pow(10, v8), p10);
	local v10 = false;
	local v11;
	if v9 ~= v9 then
		v11 = "NaN";
	elseif v9 == math.huge then
		v11 = "Infinity";
	elseif v9 == -math.huge then
		v10 = true;
		v11 = "Infinity";
	else
		v10 = v9 < 0;
		if v10 then
			v9 = -v9;
		end
		local v12 = tostring(v9);
		local v13 = "";
		if v8 > 0 then
			for index1 = 1, v8 do
				local v14 = "0";
				if #v12 > 0 then
					v14 = v12:sub(-1);
					v12 = v12:sub(1, -2);
				end
				if #v13 > 0 or v14 ~= "0" then
					v13 = v14 .. v13;
				end
			end
			if #v12 == 0 then
				v12 = "0";
			end
			if #v13 == 0 then
				v13 = "0";
			end
		end
		v11 = table1.comma_integer(v12);
		if #v13 > 0 and (not p11 or v13 ~= "0") then
			v11 = v11 .. "." .. v13;
		end
	end
	if #str1 > 0 then
		v11 = v11 .. str1;
	end
	return v11, v10;
end
return table1;

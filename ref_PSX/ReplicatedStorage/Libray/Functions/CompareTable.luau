-- https://github.com/kalidrios

function CompareTable(p1, p2, p3) -- Line: 16
	local type_ret = type(p1);
	local type_ret2 = type(p2);
	if type_ret ~= type_ret2 then
		return false;
	end
	if type_ret ~= "table" and type_ret2 ~= "table" then
		return p1 == p2;
	end
	local metatable = getmetatable(p1);
	if not p3 and metatable and metatable.__eq then
		return p1 == p2;
	end
	for key1, val1 in pairs(p1) do
		local v1 = p2[key1];
		if v1 ~= nil and CompareTable(val1, v1) then continue end
		return false;
	end
	for key2, val2 in pairs(p2) do
		local v2 = p1[key2];
		if v2 ~= nil and CompareTable(v2, val2) then continue end
		return false;
	end
	return true;
end
return CompareTable;

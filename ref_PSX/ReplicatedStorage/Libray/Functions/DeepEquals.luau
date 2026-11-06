-- https://github.com/kalidrios

function deep_equals(p1, p2, p3) -- Line: 3
	if p1 == p2 then
		return true;
	end
	if type(p1) ~= "table" or type(p2) ~= "table" then
		return false;
	end
	local v1 = p3 or {};
	if not v1[p1] then
		v1[p1] = {};
	end
	if v1[p1][p2] then
		return true;
	end
	if not v1[p2] then
		v1[p2] = {};
	end
	if v1[p2][p1] then
		return true;
	end
	v1[p1][p2] = true;
	v1[p2][p1] = true;
	local metatable = getmetatable(p1);
	if metatable and metatable.__eq then
		return p1 == p2;
	end
	local metatable2 = getmetatable(p2);
	if metatable2 and metatable.__eq then
		return p1 == p2;
	end
	if #p1 ~= #p2 then
		return false;
	end
	for key1, val1 in pairs(p1) do
		local v2 = p2[key1];
		if v2 ~= nil and deep_equals(val1, v2) then continue end
		return false;
	end
	for key2, val2 in pairs(p2) do
		local v3 = p2[key2];
		if v3 ~= nil and deep_equals(val2, v3) then continue end
		return false;
	end
	return true;
end
return deep_equals;

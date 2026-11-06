-- https://github.com/kalidrios

function deep_equals(p1, p2) -- Line: 3
	if p1 == p2 then
		return true;
	end
	if type(p1) ~= "table" or type(p2) ~= "table" then
		return false;
	end
	if #p1 ~= #p2 then
		return false;
	end
	for key1, val1 in next, p1 do
		local v1 = p2[key1];
		if v1 ~= nil and deep_equals(val1, v1) then continue end
		return false;
	end
	for key2, _ in next, p2 do
		if p1[key2] ~= nil then continue end
		return false;
	end
	return true;
end
return deep_equals;

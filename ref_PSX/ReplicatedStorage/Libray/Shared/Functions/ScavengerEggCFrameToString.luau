-- https://github.com/kalidrios

return function(p1) -- Line: 1
	local table1 = {p1:GetComponents()};
	local v1 = "";
	for key1, val1 in ipairs(table1) do
		if key1 > 3 then break end
		if key1 > 1 then
			v1 = v1 .. ",";
		end
		v1 = v1 .. tostring(val1);
	end
	return string.sub(v1, 1, 100);
end;

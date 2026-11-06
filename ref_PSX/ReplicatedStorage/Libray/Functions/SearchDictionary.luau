-- https://github.com/kalidrios

return function(p1, p2) -- Line: 14
	for key1, val1 in pairs(p1) do
		if val1 ~= p2 then continue end
		return key1;
	end
	return nil;
end;

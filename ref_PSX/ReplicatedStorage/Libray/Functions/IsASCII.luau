-- https://github.com/kalidrios

return function(p1) -- Line: 3
	assert(typeof(p1) == "string");
	for index1 = 1, #p1 do
		local byte_ret = p1:byte(index1);
		if byte_ret < 32 or byte_ret > 126 then
			return false;
		end
	end
	return true;
end;

-- https://github.com/kalidrios

local Random_new_ret = Random.new();
return function(p1) -- Line: 5
	--[[
		Upvalues:
			[1] = Random_new_ret
	--]]
	for index1 = #p1, 2, -1 do
		local NextInteger_ret = Random_new_ret:NextInteger(1, index1);
		local v1 = p1[NextInteger_ret];
		local v2 = p1[index1];
		p1[index1] = v1;
		p1[NextInteger_ret] = v2;
	end
	return p1;
end;

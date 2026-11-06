-- https://github.com/kalidrios

local Random_new_ret = Random.new();
return function(p1, p2) -- Line: 22
	--[[
		Upvalues:
			[1] = Random_new_ret
	--]]
	if p2 then
		p1 = Random_new_ret:NextNumber(p1, p2);
	end
	task.wait(p1);
end;

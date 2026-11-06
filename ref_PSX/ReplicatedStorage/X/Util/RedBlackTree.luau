-- https://github.com/kalidrios

local table1 = {};
function table1.insert(p1, p2, p3) -- Line: 13
	--[[
		Upvalues:
			[1] = table1
	--]]
	if not p1 then
		local table2 = {
			key = p2,
			value = p3,
			color = true
		};
		return table2;
	end
	if p2 < p1.key then
		p1.left = table1.insert(p1.left, p2, p3);
	elseif p1.key < p2 then
		p1.right = table1.insert(p1.right, p2, p3);
	else
		p1.value = p3;
	end
	if p1.right and p1.right.color and p1.left and p1.left.color then
		local t_right = p1.right;
		p1.right = t_right.left;
		t_right.left = p1;
		t_right.color = p1.color;
		p1.color = true;
		p1 = t_right;
	end
	if p1.left and p1.left.color then
		local t_left = p1.left;
		if t_left.left and t_left.left.color then
			p1.left = t_left.right;
			t_left.right = p1;
			t_left.color = p1.color;
			p1.color = true;
			p1 = t_left;
		end
	end
	if p1.left and p1.left.color and p1.right and p1.right.color then
		p1.left.color = false;
		p1.right.color = false;
		p1.color = true;
	end
	return p1;
end
return table1;

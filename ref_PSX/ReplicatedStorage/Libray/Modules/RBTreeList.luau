-- https://github.com/kalidrios

local table1 = {insertList = function(p1, _, p2, p3) -- insertList (Line: 19)
	if p1 then
		return p1;
	end
	local table2 = {
		color = true,
		key = p2,
		val = p3
	};
	return table2;
end};
return table1;

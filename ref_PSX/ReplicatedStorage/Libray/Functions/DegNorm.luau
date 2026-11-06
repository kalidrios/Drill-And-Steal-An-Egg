-- https://github.com/kalidrios

return function(p1) -- Line: 7
	if p1 < 0 then
		p1 = p1 + math.ceil(-p1 / 360) * 360;
	end
	return p1 % 360;
end;

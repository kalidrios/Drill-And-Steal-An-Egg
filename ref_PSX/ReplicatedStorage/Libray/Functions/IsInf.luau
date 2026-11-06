-- https://github.com/kalidrios

return function(p1) -- Line: 7
	return p1 == math.huge and true or p1 == -math.huge;
end;

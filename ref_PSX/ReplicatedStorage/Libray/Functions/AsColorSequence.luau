-- https://github.com/kalidrios

return function(p1) -- Line: 3
	if typeof(p1) == "Color3" then
		return ColorSequence.new(p1);
	end
	return p1;
end;

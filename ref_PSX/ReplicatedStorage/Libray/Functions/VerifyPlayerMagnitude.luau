-- https://github.com/kalidrios

return function(p1, p2, p3) -- Line: 9
	local v1 = p3 or 10;
	if p2 then
		local t_Character = p1.Character;
		if t_Character then
			local t_PrimaryPart = t_Character.PrimaryPart;
			if t_PrimaryPart then
				return (t_PrimaryPart.Position - p2).Magnitude < v1;
			end
		end
	end
	return false;
end;

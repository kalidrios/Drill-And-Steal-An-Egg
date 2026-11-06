-- https://github.com/kalidrios

return function(p1, p2) -- Line: 14
	if p1 and p2 then
		local t_Character = p1.Character;
		local t_Character2 = p2.Character;
		if t_Character and t_Character2 then
			local t_PrimaryPart = t_Character.PrimaryPart;
			local t_PrimaryPart2 = t_Character2.PrimaryPart;
			if t_PrimaryPart and t_PrimaryPart2 then
				return (t_PrimaryPart2.Position - t_PrimaryPart.Position).Magnitude;
			end
		end
	end
	return nil;
end;

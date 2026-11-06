-- https://github.com/kalidrios

return function(p1, p2, p3) -- Line: 16
	local t_Gravity = game.Workspace.Gravity;
	local v1 = math.atan((p3 ^ 2 + math.sqrt(p3 ^ 4 - t_Gravity * (t_Gravity * p1 ^ 2 + p2 * 2 * p3 ^ 2))) / (t_Gravity * p1));
	if v1 ~= v1 then
		v1 = math.pi / 4;
	end
	return v1;
end;

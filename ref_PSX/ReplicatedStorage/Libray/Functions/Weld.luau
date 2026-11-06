-- https://github.com/kalidrios

return function(p1, p2, p3) -- Line: 17
	local v1 = p3 and "ManualWeld" or "WeldConstraint";
	if p1.Anchored or p2.Anchored then
		v1 = "Motor6D";
	end
	local Instance_new_ret = Instance.new(v1);
	Instance_new_ret.Part0 = p1;
	Instance_new_ret.Part1 = p2;
	if v1 ~= "WeldConstraint" then
		Instance_new_ret.C0 = p1.CFrame:Inverse() * p2.CFrame;
	end
	Instance_new_ret.Parent = p1;
	return Instance_new_ret;
end;

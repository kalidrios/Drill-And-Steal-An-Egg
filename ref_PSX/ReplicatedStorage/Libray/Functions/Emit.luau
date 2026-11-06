-- https://github.com/kalidrios

return function(p1, p2, ...) -- Line: 3
	local table1 = {};
	local v1 = 0;
	for _, val1 in ipairs(table.pack(...)) do
		local Clone_ret = val1:Clone();
		Clone_ret.Enabled = false;
		if p2 then
			p2(Clone_ret);
		end
		Clone_ret.Parent = p1;
		table.insert(table1, Clone_ret);
		local v2 = Clone_ret:GetAttribute("EmitCount") or Clone_ret.Rate;
		v1 = math.max(v1, (Clone_ret:GetAttribute("EmitDelay") or 0) + Clone_ret.Lifetime.Max);
		Clone_ret:Emit(v2);
	end
	return table1, v1;
end;

-- https://github.com/kalidrios

return function(p1) -- Line: 4
	local v1 = math.huge;
	local v2 = math.huge;
	local v3 = math.huge;
	local v4 = -math.huge;
	local v5 = -math.huge;
	local v6 = -math.huge;
	for _, descendant1 in pairs(p1:GetDescendants()) do
		if not descendant1:IsA("BasePart") then continue end
		local t_CFrame = descendant1.CFrame;
		local t_Size = descendant1.Size;
		local t_X = t_Size.X;
		local t_Y = t_Size.Y;
		local t_Z = t_Size.Z;
		local GetComponents_ret1, GetComponents_ret2, GetComponents_ret3, GetComponents_ret4, GetComponents_ret5, GetComponents_ret6, GetComponents_ret7, GetComponents_ret8, GetComponents_ret9, GetComponents_ret10, GetComponents_ret11, GetComponents_ret12 = t_CFrame:GetComponents();
		local v7 = (math.abs(GetComponents_ret4) * t_X + math.abs(GetComponents_ret5) * t_Y + math.abs(GetComponents_ret6) * t_Z) * 0.5;
		local v8 = (math.abs(GetComponents_ret7) * t_X + math.abs(GetComponents_ret8) * t_Y + math.abs(GetComponents_ret9) * t_Z) * 0.5;
		local v9 = (math.abs(GetComponents_ret10) * t_X + math.abs(GetComponents_ret11) * t_Y + math.abs(GetComponents_ret12) * t_Z) * 0.5;
		if GetComponents_ret1 - v7 < v1 then
			v1 = GetComponents_ret1 - v7;
		end
		if GetComponents_ret2 - v8 < v2 then
			v2 = GetComponents_ret2 - v8;
		end
		if GetComponents_ret3 - v9 < v3 then
			v3 = GetComponents_ret3 - v9;
		end
		if v4 < GetComponents_ret1 + v7 then
			v4 = GetComponents_ret1 + v7;
		end
		if v5 < GetComponents_ret2 + v8 then
			v5 = GetComponents_ret2 + v8;
		end
		if v6 >= GetComponents_ret3 + v9 then continue end
		v6 = GetComponents_ret3 + v9;
	end
	if v1 == math.huge then
		return Vector3.new(), Vector3.new();
	end
	return Vector3.new(v1, v2, v3), Vector3.new(v4, v5, v6);
end;

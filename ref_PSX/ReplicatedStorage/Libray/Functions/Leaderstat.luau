-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

return function(p1, p2, p3)
	local v1 = p1:FindFirstChild("leaderstats");
	if not v1 then
		local v2 = Instance.new("Folder");
		v2.Name = "leaderstats";
		v2.Parent = p1;
		v1 = v2;
	end;
	assert(v1);
	local v3 = v1:FindFirstChild(p2);
	if not v3 then
		local v4 = Instance.new("IntValue");
		v4.Name = p2;
		v4.Value = p3;
		v4.Parent = v1;
		v3 = v4;
	end;
	assert(v3);
	return v3;
end;

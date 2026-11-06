-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

local l__Library__1 = game:GetService("ReplicatedStorage"):WaitForChild("Library");
local v2 = require(l__Library__1:WaitForChild("Modules").Pets);
local u1 = require(l__Library__1.Directory);
return function(p1)
	assert(p1);
	local v3 = {};
	if #p1 > 5 then
		return nil;
	end;
	for v4, v5 in ipairs(p1) do
		local v7 = u1.Pets[v5.id];
		if not v7 then
			return nil;
		end;
		if v5.l then
			return nil;
		end;
		if v7.ignoreConvert then
			return nil;
		end;
		if not v7.evolve then
			return nil;
		end;
		if not v3[v7.evolve] then
			v3[v7.evolve] = 0;
		end;
		local l__evolve__8 = v7.evolve;
		v3[l__evolve__8] = v3[l__evolve__8] + 20;	
	end;
	return v3;
end;

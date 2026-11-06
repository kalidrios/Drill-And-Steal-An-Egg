-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

local v1 = require(game:GetService("ReplicatedStorage"):WaitForChild("Library"):WaitForChild("Modules").Pets);
return function(p1, p2)
	assert(p1);
	assert(p2);
	if p1.l then
		return nil;
	end;
	if p2.ignoreConvert then
		return nil;
	end;
	if p2.rarity ~= "Event" then
		return nil;
	end;
	if p2.huge then
		return nil;
	end;
	if p2.titanic then
		return nil;
	end;
	if p2.giftEggId then
		return nil;
	end;
	if p2.extremelyRare then
		return nil;
	end;
	local v2 = 0;
	if p2.convertPoints then
		v2 = v2 + p2.convertPoints;
	elseif p2.companionEnchantLevel then
		v2 = v2 + p2.companionEnchantLevel;
	end;
	if v2 <= 0 then
		return nil;
	end;
	if p1.g then
		v2 = v2 + 1;
	end;
	if p1.r then
		v2 = v2 + 2;
	end;
	if p1.sh then
		v2 = v2 + 3;
	end;
	return v2;
end;

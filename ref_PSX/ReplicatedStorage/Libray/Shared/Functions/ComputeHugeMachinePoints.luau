-- https://github.com/kalidrios

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Library = ReplicatedStorage:WaitForChild("Library");
local _ = require(Library:WaitForChild("Modules").Pets);
return function(p1, p2) -- Line: 11
	assert(p1);
	assert(p2);
	if p1.l then
		return nil;
	end
	if p2.ignoreConvert then
		return nil;
	end
	if p2.rarity ~= "Exclusive" then
		return nil;
	end
	if p2.huge then
		return nil;
	end
	if p2.titanic then
		return nil;
	end
	if p2.giftEggId then
		return nil;
	end
	if p2.extremelyRare then
		return nil;
	end
	local v1 = 0;
	if p2.convertPoints then
		v1 = v1 + p2.convertPoints;
	elseif p2.companionEnchantLevel then
		v1 = v1 + p2.companionEnchantLevel;
	end
	if v1 <= 0 then
		return nil;
	end
	if p1.g then
		v1 = v1 + 1;
	end
	if p1.r then
		v1 = v1 + 2;
	end
	if p1.sh then
		v1 = v1 + 3;
	end
	return v1;
end;

local Library = game:GetService("ReplicatedStorage"):WaitForChild("Library")
local Signal = require(Library.Signal)
local Network = require(game:GetService("ServerScriptService"):WaitForChild("Library").Network)

local Saving = require(script.Parent.Saving)
local Directory = require(Library.Directory)
local Achievements = require(script.Parent.Achievements)
local Settings = require(script.Parent.Settings)

local v1 = {};
function v1.Get(p1, p2)
	local v2 = Saving.Get(p1);
	if not v2 then
		return;
	end;
	return v2.Upgrades[p2] or 0;
end;
function v1.Give(p3, p4, p5)
	local v3 = Saving.Get(p3);
	if not v3 then
		return;
	end;
	v3.Upgrades[p4] = p5;
	coroutine.wrap(function()
		Signal.Fire("Upgrade Bought", p3, p4, p5);
		Network.Fire("Upgrade Bought", p3, p4, p5);
	end)();
end;
function v1.Buy(p6, p7)
	local v4 = Saving.Get(p6);
	if not v4 then
		return;
	end;
	local v5 = Directory.Upgrades[p7];
	if not v5 then
		return;
	end;
	local v6 = v4.Upgrades[p7] or 0;
	if v6 == 5 then
		return false, "Already fully upgraded.";
	end;
	if v5.isHalloweenEvent and (not Settings.HalloweenEvent) then
		return false, 'The halloween event is not active.'
	end
	local v7 = v5.prices[v6 + 1];
	if not (v7 <= v4[v5.currency]) then
		return false, "Not enough " .. v5.currency;
	end;
	local l__currency__8 = v5.currency;
	v4[l__currency__8] = v4[l__currency__8] - v7;
	v1.Give(p6, p7, v6 + 1);
	if not v5.isHalloweenEvent then
		Achievements.Add(p6, "Upgrades", 1);
	end;
	coroutine.wrap(function()
		if v5.isHalloweenEvent then
			Network.FireAll("Spooky Upgrade Animation", p6);
			return;
		end;
		Network.FireAll("Upgrade Station Animation", p6);
	end)();
	return true;
end;
Network.Invoked("Buy Upgrade").OnInvoke = function(p8, p9)
	return v1.Buy(p8, p9);
end;
return v1;

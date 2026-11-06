local Library = game:GetService("ReplicatedStorage"):WaitForChild("Library")
local Signal = require(Library.Signal)
local Functions = require(Library.Functions)
local Network = require(script.Parent.Network)

local Settings = require(script.Parent.Settings)
local Saving = require(script.Parent.Saving)
local Shared = require(Library.Shared)
local Mastery = require(script.Parent.Mastery)

local v1 = {};
function v1.Give(p1, p2, p3)
	p3 = p3 or 1;
	local v2 = Saving.Get(p1);
	if not v2 then
		return;
	end;
	if not v2.BoostsInventory[p2] then
		v2.BoostsInventory[p2] = p3;
	else
		local l__BoostsInventory__3 = v2.BoostsInventory;
		l__BoostsInventory__3[p2] = l__BoostsInventory__3[p2] + p3;
	end;
	return true;
end;
function v1.Has(p4, p5)
	local v4 = Saving.Get(p4);
	if not v4 then
		return false;
	end;
	local v5 = v4.Boosts[p5];
	local v6 = false;
	if v5 ~= nil then
		v6 = v5 > 0;
	end;
	return v6;
end;
function v1.Activate(p6, p7)
	local v7 = Saving.Get(p6);
	if not v7 then
		return;
	end;
	if Shared.IsTradingPlaza then
		Network.Fire("Notification", p6, "Boosts are disabled in the Trading Plaza.", {
			color = Color3.fromRGB(255, 62, 62)
		});
		return;
	end;
	local v8 = v7.BoostsInventory[p7];
	if not v8 or not (v8 > 0) then
		return;
	end;
	local l__BoostsInventory__9 = v7.BoostsInventory;
	l__BoostsInventory__9[p7] = l__BoostsInventory__9[p7] - 1;
	if v7.BoostsInventory[p7] <= 0 then
		v7.BoostsInventory[p7] = nil;
	end;
	local v10 = Settings.BoostDurations[p7] or 1800;
	if Mastery.HasPerk(p6, "Boosts", 4) then
		v10 = v10 * 1.5;
	elseif Mastery.HasPerk(p6, "Boosts", 3) then
		v10 = v10 * 1.25;
	elseif p7 == "Triple Damage" and Mastery.HasPerk(p6, "Boosts", 1) then
		v10 = v10 * 1.25;
	elseif p7 == "Triple Coins" and Mastery.HasPerk(p6, "Boosts", 2) then
		v10 = v10 * 1.25;
	end;
	if not v7.Boosts[p7] then
		v7.Boosts[p7] = v10;
	else
		local l__Boosts__11 = v7.Boosts;
		l__Boosts__11[p7] = l__Boosts__11[p7] + v10;
	end;
	coroutine.wrap(function()
		Network.Fire("Boost Activated", p6, p7, v10);
	end)();
	Mastery.Progress(p6, "Boosts", 180);
	return true;
end;
function UpdateBoosts(p8)
	if Shared.IsTradingPlaza then
		return;
	end;
	local v12 = Saving.Get(p8);
	if not v12 then
		return;
	end;
	for v16, v17 in pairs(v12.Boosts) do
		if v17 <= 0 then
			v12.Boosts[v16] = nil;
			Network.Fire("Boost Ended", p8, v16);
		else
			v12.Boosts[v16] = v12.Boosts[v16] - 1;
			Mastery.Progress(p8, "Boosts", 1);
		end;	
	end
end;
function Track(p9)
	coroutine.wrap(function()
		while true do
			if p9 then

			else
				break;
			end;
			if p9.Parent then

			else
				break;
			end;
			UpdateBoosts(p9);
			Functions.Wait(1);		
		end;
	end)();
end;
Signal.Fired("Player Added"):Connect(function(p10)
	Track(p10);
end);
Network.Fired("Activate Boost"):Connect(function(p11, p12)
	v1.Activate(p11, p12);
end);
return v1;
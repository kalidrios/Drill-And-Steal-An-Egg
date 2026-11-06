local Fruit = { Directory = require(game.ReplicatedStorage.Library.Directory).Fruits }

local Signal = require(game.ReplicatedStorage.Library.Signal)
local Network = require(script.Parent.Network)
local Saving = require(script.Parent.Saving)
local Directory = require(game.ReplicatedStorage.Library.Directory)
local fruitModule = require(game.ReplicatedStorage.Library.Types.Fruits)
local Shared = require(game.ReplicatedStorage.Library.Shared)

function HasPerk(p1, p2)
	local v6 = Saving.Get(p1);
	local v7
	if not v6 then
		v7 = 0;
	else
		assert(v6);
		if not v6 then
			v7 = 1;
		else
			assert(v6);
			local l__Fruits__8 = v6.Mastery.Fruits;
			if l__Fruits__8 then
				v7 = Shared.MasteryXPToLevel(l__Fruits__8);
			else
				v7 = 1;
			end;
		end;
	end;
	local v9 = Directory.Mastery.Fruits.perks[p2];
	if v9 then
		if v9.level <= v7 then
			return true;
		end;
	end;
	return false;
end;

function Fruit.Get(p1, p2) 
    assert(Fruit.Directory[p2.Name] == p2);
     
    local v1 = Saving.Get(p1);
    if not v1 then
        return 0;
    end
    assert(v1);
    local v2 = v1.Fruits[p2.Name];
    if not v2 then
        return 0;
    end
	assert(v2);
	local v12 = 1;
	if HasPerk(p1, 1) then
		v12 = 1.2;
	elseif HasPerk(p1, 2) then
		v12 = 1.5;
	end;
	return fruitModule.Compute(p2, v2, Shared.ComputeSaveAge(v1), v12);
end

function Fruit.GetBonus(p5, p6)
	local v13 = 1;
	if HasPerk(p5, 3) then
		v13 = 1.3;
	end;
	return p6.Bonus((math.ceil((Fruit.Get(p5, p6))))) * v13;
end;

function Fruit.Give(player, fruit, amount)
	local save = Saving.Get(player)
	if not save then
		return
	end
	
	local v = save.Fruits[fruit]
	if not v then
		save.Fruits[fruit] = {
			Amount = math.clamp(amount,0,200),
			LastUpdated = Shared.ComputeSaveAge(save)
		}
	end
	
	v.Amount = math.clamp(v.Amount + amount,0,200)  --amount
end

Signal.Fired("Update: Fruit"):Connect(function(plyr, fruit, data)
    local save = Saving.Get(plyr)
    if not save then
        return
	end
	
	if data.Amount >= 200 then
		data.Amount = 200
	end
    
    save.Fruits[fruit] = data -- debug
end)

return Fruit

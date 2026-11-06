-- | load library | --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Library = ReplicatedStorage:WaitForChild("Library")
local ClientLibrary = Library:WaitForChild("Client")
local Modules = Library:WaitForChild("Modules")
local Types = Library:WaitForChild("Types")

-- | shared modules | --
local v3 = require(Modules.Areas)
local v4 = require(Modules.Pets)
local u2 = require(Library.Functions);

--------|     Setting     |--------

--------|    Reference    |--------

--------|    Variables    |--------

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--[[
	
	Holds fruit data types
	
--]]

local v5 = {
	Easy = {
		Name = "", 
		DisplayName = "Easy", 
		Points = 40
	}, 
	Medium = {
		Name = "", 
		DisplayName = "Medium", 
		Points = 100
	}, 
	Hard = {
		Name = "", 
		DisplayName = "Hard", 
		Points = 250
	}
};
for v6, v7 in pairs(v5) do
	v7.Name = v6;
end;
function JoinPattern(p1, p2)
	local v8 = nil;
	if p2 then
		return p2;
	end;
	if typeof(p1) == "table" then

	else
		return p1;
	end;
	local v9 = #p1;
	if v9 == 0 then
		return "";
	end;
	if v9 == 1 then
		return p1[1];
	end;
	if v9 == 2 then
		return p1[1] .. " or " .. p1[2];
	end;
	v8 = "";
	local v10 = v9 - 1;
	local v11 = 1 - 1;
	while true do
		v8 = v8 .. p1[v11] .. ", ";
		if 0 <= 1 then
			if v11 < v10 then

			else
				break;
			end;
		elseif v10 < v11 then

		else
			break;
		end;
		v11 = v11 + 1;	
	end;
	return v8 .. "or " .. p1[v9];
end;
local u1 = {
	DefaultData = {
		v = 0
	}, 
	Tiers = v5, 
	DefaultDescriptions = {
		Coin = function(p3)
			local l__Coin__13 = p3.Coin;
			assert(l__Coin__13);
			if p3.AnyArea then
				if l__Coin__13.Pattern then
					return "Break {Amount} {Coin.Pattern}s!";
				else
					return "Break {Amount} coins!";
				end;
			end;
			if l__Coin__13.Pattern then
				return "Break {Amount} {Coin.Pattern}s in {Area.Name}!";
			end;
			return "Break {Amount} coins in {Area.Name}!";
		end, 
		Egg = function(p4)
			local l__Egg__14 = p4.Egg;
			assert(l__Egg__14);
			if p4.AnyArea then
				if l__Egg__14.Pattern then
					return "Hatch {Amount}{Egg.Attributes}{Egg.Rarity} Pets!";
				else
					return "Hatch {Amount}{Egg.Attributes}{Egg.Rarity} Pets!";
				end;
			end;
			if l__Egg__14.Pattern then
				return "Hatch {Amount}{Egg.Attributes}{Egg.Rarity} Pets from {Egg.Pattern} Eggs!";
			end;
			return "Hatch {Amount}{Egg.Attributes}{Egg.Rarity} Pets from {Area.Name} Eggs!";
		end, 
		Spend = function(p5)
			assert(p5.Spend);
			return "Spend {Amount.Short} {Spend.Pattern}!";
		end, 
		Collect = function(p6)
			assert(p6.Collect);
			return "Collect {Amount.Short} {Collect.Pattern}!";
		end
	}
};
function u1.ComputeDescription(p7, p8, p9)
	local v15 = p7.Description;
	if not v15 then
		local v16 = nil;
		if p7.Coin then
			v16 = "Coin";
		elseif p7.Egg then
			v16 = "Egg";
		elseif p7.Spend then
			v16 = "Spend";
		elseif p7.Collect then
			v16 = "Collect";
		else
			error((("Missing Quest Description: (\"%*\", \"%*\")"):format(p7.AreaId, p7.Name)));
		end;
		local v17 = u1.DefaultDescriptions[v16];
		assert(v17);
		v15 = v17(p7);
	end;
	assert(v15);
	local v18 = p9 or p7.Amount;
	local l__name__19 = p8.name;
	assert(l__name__19);
	local v20 = {
		Amount = u2.Commas(v18), 
		["Amount.Short"] = u2.NumberShorten(v18), 
		["Area.Name"] = l__name__19
	};
	local l__Coin__21 = p7.Coin;
	if l__Coin__21 then
		local l__Pattern__22 = l__Coin__21.Pattern;
		if l__Pattern__22 then
			v20["Coin.Pattern"] = JoinPattern(l__Pattern__22, l__Coin__21.PatternDescription);
		end;
	end;
	local l__Egg__23 = p7.Egg;
	if l__Egg__23 then
		local l__Pattern__24 = l__Egg__23.Pattern;
		if l__Pattern__24 then
			v20["Egg.Pattern"] = JoinPattern(l__Pattern__24, l__Egg__23.PatternDescription);
		end;
		local l__Attributes__25 = l__Egg__23.Attributes;
		local v26 = {};
		if l__Attributes__25 then
			if l__Attributes__25.sh then
				table.insert(v26, "Shiny");
			end;
			if l__Attributes__25.r then
				table.insert(v26, "Rainbow");
			elseif l__Attributes__25.g then
				table.insert(v26, "Golden");
			end;
		end;
		local v27 = table.concat(v26, " ");
		if #v26 > 0 then
			v27 = " " .. v27;
		end;
		v20["Egg.Attributes"] = v27;
		local l__Rarity__28 = l__Egg__23.Rarity;
		local v29
		if l__Rarity__28 then
			v29 = " " .. l__Rarity__28;
		else
			v29 = "";
		end;
		assert(v29);
		v20["Egg.Rarity"] = v29;
	end;
	local l__Spend__30 = p7.Spend;
	if l__Spend__30 then
		local l__Pattern__31 = l__Spend__30.Pattern;
		if l__Pattern__31 then
			v20["Spend.Pattern"] = JoinPattern(l__Pattern__31, l__Spend__30.PatternDescription);
		end;
	end;
	local l__Collect__32 = p7.Collect;
	if l__Collect__32 then
		local l__Pattern__33 = l__Collect__32.Pattern;
		if l__Pattern__33 then
			v20["Collect.Pattern"] = JoinPattern(l__Pattern__33, l__Collect__32.PatternDescription);
		end;
	end;
	return v15:gsub("{(.-)}", function(p10)
		local v34 = v20[p10];
		if not v34 then
			error((("Missing Quest Description Variable: (\"%*\", \"%*\"): %*"):format(p7.AreaId, p7.Name, p10)));
		end;
		return v34;
	end);
end;
return u1;

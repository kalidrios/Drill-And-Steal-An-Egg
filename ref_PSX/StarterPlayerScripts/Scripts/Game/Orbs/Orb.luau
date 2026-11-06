-- https://github.com/kalidrios

local m_Library = nil;
coroutine.wrap(function() -- Line: 3
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
end)();
local table1 = {
	"rbxassetid://6980747874",
	"rbxassetid://6980747719",
	"rbxassetid://6980747831",
	"rbxassetid://6980747761"
};
local _ = {
	"rbxassetid://6422183746",
	"rbxassetid://6422183796",
	"rbxassetid://6422183836",
	"rbxassetid://6422183697"
};
local _ = {
	"rbxassetid://7139322725",
	"rbxassetid://116895973336007",
	"rbxassetid://7139322637",
	"rbxassetid://7139322684"
};
local _ = {
	"rbxassetid://6980747924",
	"rbxassetid://6980747977"
};
local _ = {
	"rbxassetid://7805996163",
	"rbxassetid://7805996068"
};
local _ = {
	"rbxassetid://7805995973",
	"rbxassetid://7805996231"
};
local _ = {
	"rbxassetid://8269454300",
	"rbxassetid://8269454300"
};
local _ = {
	"rbxassetid://8269454228",
	"rbxassetid://8269454359"
};
local Random_new_ret = Random.new();
local Orbs = m_Library.Things:FindFirstChild("Orbs");
local table2 = {new = function(p1, p2, p3, p4, p5, p6) -- new (Line: 27)
	--[[
		Upvalues:
			[1] = m_Library
			[2] = table1
			[3] = Random_new_ret
			[4] = Orbs
	--]]
	assert(typeof(p1) == "string");
	assert(typeof(p2) == "string");
	assert(typeof(p3) == "number");
	assert(p3 >= 0);
	assert(m_Library.Functions.IsFinite(p3));
	assert(typeof(p4) == "Vector3");
	assert(p5 == nil and true or typeof(p5) == "table");
	assert(typeof(p6) == "number");
	local Part = Instance.new("Part");
	Part.Name = p1;
	Part.Transparency = 1;
	Part.Size = Vector3.new(0.5, 0.5, 0.5);
	Part.CFrame = CFrame.new(p4);
	Part.Anchored = true;
	Part.CanQuery = false;
	Part.CanTouch = false;
	Part.CanCollide = false;
	local Clone_ret = m_Library.Assets.Billboards.Orb:Clone();
	Clone_ret.Item.Image = m_Library.Directory.Currency[p2].ImageTiny;
	Clone_ret.Parent = Part;
	local bool1 = false;
	local vec3 = Vector3.new();
	local u1 = Vector3.new();
	local table3 = {
		id = p1,
		idTable = {[p1] = p3},
		currencyType = p2,
		amount = p3,
		isDestroyed = function() -- Line: 80
			--[[
				Upvalues:
					[1] = bool1
			--]]
			return bool1;
		end,
		destroy = function() -- Line: 84
			--[[
				Upvalues:
					[1] = bool1
					[2] = m_Library
					[3] = Part
			--]]
			if bool1 then
				return false;
			end
			bool1 = true;
			m_Library.Functions.AddDebris(Part, 0);
			return true;
		end
	};
	function table3.canCombine(p7) -- Anonymous function at line 93
		--[[
			Upvalues:
				[1] = table3
				[2] = p1
				[3] = bool1
		--]]
		if p7 == table3 then
			return false;
		end
		if table3.id == p1 then
			return false;
		end
		if p7.currencyType ~= table3.currencyType then
			return false;
		end
		if p7.isDestroyed() then
			return false;
		end
		if bool1 then
			return false;
		end
		return true;
	end
	function table3.combine(p8) -- Anonymous function at line 112
		--[[
			Upvalues:
				[1] = table3
				[2] = bool1
		--]]
		assert(table3 ~= p8);
		assert(p8.id ~= table3.id);
		assert(p8.currencyType == table3.currencyType);
		assert(not bool1);
		assert(p8.destroy());
		for key1, val1 in pairs(p8.idTable) do
			if table3.idTable[key1] ~= nil then continue end
			table3.idTable[key1] = val1;
			local v1 = table3;
			v1.amount = v1.amount + val1;
		end
	end
	task.delay(math.random() * 0.25, function() -- Line: 129
		--[[
			Upvalues:
				[1] = bool1
				[2] = m_Library
				[3] = table1
				[4] = Part
				[5] = Random_new_ret
				[6] = p5
				[7] = vec3
				[8] = u1
				[9] = Orbs
		--]]
		if not bool1 then
			m_Library.Audio.Play(table1, Part, Random_new_ret:NextNumber(0.95, 1.05), 0.4, 125);
			local v2 = p5 and p5.BlastRadius or 1;
			vec3 = Vector3.new(Random_new_ret:NextNumber(-20, 20) * v2, 50, Random_new_ret:NextNumber(-20, 20) * v2);
			u1 = Vector3.new(Random_new_ret:NextNumber(-20, 20), Random_new_ret:NextNumber(-20, 20), Random_new_ret:NextNumber(-20, 20)) * v2;
			Part.Parent = Orbs;
		end
	end);
	return table3;
end};
return table2;

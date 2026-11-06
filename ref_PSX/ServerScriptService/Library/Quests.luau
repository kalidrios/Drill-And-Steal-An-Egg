-- | load library | --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Library = ReplicatedStorage:WaitForChild("Library")
local ServerLibrary = ServerScriptService:WaitForChild("Library")
local Modules = Library:WaitForChild("Modules")
local Types = Library:WaitForChild("Types")

-- | shared modules | --
local Directory = require(Library.Directory);
local Saving = require(ServerLibrary.Saving);
local questTypes = require(Types.Quests);
local Shared = require(Library.Shared);
local Functions = require(Library.Functions);
local Network = require(ServerLibrary.Network);
local Signal = require(Library.Signal)
local Give = require(ServerLibrary.Give)

local Quests = {
	Directory = Directory.Quests
};

function Quests.Get(plr, p1, p2)
	assert(Directory.Areas[p1]);
	assert(Directory.Quests[p1][p2]);
	local save = Saving.Get(plr);
	if not save then
		return Quests.DefaultData;
	end;
	local v6 = Shared.IsHardcore and save.HardcoreQuests or save.Quests; 
	local v7 = v6[p1];
	if not v7 then
		return Quests.DefaultData;
	end;
	local v8 = v7[p2];
	if v8 then
		return v8;
	end;
	return Quests.DefaultData;
end;
function Quests.GetPoints()
	local v9 = Saving.Get();
	if not v9 then
		return 0;
	end;
	return v9["Quest Points"] or 0;
end;
Network.Fired("Quests: Update"):Connect(function(p5, p6, p7)
	local v18 = Saving.Get();
	if not v18 then
		return;
	end;
	local v19 = v18.Quests;
	if Shared.IsHardcore then
		v19 = v18.HardcoreQuests;
	end;
	local v20 = v19[p5];
	if not v20 then
		v20 = {};
		v19[p5] = v20;
	end;
	assert(v20);
	v20[p6] = p7;
end);

function Quests.Update(plr, area, quest, adding)
	assert(Directory.Areas[area]);
	assert(Directory.Quests[area][quest]);
	adding = adding or 1

	local questData = Quests.Directory[area][quest]
	if not questData then
		return nil
	end

	local questData = Quests.Get(plr, area, quest)
	if not questData then
		return nil
	end

	local tierData = questTypes.Tiers[questData.Tier]
	if not tierData then
		return nil
	end

	--- this quest has already been completed!
	if questData.c then
		return true
	end

	questData.v = questData.v + adding

	local updateData = {}
	if questData.v >= questData.Amount then
		questData.c = true
		Give.Currency(plr, tierData.Points, "Quest Points")
	end

	Network.Fire("Quests: Update", plr, area, quest, questData)
end

function Quests.Complete()

end

--function Quests.Check(plr, arg, extraData) 
--	local areasData = {}
-- 	for i, v in pairs(Quests.Directory) do
--		areasData[i] = v
--	end
--	
--	local checkQuests = {}
--	for i, v in pairs(areasData) do
--		if v[arg] then
--			if arg == "Eggs" then
--				local eggData = v.Egg
--				if eggData then
--					for index, value in pairs(eggData) do
--						local d = extraData[index]
--						if d then
--							if d == value then
--								checkQuests[i] = v
--							end
--						end
--					end
--				end
--				return
--			end
--			
--		end
--	end
--	
--	warn(checkQuests)
--end

function Quests.Check(plr, quest, extraData)
	local dir = Quests.Directory
	
	--for i, v in pairs(dir) do
	--	local v2 = i:find("2") ~= nil
	--	if v2 then
	--		
	--	end
	--end
	
	local checkedQuests = {}
	for area, areaQuestData in pairs(dir) do
		for questName, questData in pairs(areaQuestData) do
			if quest == questName then
				
			end
		end
	end
	
	return checkedQuests
end

Signal.Fired("Quests: Complete"):Connect(function(p8, p9, p10)
	assert(Directory.Quests[p9][p10]);
end);

return Quests;

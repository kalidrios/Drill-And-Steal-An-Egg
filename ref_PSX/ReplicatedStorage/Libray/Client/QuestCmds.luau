-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

local l__Library__1 = game:GetService("ReplicatedStorage"):WaitForChild("Library");
local l__Client__2 = l__Library__1:WaitForChild("Client");
local v3 = require(l__Library__1.Directory);
local v4 = {
	Directory = v3.Quests
};
local u1 = require(l__Client__2.Save);
local u2 = require(l__Library__1:WaitForChild("Types").Quests);
local u3 = require(l__Library__1.Shared);
function v4.Get(p1, p2)
	assert(v3.Areas[p1]);
	assert(v3.Quests[p1][p2]);
	local v5 = u1.Get();
	if not v5 then
		return u2.DefaultData;
	end;
	local v6 = v5.Quests;
	if u3.IsHardcore then
		v6 = v5.HardcoreQuests;
	end;
	local v7 = v6[p1];
	if not v7 then
		return u2.DefaultData;
	end;
	local v8 = v7[p2];
	if v8 then
		return v8;
	end;
	return u2.DefaultData;
end;
function v4.GetPoints()
	local v9 = u1.Get();
	if not v9 then
		return 0;
	end;
	return v9["Quest Points"] or 0;
end;
function v4.GetStock(p3)
	local v10 = v3.QuestRewards[p3];
	assert(v10);
	local v11 = v10.Stock;
	if not v11 then
		return nil;
	end;
	local v12 = u1.Get();
	if not v12 then
		return nil;
	end;
	local v13 = v12.QuestRewards[p3];
	if v13 then
		v11 = v11 - v13.Purchased;
	end;
	return v11;
end;
local u4 = require(l__Library__1.Functions);
local u5 = require(l__Client__2.Network);
function v4.RedeemReward(p4)
	local v14 = v3.QuestRewards[p4];
	assert(v14);
	local v15 = v4.GetStock(p4);
	if v15 and v15 <= 0 then
		return false, "This item is out of stock!";
	end;
	local v16 = v4.GetPoints();
	local l__Cost__17 = v14.Cost;
	if not (v16 < l__Cost__17) then
		return u5.Invoke("Quests: Redeem Reward", p4);
	end;
	return false, string.format("You need %s more %s!", u4.Commas(l__Cost__17 - v16), "Quest Points");
end;
local l__Players__6 = game:GetService("Players");
u5.Fired("Quests: Update"):Connect(function(p5, p6, p7)
	local v18 = u1.Get();
	if not v18 then
		return;
	end;
	local v19 = v18.Quests;
	if u3.IsHardcore then
		v19 = v18.HardcoreQuests;
	end;
	local v20 = v19[p5];
	if not v20 then
		v20 = {};
		v19[p5] = v20;
	end;
	assert(v20);
	v20[p6] = p7;
	u3.SignalStatUpdated(l__Players__6.LocalPlayer, "Quests");
end);
u5.Fired("Quests: Complete"):Connect(function(p8, p9, p10)
	assert(v3.Quests[p9][p10]);
end);
return v4;

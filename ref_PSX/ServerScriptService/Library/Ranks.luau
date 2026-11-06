local Library = game:GetService("ReplicatedStorage"):WaitForChild("Library")
local Signal = require(Library.Signal)
local Network = require(game:GetService("ServerScriptService"):WaitForChild("Library").Network)

local Saving = require(script.Parent.Saving)
local Gamepasses = require(script.Parent.Gamepasses)


local Directory = require(Library.Directory)
local Give = require(script.Parent.Give)
local Shared = require(Library.Shared)
local Boosts = require(script.Parent.Boosts)

local v1 = {};
function v1.Reward(p1)
	local v2 = Saving.Get(p1);
	if not v2 then
		return;
	end;
	local v3 = Directory.Ranks[v2.Rank];
	if #v3.rewards == 0 or os.time() - v2.RankTimer < v3.rewardCooldown then
		return;
	end;
	v2.RankTimer = os.time();
	for  v8, v9 in ipairs(v3.rewards) do
		local v7 = nil;
		local v10 = nil;
		v10, v7 = unpack(v9);
		if v10 == "Triple Coins Boost" then
			Boosts.Give(p1, "Triple Coins", v7);
		elseif v10 == "Super Lucky Boost" then
			Boosts.Give(p1, "Super Lucky", v7);
		elseif v10 == "Ultra Lucky Boost" then
			Boosts.Give(p1, "Ultra Lucky", v7);	
		elseif v10 == "Triple Damage Boost" then
			Boosts.Give(p1, "Triple Damage", v7);
		else
			Give.Currency(p1, v7, v10, false);
		end;	
	end;
	coroutine.wrap(function()
		Network.Fire("Rewards Redeemed", p1, v3.rewards);
	end)();
	return true;
end;
function v1.Give(p2, p3)
	local v11 = Saving.Get(p2);
	if not v11 then
		return;
	end;
	if v11.Rank ~= p3 then
		v11.Rank = p3;
		v11.RankProgress = 0;
		v11.RankTimer = 0;
		coroutine.wrap(function()
			Network.FireAll("Rank Changed", p2, p3);
		end)();
		v1.Reward(p2);
	end;
end;
local l__ID__2 = Directory.Gamepasses.VIP.ID;
local u3 = {};
function v1.Progress(p4, p5)
	local v12 = Saving.Get(p4);
	if not v12 then
		return;
	end;
	if Gamepasses.Owns(p4, l__ID__2) then
		p5 = p5 * 2;
	end;
	if v12.IsFollowingOnTwitter then
		p5 = p5 * 1.5;
	end;
	if not u3[p4] then
		u3[p4] = p5;
		return;
	end;
	u3[p4] = u3[p4] + p5;
end;
function v1.GetNextRank(p6)
	local v13 = Saving.Get(p6);
	if not v13 then
		return;
	end;
	for v14, v15 in ipairs(Shared.RankChart) do
		if v15 == v13.Rank then
			return Shared.RankChart[v14 + 1];
		end;
	end;
end;
function v1.GetRankNumber(p7)
	local v16 = Saving.Get(p7);
	if not v16 then
		return;
	end;
	local l__RankChart__17 = Shared.RankChart;
	for v18, v19 in ipairs(l__RankChart__17) do
		if v19 == v16.Rank then
			return v18;
		end;
	end;
	return #l__RankChart__17;
end;
function ApplyProgress(p8)
	local v20 = Saving.Get(p8);
	local v21 = u3[p8];
	if v21 then
		if v20 then
			u3[p8] = nil;
			v20.RankProgress = v20.RankProgress + v21;
			if Directory.Ranks[v20.Rank].needed <= v20.RankProgress then
				local v22 = v1.GetNextRank(p8);
				if v22 then
					v1.Give(p8, v22);
				end;
			end;
		end;
	end;
end;
coroutine.wrap(function()
	while true do
		for v23, v24 in ipairs(game.Players:GetPlayers()) do
			ApplyProgress(v24);
		end;
		wait(0.5);	
	end;
end)();
game.Players.PlayerRemoving:Connect(function(p9)
	if u3[p9] then
		u3[p9] = nil;
	end;
end);
Network.Invoked("Redeem Rank Rewards").OnInvoke = function(p10)
	return v1.Reward(p10);
end;
return v1;

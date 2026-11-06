local Library = game:GetService("ReplicatedStorage"):WaitForChild("Library")
local Functions = require(Library.Functions)
local Network = require(game:GetService("ServerScriptService"):WaitForChild("Library").Network)

local Saving = require(script.Parent.Saving)
local RunService = game:GetService("RunService")
local Heartbeat = function(p1) -- Heartbeat (Line: 90)
	for index1 = 1, p1 or 1 do
		RunService.Heartbeat:Wait();
	end
end
local Give = require(script.Parent.Give)
local Achievements = require(script.Parent.Achievements)


local allOrbs = {};
local u3 = {}
u3 = {
	Add = function(p1, p2, p3, p4, p5)
		local v1 = Functions.GenerateUID();
		if typeof(p2) == "CFrame" then
			p2 = p2.p2;
		end;
		local v2 = {
			plr = p1, 
			type = p3, 
			am = p4, 
			pos = p2,
			reach = p5,
		};
		allOrbs[v1] = v2;
		coroutine.wrap(function()
			wait(1200);
			u3.Remove(p1, v1);
		end)();
		coroutine.wrap(function()
			Network.Fire("Orb Added", p1, v1, v2);
		end)();
		return v1;
	end, 
	Claim = function(p5, p6)
		if not Saving.Get(p5) then
			return;
		end;
		local v3 = u3.Get(p6);
		if not v3 then
			return warn("Cannot claim orb, doesn't exist (" .. p5.Name .. ")");
		end;
		Give.Currency(p5, v3.am, v3.type, false);
		Achievements.Add(p5, "Orbs", 1);
		u3.Remove(p5, p6);
	end, 
	Remove = function(p7, p8)
		if allOrbs[p8] then
			allOrbs[p8] = nil;
			coroutine.wrap(function()
				Network.Fire("Orb Removed", p7, p8);
			end)();
		end;
	end, 
	Get = function(p9)
		return allOrbs[p9];
	end
};
Network.Fired("Claim Orb"):Connect(function(p10, p11)
	u3.Claim(p10, p11);
end);
Network.Fired("Claim Orbs"):Connect(function(p12, p13)
	for v4, v5 in pairs(p13) do
		u3.Claim(p12, v5);
	end;
end);
game.Players.PlayerRemoving:Connect(function(p14)
	local v6 = 0;
	for v10, v11 in pairs(allOrbs) do
		if (v6 + 1) % 200 == 0 then
			Heartbeat();
		end;
		if v11.plr == p14 then
			u3.Remove(p14, v10);
		end;
	end
end);
return u3;

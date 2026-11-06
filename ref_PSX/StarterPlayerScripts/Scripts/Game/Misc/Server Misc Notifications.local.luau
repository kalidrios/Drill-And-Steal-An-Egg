-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
m_Library.Network.Fired("Send Message"):Connect(function(p1) -- Line: 17
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	m_Library.Message.New(p1);
end);
m_Library.Network.Fired("Inventory Slots Given"):Connect(function(p2) -- Line: 23
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local v1 = m_Library.Player.UpperTorso();
	if v1 then
		m_Library.WorldFX.RewardImage(v1.CFrame.p, "+" .. p2 .. " Brainrot Slots", "rbxassetid://104111144013969", {time = 4});
	end
end);
m_Library.Network.Fired("Merchant Departed"):Connect(function(p3, d) -- Line: 32
	--[[
		Upvalues:
			[1] = m_Library
	--]]
    if d then return end
	m_Library.Signal.Fire("Notification", (p3 and "Mysterious Merchant" or "Traveling Merchant") .. " has departed!", {time = 3});
end);
m_Library.Network.Fired("Merchant Arrival"):Connect(function(p4) -- Line: 40
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local v2 = p4 and "Mysterious Merchant" or "Traveling Merchant";
	local v3 = p4 and "rbxassetid://787528253" or "rbxassetid://7399753346";
	m_Library.Signal.Fire("Notification", v2 .. " has arrived!", {
		color = p4 and Color3.fromRGB(60, 47, 88) or Color3.fromRGB(46, 255, 63),
		time = 4.5,
		sound = v3,
		volume = 0.75
	});
end);
m_Library.Network.Fired("Hoverboard Unlocked"):Connect(function(p5, p6) -- Line: 50
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	m_Library.Signal.Fire("Notification", m_Library.Directory.Hoverboards[p5].name .. " has been Unlocked!", {
		color = Color3.fromRGB(255, 98, 248),
		time = 4,
		sound = "rbxassetid://8323209839",
		force = p6
	});
	m_Library.Signal.Fire("Fireworks Animation", m_Library.LocalPlayer);
end);
m_Library.Network.Fired("Advanced Christmas Event"):Connect(function(p7) -- Line: 59
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local v4 = m_Library.Shared.ChristmasEventQuests2022[p7];
	m_Library.Signal.Fire("Notification", "You completed the Christmas Event Quest #" .. p7 .. "!", {
		color = Color3.fromRGB(78, 244, 252),
		sound = "rbxassetid://8344182621",
		force = true
	});
	if v4.Reward[1] ~= "Rudolph Hoverboard" then
		m_Library.Signal.Fire("Rewards Redeemed", {v4.Reward});
	end
end);
m_Library.Network.Fired("Advanced April Fools Event"):Connect(function(p8) -- Line: 70
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local v5 = m_Library.Shared.AprilFools2023Quests[p8];
	m_Library.Signal.Fire("Notification", "You completed the April Fools Event Quest #" .. p8 .. "!", {
		color = Color3.fromRGB(235, 50, 252),
		force = true
	});
	if v5.Reward[1] ~= "April Fools PS1" then
		m_Library.Signal.Fire("Rewards Redeemed", {v5.Reward});
	end
end);
m_Library.Network.Fired("Play Grinch Sound"):Connect(function(_) -- Line: 81
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	m_Library.Audio.Play("rbxassetid://8275537921", script, 1, 1);
end);

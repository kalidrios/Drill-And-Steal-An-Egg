-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local t_BoostsInfo = m_Library.Shared.BoostsInfo;
function Msgs(p1) -- Line: 31
	--[[
		Upvalues:
			[1] = m_Library
			[2] = t_BoostsInfo
	--]]
	local v1 = m_Library.Player.UpperTorso();
	local _ = v1.CFrame.p;
	for _, val1 in ipairs(p1) do
		local unpack_ret1, unpack_ret2 = unpack(val1);
		if not unpack_ret2 then
			m_Library.Signal.Fire("Notification", "You got " .. unpack_ret1 .. "!", {color = Color3.fromRGB(255, 255, 255)});
		elseif unpack_ret1 == "Triple Coins Boost" or unpack_ret1 == "Triple Coins" then
			m_Library.WorldFX.RewardImage(v1.CFrame.p, "+(x" .. unpack_ret2 .. ")", t_BoostsInfo["Triple Coins"].icon, {time = 4});
			m_Library.Signal.Fire("Notification", "You got x" .. unpack_ret2 .. " Triple Coins Boost!", {
				color = Color3.fromRGB(255, 82, 218),
				sound = "rbxassetid://8344180273"
			});
		elseif unpack_ret1 == "Super Lucky Boost" or unpack_ret1 == "Super Lucky" then
			m_Library.WorldFX.RewardImage(v1.CFrame.p, "+(x" .. unpack_ret2 .. ")", t_BoostsInfo["Super Lucky"].icon, {time = 4});
			m_Library.Signal.Fire("Notification", "You got x" .. unpack_ret2 .. " Super Lucky Boost!", {
				color = Color3.fromRGB(255, 82, 218),
				sound = "rbxassetid://8344180273"
			});
		elseif unpack_ret1 == "Ultra Lucky Boost" or unpack_ret1 == "Ultra Lucky" then
			m_Library.WorldFX.RewardImage(v1.CFrame.p, "+(x" .. unpack_ret2 .. ")", t_BoostsInfo["Ultra Lucky"].icon, {time = 4});
			m_Library.Signal.Fire("Notification", "You got x" .. unpack_ret2 .. " Ultra Lucky Boost!", {
				color = Color3.fromRGB(128, 72, 173),
				sound = "rbxassetid://8344180273"
			});
		elseif unpack_ret1 == "Triple Damage Boost" or unpack_ret1 == "Triple Damage" then
			m_Library.WorldFX.RewardImage(v1.CFrame.p, "+(x" .. unpack_ret2 .. ")", t_BoostsInfo["Triple Damage"].icon, {time = 4});
			m_Library.Signal.Fire("Notification", "You got x" .. unpack_ret2 .. " Triple Damage Boost!", {
				color = Color3.fromRGB(255, 164, 52),
				sound = "rbxassetid://8344180273"
			});
		elseif unpack_ret1 == "Triple Diamond Boost" or unpack_ret1 == "Triple Diamonds" then
			m_Library.WorldFX.RewardImage(v1.CFrame.p, "+(x" .. unpack_ret2 .. ")", t_BoostsInfo["Triple Diamonds"].icon, {time = 4});
			m_Library.Signal.Fire("Notification", "You got x" .. unpack_ret2 .. " Triple Diamonds Boost!", {
				color = Color3.fromRGB(39, 251, 255),
				sound = "rbxassetid://8344180273"
			});
		elseif unpack_ret1 == "Titanic Pet" or unpack_ret1 == "Huge Pet" then
			local v2 = m_Library.Directory.Pets[unpack_ret2];
			m_Library.WorldFX.RewardImage(v1.CFrame.p, "+Pet", v2.thumbnail, {time = 4});
			m_Library.Signal.Fire("Notification", "You got an Exclusive " .. v2.name .. "!", {
				color = Color3.fromRGB(93, 255, 255),
				sound = "rbxassetid://7255790231"
			});
		elseif unpack_ret1 == "Pet" then
			local v3 = m_Library.Directory.Pets[unpack_ret2];
			m_Library.WorldFX.RewardImage(v1.CFrame.p, "+Pet", v3.thumbnail, {time = 4});
			m_Library.Signal.Fire("Notification", "You got a " .. v3.name .. "!", {color = Color3.fromRGB(255, 255, 255)});
		elseif unpack_ret1 == "Booth" then
			m_Library.Signal.Fire("Notification", "You got a " .. unpack_ret2 .. "!", {color = Color3.fromRGB(255, 255, 255)});
		else
			m_Library.Signal.Fire("Notification", "You got " .. m_Library.Functions.NumberShorten(unpack_ret2) .. " " .. unpack_ret1 .. "!", {color = Color3.fromRGB(255, 255, 255)});
			m_Library.WorldFX.AddCurrency(v1.CFrame.p, unpack_ret2, unpack_ret1, true);
			if unpack_ret1 == "Diamonds" then
				m_Library.Signal.Fire("Rain Diamonds", 2);
			end
		end
		if #p1 <= 1 then continue end
		m_Library.Functions.Wait(0.5);
	end
end
m_Library.Network.Fired("Rewards Redeemed"):Connect(function(p2) -- Line: 93
	Msgs(p2);
end);
m_Library.Signal.Fired("Rewards Redeemed"):Connect(function(p3) -- Line: 99
	Msgs(p3);
end);

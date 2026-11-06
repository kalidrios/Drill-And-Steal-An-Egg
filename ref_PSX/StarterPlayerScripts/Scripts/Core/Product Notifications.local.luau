-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
m_Library.Network.Fired("Gamepass Bought"):Connect(function(_) -- Line: 17
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	m_Library.Audio.Play("rbxassetid://6958723296", script, 1, 1);
	m_Library.Message.New("Purchase successful! Thank you so much! :)");
end);
m_Library.Network.Fired("Product Bought"):Connect(function(_) -- Line: 23
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	m_Library.Audio.Play("rbxassetid://6958723296", script, 1, 1);
	m_Library.Message.New("Purchase successful! Thank you so much! :)");
end);
m_Library.Network.Fired("Product Failed"):Connect(function(_) -- Line: 29
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	m_Library.Message.New("Thanks you very much!!!"); -- ERROR: Purchase failed! All lost Robux will be refunded automatically. If this continues to happen let us know! Sorry :(
end);

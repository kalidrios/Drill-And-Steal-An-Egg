-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
function Update() 
	local _ = m_Library.Save.Get();
	local v1 = m_Library.WorldCmds.Get();
	local _ = m_Library.Directory.Worlds[v1];
	local bool1 = false;
	local t_BoothId = nil;
	local t_BoothData = nil;
	pcall(function() 
		local LocalPlayerTeleportData = m_Library.TeleportService:GetLocalPlayerTeleportData();
		if LocalPlayerTeleportData ~= nil and LocalPlayerTeleportData.PlaceId and LocalPlayerTeleportData.PlaceId == game.PlaceId then
			if LocalPlayerTeleportData.RestorePosition then
				bool1 = true;
			end
			if LocalPlayerTeleportData.BoothId and LocalPlayerTeleportData.BoothData then
				t_BoothId = LocalPlayerTeleportData.BoothId;
				t_BoothData = LocalPlayerTeleportData.BoothData;
			end
		end
	end);
	m_Library.WorldCmds.Load(v1, bool1);
	if t_BoothId and t_BoothData then
		print("Attempting to restore booth");
		m_Library.Network.Fire("Attempt Restore Booth", t_BoothId, t_BoothData);
	end
end
Update();
m_Library.Network.Fired("Reset Player"):Connect(Update);

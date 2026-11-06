local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
function UpdateServerClosing() 
	local v1 = game.Workspace:GetAttribute("ServerClosing") or false;
	m_Library.Variables.ServerClosing = v1;
	if v1 then
		m_Library.Signal.Fire("Server Closing", true);
	end
end
UpdateServerClosing();
game.Workspace:GetAttributeChangedSignal("ServerClosing"):Connect(function()
	UpdateServerClosing();
end);

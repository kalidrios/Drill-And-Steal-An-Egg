-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local bool1 = false;
function Prompt() -- Line: 17
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local v1 = m_Library.WorldCmds.HasArea("Cave");
	if not v1 then
		m_Library.Message.New("(The door is solid and cold)");
		return;
	end
	local v2 = m_Library.Message.New("Are you willing to spend 10b Tech Coins and 500k Diamonds to open?", true);
	if v2 then
		Buy();
	end
end
function Setup() -- Line: 31
	--[[
		Upvalues:
			[1] = m_Library
			[2] = bool1
	--]]
	local Map = m_Library.WorldCmds.GetMap();
	if Map:FindFirstChild("Interactive") then
		local t_Buy = Map:FindFirstChild("Interactive"):FindFirstChild("Diamond Party Sign").Main.SurfaceGui.Buy;
		m_Library.GUIFX.ButtonFX(t_Buy);
		t_Buy.Activated:Connect(function() -- Line: 39
			--[[
				Upvalues:
					[1] = bool1
					[2] = m_Library
			--]]
			if not bool1 then
				bool1 = true;
				local v3 = m_Library.Message.New("Do you want to spend 50b Diamonds and start a Diamond drop party?", true);
				if v3 then
					local v4 = m_Library.Message.New("Are you sure? This costs 50b Diamonds!", true);
					if v4 then
						local v5, v6 = m_Library.Network.Invoke("Diamond Party: Buy");
						if not v5 then
							m_Library.Message.New(v6 or "You cannot do this right now!");
						end
					end
				end
				bool1 = false;
			end
		end);
	end
end
m_Library.Signal.Fired("World Changed"):Connect(function(p1) -- Line: 60
	if p1 == "Trading Plaza" then
		Setup();
	end
end);

-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

local v1 = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not v1.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end;
local u1 = os.clock();
function OpenGui(p1)
	local v2 = v1.GUI[p1];
	if v1.WorldCmds.CanDoAction() then
		if v1.GUI.Inventory.Gui.Enabled then
			return;
		end;
	else
		return;
	end;
	if v2.Gui.Enabled then
		u1 = os.clock();
		return;
	end;
	if 1.25 <= os.clock() - u1 then
		v2.Gui.Enabled = true;
	end;
end;
local u2 = nil;
function Scan()
	local v3 = nil;
	if not v1.WorldCmds.CanDoAction() then
		return;
	end;
	v3 = v1.Player.UpperTorso();
	if u2 then
		if not v3 then
			return;
		end;
	else
		return;
	end;
	local v4 = RaycastParams.new();
	v4.FilterDescendantsInstances = { u2 };
	v4.FilterType = Enum.RaycastFilterType.Whitelist;
	local v5 = workspace:Raycast(v3.CFrame.p, Vector3.new(0, -1, 0).Unit * 25, v4);
	if v5 then
		local l__Instance__6 = v5.Instance;
		if l__Instance__6 then
			if l__Instance__6:GetAttribute("Exclude") then
				local v7 = l__Instance__6:GetAttribute("Exclude");
				if v7 then
					if v1.GUI[v7].Gui.Enabled then
						return;
					end;
				end;
			end;
			OpenGui(l__Instance__6:GetAttribute("PadGui"));
		end;
	end;
end;
function GetPads()
	local v8 = v1.WorldCmds.GetMap();
	if v8 then
		if v8:FindFirstChild("Interactive") then
			local v9 = {};
			for v10, v11 in ipairs(v8.Interactive:GetDescendants()) do
				if v11:GetAttribute("PadGui") then
					table.insert(v9, v11);
				end;			
			end;
			u2 = v9;
			v8.Interactive.DescendantAdded:Connect(function(p2)
				if p2:GetAttribute("PadGui") then
					table.insert(u2, p2);
				end;
			end);
		end;
	end;
end;
v1.Signal.Fired("World Changed"):Connect(function()
	u2 = nil;
	GetPads();
end);
while true do
	Scan();
	v1.Heartbeat(5);
end;

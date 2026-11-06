-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

local v1 = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not v1.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end;
local v2 = v1.Player.PlayerGui();
local v3 = {};
local u1 = {};
local l__QuestShop__2 = v1.GUI.QuestShop;
local u3 = false;
function UpdateWorld()
	for v4, v5, v6 in ipairs(u1) do
		v5:Disconnect();	
	end;
	u1 = {};
	local l__Interactive__7 = v1.WorldCmds.GetMap():FindFirstChild("Interactive");
	if l__Interactive__7 then
		local l__Quest_Signs__8 = l__Interactive__7:FindFirstChild("Quest Signs");
		if l__Quest_Signs__8 then
			for v9, v10, v11 in ipairs(l__Quest_Signs__8:GetChildren()) do
				if v1.Shared.IsHardcore then
					v10:Destroy();
				end;
				local l__SurfaceGui__12 = v10:FindFirstChild("Main"):FindFirstChild("SurfaceGui");
				local l__List__13 = l__SurfaceGui__12:FindFirstChild("List");
				for v17, v18 in pairs(v1.Directory.Quests[v10.Name])  do
					local v19 = v1.QuestCmds.Get(v18.AreaId, v17);
					local v20 = v18.Amount - v19.v;
					if v19.c then
						v20 = v18.Amount;
					end;
					local v21 = v1.Types.Quests.ComputeDescription(v18, v1.Directory.Areas[v18.AreaId], v20);
					local v22 = l__List__13:FindFirstChild(v18.Tier);
					if v22 then
						local l__Title__23 = v22:FindFirstChild("Title");
						if l__Title__23 then
							l__Title__23.Text = v21;
							if v19.c then
								l__Title__23.TextColor3 = Color3.fromHex("#6b6b6b");
							end;
						end;
						if v19.c then
							local v24 = nil;
							for v25, v26, v27 in ipairs(v22.Rating:GetChildren()) do
								if v26.Name == "ImageLabel" then
									v24 = v26:Clone();
									v26:Destroy();
								end;							
							end;
							v24.Image = "rbxassetid://6516386809";
							v24.Parent = v22.Rating;
						end;
					end;				
				end;
				local l__Button__28 = l__SurfaceGui__12:FindFirstChild("Button");
				table.insert(u1, (l__Button__28.Activated:Connect(function()
					--l__QuestShop__2.Gui.Enabled = not l__QuestShop__2.Gui.Enabled;
					v1.Message.New("disabled lol, if u want to use it use dex or smth idrc")
				end)));
				if not u3 then
					v1.GUIFX.ButtonFX(l__Button__28);
				end;			
			end;
		end;
	end;
end;
v1.Signal.Fired("Stat Changed"):Connect(function(p1)
	if p1 == "Quests" then
		UpdateWorld();
	end;
end);
v1.Signal.Fired("World Changed"):Connect(function()
	u3 = false;
	UpdateWorld();
	u3 = true;
end);

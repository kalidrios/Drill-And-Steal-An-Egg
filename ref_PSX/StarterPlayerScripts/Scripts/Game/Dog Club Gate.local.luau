-- | library | --
local _L = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not _L.Loaded do  game:GetService("RunService").Heartbeat:Wait()  end

local Gate = nil;
local t_IsHardcore = _L.Shared.IsHardcore;

function Unlock(p1) 
	Gate:SetAttribute("Unlocked", true);
	local Lock = Gate:FindFirstChild("Lock");
	if Lock and p1 then
		_L.Audio.Play("rbxassetid://7751703357", Lock.CFrame.p, 0.8, 1, 150);
		_L.WorldFX.ModelFlash(Lock, 0.3);
		Lock:Destroy();
		return;
	end
	if Lock then
		Lock:Destroy();
	end
end
function IsUnlocked() 
	local v1 = _L.Save.Get();
	if v1 then
		return t_IsHardcore and _L.Functions.SearchDictionary(v1.Hardcore.AreasUnlocked, "Dog Club") or not t_IsHardcore and _L.Functions.SearchDictionary(v1.AreasUnlocked, "Dog Club");
	end
	return false;
end
function Teleport()  
	local Gate2 = _L.WorldCmds.GetMap().Teleports:FindFirstChild("Dog Club");
	if Gate2 then
		local v6 = _L.Player.Character();
		local v7 = _L.Player.Humanoid();
		_L.GUIFX.Flash(0.25, 0.75, Color3.new(255, 255, 255));
		_L.Variables.Teleporting = true;
		_L.Signal.Fire("Teleporting");
		_L.Functions.Wait(0.25);
		v6:SetPrimaryPartCFrame(Gate2.CFrame + Vector3.new(0, v7.HipHeight + 1, 0));
		_L.Audio.Play("rbxassetid://7210953148", script, 1, 1);
		_L.Network.Fire("Performed Teleport", "Dog Club");
		_L.Functions.Wait(0.25);
		_L.Variables.Teleporting = false;
		return;
	end
	_L.Message.New("Something went wrong. Try again!");
end
function Buy() 
	local v2, v3 = _L.Network.Invoke("Buy Area", "Dog Club");
	if not v2 then
		_L.Message.New(v3 or "Error");
		return;
	end
	Unlock(true);
end
function PromptBuy() 
	local v4 = _L.WorldCmds.HasArea("Dog Mansion");
	if not v4 then
		return;
	end
	local v5 = _L.Message.New("Are you sure you want to buy this area for 5t Cartoon Coins?", true);
	if v5 then
		Buy();
	end
end
function Setup() 
	local Map = _L.WorldCmds.GetMap();
	if Map:FindFirstChild("Gates") then
		Gate = Map.Gates:FindFirstChild("Dog Club");
		if Gate then
			if IsUnlocked() then
				Unlock(false);
				local v8, _ = _L.Interact.Add(Gate.PrimaryPart, {
					dist = 12,
					label = "Enter Dog Club!"
				});
				if v8 then
					v8:Connect(function() 
						Teleport();
					end);
				end
			else
				local v9, _ = _L.Interact.Add(Gate.PrimaryPart, {
					dist = 12,
					label = [[Enter Dog Club!]]
				});
				if v9 then
					v9:Connect(function()  
						if Gate:GetAttribute("Unlocked") then
							Teleport();
							return;
						end
						PromptBuy();
					end);
				end
			end
		end
	end
end

_L.Signal.Fired("World Changed"):Connect(function(p2)  
	if p2 == "Dog" then
		Setup();
	end
end);

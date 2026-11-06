-- Valentine Event Interactive System
-- Handles: Cozy Cove Gate (100 egg requirement), Cozy Cove Return, ValentinesReturnDoor
-- Based on Dominus Gate + Secret Cave Return Door patterns

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end

local EGG_NAME = "Valentines Egg";
local EGG_DISPLAY = "Valentines Boxes";
local EGG_REQUIRED = 100;

local t_IsHardcore = m_Library.Shared.IsHardcore;
local cozyCoveGate = nil;
local cozyCoveInteract = nil;
local cozyCoveCancel = nil;
local returnInteract = nil;
local returnCancel = nil;
local returnDoorInteract = nil;
local returnDoorCancel = nil;
local bool1 = false;

-- Utility: Get eggs opened count
function GetEggsOpened()
	local save = m_Library.Save.Get();
	if not save then return 0 end
	local eggsOpened = t_IsHardcore and save.Hardcore.EggsOpened or save.EggsOpened;
	return eggsOpened[EGG_NAME] or 0;
end

-- Utility: Teleport player to a named teleport point in current map
function TeleportToPoint(pointName)
	local Map = m_Library.WorldCmds.GetMap();
	local Teleports = Map:FindFirstChild("Teleports");
	if not Teleports then return end
	local point = Teleports:FindFirstChild(pointName);
	if not point then return end
	local player = m_Library.LocalPlayer;
	local character = player.Character or player.CharacterAdded:Wait();
	local Humanoid = character:WaitForChild("Humanoid");
	local HumanoidRootPart = character:WaitForChild("HumanoidRootPart");
	m_Library.Signal.Fire("Teleporting");
	task.wait(0.25);
	local cf = point.CFrame;
	character:PivotTo(cf + cf.UpVector * (Humanoid.HipHeight + HumanoidRootPart.Size.Y / 2));
	m_Library.Audio.Play("rbxassetid://7009904957", script, 1, 0.4);
	task.wait(0.25);
end

---------------------------------------
-- A. Cozy Cove Gate (100 egg check)
---------------------------------------
function IsUnlocked()
	return GetEggsOpened() >= EGG_REQUIRED;
end

function UnlockCozyCove()
	if cozyCoveGate then
		local Lock = cozyCoveGate:FindFirstChild("Lock");
		if Lock then
			m_Library.Audio.Play("rbxassetid://7751703357", Lock.CFrame, 0.8, 1, 150);
			m_Library.WorldFX.ModelFlash(Lock, 0.5);
			Lock:Destroy();
		end
	end
end

function OnCozyCoveInteract()
	if not m_Library.WorldCmds.CanDoAction() then return end
	if IsUnlocked() then
		-- Already met the requirement, try to unlock on server (grants area if not already owned)
		local success, err = m_Library.Network.Invoke("Unlock Cozy Cove");
		if success then
			UnlockCozyCove();
			TeleportToPoint("Cozy Cove");
		else
			m_Library.Message.New(err or "Something went wrong.");
		end
	else
		local remaining = EGG_REQUIRED - GetEggsOpened();
		m_Library.Message.New("You need to open " .. remaining .. " more " .. EGG_DISPLAY .. " to unlock Cozy Cove!");
	end
end

function SetupCozyCoveGate()
	local Map = m_Library.WorldCmds.GetMap();
	if not Map:FindFirstChild("Interactive") then return end
	cozyCoveGate = Map.Interactive:FindFirstChild("Cozy Cove");
	if not cozyCoveGate then return end

	-- If already unlocked, destroy the lock
	if IsUnlocked() then
		UnlockCozyCove();
	end

	local center = cozyCoveGate:FindFirstChild("Center");
	if not center then return end
	cozyCoveInteract, cozyCoveCancel = m_Library.Interact.Add(center, {dist = 15});
	cozyCoveInteract:Connect(function()
		if not bool1 then
			bool1 = true;
			OnCozyCoveInteract();
			bool1 = false;
		end
	end);
end

---------------------------------------
-- B. Cozy Cove Return (back to Valentines area)
---------------------------------------
function SetupCozyCoveReturn()
	local Map = m_Library.WorldCmds.GetMap();
	local Areas = Map:FindFirstChild("Areas");
	if not Areas then return end
	local CozyCoveArea = Areas:FindFirstChild("Cozy Cove");
	if not CozyCoveArea then return end
	local CozyCoveInner = CozyCoveArea:FindFirstChild("Cozy Cove");
	if not CozyCoveInner then return end
	local center = CozyCoveInner:FindFirstChild("Center");
	if not center then return end

	returnInteract, returnCancel = m_Library.Interact.Add(center, {dist = 12});
	returnInteract:Connect(function()
		if not bool1 then
			bool1 = true;
			TeleportToPoint("Valentines");
			bool1 = false;
		end
	end);
end

---------------------------------------
-- C. ValentinesReturnDoor (back to Spawn)
---------------------------------------
function SetupReturnDoor()
	local Map = m_Library.WorldCmds.GetMap();
	if not Map:FindFirstChild("Interactive") then return end
	local returnDoor = Map.Interactive:FindFirstChild("ValentinesReturnDoor");
	if not returnDoor then return end

	returnDoorInteract, returnDoorCancel = m_Library.Interact.Add(returnDoor, {dist = 18});
	returnDoorInteract:Connect(function()
		if not bool1 then
			bool1 = true;
			m_Library.WorldCmds.Load("Spawn");
			bool1 = false;
		end
	end);
end

---------------------------------------
-- Cleanup & World Changed
---------------------------------------
function Cleanup()
	if cozyCoveCancel then cozyCoveCancel(); cozyCoveCancel = nil end
	if returnCancel then returnCancel(); returnCancel = nil end
	if returnDoorCancel then returnDoorCancel(); returnDoorCancel = nil end
	cozyCoveGate = nil;
end

m_Library.Signal.Fired("World Changed"):Connect(function(world)
	Cleanup();
	if world == "Valentines Event" then
		SetupCozyCoveGate();
		SetupCozyCoveReturn();
		SetupReturnDoor();
	end
end);

-- Update lock when eggs opened stat changes
m_Library.Signal.Fired("Stat Changed"):Connect(function(stat)
	if stat == "EggsOpened" and cozyCoveGate then
		if IsUnlocked() then
			UnlockCozyCove();
		end
	end
end);

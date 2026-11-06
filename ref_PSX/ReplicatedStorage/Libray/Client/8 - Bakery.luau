-- Decompiled with Synapse X v3.0 | https://github.com/synllc
-- make it look sexy if you want all im doing is fixing stuff yes yes
--[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⣿⣿⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⣿⣿⣿⣿⣿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⣿⣿⣿⣿⣿⣿⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⣿⣿⣿⣿⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣿⣿⣿⣿⣿⣿⣿⣿⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⣿⣿⣿⣿⣿⣿⣿⣿⡿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣾⣿⣿⣿⣿⣿⣿⣿⣿⡿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣿⣿⣿⣿⣿⣿⣿⣿⣿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠘⢿⣿⣿⣿⣷⣦⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⣿⣿⣿⣿⣿⣿⣿⣿⡿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢿⣿⣿⣿⣿⣷⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠻⣿⣿⣿⣿⣿⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⡿⣿⣿⣿⣿⣿⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣿⣿⣿⣿⣿⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⣿⣿⣿⣿⣿⡇⠀⠀⢀⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣿⣿⣿⣿⣿⡇⠀⠀⢸⣿⣷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⣿⣿⣿⣿⣿⣿⣿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢿⣿⣿⣿⣿⣧⠀⠀⠘⣿⣿⣿⣷⣤⣀⣀⠀⠀⣀⣀⣤⣾⣿⣿⣿⣿⣿⣿⣿⣿⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠻⣿⣿⣿⣿⡄⠀⠀⠹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢿⣿⣿⣷⠀⠀⠀⠹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠻⣿⣿⡆⠀⠀⠀⠈⠻⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠿⠀⠀⠀⠀⠀⠀⠈⠉⠛⠻⠿⠿⠿⠟⠛⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀

	Velvet Groups rbx.lua Framework [2025] - [2025]
	Written by kalidrios - 1037898275229020250
	Developed with a VScode and Rojo.
	
	-+-+-+- SPECIFICS -+-+-+-
	_L.Pets 
	===========
		
	===========
	                                                  
                 
                     
    Thicc Games rbx.lua Framework [2022] - [2023]
    Written by Troy, Amy, Spencer, and Experilux - team@thicc.games
    Developed with keyboards and pixie dust.
    
	Not to be used for either commercial or personal use without permission. 
	

--]]
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


--------|       Top       |--------
local States = {}

--------|     Setting     |--------

--------|     Library     |--------
local _L; coroutine.wrap(function()  _L = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"))  end)()

--------|    Reference    |--------
local isServer = game:GetService("RunService"):IsServer()
local rng = Random.new()

local testingSession = false

--------|    Variables    |--------
local player = game.Players.LocalPlayer

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local Bakery = {};
Bakery.AllBakeries = {}
Bakery.VOXEL_SIZE = 4
Bakery.MAX_FLOORS = 10
function Bakery.new(p1, p2, p3) -- Line: 67
	--[[
		Upvalues:
			[1] = Bakery
			[2] = _L
	--]]
	if testingSession then
		_L.Print("DEBUG: Creating new bakery (function self)", true)
	end
	local self = setmetatable({}, {__index = Bakery});
	self.floors = {};
	self.owner = game.Players:FindFirstChild(p2);
	self.building = {walls = {}};
	self.UID = _L.Functions.GenerateUID();
	self.themeID = p3;
	self.Entities = {};
	Bakery.AllBakeries[self.UID] = self;
	self.locationPart = p1;
	self.rootPosition = self.locationPart.Position;
	self.baseOrientation = self.locationPart.Orientation.Y;
	self.baseAngle = math.rad(self.locationPart.Orientation.Y);
	self.isOpen = false;
	self.isTutorial = false;
	self.tutorial = {
		bot = nil,
		-- SIMULATOR: Tutorial state tracking
		-- Removed legacy Tycoon flags: readyToAllowStoreToOpen, hasAllowedStoreToOpen,
		-- readyForFirstWaveOfCustomers, hasAllowedFirstWaveOfCustomers, firstCustomerWave,
		-- readyForUserToCook, readyForUserToServe, readyForUserToCash, readyForUserToWash
		boostActivated = false,       -- Step 2: Player consumed a luck potion
		eggOpened = false,            -- Step 4: Player bought and opened an egg
		currentArrow = nil,           -- Reference to active TutorialArrow UI
		readyForUserToHire = false,   -- Kept: Used by TabController to block access during tutorial
		hasClickedInventory = false,  -- Legacy: May be used elsewhere
		allowedToClickBuild = false   -- Legacy: May be used elsewhere
	};
	self.playerFloorLevel = 1;
	self.customerQueue = {};
	self.container = Instance.new("Folder", workspace.__THINGS.BAKERIES);
	self.container.Name = _L.Player.Get("Name");
	self.foodContainer = Instance.new("Folder");
	self.foodContainer.Name = "Food";
	self.foodContainer.Parent = self.container;
	self.exterior = Instance.new("Folder", self.container);
	self.exterior.Name = "Exterior";
	self.animatedPath = nil;
	self.animatedPathTargetFloor = nil;
	self.animatedPathTargetX = nil;
	self.animatedPathTargetZ = nil;
	self.interactPool = {};
	self.nameCounters = setmetatable({}, {__index = function() -- __index (Line: 153)
		return 0;
	end});
	self.jukebox = nil;
	self.activeCelebrity = false;
	self.coffeeMachines = {};
	if p2 == game.Players.LocalPlayer.Name then
		self:SetRenderStatus(_L.PlayerSettings.IsEnabled("Rendering"));
	end
	return self;
end
function Bakery.FromUIDData(p4, p5, p6, p7) -- Line: 168
	--[[
		Upvalues:
			[1] = Bakery
			[2] = _L
	--]]
	if testingSession then
		_L.Print("DEBUG: FromUIData, grabbing from save", true)
	end
	local v1 = Bakery.new(p5, p6, p7);
	v1.currentDay = p4.CurrentDay;
	v1.experience = p4.Experience;
	-- SIMULATOR: Skip Floor/Entity creation if not a Tycoon game
	if p4.Floor and _L.Floor then
		for key1, val1 in ipairs(p4.Floor) do
			v1.floors[key1] = _L.Floor.new(v1, val1);
		end
		v1:CreateEntitiesFromUIDData(p4);
	end
	return v1;
end
function Bakery.Initialize(p8, p9, p10, p11) -- Line: 189
	--[[
		Upvalues:
			[1] = Bakery
			[2] = _L
	--]]
	local v2 = Bakery.FromUIDData(p8, p9, game.Players.LocalPlayer.Name, p10);
	_L.Variables.MyBakery = v2;
	if testingSession then
		_L.Print("DEBUG: Init'd bakery from UIDData, current tostring: ".. tostring(v2) or nil, true)
	end
	for _, val2 in ipairs(v2.floors) do
		val2:InitializePositionTable();
		val2:InitExterior();
	end
	local Clone_ret = workspace.__THINGS.BUTTONS.TeleportModel:Clone();
	v2.teleportPart = Clone_ret.TeleportPart;
	Clone_ret.Parent = v2.exterior;
	Clone_ret:SetPrimaryPartCFrame(CFrame.new(v2.locationPart.Position) * CFrame.Angles(0, v2.baseAngle, 0) * CFrame.new(8, -0.4, -45) * CFrame.Angles(0, 0, math.pi * 3 / 2));
	v2.teleportPart.BillboardGui.Title.Text = "Shop!";
	v2.doorCFrame = v2:GetFloorFromLevel(1).exteriorModel.TUTORIAL_SECURE_DOOR.CFrame;
	if testingSession then
		_L.Print("DEBUG: Associated Shop Teleport UI", true)
	end
	v2.isTutorial = p11;
	_L.Food.LoadOwnedRecipes();
	v2:StartAnimatedPathUpdateLoop();

	-- SIMULATOR: Start tutorial if player hasn't completed it
	if testingSession or true then -- Force print
		print("[BAKERY DEBUG] Initialize called. p11 (isTutorial):", p11, "Type:", type(p11))
	end

	if p11 then
		print("[BAKERY DEBUG] p11 is true, scheduling RunTutorial...")
		task.spawn(function()
			task.wait(1) -- Wait for everything to load
			print("[BAKERY DEBUG] Calling v2:RunTutorial() now!")
			v2:RunTutorial()
		end)
	else
		print("[BAKERY DEBUG] p11 is false/nil, Tutorial SKIPPED.")
	end
end
function Bakery.InitializeOtherPlayer(p12, p13, p14, p15, p16) -- Line: 229
	--[[
		Upvalues:
			[1] = Bakery
			[2] = player
			[3] = _L
	--]]
	if testingSession then
		_L.Print("DEBUG: Initalizing a different player's bakery", true)
	end
	local u1 = Bakery.FromUIDData(p12, p13, p14.Name, p15);
	local coroutine_wrap_ret2 = coroutine.wrap(function() -- Line: 233
		--[[
			Upvalues:
				[1] = u1
				[2] = player
				[3] = _L
		--]]
		for _, val51 in ipairs(u1.floors) do
			val51:InitExterior();
			wait(0.75);
		end
		pcall(function() -- Line: 240
			--[[
				Upvalues:
					[1] = u1
					[2] = player
					[3] = _L
			--]]
			local u6 = u1.floors[1];
			if u6 then
				local bool1 = false;
				u6.exteriorModel.BLACKLIST_DOOR.Touched:Connect(function(hit) -- Line: 244
					--[[
						Upvalues:
							[1] = u6
							[2] = player
							[3] = bool1
							[4] = _L
					--]]
					if not u6.exteriorModel.BLACKLIST_DOOR.CanCollide then return end
					if player.Character ~= hit.Parent then return end
					if bool1 then return end
					bool1 = true;
					local coroutine_wrap_ret = coroutine.wrap(function() -- Line: 258
						--[[
							Upvalues:
								[1] = bool1
						--]]
						wait(2);
						bool1 = false;
					end);
					coroutine_wrap_ret();
					_L.Message.New("The Restaurant owner has blacklisted you from entering.");
				end);
			end
		end);
	end);
	coroutine_wrap_ret2();
	return u1;
end
function Bakery.GetBakeryByUID(p17) -- Line: 275
	--[[
		Upvalues:
			[1] = Bakery
	--]]
	return Bakery.AllBakeries[p17];
end
function Bakery.GetBakeryByOwner(p18) -- Line: 280
	--[[
		Upvalues:
			[1] = Bakery
	--]]
	for _, val3 in pairs(Bakery.AllBakeries) do
		if val3.owner ~= p18 then continue end
		return val3;
	end
	return nil;
end
function Bakery.IsMyBakery(p19) -- Line: 290
	return game.Players.LocalPlayer == p19.owner;
end
function Bakery.ChangeTheme(p20, p21) -- Line: 295
	p20.themeID = p21;
	for _, val4 in ipairs(p20.floors) do
		val4:ReInitExterior();
	end
end
function Bakery.SearchForCelebrity(p22) -- Line: 303
	for _, val5 in ipairs(p22.floors) do
		for _, val34 in ipairs(val5.customers) do
			if val34.ID ~= "20" then continue end
			return val34;
		end
	end
	return nil;
end
function Bakery.GenerateFurnitureApplianceWhitelist(p23) -- Line: 315
	local table2 = {};
	for _, val6 in ipairs(p23.floors) do
		table.insert(table2, val6.furnitureContainer);
		table.insert(table2, val6.applianceContainer);
	end
	return table2;
end
function Bakery.CountEntity(p24, p25, p26) -- Line: 325
end
function Bakery.GetOwnedCountByName(p27, p28) -- Line: 330
	return p27.nameCounters[p28];
end
function Bakery.GetBlacklistDoor(p29) -- Line: 335
	return p29.floors[1].exteriorModel:FindFirstChild("BLACKLIST_DOOR");
end
function Bakery.GetCustomerRenderStatus(p26) -- Line: 339
	return p26.doRender == true;
end
function Bakery.SetRenderStatus(p27, p28) -- Line: 344
	--[[
		Upvalues:
			[1] = _L
	--]]
	_L.GUI.RenderStatus.Gui.Enabled = p28 == false;
	if p27.doRender ~= p28 then
		for _, v28 in p27.floors do
			for _, v49 in v28.customers do
				v49:SetRenderStatus(p28);
			end
		end
	end
	p27.doRender = p28;
end
function Bakery.CreateEntitiesFromUIDDataReplication(p30, p31) -- Line: 344
	--[[
		Upvalues:
			[1] = _L
	--]]
	local u2 = 0;
	local function delayCheck() -- Line: 347
		--[[
			Upvalues:
				[1] = u2
		--]]
		u2 = u2 + 1;
		if u2 % 20 == 0 then
			wait();
		end
	end
	-- SIMULATOR: Skip Tycoon entity creation if modules don't exist
	if _L.Waiter and p31.Waiter then
		for _, val7 in pairs(p31.Waiter) do
			u2 = u2 + 1;
			if u2 % 20 == 0 then wait() end
			local FloorFromLevel5 = p30:GetFloorFromLevel(val7.FloorLevel);
			_L.Waiter.FromUIDData(p30, FloorFromLevel5, val7);
		end
	end
	if _L.Cook and p31.Cook then
		for _, val8 in pairs(p31.Cook) do
			u2 = u2 + 1;
			if u2 % 20 == 0 then wait() end
			local FloorFromLevel4 = p30:GetFloorFromLevel(val8.FloorLevel);
			_L.Cook.FromUIDData(p30, FloorFromLevel4, val8);
		end
	end
	if _L.Furniture and p31.Furniture then
		for _, val9 in pairs(p31.Furniture) do
			u2 = u2 + 1;
			if u2 % 20 == 0 then wait() end
			if _L.Directory.Furniture[val9.ID].bannedInChina and _L.China.IsSubjectToChinaPolicies() then continue end
			local FloorFromLevel3 = p30:GetFloorFromLevel(val9.FloorLevel);
			_L.Furniture.FromUIDData(p30, FloorFromLevel3, val9);
		end
	end
	if _L.Appliance and p31.Appliance then
		for _, val10 in pairs(p31.Appliance) do
			u2 = u2 + 1;
			if u2 % 20 == 0 then wait() end
			if _L.Directory.Appliance[val10.ID].bannedInChina and _L.China.IsSubjectToChinaPolicies() then continue end
			local FloorFromLevel2 = p30:GetFloorFromLevel(val10.FloorLevel);
			_L.Appliance.FromUIDData(p30, FloorFromLevel2, val10);
		end
	end
	if _L.Customer and p31.Customer then
		for _, val11 in pairs(p31.Customer) do
			u2 = u2 + 1;
			if u2 % 20 == 0 then wait() end
			local FloorFromLevel = p30:GetFloorFromLevel(val11.FloorLevel);
			_L.Customer.FromUIDData(p30, FloorFromLevel, val11);
		end
	end
	_L.Network.Fire("GetBakeryOpenStatus", p30.owner);
end
function Bakery.CreateEntitiesFromUIDData(p32, p33) -- Line: 398
	--[[
		Upvalues:
			[1] = _L
	--]]
	if testingSession then
		_L.Print("DEBUG: Checking blacklisted China items", true)
	end
	-- SIMULATOR: Skip Tycoon entity creation if modules don't exist
	if _L.Furniture and p33.Furniture then
		for _, val12 in pairs(p33.Furniture) do
			if _L.Directory.Furniture[val12.ID].bannedInChina and _L.China.IsSubjectToChinaPolicies() then continue end
			local FloorFromLevel10 = p32:GetFloorFromLevel(val12.FloorLevel);
			_L.Furniture.FromUIDData(p32, FloorFromLevel10, val12);
		end
	end
	if _L.Appliance and p33.Appliance then
		for _, val13 in pairs(p33.Appliance) do
			if _L.Directory.Appliance[val13.ID].bannedInChina and _L.China.IsSubjectToChinaPolicies() then continue end
			local FloorFromLevel9 = p32:GetFloorFromLevel(val13.FloorLevel);
			_L.Appliance.FromUIDData(p32, FloorFromLevel9, val13);
		end
	end
	if _L.Waiter and p33.Waiter then
		for _, val14 in pairs(p33.Waiter) do
			if _L.Directory.Waiter[val14.ID].bannedInChina and _L.China.IsSubjectToChinaPolicies() then continue end
			local FloorFromLevel8 = p32:GetFloorFromLevel(val14.FloorLevel);
			_L.Waiter.FromUIDData(p32, FloorFromLevel8, val14);
		end
	end
	if _L.Cook and p33.Cook then
		for _, val15 in pairs(p33.Cook) do
			if _L.Directory.Cook[val15.ID].bannedInChina and _L.China.IsSubjectToChinaPolicies() then continue end
			local FloorFromLevel7 = p32:GetFloorFromLevel(val15.FloorLevel);
			_L.Cook.FromUIDData(p32, FloorFromLevel7, val15);
		end
	end
	if _L.Customer and p33.Customer then
		for _, val16 in pairs(p33.Customer) do
			if _L.Directory.Customer[val16.ID].bannedInChina and _L.China.IsSubjectToChinaPolicies() then continue end
			local FloorFromLevel6 = p32:GetFloorFromLevel(val16.FloorLevel);
			_L.Customer.FromUIDData(p32, FloorFromLevel6, val16);
		end
	end
end
-- fixed function
function Bakery:GetPlayerVoxel()
	if not self.playerFloorLevel then
		if testingSession then
			_L.Print("DEBUG: NO PLAYERFLOORLEVEL!!", true)
		end
		return nil
	end
	local playerFloor = self.floors[self.playerFloorLevel]
	if not player.Character then
		if testingSession then
			_L.Print("DEBUG: NO CHARACTER!!", true)
		end
		return nil
	end
	local vx, vy, vz = playerFloor:VoxelFromWorldPosition(player.Character.HumanoidRootPart.Position)
	if not playerFloor:IsValidVoxel(vx, vy, vz) then
		if testingSession then
			_L.Print("DEBUG: Invalid voxel", true)
		end
		return nil
	end
	return vx, vy, vz
end

function Bakery:RunTutorial()
	print("[BAKERY-DEBUG] RunTutorial STARTED! IsTutorial:", self.isTutorial)

	-- Request tutorial boost from server (Crucial fix!)
	_L.Network.Fire("GiveTutorialBoost")

	-- init tutorial bot :D
	self.isTutorial = true
	self.tutorial.bot = _L.TutorialBot.new()

	wait(1)

	-- Helper functions
	local function showCameraAngle(posPart, lookPart)
		local camera = workspace.CurrentCamera
		camera.CameraType = Enum.CameraType.Scriptable
		camera.CFrame = CFrame.new(posPart.Position, lookPart.Position)
	end

	local function resetCameraAngle()
		local camera = workspace.CurrentCamera
		camera.CameraType = Enum.CameraType.Custom
		if player.Character and player.Character:FindFirstChild("Humanoid") then
			camera.CameraSubject = player.Character.Humanoid
		end
		if self.tutorial.bot and self.tutorial.bot.model and self.tutorial.bot.model.PrimaryPart then
			camera.CFrame = CFrame.new(player.Character.Head.CFrame.p, self.tutorial.bot.model.PrimaryPart.Position)
		end
	end

	-- Custom ArrowPing function with positioning (2D UI arrow)
	local function createArrowPing(parent, position, rotation, size)
		local TutorialArrowUI = Instance.new("ScreenGui")
		TutorialArrowUI.Name = "TutorialArrowUI"
		TutorialArrowUI.ResetOnSpawn = false
		TutorialArrowUI.ZIndexBehavior = Enum.ZIndexBehavior.Global
		TutorialArrowUI.DisplayOrder = 10
		TutorialArrowUI.Parent = player.PlayerGui

		local arrow = game.ReplicatedStorage.Assets.UI.TutorialArrow:Clone()
		arrow.Position = position or UDim2.new(0.5, 0, 0.5, 0)
		arrow.Rotation = rotation or 0
		arrow.Size = size or UDim2.new(0.075, 10, 0.05, 30)
		arrow.Parent = TutorialArrowUI

		-- Animation
		task.spawn(function()
			local originalPos = arrow.Position
			while arrow and arrow.Parent do
				local offset = math.sin(tick() * 2 * math.pi) * 6
				if rotation == -90 or rotation == 90 then
					arrow.Position = originalPos + UDim2.new(0, offset, 0, 0)
				else
					arrow.Position = originalPos + UDim2.new(0, 0, 0, offset)
				end
				_L.Services.RunService.Heartbeat:Wait()
			end
		end)

		return TutorialArrowUI
	end

	-- 3D GuideArrow (BillboardGui adorned to a workspace part)
	local function createGuideArrow(adorneePart)
		local guideArrow = game.ReplicatedStorage.Assets.UI.TutorialArrow:Clone()
		guideArrow.Adornee = adorneePart
		guideArrow.Parent = player.PlayerGui

		-- Bobbing animation via StudsOffset
		local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1, true)
		local tween = game:GetService("TweenService"):Create(guideArrow, tweenInfo, {StudsOffset = Vector3.new(0, 4, 0)})
		tween:Play()

		return guideArrow
	end

	-- Track boost activation
	local boostActivated = false
	local boostConnection = _L.Network.Fired("Boost Activated"):Connect(function(boostName)
		if boostName == "Super Lucky" or boostName == "Ultra Lucky" then
			boostActivated = true
		end
	end)

	-- Track egg opening
	local eggOpened = false
	local eggOpenCount = 0
	local eggConnection = _L.Signal.Fired("Done Opening Egg"):Connect(function()
		eggOpened = true
		eggOpenCount = eggOpenCount + 1
	end)

	-- Tutorial State
	self.tutorial.currentArrow = nil
	local currentGuideArrow = nil

	-- Helper to cleanup 2D arrow
	local function cleanupArrow()
		if self.tutorial.currentArrow then
			self.tutorial.currentArrow:Destroy()
			self.tutorial.currentArrow = nil
		end
	end

	-- Helper to cleanup 3D guide arrow
	local function cleanupGuideArrow()
		if currentGuideArrow then
			currentGuideArrow:Destroy()
			currentGuideArrow = nil
		end
	end

	-- Reference to chatbox Next button
	local chatNext = _L.GUI.Tutorial and _L.GUI.Tutorial.Main and _L.GUI.Tutorial.Main.Next

	------------------------------------------------------------------------
	-- MSG 1: Welcome
	------------------------------------------------------------------------
	self.tutorial.bot:PlayLoadedAnimation("wave")
	self.tutorial.bot:Chat("Hey, " .. player.Name .. "! Welcome to Italian Brainrot Simulator! I'll show you how things work around here.", true).finished(function()

		--------------------------------------------------------------------
		-- MSG 2: Open ExclusiveShop + Drink Luck Potion
		--------------------------------------------------------------------
		-- Arrow on ExclusiveShop button
		local exclusiveShopBtn = _L.GUI.Main and _L.GUI.Main.Bottom and _L.GUI.Main.Bottom:FindFirstChild("ExclusiveShop")
		if exclusiveShopBtn then
			self.tutorial.currentArrow = createArrowPing(
				exclusiveShopBtn,
				UDim2.new(-0.5, 0, 0.8, 0),
				-90,
				UDim2.new(0.075, 10, 0.05, 30)
			)
			self.tutorial.currentArrow.Parent = exclusiveShopBtn
		end

		self.tutorial.bot:Chat("First, let's boost your luck! Open the Exclusive Shop and drink a Luck Potion.", false)

		-- Hide Next button until boost is activated
		if chatNext then
			chatNext.Visible = false
		end

		-- Wait for boost activation
		repeat task.wait(0.1) until boostActivated

		cleanupArrow()

		if chatNext then
			chatNext.Visible = true
		end

		self.tutorial.bot:Chat("Great! The luck potion will help you get rarer Brainrots!", true).finished(function()

			----------------------------------------------------------------
			-- MSG 3: Explain Pawtokens
			----------------------------------------------------------------
			-- Arrow on Paw Tokens display
			local pawTokensDisplay = _L.GUI.Main and _L.GUI.Main.Right and _L.GUI.Main.Right:FindFirstChild("PawTokens")
			if pawTokensDisplay then
				self.tutorial.currentArrow = createArrowPing(
					pawTokensDisplay,
					UDim2.new(0.95, 0, 2.3, 0),
					180,
					UDim2.new(0.055, 10, 0.05, 30)
				)
				self.tutorial.currentArrow.Parent = pawTokensDisplay
			end

			self.tutorial.bot:Chat("You can buy more potions, exclusive boxes, and gamepasses using Paw Tokens - earned every minute you play!", true).finished(function()

				cleanupArrow()

				------------------------------------------------------------
				-- MSG 4: Mercatello / Buy First Egg
				------------------------------------------------------------
				if workspace:FindFirstChild("__CAMERA_ANGLES") then
					local angles = workspace.__CAMERA_ANGLES
					if angles:FindFirstChild("AngleOnePos") and angles:FindFirstChild("AngleOneLook") then
						showCameraAngle(angles.AngleOnePos, angles.AngleOneLook)
					end
				end

				-- Show 3D GuideArrow pointing to FirstArrow
				if workspace:FindFirstChild("__Guide_Arrow") and workspace.__Guide_Arrow:FindFirstChild("FirstArrow") then
					currentGuideArrow = createGuideArrow(workspace.__Guide_Arrow.FirstArrow)
				end

				self.tutorial.bot:Chat("This is the Mercatello, where you can buy boxes to get new Brainrots!", true).finished(function()

					resetCameraAngle()

					self.tutorial.bot:Chat("Now let's grow your team! Buy an egg - look for the $ sign that means you can afford it!", false)

					-- Hide Next until egg is opened
					if chatNext then
						chatNext.Visible = false
					end

					-- Wait for egg purchase
					repeat task.wait(0.1) until eggOpened

					cleanupGuideArrow()

					if chatNext then
						chatNext.Visible = true
					end

					self.tutorial.bot:Chat("Awesome! You got a new Brainrot!", true).finished(function()

						--------------------------------------------------------
						-- MSG 5: Teleport to Town (Piazzara)
						--------------------------------------------------------
						-- Arrow on Teleport button
						local teleportBtn = _L.GUI.Main and _L.GUI.Main.Left and _L.GUI.Main.Left.Tools and _L.GUI.Main.Left.Tools:FindFirstChild("Teleport")
						if teleportBtn then
							self.tutorial.currentArrow = createArrowPing(
								teleportBtn,
								UDim2.new(-0.5, 0, 0.8, 0),
								-90,
								UDim2.new(0.075, 10, 0.05, 30)
							)
							self.tutorial.currentArrow.Parent = teleportBtn
						end

						self.tutorial.bot:Chat("Now let's explore! Open the Teleport and go to Town!", false)

						if chatNext then
							chatNext.Visible = false
						end

						-- Wait for Teleport GUI to open
						local t_Teleport = _L.GUI.Teleport
						repeat task.wait(0.1) until t_Teleport and t_Teleport.Gui and t_Teleport.Gui.Enabled

						cleanupArrow()

						-- Arrow on Town area button in the right container
						local townBtn = t_Teleport.Gui.Frame.RightContainer.Holder:FindFirstChild("Town")
						if townBtn then
							self.tutorial.currentArrow = createArrowPing(
								townBtn,
								UDim2.new(-0.5, 0, 0.5, 0),
								-90,
								UDim2.new(0.075, 10, 0.05, 30)
							)
							self.tutorial.currentArrow.Parent = townBtn
						end

						-- Wait for player to purchase the Town teleport (or already has it)
						repeat task.wait(0.2) until _L.WorldCmds.HasTeleport("Town")

						cleanupArrow()

						-- Arrow on Close button
						local closeBtn = t_Teleport.Close
						if closeBtn then
							self.tutorial.currentArrow = createArrowPing(
								closeBtn,
								UDim2.new(0.5, 0, 1.5, 0),
								180,
								UDim2.new(0.075, 10, 0.05, 30)
							)
							self.tutorial.currentArrow.Parent = closeBtn
						end

						-- Wait for Teleport GUI to close
						repeat task.wait(0.1) until not t_Teleport.Gui.Enabled

						cleanupArrow()

						if chatNext then
							chatNext.Visible = true
						end

						----------------------------------------------------
						-- MSG 6: Collect 1500 Coins in Piazzara
						----------------------------------------------------
						self.tutorial.bot:Chat("Great, we're in Piazzara! Collect 1500 coins so you can open a Golden Box and get a Golden Brainrot! Click on coins to send your Brainrots to break them, then collect! PS: Your Brainrots are still weak, so focus on coin piles - they're faster than chests!", false)

						if chatNext then
							chatNext.Visible = false
						end

						-- Wait for 1500 coins
						repeat
							task.wait(0.5)
							local save = _L.Save.Get()
						until save and (save.Coins or 0) >= 1500

						if chatNext then
							chatNext.Visible = true
						end

						----------------------------------------------------
						-- MSG 7: Teleport to Shop (Mercatello)
						----------------------------------------------------
						-- Arrow on Teleport button
						if teleportBtn then
							self.tutorial.currentArrow = createArrowPing(
								teleportBtn,
								UDim2.new(-0.5, 0, 0.8, 0),
								-90,
								UDim2.new(0.075, 10, 0.05, 30)
							)
							self.tutorial.currentArrow.Parent = teleportBtn
						end

						self.tutorial.bot:Chat("Nice work! Now open the Teleport and head to Mercatello to buy another egg!", false)

						if chatNext then
							chatNext.Visible = false
						end

						-- Wait for Teleport GUI to open
						repeat task.wait(0.1) until t_Teleport and t_Teleport.Gui and t_Teleport.Gui.Enabled

						cleanupArrow()

						-- Arrow on Shop area button
						local shopBtn = t_Teleport.Gui.Frame.RightContainer.Holder:FindFirstChild("Shop")
						if shopBtn then
							self.tutorial.currentArrow = createArrowPing(
								shopBtn,
								UDim2.new(-0.5, 0, 0.5, 0),
								-90,
								UDim2.new(0.075, 10, 0.05, 30)
							)
							self.tutorial.currentArrow.Parent = shopBtn
						end

						-- Wait for player to purchase/have Shop teleport
						repeat task.wait(0.2) until _L.WorldCmds.HasTeleport("Shop")

						cleanupArrow()

						-- Arrow on Close button
						if closeBtn then
							self.tutorial.currentArrow = createArrowPing(
								closeBtn,
								UDim2.new(0.5, 0, 1.5, 0),
								180,
								UDim2.new(0.075, 10, 0.05, 30)
							)
							self.tutorial.currentArrow.Parent = closeBtn
						end

						-- Wait for Teleport GUI to close
						repeat task.wait(0.1) until not t_Teleport.Gui.Enabled

						cleanupArrow()

						----------------------------------------------------
						-- MSG 8: Buy Egg at SecondArrow
						----------------------------------------------------
						-- Show GuideArrow pointing to SecondArrow
						if workspace:FindFirstChild("__Guide_Arrow") and workspace.__Guide_Arrow:FindFirstChild("SecondArrow") then
							currentGuideArrow = createGuideArrow(workspace.__Guide_Arrow.SecondArrow)
						end

						self.tutorial.bot:Chat("Buy another egg to grow your team!", false)

						if chatNext then
							chatNext.Visible = false
						end

						-- Reset egg tracking for second egg
						local secondEggOpenCount = eggOpenCount
						repeat task.wait(0.1) until eggOpenCount > secondEggOpenCount

						cleanupGuideArrow()

						if chatNext then
							chatNext.Visible = true
						end

						----------------------------------------------------
						-- MSG 9: Phase 1 Farewell
						----------------------------------------------------
						self.tutorial.bot:Chat("Great job! Use your coins to buy new areas! See you soon!", true).finished(function()

							self.tutorial.bot:PlayLoadedAnimation("wave")
							wait(1.4)

							-- Hide tutorial GUI but DON'T fire FinishedTutorial yet
							self.tutorial.bot:Cleanup()
							self.isTutorial = false
							_L.GUI.Bottom.MainBottomBar.SkipTutorial.Visible = false

							-- Disconnect temporary connections
							if boostConnection then boostConnection:Disconnect() end
							if eggConnection then eggConnection:Disconnect() end

							----------------------------------------------
							-- Phase 2 Setup: Wait for Forest area unlock
							----------------------------------------------
							local phase2Connection
							phase2Connection = _L.Signal.Fired("Stat Changed"):Connect(function(stat)
								if stat ~= "AreasUnlocked" then return end
								if not _L.WorldCmds.HasArea("Forest") then return end

								-- Forest unlocked! Start Phase 2
								phase2Connection:Disconnect()

								task.spawn(function()
									self:RunTutorialPhase2()
								end)
							end)

							-- Also check immediately in case Forest was already unlocked
							if _L.WorldCmds.HasArea("Forest") then
								phase2Connection:Disconnect()
								task.spawn(function()
									self:RunTutorialPhase2()
								end)
							end
						end)
					end)
				end)
			end)
		end)
	end)

end

function Bakery:RunTutorialPhase2()
	print("[BAKERY-DEBUG] RunTutorialPhase2 STARTED!")

	-- Re-init tutorial bot
	self.isTutorial = true
	self.tutorial.bot = _L.TutorialBot.new()

	wait(1)

	-- Helper functions (same as Phase 1)
	local function showCameraAngle(posPart, lookPart)
		local camera = workspace.CurrentCamera
		camera.CameraType = Enum.CameraType.Scriptable
		camera.CFrame = CFrame.new(posPart.Position, lookPart.Position)
	end

	local function resetCameraAngle()
		local camera = workspace.CurrentCamera
		camera.CameraType = Enum.CameraType.Custom
		if player.Character and player.Character:FindFirstChild("Humanoid") then
			camera.CameraSubject = player.Character.Humanoid
		end
		if self.tutorial.bot and self.tutorial.bot.model and self.tutorial.bot.model.PrimaryPart then
			camera.CFrame = CFrame.new(player.Character.Head.CFrame.p, self.tutorial.bot.model.PrimaryPart.Position)
		end
	end

	-- 3D GuideArrow (BillboardGui adorned to a workspace part)
	local currentGuideArrow = nil
	local function createGuideArrow(adorneePart)
		local guideArrow = game.ReplicatedStorage.Assets.UI.TutorialArrow:Clone()
		guideArrow.Adornee = adorneePart
		guideArrow.Parent = player.PlayerGui

		local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1, true)
		local tween = game:GetService("TweenService"):Create(guideArrow, tweenInfo, {StudsOffset = Vector3.new(0, 4, 0)})
		tween:Play()

		return guideArrow
	end

	local function cleanupGuideArrow()
		if currentGuideArrow then
			currentGuideArrow:Destroy()
			currentGuideArrow = nil
		end
	end

	------------------------------------------------------------------------
	-- MSG 1 (Phase 2): Hey, I'm back!
	------------------------------------------------------------------------
	self.tutorial.bot:PlayLoadedAnimation("wave")
	self.tutorial.bot:Chat("Hey, I'm back! Now I'll teach you some advanced mechanics. If you were curious, you probably noticed some machines in the first area...", true).finished(function()

		--------------------------------------------------------------------
		-- MSG 2 (Phase 2): Golden Machine
		--------------------------------------------------------------------
		if workspace:FindFirstChild("__CAMERA_ANGLES") then
			local angles = workspace.__CAMERA_ANGLES
			if angles:FindFirstChild("AngleThreePos") and angles:FindFirstChild("AngleThreeLook") then
				showCameraAngle(angles.AngleThreePos, angles.AngleThreeLook)
			end
		end

		self.tutorial.bot:Chat("Use your diamonds to turn duplicate Brainrots into Golden ones!", true).finished(function()

			resetCameraAngle()

			------------------------------------------------------------
			-- MSG 3 (Phase 2): Rainbow Machine
			------------------------------------------------------------
			if workspace:FindFirstChild("__CAMERA_ANGLES") then
				local angles = workspace.__CAMERA_ANGLES
				if angles:FindFirstChild("AngleFourPos") and angles:FindFirstChild("AngleFourLook") then
					showCameraAngle(angles.AngleFourPos, angles.AngleFourLook)
				end
			end

			self.tutorial.bot:Chat("When you have many Golden Brainrots, use more diamonds to make them Rainbow!", true).finished(function()

				resetCameraAngle()

				--------------------------------------------------------
				-- MSG 4 (Phase 2): Upgrade Machine
				--------------------------------------------------------
				if workspace:FindFirstChild("__CAMERA_ANGLES") then
					local angles = workspace.__CAMERA_ANGLES
					if angles:FindFirstChild("AngleFivePos") and angles:FindFirstChild("AngleFiveLook") then
						showCameraAngle(angles.AngleFivePos, angles.AngleFiveLook)
					end
				end

				self.tutorial.bot:Chat("Finally, use diamonds on the Upgrade Machine to improve your character's speed, your Brainrots' strength, and more!", true).finished(function()

					resetCameraAngle()

					----------------------------------------------------
					-- MSG 5 (Phase 2): GuideArrow to ThirdArrow + Upgrades
					----------------------------------------------------
					-- Show GuideArrow pointing to ThirdArrow
					if workspace:FindFirstChild("__Guide_Arrow") and workspace.__Guide_Arrow:FindFirstChild("ThirdArrow") then
						currentGuideArrow = createGuideArrow(workspace.__Guide_Arrow.ThirdArrow)
					end

					local chatNext = _L.GUI.Tutorial and _L.GUI.Tutorial.Main and _L.GUI.Tutorial.Main.Next

					self.tutorial.bot:Chat("Go check if you've collected enough diamonds to upgrade something about your character!", false)

					if chatNext then
						chatNext.Visible = false
					end

					-- Wait for Upgrades GUI to be opened and then closed
					local t_Upgrades = _L.GUI.Upgrades

					-- Wait for Upgrades to open
					repeat task.wait(0.1) until t_Upgrades and t_Upgrades.Gui and t_Upgrades.Gui.Enabled

					-- Wait for Upgrades to close
					repeat task.wait(0.1) until not t_Upgrades.Gui.Enabled

					cleanupGuideArrow()

					if chatNext then
						chatNext.Visible = true
					end

					------------------------------------------------
					-- MSG 6 (Phase 2): Final Farewell
					------------------------------------------------
					self.tutorial.bot:Chat("That's it! I hope you enjoy the game. A big hug from your dev, kalidrios!", true).finished(function()

						self.tutorial.bot:PlayLoadedAnimation("wave")
						wait(1.4)

						self:CleanupTutorial()
					end)
				end)
			end)
		end)
	end)
end

function Bakery.CleanupTutorial(p36) -- Line: 692
	--[[
		Upvalues:
			[1] = _L
	--]]
	if not p36.isTutorial then return end
	p36.tutorial.bot:Cleanup();
	p36.isTutorial = false;
	_L.GUI.Bottom.MainBottomBar.SkipTutorial.Visible = false
	_L.Network.Fire("FinishedTutorial");
	p36.floors[1].exteriorModel.TUTORIAL_SECURE_DOOR.CanCollide = false;
end
function Bakery.AnimatePathFromPointToPoint(p37, p38, p39, p40, p41, p42, p43) -- Line: 706
	--[[
		Upvalues:
			[1] = _L
	--]]
	if _L.Variables.MyBakery.animatedPath then return end
	local table3 = {};
	if p41 ~= p38 then
		table.insert(table3, p38:AnimatePathFromPointToPoint(p39, p40, p38.floorTransitionXVoxel, p38.floorTransitionZVoxel));
		table.insert(table3, p41:AnimatePathFromPointToPoint(p41.floorTransitionXVoxel, p41.floorTransitionZVoxel, p42, p43));
	else
		table.insert(table3, p41:AnimatePathFromPointToPoint(p39, p40, p42, p43));
	end
	for index1 = 2, #table3 do
		for _, child35 in ipairs(table3[index1]:GetChildren()) do
			child35.Parent = table3[1];
		end
		table3[index1]:Destroy();
	end
	_L.Variables.MyBakery.animatedPath = table3[1];
	_L.Variables.MyBakery.animatedPathTargetFloor = p41;
	_L.Variables.MyBakery.animatedPathTargetX = p42;
	_L.Variables.MyBakery.animatedPathTargetZ = p43;
	_L.Signal.Fire("BakeryAnimatedPathCreated", p41.floorLevel);
	return table3[1];
end
function Bakery.AnimatePathFromEntityToEntity(p44, p45, p46) -- Line: 754
	--[[
		Upvalues:
			[1] = _L
	--]]
	_L.Variables.MyBakery.animatedPathTargetEntity = p46;
	return p44:AnimatePathFromPointToPoint(p45:GetMyFloor(), p45.xVoxel, p45.zVoxel, p46:GetMyFloor(), p46.xVoxel, p46.zVoxel);
end
function Bakery.CleanupAnimatedPath(p47) -- Line: 763
	--[[
		Upvalues:
			[1] = _L
	--]]
	if p47.animatedPath then
		p47.animatedPath = p47.animatedPath:Destroy();
		p47.animatedPathTargetFloor = nil;
		p47.animatedPathTargetEntity = nil;
		p47.animatedPathTargetX = nil;
		p47.animatedPathTargetZ = nil;
		_L.Signal.Fire("BakeryAnimatedPathRemoved");
	end
end
function Bakery.StartAnimatedPathUpdateLoop(p48) -- Line: 778
	--[[
		Upvalues:
			[1] = _L
			[2] = player
	--]]
	local coroutine_wrap_ret3 = coroutine.wrap(function() -- Line: 779
		--[[
			Upvalues:
				[1] = _L
				[2] = p48
				[3] = player
		--]]
		local v37 = nil;
		local v38 = nil;
		while true do
			_L.Services.RunService.Heartbeat:Wait();
			if p48.animatedPath and player.Character then
				local v40 = p48.floors[p48.playerFloorLevel];
				if v40 then
					local v42 = _L.Player.Get("HumanoidRootPart");
					if v42 then
						local VoxelFromWorldPosition_ret1_2, _, VoxelFromWorldPosition_ret3_2 = v40:VoxelFromWorldPosition(player.Character.HumanoidRootPart.Position);
						if (VoxelFromWorldPosition_ret1_2 ~= v37 or VoxelFromWorldPosition_ret3_2 ~= v38) and v40:IsValidVoxel(VoxelFromWorldPosition_ret1_2, 0, VoxelFromWorldPosition_ret3_2) then
							p48.animatedPath = p48.animatedPath:Destroy();
							p48:AnimatePathFromPointToPoint(v40, VoxelFromWorldPosition_ret1_2, VoxelFromWorldPosition_ret3_2, p48.animatedPathTargetFloor, p48.animatedPathTargetX, p48.animatedPathTargetZ);
							v37 = VoxelFromWorldPosition_ret1_2;
							v38 = VoxelFromWorldPosition_ret3_2;
						end
					end
				end
			end
		end
	end);
	coroutine_wrap_ret3();
end
function Bakery.ForcedToClose(p49) -- Line: 825
	for _, val17 in ipairs(p49.floors) do
		for index2 = #val17.customers, 1, -1 do
			val17.customers[index2]:ForcedToLeave();
		end
	end
	for _, val18 in ipairs(p49.floors) do
		local EntitiesFromClassAndSubClass = val18:GetEntitiesFromClassAndSubClass("Appliance", "Order Stand");
		for _, val36 in ipairs(EntitiesFromClassAndSubClass) do
			val36:ClearContents();
		end
	end
end
function Bakery.SetOpenStatus(p50, p51) -- Line: 842
	--[[
		Upvalues:
			[1] = _L
	--]]
	local v5 = p50.isOpen ~= p51;
	p50.isOpen = p51;
	if v5 and game.Players.LocalPlayer == p50.owner then
		if p50.isOpen then
			p50.customerQueue = {};
		else
			p50:ForcedToClose();
		end
	end
	for _, val19 in ipairs(p50.floors) do
		for _, val37 in pairs(val19.furniture) do
			if val37.ID ~= "51" then continue end
			val37:SetOpenSignStatus(p51);
		end
	end
	if p50:IsMyBakery() then
		_L.Replication.ForceEvent("BakeryOpenStatus", p51);
	end
end
function Bakery.GetOpenStatus(p52) -- Line: 873
	return p52.isOpen;
end
function Bakery.GetEntityByUID(p53, p54) -- Line: 878
	if not p54 then
		return nil;
	end
	return p53.Entities[p54];
end
function Bakery.GetFloorFromLevel(p55, p56) -- Line: 886
	--[[
		Upvalues:
			[1] = _L
	--]]
	if not p55.floors[p56] then
		_L.Print("CRITICAL: Floor #" .. tostring(p56) .. " does not exist.", true);
		return nil;
	end
	return p55.floors[p56];
end
function Bakery.CleanupAllData(p57) -- Line: 895
	--[[
		Upvalues:
			[1] = Bakery
	--]]
	for _, val20 in pairs(p57.Entities) do
		val20:Cleanup();
	end
	Bakery.AllBakeries[p57.UID] = nil;
end
function Bakery.GetAllOfClassName(p58, p59) -- Line: 907
	local table4 = {};
	for _, val21 in ipairs(p58.floors) do
		for _, val38 in ipairs(val21:EntityContainerFromClassName(p59)) do
			table.insert(table4, val38);
		end
	end
	return table4;
end
function Bakery.GetPlayerFloor(p60) -- Line: 918
	return p60.floors[p60.playerFloorLevel];
end
function Bakery.UpdateAnimationOptimization(p61) -- Line: 926
	for _, val22 in ipairs(p61.floors) do
		for _, val39 in ipairs(val22.customers) do
			if not val39:PlayerIsOnMyFloor() then
				val39:PauseCurrentAnimation();
				continue;
			end
			if not val39.runningAnimation then continue end
			val39:PlayLoadedAnimation(val39.runningAnimation);
		end
	end
end
function Bakery.UpdateEmojiVisibility(p62) -- Line: 944
	for _, val23 in ipairs(p62.floors) do
		for _, val40 in ipairs(val23.customers) do
			val40:SetEmojiVisible(val40:PlayerIsOnMyFloor());
		end
		for _, val41 in ipairs(val23.appliances) do
			val41:SetEmojiVisible(val41:PlayerIsOnMyFloor());
		end
	end
end
function Bakery.TeleportToFloor(p63, p64) -- Line: 956
	--[[
		Upvalues:
			[1] = _L
			[2] = player
	--]]
	if p64 < 1 or #p63.floors < p64 then return end
	local v6 = p63.floors[p63.playerFloorLevel];
	_L.Audio.Play(5226914888, player.PlayerGui);
	if p63.playerFloorLevel ~= p64 then
		p63.playerFloorLevel = p64;
		p63:UpdateAnimationOptimization();
		p63:UpdateEmojiVisibility();
	end
	local v7 = p63.floors[p64];
	local t_Character = game.Players.LocalPlayer.Character;
	local v8 = v7:WorldPositionFromVoxel(v7.floorTransitionXVoxel, 0, v7.floorTransitionZVoxel) + Vector3.new(0, 4, 0);
	t_Character:SetPrimaryPartCFrame(CFrame.new(v8));
	if p63 == _L.Variables.MyBakery then
		_L.Signal.Fire("PlayerFloorLevelChanged", p64);
		for _, val42 in ipairs(v6.customers) do
			val42:DisplayMyClothing(false);
		end
		for _, val43 in ipairs(v7.customers) do
			val43:DisplayMyClothing(true);
		end
	end
end
function Bakery.InitNPCs(p65) -- Line: 995
	for _, val24 in ipairs(p65.floors) do
		for _, val44 in ipairs(val24.cooks) do
			val44:StartActionLoop();
		end
		for _, val45 in ipairs(val24.waiters) do
			val45:StartActionLoop();
		end
	end
end
function Bakery.SeatQueuedCustomerGroup(p66, p67, p68) -- Line: 1009
	--[[
		Upvalues:
			[1] = _L
	--]]
	if not p66.isOpen then
		p66.customerQueue = {};
		return;
	end
	local v9 = nil;
	local v10 = nil;
	for key25, val25 in ipairs(p66.customerQueue) do
		for _, val46 in ipairs(val25) do
			if val46 ~= p67 then continue end
			v9 = val25;
			v10 = key25;
			break;
		end
		if v9 then break end
	end
	if not v9 then
		_L.Print("CRITICAL: Queue group not found.: " .. p67.UID, true);
		return;
	end
	table.remove(p66.customerQueue, v10);
	for key26, val26 in ipairs(p66.customerQueue) do
		for _, val47 in ipairs(val26) do
			val47.stateData.queuePosition = key26;
		end
	end
	for _, val27 in ipairs(v9) do
		val27:GoToTargetChair();
	end
end
function Bakery.UpdateCustomerQueuePositioning(p69) -- Line: 1052
	local _ = p69.floors[1];
	if #p69.customerQueue <= 1 then return end
	for key28, val28 in ipairs(p69.customerQueue) do
		for key48, val48 in ipairs(val28) do
			local GetCustomerQueueVoxel_ret1, GetCustomerQueueVoxel_ret2, GetCustomerQueueVoxel_ret3 = p69:GetCustomerQueueVoxel(key48, key28, #val28);
			val48:WalkToPointInQueue(GetCustomerQueueVoxel_ret1, GetCustomerQueueVoxel_ret2, GetCustomerQueueVoxel_ret3, function() -- Line: 1060
				--[[
					Upvalues:
						[1] = p69
						[2] = val48
				--]]
				if not p69.isOpen then
					val48:ForcedToLeave();
					return;
				end
				val48:SetCustomerState("WaitingForSeat");
			end);
		end
	end
end
function Bakery.GetCustomerQueueVoxel(p70, p71, p72, p73) -- Line: 1072
	if p73 and p73 >= 4 then
		p71 = p71 - 1;
	end
	local v11 = p70.floors[1].isBiggerPlot and 16 or 14;
	if p70.baseOrientation == 0 then

		return v11 / 2 - 1 + p71, 0, #p70.customerQueue - p72 + 1;
	end
	if p70.baseOrientation == 90 then
		if testingSession then
			_L.Print("DEBUG: BaseOrientation marked as 90", true)
		end
		return #p70.customerQueue - p72 + 1, 0, v11 / 2 + 2 - p71;
	end
	if p70.baseOrientation == 180 then
		if testingSession then
			_L.Print("DEBUG: BaseOrientation marked as 180", true)
		end
		return v11 / 2 + 2 - p71, 0, v11 - #p70.customerQueue + p72;
	end
	if testingSession then
		_L.Print("DEBUG: BaseOrientation is nil!", true)
	end
	return v11 - #p70.customerQueue + p72, 0, v11 / 2 + 2 - p71;
end
function Bakery.GetCustomerStartVoxel(p74, p75, p76) -- Line: 1094
	if p76 and p76 >= 4 then
		p75 = p75 - 1;
	end
	local v12 = p74.floors[1].isBiggerPlot and 16 or 14;
	if p74.baseOrientation == 0 then
		if testingSession then
			_L.Print("DEBUG: BaseOrientation marked as 0", true)
		end
		return v12 / 2 - 1 + p75, 0, 1;
	end
	if p74.baseOrientation == 90 then
		if testingSession then
			_L.Print("DEBUG: BaseOrientation marked as 90", true)
		end
		return 1, 0, v12 - v12 / 2 - 1 + p75 + 1;
	end
	if math.abs(p74.baseOrientation) == 180 then
		if testingSession then
			_L.Print("DEBUG: BaseOrientation marked as 180", true)
		end
		return v12 / 2 + 2 - p75, 0, v12;
	end
	if testingSession then
		_L.Print("DEBUG: BaseOrientation is nil!", true)
	end
	return v12, 0, v12 - v12 / 2 - 1 + p75 + 1;
end
function Bakery.AddCustomersToQueueIfNecessary(p77, p78, p79) -- Line: 1116
	--[[
		Upvalues:
			[1] = _L
			[2] = player
			[3] = rng
	--]]
	local function goToSeat(p87, p88) -- Line: 1119
		--[[
			Upvalues:
				[1] = _L
				[2] = player
				[3] = p77
		--]]
		if p87.state ~= "WaitingForSeat" or p87.stateData.busyWalking then
			if not p88 then
				_L.Audio.Play(5074110087, player.PlayerGui);
			end
			return;
		end
		p87:StopGroupEmoji();
		p87:CleanupGroupInteract();
		p77:SeatQueuedCustomerGroup(p87);
		p77:UpdateCustomerQueuePositioning();
		if not p88 then
			_L.Audio.Play(5074101610, player.PlayerGui);
		end
	end
	if #p77.customerQueue >= 4 then
		return 0;
	end
	local v13 = p77.floors[1];
	local GetAvailableSeatGroupings_ret1 = nil;
	local GetAvailableSeatGroupings_ret2 = nil;
	local v14 = _L.Functions.RandomIndices(_L.Variables.MyBakery.floors);
	for _, val29 in ipairs(v14) do
		GetAvailableSeatGroupings_ret1, GetAvailableSeatGroupings_ret2 = p77.floors[val29]:GetAvailableSeatGroupings();
		if GetAvailableSeatGroupings_ret1 and GetAvailableSeatGroupings_ret2 then break end
	end
	if not GetAvailableSeatGroupings_ret1 or not GetAvailableSeatGroupings_ret2 then
		if p78 then
			local bool4 = false;
			for _, val52 in ipairs(p77.floors) do
				for _, val54 in ipairs(val52.customers) do
					if val54.state == "ReadyToExit" then continue end
					val54:ForcedToLeave();
					bool4 = true;
					break;
				end
				if bool4 then break end
			end
		end
		return 0;
	end
	local table5 = {};
	local bool5 = false;
	local table6 = {};
	local table7 = {};
	local table8 = {};
	local table9 = {};
	local johnDoeOverride = {}
	local Bakery0 = {};
	local Bakery1 = {};
	local Bakery2 = {};
	local Bakery3 = {};
	local Bakery4 = {};
	local Bakery5 = {};
	local bool6 = false;
	for key30, val30 in pairs(GetAvailableSeatGroupings_ret2) do
		local v17 = GetAvailableSeatGroupings_ret1;
		local v18 = false;
		local v19 = false;
		local v20 = false;
		local v21 = false;
		local bool7 = false;
		local v22 = false;
		local v23 = false;
		local forceJohnDoeCustomer = false
		local v24 = false;
		for _, val49 in ipairs(p77.floors[val30.floorLevel]:GetEntitiesFromClassAndSubClass("Furniture", "ChristmasTree")) do
			if math.sqrt(math.pow(val49.xVoxel - val30.xVoxel, 2) + math.pow(val49.zVoxel - val30.zVoxel, 2)) >= 5.75685424949238 then continue end
			Bakery4[key30] = true;
			break;
		end
		local t_UID = nil;
		if val30.ID == "43" and v17.ID == "44" then
			v18 = true;
			t_UID = val30.UID;
		elseif val30.ID == "43" then
			v18 = rng:NextNumber() < 0.25;
			t_UID = val30.UID;
		elseif v17.ID == "44" then
			v18 = rng:NextNumber() < 0.1;
			t_UID = v17.UID;
		end
		if v18 then
			p79[key30].ID = "13";
			table6[key30] = t_UID;
		end
		if not v18 then
			if val30.ID == "98" and v17.ID == "99" then
				v19 = true;
				t_UID = val30.UID;
			elseif val30.ID == "98" then
				v19 = rng:NextNumber() < 0.25;
				t_UID = val30.UID;
			elseif v17.ID == "99" then
				v19 = rng:NextNumber() < 0.1;
				t_UID = v17.UID;
			end
			if v19 then
				if math.random() < 0.005 then
					p79[key30].ID = "25";
					table9[key30] = t_UID;
				else
					p79[key30].ID = "26";
					Bakery0[key30] = t_UID;
				end
			end
		end
		if not v18 and not v19 then
			if val30.ID == "74" and v17.ID == "75" then
				v20 = rng:NextNumber() < 0.2;
				t_UID = val30.UID;
			elseif val30.ID == "74" then
				v20 = rng:NextNumber() < 0.1;
				t_UID = val30.UID;
			elseif v17.ID == "75" then
				v20 = rng:NextNumber() < 0.05;
				t_UID = v17.UID;
			end
			if v20 then
				p79[key30].ID = "21";
				table7[key30] = t_UID;
			end
		end
		if not v18 and not v20 and not v19 then
			if val30.ID == "84" and v17.ID == "85" then
				v21 = rng:NextNumber() < 0.25;
				t_UID = val30.UID;
			elseif val30.ID == "84" then
				v21 = rng:NextNumber() < 0.1;
				t_UID = val30.UID;
			elseif v17.ID == "85" then
				v21 = rng:NextNumber() < 0.05;
				t_UID = v17.UID;
			end
			if v21 then
				p79[key30].ID = "22";
				table8[key30] = t_UID;
			end
		end
		if not v18 and not v20 and not v19 and not v21 and val30.ID == "108" and rng:NextNumber() < 0.2 then
			bool7 = true;
			t_UID = val30.UID;
			p79[key30].ID = "27";
			Bakery1[key30] = t_UID;
		end
		if not v18 and not v20 and not v19 and not v21 and not bool7 then
			if val30.ID == "110" and v17.ID == "111" then
				v22 = rng:NextNumber() < 0.25;
				t_UID = val30.UID;
			elseif val30.ID == "110" then
				v22 = rng:NextNumber() < 0.1;
				t_UID = val30.UID;
			elseif v17.ID == "111" then
				v22 = rng:NextNumber() < 0.05;
				t_UID = v17.UID;
			end
			if v22 then
				p79[key30].ID = "28";
				Bakery2[key30] = t_UID;
			end
		end
		-- John Doe Table Logic
		if not v18 then
			if val30.ID == "216" and v17.ID == "217" then
				forceJohnDoeCustomer = true
				t_UID = val30.UID
			elseif val30.ID == "216" then
				forceJohnDoeCustomer = rng:NextNumber() < 0.25
				t_UID = val30.UID
			elseif v17.ID == "217" then
				forceJohnDoeCustomer = rng:NextNumber() < 0.10
				t_UID = v17.UID
			end
			--Force John Doe
			if forceJohnDoeCustomer then
				--	if math.random() < 0.005 then
				p79[key30].ID = "29"
				johnDoeOverride[key30] = t_UID
				--	else
				--UIDBatch[i].ID = "26"
				--corruptedVIPOverride[i] = overrideUID
			end
		end
		if not v18 and not v20 and not v19 and not v21 and not bool7 and not v22 then
			if val30.ID == "118" and v17.ID == "119" then
				v23 = rng:NextNumber() < 0.2;
				t_UID = val30.UID;
			elseif val30.ID == "118" then
				v23 = rng:NextNumber() < 0.1;
				t_UID = val30.UID;
			elseif v17.ID == "119" then
				v23 = rng:NextNumber() < 0.05;
				t_UID = v17.UID;
			end
			if v23 then
				p79[key30].ID = "33";
				Bakery3[key30] = t_UID;
			end
		end
		if not v18 and not v20 and not v19 and not v21 and not bool7 and not v22 and not v23 then
			if val30.ID == "120" and v17.ID == "121" then
				v24 = rng:NextNumber() < 0.05;
				t_UID = val30.UID;
			elseif val30.ID == "120" then
				v24 = rng:NextNumber() < 0.01;
				t_UID = val30.UID;
			elseif v17.ID == "121" then
				v24 = rng:NextNumber() < 0.01;
				t_UID = v17.UID;
			end
			if v24 then
				p79[key30].ID = "32";
				Bakery5[key30] = t_UID;
			end
		end
		local GetCustomerStartVoxel_ret1, GetCustomerStartVoxel_ret2, GetCustomerStartVoxel_ret3 = p77:GetCustomerStartVoxel(key30, #GetAvailableSeatGroupings_ret2);
		local GetCustomerQueueVoxel_ret1_2, GetCustomerQueueVoxel_ret2_2, GetCustomerQueueVoxel_ret3_2 = p77:GetCustomerQueueVoxel(key30, -5, #GetAvailableSeatGroupings_ret2);
		local u5 = _L.Customer.CreateRandomCustomer(p79[key30], GetCustomerStartVoxel_ret1, GetCustomerStartVoxel_ret2, GetCustomerStartVoxel_ret3);
		local WorldPositionFromVoxel_ret = v13:WorldPositionFromVoxel(GetCustomerStartVoxel_ret1, GetCustomerStartVoxel_ret2, GetCustomerStartVoxel_ret3);
		local WorldPositionFromVoxel_ret2 = v13:WorldPositionFromVoxel(GetCustomerQueueVoxel_ret1_2, GetCustomerQueueVoxel_ret2_2, GetCustomerQueueVoxel_ret3_2);
		u5.stateData.seatUID = val30.UID;
		u5.stateData.tableUID = v17.UID;
		u5.stateData.queuePosition = #p77.customerQueue + 1;
		u5.isNearTree = Bakery4[key30] ~= nil;
		u5:SetVoxelPosition(p77:GetCustomerStartVoxel(key30, #GetAvailableSeatGroupings_ret2));
		if u5:BelongsToMyBakery() then
			if #GetAvailableSeatGroupings_ret2 % 2 == 0 then
				u5.model:SetPrimaryPartCFrame(CFrame.new(WorldPositionFromVoxel_ret + Vector3.new(0, 2, 0), WorldPositionFromVoxel_ret2));
			elseif #GetAvailableSeatGroupings_ret2 == 1 then
				u5.model:SetPrimaryPartCFrame(CFrame.new((CFrame.new(WorldPositionFromVoxel_ret + Vector3.new(0, 2, 0)) * CFrame.Angles(0, p77.baseAngle, 0) * CFrame.new(2, 0, 0)).Position, (CFrame.new(WorldPositionFromVoxel_ret2) * CFrame.Angles(0, p77.baseAngle, 0) * CFrame.new(2, 0, 0)).Position));
			elseif #GetAvailableSeatGroupings_ret2 == 3 then
				u5.model:SetPrimaryPartCFrame(CFrame.new((CFrame.new(WorldPositionFromVoxel_ret + Vector3.new(0, 2, 0)) * CFrame.Angles(0, p77.baseAngle, 0) * CFrame.new(-2, 0, 0)).Position, (CFrame.new(WorldPositionFromVoxel_ret2) * CFrame.Angles(0, p77.baseAngle, 0) * CFrame.new(-2, 0, 0)).Position));
			end
		end
		if _L.PlayerSettings.GetSetting("Notifications") == "Enabled" then
			if u5.ID == "25" and not bool5 then
				bool5 = true;
				_L.SFX.Play(5839736886, player.PlayerGui, nil, 1);
				--_L.Alert.Message("The <t=black><c=yellow>Headless Horseman<t=/><c=/> has entered your restaurant!");
			end
			if u5.ID == "29" and not bool5 then
				bool5 = true;
				_L.SFX.Play(10244075016, player.PlayerGui);
				--_L.Alert.Message("A <t=black><c=yellow>Lifeguard<t=/><c=/> has entered your restaurant!");
			end
			if u5.ID == "27" and not bool5 then
				bool5 = true;
				_L.SFX.Play(6106142958, player.PlayerGui);
				--_L.Alert.Message("<t=black><c=yellow>Santa<t=/><c=/> has entered your restaurant!");
			end
			if u5.ID == "13" and not bool5 then
				bool5 = true;
				_L.SFX.Play(5174014731, player.PlayerGui);
				--_L.Alert.Message("A <t=black><c=yellow>VIP Customer<t=/><c=/> has entered your restaurant!");
			end
			if u5.ID == "20" and not bool5 then
				bool5 = true;
				_L.SFX.Play(5278932246, player.PlayerGui);
				--_L.Alert.Message("A <t=black><c=yellow>Celebrity<t=/><c=/> has entered your restaurant!");
			end
			if u5.ID == "21" and not bool5 then
				bool5 = true;
				_L.SFX.Play(5601560215, player.PlayerGui, nil, 0.25);
				--_L.Alert.Message("A <t=black><c=yellow>Pirate<t=/><c=/> has entered your restaurant!");
			end
			if u5.ID == "22" and not bool5 then
				bool5 = true;
				_L.SFX.Play(5625433365, player.PlayerGui, nil, 0.25);
				--_L.Alert.Message("A <t=black><c=yellow>Youtuber<t=/><c=/> has entered your restaurant!");
			end
			if u5.ID == "26" and not bool5 then
				bool5 = true;
				_L.SFX.Play(5839737683, player.PlayerGui, nil, 0.25);
				--	_L.Alert.Message("A <t=black><c=yellow>Haunted VIP Customer<t=/><c=/> has entered your restaurant!");
			end
			if u5.ID == "30" and not bool5 then
				bool5 = false;
				_L.SFX.Play(12732648984, player.PlayerGui, nil, 0.25);
				--	_L.Alert.Message("An <t=black><c=purple>Dark Matter Customer<t=/><c=/> has entered your restaurant!");
			end
		end
		if u5.ID == "14" or u5.ID == "15" then
			bool6 = true;
		end
		u5.model.Parent = u5.cachedParent;
		u5:FadeTransparency(u5:GetMyTransparency());
		_L.Replication.SendEvent("CustomerCreated", u5:ToUIDData());
		if p77.isTutorial then
			table.insert(p77.tutorial.firstCustomerWave, u5);
			p77.tutorial.hasAllowedFirstWaveOfCustomers = true;
		end
		val30:SetIsOccupied(u5);
		v17:AddCustomerAtTable(u5);
		u5:Emoji("WaitingForSeat", true);
		if _L.Gamepasses.Owns(_L.Directory.Gamepasses["AutoSeatCustomers"].ID) then
			task.spawn(function() -- Line: 1484
				--[[
					Upvalues:
						[1] = goToSeat
						[2] = u5
				--]]
				task.wait(0.5);
				goToSeat(u5, true);
			end);
		else
			u5:Interact(function() -- Line: 1489
				--[[
					Upvalues:
						[1] = goToSeat
						[2] = u5
				--]]
				goToSeat(u5);
			end);
		end
		if u5.ID == "20" then
			_L.Variables.MyBakery.activeCelebrity = true;
		end
		table.insert(table5, u5);
	end
	for _, val31 in ipairs(table5) do
		val31.stateData.queueGroup = {};
		for _, val50 in ipairs(table5) do
			if val31 == val50 then continue end
			table.insert(val31.stateData.queueGroup, val50);
		end
	end
	table.insert(p77.customerQueue, table5);
	if not bool6 then
		p77:UpdateCustomerQueuePositioning();
	else
		goToSeat(table5[1], true);
	end
	return #GetAvailableSeatGroupings_ret2, table6, table7, table8, table9, Bakery0, Bakery1, Bakery2, Bakery4, Bakery3, Bakery5;
end
function Bakery.RunDay(p80) -- Line: 1528
	--[[
		Upvalues:
			[1] = _L
	--]]
	_L.Network.Fired("BakeryExperienceUpdated"):Connect(function(p89) -- Line: 1530
		--[[
			Upvalues:
				[1] = p80
		--]]
		p80.experience = p89;
	end);
end
_L.Network.Fired("SendCustomerUIDBatchToClient"):Connect(function(p81, p82) -- Line: 1535
	--[[
		Upvalues:
			[1] = _L
	--]]
	local function sendBatchResponse(p90, ...) -- Line: 1537
		--[[
			Upvalues:
				[1] = _L
				[2] = p81
		--]]
		_L.Network.Fire("SendCustomerUIDBatchToServer", p81, p90, ...);
	end
	local t_MyBakery = _L.Variables.MyBakery;
	if not t_MyBakery or not t_MyBakery.isOpen then
		return sendBatchResponse(0);
	end
	if t_MyBakery.isTutorial and not t_MyBakery.tutorial.readyForFirstWaveOfCustomers then
		sendBatchResponse(0);
		return;
	end
	if t_MyBakery.isTutorial and t_MyBakery.tutorial.hasAllowedFirstWaveOfCustomers then
		sendBatchResponse(0);
		return;
	end
	local AddCustomersToQueueIfNecessary_ret1, AddCustomersToQueueIfNecessary_ret2, AddCustomersToQueueIfNecessary_ret3, AddCustomersToQueueIfNecessary_ret4, AddCustomersToQueueIfNecessary_ret5, AddCustomersToQueueIfNecessary_ret6, AddCustomersToQueueIfNecessary_ret7, AddCustomersToQueueIfNecessary_ret8, AddCustomersToQueueIfNecessary_ret9, AddCustomersToQueueIfNecessary_ret10, AddCustomersToQueueIfNecessary_ret11 = t_MyBakery:AddCustomersToQueueIfNecessary(false, p82);
	sendBatchResponse(AddCustomersToQueueIfNecessary_ret1, AddCustomersToQueueIfNecessary_ret2, AddCustomersToQueueIfNecessary_ret3, AddCustomersToQueueIfNecessary_ret4, AddCustomersToQueueIfNecessary_ret5, AddCustomersToQueueIfNecessary_ret6, AddCustomersToQueueIfNecessary_ret7, AddCustomersToQueueIfNecessary_ret8, AddCustomersToQueueIfNecessary_ret9, AddCustomersToQueueIfNecessary_ret10, AddCustomersToQueueIfNecessary_ret11);
end);
function Bakery.CleanupReplication(p83) -- Line: 1562
	for _, val32 in ipairs(p83.floors) do
		if not val32.transitionPad then continue end
		val32.transitionPad:Destroy();
	end
	local v16 = 0;
	for _, val33 in pairs(p83.Entities) do
		if val33.className == "Customer" and val33.stateData and val33.stateData.foodOrder then
			if val33.stateData.foodOrder.model then
				val33.stateData.foodOrder.model:Destroy();
			end
			if val33.stateData.foodOrder.moneyModel then
				val33.stateData.foodOrder.moneyModel:Destroy();
			end
		end
		val33:Cleanup();
		v16 = v16 + 1;
		if v16 % 200 ~= 0 then continue end
		wait();
	end
end
function Bakery.DestroyBakery(p84) -- Line: 1598
	--[[
		Upvalues:
			[1] = Bakery
	--]]
	p84:CleanupReplication();
	p84.container:Destroy();
	Bakery.AllBakeries[p84.UID] = nil;
end
_L.Network.Fired("GetBakeryOpenStatusFromPlayer"):Connect(function() -- Line: 1604
	--[[
		Upvalues:
			[1] = _L
	--]]
	local t_MyBakery2 = _L.Variables.MyBakery;
	if not t_MyBakery2 then return end
	wait(0.5);
	t_MyBakery2:SetOpenStatus(t_MyBakery2.isOpen);
end);
return Bakery;

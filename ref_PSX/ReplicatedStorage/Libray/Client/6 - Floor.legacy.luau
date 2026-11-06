-- Decompiled with Synapse X v3.0 | https://github.com/synllc
-- added by aimee
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
local _ = {};

--------|    Variables    |--------
local player = game.Players.LocalPlayer

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


local Floor = {};
function Floor.new(p1, p2) -- Line: 63
	--[[
		Upvalues:
			[1] = Floor
	--]]
	if testingSession then
		_L.Print("DEBUG: Creating new Floor.New", true)
	end
	local self = setmetatable({}, {__index = Floor});
	self.floorLevel = p2.FloorLevel;
	self.waiters = {};
	self.cooks = {};
	self.appliances = {};
	self.furniture = {};
	self.customers = {};
	self.customerQueue = {};
	self.entityContainers = {
		self.waiters,
		self.cooks,
		self.appliances,
		self.furniture,
		self.customers
	};
	self.parentBakery = p1;
	self.baseAngle = p1.baseAngle;
	self.dishChairs = {};
	self.floorTransitionXVoxel = p2.FloorTransitionXVoxel;
	self.floorTransitionZVoxel = p2.FloorTransitionZVoxel;
	self.sizeX = p2.SizeXVoxel;
	self.sizeY = p2.SizeYVoxel;
	self.sizeZ = p2.SizeZVoxel;
	self.isBiggerPlot = self.sizeX == 16 and self.sizeZ == 16 or false;
	self.container = Instance.new("Folder", p1.container);
	self.container.Name = string.format("Floor%d", self.floorLevel);
	self.furnitureContainer = Instance.new("Folder", self.container);
	self.furnitureContainer.Name = "FurnitureContainer";
	self.cookContainer = Instance.new("Folder", self.container);
	self.cookContainer.Name = "CookContainer";
	self.waiterContainer = Instance.new("Folder", self.container);
	self.waiterContainer.Name = "WaiterContainer";
	self.applianceContainer = Instance.new("Folder", self.container);
	self.applianceContainer.Name = "ApplianceContainer";
	self.customerContainer = Instance.new("Folder", self.container);
	self.customerContainer.Name = "CustomerContainer";
	self.exterior = Instance.new("Folder", self.container);
	self.exterior.Name = "ExteriorContainer";
	self.silverwareTrays = {};
	self.goldSilverwareTrays = {};
	self.saladBars = {};
	self.dessertBars = {};
	self.balloonMachines = {};
	self:InitFloorAndRoof();
	self.transitionPad = nil;
	self.locations = {};
	self.pathCosts = {};
	for index1 = 1, self.sizeX do
		self.locations[index1] = {};
		self.pathCosts[index1] = {};
		for index5 = 1, self.sizeZ do
			self.locations[index1][index5] = {};
			self.pathCosts[index1][index5] = 1;
		end
	end
	return self;
end
function Floor.InitFloorAndRoof(p3) -- Line: 148
	--[[
		Upvalues:
			[1] = _L
	--]]
	if testingSession then
		_L.Print("DEBUG: Initializing floor & roof", true)
	end
	local v1 = _L.Directory.Themes[p3.parentBakery.themeID];
	if p3.isBiggerPlot then
		p3.base = v1.FloorBig:Clone();
	else
		p3.base = v1.FloorSmall:Clone();
	end
	p3.base.Size = Vector3.new(p3.sizeX * _L.Bakery.VOXEL_SIZE + 1.4, p3.base.Size.Y, p3.sizeZ * _L.Bakery.VOXEL_SIZE + 1.4);
	p3.base.CFrame = CFrame.new(p3:CalculateBasePosition());
	p3.base.Parent = p3.container;
	p3.baseInvis = p3.base:Clone();
	p3.baseInvis.Parent = p3.container;
	p3.baseInvis.Transparency = 1;
	p3.baseInvis.Size = Vector3.new(90, p3.base.Size.Y, 90);
	p3.baseInvis.CFrame = p3.base.CFrame;
	p3.baseInvis:ClearAllChildren();
	p3.roofYCoordinate = p3.base.Position.Y + p3.sizeY - 3;
	p3.roof = p3.base:Clone();
	p3.roof.Size = Vector3.new(p3.roof.Size.X, 0.2, p3.roof.Size.Z);
	p3.roof.CFrame = CFrame.new(p3.base.Position + Vector3.new(0, p3.sizeY - 3, 0));
	p3.roof.Parent = p3.container;
	p3.roof.Name = "Roof";
	if p3.roof:FindFirstChild("SurfaceLight") then
		p3.roof.SurfaceLight:Destroy();
	end
	_L.Services.PhysicsService:SetPartCollisionGroup(p3.base, "FloorGroup");
	_L.Services.PhysicsService:SetPartCollisionGroup(p3.baseInvis, "FloorGroup");
end
function Floor.ReInitExterior(p4) -- Line: 187
	if p4.base then
		p4.base = p4.base:Destroy();
	end
	if p4.roof then
		p4.roof = p4.roof:Destroy();
	end
	p4:InitFloorAndRoof();
	if p4.exteriorModel then
		p4.exteriorModel = p4.exteriorModel:Destroy();
	end
	p4:InitExterior(true);
end
function Floor.InitExterior(p5) -- Line: 203
	--[[
		Upvalues:
			[1] = _L
	--]]
	if testingSession then
		_L.Print("DEBUG: Init exterior", true)
	end
	local t_parentBakery = p5.parentBakery;
	local v2 = game.Players.LocalPlayer == t_parentBakery.owner;
	local v3 = _L.Directory.Themes[p5.parentBakery.themeID];
	local v5;
	if p5.floorLevel == 1 then
		v5 = p5.isBiggerPlot and v3.firstFloorBig:Clone() or v3.firstFloorSmall:Clone();
		if v5:FindFirstChild("Floor") then
			v5.Floor:Destroy();
		end
	elseif p5.isBiggerPlot then
		if testingSession then
			_L.Print("DEBUG: Has bigger plot gamepass", true)
		end
		v5 = v3.nextFloorBig:Clone();
	else
		if testingSession then
			_L.Print("DEBUG: Does NOT have bigger plot gamepass", true)
		end
		v5 = v3.nextFloorSmall:Clone();
	end
	local v4 = v3.extraRotation or CFrame.Angles();
	v5.Parent = p5.exterior;
	if testingSession then
		_L.Print("DEBUG: Setting firstFloor's CFrame", true)
	end
	v5:SetPrimaryPartCFrame(CFrame.new(p5.base.Position + Vector3.new(0, v5.PrimaryPart.Size.Y / 2, 0)) * CFrame.Angles(0, t_parentBakery.baseAngle + math.pi, 0) * v4);
	p5.exteriorModel = v5;
	if p5.floorLevel == 1 then
		p5.parentBakery.bakerySign = v5.BakerySign;
	end
	if not p5.transitionPad then
		if testingSession then
			--	_L.Print("DEBUG: Not a transition pad", true)
		end
		local _ = v5.PrimaryPart.Size.Y;
		local WorldPositionFromVoxel_ret = p5:WorldPositionFromVoxel(p5.floorTransitionXVoxel, 0, p5.floorTransitionZVoxel);
		p5.transitionPad = game.ReplicatedStorage.Assets.BakeryExterior.TransitionPad:Clone();
		p5.transitionPad.Parent = v2 and workspace.__DEBRIS or p5.exterior;
		p5.transitionPad:SetPrimaryPartCFrame(CFrame.new(WorldPositionFromVoxel_ret) * CFrame.Angles(0, p5.baseAngle, 0) * CFrame.new(-2, p5.transitionPad.PrimaryPart.Size.Y / 2, -2));
		for _, descendant26 in ipairs(p5.transitionPad:GetDescendants()) do
			if not descendant26:IsA("BasePart") then continue end
			_L.Services.PhysicsService:SetPartCollisionGroup(descendant26, "FurnitureApplianceGroup");
		end
		local bool1 = false;
		p5.transitionPad.PrimaryPart.Touched:Connect(function(hit) -- Line: 255
			--[[
				Upvalues:
					[1] = bool1
					[2] = _L
					[3] = p5
			--]]
			if testingSession then
				--_L.Print("DEBUG: Touched teleport pad", true)
			end
			if bool1 then return end
			local PlayerFromCharacter = game.Players:GetPlayerFromCharacter(hit.Parent);
			if PlayerFromCharacter and PlayerFromCharacter == game.Players.LocalPlayer then
				_L.Signal.Fire("ShowFloorSwitchUI", p5.parentBakery.UID, p5.floorLevel);
				bool1 = true;
				wait(2);
				bool1 = false;
			end
		end);
	end
end
function Floor.RemoveFromContainer(p6, p7) -- Line: 284
	local EntityContainerFromClassName_ret = p6:EntityContainerFromClassName(p7.className);
	if not EntityContainerFromClassName_ret then return end
	for key1, val1 in ipairs(EntityContainerFromClassName_ret) do
		if val1 ~= p7 then continue end
		table.remove(EntityContainerFromClassName_ret, key1);
		return;
	end
end
function Floor.EntityContainerFromClassName(p8, p9) -- Line: 298
	if p9 == "Waiter" then
		if testingSession then
			--	_L.Print("DEBUG: EntityContainerFromClassName: Waiter", true)
		end
		return p8.waiters;
	end
	if p9 == "Cook" then
		if testingSession then
			--_L.Print("DEBUG: EntityContainerFromClassName: Cook", true)
		end
		return p8.cooks;
	end
	if p9 == "Appliance" then
		if testingSession then
			--	_L.Print("DEBUG: EntityContainerFromClassName: Appliance", true)
		end
		return p8.appliances;
	end
	if p9 == "Furniture" then
		if testingSession then
			--	_L.Print("DEBUG: EntityContainerFromClassName: Furniture", true)
		end
		return p8.furniture;
	end
	if p9 == "Customer" then
		if testingSession then
			--	_L.Print("DEBUG: EntityContainerFromClassName: Customer", true)
		end
		return p8.customers;
	end
	if testingSession then
		_L.Print("DEBUG: EntityContainerFromClassName: nil (might be important)", true)
	end
	return nil;
end
function Floor.HasAtLeastOneIdleStateOfClass(p10, p11) -- Line: 316
	local EntityContainerFromClassName_ret2 = p10:EntityContainerFromClassName(p11);
	for _, val2 in ipairs(EntityContainerFromClassName_ret2) do
		if val2.state ~= "Idle" then continue end
		return true;
	end
	return false;
end
function Floor.GatherOrderStandsWithDeliveryReady(p12) -- Line: 327
	local table2 = {};
	for _, val3 in ipairs(p12.appliances) do
		if not val3.data.subClass:find("Order Stand") then continue end
		local t_foodReadyList = val3.stateData.foodReadyList;
		if #t_foodReadyList <= 0 or #t_foodReadyList <= val3.stateData.foodReadyTargetCount then continue end
		table.insert(table2, val3);
	end
	return table2;
end
function Floor.GatherOrderStandsWithOrderReady(p13) -- Line: 341
	local table3 = {};
	for _, val4 in ipairs(p13.appliances) do
		if not val4.data.subClass:find("Order Stand") or #val4.stateData.foodOrderQueue <= 0 then continue end
		table.insert(table3, val4);
	end
	return table3;
end
function Floor.SearchForAvailableOven(p14) -- Line: 355
	--[[
		Upvalues:
			[1] = _L
	--]]
	local table4 = {};
	local function hasProperFace(p103) -- Line: 362
		--[[
			Upvalues:
				[1] = p14
		--]]
		return p14:IsValidVoxel(p103:GetFacePosition());
	end
	for _, val5 in ipairs(p14.appliances) do
		if val5.data.subClass ~= "Oven" or val5.stateData.isCooking or val5.stateData.isPinging or not p14:IsValidVoxel(val5:GetFacePosition()) then continue end
		table.insert(table4, val5);
	end
	if #table4 == 0 then
		local v19 = _L.Functions.RandomIndices(_L.Variables.MyBakery.floors);
		for _, val27 in ipairs(v19) do
			local v25 = _L.Variables.MyBakery.floors[val27];
			if v25 == p14 then continue end
			local EntitiesFromClassAndSubClass = v25:GetEntitiesFromClassAndSubClass("Appliance", "Oven");
			for _, val35 in ipairs(EntitiesFromClassAndSubClass) do
				if val35.stateData.isCooking or val35.stateData.isPinging or not p14:IsValidVoxel(val35:GetFacePosition()) then continue end
				table.insert(table4, val35);
			end
			if #table4 > 0 then break end
		end
	end
	if #table4 == 0 then
		_L.Print("No available ovens...");
		return nil;
	end
	local table5 = {};
	for _, val6 in ipairs(table4) do
		table5[val6.UID] = math.random() * 0.1;
	end
	table.sort(table4, function(p104, p105) -- Line: 405
		--[[
			Upvalues:
				[1] = table5
		--]]
		return p105.data.cookSpeed + table5[p105.UID] > p104.data.cookSpeed + table5[p104.UID];
	end);
	return table4[1];
end
function Floor.GatherDishwashersWithSpace(p15, p16) -- Line: 417
	local table6 = {};
	for _, val7 in ipairs(p15.appliances) do
		if val7.data.subClass ~= "Dishwasher" or val7.data.maxDishes + (val7.UID == p16 and 1 or 0) <= val7.stateData.numberDishes + val7.stateData.dishWasherTargetCount then continue end
		table.insert(table6, val7);
	end
	return table6;
end
function Floor.GatherDishwashersOnAnyFloor(p17, p18) -- Line: 431
	--[[
		Upvalues:
			[1] = _L
	--]]
	local GatherDishwashersWithSpace_ret = p17:GatherDishwashersWithSpace(p18);
	if #GatherDishwashersWithSpace_ret > 0 then
		return GatherDishwashersWithSpace_ret;
	end
	local v6 = _L.Functions.RandomIndices(_L.Variables.MyBakery.floors);
	for _, val8 in ipairs(v6) do
		GatherDishwashersWithSpace_ret = _L.Variables.MyBakery.floors[val8]:GatherDishwashersWithSpace();
		if #GatherDishwashersWithSpace_ret > 0 then break end
	end
	return GatherDishwashersWithSpace_ret;
end
function Floor.PickOrderFromOrderStands(p19) -- Line: 453
	local table7 = {};
	for _, val9 in ipairs(p19.appliances) do
		if val9.isDeleted or not val9.data.subClass:find("Order Stand") or #val9.stateData.foodOrderQueue <= 0 then continue end
		table.insert(table7, val9);
	end
	if #table7 == 0 then
		return nil, nil;
	end
	local v7 = table7[math.random(#table7)];
	return v7, v7.stateData.foodOrderQueue[1];
end
function Floor.GetCustomerWaitingToOrder(p20) -- Line: 474
	for _, val10 in ipairs(p20.customers) do
		if val10.state ~= "WaitingToOrder" or val10.waiterIsAttendingToFoodOrder then continue end
		return val10;
	end
	return nil;
end
function Floor.GenerateObstacleTable(p21) -- Line: 485
	return p21.pathCosts;
end
function Floor.GenerateObstacleTableWithoutNPCs(p22) -- Line: 502
	local table8 = {};
	for index2 = 1, p22.sizeX do
		table8[index2] = {};
		for index6 = 1, p22.sizeZ do
			table8[index2][index6] = 1;
		end
	end
	local table9 = {
		{
			container = p22.appliances,
			cost = 60
		},
		{
			container = p22.furniture,
			cost = 60
		}
	};
	local Floor0 = {
		Wall = 190,
		IgnorePathfinding = 1
	};
	for _, val11 in ipairs(table9) do
		for _, val28 in ipairs(val11.container) do
			if not val28.xVoxel or not val28.zVoxel or not table8[val28.xVoxel] or not table8[val28.xVoxel][val28.zVoxel] or val28.data.subClass and val28.data.subClass:find("IgnorePathfinding") then continue end
			table8[val28.xVoxel][val28.zVoxel] = Floor0[val28.subClass] or val11.cost;
		end
	end
	return table8;
end
function Floor.BroadcastNPCPositionChange(p23, p24, p25, p26) -- Line: 540
	if not p25 or not p26 then return end
	if not p23:IsValidVoxel(p25, 0, p26) then return end
	p23:RemoveNPCFromPathfindingTable(p24, p25, p26);
	local t_xVoxel = p24.xVoxel;
	local t_zVoxel = p24.zVoxel;
	if p23.pathCosts[t_xVoxel][t_zVoxel] <= 5 then
		p23.pathCosts[t_xVoxel][t_zVoxel] = 5;
	end
end
function Floor.RemoveNPCFromPathfindingTable(p27, p28, p29, p30) -- Line: 570
	p29 = p29 or p28.xVoxel;
	p30 = p30 or p28.zVoxel;
	if not p27:IsValidVoxel(p29, p28.yVoxel, p30) then return end
	if p27.pathCosts[p29][p30] <= 5 then
		p27.pathCosts[p29][p30] = 1;
	end
end
function Floor.UpdateEntityLocationTable(p31, p32, p33, p34) -- Line: 589
	if not p32:BelongsToMyBakery() then return end
	if not p32:Is("Appliance") and not p32:Is("Furniture") then return end
	local function inBounds(p106, p107) -- Line: 599
		--[[
			Upvalues:
				[1] = p31
		--]]
		return p106 >= 1 and (p106 <= p31.sizeX and (p107 >= 1 and p107 <= p31.sizeZ or false) or false) or false;
	end
	if p33 and p34 then
		p31:DeleteEntityFromLocationTable(p32, p33, p34);
	end
	for _, val12 in ipairs(p32:GetFullVoxelSetWithPathfindingIgnore()) do
		local t_x = val12.x;
		local t_z = val12.z;
		if (t_x < 1 or (t_x > p31.sizeX or (t_z < 1 or t_z > p31.sizeZ) and not false) and not false) and not false then continue end
		table.insert(p31.locations[val12.x][val12.z], p32);
		if p32.data.placementLevel ~= 2 then continue end
		p31.pathCosts[val12.x][val12.z] = 50;
	end
end
function Floor.DeleteEntityFromLocationTable(p35, p36, p37, p38) -- Line: 623
	if not p36:BelongsToMyBakery() then return end
	p37 = p37 or p36.xVoxel;
	p38 = p38 or p36.zVoxel;
	local function inBounds(p108, p109) -- Line: 631
		--[[
			Upvalues:
				[1] = p35
		--]]
		return p108 >= 1 and (p108 <= p35.sizeX and (p109 >= 1 and p109 <= p35.sizeZ or false) or false) or false;
	end
	local v8 = p36:GetFullVoxelSetWithPathfindingIgnore(p37, p38);
	for _, val13 in ipairs(v8) do
		local t_x2 = val13.x;
		local t_z2 = val13.z;
		if (t_x2 < 1 or (t_x2 > p35.sizeX or (t_z2 < 1 or t_z2 > p35.sizeZ) and not false) and not false) and not false then continue end
		local v20 = p35.locations[val13.x][val13.z];
		for key29, val29 in ipairs(v20) do
			if p36.UID ~= val29.UID then continue end
			table.remove(v20, key29);
			break;
		end
		if p36.data.placementLevel ~= 2 then continue end
		p35.pathCosts[val13.x][val13.z] = 1;
	end
end
function Floor.InitializePositionTable(p39) -- Line: 657
	for _, val14 in ipairs(p39.entityContainers) do
		for _, val30 in ipairs(val14) do
			if val30.className ~= "Appliance" and val30.className ~= "Furniture" then continue end
			val30:UpdateVoxelPosition();
		end
	end
end
function Floor.PlacementLevelIsValid(p40, p41, p42, p43) -- Line: 668
	if not p40.locations[p42] then
		return false;
	end
	if not p40.locations[p42][p43] then
		return false;
	end
	for _, val15 in ipairs(p40.locations[p42][p43]) do
		if val15.data.placementLevel ~= p41 then continue end
		return false;
	end
	return true;
end
function Floor.AddEntity(p44, p45) -- Line: 686
	table.insert(p44:EntityContainerFromClassName(p45.className), p45);
	p45.floorLevel = p44.floorLevel;
	if (p45.className == "Furniture" or p45.className == "Apppliance") and p45.xVoxel > 0 and p44.sizeX >= p45.xVoxel and p45.zVoxel > 0 and p44.sizeZ >= p45.zVoxel then
		table.insert(p44.locations[p45.xVoxel][p45.zVoxel], p45);
	end
end
function Floor.RemoveEntityLocation(p46, p47) -- Line: 698
	if p46.className ~= "Furniture" and p46.className ~= "Appliance" then return end
	local v9 = p46.locations[p47.xVoxel][p47.zVoxel];
	for key16, val16 in ipairs(v9) do
		if p47.UID ~= val16.UID then continue end
		table.remove(v9, key16);
		return;
	end
end
function Floor.RemoveEntityFromContainer(p48, p49) -- Line: 712
	local EntityContainerFromClassName_ret3 = p48:EntityContainerFromClassName(p49.className);
	for key17, val17 in ipairs(EntityContainerFromClassName_ret3) do
		if p49 ~= val17 then continue end
		p48:RemoveEntityLocation(p49);
		table.remove(EntityContainerFromClassName_ret3, key17);
		return;
	end
end
function Floor.CalculateBasePosition(p50) -- Line: 724
	return Vector3.new(p50.parentBakery.rootPosition.X, p50.parentBakery.rootPosition.Y + (p50.floorLevel - 1) * p50.sizeY - 0.45, p50.parentBakery.rootPosition.Z);
end
function Floor.IsValidVoxel(p51, p52, p53, p54) -- Line: 733
	return p52 >= 1 and (p52 <= p51.sizeX and (p53 >= 0 and (p53 <= p51.sizeY and (p54 >= 1 and p54 <= p51.sizeZ or false) or false) or false) or false) or false;
end
function Floor.ConstrainVoxel(p55, p56, p57, p58) -- Line: 742
	local v10 = p56 < 1 and 1 or p55.sizeX < p56 and p55.sizeX or p56;
	local v11 = p57 < 0 and 0 or p55.sizeY < p57 and p55.sizeY or p57;
	if p58 < 1 then
		return v10, v11, 1;
	end
	return v10, v11, p55.sizeZ < p58 and p55.sizeZ or p58;
end
function Floor.GetEntityFromLocationAndClass(p59, p60, p61, p62, p63) -- Line: 750
	if not p59:IsValidVoxel(p60, 1, p61) then
		return nil;
	end
	for _, val18 in ipairs(p59.locations[p60][p61]) do
		if not val18:Is(p62) or val18.data.placementLevel ~= p63 then continue end
		return val18;
	end
	return nil;
end
function Floor.GetEntityFromLocationAndSubclass(p64, p65, p66, p67) -- Line: 764
	if not p64:IsValidVoxel(p65, 1, p66) then
		return nil;
	end
	for _, val19 in ipairs(p64.locations[p65][p66]) do
		if not val19.data.subClass or not val19.data.subClass:find(p67) then continue end
		return val19;
	end
	return nil;
end
function Floor.GetEntitiesFromClassAndSubClass(p68, p69, p70) -- Line: 778
	local Floor1 = {};
	local EntityContainerFromClassName_ret4 = p68:EntityContainerFromClassName(p69);
	for _, val20 in ipairs(EntityContainerFromClassName_ret4) do
		if val20.isDeleted or not val20.data.subClass or not val20.data.subClass:find(p70) then continue end
		table.insert(Floor1, val20);
	end
	return Floor1;
end
function Floor.GetEntitiesFromSubClassAndContainer(p71, p72, p73) -- Line: 793
	local Floor2 = {};
	for _, val21 in ipairs(p73) do
		if not val21.data.subClass or not val21.data.subClass:find(p72) then continue end
		table.insert(Floor2, val21);
	end
	return Floor2;
end
function Floor.WorldPositionFromVoxel(p74, p75, p76, p77) -- Line: 805
	--[[
		Upvalues:
			[1] = _L
	--]]
	local t_Position = p74.base.Position;
	return Vector3.new(t_Position.X + (p75 - p74.sizeX / 2 - 0.5) * _L.Bakery.VOXEL_SIZE, t_Position.Y + p74.base.Size.Y / 2, t_Position.Z + (p77 - p74.sizeZ / 2 - 0.5) * _L.Bakery.VOXEL_SIZE);
end
-- fixed function
function Floor:VoxelFromWorldPosition(worldPosition)
	local offset = worldPosition - (self.base.Position - self.base.Size/2)
	local scaled = Vector3.new(
		math.floor(offset.X/_L.Bakery.VOXEL_SIZE) + 1,
		math.floor(offset.Y/_L.Bakery.VOXEL_SIZE),
		math.floor(offset.Z/_L.Bakery.VOXEL_SIZE) + 1
	)
	return scaled.X, scaled.Y, scaled.Z
end
function Floor.ClearAllCustomers(p80) -- Line: 834
	for _, val22 in ipairs(p80.customers) do
		val22:Cleanup();
	end
	p80.customers = {};
	p80.customerQueue = {};
end
function Floor.GetChairsSurroundingTable(p81, p82, p83) -- Line: 845
	--[[
		Upvalues:
			[1] = _L
	--]]
	local t_xVoxel2 = p82.xVoxel;
	local t_zVoxel2 = p82.zVoxel;
	local Floor3 = {};
	for index3 = -2, 2 do
		for index7 = -2, 2 do
			while true do
				if index3 == 0 and index7 == 0 then
					break;
				end
				local v26 = t_xVoxel2 + index3;
				local v27 = t_zVoxel2 + index7;
				if not p81:IsValidVoxel(v26, 0, v27) then
					break;
				end
				local EntityFromLocationAndClass = p81:GetEntityFromLocationAndClass(v26, v27, "Furniture", 2);
				if not EntityFromLocationAndClass or not EntityFromLocationAndClass.data.subClass:find("Chair") or (EntityFromLocationAndClass.stateData.occupied or EntityFromLocationAndClass.stateData.dish) and not p83 then
					break;
				end
				local v28 = _L.Directory.Furniture[EntityFromLocationAndClass.ID];
				local Floor4 = {};
				if not v28.omnidirectional then
					local GetFacePosition_ret1, _, GetFacePosition_ret3 = EntityFromLocationAndClass:GetFacePosition();
					if not p81:IsValidVoxel(GetFacePosition_ret1, 0, GetFacePosition_ret3) then
						break;
					end
					local EntityFromLocationAndClass2 = p81:GetEntityFromLocationAndClass(GetFacePosition_ret1, GetFacePosition_ret3, "Furniture", 2);
					if not EntityFromLocationAndClass2 then
						break;
					end
					table.insert(Floor4, EntityFromLocationAndClass2);
				else
					local Floor5 = {
						{
							dx = -1,
							dz = 0
						},
						{
							dx = 1,
							dz = 0
						},
						{
							dx = 0,
							dz = -1
						},
						{
							dx = 0,
							dz = 1
						}
					};
					for _, val37 in ipairs(Floor5) do
						local v30 = EntityFromLocationAndClass.xVoxel + val37.dx;
						local v31 = EntityFromLocationAndClass.zVoxel + val37.dz;
						if not p81:IsValidVoxel(v30, 0, v31) then continue end
						local EntityFromLocationAndClass3 = p81:GetEntityFromLocationAndClass(v30, v31, "Furniture", 2);
						if not EntityFromLocationAndClass3 then continue end
						table.insert(Floor4, EntityFromLocationAndClass3);
					end
				end
				for _, val36 in ipairs(Floor4) do
					if val36 ~= p82 then continue end
					table.insert(Floor3, EntityFromLocationAndClass);
					if v28.omnidirectional then
						local v32 = val36.xVoxel - EntityFromLocationAndClass.xVoxel;
						local v33 = val36.zVoxel - EntityFromLocationAndClass.zVoxel;
						EntityFromLocationAndClass.stateData.cachedFaceDirection = Vector3.new(v32, 0, v33);
						_L.Replication.ForceEvent("UpdateSeatCachedFaceDirection", EntityFromLocationAndClass.UID, (Vector3.new(v32, 0, v33)));
					end
					if #Floor3 == 1 and _L.Variables.MyBakery.isTutorial then
						return Floor3;
					end
					if #Floor3 ~= 4 then break end
					return Floor3;
				end
				break;
			end
		end
	end
	return Floor3;
end
function Floor.GetAvailableSeatGroupings(p84) -- Line: 946
	--[[
		Upvalues:
			[1] = _L
	--]]
	local v13 = _L.Functions.RandomIndices(p84.furniture);
	for _, val23 in ipairs(v13) do
		local v21 = p84.furniture[val23];
		if not v21.data.subClass:find("Table") then continue end
		local ChairsSurroundingTable = p84:GetChairsSurroundingTable(v21);
		if #ChairsSurroundingTable <= 0 then continue end
		return v21, ChairsSurroundingTable;
	end
	return nil, nil;
end
function Floor.GetRandomOrderStand(p85) -- Line: 968
	local EntitiesFromSubClassAndContainer = p85:GetEntitiesFromSubClassAndContainer("Order Stand", p85.appliances);
	if #EntitiesFromSubClassAndContainer == 0 then
		return nil;
	end
	return EntitiesFromSubClassAndContainer[math.random(#EntitiesFromSubClassAndContainer)];
end
function Floor.FindOrderStandOnAnyFloor(p86) -- Line: 977
	--[[
		Upvalues:
			[1] = _L
	--]]
	local RandomOrderStand = p86:GetRandomOrderStand();
	if not RandomOrderStand then
		local v22 = _L.Functions.RandomIndices(_L.Variables.MyBakery.floors);
		for _, val31 in ipairs(v22) do
			local v29 = _L.Variables.MyBakery.floors[val31];
			if v29 == p86 then continue end
			RandomOrderStand = v29:GetRandomOrderStand();
			if RandomOrderStand then break end
		end
	end
	return RandomOrderStand;
end
function Floor.AddFoodOrder(p87, p88) -- Line: 998
	local RandomOrderStand2 = p87:GetRandomOrderStand();
	if RandomOrderStand2 then
		RandomOrderStand2:AddFoodToQueue(p88);
	end
end
function Floor.AnimatePathFromPointToPoint(p89, p90, p91, p92, p93) -- Line: 1011
	--[[
		Upvalues:
			[1] = _L
	--]]
	local function calculatePathToEntity() -- Line: 1015
		--[[
			Upvalues:
				[1] = p89
				[2] = _L
				[3] = p90
				[4] = p91
				[5] = p92
				[6] = p93
		--]]
		local GenerateObstacleTable_ret = p89:GenerateObstacleTable();
		local v23 = _L.Pathfinding.CalculatePath(GenerateObstacleTable_ret, p90, p91, p92, p93, nil, true);
		local Floor6 = {};
		for _, val33 in ipairs(v23) do
			table.insert(Floor6, p89:WorldPositionFromVoxel(val33.x, 0, val33.y));
		end
		return Floor6;
	end
	local function drawPathToEntity() -- Line: 1025
		--[[
			Upvalues:
				[1] = calculatePathToEntity
				[2] = _L
		--]]
		local v24 = calculatePathToEntity();
		local Folder = Instance.new("Folder", workspace.__DEBRIS);
		local Floor7 = {};
		for _, val34 in ipairs(v24) do
			local Part = Instance.new("Part", Folder);
			Part.Size = Vector3.new(4, 0.2, 4);
			Part.Position = val34;
			Part.Anchored = true;
			Part.CanCollide = false;
			Part.TopSurface = Enum.SurfaceType.Smooth;
			Part.Color = Color3.fromRGB(64, 220, 255);
			Part.Material = Enum.Material.Neon;
			table.insert(Floor7, Part);
		end
		local coroutine_wrap_ret = coroutine.wrap(function() -- Line: 1042
			--[[
				Upvalues:
					[1] = Floor7
					[2] = _L
			--]]
			local tick_ret = tick();
			while true do
				local _ = tick() - tick_ret;
				local bool2 = false;
				for key38, val38 in ipairs(Floor7) do
					if val38.Parent == nil then
						bool2 = true;
						break;
					end
					local v34 = (#Floor7 - key38 + 1) * math.pi / 8;
					val38.Transparency = 0.95 - (math.sin(tick() * 7 + v34) / 2 + 0.5) * 0.55;
				end
				if bool2 then break end
				_L.Services.RunService.RenderStepped:Wait();
			end
		end);
		coroutine_wrap_ret();
		return Folder;
	end
	return drawPathToEntity();
end
function Floor.GetWallModelFromGrid(p94, p95, p96, p97) -- Line: 1071
	local v15 = (p95[p96] or {})[p97 - 1] and "T" or "F";
	local v16 = (p95[p96] or {})[p97 + 1] and "T" or "F";
	local v17 = (p95[p96 - 1] or {})[p97] and "T" or "F";
	local v18 = v17 .. v15 .. ((p95[p96 + 1] or {})[p97] and "T" or "F") .. v16;
	local t_Furniture = game.ReplicatedStorage.Assets.BakeryEntityAssets.Furniture;
	return ({
		TTTT = t_Furniture.WALL_CROSS,
		TTTF = t_Furniture.WALL_LRD,
		TTFT = t_Furniture.WALL_RUD,
		TFTT = t_Furniture.WALL_LRU,
		FTTT = t_Furniture.WALL_LUD,
		TTFF = t_Furniture.WALL_RD,
		TFFT = t_Furniture.WALL_RU,
		FTTF = t_Furniture.WALL_LD,
		FFTT = t_Furniture.WALL_LU,
		TFTF = t_Furniture.WALL_HORIZONTAL,
		FTFT = t_Furniture.WALL_VERTICAL,
		TFFF = t_Furniture.WALL_HORIZONTAL,
		FTFF = t_Furniture.WALL_VERTICAL,
		FFTF = t_Furniture.WALL_HORIZONTAL,
		FFFT = t_Furniture.WALL_VERTICAL,
		FFFF = t_Furniture.WALL_HORIZONTAL
	})[v18];
end
function Floor.UpdateWalls(p98, p99, p100) -- Line: 1098
	--[[
		Upvalues:
			[1] = _L
	--]]
	local GetWallGrid_ret1, GetWallGrid_ret2 = p98:GetWallGrid();
	if p99 and p100 then
		GetWallGrid_ret1[p99][p100] = true;
	end
	for _, val24 in ipairs(GetWallGrid_ret2) do
		local WallModelFromGrid = p98:GetWallModelFromGrid(GetWallGrid_ret1, val24.xVoxel, val24.zVoxel);
		if val24.model.Name == WallModelFromGrid.Name then continue end
		local Clone_ret = WallModelFromGrid:Clone();
		local t_Position2 = val24.model.PrimaryPart.Position;
		Clone_ret.Parent = p98.furnitureContainer;
		Clone_ret:MakeJoints();
		Clone_ret:SetPrimaryPartCFrame(CFrame.new(t_Position2));
		val24.model:Destroy();
		val24.model = Clone_ret;
		for _, descendant32 in ipairs(val24.model:GetDescendants()) do
			if not descendant32:IsA("BasePart") then continue end
			_L.Services.PhysicsService:SetPartCollisionGroup(descendant32, "FurnitureApplianceGroup");
		end
	end
end
function Floor.GetWallGrid(p101) -- Line: 1123
	local EntitiesFromClassAndSubClass2 = p101:GetEntitiesFromClassAndSubClass("Furniture", "Wall");
	local Floor8 = {};
	for index4 = 1, p101.sizeX do
		Floor8[index4] = {};
	end
	for _, val25 in ipairs(EntitiesFromClassAndSubClass2) do
		if not Floor8[val25.xVoxel] then continue end
		Floor8[val25.xVoxel][val25.zVoxel] = val25.UID;
	end
	return Floor8, EntitiesFromClassAndSubClass2;
end
function Floor.UpdateToBiggerPlot(p102) -- Line: 1138
end
return Floor;

--[[
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
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
	 
--]]
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


--------|       Top       |--------
local States = {}

--------|     Setting     |--------

--------|     Library     |--------
local _L; coroutine.wrap(function()  _L = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"))  end)()

--------|    Reference    |--------
local isServer = game:GetService("RunService"):IsServer()

--------|    Variables    |--------
local player = game.Players.LocalPlayer

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local Appliance = {}

-- @static
function Appliance.new(ID, UID, parentBakery, parentFloor)
		
	local super = _L.Entity.new(ID, UID, "Appliance", parentBakery, parentFloor)
	local self = setmetatable(super, {__index = function(t, key) return Appliance[key] or _L.Entity[key] end})
	
	for _, v in ipairs(self.model:GetDescendants()) do
		if v:IsA("BasePart") then
			_L.Services.PhysicsService:SetPartCollisionGroup(v, "FurnitureApplianceGroup")
		end
	end
	
	self.objectData = _L.Directory.Appliance[ID]
	
	-- used for misc. state data between subclasses
	self.stateData = {}
	
	if not self.data.subClass then
		self.data.subClass = ""
	end
	
	if self.data.subClass:find("Order Stand") then
		
		-- list of food items waiting to be cooked
		self.stateData.foodOrderQueue = {}
		
		-- list of food items that have been cooked and are waiting to be served
		self.stateData.foodReadyList = {}
		
		-- the UI containing these objects ^
		self.stateData.orderStandUI = _L.CustomUIEffects.OrderStandPopupList(self.model, self:BelongsToMyBakery())
		
		-- the number of waiters currently walking to this destination to pickup a delivery
		self.stateData.foodReadyTargetCount = 0
		
		-- the number of cooks walking to this destination to pickup an order
		self.stateData.orderPickupReadyTargetCount = 0
		
		self:InitOrderStandInteract()
		
	elseif self.data.subClass == "Oven" then
		
		-- whether or not it's pinging the customer to be used
		self.stateData.isPinging = false
		
		-- the UI for above ^
		self.stateData.pingUI = nil
		
		-- whether or not cooking is in progress
		self.stateData.isCooking = false
		
		-- the UI for above ^
		self.stateData.cookingUI = _L.CustomUIEffects.CookingProgressUI(self.model)
		
		-- humanoid of whoever is using the oven
		self.stateData.interactingHumanoidModel = nil
		
		-- sound object being looped
		self.stateData.ovenLoopSound = nil
		
		-- smoke effect during cooking
		self.stateData.smokeEffect = game.ReplicatedStorage.Assets.Particles.StoveSmoke:Clone()
		self.stateData.smokeEffect.Parent = self.model.PrimaryPart
		self.stateData.smokeEffect.Enabled = false
		
	elseif self.data.subClass == "Dishwasher" then
		
		-- the number of dishes currently stored
		self.stateData.numberDishes = 0
		
		-- number of waiters walking to this destination to insert a dish
		self.stateData.dishWasherTargetCount = 0
		
		-- user ping
		self.stateData.dishwasherPing = nil
		
		-- am i currently washing dishes?
		self.stateData.isWashingDishes = false
		
		-- displays number of dishes and total space
		self.stateData.dishwasherUI = _L.CustomUIEffects.DishWasherPopupUI(self.model, self.data.maxDishes)
		self.stateData.dishwasherUI.Enabled = false
		
		-- sound object being looped
		self.stateData.washingLoopSound = nil
		
		self:StartDishwasherUIUpdateLoop()
		
	end
	
	return self
	
end

-- @static
function Appliance.FromUIDData(parentBakery, parentFloor, applianceUIDData)
		
	local self = Appliance.new(applianceUIDData.ID, applianceUIDData.UID, parentBakery, parentFloor)
	
	self.xVoxel = applianceUIDData.XVoxel
	self.yVoxel = applianceUIDData.YVoxel
	self.zVoxel = applianceUIDData.ZVoxel
	self.orientation = applianceUIDData.Orientation
			
	local myWorldPosition = parentFloor:WorldPositionFromVoxel(self.xVoxel, self.yVoxel, self.zVoxel) + Vector3.new(0, self.model.PrimaryPart.Size.Y/2, 0)
	self.model:SetPrimaryPartCFrame(CFrame.new(myWorldPosition) * CFrame.Angles(0, math.rad(self.orientation), 0))
		
	-- door CFrame attachments
	if self.objectData.subClass:find("Oven") then
		self.doorClosedAttachment = self.model.stove.DoorClosed
		self.doorOpenAttachment   = self.model.stove.DoorOpen
		self.doorPart             = self.model.door
		self.stovePart            = self.model.stove
		
		self:SetDoorToAttachment(self.doorOpenAttachment)
	end
	
	if self.ID == "22" then
		table.insert(parentBakery.coffeeMachines, self)
	end
	
	if self.ID == "24" then
		table.insert(self:GetMyFloor().silverwareTrays, self)
	end
	
	if self.ID == "25" then
		table.insert(self:GetMyFloor().goldSilverwareTrays, self)
	end	

	if self.ID == "28" then
		table.insert(self:GetMyFloor().saladBars, self)
	end
	
	if self.ID == "30" then
		table.insert(self:GetMyFloor().dessertBars, self)
	end
	
	-- special case: init candy bowl
	if self.ID == "31" then
		self:InitCandyBowl(applianceUIDData)
	end

			
	return self
	
end

-- @classmethod
-- only used for stoves
function Appliance:SetDoorToAttachment(attachment)
	
	local easingStyle
	local easingTime
	if attachment == self.doorOpenAttachment then
		easingTime = 0.5
		easingStyle = "Back"
	else
		easingTime = 0.2
		easingStyle = "Linear"
	end
	
	local orientation = Vector3.new(
		math.rad(attachment.WorldOrientation.X),
		math.rad(attachment.WorldOrientation.Y),
		math.rad(attachment.WorldOrientation.Z)
	)
	
	local initialPosition = self.doorPart.Position
	local initialOrientation = self.doorPart.Orientation
	
	local function makeEasedVector(start, goal, ease)
		local dx = goal.X - start.X
		local dy = goal.Y - start.Y
		local dz = goal.Z - start.Z
		return Vector3.new(
			start.X + dx*ease,
			start.Y + dy*ease,
			start.Z + dz*ease
		)
	end
	
	coroutine.wrap(function()
		local _t = tick()
		while (tick() - _t) <= easingTime do
			local alpha = math.clamp((tick() - _t) / easingTime, 0, 1)
			local ease = _L.Functions.Easing(alpha, easingStyle, "Out")
			
			self.doorPart.Position = makeEasedVector(initialPosition, attachment.WorldPosition, ease)
			self.doorPart.Orientation = makeEasedVector(initialOrientation, attachment.WorldOrientation, ease)
			
			_L.Services.RunService.RenderStepped:Wait()
		end
	end)()

end
-- @classmethod
function Appliance:Cleanup()
	
	if self.isDeleted then
		return
	end
	
	local myBakery = self:GetMyBakery()
	
	-- cleanup burners
	if self.data.subClass:find("Oven") then
		self:StopBurners()
	end
	
	-- target of animated path?
	if self == myBakery.animatedPathTargetEntity then
		myBakery:CleanupAnimatedPath()
		
		if self.data.subClass == "Dishwasher" then
			_L.PlayerAnimations.DropModel()
		end
	end
	
	-- if I'm an active oven, my order should return to the order stand
	if self.data.subClass == "Oven" and self.stateData.isCooking then
		self:FreeHumanoid()
		
		if self.stateData.cookUsingMe then
			self.stateData.cookUsingMe:AbortCooking()
		end
		
		local orderStand = self:GetMyFloor():FindOrderStandOnAnyFloor()
		if orderStand then
			orderStand:AddFoodToQueue(self.stateData.foodOrder)
		else
			local customerOwner = self:EntityTable()[self.stateData.foodOrder.customerOwnerUID]
			if customerOwner then
				customerOwner:ForcedToLeave()
			end
		end
		
	elseif self.data.subClass:find("Order Stand") then
		
		local function forceToLeave(customerUID)
			local customer = self:EntityTable()[customerUID]
			if not customer or customer.isDeleted then
				return
			end
			customer:ForcedToLeave()
		end
		
		for _, foodItem in ipairs(self.stateData.foodOrderQueue) do
			forceToLeave(foodItem.customerOwnerUID)	
		end
		for _, foodItem in ipairs(self.stateData.foodReadyList) do
			forceToLeave(foodItem.customerOwnerUID)
		end
		self.stateData.foodOrderQueue = nil
		self.stateData.foodReadyList = nil
		
	-- silverware tray
	elseif self.ID == "24" then
		
		local myFloor = self:GetMyFloor()
		for i, elem in ipairs(myFloor.silverwareTrays) do
			if elem == self then
				table.remove(myFloor.silverwareTrays, i)
				break
			end
		end
		
	-- gold silverware tray
	elseif self.ID == "25" then
		
		local myFloor = self:GetMyFloor()
		for i, elem in ipairs(myFloor.goldSilverwareTrays) do
			if elem == self then
				table.remove(myFloor.goldSilverwareTrays, i)
				break
			end
		end
		
	end
	
	if self.ID == "22" then
		for i, v in ipairs(myBakery.coffeeMachines) do
			if v.UID == self.UID then
				table.remove(myBakery.coffeeMachines, i)
				break
			end
		end
	end

	if self.ID == "28" then
		local myFloor = self:GetMyFloor()
		for i, elem in ipairs(myFloor.saladBars) do
			if elem == self then
				table.remove(myFloor.saladBars, i)
				break
			end
		end
	end
	
	if self.ID == "30" then
		local myFloor = self:GetMyFloor()
		for i, elem in ipairs(myFloor.dessertBars) do
			if elem == self then
				table.remove(myFloor.dessertBars, i)
				break
			end
		end
	end
	
	-- super destructor
	_L.Entity.Cleanup(self)
	
end

-- @classmethod
function Appliance:UpdateCandyBowlHeight(level)
	self.model.candy.Transparency = level > 0 and 0 or 1
	self.model.candy.Position = self.model.PrimaryPart.Position + Vector3.new(0, 2.50 - (5 - level)*0.50)
end

-- @classmethod
function Appliance:InitCandyBowl(UIDData)
	
	UIDData.CandyLevel = UIDData.CandyLevel or 0
	self.level = UIDData.CandyLevel
	self:UpdateCandyBowlHeight(self.level)
	
	if not self:BelongsToMyBakery() then
		return
	end
	
	coroutine.wrap(function()
		while not self.isDeleted and wait() do
			
			if not self.interactEvent and self.level == 0 then
				self:Interact(function()
					_L.Audio.Play(5839737471, self.model.PrimaryPart)
					_L.Network.Fire("RefillCandyBowl", self.UID)
				end)
			elseif self.interactEvent and self.level > 0 then
				self:CleanupInteract()
			end
			
		end	
	end)()
	
end
_L.Network.Fired("CandyBowlHeightChanged"):Connect(function(candyUID, newLevel)
	local bakery = _L.Variables.MyBakery
	if not bakery then
		return
	end
	local candyBowl = bakery:GetEntityByUID(candyUID)
	if not candyBowl then
		return
	end
	candyBowl:UpdateCandyBowlHeight(newLevel)
	candyBowl.level = newLevel
end)


-- @classmethod
-- only for Order Stand
function Appliance:ClearContents()
	self.stateData.foodOrderQueue = {}
	self.stateData.foodReadyList = {}
	self.stateData.orderPickupReadyTargetCount = 0
	self.stateData.foodReadyTargetCount = 0
	for _, child in ipairs(self.stateData.orderStandUI:GetDescendants()) do
		if child.Name == "CookItem" or child.Name == "ServeItem" then
			child:Destroy()
		end
	end
end

-- @classmethod
function Appliance:CleanupFoodObjectFromBothLists(foodOrder)
	
	for i, item in ipairs(self.stateData.foodOrderQueue) do
		if item == foodOrder then
			table.remove(self.stateData.foodOrderQueue, i)
			break
		end
	end
	for i, item in ipairs(self.stateData.foodReadyList) do
		if item == foodOrder then
			table.remove(self.stateData.foodReadyList, i)
			break
		end
	end
	
end

-- @classmethod
function Appliance:InitOrderStandInteract()
	
	if not self:BelongsToMyBakery() then
		return
	end
	
	self:Interact(function(interactDestroyer)
		
		if _L.Variables.MyBakery.animatedPath and not _L.Variables.MyBakery.isTutorial then
			_L.Alert.Message("You cannot do that right now.")
			return
		end
		
		local grabbedQueue = #self.stateData.foodOrderQueue > 0 and self:GrabItemFromQueueList(self.stateData.foodOrderQueue[1])
		local grabbedReady
		
		if not grabbedQueue and #self.stateData.foodReadyList > 0 then
			grabbedReady = self:GrabItemFromReadyList(self.stateData.foodReadyList[1])
			
			-- dish sound
			local dishSounds = {5205173686, 5205173942}
			_L.SFX.Play(dishSounds[math.random(#dishSounds)], self.model:GetPrimaryPartCFrame().p)
		end
		
		-- no stoves?
		if not grabbedQueue and #self.stateData.foodOrderQueue > 0 and not grabbedReady then
			_L.Alert.Message("There are no available stoves.")
		end
		
		-- nothing in stand?
		if #self.stateData.foodOrderQueue == 0 and #self.stateData.foodReadyList == 0 and not grabbedQueue and not grabbedReady then
			_L.Alert.Message("That Order Stand is empty.")
		end
	end, 7)
	
end

-- @classmethod
function Appliance:GrabItemFromReadyList(foodOrder)
	-- lock during tutorial
	if _L.Variables.MyBakery.isTutorial and not _L.Variables.MyBakery.tutorial.readyForUserToServe then
		return
	end
	
	-- if in the tutorial, clean up the tutorial animated path
	if _L.Variables.MyBakery.isTutorial and _L.Variables.MyBakery.animatedPathTargetEntity == self then
		_L.Variables.MyBakery:CleanupAnimatedPath()
	end
	
	-- lock if another animated path already exists
	if _L.Variables.MyBakery.animatedPath then
		return
	end
	
	-- get the customer that the food belongs to
	local myCustomer = self:EntityTable()[foodOrder.customerOwnerUID]
	if not myCustomer then
		_L.Print("ERROR: couldn't find customer owner of food", true)
		return
	end
	
	-- only allow one carry at a time.  should change in the future
	if player:FindFirstChild("__ACTIVATED_CARRY") then
		_L.Alert.Message("You cannot do that right now.")
		return
	end
	Instance.new("IntValue", player).Name = "__ACTIVATED_CARRY"
	
	-- gold?
	foodOrder.isGold = self:IsGoldOrderStand() and math.random() < 0.05
	if foodOrder.isGold then
		_L.SFX.Play(5370840758, self.model.PrimaryPart)
	end
	
	-- hold the dish
	_L.PlayerAnimations.HoldModel(foodOrder.data.model, foodOrder.isGold)
	
	-- ping the customer
	myCustomer:PingForFoodDelivery()
	
	-- animate a path to the customer
	myCustomer.stateData.pathToMe = self:AnimatePathToEntity(myCustomer)
	
	-- remove food from the ready list
	for i, foodOrderInList in ipairs(self.stateData.foodReadyList) do
		if foodOrderInList == foodOrder then
			table.remove(self.stateData.foodReadyList, i)
		end
	end
	
	-- delete list item
	if foodOrder.associatedListItem then
		foodOrder.associatedListItem = foodOrder.associatedListItem:Destroy()
	end
	
	-- tutorial event
	if _L.Variables.MyBakery.isTutorial then
		_L.Signal.Fire("Tutorial_StartedServing")
	end	
	
	return true
end

-- #classmethod
-- only for 'Order Stand' subclass
function Appliance:AddFoodToReadyList(foodOrder)
	
	if not foodOrder or foodOrder.isDeleted then
		return
	end
	
	table.insert(self.stateData.foodReadyList, foodOrder)
	
	local listItem = foodOrder:MakePopupListItemUIServe(self.stateData.orderStandUI)
	foodOrder.associatedListItem = listItem
	listItem.MouseButton1Down:Connect(function()
		
		-- click sound
		_L.Audio.Play(5074101610, player.PlayerGui)
		
		self:GrabItemFromReadyList(foodOrder)
	end)
end

-- @classmethod
-- returns true if action is successful
function Appliance:GrabItemFromQueueList(foodOrder)
			
	-- tutorial lock
	if _L.Variables.MyBakery.isTutorial and not _L.Variables.MyBakery.tutorial.readyForUserToCook then
		return
	end
	
	-- if in the tutorial, clean up the tutorial animated path
	if _L.Variables.MyBakery.isTutorial and _L.Variables.MyBakery.animatedPathTargetEntity == self then
		_L.Variables.MyBakery:CleanupAnimatedPath()
	end
	
	-- only allow one action at a time
	if _L.Variables.MyBakery.animatedPath then
		return
	end
	
	-- collect available ovens
	local oven = _L.Floor.SearchForAvailableOven(self:GetMyFloor())
	
	-- if no ovens avaiable, abort
	if not oven then
		--_L.Alert.Message("There are no available stoves.")
		return
	end
	
	-- remove the order from the queue
	local didFindOrder = false
	for i, foodOrderEntry in ipairs(self.stateData.foodOrderQueue) do
		if foodOrder == foodOrderEntry then
			table.remove(self.stateData.foodOrderQueue, i)
			didFindOrder = true
			self:UpdateNotes()
			break
		end
	end
	
	-- is the order somehow nonexistant?
	if not didFindOrder then
		_L.Print("Player AddFoodToQueue ping failed")
		return
	end
	
	-- all good!  ping the player with a the best available oven
	local pingedOven = oven
	pingedOven.stateData.isPinging = true
	
	-- delete list item
	if foodOrder.associatedListItem then
		foodOrder.associatedListItem = foodOrder.associatedListItem:Destroy()
	end
	
	-- animate a path to the oven
	self:AnimatePathToEntity(pingedOven)
	
	pingedOven:Emoji("CookingEmoji", true)
	pingedOven:Interact(function(interactDestroyer)
		
		local myPosition = player.Character:GetModelCFrame().p
		local pingPosition = pingedOven.model.PrimaryPart.Position
		
		-- bad ping
		if (myPosition - pingPosition).Magnitude > 12 then
			_L.CustomUIEffects.BlinkErrorPing(pingedOven.stateData.pingUI)
			return
		end
		
		-- good ping
		pingedOven.stateData.isPinging = false
		pingedOven:StartCooking(foodOrder)
		pingedOven:StopEmoji()
		interactDestroyer()
		_L.Variables.MyBakery:CleanupAnimatedPath()
		
		-- tutorial event
		if _L.Variables.MyBakery.isTutorial then
			_L.Signal.Fire("Tutorial_StartedCooking")
		end
	end)	
	
	return true

end

-- @classmethod
function Appliance:IsGoldOrderStand()
	return self.ID == "21"
end

-- @classmethod
-- only for 'Order Stand' subclass
-- adds a food list element to the OrderStand popup UI.
-- attaches event to transition the chosen oven into cooking state
function Appliance:AddFoodToQueue(foodOrder)
	
	if not foodOrder or foodOrder.isDeleted then
		return
	end
	
	table.insert(self.stateData.foodOrderQueue, foodOrder)
	self:UpdateNotes()
	
	local listItem = foodOrder:MakePopupListItemUICook(self.stateData.orderStandUI)
	foodOrder.associatedListItem = listItem
	
	listItem.MouseButton1Down:Connect(function()
		
		-- click sound
		_L.Audio.Play(5074101610, player.PlayerGui)
		
		self:GrabItemFromQueueList(foodOrder) 
	end)
end

-- @classmethod
-- only for 'Oven' subclass
function Appliance:ShowBurners()
	
	-- find burner attachments
	local allBurners = {}
	for i = 1, 6 do
		local burnerCheck = self.model:FindFirstChild("burner" .. i, true)
		if not burnerCheck then
			break
		end
		table.insert(allBurners, burnerCheck)
	end
	
	-- count a number of them
	local burnerCount = 1
	while burnerCount < #allBurners and math.random() < 0.35 do
		burnerCount += 1
	end
	
	-- select burners
	local selectedBurners = {}
	for i = 1, burnerCount do
		local index = math.random(#allBurners)
		local burner = allBurners[index]
		table.remove(allBurners, index)
		table.insert(selectedBurners, burner)
	end
	
	-- make particles
	if not self.stateData.burnerHosts then
		self.stateData.burnerHosts = {}
	end
	for _, burner in ipairs(selectedBurners) do
		local host = _L.Functions.CreateParticleHost(burner.WorldPosition)
		local particle = self.data.stoveParticle:Clone()
		particle.Parent = host
		table.insert(self.stateData.burnerHosts, host)
	end
	
end

-- @classmethod
-- only for 'Oven' subclass
function Appliance:StopBurners()
	
	if not self.stateData.burnerHosts then
		return
	end
	
	if self.isDeleted then
		return
	end
	
	for _, burnerHost in ipairs(self.stateData.burnerHosts) do
		burnerHost:Destroy()
	end
	self.stateData.burnerHosts = {}
	
end

-- @classmethod
-- only for 'Oven' subclass
-- given a food object, enters into cooking state
-- if a finished callback is given, a list item is NOT created.
function Appliance:StartCooking(foodOrder, cookUsingMe, finishedCallback)
	
	local isPlayerCooking = not cookUsingMe
	
	if self.stateData.isCooking then 
		return
	end
	self.stateData.isCooking = true
	self.stateData.foodOrder = foodOrder
	self.stateData.cookUsingMe = cookUsingMe
	
	-- door close sound
	_L.SFX.Play(5174014203, self.model.PrimaryPart.Position)
	
	-- tween door to closed
	self:SetDoorToAttachment(self.doorClosedAttachment)
	
	-- play startup sound
	if self.data.activatedSound then
		_L.SFX.Play(self.data.activatedSound, self.model.PrimaryPart)
	end
	if self.data.loopedSound then
		coroutine.wrap(function()
			wait(1.5)
			if self.isDeleted then
				return
			end
			if self.stateData.isCooking then	
				self.stateData.ovenLoopSound = _L.SFX.Play(self.data.loopedSound, self.model.PrimaryPart, nil, nil, nil, nil, true)
			end
		end)()
	end
	
	-- show smoke effect
	self.stateData.smokeEffect.Enabled = true
	
	-- start burners
	self:ShowBurners()
	
	coroutine.wrap(function()
		local cook_time = self.objectData.cookSpeed * (isPlayerCooking and 1 or 2)
		local startTime = tick()
		local timeLeft
		
		-- talented cooks boost
		if _L.TimedProduct.BoostIsActive("Talented Cooks") then
			cook_time /= 3
		end
		
		-- account for cook's cook time
		if cookUsingMe then
			cook_time *= (1 / cookUsingMe.data.cookSpeed)
		end
		
		-- faster cook time during tutorial.  wait 5.5 seconds.  the server
		-- is also aware of this faster cooking time
		if _L.Variables.MyBakery.isTutorial then
			cook_time = 5.5
		end
		
		self.stateData.cookingUI.Enabled = true
		self.stateData.cookingUI.Frame.Progress.Visible = true
		
		local myBakery = self:GetMyBakery()
		local gotServerResponse = false
		local abortedCooking = false
		coroutine.wrap(function()
			while tick() - startTime < cook_time and not gotServerResponse and myBakery.isOpen do
				if self.isDeleted then
					return
				end
				local timeLeft = math.max(cook_time - (tick() - startTime), 0)
				local percentDone = (tick() - startTime)/cook_time
				self.stateData.cookingUI.Frame.Progress.Text = string.format("%.2fs", timeLeft)
				self.stateData.cookingUI.Frame.BarFrame.Bar.Size = UDim2.new(percentDone, 0, 1, 0)
				_L.Services.RunService.RenderStepped:Wait()
			end
		end)()
		
		coroutine.wrap(function()
			if isPlayerCooking then
				_L.Network.Invoke("WaitForCookTime", true, nil, self.ID, self.UID)
			else
				_L.Network.Invoke("WaitForCookTime", false, self.stateData.cookUsingMe.UID, self.ID, self.UID)
			end
			gotServerResponse = true
		end)()
		
		repeat wait() until gotServerResponse or not myBakery.isOpen
		
		if self.isDeleted then
			return
		end
		
		if not self.isDeleted then
			self.stateData.cookingUI.Enabled = false
			self.stateData.cookingUI.Frame.Progress.Visible = false
			self.stateData.cookingUI.Frame.BarFrame.Bar.Size = UDim2.new(0, 0, 1, 0)
		end
		
		-- door open sound
		_L.SFX.Play(5174014203, self.model.PrimaryPart.Position)
		
		-- tween door to closed
		self:SetDoorToAttachment(self.doorOpenAttachment)
		
		-- stop looped sound if necessary
		if self.stateData.ovenLoopSound then
			self.stateData.ovenLoopSound:Stop()
			self.stateData.ovenLoopSound = nil
		end
		
		-- stop smoke effect
		if self.stateData.smokeEffect then
			self.stateData.smokeEffect.Enabled = false
		end
		
		-- stop burners
		self:StopBurners()
		self.stateData.isCooking = false
		self.stateData.foodOrder = nil
		self.stateData.cookUsingMe = nil
		self:FreeHumanoid()
		
		-- add cooked object to list
		local myFloor = self:GetMyFloor()
		local orderStand = myFloor:FindOrderStandOnAnyFloor()
		
		if finishedCallback then
			finishedCallback()
		elseif orderStand and not orderStand.isDeleted then
			
			-- bakery was closed? abort
			if not _L.Variables.MyBakery.isOpen then
				return
			end
				
			orderStand:AddFoodToReadyList(foodOrder)
			_L.SFX.Play(5057745840, orderStand.model.PrimaryPart.Position)
			
			-- tutorial event
			if _L.Variables.MyBakery.isTutorial then
				_L.Signal.Fire("Tutorial_FinishedCooking")
			end
			
			-- award player experience
			_L.Network.Fire("AwardBakeryExperienceWithVerification")
		end
		
	end)()
	
end

-- @classmethod
-- only for 'Order Stand' subclass
function Appliance:UpdateNotes()
	
	local function toggleNote(note, trans)
		note.Transparency = trans
		for _, child in ipairs(note:GetChildren()) do
			if child:IsA("Decal") then
				child.Transparency = trans
			end
		end
	end
	
	local visibleNotes = math.min(#self.stateData.foodOrderQueue, 10)
	for i = 1, visibleNotes do
		toggleNote(self.model:FindFirstChild("Note" .. i), 0)
	end
	for i = visibleNotes + 1, 10 do
		toggleNote(self.model:FindFirstChild("Note" .. i), 1)
	end
end

-- @classmethod
function Appliance:StartDishwasherUIUpdateLoop()
	
	coroutine.wrap(function()
		
		while true do
			
			_L.Services.RunService.RenderStepped:Wait()
			
			if self.isDeleted or not self.stateData then
				return
			end
			
			local ui = self.stateData.dishwasherUI
			if not ui.Enabled then
				continue
			end
			
			if not self.stateData.isWashingDishes then
				continue
			end
			if not self.stateData.dishStartTime then
				continue
			end
			
			-- update bar size
			local DISH_WASH_TIME = self.data.dishWashTime
			local currentDishes = self.stateData.numberDishes
			local maxDishes = self.data.maxDishes
			local scaleUnit = 1/maxDishes
			local scaleStart = currentDishes/maxDishes
			local elapsed = tick() - self.stateData.dishStartTime
			local percentDone = elapsed/DISH_WASH_TIME
			local barSize = scaleStart - scaleUnit*percentDone
			self.stateData.dishwasherUI.Frame.DishProgress.Bar.Size = UDim2.new(barSize, 0, 1, 0)
			
			-- update progress label
			local timeLeft = math.max(DISH_WASH_TIME - elapsed, 0)
			_L.Functions.CachedPropertyChange(self.stateData.dishwasherUI.Frame.Progress, "Text", string.format("%.2fs", timeLeft))
			
		end		
	end)()
	
end

-- @classmethod
function Appliance:StartWashingDishes()
	
	-- enter dishwashing state
	if self.stateData.isWashingDishes then
		return
	end
	self.stateData.isWashingDishes = true
	
	local DISH_WASH_TIME = self.data.dishWashTime
	local lastDishWash = tick()
	
	-- activated sound
	_L.SFX.Play(self.data.activatedSound, self.model.PrimaryPart)
	
	-- start looped washing sound
	if not self.stateData.washingLoopSound then
		coroutine.wrap(function()
			wait(self.data.isDishwasher and 1 or 0.1) --- delay looping audio from playing to give headspace for the start sfx
			if self.isDeleted then
				return
			end
			self.stateData.washingLoopSound = _L.SFX.Play(self.data.loopingSound, self.model.PrimaryPart, 1, 0.70, nil, nil, true)
		end)()
	end
	
	local function updateDishUI()
		self.stateData.dishwasherUI.Enabled = true
	end
	
	local function finishDishUI()
		if self.isDeleted then
			return
		end
		self.stateData.dishwasherUI.Frame.DishProgress.Bar.Size = UDim2.new(0, 0, 1, 0)
		self.stateData.dishwasherUI.Enabled = false
	end
	
	coroutine.wrap(function()
		while not self.isDeleted and self.stateData.numberDishes > 0 do
			self.stateData.dishStartTime = tick()
			updateDishUI()
			wait(DISH_WASH_TIME)
			self:RemoveDish()
			lastDishWash = tick()
		end
		if self.isDeleted then
			return
		end
		finishDishUI()
		self.stateData.isWashingDishes = false
		
		--- finish sound
		if self.data.finishSound then
			_L.SFX.Play(self.data.finishSound, self.model.PrimaryPart, 1, 0.5)
		end
		
		-- stop looped sound
		if self.stateData.washingLoopSound then
			self.stateData.washingLoopSound:Destroy()
			self.stateData.washingLoopSound = nil
		end
	end)()
end

-- @classmethod
function Appliance:AddDish()
	if self.isDeleted then
		return
	end
	
	self.stateData.numberDishes += 1
	self.stateData.dishWasherTargetCount -= 1
	if not self.stateData.isWashingDishes then
		self:StartWashingDishes()
	end
	
	-- dish added sound
	_L.SFX.Play(5205174199, self.model.PrimaryPart)
	
end

-- @classmethod
function Appliance:RemoveDish()
	if self.isDeleted then
		return
	end
	
	if self.stateData.numberDishes <= 0 then
		return
	end
	self.stateData.numberDishes -= 1
	self.stateData.dishwasherUI.Frame.Progress.Text = ""

end


-- @classmethod
-- works for any kind of R15 model.  makes the model face the appliace, locks it in
-- place, plays cooking animation
function Appliance:InteractWithHumanoid(characterModel)
	local targetPosition = self.model.PrimaryPart.Position + self:GetFaceDirection()*_L.Bakery.VOXEL_SIZE
	
	_L.Functions.FastTween(
		characterModel.PrimaryPart,
		{CFrame = CFrame.new(targetPosition, self.model.PrimaryPart.Position)},
		{0.15, "Quad", "Out"}
	)
	
--	characterModel:SetPrimaryPartCFrame(CFrame.new(targetPosition, self.model.PrimaryPart.Position))
	self.stateData.interactingHumanoidModel = characterModel
end

-- @classmethod
-- undoes Appliance:FreeHumanoid(), allowing it to move again
function Appliance:FreeHumanoid()
	if not self.stateData.interactingHumanoidModel then
		
		-- the only case where there's no humanoid is if a player interacted with
		-- the appliance.  so, delete activated cooking debounce
		
		if player:FindFirstChild("__ACTIVATED_COOKING") then
			player.__ACTIVATED_COOKING:Destroy()
		end
		
		return
	end
	
	local characterModel = self.stateData.interactingHumanoidModel
	
	characterModel.HumanoidRootPart.Anchored = false
	self.stateData.interactingHumanoidModel = nil
end

function Appliance:ResetAllStates()
	if self.data.subClass == "Oven" then
		if self.stateData.isPinging then
			self.stateData.pingUI:Destroy()
		end
		self.stateData.isPinging = false
		self.stateData.pingUI = nil
		
		self.stateData.isCooking = false
		self.stateData.cookingUI = nil
		self.stateData.interactingHumanoidModel = nil
	elseif self.data.subClass:find("Order Stand") then
		self.stateData.foodOrderQueue = {}
		self.stateData.foodReadyList = {}
		
		for _, child in ipairs(self.stateData.orderStandUI.MainFrame:GetDescendants()) do
			if child.Name == "ServeItem" or child.Name == "CookItem" then
				child:Destroy()
			end
		end
	end
end

return Appliance
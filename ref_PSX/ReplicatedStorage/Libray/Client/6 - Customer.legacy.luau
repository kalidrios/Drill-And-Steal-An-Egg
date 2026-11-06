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


--------|    Variables    |--------
local player = game.Players.LocalPlayer

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local Customer = {}
function Customer.InitAlienCustomer(p14) -- Line: 263
	task.spawn(function() -- Line: 264
		--[[
			Upvalues:
				[1] = p14
		--]]
		p14:CreateAlienPortal();
	end);
end


-- @static
function Customer.new(ID, UID, parentBakery, parentFloor)
			
	local super = _L.Entity.new(ID, UID, "Customer", parentBakery, parentFloor)
	local self = setmetatable(super, {__index = function(t, key) return Customer[key] or _L.Entity[key] end})
	
	--[[
		list of customer states:
		WalkingToQueueSpot
		WaitingForSeat
		WalkingToSeat
		ThinkingAboutOrder
		DecidedOnOrder
		WaitingToOrder
		WaitingForFood
		EatingFood
		ReadyToExit
		WalkingToExit
	--]]
	self.state = "WaitingForSeat"
	
	-- misc data for information about each state
	self.stateData = {
		
		-- UID of the TARGETED seat.  E.g. when I'm in line, the UID of t
		-- seat that I've been promised
		seatUID = nil;
		
		-- UID of the TARGETED table.  e.g. when I'm in line, the UID of
		-- the table that I've been promised
		tableUID = nil;
		
		-- integer position in the queue.  Updates automatically when
		-- other customers leave the queue
		queuePosition = nil;
		
		-- whether or not the customer has been seated at a table
		isSitting = false;
		
		-- other customers in the queue group.  note: SELF IS NOT IN
		-- THIS TABLE
		queueGroup = {};
		
		-- whether or not I am currently walking
		busyWalking = false;
		
		-- food object that has been ordered
		foodOrder = nil;
		
		-- ping for delivery of food
		deliveryPingUI = nil;
		
		-- when the user delivers food to me, a path is draw.  the parts of
		-- the path are stored in a folder (which is pathToMe)
		pathToMe = nil;
		
		-- for celebrity customers... counts how many customers are approaching
		celebrityApproachCount = 0;
	}
	
	self.cachedLeftHipCF = nil
	self.cachedRightHipCF = nil
	self.chatBox = nil
	self.humanoid = self.model:WaitForChild("Humanoid")
	self.humanoid.WalkSpeed = self.data.walkSpeed
	
	-- init humanoid animations
	self:InitHumanoidAnimations()

	-- no collisions between NPCs	
	for i, v in ipairs(self.model:GetDescendants()) do
		if v:IsA("BasePart") then
			_L.Services.PhysicsService:SetPartCollisionGroup(v, "NPCGroup")
		end
	end
	
	-- BONUS: should the customer get a Lei?
	if parentBakery.nameCounters["Epic Totem"] > 0 and math.random() < 0.25 then
		self:EquipLei()
	end
	
	-- BONUS: skeleton face?
	if parentBakery.nameCounters["Haunted Statue"] > 0 then
		local face = self.model.Head:FindFirstChildOfClass("Decal")
		if face then
			face.Texture = "http://www.roblox.com/asset/?id=49493144"
		end
	end
	
	-- santa customer?
	if self.ID == "27" then
		self:InitSantaCustomer()
	end
	
	-- elf customer?
	if self.ID == "28" then
		self:InitElfCustomer()
	end
	
	if self.ID == "32" then
		self:InitAlienCustomer()
	end
	
	self:SetRenderStatus(parentBakery.doRender or true);

	return self
	
end

-- @static
function Customer.FromUIDData(parentBakery, parentFloor, customerUIDData)
	local self = Customer.new(customerUIDData.ID, customerUIDData.UID, parentBakery, parentFloor)
	
	self.xVoxel = customerUIDData.XVoxel or 1
	self.yVoxel = 0
	self.zVoxel = customerUIDData.ZVoxel or 1
	self:UpdateVoxelPosition()
	
	-- customers are nil until added to queue
	if self:BelongsToMyBakery() then
		self.cachedParent = self.model.Parent
		self.model.Parent = nil
		
		-- also make them invisible
		for _, child in ipairs(self.model:GetDescendants()) do
			if child:IsA("BasePart") then
				child.Transparency = 1
			end
		end
	end
	
	-- am I a rich customer?
	if customerUIDData.RichCustomer then
		self.isRichCustomer = true
	end
	
	local myWorldPosition = parentFloor:WorldPositionFromVoxel(self.xVoxel, self.yVoxel, self.zVoxel) + Vector3.new(0, self.model.PrimaryPart.Size.Y/2, 0)
	self.model:SetPrimaryPartCFrame(CFrame.new(myWorldPosition))
		
	-- if this customer doesn't belong to me, then its state is already
	-- stored in the UIDData.  only update it if necessary
	if not self:BelongsToMyBakery() then
		self:CustomerStateChangedByReplication(customerUIDData.CurrentState, customerUIDData.CurrentStateData)
	end
	
	return self
end

-- @static
function Customer.CreateRandomCustomer(UIDProvidedByServer, startX, startY, startZ)
	return _L.Entity.FromUIDData(_L.Variables.MyBakery, UIDProvidedByServer)
end 

function Customer.SetRenderStatus(p9, p10) -- Line: 222
	p9.doRender = p10;
end
-- @classmethod
local presentEntries = {}
function Customer:DropPresent()
	if _L.Functions.DictionaryLength(presentEntries) >= 10 then
		return
	end
	local UID = _L.Network.Invoke("Santa_RequestPresentUID", self.UID)
	if not UID then
		return
	end
	local present = game.ReplicatedStorage.Assets.Models.SantaPresent:Clone()
	_L.Services.PhysicsService:SetPartCollisionGroup(present.PrimaryPart, "PresentGroup")
	present:SetPrimaryPartCFrame(CFrame.new(self.model.PrimaryPart.CFrame.p))
	present.PrimaryPart.Velocity = Vector3.new(
		math.random() - 0.50,
		math.random() - 0.50,
		math.random() - 0.50
	)*20
	present.Parent = workspace.__DEBRIS
	presentEntries[UID] = present
	local interact, destroyer = _L.Interact.Add(present.PrimaryPart, 8)
	interact:Connect(function()
		_L.Network.Fire("Santa_PickUpGift", UID, present.PrimaryPart.Position)
		destroyer()
		present:Destroy()
		presentEntries[UID] = nil
	end)
end
_L.Network.Fired("Santa_GiftPickedUp"):Connect(function(award, position)
	_L.CustomUIEffects.CreateRewardBillboard(position, award)
	_L.SFX.Play(6106143051, position)
end)

-- @classmethod
function Customer:InitElfCustomer()
	
end

-- @classmethod
function Customer:InitSantaCustomer()
	coroutine.wrap(function()
		while true do
			if self.isDeleted then
				break
			end
			
			wait(math.random(2, 7))
			local skipStates = {
				ThinkingAboutOrder = true,
				DecidedOnOrder = true,
				WaitingToOrder = true,
				WaitingForFood = true,
				EatingFood = true
			}
			if skipStates[self.state] then
				continue
			end
			
			self:DropPresent()
		end
	end)()
end

-- @classmethod
function Customer:DisplayMyClothing(doShow)
	

end

-- @classmethod
function Customer:GetMyTransparency()
	return self:IsGhostCustomer() and 0.40 or 0.00
end

-- @classmethod
function Customer:ToUIDData()
	return {
		ClassName = "Customer",
		ID = self.ID;
		UID = self.UID;
		FloorLevel = self:GetMyFloor().floorLevel;
		XVoxel = self.xVoxel;
		YVoxel = self.yVoxel;
		ZVoxel = self.zVoxel;
		CurrentState = self.state;
	}
end

-- @classmethod
function Customer:IsHauntedHorseman()
	return self.ID == "25"
end

-- @classmethod
function Customer:InitHumanoidAnimations()
	
	self.animations = {}
	self.runningAnimation = nil
	
	local walkAnimation = Instance.new("Animation")
	if self:IsSpecialCustomer() or self:IsGhostCustomer() or self:IsHauntedHorseman() then
		walkAnimation.AnimationId = "http://www.roblox.com/asset/?id=616006778"
	elseif self:IsPirateCustomer() then
		walkAnimation.AnimationId = "rbxassetid://750785693"
	else
		walkAnimation.AnimationId = "rbxassetid://913402848"
	end
	
	local idleAnimation = Instance.new("Animation") --by roblox
	idleAnimation.AnimationId = "rbxassetid://507766388"
	
	local eatAnimation = Instance.new("Animation")
	eatAnimation.AnimationId = "rbxassetid://9379343400"
	
	local menuAnimation = Instance.new("Animation")
	menuAnimation.AnimationId = "rbxassetid://9379339456"
	
	local waveAnimation = Instance.new("Animation") -- by robloox
	waveAnimation.AnimationId = "rbxassetid://507770239"
	
	local gamingAnimation = Instance.new("Animation")
	gamingAnimation.AnimationId = "rbxassetid://9379348777"
	
	self.animations.gaming = self.humanoid:LoadAnimation(gamingAnimation)
	self.animations.gaming.Looped = true
	
	self.animations.walking = self.humanoid:LoadAnimation(walkAnimation)
	self.animations.walking.Looped = true
	
	self.animations.idle = self.humanoid:LoadAnimation(idleAnimation)
	self.animations.idle.Looped = true
	
	self.animations.eating = self.humanoid:LoadAnimation(eatAnimation)
	self.animations.eating.Looped = true
	
	self.animations.menu = self.humanoid:LoadAnimation(menuAnimation)
	self.animations.menu.Looped = true
	
	self.animations.wave = self.humanoid:LoadAnimation(waveAnimation)
	self.animations.wave.Looped = false
	
	gamingAnimation:Destroy()
	idleAnimation:Destroy()
	eatAnimation:Destroy()
	menuAnimation:Destroy()
	waveAnimation:Destroy()
	
	-- humanoid should initially be idle
	self.animations.idle:Play()
	
end

-- @classmethod
function Customer:PlayLoadedAnimation(animName)
	self.runningAnimation = nil
	for _, anim in pairs(self.animations) do
		anim:Stop()
	end
	if self.animations[animName] and self:ShouldPlayAnimation(animName) then
		
		-- animation optimization.  only play the animation if the player is on this floor
		if self:PlayerIsOnMyFloor() then
			self.animations[animName]:Play()
		end
		self.runningAnimation = animName
	end
end

-- @classmethod
function Customer:StopLoadedAnimation(animName)
	if self.animations[animName] then
		self.animations[animName]:Stop()
		self.runningAnimation = nil
	end
end

-- @classmethod
-- called when the player teleports to a floor that isn't my floor
-- in this case, we want to stop the animation that is currently
-- playing.  notice that self.runningAnimation is not set to
-- nil, meaning that this animation will be restarted (if necessary)
-- when the player teleports back to this floor
function Customer:PauseCurrentAnimation()
	if not self.runningAnimation then
		return
	end
	self.animations[self.runningAnimation]:Stop()
end

function Customer:RestartCurrentAnimation()
	if not self.runningAnimation then
		return
	end
	self.animations[self.runningAnimation]:Play()
end

-- @classmethod
-- second argument is a callback that is called when the chatbox is clicked.
-- an argument to that callback is a 'destroyer' function.  When called, the
-- chatbox is destroyed
function Customer:Chat(message, clickEvent, properties)
	
	if self.chatBox then
		self.chatBox:Destroy()
	end
	
	self.chatBox = _L.CustomUIEffects.CustomerChatBox(self.model:FindFirstChild("Head"), message)
	if properties then
		for prop, value in pairs(properties) do
			self.chatBox.MainFrame[prop] = value
		end
	end
	
	if clickEvent then
		return self.chatBox.MainFrame.Message.MouseButton1Down:Connect(function()
			clickEvent(function() 
				if not self.chatBox then
					return
				end
				self.chatBox:Destroy() 
				self.chatBox = nil 
			end)
		end)
	end
	
end

-- @classmethod
-- cleans up my interact, and interacts of my group members
function Customer:CleanupGroupInteract()
	self:CleanupInteract()
	for _, partner in ipairs(self.stateData.queueGroup) do
		partner:CleanupInteract()
	end
end

-- @classmethod
function Customer:StopGroupEmoji()
	self:StopEmoji()
	for _, partner in ipairs(self.stateData.queueGroup) do
		partner:StopEmoji()
	end
end

-- @classmethod
function Customer:StopChat()
	if self.chatBox then
		self.chatBox:Destroy()
	end
	
	self.chatBox = nil
end

-- @classmethod
function Customer:CustomerStateChangedByReplication(state, data)
	
	self.state = state
	self.currentStateData = data or {}
	
	if self:BelongsToMyBakery() then
		return
	end
	
	if self.state == "WalkingToQueueSpot" or self.state == "WaitingForSeat" then
		self:Emoji("WaitingForSeat")
		return
	end
	
	self:StopEmoji()
	
	if self.state == "WalkingToExit" then
		self:Emoji("HappyEmoji")
		self:StandUp()
		return
	end
	
	local myBakery = self:GetMyBakery()
	local seatLeaf = myBakery:GetEntityByUID(self.currentStateData.seatUID)
	local tableLeaf = myBakery:GetEntityByUID(self.currentStateData.tableUID)
	
	if not seatLeaf or not tableLeaf then
		print("Init replicated state error: no seat leaf or table leaf", state)
		return
	end
	
	if not self.stateData.isSitting then
		self:SitInSeat(seatLeaf)
	end
	
	if self.state == "ThinkingAboutOrder" then
		self:ReadMenu()
	elseif self.state == "WaitingToOrder" then
		self:StopReadingMenu()
		self:Emoji("WaitingToOrder")
	elseif self.state == "EatingFood" then
		if data.foodCFrame then
			self.stateData.foodOrder = _L.Food.new(data.foodID, self.UID)
			self:CreateMyFoodModel(data.foodCFrame)
			self:PlayLoadedAnimation("eating")
		end
	elseif self.state == "ReadyToExit" then
		if self.stateData.foodOrder then
			self.stateData.foodOrder:DestroyModel()
			self.stateData.foodOrder = nil
			self:StopLoadedAnimation("eating")
		end
		
		-- replace with dirty dish
		--[[
		if data.foodCFrame then
			self.stateData.foodOrder = _L.Food.new(data.foodID, self.UID)
			self:CreateMyFoodModel(data.foodCFrame)
			self.stateData.foodOrder:ChangeToDirtyDish()
		end
		]]
	end
end

-- @classmethod
-- if my bakery sends an update to the server with new UID data
-- optionally, each state may contain a dictionary of values that
-- can be used to help replication partners when they are added
	
--[[
	list of customer states:
	WalkingToQueueSpot
	WaitingForSeat
	WalkingToSeat
	ThinkingAboutOrder
	DecidedOnOrder
	WaitingToOrder
	WaitingForFood
	EatingFood
	ReadyToExit
	WalkingToExit
--]]
function Customer:SetCustomerState(customerState)
	
	if not self:BelongsToMyBakery() then
		return
	end
	
	self.state = customerState
	
	local function getExtraData()
		local extraData = {}
		
		if customerState == "WalkingToQueueSpot" or customerState == "WaitingForSeat" or
		   customerState == "WalkingToSeat" then
			return extraData
		end
		
		extraData.seatUID = self.stateData.seatUID
		extraData.tableUID = self.stateData.tableUID

		if customerState == "ThinkingAboutOrder" or customerState == "DecidedOnOrder" or 
		   customerState == "WaitingToOrder" then
			return extraData
		end
		
		if self.stateData.foodOrder then
			extraData.foodID = self.stateData.foodOrder.ID
			if self.stateData.foodOrder.model then
				extraData.foodCFrame = self.stateData.foodOrder.model:GetPrimaryPartCFrame()
			end
		end
		
		if customerState == "WaitingForFood" then
			return extraData
		end
		
		return extraData
	end
	
	-- to improve replication, we will network whenever a customer state changes
	-- this allows us to already know the state of each customer when a
	-- replication child is added
	_L.Signal.Fire("MUTATE_CustomerStateChanged", self.UID, customerState, getExtraData())
end

-- @classmethod
function Customer:ChangeToWaitingForFoodState(foodOrder)

	self.stateData.foodOrder = foodOrder	
						
	self:PlayLoadedAnimation("idle")
	self:SetCustomerState("WaitingForFood")	
	
end

-- @classmethod
function Customer:ReadyToOrder()
	
	if self.state ~= "DecidedOnOrder" then
		return
	end
	self:SetCustomerState("WaitingToOrder")
	
	self:PlayLoadedAnimation("idle")
	
	self:Emoji("WaitingToOrder", true)
	self:Interact(function(destroyer)
	
		if self.isDeleted or self.state ~= "WaitingToOrder" then
			return
		end
		
		-- click sound
		_L.Audio.Play(5074101610, player.PlayerGui)
		
		local myFloor = self:GetMyFloor()
		local orderStand = myFloor:FindOrderStandOnAnyFloor()
		if not orderStand then
			_L.Alert.Message("Place an Order Stand to take a customer's order.")
			return
		end
		
		destroyer()
		self:StopEmoji()
		
		local foodOrder = _L.Food.RandomFoodChoice(self.UID, self.ID, self:IsRichCustomer(), self:IsPirateCustomer(), self.isNearTree)
		orderStand:AddFoodToQueue(foodOrder)
		self:ChangeToWaitingForFoodState(foodOrder)
	end)
end

-- @classsmethod
function Customer:SitInSeat(seat)
	
	local sitOffset = Vector3.new(0, 1.3, 0)
	local seatPart = seat.model.PrimaryPart
	local faceDirection = seat:GetFaceDirection()
	local sitPosition = seat.model.PrimaryPart.SeatAttachment.WorldPosition + sitOffset
	local newPrimaryPartCF = CFrame.new(sitPosition + faceDirection*0.40, sitPosition + faceDirection)
	self.stateData.isSitting = true
	self.stateData.mySeat = seat
	self.model.HumanoidRootPart.Anchored = true
	
	local TWEEN_TO_SIT_TIME = 0.30
	
	-- tween legs to sit position
	if not self.cachedLeftHipCF then
		self.cachedLeftHipCF = self.model.LeftUpperLeg.LeftHip.C0
		self.cachedRightHipCF = self.model.RightUpperLeg.RightHip.C0
	end
	_L.Functions.FastTween(
		self.model.LeftUpperLeg.LeftHip,
		{C0 = CFrame.new(-0.35, -0.5, 0) * CFrame.Angles(math.rad(75), 0, 0)},
		{TWEEN_TO_SIT_TIME, "Quad", "Out"}
	)
	_L.Functions.FastTween(
		self.model.RightUpperLeg.RightHip,
		{C0 = CFrame.new(0.35, -0.5, 0) * CFrame.Angles(math.rad(75), 0, 0)},
		{TWEEN_TO_SIT_TIME, "Quad", "Out"}
	)
	
	-- tween model to sit position
	return _L.Functions.FastTween(
		self.model.PrimaryPart,
		{CFrame = newPrimaryPartCF},
		{TWEEN_TO_SIT_TIME, "Quad", "Out"}
	)
end

-- @classmethod
function Customer:ReadMenu()
	
	if not self.model then
		return
	end
	
	-- read the menu
	self:PlayLoadedAnimation("menu")
	
	-- hold menu object and weld it
	local menuModel = game.ReplicatedStorage.Assets.Models.MenuModel:Clone()
	local weld = Instance.new("Weld")
	weld.Part0 = self.model.RightHand
	weld.Part1 = menuModel.PrimaryPart
	weld.C0 = CFrame.new(-0.80, -0.40, 0) * CFrame.Angles(0, math.pi, -math.pi/8)
	weld.Parent = menuModel.PrimaryPart
	for _, part in ipairs(menuModel:GetChildren()) do
		local weldC = Instance.new("WeldConstraint")
		weldC.Parent = menuModel.PrimaryPart
		weldC.Part0 = menuModel.PrimaryPart
		weldC.Part1 = part
	end
	menuModel.Parent = self.model
	self.stateData.menuModel = menuModel
end

function Customer:StopReadingMenu()
	
	self:StopLoadedAnimation("menu")	
	if self.stateData.menuModel then
		self.stateData.menuModel = self.stateData.menuModel:Destroy()
	end
end

-- @classmethod
function Customer:ChangeToWaitForOrderState()
	
	if self.state ~= "WalkingToSeat" then
		return
	end

	local seatLeaf = self:EntityTable()[self.stateData.seatUID]
	local tableLeaf = self:EntityTable()[self.stateData.tableUID]
			
	if seatLeaf.isDeleted or tableLeaf.isDeleted then
		self:ForcedToLeave()
		return
	end
	
	self:SetCustomerState("ThinkingAboutOrder")
	
	-- make the humanoid sit
	self:SitInSeat(seatLeaf).Completed:Connect(function()
		self.humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
		
		-- change voxel position to match the seat
		self.xVoxel = seatLeaf.xVoxel
		self.zVoxel = seatLeaf.zVoxel
		
		coroutine.wrap(function()
			wait(0.35)
			
			-- start reading the menu
			self:ReadMenu()
			
			-- pause for time
			if _L.Variables.MyBakery.isTutorial then
				wait(4.5)
			else
				wait(7.5 + math.random()*6)
			end
			if self.isDeleted or self.state ~= "ThinkingAboutOrder" then
				return
			end
			
			-- stop reading the menu
			self:StopReadingMenu()
			
			-- advance to next state
			self:SetCustomerState("DecidedOnOrder")
			
			-- only set my entire group to ready to order when everybody has decided on the order
			local myGroup = {self}
			for _, partner in ipairs(self.stateData.queueGroup) do
				if not partner.isDeleted then
					table.insert(myGroup, partner)
				end
			end
			local foundUndecidedMember = false
			for _, groupMember in ipairs(myGroup) do
				if groupMember.state ~= "DecidedOnOrder" then
					foundUndecidedMember = true
					break
				end
			end
			
			-- if the entire group is ready, then have them say it in sync
			if not foundUndecidedMember then
				for _, groupMember in ipairs(myGroup) do
					groupMember:ReadyToOrder()
				end
			end
			
		end)()
	end)

end

-- @classmethod
function Customer:ResetAllStates()
end

-- @classmethod
function Customer:ChangeToReadyToExitState(forceLeaveTip)
	
	self:SetCustomerState("ReadyToExit")
	self:PlayLoadedAnimation("idle")
	
	-- my dish goes into the floor's dishChairs table
	local mySeat = self:EntityTable()[self.stateData.seatUID]
	local myFloor = self:GetMyFloor()
	local foodOrder = self.stateData.foodOrder
	mySeat.stateData.dish = foodOrder
	table.insert(myFloor.dishChairs, mySeat)
	
	-- create money model.
	local function getOrientation()
		if mySeat.stateData.cachedFaceDirection then
			local fd = mySeat.stateData.cachedFaceDirection
			return (
				fd == Vector3.new(1, 0, 0) and math.pi/2 or
				fd == Vector3.new(0, 0, 1) and math.pi or
				fd == Vector3.new(-1, 0, 0) and 3*math.pi/2 or 0
			)
		else
			return math.rad(mySeat.model.PrimaryPart.Orientation.Y)
		end
	end
	foodOrder:InitMoneyModel(getOrientation() + math.pi/2, self:IsVIPCustomer() or self:IsRichCustomer() or self:IsGhostCustomer() or self:IsSpecialCustomer())
	
	-- if auto money collect gamepass, then pick up right away
	if _L.Gamepasses.Owns(_L.Directory.Gamepasses["AutoCashCollect"].ID) and _L.PlayerSettings.IsEnabled("Gamepasses") then
		foodOrder:MoneyPickedUp()
	end
	
	coroutine.wrap(function()
		-- if tutorial, pause on the interaction until the money is picked up
		if _L.Variables.MyBakery.isTutorial then
			repeat wait() until _L.Variables.MyBakery.tutorial.readyForUserToWash
		end
		
		-- click on a dish to bring it to the dishwasher
		foodOrder:Interact(function(interactDestroyer)
			
			-- tutorial lock?
			if _L.Variables.MyBakery.isTutorial and not _L.Variables.MyBakery.tutorial.readyForUserToWash then
				return
			end
			
			-- only allow one player action at a time
			if _L.Variables.MyBakery.animatedPath then
				_L.Alert.Message("You cannot do that right now.")
				return
			end
			
			local allowExtraMaxDishUID = foodOrder.flaggedDishwasherUID	
			
			local dishwashers = myFloor:GatherDishwashersOnAnyFloor(allowExtraMaxDishUID)
			if #dishwashers == 0 then
				_L.Alert.Message("All sinks/dishwashers are currently full.")
				return
			end
			
			-- if a waiter targets this dish, it is instantly removed from dishChairs.
			-- so, only allow the user to get the dish if a waiter isn't going for it
			local stillExistsForUser = false
			for i, dishChair in ipairs(myFloor.dishChairs) do
				if dishChair == mySeat then
					stillExistsForUser = true
					table.remove(myFloor.dishChairs, i)
					break
				end
			end
			
			-- dead code, should never be reached.  but leave in
			if not stillExistsForUser then
				_L.Alert.Message("A waiter is already coming to get this dish.")
				return
			end
			
			-- tutorial signal
			if _L.Variables.MyBakery.isTutorial then
				_L.Signal.Fire("Tutorial_DishPickedUp")
			end
			
			-- dish sound
			if foodOrder.model then
				local dishSounds = {5205173686, 5205173942}
				_L.SFX.Play(dishSounds[math.random(#dishSounds)], foodOrder.model:GetPrimaryPartCFrame().p)
			end
			
			-- delete the dish model
			if not mySeat.isDeleted then
				mySeat.stateData.dish = nil
			end
			foodOrder:DestroyModel()
			foodOrder:CleanupInteract()
			
			-- pick up the money (only if necessary)
			foodOrder:MoneyPickedUp()
			
			-- hold the dish model
			_L.PlayerAnimations.HoldModel(game.ReplicatedStorage.Assets.BakeryEntityAssets.Food.DirtyDish)
			
			-- grab a random dishwasher, ping it
			local dishwasher = dishwashers[math.random(#dishwashers)]
			dishwasher.stateData.dishWasherTargetCount += 1
			dishwasher.stateData.dishwasherUI.Enabled = false
			dishwasher:Emoji("DishEmoji", true)
			dishwasher:Interact(function(interactDestroyer)
				dishwasher.stateData.dishwasherUI.Enabled = true
				dishwasher:AddDish()
	
				_L.Variables.MyBakery:CleanupAnimatedPath()			
				interactDestroyer()
				dishwasher:StopEmoji()
				_L.PlayerAnimations.DropModel()
				
				-- tutorial event
				if _L.Variables.MyBakery.isTutorial then
					_L.Signal.Fire("Tutorial_StartedWashing")
				end
							
				-- award player experience
				_L.Network.Fire("AwardBakeryExperienceWithVerification")
			end)
			
			-- animate a path to the dishwasher
			mySeat:AnimatePathToEntity(dishwasher)
			
		end)
	end)()	
	
	-- gather my group
	local entireCustomerGroup = {self}
	for i, v in ipairs(self.stateData.queueGroup) do
		table.insert(entireCustomerGroup, v)
	end
	
	-- make sure everyone is done eating
	for i, v in ipairs(entireCustomerGroup) do
		if v.state ~= "ReadyToExit" then
			return
		end
	end

	-- the entire group is ready to leave!	
	for i, v in ipairs(entireCustomerGroup) do
		if not v.isDeleted then
			v:ChangeToExitingState(false, forceLeaveTip)
		end
	end
				
end

-- @classmethod
function Customer:RecheckGroupFinishedEating()
	
	-- gather my group
	local entireCustomerGroup = {self}
	for i, v in ipairs(self.stateData.queueGroup) do
		table.insert(entireCustomerGroup, v)
	end
	
	-- make sure everyone is done eating
	for i, v in ipairs(entireCustomerGroup) do
		if v.state ~= "ReadyToExit" then
			return
		end
	end

	-- the entire group is ready to leave!	
	for i, v in ipairs(entireCustomerGroup) do
		if not v.isDeleted then
			v:ChangeToExitingState(false)
		end
	end
	
end

-- @classmethod
function Customer:LeaveBakery()
		
	if self.isDeleted then
		return
	end
	
	-- the customer's seats are considered 'taken' until the customer
	-- has completely left the store
	local mySeat = self:EntityTable()[self.stateData.seatUID]
	if mySeat and not mySeat.isDeleted then
		self:EntityTable()[self.stateData.seatUID]:SetIsOccupied(nil)
	end
	
	-- remove from floor table
	local myFloor = self:GetMyFloor()
	for i, customer in ipairs(myFloor.customers) do
		if customer == self then
			table.remove(myFloor.customers, i)
			break
		end
	end
	
	if self:BelongsToMyBakery() then
		_L.Replication.SendEvent("CustomerDestroyed", self.UID)
		
		-- disable celebrity flag
		_L.Variables.MyBakery.activeCelebrity = false
	end
	
	self:Cleanup()

end

-- @classmethod
function Customer:ForcedToLeave()
	
	if not self:BelongsToMyBakery() then
		return
	end
	
	-- delete the customer's food
	if self.stateData.foodOrder then
		if self.stateData.foodOrder.moneyModel then
			self.stateData.foodOrder:MoneyPickedUp()
		end
		self.stateData.foodOrder:CleanupInteract()
		self.stateData.foodOrder:DestroyModel()
		self.stateData.foodOrder.isDeleted = true
		
		if self.stateData.foodOrder.associatedListItem then
			self.stateData.foodOrder.associatedListItem:Destroy()
		end
		
		-- remove food order from all order stands
		for _, floor in ipairs(_L.Variables.MyBakery.floors) do
			local orderStands = floor:GetEntitiesFromClassAndSubClass("Appliance", "Order Stand")
			for _, stand in ipairs(orderStands) do
				stand:CleanupFoodObjectFromBothLists(self.stateData.foodOrder)
			end
		end
		
		self.stateData.foodOrder = nil
	end
	
	-- if animating path to customer, stop
	if self == self:GetMyBakery().animatedPathTargetEntity then
		self:GetMyBakery():CleanupAnimatedPath()
		_L.PlayerAnimations.DropModel()
	end
	
	-- delete me from the queue, if i'm in it
	local queue = _L.Variables.MyBakery.customerQueue
	for i, queueRow in ipairs(queue) do
		local foundCustomer = false
		for j, customer in ipairs(queueRow) do
			if customer == self then
				table.remove(queueRow, j)
				foundCustomer = true
				if #queueRow == 0 then
					table.remove(queue, i)
				end
				break
			end
		end
		if foundCustomer then
			break
		end
	end
	
	-- delete myself from all group member's groups
	for _, partner in ipairs(self.stateData.queueGroup) do
		if partner.isDeleted then
			continue
		end
		for i, search in ipairs(partner.stateData.queueGroup) do
			if self == search then
				table.remove(partner.stateData.queueGroup, i)
				partner:RecheckGroupFinishedEating()
				break
			end
		end
	end
	
	-- clear all interactions
	self:CleanupInteract()
	
	-- walk out
	self:ChangeToExitingState(true)
	
end

-- @classmethod
function Customer:IsVIPCustomer()
	return self.ID == "13"
end

-- @classmethod
function Customer:IsSpecialCustomer()
	return self.ID == "14"
end

-- @classmethod
function Customer:IsPirateCustomer()
	return self.ID == "21"
end

-- @classmethod
function Customer:IsGhostCustomer()
	return self.ID == "15"
end

-- @classmethod
function Customer:IsCelebrityCustomer()
	return self.ID == "20"
end

-- @classmethod
function Customer:IsRichCustomer()
	return self.isRichCustomer
end

-- @classmethod
function Customer:StandUp()
	self.stateData.isSitting = false
	self.model.HumanoidRootPart.Anchored = false
	self.humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
	
	-- fix leg welds
	if self.cachedLeftHipCF and self.cachedRightHipCF then
		self.model.LeftUpperLeg.LeftHip.C0 = self.cachedLeftHipCF
		self.model.RightUpperLeg.RightHip.C0 = self.cachedRightHipCF
	end
end

-- @classmethod
function Customer:ChangeToExitingState(wasForcedToLeave, forcedToLeaveTip)
		
	if self.isDeleted then
		return
	end
	
	self.leaving = true
	self:SetCustomerState("WalkingToExit")
	
	-- remove customer from table
	local myTable = self:EntityTable()[self.stateData.tableUID]
	if myTable and not myTable.isDeleted then
		myTable:RemoveCustomerFromTable(self)
	end
	
	local myFloor = self:GetMyFloor()
				
	coroutine.wrap(function()
		if wasForcedToLeave then
			self:TimedEmoji("MadEmoji", 2)
		else
			if math.random() < 0.30 or _L.Variables.MyBakery.isTutorial then
				self:TimedEmoji("HappyEmoji", 2.5)
			end
		end
		
		-- make humanoid stand
		self:StandUp()
		
		local function goToExitAndLeave()
			self:WalkToNewFloor(_L.Variables.MyBakery.floors[1], function()
				local vx, vy, vz = _L.Variables.MyBakery:GetCustomerStartVoxel(1)
				self:WalkToPoint(vx, vy, vz, function()	
					self:FadeTransparency(1, function()
						self:LeaveBakery()
					end)					
				end, nil, true)
			end)
		end
		
		local isLeavingTip = false
		local isGoingForGumball = false
		local isGoingForCandy = false
		local isGoingForArcade = false
		local isGoingForPopcorn = false
		local isGoingForSoda = false
		local isGoingForBowl = false
						
		-- is there a tip jar on this floor? if so, roll to leave tip
		if not wasForcedToLeave then
			local tipJars = myFloor:GetEntitiesFromClassAndSubClass("Appliance", "Tip Jar")
			if #tipJars > 0 then
				for _, tipJar in ipairs(tipJars) do
					local tipChance = tipJar.ID == "14" and 0.05 or tipJar.ID == "19" and 0.50 or tipJar.ID == "26" and 0.40 or 0
					if math.random() < tipChance or forcedToLeaveTip or self:IsVIPCustomer() then
						isLeavingTip = true
						self:WalkToPoint(tipJar.xVoxel, tipJar.yVoxel, tipJar.zVoxel, function()
							if tipJar.isDeleted or self.isDeleted or not self.stateData or not self.stateData.foodOrder then
								goToExitAndLeave()
								return
							end
							
							-- happy emoji at tip jar
							self:TimedEmoji("VeryHappyEmoji", 2.5)
							
							_L.Network.Fire("AwardTipWithVerification", self.UID, tipJar.UID, self.stateData.foodOrder.ID)
							_L.SFX.Play(5839737230, tipJar.model.PrimaryPart)
							
							self:FaceEntity(tipJar)
							wait(0.30)
							goToExitAndLeave()
						end)
						break
					end
				end
			end
		end
		
		if not isLeavingTip then
			local candyBowls = myFloor:GetEntitiesFromClassAndSubClass("Appliance", "CandyBowl")
			if #candyBowls > 0 then
				for _, bowl in ipairs(candyBowls) do
					if math.random() < 1 and bowl.level and bowl.level > 0 then
						isGoingForBowl = true
						self:WalkToPoint(bowl.xVoxel, bowl.yVoxel, bowl.zVoxel, function()
							if bowl.isDeleted or not self.stateData or not self.stateData.foodOrder or bowl.level <= 0 then
								goToExitAndLeave()
								return
							end
							
							-- happy emoji at tip jar
							self:TimedEmoji("VeryHappyEmoji", 2.5)

							_L.Network.Fire("AwardTipWithVerification", self.UID, bowl.UID, self.stateData.foodOrder.ID)
							_L.SFX.Play(5057746151, bowl.model.PrimaryPart)

							self:FaceEntity(bowl)
							wait(0.30)
							goToExitAndLeave()
						end)
						break
					end
				end
			end
		end
		
		-- only go for gumball if we're not leaving a tip
		if not isLeavingTip and not isGoingForBowl then
			
			local gumballMachines = myFloor:GetEntitiesFromClassAndSubClass("Appliance", "GumballMachine")
			if #gumballMachines > 0 then
				for _, gumballMachine in ipairs(gumballMachines) do
					if math.random() < 0.10 then
						isGoingForGumball = true
						
						local fx, fy, fz = gumballMachine:GetFacePosition()
						if not myFloor:IsValidVoxel(fx, fy, fz) then
							fx, fy, fz = gumballMachine.xVoxel, gumballMachine.yVoxel, gumballMachine.zVoxel
						end
						self:WalkToPoint(fx, fy, fz, function()
							if gumballMachine.isDeleted or self.isDeleted then
								goToExitAndLeave()
								return
							end
							
							-- gumball tip
							if self.stateData.foodOrder then
								_L.Network.Fire("AwardTipWithVerification", self.UID, gumballMachine.UID, self.stateData.foodOrder.ID)
							end
							
							-- gumball sound
							_L.SFX.Play(5205171179, gumballMachine.model.PrimaryPart.Position)
							
							-- gumball emoji
							self:TimedEmoji("VeryHappyEmoji", 2.5)
							self:FaceEntity(gumballMachine)
							wait(0.30)
							goToExitAndLeave()
						end)
						break
					end
				end
			end
			
		end
		
		if not isLeavingTip and not isGoingForGumball and not isGoingForBowl then
			local candyMachines = myFloor:GetEntitiesFromClassAndSubClass("Appliance", "CandyMachine")
			if #candyMachines > 0 then
				for _, candyMachine in ipairs(candyMachines) do
					if math.random() < 0.10 then
						isGoingForCandy = true
						
						local fx, fy, fz = candyMachine:GetFacePosition()
						if not myFloor:IsValidVoxel(fx, fy, fz) then
							fx, fy, fz = candyMachine.xVoxel, candyMachine.yVoxel, candyMachine.zVoxel
						end
						self:WalkToPoint(fx, fy, fz, function()
							if candyMachine.isDeleted or self.isDeleted then
								goToExitAndLeave()
								return
							end
							
							_L.SFX.Play(5601560734, candyMachine.model.PrimaryPart)
							
							-- gumball tip
							if self.stateData.foodOrder then
								_L.Network.Fire("AwardTipWithVerification", self.UID, candyMachine.UID, self.stateData.foodOrder.ID)
							end
							
							-- gumball emoji
							self:TimedEmoji("VeryHappyEmoji", 2.5)
							self:FaceEntity(candyMachine)
							wait(0.30)
							goToExitAndLeave()
						end)
						break
					end
				end
			end
		end
		
		-- check for popcorn machine
		if not isLeavingTip and not isGoingForGumball and not isGoingForCandy and not isGoingForBowl then
			
			local popcornMachines = myFloor:GetEntitiesFromClassAndSubClass("Appliance", "PopcornMachine")
			if #popcornMachines > 0 then
				for _, popcornMachine in ipairs(popcornMachines) do
					if math.random() < 0.10 then
						isGoingForPopcorn = true
						
						local fx, fy, fz = popcornMachine:GetFacePosition()
						if not myFloor:IsValidVoxel(fx, fy, fz) then
							fx, fy, fz = popcornMachine.xVoxel, popcornMachine.yVoxel, popcornMachine.zVoxel
						end
						self:WalkToPoint(fx, fy, fz, function()
							if popcornMachine.isDeleted or self.isDeleted then
								goToExitAndLeave()
								return
							end
							
							_L.SFX.Play(5625433552, popcornMachine.model.PrimaryPart)
							
							-- popcorn tip
							if self.stateData.foodOrder then
								_L.Network.Fire("AwardTipWithVerification", self.UID, popcornMachine.UID, self.stateData.foodOrder.ID)
							end
							
							-- gumball emoji
							self:TimedEmoji("VeryHappyEmoji", 2.5)
							self:FaceEntity(popcornMachine)
							wait(0.30)
							goToExitAndLeave()
						end)
						break
					end
				end
			end
			
		end

		-- check for soda machine
		if not isLeavingTip and not isGoingForGumball and not isGoingForCandy and not isGoingForPopcorn and not wasForcedToLeave and not isGoingForBowl then
			local sodaMachines = myFloor:GetEntitiesFromClassAndSubClass("Appliance", "SodaMachine")
			if #sodaMachines > 0 then
				for _, sodaMachine in ipairs(sodaMachines) do
					if math.random() < 0.15 then
						isGoingForSoda = true

						local fx, fy, fz = sodaMachine:GetFacePosition()
						if not myFloor:IsValidVoxel(fx, fy, fz) then
							fx, fy, fz = sodaMachine.xVoxel, sodaMachine.yVoxel, sodaMachine.zVoxel
						end
						self:WalkToPoint(fx, fy, fz, function()
							if sodaMachine.isDeleted or self.isDeleted then
								goToExitAndLeave()
								return
							end

							_L.SFX.Play(5708685354, sodaMachine.model.PrimaryPart)

							-- soda tip
							if self.stateData.foodOrder then
								_L.Network.Fire("AwardTipWithVerification", self.UID, sodaMachine.UID, self.stateData.foodOrder.ID)
							end

							-- gumball emoji
							self:TimedEmoji("VeryHappyEmoji", 2.5)
							self:FaceEntity(sodaMachine)
							wait(0.30)
							goToExitAndLeave()
						end)
						break
					end
				end
			end
		end
		
		-- check for arcade machine
		if not isLeavingTip and not isGoingForGumball and not isGoingForCandy and not isGoingForPopcorn and not isGoingForSoda and not wasForcedToLeave and not isGoingForBowl then
			local arcadeMachines = myFloor:GetEntitiesFromClassAndSubClass("Furniture", "ArcadeMachine")
			if #arcadeMachines > 0 then
				local indices = _L.Functions.RandomIndices(arcadeMachines)
				for _, index in ipairs(indices) do
					local arcadeMachine = arcadeMachines[index]
					if arcadeMachine.arcadeState ~= "Highscore" then
						continue
					end
					if arcadeMachine.busy then
						continue
					end
					arcadeMachine.busy = true
					isGoingForArcade = true
					local fx, fy, fz = arcadeMachine:GetFacePosition()
					if not myFloor:IsValidVoxel(fx, fy, fz) then
						fx, fy, fz = arcadeMachine.xVoxel, arcadeMachine.yVoxel, arcadeMachine.zVoxel
					end
					self:WalkToPoint(fx, fy, fz, function()
						
						if arcadeMachine.isDeleted or self.isDeleted then
							goToExitAndLeave()
							return
						end
												
						self:FaceEntity(arcadeMachine)
						
						-- play game (halts thread until done)
						arcadeMachine:PlayGameWithCustomer(self)
						
						arcadeMachine.busy = false
						
						goToExitAndLeave()
						
					end)
					break
				end
			end
		end
		
		-- check for celebrity customer
		local isGoingForCelebrity = false
		(function()
			if isLeavingTip or isGoingForGumball or isGoingForCandy or isGoingForPopcorn or isGoingForArcade or isGoingForSoda or isGoingForBowl then
				return
			end
			if _L.Variables.MyBakery.nameCounters["Celebrity Customer"] == 0 then
				return
			end
			
			local celebrity = _L.Variables.MyBakery:SearchForCelebrity()
			if not celebrity or celebrity.isDeleted or celebrity.stateData.celebrityApproachCount >= 3 then
				return
			end
			
			local function isValidCelebState()
				local validCelebStates = {
					ThinkingAboutOrder = true,
					DecidedOnOrder = true,
					WaitingToOrder = true,
					WaitingForFood = true,
					EatingFood = true
				}
				return not celebrity.isDeleted and validCelebStates[celebrity.state]
			end
			
			if not isValidCelebState() then
				return
			end
			
			isGoingForCelebrity = true
			celebrity.stateData.celebrityApproachCount += 1
			
			self:WalkToNewFloor(celebrity:GetMyFloor(), function()
				if not isValidCelebState() then
					if not celebrity.isDeleted then
						celebrity.stateData.celebrityApproachCount -= 1
					end
					goToExitAndLeave()
					return
				end
				
				self:WalkToPoint(celebrity.xVoxel, celebrity.yVoxel, celebrity.zVoxel, function()
					if not isValidCelebState() then
						if not celebrity.isDeleted then
							celebrity.stateData.celebrityApproachCount -= 1
						end
						goToExitAndLeave()
						return
					end
					
					celebrity.stateData.celebrityApproachCount -= 1
					
					_L.SFX.Play(5278932469, celebrity.model.PrimaryPart.Position)
					self:FaceEntity(celebrity)
					self:TimedEmoji("Starstruck", 2.5)
					self:PlayLoadedAnimation("wave")
					wait(2.0)
					goToExitAndLeave()
				end)
			end)
		end)()
		
		if not isLeavingTip and not isGoingForGumball and not isGoingForCelebrity and not isGoingForCandy and not isGoingForArcade and not isGoingForPopcorn and not isGoingForBowl then
			goToExitAndLeave()
		end
	
	end)()
	
end

-- @classmethod
function Customer:CreateMyFoodModel(cframe)
	self.stateData.foodOrder:MakeModel()
	self.stateData.foodOrder:SetModelPrimaryPartCFrame(cframe)
end

-- @classmethod
function Customer:ChangeToEatingState()
	
	coroutine.wrap(function()
		if self.state == "EatingFood" then
			return
		end
		
		-- first, check for silverware
		local myFloor = self:GetMyFloor()
		table.sort(myFloor.silverwareTrays, function(a, b)
			local aDist = math.abs(self.xVoxel - a.xVoxel) + math.abs(self.zVoxel - a.zVoxel)
			local bDist = math.abs(self.xVoxel - b.xVoxel) + math.abs(self.zVoxel - b.zVoxel)
			return aDist < bDist
		end)
		table.sort(myFloor.goldSilverwareTrays, function(a, b)
			local aDist = math.abs(self.xVoxel - a.xVoxel) + math.abs(self.zVoxel - a.zVoxel)
			local bDist = math.abs(self.xVoxel - b.xVoxel) + math.abs(self.zVoxel - b.zVoxel)
			return aDist < bDist
		end)
		
		self:SetCustomerState("EatingFood")
		
		-- if there's a path to me, delete it
		if self.stateData.pathToMe then
			_L.Variables.MyBakery:CleanupAnimatedPath()
			self.stateData.pathToMe = nil
		end

		local didSaladCheck = false
		local function checkForSaladBars(isWalkingFromSilverware, doWalkBackToSeat)
			didSaladCheck = true
			local didWalkToSalad = false
			-- walk to salad bar sometimes
			local isWalkingToSaladBar = false
			for _, saladBar in ipairs(myFloor.saladBars) do
				if math.random() < 0.20 then

					if not isWalkingFromSilverware then
						self:StandUp()
					end
					
					isWalkingToSaladBar = true
					didWalkToSalad = true
					local sx, sy, sz = self.xVoxel, self.yVoxel, self.zVoxel
					self:WalkToPoint(saladBar.xVoxel, saladBar.yVoxel, saladBar.zVoxel, function()
						if saladBar.isDeleted then
							isWalkingToSaladBar = false
							self:ForcedToLeave()
							return
						end

						self:FaceEntity(saladBar)
						wait(0.30)
						_L.SFX.Play(5708685167, saladBar.model.PrimaryPart)
						_L.Network.Fire("AwardTipWithVerification", self.UID, saladBar.UID, self.stateData.foodOrder.ID, isWalkingFromSilverware)

						if doWalkBackToSeat then
							self:WalkToPoint(sx, sy, sz, function()
								isWalkingToSaladBar = false
								if self.stateData.mySeat.isDeleted then
									self:ForcedToLeave()
									return
								end
								self:SitInSeat(self.stateData.mySeat)
							end)
						else
							isWalkingToSaladBar = false
						end
					end)   
					break
				end
			end
			if isWalkingToSaladBar then
				repeat wait() until not isWalkingToSaladBar
			end
			return didWalkToSalad
		end
		
		local didDessertCheck = false
		local function checkForDessertBars(isWalkingFromSilverware, doWalkBackToSeat)
			didDessertCheck = true
			local didWalkToDessert = false
			-- walk to salad bar sometimes
			local isWalkingToDessertBar = false
			for _, dessertBar in ipairs(myFloor.dessertBars) do
				if math.random() < 0.20 then
					
					if not isWalkingFromSilverware then
						self:StandUp()
					end
					
					isWalkingToDessertBar = true
					didWalkToDessert = true
					local sx, sy, sz = self.xVoxel, self.yVoxel, self.zVoxel
					self:WalkToPoint(dessertBar.xVoxel, dessertBar.yVoxel, dessertBar.zVoxel, function()
						if dessertBar.isDeleted then
							isWalkingToDessertBar = false
							self:ForcedToLeave()
							return
						end
						
						self:FaceEntity(dessertBar)
						wait(0.30)
						_L.SFX.Play(5708685167, dessertBar.model.PrimaryPart)
						_L.Network.Fire("AwardTipWithVerification", self.UID, dessertBar.UID, self.stateData.foodOrder.ID, isWalkingFromSilverware)
						
						if doWalkBackToSeat then
							self:WalkToPoint(sx, sy, sz, function()
								isWalkingToDessertBar = false
								if self.stateData.mySeat.isDeleted then
									self:ForcedToLeave()
									return
								end
								self:SitInSeat(self.stateData.mySeat)
							end)
						else
							isWalkingToDessertBar = false
						end
					end)   
					break
				end
			end
			if isWalkingToDessertBar then
				repeat wait() until not isWalkingToDessertBar
			end
			return didWalkToDessert
		end
		
		-- create food model for the customer
		if not self.stateData.foodOrder then
			self:ForcedToLeave()
			return
		end
		local myTable = self:EntityTable()[self.stateData.tableUID]
		local mySeat = self:EntityTable()[self.stateData.seatUID]
		if not myTable or not mySeat then
			_L.Print("CRITICAL: COULDN'T FIND CUSTOMERS TABLE WHEN EATING", true)
			return
		end
		local myFloor = myTable:GetMyFloor()
		local worldPos = myFloor:WorldPositionFromVoxel(mySeat:GetFacePosition())
		local tableRoot = myTable.model.PrimaryPart
		local tableTop = Vector3.new(worldPos.X, tableRoot.Position.Y + tableRoot.Size.Y/2, worldPos.Z)
		local foodOffset = (-1.1)*mySeat:GetFaceDirection() + Vector3.new(0, self.stateData.foodOrder.data.model.PrimaryPart.Size.Y/2, 0)
		local foodCF = CFrame.new(tableTop + foodOffset)
		self:CreateMyFoodModel(foodCF)
		
		local isWalkingToTray = false
		local wasWalkingToTray = false
		local trayUID = false
		local forkModel = nil
		local spoonModel = nil
		local welds = {}
		local function walkToTray(tray)
			isWalkingToTray = true
			wasWalkingToTray = true
			trayUID = tray.UID
			self:StandUp()
			local sx, sy, sz = self.xVoxel, self.yVoxel, self.zVoxel
			self:WalkToPoint(tray.xVoxel, tray.yVoxel, tray.zVoxel, function()
				if tray.isDeleted then
					isWalkingToTray = false
					self:ForcedToLeave()
					return
				end
				local sounds = {5601560377, 5601560515, 5601560641}
				_L.SFX.Play(sounds[math.random(#sounds)], tray.model.PrimaryPart)
				self:FaceEntity(tray)
				wait(0.30)

				if not checkForSaladBars(true, false) then
					checkForDessertBars(true, false)
				end
				
				self:WalkToPoint(sx, sy, sz, function()
					isWalkingToTray = false
					if self.stateData.mySeat.isDeleted then
						self:ForcedToLeave()
						return
					end
					self:SitInSeat(self.stateData.mySeat)
					
					-- hold silverware
					local isGold = tray.ID == "25"
					local function weldToHand(part, hand)
						local weld = Instance.new("Weld", part)
						weld.Part0 = part 
						weld.Part1 = hand
						weld.C0 = CFrame.Angles(-math.pi/2, 0, 0)
						table.insert(welds, weld)
					end
					if isGold then
						forkModel = game.ReplicatedStorage.Assets.Models["Luxury Fork"]:Clone()
						spoonModel = game.ReplicatedStorage.Assets.Models["Luxury Spoon"]:Clone()
						forkModel.Parent = self.model
						spoonModel.Parent = self.model
						weldToHand(forkModel, self.model.RightHand)
						weldToHand(spoonModel, self.model.LeftHand)
					else
						forkModel = game.ReplicatedStorage.Assets.Models["Default Fork"]:Clone()
						spoonModel = game.ReplicatedStorage.Assets.Models["Default Spoon"]:Clone()
						forkModel.Parent = self.model
						spoonModel.Parent = self.model
						weldToHand(forkModel, self.model.RightHand)
						weldToHand(spoonModel, self.model.LeftHand)
					end
				end)
			end)
		end
		
		if #myFloor.goldSilverwareTrays > 0 then
			walkToTray(myFloor.goldSilverwareTrays[1])
		elseif #myFloor.silverwareTrays > 0 then
			local goodRoll = false
			for i = 1, #myFloor.silverwareTrays do
				if math.random() < 0.20 then
					goodRoll = true
				end
			end
			if goodRoll then
				walkToTray(myFloor.silverwareTrays[1])
			end
		end
		
		if isWalkingToTray then
			repeat wait() until not isWalkingToTray
		end

		if not didSaladCheck then
			if not checkForSaladBars(false, true) then
				checkForDessertBars(false, true)
			end
		end
			
		-- play eating animation
		self:PlayLoadedAnimation("eating")

		-- play served sound
		_L.SFX.Play(5205174537, self.model.PrimaryPart, nil, 0.60)
		
		-- play eating looped sound
		local pitch = 1 + (math.random() - 0.50)*0.10
		local eatSound = math.random() < 0.50 and 5029600710 or 5029600543
		self.stateData.loopedEatingSound = _L.SFX.Play(eatSound, self.model.PrimaryPart, pitch, 0.85, 35, nil, true)
			
		coroutine.wrap(function()
			
			-- eat timing is determined by the server.  locks the customer
			-- in eat mode until the server replies
			local forceLeaveTip = _L.Network.Invoke("WaitForEatTime", self.ID, self.UID, trayUID)
			if not self.isDeleted and self.state == "EatingFood" then
				if self.stateData.loopedEatingSound then
					self.stateData.loopedEatingSound = self.stateData.loopedEatingSound:Destroy()
				end
				self.stateData.foodOrder:ChangeToDirtyDish()
				self:StopLoadedAnimation("eating")
				self:ChangeToReadyToExitState(forceLeaveTip)
				
				if forkModel then
					forkModel:Destroy()
					spoonModel:Destroy()
					for _, weld in ipairs(welds) do
						weld:Destroy()
					end
					welds = {}
				end
			end
		end)()
	end)()
	
end

-- @classmethod
function Customer:PingForFoodDelivery()
	
	self:Emoji("ServeEmoji")
	
	-- setup ping UI
	self:Interact(function(interactDestroyer)
		
		local myPosition = player.Character:GetModelCFrame().p
		local pingPosition = self.model.PrimaryPart.Position
		
		-- bad ping
		if (myPosition - pingPosition).Magnitude > 12 then
			return
		end
		
		-- tutorial event
		if _L.Variables.MyBakery.isTutorial then
			_L.Signal.Fire("Tutorial_FinishedServing")
		end
		
		-- ping sound
		_L.SFX.Play(5074101610, player.PlayerGui)

		interactDestroyer()
		self:StopEmoji()
		_L.PlayerAnimations.DropModel()
		if player:FindFirstChild("__ACTIVATED_CARRY") then
			player.__ACTIVATED_CARRY:Destroy()
		end
		
		-- award player experience
		_L.Network.Fire("AwardBakeryExperienceWithVerification")
		
		self:ChangeToEatingState()
		
	end)
	
end

-- @classmethod
-- goes to the chair targeted by stateData.seatUID
function Customer:GoToTargetChair()
	
	if self.isDeleted then
		return
	end
	
	if not self.stateData.seatUID then
		_L.Print("Error: Can't sit customer at chair because it is unassigned", true)
		self:ForcedToLeave()
		return
	end
	
	if not self.stateData.tableUID then
		_L.Print("Error: can't sit customer at table because it is unassigned", true)
		self:ForcedToLeave()
		return
	end
	
	if self.state ~= "WaitingForSeat" then
		return
	end
	
	self:SetCustomerState("WalkingToSeat")	
	
	-- small chance for happy emoji
	if math.random() < 0.15 or _L.Variables.MyBakery.isTutorial then
		self:TimedEmoji("HappyEmoji", 1.75)
	end
		
	-- make sure seat and table still exist (already occupied them earlier...)
	local myFloor = self:GetMyFloor()
	local seatLeaf = self:EntityTable()[self.stateData.seatUID]
	local tableLeaf = self:EntityTable()[self.stateData.tableUID]
	if not seatLeaf or not tableLeaf then
		self:ForcedToLeave()
		return
	end
	
	-- walk to my seat
	self:WalkToNewFloor(seatLeaf:GetMyFloor(), function()
		self:WalkToPoint(seatLeaf.xVoxel, seatLeaf.yVoxel, seatLeaf.zVoxel, function()	
			if seatLeaf.isDeleted or tableLeaf.isDeleted then
				self:ForcedToLeave()
				return
			end
			self:FaceEntity(seatLeaf)
			wait(0.30)	
			
			if not _L.Variables.MyBakery.isOpen then
				self:ForcedToLeave()
			else
				self:ChangeToWaitForOrderState()
			end
		end, true)
	end)
end	

-- @classmethod
function Customer:EquipLei()
	local handle = Instance.new("Part")
	handle.Name = "LeiPart" 
	handle.formFactor = 0
	handle.Size = Vector3.new(0,-0.25,0) 
	handle.BottomSurface = 0 
	handle.TopSurface = 0 
	handle.Locked = true 
	handle.CanCollide = false
	handle.Parent = self.model
	game.ReplicatedStorage.Assets.Models.LeiMesh:Clone().Parent = handle
	
	local weld = Instance.new("Weld")
	weld.Part0 = handle
	weld.Part1 = self.model.Head
	weld.C0 = CFrame.new(0, -0.65, 0)
	weld.Parent = handle
end

-- helper for :WaitToPoint
local function getWalkablePath(customerLeaf, xVoxel, yVoxel, zVoxel)
	local myFloor = customerLeaf:GetMyFloor()
	local obstacles = myFloor:GenerateObstacleTable()
	local path = _L.Pathfinding.CalculatePath(obstacles, customerLeaf.xVoxel, customerLeaf.zVoxel, xVoxel, zVoxel)
	local waypoints = {}
	for _, node in ipairs(path) do
		table.insert(waypoints, myFloor:WorldPositionFromVoxel(node.x, customerLeaf.yVoxel, node.y))
	end
	return path, waypoints
end

-- @classmethod
function Customer:WalkToPoint(xVoxel, yVoxel, zVoxel, finishedCallback)
	
	if self.stateData.busyWalking then
		return
	end
	self.stateData.busyWalking = true
	
	self:PlayLoadedAnimation("walking")
	
	local voxelpoints, waypoints = getWalkablePath(self, xVoxel, yVoxel, zVoxel)
	local visualizers = {}
	local function updateRenderStatus() -- Line: 2074
		--[[
			Upvalues:
				[1] = self
		--]]
		if not self:BelongsToMyBakery() then return end
		local CustomerRenderStatus = self:GetMyBakery():GetCustomerRenderStatus();
		if self.model.Parent and not CustomerRenderStatus then
			self.modelParentCache = self.model.Parent;
			self.model.Parent = nil;
			return;
		end
		if not self.model.Parent and CustomerRenderStatus and self.modelParentCache then
			local MyFloor8 = self:GetMyFloor();
			self.model.Parent = self.modelParentCache;
			self.model:SetPrimaryPartCFrame(CFrame.new(MyFloor8:WorldPositionFromVoxel(self.xVoxel, self.zVoxel) + Vector3.new(0, self.model.PrimaryPart.Size.Y / 2, 0)));
		end
	end
	coroutine.wrap(function()
			
		-- send path data to replication partners
		-- replication partners need not recalculate the path.  we just
		-- send them the path that my client generated
		if self:BelongsToMyBakery() then
			_L.Replication.SendEvent("NPCWalkingFromPointToPoint", self.UID, voxelpoints)
		end
		updateRenderStatus()
	 	self:WalkThroughWaypoints(voxelpoints, waypoints, self.xVoxel, self.zVoxel)
		updateRenderStatus()
		self.stateData.busyWalking = false
		
		coroutine.wrap(function()
			self:NetworkMyVoxelPosition()
		end)()
		
		self:StopLoadedAnimation("walking")
		self:PlayLoadedAnimation("idle")
		
		if finishedCallback then
			finishedCallback()
		end
	end)()
end

-- @classmethod
function Customer:WalkToNewFloor(targetFloor, finishedCallback)
	
	local currentFloor = self:GetMyFloor()
	
	if not targetFloor or currentFloor.floorLevel == targetFloor.floorLevel then
		if finishedCallback then finishedCallback() end
		return
	end
	
	self:WalkToPoint(currentFloor.floorTransitionXVoxel, self.yVoxel, currentFloor.floorTransitionZVoxel, function()
		self:FadeTransparency(1.0, function()
			self:TransitionToDifferentFloor(targetFloor)
			self:FadeTransparency(self:GetMyTransparency(), function()
				if finishedCallback then
					finishedCallback()
				end
			end)
		end)
	end, false, true)
	
	
end

-- @classmethod
function Customer:WalkToPointInQueue(xVoxel, yVoxel, zVoxel, finishedCallback)
	
	yVoxel = yVoxel or 0
	
	if self.isDeleted then
		return
	end
	if self.stateData.busyWalking then
		return
	end
	self.stateData.busyWalking = true
	
	self:PlayLoadedAnimation("walking")
	
	local myFloor = self:GetMyFloor()
	local goalPosition = myFloor:WorldPositionFromVoxel(xVoxel, self.yVoxel, zVoxel)
	
	-- customer queue goal position offset (for centering customers)
	if self:BelongsToMyBakery() and self.stateData.queueGroup then
		local groupSize = #self.stateData.queueGroup + 1
		local baseAngle = CFrame.Angles(0, self:GetMyBakery().baseAngle, 0)
		
		if groupSize == 1 then
			goalPosition += (baseAngle * CFrame.new(2, 0, 0)).p
		elseif groupSize == 3 then
			goalPosition += (baseAngle * CFrame.new(-2, 0, 0)).p
		end
	end
	
	-- replication event
	if self:BelongsToMyBakery() then
		_L.Replication.SendEvent("NPCWalkingFromPointToPointWithoutPathfinding", self.UID, xVoxel, zVoxel)
	end
	
	coroutine.wrap(function()
		local oldX, oldZ = self.xVoxel, self.zVoxel
		self.humanoid:MoveTo(goalPosition)
		self.humanoid.MoveToFinished:Wait()
		
		self.xVoxel = xVoxel
		self.zVoxel = zVoxel
		self:NetworkMyVoxelPosition()
		
		self:GetMyFloor():BroadcastNPCPositionChange(self, oldX, oldZ)
		
		self.stateData.busyWalking = false
		
		self:StopLoadedAnimation("walking")
		self:PlayLoadedAnimation("idle")
		
		if finishedCallback then
			finishedCallback()
		end
	end)()
	
end

return Customer
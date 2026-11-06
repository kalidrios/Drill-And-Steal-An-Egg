-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Heartbeat = RunService.Heartbeat
local v1 = RunService:IsClient() and Players.LocalPlayer

game:GetService("ReplicatedStorage")

local HttpService = game:GetService("HttpService")
local enums = require(script.Enum).enums
local Janitor = require(script.Janitor)
local Signal = require(script.Signal)
local ZonePlusReference = require(script.ZonePlusReference)
local v2 = ZonePlusReference.getObject()
local ZoneController = script.ZoneController
local Tracker = ZoneController.Tracker
local CollectiveWorldModel = ZoneController.CollectiveWorldModel
local v3 = require(ZoneController)
local v5 = if v2 then v2:FindFirstChild(if game:GetService("RunService"):IsClient() then "Client" else "Server") else v2

if v5 then
	return require(v2.Value)
end

local t = {}

t.__index = t

local _, v6

if v5 then
	t.enum = enums
	function t.new(p13) --[[ new | Line: 34 | Upvalues: t (copy), enums (copy), Janitor (copy), HttpService (copy), v3 (copy), Signal (copy), v1 (copy) ]]
		local t2 = {}

		setmetatable(t2, t)

		local v2 = typeof(p13)

		if v2 ~= "table" and v2 ~= "Instance" then
			error("The zone container must be a model, folder, basepart or table!")
		end

		t2.accuracy = enums.Accuracy.High
		t2.autoUpdate = true
		t2.respectUpdateQueue = true

		local v32 = Janitor.new()

		t2.janitor = v32
		t2._updateConnections = v32:add(Janitor.new(), "destroy")
		t2.container = p13
		t2.zoneParts = {}
		t2.overlapParams = {}
		t2.region = nil
		t2.volume = nil
		t2.boundMin = nil
		t2.boundMax = nil
		t2.recommendedMaxParts = nil
		t2.zoneId = HttpService:GenerateGUID()
		t2.activeTriggers = {}
		t2.occupants = {}
		t2.trackingTouchedTriggers = {}
		t2.enterDetection = enums.Detection.Centre
		t2.exitDetection = enums.Detection.Centre
		t2._currentEnterDetection = nil
		t2._currentExitDetection = nil
		t2.totalPartVolume = 0
		t2.allZonePartsAreBlocks = true
		t2.trackedItems = {}
		t2.settingsGroupName = nil
		t2.worldModel = workspace
		t2.onItemDetails = {}
		t2.itemsToUntrack = {}
		v3.updateDetection(t2)
		t2.updated = v32:add(Signal.new(), "destroy")

		local tbl2 = { "player", "part", "localPlayer", "item" }
		local tbl22 = { "entered", "exited" }

		for k2, v in pairs(tbl2) do
			local v4 = 0
			local v5 = 0

			for k22, v7 in pairs(tbl22) do
				local v62 = v32:add(Signal.new(true), "destroy")
				local v72 = v7:sub(1, 1):upper() .. v7:sub(2)

				t2[v .. v72] = v62
				v62.connectionsChanged:Connect(function(p13) --[[ Line: 105 | Upvalues: v (copy), v1 (ref), v72 (copy), v4 (ref), v5 (ref), v3 (ref), t2 (copy) ]]
					if v == "localPlayer" and (not v1 and p13 == 1) then
						error(("Can only connect to \'localPlayer%s\' on the client!"):format(v72))
					end

					v4 = v5
					v5 = v5 + p13

					if v4 == 0 and v5 > 0 then
						v3._registerConnection(t2, v, v72)

						return
					end

					if not (v4 > 0) or v5 ~= 0 then
						return
					end

					v3._deregisterConnection(t2, v)
				end)
			end
		end

		t.touchedConnectionActions = {}

		for k2, v in pairs(tbl2) do
			local v8 = t2[("_%sTouchedZone"):format(v)]

			if v8 then
				t2.trackingTouchedTriggers[v] = {}
				t.touchedConnectionActions[v] = function(p13) --[[ Line: 129 | Upvalues: v8 (copy), t2 (copy) ]]
					v8(t2, p13)
				end
			end
		end

		t2:_update()
		v3._registerZone(t2)
		v32:add(function() --[[ Line: 140 | Upvalues: v3 (ref), t2 (copy) ]]
			v3._deregisterZone(t2)
		end, true)

		return t2
	end
	function t.fromRegion(p13, p23) --[[ fromRegion | Line: 147 | Upvalues: t (copy) ]]
		local Model = Instance.new("Model")

		local function v1(p13, p23) --[[ createCube | Line: 150 | Upvalues: v1 (copy), Model (copy) ]]
			if not (p23.X > 2024 or (p23.Y > 2024 or p23.Z > 2024)) then
				local Part = Instance.new("Part")

				Part.CFrame = p13
				Part.Size = p23
				Part.Anchored = true
				Part.Parent = Model

				return
			end

			local v12 = p23 * 0.25
			local v2 = p23 * 0.5

			v1(p13 * CFrame.new(-v12.X, -v12.Y, -v12.Z), v2)
			v1(p13 * CFrame.new(-v12.X, -v12.Y, v12.Z), v2)
			v1(p13 * CFrame.new(-v12.X, v12.Y, -v12.Z), v2)
			v1(p13 * CFrame.new(-v12.X, v12.Y, v12.Z), v2)
			v1(p13 * CFrame.new(v12.X, -v12.Y, -v12.Z), v2)
			v1(p13 * CFrame.new(v12.X, -v12.Y, v12.Z), v2)
			v1(p13 * CFrame.new(v12.X, v12.Y, -v12.Z), v2)
			v1(p13 * CFrame.new(v12.X, v12.Y, v12.Z), v2)
		end

		v1(p13, p23)

		local v2 = t.new(Model)

		v2:relocate()

		return v2
	end
	function t._calculateRegion(p13, p23, p33) --[[ _calculateRegion | Line: 179 ]]
		local tbl2 = {
			Min = {},
			Max = {}
		}

		for k2, v in pairs(tbl2) do
			v.Values = {}
			function v.parseCheck(p13, p23) --[[ parseCheck | Line: 183 | Upvalues: k2 (copy) ]]
				if k2 == "Min" then
					return p13 <= p23
				end

				if k2 ~= "Max" then
					return
				end

				return p23 <= p13
			end
			function v.parse(p13, p23) --[[ parse | Line: 190 ]]
				for k2, v in pairs(p23) do
					if p13.parseCheck(v, p13.Values[k2] or v) then
						p13.Values[k2] = v
					end
				end
			end
		end

		for k2, v in pairs(p23) do
			local v1 = v.Size * 0.5

			for k22, v3 in pairs({
				v.CFrame * CFrame.new(-v1.X, -v1.Y, -v1.Z),
				v.CFrame * CFrame.new(-v1.X, -v1.Y, v1.Z),
				v.CFrame * CFrame.new(-v1.X, v1.Y, -v1.Z),
				v.CFrame * CFrame.new(-v1.X, v1.Y, v1.Z),
				v.CFrame * CFrame.new(v1.X, -v1.Y, -v1.Z),
				v.CFrame * CFrame.new(v1.X, -v1.Y, v1.Z),
				v.CFrame * CFrame.new(v1.X, v1.Y, -v1.Z),
				v.CFrame * CFrame.new(v1.X, v1.Y, v1.Z)
			}) do
				local v22, v32, v4 = v3:GetComponents()
				local t2 = { v22, v32, v4 }

				tbl2.Min:parse(t2)
				tbl2.Max:parse(t2)
			end
		end

		local function roundToFour(p13) --[[ roundToFour | Line: 222 ]]
			return math.floor((p13 + 2) / 4) * 4
		end

		local t2 = {}
		local t22 = {}

		for k2, v in pairs(tbl2) do
			for k22, v3 in pairs(v.Values) do
				local v5, v6

				v5 = if k2 == "Min" and t2 then t2 else t22
				v6 = if p33 then v3 else math.floor((v3 + (if k2 == "Min" then -2 else 2) + 2) / 4) * 4
				table.insert(v5, v6)
			end
		end

		local v10 = Vector3.new(unpack(t2))
		local v12 = Vector3.new(unpack(t22))

		return Region3.new(v10, v12), v10, v12
	end
	function t._displayBounds(p13) --[[ _displayBounds | Line: 245 ]]
		if p13.displayBoundParts then
			return
		end

		p13.displayBoundParts = true

		for k2, v in pairs({
			BoundMin = p13.boundMin,
			BoundMax = p13.boundMax
		}) do
			local Part = Instance.new("Part")

			Part.Anchored = true
			Part.CanCollide = false
			Part.Transparency = 0.5
			Part.Size = Vector3.new(1, 1, 1)
			Part.Color = Color3.fromRGB(255, 0, 0)
			Part.CFrame = CFrame.new(v)
			Part.Name = k2
			Part.Parent = workspace
			p13.janitor:add(Part, "Destroy")
		end
	end
	function t._update(p13) --[[ _update | Line: 264 | Upvalues: RunService (copy) ]]
		local container = p13.container
		local tbl2 = {}
		local v1 = 0

		p13._updateConnections:clean()

		local v2 = typeof(container)
		local tbl22 = {}

		if v2 == "table" then
			for k2, v in pairs(container) do
				if v:IsA("BasePart") then
					table.insert(tbl2, v)
				end
			end
		elseif v2 == "Instance" and container:IsA("BasePart") then
			table.insert(tbl2, container)
		elseif v2 == "Instance" then
			table.insert(tbl22, container)

			for k2, v in pairs(container:GetDescendants()) do
				if v:IsA("BasePart") then
					table.insert(tbl2, v)

					continue
				end

				table.insert(tbl22, v)
			end
		end

		p13.zoneParts = tbl2
		p13.overlapParams = {}

		local v3 = true

		for k2, v in pairs(tbl2) do
			local _, result = pcall(function() --[[ Line: 298 | Upvalues: v (copy) ]]
				return v.Shape.Name
			end)

			if result ~= "Block" then
				v3 = false
			end
		end

		p13.allZonePartsAreBlocks = v3

		local v4 = OverlapParams.new()

		v4.FilterType = Enum.RaycastFilterType.Whitelist
		v4.MaxParts = #tbl2
		v4.FilterDescendantsInstances = tbl2
		p13.overlapParams.zonePartsWhitelist = v4

		local v5 = OverlapParams.new()

		v5.FilterType = Enum.RaycastFilterType.Blacklist
		v5.FilterDescendantsInstances = tbl2
		p13.overlapParams.zonePartsIgnorelist = v5

		local function update() --[[ update | Line: 318 | Upvalues: p13 (copy), v1 (ref), RunService (ref) ]]
			if not p13.autoUpdate then
				return
			end

			local sum2 = os.clock()

			if p13.respectUpdateQueue then
				v1 = v1 + 1
				sum2 = sum2 + 0.1
			end

			local v12 = nil

			v12 = RunService.Heartbeat:Connect(function() --[[ Line: 326 | Upvalues: sum2 (ref), v12 (ref), p13 (ref), v1 (ref) ]]
				if not (sum2 <= os.clock()) then
					return
				end

				v12:Disconnect()

				if p13.respectUpdateQueue then
					v1 = v1 - 1
				end

				if v1 ~= 0 or not p13.zoneId then
					return
				end

				p13:_update()
			end)
		end

		local function verifyDefaultCollision(p13) --[[ verifyDefaultCollision | Line: 340 ]]
			if p13.CollisionGroupId == 0 then
				return
			end

			error("Zone parts must belong to the \'Default\' (0) CollisionGroup! Consider using zone:relocate() if you wish to move zones outside of workspace to prevent them interacting with other parts.")
		end

		local tbl3 = { "Size", "Position" }

		for k2, v in pairs(tbl2) do
			for k22, v7 in pairs(tbl3) do
				p13._updateConnections:add(v:GetPropertyChangedSignal(v7):Connect(update), "Disconnect")
			end

			if v.CollisionGroupId ~= 0 then
				error("Zone parts must belong to the \'Default\' (0) CollisionGroup! Consider using zone:relocate() if you wish to move zones outside of workspace to prevent them interacting with other parts.")
			end

			p13._updateConnections:add(v:GetPropertyChangedSignal("CollisionGroupId"):Connect(function() --[[ Line: 350 | Upvalues: v (copy) ]]
				if v.CollisionGroupId == 0 then
					return
				end

				error("Zone parts must belong to the \'Default\' (0) CollisionGroup! Consider using zone:relocate() if you wish to move zones outside of workspace to prevent them interacting with other parts.")
			end), "Disconnect")
		end

		local tbl4 = { "ChildAdded", "ChildRemoved" }

		for k2, v in pairs(tbl22) do
			for k22, v7 in pairs(tbl4) do
				p13._updateConnections:add(p13.container[v7]:Connect(function(p1) --[[ Line: 357 | Upvalues: p13 (copy), v1 (ref), RunService (ref) ]]
					if not (p1:IsA("BasePart") and p13.autoUpdate) then
						return
					end

					local sum2 = os.clock()

					if p13.respectUpdateQueue then
						v1 = v1 + 1
						sum2 = sum2 + 0.1
					end

					local v12 = nil

					v12 = RunService.Heartbeat:Connect(function() --[[ Line: 326 | Upvalues: sum2 (ref), v12 (ref), p13 (ref), v1 (ref) ]]
						if not (sum2 <= os.clock()) then
							return
						end

						v12:Disconnect()

						if p13.respectUpdateQueue then
							v1 = v1 - 1
						end

						if v1 ~= 0 or not p13.zoneId then
							return
						end

						p13:_update()
					end)
				end), "Disconnect")
			end
		end

		local v6, v7, v8 = p13:_calculateRegion(tbl2)
		local v9, _, _22 = p13:_calculateRegion(tbl2, true)

		p13.region = v6
		p13.exactRegion = v9
		p13.boundMin = v7
		p13.boundMax = v8

		local Size = v6.Size

		p13.volume = Size.X * Size.Y * Size.Z
		p13:_updateTouchedConnections()
		p13.updated:Fire()
	end
	function t._updateOccupants(p13, p23, p33) --[[ _updateOccupants | Line: 393 ]]
		local v1 = p13.occupants[p23]

		if not v1 then
			v1 = {}
			p13.occupants[p23] = v1
		end

		local t2 = {}

		for k2, v in pairs(v1) do
			local v2 = p33[k2]

			if v2 == nil or v2 ~= v then
				v1[k2] = nil

				if not t2.exited then
					t2.exited = {}
				end

				table.insert(t2.exited, k2)
			end
		end

		for k2, v in pairs(p33) do
			if v1[k2] == nil then
				v1[k2] = k2:IsA("Player") and k2.Character or true

				if not t2.entered then
					t2.entered = {}
				end

				table.insert(t2.entered, k2)
			end
		end

		return t2
	end
	function t._formTouchedConnection(p13, p23) --[[ _formTouchedConnection | Line: 423 | Upvalues: Janitor (copy) ]]
		local v1 = "_touchedJanitor" .. p23
		local v2 = p13[v1]

		if v2 then
			v2:clean()
		else
			p13[v1] = p13.janitor:add(Janitor.new(), "destroy")
		end

		p13:_updateTouchedConnection(p23)
	end
	function t._updateTouchedConnection(p13, p23) --[[ _updateTouchedConnection | Line: 435 ]]
		local v1 = p13["_touchedJanitor" .. p23]

		if not v1 then
			return
		end

		for k2, v in pairs(p13.zoneParts) do
			v1:add(v.Touched:Connect(p13.touchedConnectionActions[p23], p13), "Disconnect")
		end
	end
	function t._updateTouchedConnections(p13) --[[ _updateTouchedConnections | Line: 444 ]]
		for k2, v in pairs(p13.touchedConnectionActions) do
			local v1 = p13["_touchedJanitor" .. k2]

			if v1 then
				v1:cleanup()
				p13:_updateTouchedConnection(k2)
			end
		end
	end
	function t._disconnectTouchedConnection(p13, p23) --[[ _disconnectTouchedConnection | Line: 455 ]]
		local v1 = "_touchedJanitor" .. p23
		local v2 = p13[v1]

		if not v2 then
			return
		end

		v2:cleanup()
		p13[v1] = nil
	end
	_ = function(p13, p23) --[[ round | Line: 464 ]]
		return math.round(p13 * 10 ^ p23) * 10 ^ (-p23)
	end
	function t._partTouchedZone(p13, p23) --[[ _partTouchedZone | Line: 467 | Upvalues: Janitor (copy), Heartbeat (copy), enums (copy) ]]
		local part = p13.trackingTouchedTriggers.part

		if part[p23] then
			return
		end

		local v1 = 0
		local v2 = false
		local Position = p23.Position
		local v3 = os.clock()
		local v4 = p13.janitor:add(Janitor.new(), "destroy")

		part[p23] = v4

		if not ({
			Seat = true,
			VehicleSeat = true
		})[p23.ClassName] and ({
			HumanoidRootPart = true
		})[p23.Name] then
			p23.CanTouch = false
		end

		local v6 = math.round(p23.Size.X * p23.Size.Y * p23.Size.Z * 100000) * 0.00001

		p13.totalPartVolume = p13.totalPartVolume + v6
		v4:add(Heartbeat:Connect(function() --[[ Line: 485 | Upvalues: v1 (ref), enums (ref), p13 (copy), p23 (copy), v2 (ref), Position (ref), v3 (ref), v4 (copy) ]]
			local v12 = os.clock()

			if not (v1 <= v12) then
				return
			end

			local v22 = enums.Accuracy.getProperty(p13.accuracy)

			v1 = v12 + v22

			local v32 = p13:findPoint(p23.CFrame)

			if not v32 then
				v32 = p13:findPart(p23)
			end

			if v2 then
				if v32 then
					return
				end

				v2 = false
				Position = p23.Position
				v3 = os.clock()
				p13.partExited:Fire(p23)
			else
				if v32 then
					v2 = true
					p13.partEntered:Fire(p23)

					return
				end

				if (p23.Position - Position).Magnitude > 1.5 and v22 <= v12 - v3 then
					v4:cleanup()
				end
			end
		end), "Disconnect")
		v4:add(function() --[[ Line: 516 | Upvalues: part (copy), p23 (copy), p13 (copy), v6 (copy) ]]
			part[p23] = nil
			p23.CanTouch = true
			p13.totalPartVolume = math.round((p13.totalPartVolume - v6) * 100000) * 0.00001
		end, true)
	end
	v6 = {
		Ball = function(p13) --[[ Line: 524 ]]
			return "GetPartBoundsInRadius", { p13.Position, p13.Size.X }
		end,
		Block = function(p13) --[[ Line: 527 ]]
			return "GetPartBoundsInBox", { p13.CFrame, p13.Size }
		end,
		Other = function(p13) --[[ Line: 530 ]]
			return "GetPartsInPart", { p13 }
		end
	}
	function t._getRegionConstructor(p13, p23, p33) --[[ _getRegionConstructor | Line: 534 | Upvalues: v6 (copy) ]]
		local ok, result = pcall(function() --[[ Line: 535 | Upvalues: p23 (copy) ]]
			return p23.Shape.Name
		end)
		local v1 = nil
		local v2 = nil

		if ok and p13.allZonePartsAreBlocks then
			local v3 = v6[result]

			if v3 then
				local v4, v5 = v3(p23)

				v1 = v4
				v2 = v5
			end
		end

		if not v1 then
			v2 = { p23 }
			v1 = "GetPartsInPart"
		end

		if p33 then
			table.insert(v2, p33)
		end

		return v1, v2
	end
	function t.findLocalPlayer(p13) --[[ findLocalPlayer | Line: 555 | Upvalues: v1 (copy) ]]
		if v1 then
			return p13:findPlayer(v1)
		end

		error("Can only call \'findLocalPlayer\' on the client!")
	end
	function t._find(p13, p23, p33) --[[ _find | Line: 562 | Upvalues: v3 (copy) ]]
		v3.updateDetection(p13)

		for k2, v in pairs((v3.getTouchingZones(p33, false, p13._currentEnterDetection, v3.trackers[p23]))) do
			if v == p13 then
				return true
			end
		end

		return false
	end
	function t.findPlayer(p13, p23) --[[ findPlayer | Line: 574 ]]
		local Character = p23.Character

		if if Character then Character:FindFirstChildOfClass("Humanoid") else Character then
			return p13:_find("player", p23.Character)
		end

		return false
	end
	function t.findItem(p13, p23) --[[ findItem | Line: 583 ]]
		return p13:_find("item", p23)
	end
	function t.findPart(p13, p23) --[[ findPart | Line: 587 ]]
		local v1, v2 = p13:_getRegionConstructor(p23, p13.overlapParams.zonePartsWhitelist)
		local v3 = p13.worldModel[v1](p13.worldModel, unpack(v2))

		if #v3 > 0 then
			return true, v3
		end

		return false
	end
	function t.getCheckerPart(p13) --[[ getCheckerPart | Line: 597 | Upvalues: v3 (copy) ]]
		local checkerPart = p13.checkerPart

		if not checkerPart then
			local ZonePlusCheckerPart = p13.janitor:add(Instance.new("Part"), "Destroy")

			ZonePlusCheckerPart.Size = Vector3.new(0.1, 0.1, 0.1)
			ZonePlusCheckerPart.Name = "ZonePlusCheckerPart"
			ZonePlusCheckerPart.Anchored = true
			ZonePlusCheckerPart.Transparency = 1
			ZonePlusCheckerPart.CanCollide = false
			p13.checkerPart = ZonePlusCheckerPart
			checkerPart = ZonePlusCheckerPart
		end

		local worldModel = p13.worldModel

		if worldModel == workspace then
			worldModel = v3.getWorkspaceContainer()
		end

		if checkerPart.Parent ~= worldModel then
			checkerPart.Parent = worldModel
		end

		return checkerPart
	end
	function t.findPoint(p13, p23) --[[ findPoint | Line: 618 ]]
		local v1 = if typeof(p23) == "Vector3" then CFrame.new(p23) else p23
		local v3 = p13:getCheckerPart()

		v3.CFrame = v1

		local v4, v5 = p13:_getRegionConstructor(v3, p13.overlapParams.zonePartsWhitelist)
		local v6 = p13.worldModel[v4](p13.worldModel, unpack(v5))

		if #v6 > 0 then
			return true, v6
		end

		return false
	end
	function t._getAll(p13, p23) --[[ _getAll | Line: 635 | Upvalues: v3 (copy) ]]
		v3.updateDetection(p13)

		local t2 = {}
		local v1 = v3._getZonesAndItems(p23, {
			self = true
		}, p13.volume, false, p13._currentEnterDetection)[p13]

		if v1 then
			for k2, v in pairs(v1) do
				table.insert(t2, k2)
			end
		end

		return t2
	end
	function t.getPlayers(p13) --[[ getPlayers | Line: 648 ]]
		return p13:_getAll("player")
	end
	function t.getItems(p13) --[[ getItems | Line: 652 ]]
		return p13:_getAll("item")
	end
	function t.getParts(p13) --[[ getParts | Line: 656 ]]
		local t2 = {}

		if p13.activeTriggers.part then
			for k2, v in pairs(p13.trackingTouchedTriggers.part) do
				table.insert(t2, k2)
			end
		else
			for k2, v in pairs((p13.worldModel:GetPartBoundsInBox(p13.region.CFrame, p13.region.Size, p13.overlapParams.zonePartsIgnorelist))) do
				if p13:findPart(v) then
					table.insert(t2, v)
				end
			end
		end

		return t2
	end
	function t.getRandomPoint(p13) --[[ getRandomPoint | Line: 677 ]]
		local exactRegion = p13.exactRegion
		local Size = exactRegion.Size
		local v1 = exactRegion.CFrame
		local v2 = Random.new()
		local v3 = nil
		local v4, v5

		repeat
			v4 = v1 * CFrame.new(v2:NextNumber(-Size.X / 2, Size.X / 2), v2:NextNumber(-Size.Y / 2, Size.Y / 2), v2:NextNumber(-Size.Z / 2, Size.Z / 2))

			local v6

			v6, v5 = p13:findPoint(v4)

			if v6 then
				v3 = true
			end
		until v3

		return v4.Position, v5
	end
	function t.setAccuracy(p13, p23) --[[ setAccuracy | Line: 696 | Upvalues: enums (copy) ]]
		local v1 = tonumber(p23)

		if v1 then
			if not enums.Accuracy.getName(v1) then
				error(("%s is an invalid enumId!"):format(v1))
			end
		else
			v1 = enums.Accuracy[p23]

			if not v1 then
				error(("\'%s\' is an invalid enumName!"):format(p23))
			end
		end

		p13.accuracy = v1
	end
	function t.setDetection(p13, p23) --[[ setDetection | Line: 712 | Upvalues: enums (copy) ]]
		local v1 = tonumber(p23)

		if v1 then
			if not enums.Detection.getName(v1) then
				error(("%s is an invalid enumId!"):format(v1))
			end
		else
			v1 = enums.Detection[p23]

			if not v1 then
				error(("\'%s\' is an invalid enumName!"):format(p23))
			end
		end

		p13.enterDetection = v1
		p13.exitDetection = v1
	end
	function t.trackItem(p13, p23) --[[ trackItem | Line: 729 | Upvalues: Janitor (copy), Tracker (copy) ]]
		local v1 = p23:IsA("BasePart")
		local v2 = if v1 then false else p23:FindFirstChildOfClass("Humanoid") and p23:FindFirstChild("HumanoidRootPart")

		assert(v1 or v2, "Only BaseParts or Characters/NPCs can be tracked!")

		if p13.trackedItems[p23] then
			return
		end

		if p13.itemsToUntrack[p23] then
			p13.itemsToUntrack[p23] = nil
		end

		local v4 = p13.janitor:add(Janitor.new(), "destroy")
		local t2 = {
			janitor = v4,
			item = p23,
			isBasePart = v1,
			isCharacter = v2
		}

		p13.trackedItems[p23] = t2
		v4:add(p23.AncestryChanged:Connect(function() --[[ Line: 754 | Upvalues: p23 (copy), p13 (copy) ]]
			if p23:IsDescendantOf(game) then
				return
			end

			p13:untrackItem(p23)
		end), "Disconnect")
		require(Tracker).itemAdded:Fire(t2)
	end
	function t.untrackItem(p13, p23) --[[ untrackItem | Line: 764 | Upvalues: Tracker (copy) ]]
		local v1 = p13.trackedItems[p23]

		if v1 then
			v1.janitor:destroy()
		end

		p13.trackedItems[p23] = nil
		require(Tracker).itemRemoved:Fire(v1)
	end
	function t.bindToGroup(p13, p23) --[[ bindToGroup | Line: 775 | Upvalues: v3 (copy) ]]
		p13:unbindFromGroup();
		(v3.getGroup(p23) or v3.setGroup(p23))._memberZones[p13.zoneId] = p13
		p13.settingsGroupName = p23
	end
	function t.unbindFromGroup(p13) --[[ unbindFromGroup | Line: 782 | Upvalues: v3 (copy) ]]
		if not p13.settingsGroupName then
			return
		end

		local v1 = v3.getGroup(p13.settingsGroupName)

		if v1 then
			v1._memberZones[p13.zoneId] = nil
		end

		p13.settingsGroupName = nil
	end
	function t.relocate(p13) --[[ relocate | Line: 792 | Upvalues: CollectiveWorldModel (copy) ]]
		if p13.hasRelocated then
			return
		end

		local v1 = require(CollectiveWorldModel).setupWorldModel(p13)

		p13.worldModel = v1
		p13.hasRelocated = true

		local container = p13.container

		if typeof(container) == "table" then
			container = Instance.new("Folder")

			for k2, v in pairs(p13.zoneParts) do
				v.Parent = container
			end
		end

		p13.relocationContainer = p13.janitor:add(container, "Destroy", "RelocationContainer")
		container.Parent = v1
	end
	function t._onItemCallback(p13, p23, p33, p43, p53) --[[ _onItemCallback | Line: 813 ]]
		local v1 = p13.onItemDetails[p43]

		if not v1 then
			v1 = {}
			p13.onItemDetails[p43] = v1
		end

		if #v1 == 0 then
			p13.itemsToUntrack[p43] = true
		end

		table.insert(v1, p43)
		p13:trackItem(p43)

		local function triggerCallback() --[[ triggerCallback | Line: 825 | Upvalues: p53 (copy), p13 (copy), p43 (copy) ]]
			p53()

			if not p13.itemsToUntrack[p43] then
				return
			end

			p13.itemsToUntrack[p43] = nil
			p13:untrackItem(p43)
		end

		if p13:findItem(p43) == p33 then
			p53()

			if p13.itemsToUntrack[p43] then
				p13.itemsToUntrack[p43] = nil
				p13:untrackItem(p43)
			end
		else
			local v2 = nil

			v2 = p13[p23]:Connect(function(p1) --[[ Line: 838 | Upvalues: v2 (ref), p43 (copy), p53 (copy), p13 (copy) ]]
				if not v2 or p1 ~= p43 then
					return
				end

				v2:Disconnect()
				v2 = nil
				p53()

				if not p13.itemsToUntrack[p43] then
					return
				end

				p13.itemsToUntrack[p43] = nil
				p13:untrackItem(p43)
			end)
		end
	end
	function t.onItemEnter(p13, ...) --[[ onItemEnter | Line: 860 ]]
		p13:_onItemCallback("itemEntered", true, ...)
	end
	function t.onItemExit(p13, ...) --[[ onItemExit | Line: 864 ]]
		p13:_onItemCallback("itemExited", false, ...)
	end
	function t.destroy(p13) --[[ destroy | Line: 868 ]]
		p13:unbindFromGroup()
		p13.janitor:destroy()
	end
	t.Destroy = t.destroy

	return t
end

ZonePlusReference.addToReplicatedStorage()
t.enum = enums
function t.new(p13) --[[ new | Line: 34 | Upvalues: t (copy), enums (copy), Janitor (copy), HttpService (copy), v3 (copy), Signal (copy), v1 (copy) ]]
	local t2 = {}

	setmetatable(t2, t)

	local v2 = typeof(p13)

	if v2 ~= "table" and v2 ~= "Instance" then
		error("The zone container must be a model, folder, basepart or table!")
	end

	t2.accuracy = enums.Accuracy.High
	t2.autoUpdate = true
	t2.respectUpdateQueue = true

	local v32 = Janitor.new()

	t2.janitor = v32
	t2._updateConnections = v32:add(Janitor.new(), "destroy")
	t2.container = p13
	t2.zoneParts = {}
	t2.overlapParams = {}
	t2.region = nil
	t2.volume = nil
	t2.boundMin = nil
	t2.boundMax = nil
	t2.recommendedMaxParts = nil
	t2.zoneId = HttpService:GenerateGUID()
	t2.activeTriggers = {}
	t2.occupants = {}
	t2.trackingTouchedTriggers = {}
	t2.enterDetection = enums.Detection.Centre
	t2.exitDetection = enums.Detection.Centre
	t2._currentEnterDetection = nil
	t2._currentExitDetection = nil
	t2.totalPartVolume = 0
	t2.allZonePartsAreBlocks = true
	t2.trackedItems = {}
	t2.settingsGroupName = nil
	t2.worldModel = workspace
	t2.onItemDetails = {}
	t2.itemsToUntrack = {}
	v3.updateDetection(t2)
	t2.updated = v32:add(Signal.new(), "destroy")

	local tbl2 = { "player", "part", "localPlayer", "item" }
	local tbl22 = { "entered", "exited" }

	for k2, v in pairs(tbl2) do
		local v4 = 0
		local v5 = 0

		for k22, v7 in pairs(tbl22) do
			local v62 = v32:add(Signal.new(true), "destroy")
			local v72 = v7:sub(1, 1):upper() .. v7:sub(2)

			t2[v .. v72] = v62
			v62.connectionsChanged:Connect(function(p13) --[[ Line: 105 | Upvalues: v (copy), v1 (ref), v72 (copy), v4 (ref), v5 (ref), v3 (ref), t2 (copy) ]]
				if v == "localPlayer" and (not v1 and p13 == 1) then
					error(("Can only connect to \'localPlayer%s\' on the client!"):format(v72))
				end

				v4 = v5
				v5 = v5 + p13

				if v4 == 0 and v5 > 0 then
					v3._registerConnection(t2, v, v72)

					return
				end

				if not (v4 > 0) or v5 ~= 0 then
					return
				end

				v3._deregisterConnection(t2, v)
			end)
		end
	end

	t.touchedConnectionActions = {}

	for k2, v in pairs(tbl2) do
		local v8 = t2[("_%sTouchedZone"):format(v)]

		if v8 then
			t2.trackingTouchedTriggers[v] = {}
			t.touchedConnectionActions[v] = function(p13) --[[ Line: 129 | Upvalues: v8 (copy), t2 (copy) ]]
				v8(t2, p13)
			end
		end
	end

	t2:_update()
	v3._registerZone(t2)
	v32:add(function() --[[ Line: 140 | Upvalues: v3 (ref), t2 (copy) ]]
		v3._deregisterZone(t2)
	end, true)

	return t2
end
function t.fromRegion(p13, p23) --[[ fromRegion | Line: 147 | Upvalues: t (copy) ]]
	local Model = Instance.new("Model")

	local function v1(p13, p23) --[[ createCube | Line: 150 | Upvalues: v1 (copy), Model (copy) ]]
		if not (p23.X > 2024 or (p23.Y > 2024 or p23.Z > 2024)) then
			local Part = Instance.new("Part")

			Part.CFrame = p13
			Part.Size = p23
			Part.Anchored = true
			Part.Parent = Model

			return
		end

		local v12 = p23 * 0.25
		local v2 = p23 * 0.5

		v1(p13 * CFrame.new(-v12.X, -v12.Y, -v12.Z), v2)
		v1(p13 * CFrame.new(-v12.X, -v12.Y, v12.Z), v2)
		v1(p13 * CFrame.new(-v12.X, v12.Y, -v12.Z), v2)
		v1(p13 * CFrame.new(-v12.X, v12.Y, v12.Z), v2)
		v1(p13 * CFrame.new(v12.X, -v12.Y, -v12.Z), v2)
		v1(p13 * CFrame.new(v12.X, -v12.Y, v12.Z), v2)
		v1(p13 * CFrame.new(v12.X, v12.Y, -v12.Z), v2)
		v1(p13 * CFrame.new(v12.X, v12.Y, v12.Z), v2)
	end

	v1(p13, p23)

	local v2 = t.new(Model)

	v2:relocate()

	return v2
end
function t._calculateRegion(p13, p23, p33) --[[ _calculateRegion | Line: 179 ]]
	local tbl2 = {
		Min = {},
		Max = {}
	}

	for k2, v in pairs(tbl2) do
		v.Values = {}
		function v.parseCheck(p13, p23) --[[ parseCheck | Line: 183 | Upvalues: k2 (copy) ]]
			if k2 == "Min" then
				return p13 <= p23
			end

			if k2 ~= "Max" then
				return
			end

			return p23 <= p13
		end
		function v.parse(p13, p23) --[[ parse | Line: 190 ]]
			for k2, v in pairs(p23) do
				if p13.parseCheck(v, p13.Values[k2] or v) then
					p13.Values[k2] = v
				end
			end
		end
	end

	for k2, v in pairs(p23) do
		local v1 = v.Size * 0.5

		for k22, v3 in pairs({
			v.CFrame * CFrame.new(-v1.X, -v1.Y, -v1.Z),
			v.CFrame * CFrame.new(-v1.X, -v1.Y, v1.Z),
			v.CFrame * CFrame.new(-v1.X, v1.Y, -v1.Z),
			v.CFrame * CFrame.new(-v1.X, v1.Y, v1.Z),
			v.CFrame * CFrame.new(v1.X, -v1.Y, -v1.Z),
			v.CFrame * CFrame.new(v1.X, -v1.Y, v1.Z),
			v.CFrame * CFrame.new(v1.X, v1.Y, -v1.Z),
			v.CFrame * CFrame.new(v1.X, v1.Y, v1.Z)
		}) do
			local v22, v32, v4 = v3:GetComponents()
			local t2 = { v22, v32, v4 }

			tbl2.Min:parse(t2)
			tbl2.Max:parse(t2)
		end
	end

	local function roundToFour(p13) --[[ roundToFour | Line: 222 ]]
		return math.floor((p13 + 2) / 4) * 4
	end

	local t2 = {}
	local t22 = {}

	for k2, v in pairs(tbl2) do
		for k22, v3 in pairs(v.Values) do
			local v5, v6

			v5 = if k2 == "Min" and t2 then t2 else t22
			v6 = if p33 then v3 else math.floor((v3 + (if k2 == "Min" then -2 else 2) + 2) / 4) * 4
			table.insert(v5, v6)
		end
	end

	local v10 = Vector3.new(unpack(t2))
	local v12 = Vector3.new(unpack(t22))

	return Region3.new(v10, v12), v10, v12
end
function t._displayBounds(p13) --[[ _displayBounds | Line: 245 ]]
	if p13.displayBoundParts then
		return
	end

	p13.displayBoundParts = true

	for k2, v in pairs({
		BoundMin = p13.boundMin,
		BoundMax = p13.boundMax
	}) do
		local Part = Instance.new("Part")

		Part.Anchored = true
		Part.CanCollide = false
		Part.Transparency = 0.5
		Part.Size = Vector3.new(1, 1, 1)
		Part.Color = Color3.fromRGB(255, 0, 0)
		Part.CFrame = CFrame.new(v)
		Part.Name = k2
		Part.Parent = workspace
		p13.janitor:add(Part, "Destroy")
	end
end
function t._update(p13) --[[ _update | Line: 264 | Upvalues: RunService (copy) ]]
	local container = p13.container
	local tbl2 = {}
	local v1 = 0

	p13._updateConnections:clean()

	local v2 = typeof(container)
	local tbl22 = {}

	if v2 == "table" then
		for k2, v in pairs(container) do
			if v:IsA("BasePart") then
				table.insert(tbl2, v)
			end
		end
	elseif v2 == "Instance" and container:IsA("BasePart") then
		table.insert(tbl2, container)
	elseif v2 == "Instance" then
		table.insert(tbl22, container)

		for k2, v in pairs(container:GetDescendants()) do
			if v:IsA("BasePart") then
				table.insert(tbl2, v)

				continue
			end

			table.insert(tbl22, v)
		end
	end

	p13.zoneParts = tbl2
	p13.overlapParams = {}

	local v3 = true

	for k2, v in pairs(tbl2) do
		local _, result = pcall(function() --[[ Line: 298 | Upvalues: v (copy) ]]
			return v.Shape.Name
		end)

		if result ~= "Block" then
			v3 = false
		end
	end

	p13.allZonePartsAreBlocks = v3

	local v4 = OverlapParams.new()

	v4.FilterType = Enum.RaycastFilterType.Whitelist
	v4.MaxParts = #tbl2
	v4.FilterDescendantsInstances = tbl2
	p13.overlapParams.zonePartsWhitelist = v4

	local v5 = OverlapParams.new()

	v5.FilterType = Enum.RaycastFilterType.Blacklist
	v5.FilterDescendantsInstances = tbl2
	p13.overlapParams.zonePartsIgnorelist = v5

	local function update() --[[ update | Line: 318 | Upvalues: p13 (copy), v1 (ref), RunService (ref) ]]
		if not p13.autoUpdate then
			return
		end

		local sum2 = os.clock()

		if p13.respectUpdateQueue then
			v1 = v1 + 1
			sum2 = sum2 + 0.1
		end

		local v12 = nil

		v12 = RunService.Heartbeat:Connect(function() --[[ Line: 326 | Upvalues: sum2 (ref), v12 (ref), p13 (ref), v1 (ref) ]]
			if not (sum2 <= os.clock()) then
				return
			end

			v12:Disconnect()

			if p13.respectUpdateQueue then
				v1 = v1 - 1
			end

			if v1 ~= 0 or not p13.zoneId then
				return
			end

			p13:_update()
		end)
	end

	local function verifyDefaultCollision(p13) --[[ verifyDefaultCollision | Line: 340 ]]
		if p13.CollisionGroupId == 0 then
			return
		end

		error("Zone parts must belong to the \'Default\' (0) CollisionGroup! Consider using zone:relocate() if you wish to move zones outside of workspace to prevent them interacting with other parts.")
	end

	local tbl3 = { "Size", "Position" }

	for k2, v in pairs(tbl2) do
		for k22, v7 in pairs(tbl3) do
			p13._updateConnections:add(v:GetPropertyChangedSignal(v7):Connect(update), "Disconnect")
		end

		if v.CollisionGroupId ~= 0 then
			error("Zone parts must belong to the \'Default\' (0) CollisionGroup! Consider using zone:relocate() if you wish to move zones outside of workspace to prevent them interacting with other parts.")
		end

		p13._updateConnections:add(v:GetPropertyChangedSignal("CollisionGroupId"):Connect(function() --[[ Line: 350 | Upvalues: v (copy) ]]
			if v.CollisionGroupId == 0 then
				return
			end

			error("Zone parts must belong to the \'Default\' (0) CollisionGroup! Consider using zone:relocate() if you wish to move zones outside of workspace to prevent them interacting with other parts.")
		end), "Disconnect")
	end

	local tbl4 = { "ChildAdded", "ChildRemoved" }

	for k2, v in pairs(tbl22) do
		for k22, v7 in pairs(tbl4) do
			p13._updateConnections:add(p13.container[v7]:Connect(function(p1) --[[ Line: 357 | Upvalues: p13 (copy), v1 (ref), RunService (ref) ]]
				if not (p1:IsA("BasePart") and p13.autoUpdate) then
					return
				end

				local sum2 = os.clock()

				if p13.respectUpdateQueue then
					v1 = v1 + 1
					sum2 = sum2 + 0.1
				end

				local v12 = nil

				v12 = RunService.Heartbeat:Connect(function() --[[ Line: 326 | Upvalues: sum2 (ref), v12 (ref), p13 (ref), v1 (ref) ]]
					if not (sum2 <= os.clock()) then
						return
					end

					v12:Disconnect()

					if p13.respectUpdateQueue then
						v1 = v1 - 1
					end

					if v1 ~= 0 or not p13.zoneId then
						return
					end

					p13:_update()
				end)
			end), "Disconnect")
		end
	end

	local v6, v7, v8 = p13:_calculateRegion(tbl2)
	local v9, _, _22 = p13:_calculateRegion(tbl2, true)

	p13.region = v6
	p13.exactRegion = v9
	p13.boundMin = v7
	p13.boundMax = v8

	local Size = v6.Size

	p13.volume = Size.X * Size.Y * Size.Z
	p13:_updateTouchedConnections()
	p13.updated:Fire()
end
function t._updateOccupants(p13, p23, p33) --[[ _updateOccupants | Line: 393 ]]
	local v1 = p13.occupants[p23]

	if not v1 then
		v1 = {}
		p13.occupants[p23] = v1
	end

	local t2 = {}

	for k2, v in pairs(v1) do
		local v2 = p33[k2]

		if v2 == nil or v2 ~= v then
			v1[k2] = nil

			if not t2.exited then
				t2.exited = {}
			end

			table.insert(t2.exited, k2)
		end
	end

	for k2, v in pairs(p33) do
		if v1[k2] == nil then
			v1[k2] = k2:IsA("Player") and k2.Character or true

			if not t2.entered then
				t2.entered = {}
			end

			table.insert(t2.entered, k2)
		end
	end

	return t2
end
function t._formTouchedConnection(p13, p23) --[[ _formTouchedConnection | Line: 423 | Upvalues: Janitor (copy) ]]
	local v1 = "_touchedJanitor" .. p23
	local v2 = p13[v1]

	if v2 then
		v2:clean()
	else
		p13[v1] = p13.janitor:add(Janitor.new(), "destroy")
	end

	p13:_updateTouchedConnection(p23)
end
function t._updateTouchedConnection(p13, p23) --[[ _updateTouchedConnection | Line: 435 ]]
	local v1 = p13["_touchedJanitor" .. p23]

	if not v1 then
		return
	end

	for k2, v in pairs(p13.zoneParts) do
		v1:add(v.Touched:Connect(p13.touchedConnectionActions[p23], p13), "Disconnect")
	end
end
function t._updateTouchedConnections(p13) --[[ _updateTouchedConnections | Line: 444 ]]
	for k2, v in pairs(p13.touchedConnectionActions) do
		local v1 = p13["_touchedJanitor" .. k2]

		if v1 then
			v1:cleanup()
			p13:_updateTouchedConnection(k2)
		end
	end
end
function t._disconnectTouchedConnection(p13, p23) --[[ _disconnectTouchedConnection | Line: 455 ]]
	local v1 = "_touchedJanitor" .. p23
	local v2 = p13[v1]

	if not v2 then
		return
	end

	v2:cleanup()
	p13[v1] = nil
end
_ = function(p13, p23) --[[ round | Line: 464 ]]
	return math.round(p13 * 10 ^ p23) * 10 ^ (-p23)
end
function t._partTouchedZone(p13, p23) --[[ _partTouchedZone | Line: 467 | Upvalues: Janitor (copy), Heartbeat (copy), enums (copy) ]]
	local part = p13.trackingTouchedTriggers.part

	if part[p23] then
		return
	end

	local v1 = 0
	local v2 = false
	local Position = p23.Position
	local v3 = os.clock()
	local v4 = p13.janitor:add(Janitor.new(), "destroy")

	part[p23] = v4

	if not ({
		Seat = true,
		VehicleSeat = true
	})[p23.ClassName] and ({
		HumanoidRootPart = true
	})[p23.Name] then
		p23.CanTouch = false
	end

	local v6 = math.round(p23.Size.X * p23.Size.Y * p23.Size.Z * 100000) * 0.00001

	p13.totalPartVolume = p13.totalPartVolume + v6
	v4:add(Heartbeat:Connect(function() --[[ Line: 485 | Upvalues: v1 (ref), enums (ref), p13 (copy), p23 (copy), v2 (ref), Position (ref), v3 (ref), v4 (copy) ]]
		local v12 = os.clock()

		if not (v1 <= v12) then
			return
		end

		local v22 = enums.Accuracy.getProperty(p13.accuracy)

		v1 = v12 + v22

		local v32 = p13:findPoint(p23.CFrame)

		if not v32 then
			v32 = p13:findPart(p23)
		end

		if v2 then
			if v32 then
				return
			end

			v2 = false
			Position = p23.Position
			v3 = os.clock()
			p13.partExited:Fire(p23)
		else
			if v32 then
				v2 = true
				p13.partEntered:Fire(p23)

				return
			end

			if (p23.Position - Position).Magnitude > 1.5 and v22 <= v12 - v3 then
				v4:cleanup()
			end
		end
	end), "Disconnect")
	v4:add(function() --[[ Line: 516 | Upvalues: part (copy), p23 (copy), p13 (copy), v6 (copy) ]]
		part[p23] = nil
		p23.CanTouch = true
		p13.totalPartVolume = math.round((p13.totalPartVolume - v6) * 100000) * 0.00001
	end, true)
end
v6 = {
	Ball = function(p13) --[[ Line: 524 ]]
		return "GetPartBoundsInRadius", { p13.Position, p13.Size.X }
	end,
	Block = function(p13) --[[ Line: 527 ]]
		return "GetPartBoundsInBox", { p13.CFrame, p13.Size }
	end,
	Other = function(p13) --[[ Line: 530 ]]
		return "GetPartsInPart", { p13 }
	end
}
function t._getRegionConstructor(p13, p23, p33) --[[ _getRegionConstructor | Line: 534 | Upvalues: v6 (copy) ]]
	local ok, result = pcall(function() --[[ Line: 535 | Upvalues: p23 (copy) ]]
		return p23.Shape.Name
	end)
	local v1 = nil
	local v2 = nil

	if ok and p13.allZonePartsAreBlocks then
		local v3 = v6[result]

		if v3 then
			local v4, v5 = v3(p23)

			v1 = v4
			v2 = v5
		end
	end

	if not v1 then
		v2 = { p23 }
		v1 = "GetPartsInPart"
	end

	if p33 then
		table.insert(v2, p33)
	end

	return v1, v2
end
function t.findLocalPlayer(p13) --[[ findLocalPlayer | Line: 555 | Upvalues: v1 (copy) ]]
	if v1 then
		return p13:findPlayer(v1)
	end

	error("Can only call \'findLocalPlayer\' on the client!")
end
function t._find(p13, p23, p33) --[[ _find | Line: 562 | Upvalues: v3 (copy) ]]
	v3.updateDetection(p13)

	for k2, v in pairs((v3.getTouchingZones(p33, false, p13._currentEnterDetection, v3.trackers[p23]))) do
		if v == p13 then
			return true
		end
	end

	return false
end
function t.findPlayer(p13, p23) --[[ findPlayer | Line: 574 ]]
	local Character = p23.Character

	if if Character then Character:FindFirstChildOfClass("Humanoid") else Character then
		return p13:_find("player", p23.Character)
	end

	return false
end
function t.findItem(p13, p23) --[[ findItem | Line: 583 ]]
	return p13:_find("item", p23)
end
function t.findPart(p13, p23) --[[ findPart | Line: 587 ]]
	local v1, v2 = p13:_getRegionConstructor(p23, p13.overlapParams.zonePartsWhitelist)
	local v3 = p13.worldModel[v1](p13.worldModel, unpack(v2))

	if #v3 > 0 then
		return true, v3
	end

	return false
end
function t.getCheckerPart(p13) --[[ getCheckerPart | Line: 597 | Upvalues: v3 (copy) ]]
	local checkerPart = p13.checkerPart

	if not checkerPart then
		local ZonePlusCheckerPart = p13.janitor:add(Instance.new("Part"), "Destroy")

		ZonePlusCheckerPart.Size = Vector3.new(0.1, 0.1, 0.1)
		ZonePlusCheckerPart.Name = "ZonePlusCheckerPart"
		ZonePlusCheckerPart.Anchored = true
		ZonePlusCheckerPart.Transparency = 1
		ZonePlusCheckerPart.CanCollide = false
		p13.checkerPart = ZonePlusCheckerPart
		checkerPart = ZonePlusCheckerPart
	end

	local worldModel = p13.worldModel

	if worldModel == workspace then
		worldModel = v3.getWorkspaceContainer()
	end

	if checkerPart.Parent ~= worldModel then
		checkerPart.Parent = worldModel
	end

	return checkerPart
end
function t.findPoint(p13, p23) --[[ findPoint | Line: 618 ]]
	local v1 = if typeof(p23) == "Vector3" then CFrame.new(p23) else p23
	local v3 = p13:getCheckerPart()

	v3.CFrame = v1

	local v4, v5 = p13:_getRegionConstructor(v3, p13.overlapParams.zonePartsWhitelist)
	local v6 = p13.worldModel[v4](p13.worldModel, unpack(v5))

	if #v6 > 0 then
		return true, v6
	end

	return false
end
function t._getAll(p13, p23) --[[ _getAll | Line: 635 | Upvalues: v3 (copy) ]]
	v3.updateDetection(p13)

	local t2 = {}
	local v1 = v3._getZonesAndItems(p23, {
		self = true
	}, p13.volume, false, p13._currentEnterDetection)[p13]

	if v1 then
		for k2, v in pairs(v1) do
			table.insert(t2, k2)
		end
	end

	return t2
end
function t.getPlayers(p13) --[[ getPlayers | Line: 648 ]]
	return p13:_getAll("player")
end
function t.getItems(p13) --[[ getItems | Line: 652 ]]
	return p13:_getAll("item")
end
function t.getParts(p13) --[[ getParts | Line: 656 ]]
	local t2 = {}

	if p13.activeTriggers.part then
		for k2, v in pairs(p13.trackingTouchedTriggers.part) do
			table.insert(t2, k2)
		end
	else
		for k2, v in pairs((p13.worldModel:GetPartBoundsInBox(p13.region.CFrame, p13.region.Size, p13.overlapParams.zonePartsIgnorelist))) do
			if p13:findPart(v) then
				table.insert(t2, v)
			end
		end
	end

	return t2
end
function t.getRandomPoint(p13) --[[ getRandomPoint | Line: 677 ]]
	local exactRegion = p13.exactRegion
	local Size = exactRegion.Size
	local v1 = exactRegion.CFrame
	local v2 = Random.new()
	local v3 = nil
	local v4, v5

	repeat
		v4 = v1 * CFrame.new(v2:NextNumber(-Size.X / 2, Size.X / 2), v2:NextNumber(-Size.Y / 2, Size.Y / 2), v2:NextNumber(-Size.Z / 2, Size.Z / 2))

		local v6

		v6, v5 = p13:findPoint(v4)

		if v6 then
			v3 = true
		end
	until v3

	return v4.Position, v5
end
function t.setAccuracy(p13, p23) --[[ setAccuracy | Line: 696 | Upvalues: enums (copy) ]]
	local v1 = tonumber(p23)

	if v1 then
		if not enums.Accuracy.getName(v1) then
			error(("%s is an invalid enumId!"):format(v1))
		end
	else
		v1 = enums.Accuracy[p23]

		if not v1 then
			error(("\'%s\' is an invalid enumName!"):format(p23))
		end
	end

	p13.accuracy = v1
end
function t.setDetection(p13, p23) --[[ setDetection | Line: 712 | Upvalues: enums (copy) ]]
	local v1 = tonumber(p23)

	if v1 then
		if not enums.Detection.getName(v1) then
			error(("%s is an invalid enumId!"):format(v1))
		end
	else
		v1 = enums.Detection[p23]

		if not v1 then
			error(("\'%s\' is an invalid enumName!"):format(p23))
		end
	end

	p13.enterDetection = v1
	p13.exitDetection = v1
end
function t.trackItem(p13, p23) --[[ trackItem | Line: 729 | Upvalues: Janitor (copy), Tracker (copy) ]]
	local v1 = p23:IsA("BasePart")
	local v2 = if v1 then false else p23:FindFirstChildOfClass("Humanoid") and p23:FindFirstChild("HumanoidRootPart")

	assert(v1 or v2, "Only BaseParts or Characters/NPCs can be tracked!")

	if p13.trackedItems[p23] then
		return
	end

	if p13.itemsToUntrack[p23] then
		p13.itemsToUntrack[p23] = nil
	end

	local v4 = p13.janitor:add(Janitor.new(), "destroy")
	local t2 = {
		janitor = v4,
		item = p23,
		isBasePart = v1,
		isCharacter = v2
	}

	p13.trackedItems[p23] = t2
	v4:add(p23.AncestryChanged:Connect(function() --[[ Line: 754 | Upvalues: p23 (copy), p13 (copy) ]]
		if p23:IsDescendantOf(game) then
			return
		end

		p13:untrackItem(p23)
	end), "Disconnect")
	require(Tracker).itemAdded:Fire(t2)
end
function t.untrackItem(p13, p23) --[[ untrackItem | Line: 764 | Upvalues: Tracker (copy) ]]
	local v1 = p13.trackedItems[p23]

	if v1 then
		v1.janitor:destroy()
	end

	p13.trackedItems[p23] = nil
	require(Tracker).itemRemoved:Fire(v1)
end
function t.bindToGroup(p13, p23) --[[ bindToGroup | Line: 775 | Upvalues: v3 (copy) ]]
	p13:unbindFromGroup();
	(v3.getGroup(p23) or v3.setGroup(p23))._memberZones[p13.zoneId] = p13
	p13.settingsGroupName = p23
end
function t.unbindFromGroup(p13) --[[ unbindFromGroup | Line: 782 | Upvalues: v3 (copy) ]]
	if not p13.settingsGroupName then
		return
	end

	local v1 = v3.getGroup(p13.settingsGroupName)

	if v1 then
		v1._memberZones[p13.zoneId] = nil
	end

	p13.settingsGroupName = nil
end
function t.relocate(p13) --[[ relocate | Line: 792 | Upvalues: CollectiveWorldModel (copy) ]]
	if p13.hasRelocated then
		return
	end

	local v1 = require(CollectiveWorldModel).setupWorldModel(p13)

	p13.worldModel = v1
	p13.hasRelocated = true

	local container = p13.container

	if typeof(container) == "table" then
		container = Instance.new("Folder")

		for k2, v in pairs(p13.zoneParts) do
			v.Parent = container
		end
	end

	p13.relocationContainer = p13.janitor:add(container, "Destroy", "RelocationContainer")
	container.Parent = v1
end
function t._onItemCallback(p13, p23, p33, p43, p53) --[[ _onItemCallback | Line: 813 ]]
	local v1 = p13.onItemDetails[p43]

	if not v1 then
		v1 = {}
		p13.onItemDetails[p43] = v1
	end

	if #v1 == 0 then
		p13.itemsToUntrack[p43] = true
	end

	table.insert(v1, p43)
	p13:trackItem(p43)

	local function triggerCallback() --[[ triggerCallback | Line: 825 | Upvalues: p53 (copy), p13 (copy), p43 (copy) ]]
		p53()

		if not p13.itemsToUntrack[p43] then
			return
		end

		p13.itemsToUntrack[p43] = nil
		p13:untrackItem(p43)
	end

	if p13:findItem(p43) == p33 then
		p53()

		if p13.itemsToUntrack[p43] then
			p13.itemsToUntrack[p43] = nil
			p13:untrackItem(p43)
		end
	else
		local v2 = nil

		v2 = p13[p23]:Connect(function(p1) --[[ Line: 838 | Upvalues: v2 (ref), p43 (copy), p53 (copy), p13 (copy) ]]
			if not v2 or p1 ~= p43 then
				return
			end

			v2:Disconnect()
			v2 = nil
			p53()

			if not p13.itemsToUntrack[p43] then
				return
			end

			p13.itemsToUntrack[p43] = nil
			p13:untrackItem(p43)
		end)
	end
end
function t.onItemEnter(p13, ...) --[[ onItemEnter | Line: 860 ]]
	p13:_onItemCallback("itemEntered", true, ...)
end
function t.onItemExit(p13, ...) --[[ onItemExit | Line: 864 ]]
	p13:_onItemCallback("itemExited", false, ...)
end
function t.destroy(p13) --[[ destroy | Line: 868 ]]
	p13:unbindFromGroup()
	p13.janitor:destroy()
end
t.Destroy = t.destroy

return t
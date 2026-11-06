-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Janitor = require(script.Parent.Janitor)
local v1 = require(script.Parent.Enum)

require(script.Parent.Signal)

local Tracker = require(script.Tracker)
local CollectiveWorldModel = require(script.CollectiveWorldModel)
local enums = v1.enums
local Players = game:GetService("Players")
local t = {}
local v2 = 0
local t2 = {}
local t3 = {}
local t4 = {}
local t5 = {}
local t6 = {}
local t7 = {}
local v3 = 0
local RunService = game:GetService("RunService")
local Heartbeat = RunService.Heartbeat
local t8 = {}
local v4 = RunService:IsClient() and Players.LocalPlayer
local t9 = {}
local t10 = {
	player = Tracker.new("player"),
	item = Tracker.new("item")
}

t9.trackers = t10

local function dictLength(p1) --[[ dictLength | Line: 40 ]]
	local count = 0

	for k, v in pairs(p1) do
		count = count + 1
	end

	return count
end

local function fillOccupants(p1, p2, p3) --[[ fillOccupants | Line: 48 ]]
	local v1 = p1[p2]

	if not v1 then
		v1 = {}
		p1[p2] = v1
	end

	v1[p3] = p3:IsA("Player") and p3.Character or true
end

local t11 = {
	player = function(p1) --[[ Line: 59 | Upvalues: t9 (copy), t (copy), v2 (ref) ]]
		return t9._getZonesAndItems("player", t, v2, true, p1)
	end,
	localPlayer = function(p1) --[[ Line: 62 | Upvalues: v4 (copy), t9 (copy), t10 (copy) ]]
		local t = {}
		local Character = v4.Character

		if not Character then
			return t
		end

		for k, v in pairs((t9.getTouchingZones(Character, true, p1, t10.player))) do
			if v.activeTriggers.localPlayer then
				local v2 = v4
				local v3 = t[v]

				if not v3 then
					v3 = {}
					t[v] = v3
				end

				v3[v2] = v2:IsA("Player") and v2.Character or true
			end
		end

		return t
	end,
	item = function(p1) --[[ Line: 76 | Upvalues: t9 (copy), t (copy), v2 (ref) ]]
		return t9._getZonesAndItems("item", t, v2, true, p1)
	end
}

function t9._registerZone(p1) --[[ _registerZone | Line: 84 | Upvalues: t3 (copy), Janitor (copy), t9 (copy) ]]
	t3[p1] = true

	local v1 = p1.janitor:add(Janitor.new(), "destroy")

	p1._registeredJanitor = v1
	v1:add(p1.updated:Connect(function() --[[ Line: 88 | Upvalues: t9 (ref) ]]
		t9._updateZoneDetails()
	end), "Disconnect")
	t9._updateZoneDetails()
end
function t9._deregisterZone(p1) --[[ _deregisterZone | Line: 94 | Upvalues: t3 (copy), t9 (copy) ]]
	t3[p1] = nil
	p1._registeredJanitor:destroy()
	p1._registeredJanitor = nil
	t9._updateZoneDetails()
end
function t9._registerConnection(p1, p2) --[[ _registerConnection | Line: 101 | Upvalues: v3 (ref), t (copy), t9 (copy), t2 (copy), t11 (copy) ]]
	local count = 0

	for k, v in pairs(p1.activeTriggers) do
		count = count + 1
	end

	v3 = v3 + 1

	if count == 0 then
		t[p1] = true
		t9._updateZoneDetails()
	end

	local v1 = t2[p2]

	t2[p2] = v1 and v1 + 1 or 1
	p1.activeTriggers[p2] = true

	if p1.touchedConnectionActions[p2] then
		p1:_formTouchedConnection(p2)
	end

	if not t11[p2] then
		return
	end

	t9._formHeartbeat(p2)
end
function t9.updateDetection(p1) --[[ updateDetection | Line: 121 | Upvalues: Tracker (copy), enums (copy) ]]
	for k, v in pairs({
		enterDetection = "_currentEnterDetection",
		exitDetection = "_currentExitDetection"
	}) do
		local v1 = p1[k]
		local v2 = Tracker.getCombinedTotalVolumes()

		if v1 == enums.Detection.Automatic then
			v1 = if v2 > 729000 then enums.Detection.Centre else enums.Detection.WholeBody
		end

		p1[v] = v1
	end
end
function t9._formHeartbeat(p1) --[[ _formHeartbeat | Line: 140 | Upvalues: t8 (copy), Heartbeat (copy), t (copy), t9 (copy), t11 (copy), enums (copy) ]]
	if not t8[p1] then
		local v1 = 0

		t8[p1] = Heartbeat:Connect(function() --[[ Line: 150 | Upvalues: v1 (ref), t (ref), p1 (copy), t9 (ref), t11 (ref), enums (ref) ]]
			local v12 = os.clock()

			if not (v1 <= v12) then
				return
			end

			local v2 = nil
			local v3 = nil

			for k, v in pairs(t) do
				if k.activeTriggers[p1] then
					local accuracy = k.accuracy

					if v2 == nil or accuracy < v2 then
						v2 = accuracy
					end

					t9.updateDetection(k)

					local _currentEnterDetection = k._currentEnterDetection

					if v3 == nil or _currentEnterDetection < v3 then
						v3 = _currentEnterDetection
					end
				end
			end

			local v4 = t11[p1](v3)
			local t2, v5, v6 = {}, {}, v2

			for k, v in pairs(v4) do
				local v7 = k.settingsGroupName and t9.getGroup(k.settingsGroupName)

				if v7 and v7.onlyEnterOnceExitedAll == true then
					for k2, v8 in pairs(v) do
						local v82 = t2[k.settingsGroupName]

						if not v82 then
							v82 = {}
							t2[k.settingsGroupName] = v82
						end

						v82[k2] = k
					end

					v5[k] = v
				end
			end

			for k, v in pairs(v5) do
				local v9 = t2[k.settingsGroupName]

				if v9 then
					for k2, v7 in pairs(v) do
						local v10 = v9[k2]

						if v10 and v10 ~= k then
							v[k2] = nil
						end
					end
				end
			end

			local tbl = {
				{},
				{}
			}

			for k, v in pairs(t) do
				if k.activeTriggers[p1] then
					local accuracy = k.accuracy
					local v11 = v4[k] or {}
					local v122 = false

					for k2, v7 in pairs(v11) do
						v122 = true

						break
					end

					if v122 and v6 < accuracy then
						v6 = accuracy
					end

					local v13 = k:_updateOccupants(p1, v11)

					tbl[1][k] = v13.exited
					tbl[2][k] = v13.entered
				end
			end

			local t3 = { "Exited", "Entered" }

			for k, v in pairs(tbl) do
				local v14 = p1 .. t3[k]

				for k2, v7 in pairs(v) do
					local v15 = k2[v14]

					if v15 then
						for k3, v8 in pairs(v7) do
							v15:Fire(v8)
						end
					end
				end
			end

			v1 = v12 + enums.Accuracy.getProperty(v6)
		end)
	end
end
function t9._deregisterConnection(p1, p2) --[[ _deregisterConnection | Line: 249 | Upvalues: v3 (ref), t2 (copy), t8 (copy), t (copy), t9 (copy) ]]
	v3 = v3 - 1

	if t2[p2] == 1 then
		t2[p2] = nil

		local v1 = t8[p2]

		if v1 then
			t8[p2] = nil
			v1:Disconnect()
		end
	else
		local v2 = t2

		v2[p2] = v2[p2] - 1
	end

	p1.activeTriggers[p2] = nil

	local count = 0

	for k, v in pairs(p1.activeTriggers) do
		count = count + 1
	end

	if count == 0 then
		t[p1] = nil
		t9._updateZoneDetails()
	end

	if not p1.touchedConnectionActions[p2] then
		return
	end

	p1:_disconnectTouchedConnection(p2)
end
function t9._updateZoneDetails() --[[ _updateZoneDetails | Line: 271 | Upvalues: t4 (ref), t5 (ref), t6 (ref), t7 (ref), v2 (ref), t3 (copy), t (copy) ]]
	t4 = {}
	t5 = {}
	t6 = {}
	t7 = {}
	v2 = 0

	for k, v in pairs(t3) do
		local v1 = t[k]

		if v1 then
			v2 = v2 + k.volume
		end

		for k2, v3 in pairs(k.zoneParts) do
			if v1 then
				table.insert(t4, v3)
				t5[v3] = k
			end

			table.insert(t6, v3)
			t7[v3] = k
		end
	end
end
function t9._getZonesAndItems(p1, p2, p3, p4, p5) --[[ _getZonesAndItems | Line: 293 | Upvalues: t10 (copy), t9 (copy), Players (copy), CollectiveWorldModel (copy) ]]
	local sum = p3

	if p3 then
	else
		for k, v in pairs(p2) do
			sum = sum + k.volume
		end
	end

	local t = {}
	local v1 = t10[p1]

	if v1.totalVolume < sum then
		for k, v in pairs(v1.items) do
			for k2, v4 in pairs((t9.getTouchingZones(v, p4, p5, v1))) do
				local v3

				if not p4 or v4.activeTriggers[p1] then
					v3 = if p1 == "player" then Players:GetPlayerFromCharacter(v) else v

					if v3 then
						local v5 = t[v4]

						if not v5 then
							v5 = {}
							t[v4] = v5
						end

						v5[v3] = v3:IsA("Player") and v3.Character or true
					end
				end
			end
		end
	else
		for k, v in pairs(p2) do
			if not p4 or k.activeTriggers[p1] then
				local tbl = {}

				for k2, v2 in pairs((CollectiveWorldModel:GetPartBoundsInBox(k.region.CFrame, k.region.Size, v1.whitelistParams))) do
					local v9 = v1.partToItem[v2]

					if not tbl[v9] then
						tbl[v9] = true
					end
				end

				for k2, v2 in pairs(tbl) do
					if p1 == "player" then
						local v10 = Players:GetPlayerFromCharacter(k2)

						if k:findPlayer(v10) then
							local v11 = t[k]

							if not v11 then
								v11 = {}
								t[k] = v11
							end

							v11[v10] = v10:IsA("Player") and v10.Character or true
						end

						continue
					end

					if k:findItem(k2) then
						local v13 = t[k]

						if not v13 then
							v13 = {}
							t[k] = v13
						end

						v13[k2] = k2:IsA("Player") and k2.Character or true
					end
				end
			end
		end
	end

	return t
end
function t9.getZones() --[[ getZones | Line: 354 | Upvalues: t3 (copy) ]]
	local t = {}

	for k, v in pairs(t3) do
		table.insert(t, k)
	end

	return t
end
function t9.getTouchingZones(p1, p2, p3, p4) --[[ getTouchingZones | Line: 374 | Upvalues: enums (copy), Tracker (copy), t4 (ref), t6 (ref), t5 (ref), t7 (ref), CollectiveWorldModel (copy) ]]
	local v1

	if p4 then
		v1 = p4.exitDetections[p1]
		p4.exitDetections[p1] = nil
	else
		v1 = nil
	end

	local v2 = v1 or p3
	local v3 = nil
	local v4 = nil
	local v5 = p1:IsA("BasePart")
	local v6 = not v5
	local tbl = {}

	if v5 then
		v3 = p1.Size
		v4 = p1.CFrame
		table.insert(tbl, p1)
	elseif v2 == enums.Detection.WholeBody then
		local v7, v8 = Tracker.getCharacterSize(p1)

		v3, v4, tbl = v7, v8, p1:GetChildren()
	else
		local HumanoidRootPart = p1:FindFirstChild("HumanoidRootPart")

		if HumanoidRootPart then
			v3 = HumanoidRootPart.Size
			v4 = HumanoidRootPart.CFrame
			table.insert(tbl, HumanoidRootPart)
		end
	end

	if not (v3 and v4) then
		return {}
	end

	local v10 = p2 and t4 or t6
	local v11 = p2 and t5 or t7
	local v12 = OverlapParams.new()

	v12.FilterType = Enum.RaycastFilterType.Whitelist
	v12.MaxParts = #v10
	v12.FilterDescendantsInstances = v10

	local tbl2 = {}
	local t = {}
	local t2 = {}

	for k, v in pairs((CollectiveWorldModel:GetPartBoundsInBox(v4, v3, v12))) do
		local v14 = v11[v]

		if v14 and v14.allZonePartsAreBlocks then
			tbl2[v14] = true
			t[v] = v14

			continue
		end

		table.insert(t2, v)
	end

	local v15 = #t2
	local count = 0

	if v15 > 0 then
		local v16 = OverlapParams.new()

		v16.FilterType = Enum.RaycastFilterType.Whitelist
		v16.MaxParts = v15
		v16.FilterDescendantsInstances = t2

		for k, v in pairs(tbl) do
			local v17 = false

			if v:IsA("BasePart") and not (v6 and Tracker.bodyPartsToIgnore[v.Name]) then
				for k2, v7 in pairs((CollectiveWorldModel:GetPartsInPart(v, v16))) do
					if not t[v7] then
						local v19 = v11[v7]

						if v19 then
							tbl2[v19] = true
							t[v7] = v19
							count = count + 1
						end

						if count == v15 then
							v17 = true

							break
						end
					end
				end

				if v17 then
					break
				end
			end
		end
	end

	local v20 = nil
	local t3 = {}

	for k, v in pairs(tbl2) do
		if v20 == nil or k._currentExitDetection < v20 then
			v20 = k._currentExitDetection
		end

		table.insert(t3, k)
	end

	if not (v20 and p4) then
		return t3, t
	end

	p4.exitDetections[p1] = v20

	return t3, t
end

local t12 = {}

function t9.setGroup(p1, p2) --[[ setGroup | Line: 491 | Upvalues: t12 (copy) ]]
	local v1 = t12[p1]

	if not v1 then
		v1 = {}
		t12[p1] = v1
	end

	v1.onlyEnterOnceExitedAll = true
	v1._name = p1
	v1._memberZones = {}

	if typeof(p2) == "table" then
		for k, v in pairs(p2) do
			v1[k] = v
		end
	end

	return v1
end
function t9.getGroup(p1) --[[ getGroup | Line: 515 | Upvalues: t12 (copy) ]]
	return t12[p1]
end

local v5 = nil
local v8 = string.format("ZonePlus%sContainer", if RunService:IsClient() then "Client" else "Server")

function t9.getWorkspaceContainer() --[[ getWorkspaceContainer | Line: 521 | Upvalues: v5 (ref), v8 (copy) ]]
	local v1 = v5 or workspace:FindFirstChild(v8)

	if not v1 then
		local v2 = Instance.new("Folder")

		v2.Name = v8
		v2.Parent = workspace
		v5 = v2
		v1 = v2
	end

	return v1
end

return t9
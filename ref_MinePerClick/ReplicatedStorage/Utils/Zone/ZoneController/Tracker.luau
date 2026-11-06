-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Players = game:GetService("Players")
local Heartbeat = game:GetService("RunService").Heartbeat
local Signal = require(script.Parent.Parent.Signal)
local Janitor = require(script.Parent.Parent.Janitor)
local t = {}

t.__index = t

local t2 = {}

t.trackers = t2
t.itemAdded = Signal.new()
t.itemRemoved = Signal.new()
t.bodyPartsToIgnore = {
	UpperTorso = true,
	LowerTorso = true,
	Torso = true,
	LeftHand = true,
	RightHand = true,
	LeftFoot = true,
	RightFoot = true
}
function t.getCombinedTotalVolumes() --[[ getCombinedTotalVolumes | Line: 35 | Upvalues: t2 (copy) ]]
	local sum = 0

	for k, v in pairs(t2) do
		sum = sum + k.totalVolume
	end

	return sum
end
function t.getCharacterSize(p1) --[[ getCharacterSize | Line: 43 ]]
	local v1 = if p1 then p1:FindFirstChild("Head") else p1
	local v2 = if p1 then p1:FindFirstChild("HumanoidRootPart") else p1

	if not (v2 and v1) then
		return nil
	end

	if not v1:IsA("BasePart") then
		v1 = v2
	end

	local Y = v1.Size.Y
	local Size = v2.Size

	return Size * Vector3.new(2, 2, 1) + Vector3.new(0, Y, 0), v2.CFrame * CFrame.new(0, Y / 2 - Size.Y / 2, 0)
end
function t.new(p1) --[[ new | Line: 60 | Upvalues: t (copy), Janitor (copy), Players (copy), t2 (copy) ]]
	local t3 = {}

	setmetatable(t3, t)
	t3.name = p1
	t3.totalVolume = 0
	t3.parts = {}
	t3.partToItem = {}
	t3.items = {}
	t3.whitelistParams = nil
	t3.characters = {}
	t3.baseParts = {}
	t3.exitDetections = {}
	t3.janitor = Janitor.new()

	if p1 == "player" then
		local function updatePlayerCharacters() --[[ updatePlayerCharacters | Line: 76 | Upvalues: Players (ref), t3 (copy) ]]
			local t = {}

			for k, v in pairs(Players:GetPlayers()) do
				local Character = v.Character

				if Character then
					t[Character] = true
				end
			end

			t3.characters = t
		end

		local function playerAdded(p1) --[[ playerAdded | Line: 87 | Upvalues: updatePlayerCharacters (copy), t3 (copy) ]]
			local function charAdded(p1) --[[ charAdded | Line: 88 | Upvalues: updatePlayerCharacters (ref), t3 (ref) ]]
				local Humanoid = p1:WaitForChild("Humanoid", 3)

				if not Humanoid then
					return
				end

				updatePlayerCharacters()
				t3:update()

				for k, v in pairs(Humanoid:GetChildren()) do
					if v:IsA("NumberValue") then
						v.Changed:Connect(function() --[[ Line: 95 | Upvalues: t3 (ref) ]]
							t3:update()
						end)
					end
				end
			end

			if p1.Character then
				charAdded(p1.Character)
			end

			p1.CharacterAdded:Connect(charAdded)
			p1.CharacterRemoving:Connect(function(p1) --[[ Line: 106 | Upvalues: t3 (ref) ]]
				t3.exitDetections[p1] = nil
			end)
		end

		Players.PlayerAdded:Connect(playerAdded)

		for k, v in pairs(Players:GetPlayers()) do
			playerAdded(v)
		end

		Players.PlayerRemoving:Connect(function(p1) --[[ Line: 116 | Upvalues: updatePlayerCharacters (copy), t3 (copy) ]]
			updatePlayerCharacters()
			t3:update()
		end)
	elseif p1 == "item" then
		local function updateItem(p1, p2) --[[ updateItem | Line: 123 | Upvalues: t3 (copy) ]]
			if p1.isCharacter then
				t3.characters[p1.item] = p2
			else
				if not p1.isBasePart then
					t3:update()

					return
				end

				t3.baseParts[p1.item] = p2
			end

			t3:update()
		end

		t.itemAdded:Connect(function(p1) --[[ Line: 131 | Upvalues: t3 (copy) ]]
			if p1.isCharacter then
				t3.characters[p1.item] = true
			else
				if not p1.isBasePart then
					t3:update()

					return
				end

				t3.baseParts[p1.item] = true
			end

			t3:update()
		end)
		t.itemRemoved:Connect(function(p1) --[[ Line: 134 | Upvalues: t3 (copy) ]]
			t3.exitDetections[p1.item] = nil

			if p1.isCharacter then
				t3.characters[p1.item] = nil
			else
				if not p1.isBasePart then
					t3:update()

					return
				end

				t3.baseParts[p1.item] = nil
			end

			t3:update()
		end)
	end

	t2[t3] = true
	task.defer(t3.update, t3)

	return t3
end
function t._preventMultiFrameUpdates(p1, p2, ...) --[[ _preventMultiFrameUpdates | Line: 148 ]]
	p1._preventMultiDetails = p1._preventMultiDetails or {}

	local v2 = p1._preventMultiDetails[p2]

	if not v2 then
		v2 = {
			calling = false,
			callsThisFrame = 0,
			updatedThisFrame = false
		}
		p1._preventMultiDetails[p2] = v2
	end

	v2.callsThisFrame = v2.callsThisFrame + 1

	if v2.callsThisFrame == 1 then
		local v3 = table.pack(...)

		task.defer(function() --[[ Line: 165 | Upvalues: v2 (ref), p1 (copy), p2 (copy), v3 (copy) ]]
			local callsThisFrame = v2.callsThisFrame

			v2.callsThisFrame = 0

			if not (callsThisFrame > 1) then
				return
			end

			p1[p2](p1, unpack(v3))
		end)

		return false
	end

	return true
end
function t.update(p1) --[[ update | Line: 177 | Upvalues: t (copy), Janitor (copy) ]]
	if p1:_preventMultiFrameUpdates("update") then
		return
	end

	p1.totalVolume = 0
	p1.parts = {}
	p1.partToItem = {}
	p1.items = {}

	for k, v in pairs(p1.characters) do
		local v1 = t.getCharacterSize(k)

		if v1 then
			p1.totalVolume = p1.totalVolume + v1.X * v1.Y * v1.Z

			local v3 = p1.janitor:add(Janitor.new(), "destroy", "trackCharacterParts-" .. p1.name)

			local function updateTrackerOnParentChanged(p12) --[[ updateTrackerOnParentChanged | Line: 198 | Upvalues: v3 (ref), p1 (copy) ]]
				v3:add(p12.AncestryChanged:Connect(function() --[[ Line: 199 | Upvalues: p12 (copy), v3 (ref), p1 (ref) ]]
					if p12:IsDescendantOf(game) or (p12.Parent ~= nil or v3 == nil) then
						return
					end

					v3:destroy()
					v3 = nil
					p1:update()
				end), "Disconnect")
			end

			for k2, v4 in pairs(k:GetChildren()) do
				if v4:IsA("BasePart") and not t.bodyPartsToIgnore[v4.Name] then
					p1.partToItem[v4] = k
					table.insert(p1.parts, v4)
					v3:add(v4.AncestryChanged:Connect(function() --[[ Line: 199 | Upvalues: v4 (copy), v3 (ref), p1 (copy) ]]
						if v4:IsDescendantOf(game) or (v4.Parent ~= nil or v3 == nil) then
							return
						end

						v3:destroy()
						v3 = nil
						p1:update()
					end), "Disconnect")
				end
			end

			v3:add(k.AncestryChanged:Connect(function() --[[ Line: 199 | Upvalues: k (copy), v3 (ref), p1 (copy) ]]
				if k:IsDescendantOf(game) or (k.Parent ~= nil or v3 == nil) then
					return
				end

				v3:destroy()
				v3 = nil
				p1:update()
			end), "Disconnect")
			table.insert(p1.items, k)
		end
	end

	for k, v in pairs(p1.baseParts) do
		local Size = k.Size

		p1.totalVolume = p1.totalVolume + Size.X * Size.Y * Size.Z
		p1.partToItem[k] = k
		table.insert(p1.parts, k)
		table.insert(p1.items, k)
	end

	p1.whitelistParams = OverlapParams.new()
	p1.whitelistParams.FilterType = Enum.RaycastFilterType.Whitelist
	p1.whitelistParams.MaxParts = #p1.parts
	p1.whitelistParams.FilterDescendantsInstances = p1.parts
end

return t
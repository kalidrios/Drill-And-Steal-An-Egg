-- decompiled by Sentinel (took 8.18447ms)
local v_u_1 = require(game.ReplicatedStorage.Library)
v_u_1.Load()
require(game:GetService("ReplicatedStorage"):WaitForChild("Library"):WaitForChild("Modules").Pets)
require(script.Parent.Common)
local v_u_2 = v_u_1.LocalPlayer.PlayerGui:WaitForChild("Dismount")
local v_u_3 = Random.new()
local v_u_56 = {}
v_u_56 = {
	["hasPetRidingLocal"] = false, 
	["petRidingLocal"] = nil, 
	["new"] = function(p_u_4)
		-- upvalues: (copy) v_u_1, (copy) v_u_3, (copy) v_u_56, (copy) v_u_2
		local v5 = p_u_4.spawned.part
		local v6 = v_u_1.Directory.Pets[p_u_4.spawned.id]
		local v7 = p_u_4.spawned.center
		local v8 = p_u_4.spawned.bottom
		local v9 = p_u_4.spawned.mount
		assert(v9)
		local v10 = getFullAttachmentCFrame(v9, p_u_4.spawned, false)
		local v11 = p_u_4.spawned.owner
		local v_u_12 = v11.Character
		assert(v_u_12)
		assert(v_u_12.PrimaryPart)
		local v_u_13 = v_u_12:FindFirstChildOfClass("Humanoid")
		assert(v_u_13)
		local v_u_14 = v11 == v_u_1.LocalPlayer
		local v_u_15 = v_u_13:GetAppliedDescription()
		local v16
		if v6.ridingGravity then
			v16 = workspace.Gravity
			workspace.Gravity = v6.ridingGravity
		else
			v16 = nil
		end
		local v17 = v_u_13.WalkSpeed
		v_u_13.WalkSpeed = v6.ridingWalkSpeed or 48
		local v18 = v_u_13.JumpPower
		v_u_13.JumpPower = v6.ridingJumpPower or 75
		local v19 = v_u_13.HipHeight
		v_u_13.HipHeight = v19 + v7.CFrame.Y - v8.CFrame.Y
		local v20 = Vector3.new(0, v10.Y - v7.CFrame.Y, 0) + Vector3.new(0, -1.5, 0)
		if v6.ridingCameraOffset then
			v20 = v20 + v6.ridingCameraOffset
		end
		local v21 = v_u_13.CameraOffset
		v_u_13.CameraOffset = v21 + v20
		local v_u_22
		if v_u_14 then
			v_u_22 = nil
		else
			v_u_22 = v_u_13.DisplayDistanceType
			v_u_13.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
		end
		local v23 = {}
		local v24 = {}
		local v25 = {}
		local v26 = {}
		local v27 = {}
		local v28 = {}
		local v29 = {}
		for _, v30 in ipairs(v_u_12:GetDescendants()) do
			if v30:IsA("BasePart") then
				local v31 = v30.Transparency
				if v31 < 1 then
					v30.Transparency = 1
					v23[v30] = v31
				end
				if v30.CastShadow then
					v30.CastShadow = false
					table.insert(v24, v30)
				end
			elseif v30:IsA("ParticleEmitter") then
				if v30.Enabled then
					v30.Enabled = false
					table.insert(v25, v30)
				end
			elseif v30:IsA("Trail") then
				if v30.Enabled then
					v30.Enabled = false
					table.insert(v26, v30)
				end
			elseif v30:IsA("Light") then
				if v30.Enabled then
					v30.Enabled = false
					table.insert(v27, v30)
				end
			elseif v30:IsA("Sound") then
				if 0 < v30.Volume then
					v28[v30] = v30.Volume
					v30.Volume = 0
				end
			elseif v30:IsA("Decal") and 0 < v30.Transparency then
				v29[v30] = v30.Transparency
				v30.Transparency = 1
			end
		end
		v_u_1.Audio.Play("rbxassetid://7000720081", v5, v_u_3:NextNumber(0.95, 1.05), 0.125, 125)
		local v_u_32 = setmetatable({
			["destroyed"] = false, 
			["petInfo"] = p_u_4, 
			["originalGravity"] = v16, 
			["originalTransparencies"] = v23, 
			["originalCastShadows"] = v24, 
			["originalParticleEmitters"] = v25, 
			["originalTrails"] = v26, 
			["originalLights"] = v27, 
			["originalVolumes"] = v28, 
			["originalDecalTransparencies"] = v29, 
			["originalWalkSpeed"] = v17, 
			["originalJumpPower"] = v18, 
			["originalHipHeight"] = v19, 
			["originalCameraOffset"] = v21, 
			["originalDisplayDistanceType"] = v_u_22, 
			["characterCopyTransparency"] = 1
		}, {
			["__index"] = v_u_56
		})
		task.spawn(function()
			-- upvalues: (ref) v_u_1, (copy) v_u_15, (copy) v_u_13, (copy) v_u_32, (copy) v_u_14, (ref) v_u_22, (copy) p_u_4, (copy) v_u_12
			local v_u_33 = v_u_1.Players:CreateHumanoidModelFromDescription(v_u_15, v_u_13.RigType, Enum.AssetTypeVerification.ClientOnly)
			if v_u_32.destroyed then
				v_u_33:Destroy()
			else
				local v34 = v_u_33.PrimaryPart
				local v35 = v_u_33:FindFirstChildOfClass("Humanoid")
				v35.PlatformStand = true
				v35.AutoJumpEnabled = false
				v35.AutoRotate = false
				if v_u_14 then
					v35.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
				elseif v_u_22 then
					v35.DisplayDistanceType = v_u_22
				end
				local v36 = v_u_33:FindFirstChild("animate")
				if v36 then
					v36:Destroy()
				end
				for _, v37 in ipairs(v_u_33:GetDescendants()) do
					if v37:IsA("Sound") then
						v37.Volume = 0
					end
				end
				v_u_33.Parent = p_u_4.spawned.part
				v_u_33:PivotTo(v_u_12:GetPivot())
				v34.Anchored = true
				for _, v38 in ipairs(v_u_33:GetDescendants()) do
					if v38:IsA("BasePart") then
						v38.CanCollide = false
						v38.CanQuery = false
						v38.CanTouch = false
						v38.Massless = true
						if v_u_14 then
							v38:SetAttribute("RidingOriginalTransparency", v38.Transparency)
						end
					elseif v38:IsA("Decal") and v_u_14 then
						v38:SetAttribute("RidingOriginalTransparency", v38.Transparency)
					end
				end
				local function v_u_40()
					-- upvalues: (copy) v_u_33
					for _, v39 in ipairs(v_u_33:GetDescendants()) do
						if v39:IsA("BasePart") then
							v39.CanCollide = false
							v39.CanQuery = false
							v39.CanTouch = false
						end
					end
				end
				v_u_32.stateChangeConnection = v35.StateChanged:Connect(function()
					-- upvalues: (copy) v_u_40
					task.defer(v_u_40)
				end)
				task.defer(v_u_40)
				v_u_32.characterCopy = v_u_33
				local v41 = v_u_1.Assets.Particles:FindFirstChild("Pet Spawn"):Clone()
				v41.Parent = v34
				v41:Emit(15)
				v_u_1.Functions.AddDebris(v41, 4)
				v35:FindFirstChildOfClass("Animator"):LoadAnimation((script:WaitForChild("RidingAnimation"))):Play()
			end
		end)
		if v_u_14 then
			v_u_2.Enabled = true
		end
		return v_u_32
	end, 
	["computePetCFrame"] = function(p42)
		local v43 = p42.petInfo
		local v44 = v43.spawned.part
		local v45 = v43.spawned.mount
		assert(v45)
		local v46 = getFullAttachmentCFrame(v45, v43.spawned, false)
		local v47 = v46 - Vector3.new(0, v46.Y, 0)
		local v48 = v43.spawned.owner.Character
		if not v48 then
			return v44.CFrame
		end
		local v49 = v48.PrimaryPart
		if not v49 then
			return v44.CFrame
		end
		local v50 = v48:FindFirstChildOfClass("Humanoid")
		if not v50 then
			return v44.CFrame
		end
		local v51 = v49.CFrame
		local _, v52, _ = v51:ToOrientation()
		local v53 = CFrame.fromOrientation(0, v52, 0) + v51.Position
		local v54 = v53 - Vector3.new(0, v49.Size.Y / 2 + v50.HipHeight, 0) * v53.UpVector
		local v55 = workspace.FallenPartsDestroyHeight + 25
		if v54.Y < v55 then
			v54 = v54 + Vector3.new(0, v55 - v54.Y, 0)
		end
		return v54 * v47:Inverse()
	end
}
function getFullAttachmentCFrame(p57, p58, p59)
	local v60 = p57.CFrame
	if p59 then
		local v61 = p57.Parent
		if v61 then
			if v61:IsA("BasePart") then
				local v62 = p58.scriptedWelds[v61]
				if v62 then
					v60 = v62.lastOffset * v60
				end
			end
		end
	end
	return v60
end
function v_u_56.updateCharacterCopy(p63, p64)
	-- upvalues: (copy) v_u_1
	local v65 = p63.characterCopy
	if v65 then
		local v66 = v65.PrimaryPart
		if not v66 then
			return
		end
		local v67 = v65:FindFirstChildOfClass("Humanoid")
		if not v67 then
			return
		end
		local v68 = p63.petInfo
		local v69 = v68.spawned.owner == v_u_1.LocalPlayer
		local v70 = v68.spawned.mount
		assert(v70)
		local v71 = p64 * getFullAttachmentCFrame(v70, v68.spawned, true)
		local v72 = v66.Size.Y / 2 + v67.HipHeight
		local v73 = v65:FindFirstChild("LeftFoot")
		if v73 then
			v72 = -(v66.CFrame:Inverse() * v73.CFrame).Position.Y
		end
		v65:PivotTo(v71 + Vector3.new(0, v72, 0) * v71.UpVector)
		if v69 then
			local v74 = workspace.CurrentCamera
			local v75 = 1 - (math.clamp((v74.CFrame.Position - v74.Focus.Position).Magnitude, 1.5, 3.5) - 1.5) / 2
			local v76 = v_u_1.Directory.Pets[v68.spawned.id]
			if v76 then
				if v76.ridingTransparency then
					v75 = 1 - v_u_1.Functions.Map(1 - v75, 0, 1, 0, 1 - v76.ridingTransparency)
				end
			end
			if p63.characterCopyTransparency ~= v75 then
				p63.characterCopyTransparency = v75
				for _, v77 in ipairs(v65:GetDescendants()) do
					local v78 = (v77:IsA("BasePart") or v77:IsA("Decal")) and v77:GetAttribute("RidingOriginalTransparency")
					if v78 then
						v77.Transparency = v78 * (1 - v75) + 1 * v75
					end
				end
			end
		end
	end
end
function v_u_56.destroy(p79)
	-- upvalues: (copy) v_u_1, (copy) v_u_3, (copy) v_u_2
	if not p79.destroyed then
		p79.destroyed = true
		local v80 = p79.stateChangeConnection
		if v80 then
			p79.stateChangeConnection = nil
			v80:Disconnect()
		end
		if p79.originalGravity then
			workspace.Gravity = p79.originalGravity
		end
		local v81 = p79.petInfo
		v_u_1.Audio.Play("rbxassetid://7139317934", v81.spawned.part, v_u_3:NextNumber(0.95, 1.05), 0.75)
		local v82 = v81.spawned.owner
		if v82 == v_u_1.LocalPlayer then
			v_u_2.Enabled = false
		end
		local v83 = v82 and v82.Character
		if v83 then
			local v84 = v83.PrimaryPart
			local v85 = v84 and v83:FindFirstChildOfClass("Humanoid")
			if v85 then
				local v86 = v_u_1.Assets.Particles:FindFirstChild("Pet Spawn"):Clone()
				v86.Parent = v84
				v86:Emit(15)
				v_u_1.Functions.AddDebris(v86, 4)
				v85.WalkSpeed = p79.originalWalkSpeed
				v85.JumpPower = p79.originalJumpPower
				v85.HipHeight = p79.originalHipHeight
				v85.CameraOffset = p79.originalCameraOffset
				if p79.originalDisplayDistanceType then
					v85.DisplayDistanceType = p79.originalDisplayDistanceType
				end
			end
		end
		for v87, v88 in pairs(p79.originalTransparencies) do
			if v87 then
				v87.Transparency = v88
			end
		end
		for _, v89 in ipairs(p79.originalCastShadows) do
			if v89 then
				v89.CastShadow = true
			end
		end
		for _, v90 in ipairs(p79.originalParticleEmitters) do
			if v90 then
				v90.Enabled = true
			end
		end
		for _, v91 in ipairs(p79.originalTrails) do
			if v91 then
				v91.Enabled = true
			end
		end
		for _, v92 in ipairs(p79.originalLights) do
			if v92 then
				v92.Enabled = true
			end
		end
		for v93, v94 in pairs(p79.originalVolumes) do
			if v93 then
				v93.Volume = v94
			end
		end
		for v95, v96 in pairs(p79.originalDecalTransparencies) do
			if v95 then
				v95.Transparency = v96
			end
		end
		local v97 = p79.characterCopy
		if v97 then
			v97:Destroy()
		end
	end
end
function v_u_56.isRiding(p98, p99)
	-- upvalues: (copy) v_u_1, (copy) v_u_56
	if p98.target == p98.spawned.owner then
		local v100 = v_u_1.Directory.Pets[p98.spawned.id]
		if v100 then
			if v100.titanic then
				local v101 = p98.spawned.owner
				if v101 and v101.Parent then
					if v101:FindFirstChild("__LOADED") then
						if v101:GetAttribute("UsingHoverboard") then
							return false
						elseif v101:GetAttribute("UsingCannon") then
							return false
						else
							local v102 = v101.Character
							if v102 then
								assert(v102)
								local v103 = v102.PrimaryPart
								if v103 then
									assert(v103)
									local v104 = v102:FindFirstChildOfClass("Humanoid")
									if v104 then
										assert(v104)
										if v104.Health <= 0 then
											return false
										else
											if v101 == v_u_1.LocalPlayer then
												if v_u_1.Variables.LoadingWorld then
													return false
												end
												if v_u_1.Variables.UsingCannon then
													return false
												end
												if v_u_1.Variables.UsingHoverboard then
													return false
												end
												if v_u_1.Variables.Teleporting then
													return false
												end
												if v_u_56.hasPetRidingLocal then
													return v_u_56.petRidingLocal == p98.spawned.uid
												end
											end
											local v105 = v_u_1.Save.Get(v101)
											if v105 then
												assert(v105)
												if v_u_1.Shared.HasPetEquipped(v105, p99) then
													return v105[v_u_1.Shared.IsHardcore and "HardcoreRidingPet" or "RidingPet"] == p98.spawned.uid
												else
													return false
												end
											else
												return false
											end
										end
									else
										return false
									end
								else
									return false
								end
							else
								return false
							end
						end
					else
						return false
					end
				else
					return false
				end
			else
				return false
			end
		else
			return false
		end
	else
		return false
	end
end
local v_u_106 = {}
function v_u_56.getLocal()
	-- upvalues: (copy) v_u_106, (copy) v_u_1
	return v_u_106[v_u_1.LocalPlayer]
end
function v_u_56.get(p107)
	-- upvalues: (copy) v_u_106
	return v_u_106[p107]
end
function v_u_56.destroyByPlayer(p108)
	-- upvalues: (copy) v_u_106
	local v109 = v_u_106[p108]
	if v109 then
		v_u_106[p108] = nil
		v109:destroy()
	end
end
function v_u_56.process(p110, p111)
	-- upvalues: (copy) v_u_106, (copy) v_u_56
	local v112 = p110.spawned.owner
	local v113 = v_u_106[v112]
	local v114
	if v113 then
		if v113.petInfo == p110 then
			v114 = v113
		else
			v114 = nil
		end
	else
		v114 = v113
	end
	if v_u_56.isRiding(p110, p111) then
		if not v114 then
			if v113 then
				v_u_106[v112] = nil
				v113:destroy()
			end
			local v115 = v_u_56.new(p110)
			v_u_106[v112] = v115
			return v115
		end
	elseif v114 then
		v_u_106[v112] = nil
		v114:destroy()
	end
	return v114
end
function v_u_56.stopRidingLocal()
	-- upvalues: (copy) v_u_56, (copy) v_u_1
	v_u_56.destroyByPlayer(v_u_1.LocalPlayer)
	if not v_u_56.hasPetRidingLocal or v_u_56.petRidingLocal ~= nil then
		v_u_56.petRidingLocal = nil
		v_u_56.hasPetRidingLocal = true
		v_u_1.Network.Fire("Set Riding Pet", nil)
	end
end
v_u_1.Signal.Fired("Entered Cannon"):Connect(function()
	-- upvalues: (copy) v_u_56, (copy) v_u_1
	v_u_56.destroyByPlayer(v_u_1.LocalPlayer)
end)
v_u_1.Signal.Fired("Other Entered Cannon"):Connect(function(p116)
	-- upvalues: (copy) v_u_56
	v_u_56.destroyByPlayer(p116)
end)
v_u_1.Signal.Fired("World Changed"):Connect(function()
	-- upvalues: (copy) v_u_1, (copy) v_u_56
	if v_u_1.Variables.UsingHoverboard then
		v_u_56.destroyByPlayer(v_u_1.LocalPlayer)
	end
end)
v_u_1.Signal.Fired("Toggled Hoverboard"):Connect(function()
	-- upvalues: (copy) v_u_1, (copy) v_u_56
	if v_u_1.Variables.UsingHoverboard then
		v_u_56.destroyByPlayer(v_u_1.LocalPlayer)
	end
end)
v_u_1.Signal.Fired("Teleporting"):Connect(function()
	-- upvalues: (copy) v_u_1, (copy) v_u_56
	if v_u_1.Variables.Teleporting then
		v_u_56.destroyByPlayer(v_u_1.LocalPlayer)
	end
end)
v_u_1.Signal.Fired("Stat Changed"):Connect(function(p117)
	-- upvalues: (copy) v_u_1, (copy) v_u_56
	if p117 == "EquippedHoverboard" and v_u_1.Variables.UsingHoverboard then
		v_u_56.destroyByPlayer(v_u_1.LocalPlayer)
	end
end)
v_u_1.Signal.Fired("Other Stat Changed"):Connect(function(p118, p119)
	-- upvalues: (copy) v_u_56
	if p119 == "EquippedHoverboard" and p118:GetAttribute("UsingHoverboard") then
		v_u_56.destroyByPlayer(p118)
	end
end)
v_u_1.Players.PlayerRemoving:Connect(function(p120)
	-- upvalues: (copy) v_u_56
	v_u_56.destroyByPlayer(p120)
end)
v_u_2.Close.Activated:Connect(function()
	-- upvalues: (copy) v_u_2, (copy) v_u_56
	v_u_2.Enabled = false
	v_u_56.stopRidingLocal()
end)
return v_u_56
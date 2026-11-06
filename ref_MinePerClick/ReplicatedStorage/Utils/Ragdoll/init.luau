-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local PhysicsService = game:GetService("PhysicsService")
local Players = game:GetService("Players")
local Debris = game:GetService("Debris")
local t = {}
local t2 = {}
local v1, v2, v3

if PhysicsService:IsCollisionGroupRegistered("Ragdoll") then
	v1 = function(p13) --[[ EnableRagdoll | Line: 16 ]]
		if not p13 then
			return
		end

		local v1 = p13:FindFirstChildWhichIsA("Humanoid")

		if not v1 or v1.Health <= 0 then
			return
		end

		v1:ChangeState(Enum.HumanoidStateType.Physics)
		v1.AutoRotate = false

		local PrimaryPart = p13.PrimaryPart

		if not PrimaryPart then
			return
		end

		PrimaryPart.Massless = true

		for i2, v in ipairs(p13:GetDescendants()) do
			if v:IsA("Motor6D") then
				if v.Part0 == PrimaryPart or v.Part1 == PrimaryPart then
					local WeldConstraint = PrimaryPart:FindFirstChild("WeldConstraint")

					if WeldConstraint then
						WeldConstraint.Enabled = true
					end

					PrimaryPart.CanCollide = false

					continue
				end

				if v1.RigType == Enum.HumanoidRigType.R15 then
					if v.Part1 then
						v.Part1.CanCollide = true
					end
				else
					local v2 = p13:FindFirstChild(v.Part1.Name .. " Collider")

					if v2 then
						v2.CanCollide = true
					end

					v.Part1.CollisionGroup = "Ragdoll"
				end

				v.Enabled = false
			end
		end
	end
	v2 = function(p13) --[[ DisableRagdoll | Line: 56 ]]
		local v1 = p13:FindFirstChildWhichIsA("Humanoid")

		if not v1 or v1.Health <= 0 then
			return
		end

		local PrimaryPart = p13.PrimaryPart

		if not PrimaryPart then
			return
		end

		PrimaryPart.Massless = false

		for i2, v in ipairs(p13:GetDescendants()) do
			if v:IsA("Motor6D") then
				if v.Part0 == PrimaryPart or v.Part1 == PrimaryPart then
					local WeldConstraint = PrimaryPart:FindFirstChild("WeldConstraint")

					if WeldConstraint then
						WeldConstraint.Enabled = false
					end

					PrimaryPart.CanCollide = true

					continue
				end

				if v1.RigType == Enum.HumanoidRigType.R15 then
					if v.Part1 then
						v.Part1.CanCollide = false
					end
				else
					local v2 = p13:FindFirstChild(v.Part1.Name .. " Collider")

					if v2 then
						v2.CanCollide = false
					end

					v.Part1.CollisionGroup = "Default"
				end

				v.Enabled = true
			end
		end

		local v3 = RaycastParams.new()

		v3.FilterType = Enum.RaycastFilterType.Exclude
		v3.FilterDescendantsInstances = { p13 }

		local v4 = workspace:Raycast(PrimaryPart.Position, Vector3.new(0, -3.5, 0), v3)

		if v4 then
			PrimaryPart.CFrame = CFrame.new(v4.Position + Vector3.new(0, 3, 0))
		end

		v1:ChangeState(Enum.HumanoidStateType.GettingUp)
		v1.AutoRotate = true
	end
	v3 = function(p13, p23, p33) --[[ ApplyKnockback | Line: 103 | Upvalues: Debris (copy) ]]
		if not p13:FindFirstChildWhichIsA("Humanoid") then
			return
		end

		local v1 = p13.PrimaryPart or p13:FindFirstChild("Head")

		if v1 then
			local RagdollKnockback = Instance.new("BodyVelocity")

			RagdollKnockback.Name = "RagdollKnockback"
			RagdollKnockback.MaxForce = Vector3.new(inf, inf, inf)
			RagdollKnockback.P = 2400
			RagdollKnockback.Velocity = p23 * (p33 or 2) * (196.2 / workspace.Gravity)
			RagdollKnockback.Parent = v1
			Debris:AddItem(RagdollKnockback, 0.2)
		end
	end
	function t.RigCharacter(p13, p23, p33) --[[ RigCharacter | Line: 120 | Upvalues: t2 (copy), v1 (copy), v2 (copy) ]]
		local Humanoid = p23:WaitForChild("Humanoid", 3)

		if not Humanoid then
			return
		end

		Humanoid.BreakJointsOnDeath = false
		Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false)
		t2[p23] = 0

		local WeldConstraint = Instance.new("WeldConstraint")

		WeldConstraint.Parent = p23.PrimaryPart

		for i2, v in ipairs(p23:GetDescendants()) do
			if v:IsA("Motor6D") then
				local BC = Instance.new("BallSocketConstraint")

				BC.Name = "BC"
				BC.Parent = v.Part0

				local Attachment = Instance.new("Attachment", v.Part0)
				local Attachment2 = Instance.new("Attachment", v.Part1)

				Attachment2.Position = v.C1.Position
				Attachment.WorldPosition = Attachment2.WorldPosition
				BC.Attachment0 = Attachment
				BC.Attachment1 = Attachment2
				BC.LimitsEnabled = true
				BC.TwistLimitsEnabled = true

				if Humanoid.RigType == Enum.HumanoidRigType.R6 then
					BC.UpperAngle = 55
					BC.TwistLowerAngle = -55
					BC.TwistUpperAngle = 55
				end

				if v.Part0 == p23.PrimaryPart then
					WeldConstraint.Part0 = p23.PrimaryPart
					WeldConstraint.Part1 = v.Part1
					WeldConstraint.Enabled = false
				end
			end
		end

		if not p33 then
			return
		end

		p33:SetAttribute("Ragdoll", false)
		p33:GetAttributeChangedSignal("Ragdoll"):Connect(function() --[[ Line: 165 | Upvalues: Humanoid (copy), p33 (copy), v1 (ref), p23 (copy), v2 (ref) ]]
			if Humanoid.Health <= 0 then
				return
			end

			if p33:GetAttribute("Ragdoll") then
				v1(p23)
			else
				v2(p23)
			end
		end)

		local ClientRagdoll = script:FindFirstChild("ClientRagdoll")

		if not ClientRagdoll then
			return
		end

		ClientRagdoll:Clone().Parent = p23
	end
	function t.Ragdoll(p13, p23, p33, p43) --[[ Ragdoll | Line: 182 | Upvalues: Players (copy), v3 (copy), t2 (copy) ]]
		if not p23:WaitForChild("Humanoid", 3) then
			return
		end

		local v1 = Players:GetPlayerFromCharacter(p23)

		if not v1 then
			return
		end

		if p43 == 0 then
			v1:SetAttribute("Ragdoll", false)

			return
		end

		v1:SetAttribute("Ragdoll", true)

		if p33 then
			task.defer(function() --[[ Line: 197 | Upvalues: v3 (ref), p23 (copy), p33 (copy) ]]
				v3(p23, p33.Direction, p33.Strength)
			end)
		end

		if not tonumber(p43) then
			return
		end

		local v2 = t2

		v2[p23] = v2[p23] + 1

		if p43 > 0 then
			task.wait(p43)
		else
			local PrimaryPart = p23.PrimaryPart

			repeat
				task.wait()
			until PrimaryPart.AssemblyLinearVelocity.Magnitude >= 0.5

			repeat
				task.wait()
			until PrimaryPart.AssemblyLinearVelocity.Magnitude < 0.5

			task.wait((math.abs(p43)))
		end

		if t2[p23] ~= t2[p23] then
			return
		end

		v1:SetAttribute("Ragdoll", false)
	end
	Players.PlayerAdded:Connect(function(p13) --[[ Line: 222 | Upvalues: t (copy) ]]
		p13.CharacterAdded:Connect(function(p1) --[[ Line: 223 | Upvalues: t (ref), p13 (copy) ]]
			t:RigCharacter(p1, p13)
		end)
	end)

	return t
end

PhysicsService:RegisterCollisionGroup("Ragdoll")
PhysicsService:CollisionGroupSetCollidable("Ragdoll", "Default", false)
v1 = function(p13) --[[ EnableRagdoll | Line: 16 ]]
	if not p13 then
		return
	end

	local v1 = p13:FindFirstChildWhichIsA("Humanoid")

	if not v1 or v1.Health <= 0 then
		return
	end

	v1:ChangeState(Enum.HumanoidStateType.Physics)
	v1.AutoRotate = false

	local PrimaryPart = p13.PrimaryPart

	if not PrimaryPart then
		return
	end

	PrimaryPart.Massless = true

	for i2, v in ipairs(p13:GetDescendants()) do
		if v:IsA("Motor6D") then
			if v.Part0 == PrimaryPart or v.Part1 == PrimaryPart then
				local WeldConstraint = PrimaryPart:FindFirstChild("WeldConstraint")

				if WeldConstraint then
					WeldConstraint.Enabled = true
				end

				PrimaryPart.CanCollide = false

				continue
			end

			if v1.RigType == Enum.HumanoidRigType.R15 then
				if v.Part1 then
					v.Part1.CanCollide = true
				end
			else
				local v2 = p13:FindFirstChild(v.Part1.Name .. " Collider")

				if v2 then
					v2.CanCollide = true
				end

				v.Part1.CollisionGroup = "Ragdoll"
			end

			v.Enabled = false
		end
	end
end
v2 = function(p13) --[[ DisableRagdoll | Line: 56 ]]
	local v1 = p13:FindFirstChildWhichIsA("Humanoid")

	if not v1 or v1.Health <= 0 then
		return
	end

	local PrimaryPart = p13.PrimaryPart

	if not PrimaryPart then
		return
	end

	PrimaryPart.Massless = false

	for i2, v in ipairs(p13:GetDescendants()) do
		if v:IsA("Motor6D") then
			if v.Part0 == PrimaryPart or v.Part1 == PrimaryPart then
				local WeldConstraint = PrimaryPart:FindFirstChild("WeldConstraint")

				if WeldConstraint then
					WeldConstraint.Enabled = false
				end

				PrimaryPart.CanCollide = true

				continue
			end

			if v1.RigType == Enum.HumanoidRigType.R15 then
				if v.Part1 then
					v.Part1.CanCollide = false
				end
			else
				local v2 = p13:FindFirstChild(v.Part1.Name .. " Collider")

				if v2 then
					v2.CanCollide = false
				end

				v.Part1.CollisionGroup = "Default"
			end

			v.Enabled = true
		end
	end

	local v3 = RaycastParams.new()

	v3.FilterType = Enum.RaycastFilterType.Exclude
	v3.FilterDescendantsInstances = { p13 }

	local v4 = workspace:Raycast(PrimaryPart.Position, Vector3.new(0, -3.5, 0), v3)

	if v4 then
		PrimaryPart.CFrame = CFrame.new(v4.Position + Vector3.new(0, 3, 0))
	end

	v1:ChangeState(Enum.HumanoidStateType.GettingUp)
	v1.AutoRotate = true
end
v3 = function(p13, p23, p33) --[[ ApplyKnockback | Line: 103 | Upvalues: Debris (copy) ]]
	if not p13:FindFirstChildWhichIsA("Humanoid") then
		return
	end

	local v1 = p13.PrimaryPart or p13:FindFirstChild("Head")

	if v1 then
		local RagdollKnockback = Instance.new("BodyVelocity")

		RagdollKnockback.Name = "RagdollKnockback"
		RagdollKnockback.MaxForce = Vector3.new(inf, inf, inf)
		RagdollKnockback.P = 2400
		RagdollKnockback.Velocity = p23 * (p33 or 2) * (196.2 / workspace.Gravity)
		RagdollKnockback.Parent = v1
		Debris:AddItem(RagdollKnockback, 0.2)
	end
end
function t.RigCharacter(p13, p23, p33) --[[ RigCharacter | Line: 120 | Upvalues: t2 (copy), v1 (copy), v2 (copy) ]]
	local Humanoid = p23:WaitForChild("Humanoid", 3)

	if not Humanoid then
		return
	end

	Humanoid.BreakJointsOnDeath = false
	Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false)
	t2[p23] = 0

	local WeldConstraint = Instance.new("WeldConstraint")

	WeldConstraint.Parent = p23.PrimaryPart

	for i2, v in ipairs(p23:GetDescendants()) do
		if v:IsA("Motor6D") then
			local BC = Instance.new("BallSocketConstraint")

			BC.Name = "BC"
			BC.Parent = v.Part0

			local Attachment = Instance.new("Attachment", v.Part0)
			local Attachment2 = Instance.new("Attachment", v.Part1)

			Attachment2.Position = v.C1.Position
			Attachment.WorldPosition = Attachment2.WorldPosition
			BC.Attachment0 = Attachment
			BC.Attachment1 = Attachment2
			BC.LimitsEnabled = true
			BC.TwistLimitsEnabled = true

			if Humanoid.RigType == Enum.HumanoidRigType.R6 then
				BC.UpperAngle = 55
				BC.TwistLowerAngle = -55
				BC.TwistUpperAngle = 55
			end

			if v.Part0 == p23.PrimaryPart then
				WeldConstraint.Part0 = p23.PrimaryPart
				WeldConstraint.Part1 = v.Part1
				WeldConstraint.Enabled = false
			end
		end
	end

	if not p33 then
		return
	end

	p33:SetAttribute("Ragdoll", false)
	p33:GetAttributeChangedSignal("Ragdoll"):Connect(function() --[[ Line: 165 | Upvalues: Humanoid (copy), p33 (copy), v1 (ref), p23 (copy), v2 (ref) ]]
		if Humanoid.Health <= 0 then
			return
		end

		if p33:GetAttribute("Ragdoll") then
			v1(p23)
		else
			v2(p23)
		end
	end)

	local ClientRagdoll = script:FindFirstChild("ClientRagdoll")

	if not ClientRagdoll then
		return
	end

	ClientRagdoll:Clone().Parent = p23
end
function t.Ragdoll(p13, p23, p33, p43) --[[ Ragdoll | Line: 182 | Upvalues: Players (copy), v3 (copy), t2 (copy) ]]
	if not p23:WaitForChild("Humanoid", 3) then
		return
	end

	local v1 = Players:GetPlayerFromCharacter(p23)

	if not v1 then
		return
	end

	if p43 == 0 then
		v1:SetAttribute("Ragdoll", false)

		return
	end

	v1:SetAttribute("Ragdoll", true)

	if p33 then
		task.defer(function() --[[ Line: 197 | Upvalues: v3 (ref), p23 (copy), p33 (copy) ]]
			v3(p23, p33.Direction, p33.Strength)
		end)
	end

	if not tonumber(p43) then
		return
	end

	local v2 = t2

	v2[p23] = v2[p23] + 1

	if p43 > 0 then
		task.wait(p43)
	else
		local PrimaryPart = p23.PrimaryPart

		repeat
			task.wait()
		until PrimaryPart.AssemblyLinearVelocity.Magnitude >= 0.5

		repeat
			task.wait()
		until PrimaryPart.AssemblyLinearVelocity.Magnitude < 0.5

		task.wait((math.abs(p43)))
	end

	if t2[p23] ~= t2[p23] then
		return
	end

	v1:SetAttribute("Ragdoll", false)
end
Players.PlayerAdded:Connect(function(p13) --[[ Line: 222 | Upvalues: t (copy) ]]
	p13.CharacterAdded:Connect(function(p1) --[[ Line: 223 | Upvalues: t (ref), p13 (copy) ]]
		t:RigCharacter(p1, p13)
	end)
end)

return t
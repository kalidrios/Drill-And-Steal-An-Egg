-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local PhysicsService = game:GetService("PhysicsService")
local t = {}
local t2 = {
	RagdollAttachment = true,
	RagdollConstraint = true
}
local t3 = {}

pcall(function() --[[ Line: 21 | Upvalues: PhysicsService (copy) ]]
	PhysicsService:RegisterCollisionGroup("Ragdoll")
end)
PhysicsService:CollisionGroupSetCollidable("Ragdoll", "Ragdoll", false)

local function setCollision(p1, p2) --[[ setCollision | Line: 27 ]]
	for i, v in ipairs(p1:GetDescendants()) do
		if v:IsA("BasePart") then
			v.CollisionGroup = p2
		end
	end
end

local function ragdoll(p1, p2) --[[ ragdoll | Line: 36 | Upvalues: t3 (copy), setCollision (copy) ]]
	p2.BreakJointsOnDeath = false
	p2.RequiresNeck = true
	p2.AutoRotate = false

	local Animate = p1:FindFirstChild("Animate")

	if Animate then
		Animate.Enabled = false
	end

	local Animator = p2:FindFirstChildOfClass("Animator")

	if Animator then
		for v1, v2 in Animator:GetPlayingAnimationTracks() do
			v2:Stop()
		end
	end

	for i, v in ipairs(p1:GetDescendants()) do
		if v:IsA("Motor6D") and (v.Part0 and (v.Part1 and v.Name ~= "Neck")) then
			t3[v] = { v.Part0, v.Part1 }

			local RagdollAttachment = Instance.new("Attachment")
			local RagdollAttachment2 = Instance.new("Attachment")

			RagdollAttachment.Name = "RagdollAttachment"
			RagdollAttachment2.Name = "RagdollAttachment"
			RagdollAttachment.CFrame = v.C0
			RagdollAttachment2.CFrame = v.C1
			RagdollAttachment.Parent = v.Part0
			RagdollAttachment2.Parent = v.Part1

			local RagdollConstraint = Instance.new("BallSocketConstraint")

			RagdollConstraint.Name = "RagdollConstraint"
			RagdollConstraint.Attachment0 = RagdollAttachment
			RagdollConstraint.Attachment1 = RagdollAttachment2
			RagdollConstraint.LimitsEnabled = true
			RagdollConstraint.TwistLimitsEnabled = true
			RagdollConstraint.UpperAngle = 75
			RagdollConstraint.TwistLowerAngle = -45
			RagdollConstraint.TwistUpperAngle = 45
			RagdollConstraint.MaxFrictionTorque = 10
			RagdollConstraint.Parent = v.Part0
			v.Part0 = nil
			v.Part1 = nil
		end
	end

	setCollision(p1, "Ragdoll")
end

local function unragdoll(p1, p2) --[[ unragdoll | Line: 84 | Upvalues: t2 (copy), t3 (copy), setCollision (copy) ]]
	if p2.Health <= 0 then
		return
	end

	for i, v in ipairs(p1:GetDescendants()) do
		if t2[v.Name] then
			v:Destroy()
		end
	end

	for k, v in pairs(t3) do
		if k.Parent then
			k.Part0 = v[1]
			k.Part1 = v[2]
		end
	end

	table.clear(t3)
	setCollision(p1, "Default")
	p2.AutoRotate = true

	local Animate = p1:FindFirstChild("Animate")

	if not Animate then
		return
	end

	Animate.Enabled = true
end

function t.SetRagdoll(p1, p2) --[[ SetRagdoll | Line: 110 | Upvalues: RunService (copy), ragdoll (copy), unragdoll (copy), Players (copy) ]]
	if not RunService:IsServer() then
		return
	end

	local Humanoid = p1:FindFirstChildOfClass("Humanoid")

	if not Humanoid then
		return
	end

	local PrimaryPart = p1.PrimaryPart

	if PrimaryPart then
		PrimaryPart:SetNetworkOwner(nil)
	end

	if p2 then
		ragdoll(p1, Humanoid)
		Humanoid:ChangeState(Enum.HumanoidStateType.Physics)

		return
	end

	unragdoll(p1, Humanoid)
	Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)

	local v1 = Players:GetPlayerFromCharacter(p1)

	if not (v1 and PrimaryPart) then
		return
	end

	PrimaryPart:SetNetworkOwner(v1)
end

return t
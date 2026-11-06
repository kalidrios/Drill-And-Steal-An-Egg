-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local CurrentCamera = Workspace.CurrentCamera

local function UpdateRagdollState(p1, p2) --[[ UpdateRagdollState | Line: 9 | Upvalues: LocalPlayer (copy), CurrentCamera (copy) ]]
	local v1 = p2:FindFirstChildWhichIsA("Humanoid")

	if not v1 or v1.Health <= 0 then
		return
	end

	if p1:GetAttribute("Ragdoll") then
		v1:ChangeState(Enum.HumanoidStateType.Physics)
		p2.PrimaryPart.Massless = true
		v1.AutoRotate = false

		if p1 == LocalPlayer then
			CurrentCamera.CameraSubject = p2.PrimaryPart
			v1.CameraOffset = Vector3.new(0, 2, 0)
		end
	else
		v1:ChangeState(Enum.HumanoidStateType.GettingUp)
		p2.PrimaryPart.Massless = false
		v1.AutoRotate = true

		if p1 ~= LocalPlayer then
			return
		end

		CurrentCamera.CameraSubject = v1
		v1.CameraOffset = Vector3.new(0, 0, 0)
	end
end

local function ConnectPlayer(p1) --[[ ConnectPlayer | Line: 35 | Upvalues: UpdateRagdollState (copy) ]]
	p1:GetAttributeChangedSignal("Ragdoll"):Connect(function() --[[ Line: 36 | Upvalues: p1 (copy), UpdateRagdollState (ref) ]]
		local Character = p1.Character

		if not Character then
			return
		end

		UpdateRagdollState(p1, Character)
	end)
end

for k, v in pairs(Players:GetPlayers()) do
	v:GetAttributeChangedSignal("Ragdoll"):Connect(function() --[[ Line: 36 | Upvalues: v (copy), UpdateRagdollState (copy) ]]
		local Character = v.Character

		if not Character then
			return
		end

		UpdateRagdollState(v, Character)
	end)
end

Players.PlayerAdded:Connect(ConnectPlayer)
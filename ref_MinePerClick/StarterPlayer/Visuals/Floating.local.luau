-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local CollectionService = game:GetService("CollectionService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local t = {}

local function SetParticles(p1, p2) --[[ SetParticles | Line: 17 ]]
	for i, v in ipairs(p1:GetDescendants()) do
		if v:IsA("ParticleEmitter") then
			v.Enabled = p2
		end
	end
end

local function GetCharacterPosition() --[[ GetCharacterPosition | Line: 25 | Upvalues: LocalPlayer (copy) ]]
	local Character = LocalPlayer.Character

	if not Character then
		return nil
	end

	local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

	if HumanoidRootPart then
		return HumanoidRootPart.Position
	end

	return nil
end

local function CleanupFloat(p1) --[[ CleanupFloat | Line: 35 | Upvalues: t (copy), SetParticles (copy), TweenService (copy) ]]
	local v1 = t[p1]

	if not v1 then
		return
	end

	v1.Tween:Cancel()
	SetParticles(p1, false)
	t[p1] = nil

	if not p1.PrimaryPart then
		return
	end

	TweenService:Create(p1.PrimaryPart, TweenInfo.new(0.35, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
		CFrame = v1.StartCFrame
	}):Play()
end

local function SetupFloat(p1) --[[ SetupFloat | Line: 53 | Upvalues: t (copy), LocalPlayer (copy), SetParticles (copy), TweenService (copy) ]]
	if not p1:IsA("Model") then
		return
	end

	if t[p1] then
		return
	end

	if not p1:IsDescendantOf(workspace) then
		return
	end

	if not p1.PrimaryPart then
		p1.PrimaryPart = p1:FindFirstChildWhichIsA("BasePart")
	end

	if not p1.PrimaryPart then
		return
	end

	local Character = LocalPlayer.Character
	local v1

	if Character then
		local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

		v1 = if HumanoidRootPart then HumanoidRootPart.Position else nil
	else
		v1 = nil
	end

	if not v1 then
		return
	end

	if (v1 - p1.PrimaryPart.Position).Magnitude > 30 then
		SetParticles(p1, false)
	else
		SetParticles(p1, true)

		local v2 = p1.PrimaryPart.CFrame
		local v3 = v2 * CFrame.new(0, 2, 0)
		local v4 = TweenService:Create(p1.PrimaryPart, TweenInfo.new(1.25, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
			CFrame = v3
		})

		t[p1] = {
			Tween = v4,
			StartCFrame = v2
		}
		v4:Play()
	end
end

local function UpdateFloating() --[[ UpdateFloating | Line: 90 | Upvalues: LocalPlayer (copy), t (copy), CleanupFloat (copy), CollectionService (copy), SetupFloat (copy) ]]
	local Character = LocalPlayer.Character
	local v1

	if Character then
		local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

		v1 = if HumanoidRootPart then HumanoidRootPart.Position else nil
	else
		v1 = nil
	end

	if not v1 then
		return
	end

	for k, v in pairs(t) do
		if k:IsDescendantOf(workspace) and k.PrimaryPart then
			if (v1 - k.PrimaryPart.Position).Magnitude > 30 then
				CleanupFloat(k)
			end

			continue
		end

		CleanupFloat(k)
	end

	for i, v in ipairs(CollectionService:GetTagged("Float")) do
		SetupFloat(v)
	end
end

CollectionService:GetInstanceAddedSignal("Float"):Connect(function(p1) --[[ Line: 111 | Upvalues: SetupFloat (copy) ]]
	SetupFloat(p1)
end)
task.spawn(function() --[[ Line: 115 | Upvalues: UpdateFloating (copy) ]]
	while task.wait(0.25) do
		UpdateFloating()
	end
end)
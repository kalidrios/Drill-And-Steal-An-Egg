-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local t = {}
local Streaming = ReplicatedStorage:FindFirstChild("Streaming") or Instance.new("Folder")

Streaming.Name = "Streaming"
Streaming.Parent = ReplicatedStorage

local function GetCharacterPosition() --[[ GetCharacterPosition | Line: 19 | Upvalues: LocalPlayer (copy) ]]
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

local function GetLootPosition(p1) --[[ GetLootPosition | Line: 29 ]]
	if p1:IsA("Model") then
		if not p1.PrimaryPart then
			p1.PrimaryPart = p1:FindFirstChildWhichIsA("BasePart")
		end

		if p1.PrimaryPart then
			return p1.PrimaryPart.Position
		end

		return nil
	end

	if p1:IsA("BasePart") then
		return p1.Position
	end

	return nil
end

local function SetupLoot(p1) --[[ SetupLoot | Line: 46 | Upvalues: t (copy) ]]
	if t[p1] then
		return
	end

	if not (p1:IsA("Model") or p1:IsA("BasePart")) then
		return
	end

	t[p1] = {
		Streamed = false,
		OriginalParent = p1.Parent
	}
end

local function CleanupLoot(p1) --[[ CleanupLoot | Line: 56 | Upvalues: t (copy) ]]
	t[p1] = nil
end

local function SetLootStreamed(p1, p2, p3) --[[ SetLootStreamed | Line: 60 | Upvalues: Streaming (copy) ]]
	if p2.Streamed == p3 then
		return
	end

	p2.Streamed = p3

	if p3 then
		p1.Parent = Streaming
	else
		p1.Parent = p2.OriginalParent
	end
end

local function UpdateLoot() --[[ UpdateLoot | Line: 72 | Upvalues: LocalPlayer (copy), t (copy), Streaming (copy) ]]
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
		local v2

		if k.Parent then
			if k:IsA("Model") then
				if not k.PrimaryPart then
					k.PrimaryPart = k:FindFirstChildWhichIsA("BasePart")
				end

				v2 = if k.PrimaryPart then k.PrimaryPart.Position else nil
			else
				v2 = if k:IsA("BasePart") then k.Position else nil
			end

			if v2 then
				if (v1 - v2).Magnitude > 80 then
					if v.Streamed ~= true then
						v.Streamed = true
						k.Parent = Streaming
					end

					continue
				end

				if v.Streamed ~= false then
					v.Streamed = false
					k.Parent = v.OriginalParent
				end
			end

			continue
		end

		t[k] = nil
	end
end

for i, v in ipairs(CollectionService:GetTagged("Loot")) do
	SetupLoot(v)
end

CollectionService:GetInstanceAddedSignal("Loot"):Connect(function(p1) --[[ Line: 101 | Upvalues: SetupLoot (copy) ]]
	SetupLoot(p1)
end)
CollectionService:GetInstanceRemovedSignal("Loot"):Connect(function(p1) --[[ Line: 105 | Upvalues: t (copy) ]]
	t[p1] = nil
end)
task.spawn(function() --[[ Line: 109 | Upvalues: UpdateLoot (copy) ]]
	while task.wait(0.25) do
		UpdateLoot()
	end
end)
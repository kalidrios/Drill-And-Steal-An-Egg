-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

game:GetService("RunService")

local Utils = ReplicatedStorage:WaitForChild("Utils")
local GradientVisuals = require(Utils:WaitForChild("GradientVisuals"))
local v1 = CollectionService:GetTagged("MythicEffect")
local v2 = CollectionService:GetTagged("SecretEffect")
local v3 = CollectionService:GetTagged("GodlyEffect")
local v4 = CollectionService:GetTagged("DivineEffect")

local function AnimateRainbow(p1) --[[ AnimateRainbow | Line: 18 | Upvalues: GradientVisuals (copy) ]]
	local v1 = p1.Parent

	if not (v1 and v1:IsA("GuiObject")) then
		return
	end

	GradientVisuals.apply(v1, "Rainbow")
end

local function AnimateSecret(p1) --[[ AnimateSecret | Line: 26 | Upvalues: GradientVisuals (copy) ]]
	local v1 = p1.Parent

	if not (v1 and v1:IsA("GuiObject")) then
		return
	end

	GradientVisuals.apply(v1, "Zebra")
end

local function AnimateGodly(p1) --[[ AnimateGodly | Line: 34 | Upvalues: GradientVisuals (copy) ]]
	local v1 = p1.Parent

	if not (v1 and v1:IsA("GuiObject")) then
		return
	end

	GradientVisuals.apply(v1, "Unknown")
end

local function AnimateDivine(p1) --[[ AnimateDivine | Line: 42 | Upvalues: GradientVisuals (copy) ]]
	local v1 = p1.Parent

	if not (v1 and v1:IsA("GuiObject")) then
		return
	end

	GradientVisuals.apply(v1, "Divine")
end

for i, v in ipairs(v1) do
	local v5 = v.Parent

	if v5 and v5:IsA("GuiObject") then
		GradientVisuals.apply(v5, "Rainbow")
	end
end

for i, v in ipairs(v2) do
	local v6 = v.Parent

	if v6 and v6:IsA("GuiObject") then
		GradientVisuals.apply(v6, "Zebra")
	end
end

for i, v in ipairs(v3) do
	local v7 = v.Parent

	if v7 and v7:IsA("GuiObject") then
		GradientVisuals.apply(v7, "Unknown")
	end
end

for i, v in ipairs(v4) do
	local v8 = v.Parent

	if v8 and v8:IsA("GuiObject") then
		GradientVisuals.apply(v8, "Divine")
	end
end

CollectionService:GetInstanceAddedSignal("MythicEffect"):Connect(AnimateRainbow)
CollectionService:GetInstanceAddedSignal("SecretEffect"):Connect(AnimateSecret)
CollectionService:GetInstanceAddedSignal("GodlyEffect"):Connect(AnimateGodly)
CollectionService:GetInstanceAddedSignal("DivineEffect"):Connect(AnimateDivine)
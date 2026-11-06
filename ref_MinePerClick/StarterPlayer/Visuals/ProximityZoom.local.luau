-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Utils = ReplicatedStorage:WaitForChild("Utils")

require(Utils:WaitForChild("ModelTweener"))

local CurrentCamera = workspace.CurrentCamera

local function SetupLoot(p1) --[[ SetupLoot | Line: 17 | Upvalues: TweenService (copy), CurrentCamera (copy) ]]
	if not p1:IsA("Model") then
		return
	end

	if p1:GetAttribute("FOVSetup") then
		return
	end

	p1:SetAttribute("FOVSetup", true)

	local PrimaryPart = p1.PrimaryPart

	if not PrimaryPart then
		return
	end

	local v1 = PrimaryPart:FindFirstChildWhichIsA("ProximityPrompt")

	if v1 then
		v1.PromptButtonHoldBegan:Connect(function() --[[ Line: 28 | Upvalues: TweenService (ref), CurrentCamera (ref), v1 (copy) ]]
			TweenService:Create(CurrentCamera, TweenInfo.new(v1.HoldDuration, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
				FieldOfView = 60
			}):Play()
		end)
		v1.PromptButtonHoldEnded:Connect(function() --[[ Line: 34 | Upvalues: TweenService (ref), CurrentCamera (ref) ]]
			TweenService:Create(CurrentCamera, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
				FieldOfView = 70
			}):Play()
		end)
		v1.Triggered:Connect(function() --[[ Line: 40 | Upvalues: TweenService (ref), CurrentCamera (ref), p1 (copy) ]]
			TweenService:Create(CurrentCamera, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
				FieldOfView = 70
			}):Play()
			game:GetService("SoundService"):FindFirstChild("Pop 2"):Play()

			local v1 = p1:Clone()

			v1.Parent = workspace
			v1:PivotTo(p1:GetPivot())
			task.delay(0.1, function() --[[ Line: 51 | Upvalues: v1 (copy) ]]
				v1:Destroy()
			end)
		end)
	end
end

for k, v in pairs(CollectionService:GetTagged("Loot")) do
	SetupLoot(v)
end

CollectionService:GetInstanceAddedSignal("Loot"):Connect(function(p1) --[[ Line: 63 | Upvalues: SetupLoot (copy) ]]
	SetupLoot(p1)
end)
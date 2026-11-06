-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local v1 = script.Parent
local UIScale = v1:FindFirstChildOfClass("UIScale")
if not UIScale then
	UIScale = Instance.new("UIScale")
	UIScale.Parent = v1
end
local v2 = 0
RunService.RenderStepped:Connect(function(p1) --[[ Line: 20 | Upvalues: v2 (ref), v1 (copy), UIScale (ref) ]]
	v2 = v2 + p1
	v1.Rotation = v2 * 45 % 360
	UIScale.Scale = math.sin(v2 * 3) * 0.08 + 1
end)
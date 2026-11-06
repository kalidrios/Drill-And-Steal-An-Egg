-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")
local LocalPlayer = Players.LocalPlayer

RunService.RenderStepped:Connect(function(p1) --[[ Line: 12 | Upvalues: LocalPlayer (copy), CollectionService (copy) ]]
	if LocalPlayer:GetAttribute("Stealing") then
		return
	end

	local Character = LocalPlayer.Character
	local v1 = if Character then Character.PrimaryPart else Character

	if not v1 then
		return
	end

	local Position = v1.Position

	for i, v in ipairs(CollectionService:GetTagged("Lookat")) do
		local PrimaryPart = v.PrimaryPart

		if PrimaryPart and not ((PrimaryPart.Position - Position).Magnitude > 70) then
			PrimaryPart.CFrame = PrimaryPart.CFrame:Lerp(CFrame.lookAt(PrimaryPart.Position, (Vector3.new(Position.X, PrimaryPart.Position.Y, Position.Z))), p1 * 8)
		end
	end
end)
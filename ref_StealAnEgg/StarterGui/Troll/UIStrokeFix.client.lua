-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
for k, v in pairs(script.Parent:GetDescendants()) do
	if v:IsA("UIStroke") then
		local Thickness = v.Thickness
		local CurrentCamera = game:GetService("Workspace").CurrentCamera

		CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function() --[[ Line: 7 | Upvalues: v (copy), Thickness (copy), CurrentCamera (copy) ]]
			v.Thickness = Thickness * CurrentCamera.ViewportSize.X / 1600
		end)
		v.Thickness = Thickness * CurrentCamera.ViewportSize.X / 1600
	end
end
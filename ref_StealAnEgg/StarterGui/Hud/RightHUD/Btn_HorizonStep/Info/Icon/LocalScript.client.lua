-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local v1 = script.Parent
script.Parent.Parent:WaitForChild("Txt_Price")
local v2 = nil
local function playNotificationShake() --[[ playNotificationShake | Line: 10 | Upvalues: v2 (ref), RunService (copy), v1 (copy) ]]
	local v12
	if v2 then
		v2:Disconnect()
	end
	v12 = os.clock()
	v2 = RunService.RenderStepped:Connect(function() --[[ Line: 23 | Upvalues: v12 (copy), v1 (ref), v2 (ref) ]]
		local v13 = os.clock() - v12
		local v22 = v13 / 0.5
		if v22 >= 1 then
			v1.Rotation = 0
			v2:Disconnect()
			v2 = nil
		else
			v1.Rotation = math.sin(v13 * 50) * 15 * (1 - v22)
		end
	end)
end
while task.wait(3) do
	if v2 then
		v2:Disconnect()
	end
	local v3 = os.clock()
	v2 = RunService.RenderStepped:Connect(function() --[[ Line: 23 | Upvalues: v3 (copy), v1 (copy), v2 (ref) ]]
		local v13 = os.clock() - v3
		local v22 = v13 / 0.5
		if v22 >= 1 then
			v1.Rotation = 0
			v2:Disconnect()
			v2 = nil
		else
			v1.Rotation = math.sin(v13 * 50) * 15 * (1 - v22)
		end
	end)
end
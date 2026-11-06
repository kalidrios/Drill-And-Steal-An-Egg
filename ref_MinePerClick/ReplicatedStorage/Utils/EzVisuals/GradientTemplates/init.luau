-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local t = {}

for v1, v2 in script:GetDescendants() do
	if v2:IsA("ModuleScript") then
		t[v2.Name] = require(v2)()
	end
end

return t
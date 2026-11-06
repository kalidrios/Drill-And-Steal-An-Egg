-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
game:GetService("ReplicatedStorage")

local LocalPlayer = game.Players.LocalPlayer
local Music = game.Workspace:WaitForChild("Music")
local Icon = require(script:WaitForChild("Icon"))
local v1 = false
local v2 = Icon.new():setImage(76535944750692)

local function SetMusicMuted(p1) --[[ SetMusicMuted | Line: 14 | Upvalues: v1 (ref), Music (copy) ]]
	v1 = p1

	for k, v in pairs(Music:GetChildren()) do
		if v:IsA("Sound") then
			v.Volume = if p1 then 0 else 0.5
		end
	end
end

v2.selected:Connect(function() --[[ Line: 24 | Upvalues: v2 (copy), SetMusicMuted (copy) ]]
	v2:setImage(76944035964747)
	SetMusicMuted(true)
end)
v2.deselected:Connect(function() --[[ Line: 29 | Upvalues: v2 (copy), SetMusicMuted (copy) ]]
	v2:setImage(76535944750692)
	SetMusicMuted(false)
end)
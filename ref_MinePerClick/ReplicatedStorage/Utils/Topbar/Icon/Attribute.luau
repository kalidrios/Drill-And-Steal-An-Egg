-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
task.defer(function() --[[ Line: 21 ]]
	local RunService = game:GetService("RunService")
	local VERSION = require(script.Parent.VERSION)
	local v1 = VERSION.getAppVersion()
	local v2 = VERSION.getLatestVersion()
	local v3 = not VERSION.isUpToDate()

	if not RunService:IsStudio() then
		print((("\240\159\141\141 Running TopbarPlus %* by @ForeverHD & HD Admin"):format(v1)))
	end

	if not v3 then
		return
	end

	warn((("A new version of TopbarPlus (%*) is available: https://devforum.roblox.com/t/topbarplus/1017485"):format(v2)))
end)

return {}
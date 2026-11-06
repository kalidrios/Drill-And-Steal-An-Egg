-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local t = {
	appVersion = "v3.3.1",
	latestVersion = nil
}

function t.getLatestVersion() --[[ getLatestVersion | Line: 14 | Upvalues: t (copy) ]]
	local latestVersion = t.latestVersion

	if latestVersion then
		return latestVersion
	end

	local v1

	while true do
		local v2

		v2, v1 = pcall(function() --[[ Line: 22 ]]
			return game:GetService("MarketplaceService"):GetProductInfo(117501901079852)
		end)

		if v2 and v1 then
			break
		end

		task.wait(1)
	end

	local v4 = string.match(v1.Name, "^TopbarPlus (.*)$")
	local v5 = v4 and v4:gsub("%s+", "")

	t.latestVersion = v5

	return v5
end
function t.getAppVersion() --[[ getAppVersion | Line: 39 | Upvalues: t (copy) ]]
	return t.appVersion
end
function t.isUpToDate() --[[ isUpToDate | Line: 43 | Upvalues: t (copy) ]]
	local v1 = t.getLatestVersion()

	return if v1 == nil then false else v1 == t.getAppVersion()
end

return t
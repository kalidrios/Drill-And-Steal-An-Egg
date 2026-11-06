-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local t = {
	Default = nil
}
local Players = game:GetService("Players")
local t2 = {}
local t3 = {}
local t4 = {}

t4.__index = t4
function t4.CheckRate(p1, p2) --[[ CheckRate | Line: 59 | Upvalues: t2 (copy) ]]
	local _sources = p1._sources
	local v1 = os.clock()
	local v2 = _sources[p2]

	if v2 == nil then
		if typeof(p2) == "Instance" and (p2:IsA("Player") and t2[p2] == nil) then
			return false
		end

		_sources[p2] = v1 + p1._rate_period

		return true
	end

	local v4 = math.max(v1, v2 + p1._rate_period)

	if v4 - v1 < 1 then
		_sources[p2] = v4

		return true
	end

	return false
end
function t4.CleanSource(p1, p2) --[[ CleanSource | Line: 83 ]]
	p1._sources[p2] = nil
end
function t4.Cleanup(p1) --[[ Cleanup | Line: 87 ]]
	p1._sources = {}
end
function t4.Destroy(p1) --[[ Destroy | Line: 91 | Upvalues: t3 (copy) ]]
	t3[p1] = nil
end
function t.NewRateLimiter(p1) --[[ NewRateLimiter | Line: 96 | Upvalues: t4 (copy), t3 (copy) ]]
	if not (p1 <= 0) then
		local v1, v2

		v1 = {
			_sources = {},
			_rate_period = 1 / p1
		}
		v2 = t4
		setmetatable(v1, t4)
		t3[v1] = true

		return v1
	end

	error("[RateLimiter]: Invalid rate")
end

for i, v in ipairs(Players:GetPlayers()) do
	t2[v] = true
end

t.Default = t.NewRateLimiter(120)
Players.PlayerAdded:Connect(function(p1) --[[ Line: 122 | Upvalues: t2 (copy) ]]
	t2[p1] = true
end)
Players.PlayerRemoving:Connect(function(p1) --[[ Line: 126 | Upvalues: t2 (copy), t3 (copy) ]]
	t2[p1] = nil

	for k in pairs(t3) do
		k._sources[p1] = nil
	end
end)

return t
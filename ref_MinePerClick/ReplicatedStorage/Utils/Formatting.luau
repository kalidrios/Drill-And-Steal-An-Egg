-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local t = {}
local t2 = {
	"",
	"K",
	"M",
	"B",
	"T",
	"Qa",
	"Qi",
	"Sx",
	"Sp",
	"Oc",
	"No",
	"Dc",
	"Ud",
	"Dd",
	"Td",
	"Qad",
	"Qid",
	"Sxd",
	"Spd",
	"Ocd",
	"Nod",
	"Vg"
}

function t.FormatNumber(self, num)
	local actualNum = num
	if actualNum == nil then
		actualNum = self
	end
	if type(actualNum) ~= "number" then
		return "0"
	end

	if actualNum < 1000 then
		return tostring((math.floor(actualNum)))
	end

	local v5 = math.min(math.floor((math.log(actualNum, 1000))), #t2 - 1)
	local v6 = actualNum / 1000 ^ v5

	if v6 >= 100 then
		return string.format("%.0f%s", v6, t2[v5 + 1])
	end

	if v6 >= 10 then
		return string.format("%.1f%s", v6, t2[v5 + 1])
	end

	return string.format("%.2f%s", v6, t2[v5 + 1])
end
function t.FormatTime(p1, p2) --[[ FormatTime | Line: 39 ]]
	local v1 = math.floor(p2 / 3600)
	local v2 = math.floor(p2 % 3600 / 60)
	local v3 = p2 % 60

	if v1 > 0 then
		return v1 .. "h " .. v2 .. "m " .. v3 .. "s"
	end

	if v2 > 0 then
		return v2 .. "m " .. v3 .. "s"
	end

	return v3 .. "s"
end

return t
-- https://github.com/kalidrios

local m_GetDateTable = require(script.Parent.GetDateTable);
local m_AddOrdinalSuffix = require(script.Parent.AddOrdinalSuffix);
local table1 = {
	"Jan",
	"Feb",
	"Mar",
	"Apr",
	"May",
	"Jun",
	"Jul",
	"Aug",
	"Sep",
	"Oct",
	"Nov",
	"Dec"
};
return function(p1) -- Line: 11
	--[[
		Upvalues:
			[1] = m_GetDateTable
			[2] = table1
			[3] = m_AddOrdinalSuffix
	--]]
	local v1 = m_GetDateTable((math.floor(p1)));
	return ("%* %*, %*"):format(table1[v1.month], m_AddOrdinalSuffix(v1.day), (tostring(v1.year)));
end;

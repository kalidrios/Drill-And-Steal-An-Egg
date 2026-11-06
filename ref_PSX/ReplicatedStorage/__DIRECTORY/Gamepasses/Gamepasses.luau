local Data = {
	["8 Pets Equipped"] = {ID = 1277570593}, --260
	["Teleport"] = {ID = 1239351332}, --80
	["Hoverboard"] = {ID = 1284338258}, --190
	["VIP"] = {ID = 1283302319}, --500
	["Triple Egg Open"] = {ID = 1284920270}, --500
	["Skip Egg Open"] = {ID = 1285584427, }, --100
	["Pet Storage"] = {ID = 1284890291}, --80
	["Super Pet Storage"] = {ID = 1284986454}, --300
	["Auto Hatch"] = {ID = 1283682462}, --120
	["Lucky"] = {ID = 1284182550}, --300
	["Mythical Hunter"] = {ID = 1285172461}, --1400
	["Magic Eggs"] = {ID = 1283972484}, --10000
	["Magnet"] = {ID = 1285292400},--160
	["Secret Hunter"] = {ID = 127826519}, --18000
	["Shiny Hunter"] = {ID = 1284470567}, --1000
	["15 Pets Equipped"] = {ID = 140977665}, --1500
	["Octuple Egg Open"] = {ID = 102179048}, --900
} 

--[[local _string = ""
for i,v in pairs(Data) do
	_string = _string .. "[\""..string.gsub(string.lower(i)," ", "").."\"] = \""..i.."\", \n"
end
print(_string)]]--

return Data
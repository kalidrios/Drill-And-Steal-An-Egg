--!strict
--[[
	ClientInit: Módulos utilitários e controladores visuais do cliente
]]

local ClientInit = {
	Save = require(script:WaitForChild("Save")),
	StageClientCmds = require(script:WaitForChild("StageClientCmds")),
	ImportantWindow = require(script:WaitForChild("ImportantWindow")),
	PlotClientCmds = require(script:WaitForChild("PlotClientCmds")),
}

return ClientInit

--!strict
local ServerLibrary = {}

ServerLibrary.Saving = require(script:WaitForChild("Saving"))
ServerLibrary.StageServer = require(script:WaitForChild("StageServer"))
ServerLibrary.PickaxeServer = require(script:WaitForChild("PickaxeServer"))
ServerLibrary.PlotServer = require(script:WaitForChild("PlotServer"))
ServerLibrary.HatchService = require(script:WaitForChild("HatchService"))
ServerLibrary.PlotEggService = require(script:WaitForChild("PlotEggService"))
ServerLibrary.WildEggService = require(script:WaitForChild("WildEggService"))

function ServerLibrary.Start(frameworkLibrary: any)
	if ServerLibrary.Saving and ServerLibrary.Saving.Start then
		ServerLibrary.Saving.Start(frameworkLibrary)
	end

	if ServerLibrary.StageServer and ServerLibrary.StageServer.Start then
		ServerLibrary.StageServer.Start(frameworkLibrary)
	end

	if ServerLibrary.PickaxeServer and ServerLibrary.PickaxeServer.Start then
		ServerLibrary.PickaxeServer.Start(frameworkLibrary)
	end

	if ServerLibrary.PlotServer and ServerLibrary.PlotServer.Start then
		ServerLibrary.PlotServer.Start(frameworkLibrary)
	end

	if ServerLibrary.PlotEggService and ServerLibrary.PlotEggService.Start then
		ServerLibrary.PlotEggService.Start(frameworkLibrary)
	end

	if ServerLibrary.WildEggService and ServerLibrary.WildEggService.Start then
		ServerLibrary.WildEggService.Start(frameworkLibrary)
	end

	print("[ServerLibrary] Todos os serviços de servidor Velvet foram iniciados!")
end

return ServerLibrary

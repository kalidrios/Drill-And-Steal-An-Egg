-- Server Loader: Точка входа серверной архитектуры
print("[Server Loader]: Script started!")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ok, err = pcall(function()
	local Loader = require(ReplicatedStorage:WaitForChild("Loader", 10))
	if not Loader then
		warn("[Server Loader]: Loader module not found!")
		return
	end
	Loader:GatherModules()
	Loader:StartModules()
	print("[Server]: All services loaded successfully")
end)
if not ok then
	warn("[Server Loader]: CRITICAL ERROR:", tostring(err))
end

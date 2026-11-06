--[[
	GameLoader: Серверный загрузчик
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Loader = require(ReplicatedStorage:WaitForChild("Loader"))

print("=================== GAMELOADER STARTING ===================")
Loader:GatherModules()
Loader:StartModules()
print("=================== GAMELOADER FINISHED ===================")

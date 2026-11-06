-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Loader = require(ReplicatedStorage:WaitForChild("Loader"))
local Utils = ReplicatedStorage:WaitForChild("Utils")

require(Utils:WaitForChild("Satchel"))
Loader:GatherModules()
Loader:StartModules()
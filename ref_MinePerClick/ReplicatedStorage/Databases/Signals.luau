-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Utils = game:GetService("ReplicatedStorage"):WaitForChild("Utils")
local Signal = require(Utils:WaitForChild("Signal"))

return {
	DataLoaded = Signal.new(),
	DataUpdated = Signal.new(),
	LootAdded = Signal.new(),
	LootRemoved = Signal.new(),
	IndexAdded = Signal.new(),
	IndexRemoved = Signal.new(),
	TraitIndexAdded = Signal.new(),
	TraitIndexRemoved = Signal.new()
}
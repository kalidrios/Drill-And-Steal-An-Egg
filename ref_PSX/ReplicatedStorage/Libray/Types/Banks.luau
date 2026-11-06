-- | load library | --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Library = ReplicatedStorage:WaitForChild("Library")
local ClientLibrary = Library:WaitForChild("Client")
local Modules = Library:WaitForChild("Modules")
local Types = Library:WaitForChild("Types")

-- | shared modules | --
local Pets = require(Modules.Pets)

--------|     Setting     |--------

--------|    Reference    |--------

--------|    Variables    |--------

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--[[
	
	Holds bank data types
	
--]]

return {
	HISTORY_MAX = 100,
	HISTORY_ENUM = {
		DEPOSIT = 1,
		WITHDRAW = 2,
		INVITE = 3,
		KICK = 4,
		LEAVE = 5,
		JOIN = 6,
		TIER = 7,
		INTEREST = 8,
		DUPE = 9
	}
}
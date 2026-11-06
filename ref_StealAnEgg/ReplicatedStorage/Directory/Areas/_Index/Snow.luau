-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMhBGdhbWURUmVwbGljYXRlZFN0b3JhZ2UKR2V0U2VydmljZQdyZXF1aXJlBnNjcmlwdAZQYXJlbnQFVHlwZXMJSW50ZXJmYWNlCURpcmVjdG9yeQZHdWFyZHMGUmFyaXR5CFJhcml0aWVzBFNub3cLRGlzcGxheU5hbWUFRW1vamkE8J+YnwRJY29uG3JieGFzc2V0aWQ6Ly85NDc0MjI2NzE3MjE3NAlEcm9wVGFibGUHR3VhcmRJZA5JbmRleEJhdEdlYXJJZAhTbm93IEJhdAROYW1lB1Blbmd1aW4GV2FscnVzClBvbGFyIEJlYXIQU2FiZXJ0b290aCBUaWdlcgdNYW1tb3RoEENvbG9zc2FsIE1hbW1vdGgEWWV0aQpJY2UgRHJhZ29uA19pZAlMZWdlbmRhcnkAAREAAAECAG6jAAAApAABAAAAAEBvAgIAvAAAFgMAAACfAAMCpAEFAAAAQECkAgcAAABgQE0CAiQIAAAATQICJAgAAABNAgLvCQAAAE0CAg8KAAAAnwECAqQCBQAAAEBATQMAkQsAAABNAwNZDAAAAJ8CAgKkAwUAAABAQE0EAJELAAAATQQE8g0AAACfAwICTQMD6A4AAABNBAKRCwAAAE0EBO8PAAAA4gUZAKQGBwAAAGBATQYGuhoAAAAwBgVXEAAAAP8GAAAIAAAA/wcAAAIAAABvCBsAbwkcAMUHCAMBAAAA/wgAAAIAAABvCR0AbwoeAMUICQMBAAAA/wkAAAIAAABvCh8AbwsgAMUJCgMBAAAA/woAAAIAAABvCyEAbwwiAMUKCwMBAAAA/wsAAAIAAABvDCMAbw0kAMULDAMBAAAA/wwAAAIAAABvDSUAbw4mAMUMDQMBAAAA/w0AAAIAAABvDicAbw8oAMUNDgMBAAAA/w4AAAIAAABvDykAbxAqAMUODwMBAAAAxQYHCQEAAAAwBgV9FQAAAE0GBNMrAAAAMAYFyRYAAABNBgO5LAAAADAGBfINAAAAggUCAC0DAQQAAABAAwIDAwMEBAAAQEADBQQAAGBAAwYDBwMIAwkDCgMLAwwDDQMOAw8DEAMRAxIDEwMUAxUDFggHEP////8REgAAABMUAAAAFf////8W/////xcYAAAADf////8DFwMYAps7+l+ucT1AAxkCA1slWBySNUADGgJ0z7pGy1UyQAMbAoF6M2q+CixAAxwC7l9ZaVK6J0ADHQKnJVZGI68QQAMeAvQZUG9Gzdc/Ax8CaXIxBtZxzD8DIAMhAAEAARgAAwAAAAAAAwAAAAAAAAAAAAAAAAEAAAAAAAABAAAAAAAAAAADAAAAAgEAAAAAAAMAAQAAAAAAAQAAAAAAAQAAAAAAAQAAAAAAAQAAAAAAAQAAAAAAAQAAAAAAAQAAAAAAAAD4AAoAAAACAAAAAAEAAAAAAAPpHbEb9SxVMri3z8Fzdf1z8QrFMS13sA==

-- decompilation:
local ReplicatedStorage = game:GetService("ReplicatedStorage")

require(script.Parent.Parent.Types.Interface)

local Guards = require(ReplicatedStorage.Directory.Guards)
local Rarities = require(ReplicatedStorage.Directory.Rarity).Rarities
local Snow = Guards.Directory.Snow

return {
	Emoji = "😟",
	Icon = "rbxassetid://94742267172174",
	IndexBatGearId = "Snow Bat",
	DisplayName = script.Name,
	DropTable = {
		{
			"Penguin",
			29.444067
		},
		{
			"Walrus",
			21.570745
		},
		{
			"Polar Bear",
			18.335133
		},
		{
			"Sabertooth Tiger",
			14.020984
		},
		{
			"Mammoth",
			11.86391
		},
		{
			"Colossal Mammoth",
			4.171033
		},
		{
			-- 🟡 MODDED REBALANCE (user: "subelo muchisimo mas el juego es modded recuerda") --
			-- Secret x8, Eternal x15, same multipliers applied across all 9 zones.
			"Yeti",
			2.975232
		},
		{
			"Ice Dragon",
			3.33336
		}
	},
	GuardId = Snow._id,
	Rarity = Rarities.Legendary
}


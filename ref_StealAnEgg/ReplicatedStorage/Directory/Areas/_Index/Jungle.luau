-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMhBGdhbWURUmVwbGljYXRlZFN0b3JhZ2UKR2V0U2VydmljZQdyZXF1aXJlBnNjcmlwdAZQYXJlbnQFVHlwZXMJSW50ZXJmYWNlCURpcmVjdG9yeQZHdWFyZHMGUmFyaXR5CFJhcml0aWVzBkp1bmdsZQtEaXNwbGF5TmFtZQVFbW9qaQTwn5isBEljb24ccmJ4YXNzZXRpZDovLzExNDc5NjQ2MzUwNzc2OAlEcm9wVGFibGUHR3VhcmRJZA5JbmRleEJhdEdlYXJJZApKdW5nbGUgQmF0BE5hbWUKQ2hpbXBhbnplZQZUb3VjYW4JQ3JvY29kaWxlB0dvcmlsbGEVT3Jhbmd1dGluaSBBbmFuYXNzaW5pBlNwaWRlcgVUaWdlcgZXYXJkZW4DX2lkBEVwaWMAAREAAAECAG6jAAAApAABAAAAAEBvAgIAvAAAFgMAAACfAAMCpAEFAAAAQECkAgcAAABgQE0CAiQIAAAATQICJAgAAABNAgLvCQAAAE0CAg8KAAAAnwECAqQCBQAAAEBATQMAkQsAAABNAwNZDAAAAJ8CAgKkAwUAAABAQE0EAJELAAAATQQE8g0AAACfAwICTQMD6A4AAABNBAKRCwAAAE0EBOAPAAAA4gUZAKQGBwAAAGBATQYGuhoAAAAwBgVXEAAAAP8GAAAIAAAA/wcAAAIAAABvCBsAbwkcAMUHCAMBAAAA/wgAAAIAAABvCR0AbwoeAMUICQMBAAAA/wkAAAIAAABvCh8AbwsgAMUJCgMBAAAA/woAAAIAAABvCyEAbwwiAMUKCwMBAAAA/wsAAAIAAABvDCMAbw0kAMULDAMBAAAA/wwAAAIAAABvDSUAbw4mAMUMDQMBAAAA/w0AAAIAAABvDicAbw8oAMUNDgMBAAAA/w4AAAIAAABvDykAbxAqAMUODwMBAAAAxQYHCQEAAAAwBgV9FQAAAE0GBNMrAAAAMAYFyRYAAABNBgO8LAAAADAGBfINAAAAggUCAC0DAQQAAABAAwIDAwMEBAAAQEADBQQAAGBAAwYDBwMIAwkDCgMLAwwDDQMOAw8DEAMRAxIDEwMUAxUDFggHEP////8REgAAABMUAAAAFf////8W/////xcYAAAADf////8DFwMYArJMv0S8ATpAAxkCOXtntFUBNEADGgJODp90IgExQAMbAhFV+DO8ASpAAxwC7Ggc6ncBJkADHQKhnj4Cf2gfQAMeAntq9dVVARRAAx8CmiLA6V28vz8DIAMhAAEAARgAAwAAAAAAAwAAAAAAAAAAAAAAAAEAAAAAAAABAAAAAAAAAAADAAAAAgEAAAAAAAMAAQAAAAAAAQAAAAAAAQAAAAAAAQAAAAAAAQAAAAAAAQAAAAAAAQAAAAAAAQAAAAAAAAD4AAoAAAACAAAAAAEAAAAAAFyM8Q0sAIN42+THIWUE2bsslOZ5bkibDA==

-- decompilation:
local ReplicatedStorage = game:GetService("ReplicatedStorage")

require(script.Parent.Parent.Types.Interface)

local Guards = require(ReplicatedStorage.Directory.Guards)
local Rarities = require(ReplicatedStorage.Directory.Rarity).Rarities
local Jungle = Guards.Directory.Jungle

return {
	Emoji = "😬",
	Icon = "rbxassetid://114796463507768",
	IndexBatGearId = "Jungle Bat",
	DisplayName = script.Name,
	DropTable = {
		{
			"Chimpanzee",
			26.006779
		},
		{
			"Toucan",
			20.005214
		},
		{
			"Crocodile",
			17.004432
		},
		{
			"Gorilla",
			13.003389
		},
		{
			"Orangutini Ananassini",
			11.002868
		},
		{
			"Spider",
			7.852047
		},
		{
			"Tiger",
			5.001304
		},
		{
			-- 🟡 MODDED REBALANCE (user: "subelo muchisimo mas el juego es modded recuerda") --
			-- Secret x8 vs the real game's weight, same multiplier applied across all 9 zones.
			"Warden",
			3.09
		}
	},
	GuardId = Jungle._id,
	Rarity = Rarities.Epic
}


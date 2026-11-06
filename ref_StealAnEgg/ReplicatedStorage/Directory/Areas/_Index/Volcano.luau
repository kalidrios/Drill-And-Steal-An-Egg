-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMhBGdhbWURUmVwbGljYXRlZFN0b3JhZ2UKR2V0U2VydmljZQdyZXF1aXJlBnNjcmlwdAZQYXJlbnQFVHlwZXMJSW50ZXJmYWNlCURpcmVjdG9yeQZHdWFyZHMGUmFyaXR5CFJhcml0aWVzB1ZvbGNhbm8LRGlzcGxheU5hbWUFRW1vamkE8J+YsARJY29uHHJieGFzc2V0aWQ6Ly8xMTQwNTg1MjgwNjk5MzcJRHJvcFRhYmxlB0d1YXJkSWQOSW5kZXhCYXRHZWFySWQLVm9sY2FubyBCYXQETmFtZQlBc2ggR2Vja28JTGF2YSBmcm9nDEZsYW1pbmcgQnVsbAtMYXZhIElndWFuYQ5DaGlsbGluIENoaWxsaQhDZXJiZXJ1cxpBc2NlbmRlZCBWZXJtaWxpb24gUGhvZW5peAZEcmFnb24DX2lkBk15dGhpYwABEQAAAQIAbqMAAACkAAEAAAAAQG8CAgC8AAAWAwAAAJ8AAwKkAQUAAABAQKQCBwAAAGBATQICJAgAAABNAgIkCAAAAE0CAu8JAAAATQICDwoAAACfAQICpAIFAAAAQEBNAwCRCwAAAE0DA1kMAAAAnwICAqQDBQAAAEBATQQAkQsAAABNBATyDQAAAJ8DAgJNAwPoDgAAAE0EApELAAAATQQELQ8AAADiBRkApAYHAAAAYEBNBga6GgAAADAGBVcQAAAA/wYAAAgAAAD/BwAAAgAAAG8IGwBvCRwAxQcIAwEAAAD/CAAAAgAAAG8JHQBvCh4AxQgJAwEAAAD/CQAAAgAAAG8KHwBvCyAAxQkKAwEAAAD/CgAAAgAAAG8LIQBvDCIAxQoLAwEAAAD/CwAAAgAAAG8MIwBvDSQAxQsMAwEAAAD/DAAAAgAAAG8NJQBvDiYAxQwNAwEAAAD/DQAAAgAAAG8OJwBvDygAxQ0OAwEAAAD/DgAAAgAAAG8PKQBvECoAxQ4PAwEAAADFBgcJAQAAADAGBX0VAAAATQYE0ysAAAAwBgXJFgAAAE0GA6QsAAAAMAYF8g0AAACCBQIALQMBBAAAAEADAgMDAwQEAABAQAMFBAAAYEADBgMHAwgDCQMKAwsDDAMNAw4DDwMQAxEDEgMTAxQDFQMWCAcQ/////xESAAAAExQAAAAV/////xb/////FxgAAAAN/////wMXAxgClpaRek/ZOkADGQLdC8wKRQo2QAMaAt2WyAVnCDJAAxsC3PXSFAEOLkADHAJuNeuM7wcxQAMdAqAVGLK61eM/Ax4CaXIxBtZxzD8DHwLbMXVXdsHGPwMgAyEAAQABGAADAAAAAAADAAAAAAAAAAAAAAAAAQAAAAAAAAEAAAAAAAAAAAMAAAACAQAAAAAAAwABAAAAAAABAAAAAAABAAAAAAABAAAAAAABAAAAAAABAAAAAAABAAAAAAABAAAAAAAAAPgACgAAAAIAAAAAAQAAAAAAHOV55flaQ9wxOWtsReuiWGz9bpEuIRPk

-- decompilation:
local ReplicatedStorage = game:GetService("ReplicatedStorage")

require(script.Parent.Parent.Types.Interface)

local Guards = require(ReplicatedStorage.Directory.Guards)
local Rarities = require(ReplicatedStorage.Directory.Rarity).Rarities
local Volcano = Guards.Directory.Volcano

return {
	Emoji = "😰",
	Icon = "rbxassetid://114058528069937",
	IndexBatGearId = "Volcano Bat",
	DisplayName = script.Name,
	DropTable = {
		{
			"Ash Gecko",
			26.848869
		},
		{
			"Lava frog",
			22.040116
		},
		{
			"Flaming Bull",
			18.032822
		},
		{
			"Lava Iguana",
			15.027352
		},
		{
			"Chillin Chilli",
			17.030999
		},
		{
			-- 🟡 MODDED REBALANCE (user: "subelo muchisimo mas el juego es modded recuerda") --
			-- Secret x8, Eternal x15, same multipliers applied across all 9 zones.
			"Cerberus",
			4.95872
		},
		{
			"Ascended Vermilion Phoenix",
			3.33336
		},
		{
			"Dragon",
			2.666685
		}
	},
	GuardId = Volcano._id,
	Rarity = Rarities.Mythic
}


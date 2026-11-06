-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMhBGdhbWURUmVwbGljYXRlZFN0b3JhZ2UKR2V0U2VydmljZQdyZXF1aXJlBnNjcmlwdAZQYXJlbnQFVHlwZXMJSW50ZXJmYWNlCURpcmVjdG9yeQZHdWFyZHMGUmFyaXR5CFJhcml0aWVzC0FieXNzIE9jZWFuC0Rpc3BsYXlOYW1lBUVtb2ppBPCfmLEESWNvbhxyYnhhc3NldGlkOi8vMTE0OTczOTQwMjcyMzAyCURyb3BUYWJsZQdHdWFyZElkDkluZGV4QmF0R2VhcklkD0FieXNzIE9jZWFuIEJhdAROYW1lClBhcnJvdGZpc2gJU3dvcmRmaXNoD0Zpbm5lZCBUaHJlc2hlcgRPcmNhC1doYWxlIFNoYXJrD0FsYWJhc3RlciBXaGFsZQZLcmFrZW4HRWwgTWFqYQNfaWQGQ29zbWljAAERAAABAgBuowAAAKQAAQAAAABAbwICALwAABYDAAAAnwADAqQBBQAAAEBApAIHAAAAYEBNAgIkCAAAAE0CAiQIAAAATQIC7wkAAABNAgIPCgAAAJ8BAgKkAgUAAABAQE0DAJELAAAATQMDWQwAAACfAgICpAMFAAAAQEBNBACRCwAAAE0EBPINAAAAnwMCAk0DA+gOAAAATQUCkQsAAABNBAVgDwAAAOIFGQCkBgcAAABgQE0GBroaAAAAMAYFVxAAAAD/BgAACAAAAP8HAAACAAAAbwgbAG8JHADFBwgDAQAAAP8IAAACAAAAbwkdAG8KHgDFCAkDAQAAAP8JAAACAAAAbwofAG8LIADFCQoDAQAAAP8KAAACAAAAbwshAG8MIgDFCgsDAQAAAP8LAAACAAAAbwwjAG8NJADFCwwDAQAAAP8MAAACAAAAbw0lAG8OJgDFDA0DAQAAAP8NAAACAAAAbw4nAG8PKADFDQ4DAQAAAP8OAAACAAAAbw8pAG8QKgDFDg8DAQAAAMUGBwkBAAAAMAYFfRUAAABNBgTTKwAAADAGBckWAAAATQYDBSwAAAAwBgXyDQAAAIIFAgAtAwEEAAAAQAMCAwMDBAQAAEBAAwUEAABgQAMGAwcDCAMJAwoDCwMMAw0DDgMPAxADEQMSAxMDFAMVAxYIBxD/////ERIAAAATFAAAABX/////Fv////8XGAAAAA3/////AxcDGAK+FB40u2BBQAMZAp+OxwxUqjhAAxoCCFVq9kAPM0ADGwKG56ViYyYtQAMcAmsnSkIiTQtAAx0CdZMYBFbuBEADHgJ5y9WPTXLqPwMfAjYC8bp+wbY/AyADIQABAAEYAAMAAAAAAAMAAAAAAAAAAAAAAAABAAAAAAAAAQAAAAAAAAAAAwAAAAIBAAAAAAADAAEAAAAAAAEAAAAAAAEAAAAAAAEAAAAAAAEAAAAAAAEAAAAAAAEAAAAAAAEAAAAAAAAA+AAKAAAAAgAAAAABAAAAAAA6lgTGK/0kRifAQ9/8n/qdSo4TsghSbsc=

-- decompilation:
local ReplicatedStorage = game:GetService("ReplicatedStorage")

require(script.Parent.Parent.Types.Interface)

local Guards = require(ReplicatedStorage.Directory.Guards)
local Rarities = require(ReplicatedStorage.Directory.Rarity).Rarities
local v4 = Guards.Directory["Abyss Ocean"]

return {
	Emoji = "😱",
	Icon = "rbxassetid://114973940272302",
	IndexBatGearId = "Abyss Ocean Bat",
	DisplayName = script.Name,
	DropTable = {
		{
			"Parrotfish",
			34.755713
		},
		{
			"Swordfish",
			24.665345
		},
		{
			"Finned Thresher",
			19.059585
		},
		{
			"Orca",
			14.574977
		},
		{
			"Whale Shark",
			3.412663
		},
		{
			"Alabaster Whale",
			2.616375
		},
		{
			-- 🟡 MODDED REBALANCE (user: "subelo muchisimo mas el juego es modded recuerda") --
			-- Secret x8, Eternal x15, same multipliers applied across all 9 zones.
			"Kraken",
			6.611624
		},
		{
			"El Maja",
			3.27
		}
	},
	GuardId = v4._id,
	Rarity = Rarities.Cosmic
}


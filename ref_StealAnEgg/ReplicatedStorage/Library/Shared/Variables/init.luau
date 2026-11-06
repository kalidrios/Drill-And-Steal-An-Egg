-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMeGUV4Y2x1c2l2ZUVnZ1NwYWNpbmdSYWRpdXMXRXhjbHVzaXZlRWdnUmFkaXVzUmFuZ2UWRXhjbHVzaXZlRWdnUmFkaXVzU3RlcBhFeGNsdXNpdmVFZ2dSYWRpdXNCdWZmZXIVRXhjbHVzaXZlRWdnTWF4SGVpZ2h0GEV4Y2x1c2l2ZUVnZ0hlaWdodE9mZnNldBtFeGNsdXNpdmVFZ2dNYXhIZWlnaHRCdWZmZXIMU2V0dGluZ3NJbmZvB1ZlY3RvcjIDbmV3A1NGWAVNdXNpYwdUcmFkaW5nA0FGSw1IaWRlT3RoZXJQZXRzDURpc2FibGVWaWRlb3MLZGlzcGxheU5hbWUNU291bmQgRWZmZWN0cwtkZXNjcmlwdGlvbh9Ub2dnbGUgc291bmQgZWZmZWN0cyBvbiBvciBvZmYuB2RlZmF1bHQHb3B0aW9ucyBUb2dnbGUgbXVzaWMgcGxheWJhY2sgb24gb3Igb2ZmLi9BbGxvdyBvdGhlciBwbGF5ZXJzIHRvIHNlbmQgeW91IHRyYWRlIHJlcXVlc3RzLghBRksgTW9kZTFTdGF5IGluIHRoZSBsb2JieSBhbmQgc2tpcCBNdXJkZXIgTXlzdGVyeSByb3VuZHMuD0hpZGUgT3RoZXIgUGV0cxhIaWRlIG90aGVyIHBsYXllcnMgcGV0cy4ORGlzYWJsZSBWaWRlb3MYRGlzYWJsZSB0cmVhZG1pbGwgdmlkZW8uAAEGAAABAgBbowAAAOIADQCkARAAADzggIwCCACMA2QAnwEDAjABALoCAAAA4gEXAOICHwD/AwIAAAAAAKkEAQCpBQEAagUDBKkEAACpBQAAagUDBDADAtIeAAAAMAIBYREAAADiAiEA/wMCAAAAAACpBAEAqQUBAGoFAwSpBAAAqQUAAGoFAwQwAwLSHgAAADACAX0SAAAA4gIjAP8DAgAAAAAAqQQBAKkFAQBqBQMEqQQAAKkFAABqBQMEMAMC0h4AAAAwAgHXEwAAAOICJwD/AwIAAAAAAKkEAQCpBQEAagUDBKkEAACpBQAAagUDBDADAtIeAAAAMAIBbxQAAADiAioA/wMCAAAAAACpBAEAqQUBAGoFAwSpBAAAqQUAAGoFAwQwAwLSHgAAADACAU8VAAAA4gItAP8DAgAAAAAAqQQBAKkFAQBqBQMEqQQAAKkFAABqBQMEMAMC0h4AAAAwAgF7FgAAADABALYMAAAAggACAC4DAQIAAAAAAAAQQAMCAwMCAAAAAAAA8D8DBAIAAAAAAAAUQAMFAgAAAAAAAC5AAwYCAAAAAAAAJEADBwMICAgAAQAAAAL/////AwQAAAAFBgAAAAcIAAAACQoAAAALBgAAAAz/////AwkDCgQAPOCAAwsDDAMNAw4DDwMQBQYREhMUFRYDEQMSAxMDFAMVAQEDFggEGBkAAAAaGwAAABwdAAAAHv////8DFwgEGBIAAAAaIAAAABwdAAAAHv////8DGAgEGBMAAAAaIgAAABwdAAAAHv////8DGQMaAQAIBBgkAAAAGiUAAAAcJgAAAB7/////AxsDHAgEGCgAAAAaKQAAABwmAAAAHv////8DHQMeCAQYKwAAABosAAAAHCYAAAAe/////wABAAEYAAACAAAAAAAABwEEAAEAAAEAAP4A/AAKBAABAAABAAD+APwACgQAAQAAAQAA/gD8AAkEAAEAAAEAAP4A/AAJBAABAAABAAD+APwACQQAAQAAAQAA/gD8ANAAAAEAAAAAAHkpCrlS0iXxqkRGU73KjQkJMR3NS+1guA==

-- decompilation:
return {
	ExclusiveEggSpacingRadius = 4.0,
	ExclusiveEggRadiusStep = 1.0,
	ExclusiveEggRadiusBuffer = 5.0,
	ExclusiveEggMaxHeight = 15.0,
	ExclusiveEggHeightOffset = 10.0,
	ExclusiveEggMaxHeightBuffer = 5.0,
	ExclusiveEggRadiusRange = Vector2.new(8.0, 100.0),
	SettingsInfo = {
		SFX = {
			displayName = "Sound Effects",
			description = "Toggle sound effects on or off.",
			default = true,
			options = {
				[true] = true,
				[false] = false
			}
		},
		Music = {
			displayName = "Music",
			description = "Toggle music playback on or off.",
			default = true,
			options = {
				[true] = true,
				[false] = false
			}
		},
		Trading = {
			displayName = "Trading",
			description = "Allow other players to send you trade requests.",
			default = true,
			options = {
				[true] = true,
				[false] = false
			}
		},
		AFK = {
			displayName = "AFK Mode",
			description = "Stay in the lobby and skip Murder Mystery rounds.",
			default = false,
			options = {
				[true] = true,
				[false] = false
			}
		},
		HideOtherPets = {
			displayName = "Hide Other Pets",
			description = "Hide other players pets.",
			default = false,
			options = {
				[true] = true,
				[false] = false
			}
		},
		DisableVideos = {
			displayName = "Disable Videos",
			description = "Disable treadmill video.",
			default = false,
			options = {
				[true] = true,
				[false] = false
			}
		}
	}
}


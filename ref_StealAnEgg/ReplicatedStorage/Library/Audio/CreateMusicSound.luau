-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMgBHR5cGUGc3RyaW5nBm51bWJlcidNdXNpYyBzb3VuZCBpZCBtdXN0IHJlc29sdmUgdG8gYSBudW1iZXIGYXNzZXJ0JU11c2ljIHNvdW5kIGlkIG11c3QgYmUgZ3JlYXRlciB0aGFuIDAGc2NyaXB0BlBhcmVudAVNdXNpYwZGb2xkZXIDSXNBG0V4cGVjdGVkIEF1ZGlvLk11c2ljIGZvbGRlcglHYW1lTXVzaWMKU291bmRHcm91cCdFeHBlY3RlZCBTb3VuZFNlcnZpY2UuTXVzaWMgc291bmQgZ3JvdXAISW5zdGFuY2UDbmV3BVNvdW5kBE5hbWUPcmJ4YXNzZXRpZDovLyVkBmZvcm1hdAdTb3VuZElkBlZvbHVtZQZMb29wZWQEZ2FtZQxTb3VuZFNlcnZpY2UKR2V0U2VydmljZRFSZXBsaWNhdGVkU3RvcmFnZQdyZXF1aXJlB0xpYnJhcnkJRnVuY3Rpb25zDFBhcnNlQXNzZXRJZAACCwMCAAAMBQABBQMDDwEDCE0CXLsoAQNSBQEApAQBAAAAAECfBAIC8AQFAAIAAID7AwAAUgQBAJ8DAgJlAAEAUgMBALsoAwNSBwMApAYBAAAAAECfBgIC8AYCAAMAAACpBQABqQUBAIEBBQQEAAAAbwYEAKQEBgAAAFBAnwQDAYwGAAC3BgIAAwAAAKkFAAGpBQEAgQEFBAcAAABvBgcApAQGAAAAUECfBAMBpAQJAAAAgEBNBAQkCgAAAE0FBH0LAAAAbwkMALwHBf4NAAAAnwcDAoEBBwQOAAAAbwgOAKQGBgAAAFBAnwYDAfsGAQBNBgZ9CwAAAE0GBngPAAAAbwoQALwIBv4NAAAAnwgDAoEBCAQRAAAAbwkRAKQHBgAAAFBAnwcDAaQHFAAATCCBbwgVAJ8HAgIwAAe6FgAAAG8IFwBSCgMAvAgIjRgAAACfCAMCMAgHfBkAAACMCAAAMAgHSxoAAAAwAge1GwAAADAGB+EQAAAAMAUHJAoAAACCBwIAHAMBBAAAAEADAgMDAwQDBQQAAFBAAwYDBwQAAIBAAwgDCQMKAwsDDAMNAw4DDwMQAxEEAEwggQMSAxMDFAMVAxYDFwMYABQAARgAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAIAAAABAAEAAAAAAAAAAAACAAAAAAEAAAAAAAAAAAACAAAAAQABAAAAAAAAAQAAAQABAAEAAhkAAAAABAAAAQIAGqMAAACkAAEAAAAAQG8CAgC8AAAWAwAAAJ8AAwKkAQEAAAAAQG8DBAC8AQEWAwAAAJ8BAwKkAgYAAABQQE0DAWoHAAAATQMDUwgAAABNAwMsCQAAAJ8CAgLAAwoAEgACABIAAACCAwIACwMZBAAAAEADGgMbAxwDHQQAAFBAAx4DHwMgBgABAAEAARgAAwAAAAAAAQAAAAAAAwAAAAAAAAAADAAAGwEAAAAAAU3qh85bck7ypZEIkZaMSsg98pC6fy7tzw==

-- decompilation:
local SoundService = game:GetService("SoundService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ParseAssetId = require(ReplicatedStorage.Library.Functions.ParseAssetId)

return function(s1: string, p1, b1: boolean) -- line: 20
	-- upvalues: ParseAssetId (copy), SoundService (copy)
	local v7 = if type(p1) ~= "string" then p1 else ParseAssetId(p1)

	assert(type(v7) == "number", "Music sound id must resolve to a number")
	assert(v7 > 0.0, "Music sound id must be greater than 0")

	local Music = script.Parent.Music

	assert(Music:IsA("Folder"), "Expected Audio.Music folder")

	local GameMusic = SoundService.Music.GameMusic

	assert(GameMusic:IsA("SoundGroup"), "Expected SoundService.Music sound group")

	local Sound = Instance.new("Sound")

	Sound.Name = s1
	Sound.SoundId = ("rbxassetid://%d"):format(v7)
	Sound.Volume = 0.0
	Sound.Looped = b1
	Sound.SoundGroup = GameMusic
	Sound.Parent = Music

	return Sound
end


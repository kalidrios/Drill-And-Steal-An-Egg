return {
	name = "Original Hoverboard", 
	neededDesc = "Own the Hoverboard Gamepass", 
	thumbnail = "rbxassetid://8312898681", 
	speed = 1, 
	sounds = {
		equip = { 8323117805 }, 
		idle = { 8323137043 }, 
		jump = { 8323117585 }
	}, 
	callback = function(p1)
		local Directory = require(game:GetService("ReplicatedStorage"):WaitForChild("Library").Directory)
		local Gamepasses = require(game:GetService("ServerScriptService"):WaitForChild("Library").Gamepasses)
		return Gamepasses.Owns(p1, Directory.Gamepasses.Hoverboard.ID);
	end, 
	board = script.Parent:FindFirstChildWhichIsA("BasePart")
}

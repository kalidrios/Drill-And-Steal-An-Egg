return {
	name = "VIP carpet", 
	neededDesc = "Own both the Hoverboard and VIP Gamepasses", 
	thumbnail = "rbxassetid://8312898681", 
	speed = 2, 
	sounds = {
		equip = { "rbxassetid://8323117805", "rbxassetid://8323117725" }, 
		idle = { "rbxassetid://8323137043" }, 
		jump = { "rbxassetid://8323117585" }
	}, 
	callback = function(p1)
		local Gamepasses = require(game:GetService("ServerScriptService"):WaitForChild("Library").Gamepasses)
		local Directory = require(game:GetService("ReplicatedStorage"):WaitForChild("Library").Directory)
		return Gamepasses.Owns(p1, Directory.Gamepasses.Hoverboard.ID) and Gamepasses.Owns(p1, Directory.Gamepasses.VIP.ID);
	end, 
	board = script.Parent:FindFirstChildWhichIsA("BasePart")
}

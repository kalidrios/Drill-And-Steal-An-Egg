-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

return {
	name = "Steampunk Hoverboard", 
	neededDesc = "Reach Lvl 99 Converting Mastery", 
	thumbnail = "rbxassetid://9014365809", 
	speed = 1, 
	sounds = {
		equip = { "rbxassetid://9014644744" }, 
		idle = { "rbxassetid://9014645108" }, 
		jump = { "rbxassetid://9014644521" }
	}, 
	callback = function(p1)
		return require(game:GetService("ServerScriptService"):WaitForChild("Library").Mastery).HasPerk(p1, "Converting", 1);
	end, 
	board = script.Parent:FindFirstChildWhichIsA("BasePart")
};

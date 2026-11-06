-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

return {
	name = "Easter Bunny Hoverboard", 
	neededDesc = "\240\159\144\176 Easter 2023", 
	thumbnail = "rbxassetid://13036485622", 
	speed = 2, 
	sounds = {
		equip = { "rbxassetid://11345687913" }, 
		idle = { 3510107486 }, 
		jump = { 3510107658 }
	}, 
	callback = function(p1)
		return false;
	end, 
	board = script.Parent:FindFirstChildWhichIsA("BasePart")
};

-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

return {
	name = "M-10 Quest Hoverboard", 
	neededDesc = "Unlocked in Quest Shop", 
	thumbnail = "rbxassetid://13208837363", 
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

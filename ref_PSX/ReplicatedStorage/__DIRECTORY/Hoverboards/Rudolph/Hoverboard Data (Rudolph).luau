-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

return {
	name = "Rudolph Hoverboard", 
	neededDesc = "\240\159\142\132 Complete the 2022 Christmas Event", 
	thumbnail = "rbxassetid://11836482697", 
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

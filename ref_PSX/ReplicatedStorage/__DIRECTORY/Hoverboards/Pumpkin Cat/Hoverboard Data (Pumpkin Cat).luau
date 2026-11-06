-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

return {
	name = "Pumpkin Cat Hoverboard", 
	neededDesc = "\240\159\142\131 Halloween 2022", 
	thumbnail = "rbxassetid://11345718736", 
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

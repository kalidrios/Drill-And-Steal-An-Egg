-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

return {
	name = "Doodle Hoverboard", 
	neededDesc = "Unlocked in the Doodle World Hardcore Mode", 
	thumbnail = "rbxassetid://12219030670", 
	speed = 3, 
	sounds = {
		equip = { 3510107225 }, 
		idle = { 3510107486 }, 
		jump = { 3510107658 }
	}, 
	callback = function(p1)
		return false;
	end, 
	board = script.Parent:FindFirstChildWhichIsA("BasePart")
};

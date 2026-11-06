-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

return {
	name = "Purple Hoverboard", 
	neededDesc = "Unlocked in Hardcore Mode.", 
	thumbnail = "rbxassetid://10331584653", 
	speed = 1, 
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

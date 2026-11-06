-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

return {
	name = "Sleigh Hoverboard", 
	neededDesc = "Complete the 2021 Christmas Event", 
	thumbnail = "rbxassetid://8312898812", 
	speed = 1, 
	sounds = {
		equip = { "rbxassetid://8323099981" }, 
		idle = { "rbxassetid://8323130519" }, 
		jump = { "rbxassetid://8323099849" }
	}, 
	callback = function(p1)
		return false;
	end, 
	board = script.Parent:FindFirstChildWhichIsA("BasePart")
};

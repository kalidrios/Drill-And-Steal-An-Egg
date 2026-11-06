-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

return {
	name = "Flame Hoverboard", 
	neededDesc = "Be a BIG Games Partner", 
	thumbnail = "rbxassetid://8312898199", 
	speed = 3, 
	sounds = {
		equip = { "rbxassetid://8323020551" }, 
		idle = { "rbxassetid://8323020440" }, 
		jump = { "rbxassetid://8323020294" }
	}, 
	callback = function(p1)
		return p1:GetRankInGroup(3112828) == 5;
	end, 
	board = script.Parent:FindFirstChildWhichIsA("BasePart")
};

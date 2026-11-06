-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

return {
	name = "Rainbow Hoverboard", 
	neededDesc = "Redeem a merch code", 
	thumbnail = "rbxassetid://8312898931", 
	speed = 2, 
	sounds = {
		equip = { "rbxassetid://8323072985" }, 
		idle = { "rbxassetid://8323072923" }, 
		jump = { 3510107658 }
	}, 
	callback = function(p1)
		if not require(game:GetService("ServerScriptService"):WaitForChild("Library").Saving).Get(p1).Achievements.Merchandise then
			return;
		end;
		return true;
	end, 
	board = script.Parent:FindFirstChildWhichIsA("BasePart")
};

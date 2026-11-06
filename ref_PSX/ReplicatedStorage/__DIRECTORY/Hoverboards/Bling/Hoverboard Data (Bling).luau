-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

return {
	name = "Bling Hoverboard", 
	neededDesc = "Spend over 100k Robux in total", 
	thumbnail = "rbxassetid://8312898012", 
	speed = 3, 
	sounds = {
		equip = { "rbxassetid://8323053302" }, 
		idle = { "rbxassetid://8323053239" }, 
		jump = { 3510107658 }
	}, 
	callback = function(p1)
		if not (require(game:GetService("ServerScriptService"):WaitForChild("Library").Saving).Get(p1, false).RobuxSpent >= 100000) then
			return;
		end;
		return true;
	end, 
	board = script.Parent:FindFirstChildWhichIsA("BasePart")
};

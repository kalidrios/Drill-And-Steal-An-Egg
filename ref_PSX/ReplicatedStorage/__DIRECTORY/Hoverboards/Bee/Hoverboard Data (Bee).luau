-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

return {
	name = "Bee Hoverboard", 
	neededDesc = "Redeem a Season 1 toy code", 
	thumbnail = "rbxassetid://10016161308", 
	speed = 2, 
	sounds = {
		equip = { 3510107225 }, 
		idle = { 3510107486 }, 
		jump = { 3510107658 }
	}, 
	callback = function(p1)
		if not require(game:GetService("ServerScriptService"):WaitForChild("Library").Saving).Get(p1).Achievements["Season 1 Toy"] then
			return;
		end;
		return true;
	end, 
	board = script.Parent:FindFirstChildWhichIsA("BasePart")
};

-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

local v1 = {
	name = "Diamond Carpet", 
	neededDesc = "Reach max Diamonds", 
	thumbnail = "rbxassetid://12603128179", 
	speed = 3, 
	sounds = {
		equip = { 3510107225 }, 
		idle = { 3510107486 }, 
		jump = { 3510107658 }
	}
};
local l__Library__1 = game:GetService("ReplicatedStorage"):WaitForChild("Library");
function v1.callback(p1)
	local v2 = require(l__Library__1.Directory);
	local v3 = require(game:GetService("ServerScriptService"):WaitForChild("Library").Give).GetCurrency(p1, "Diamonds", false);
	local v4 = v3 and v3 >= 10000000000000;
	return v4;
end;
v1.board = script.Parent:FindFirstChildWhichIsA("BasePart");
return v1;

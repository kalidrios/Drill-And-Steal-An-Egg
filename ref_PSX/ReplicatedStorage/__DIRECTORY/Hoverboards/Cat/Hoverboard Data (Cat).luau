-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

local v1 = {
	name = "Cat Hoverboard", 
	neededDesc = "Meow", 
	thumbnail = "rbxassetid://8312899360", 
	speed = 3, 
	sounds = {
		equip = { "rbxassetid://9014691278" }, 
		idle = { 3510107486 }, 
		jump = { 3510107658 }
	}
};
local l__Library__1 = game:GetService("ReplicatedStorage"):WaitForChild("Library");
function v1.callback(p1)
	local v2 = require(game:GetService("ServerScriptService"):WaitForChild("Library").Mastery);
	for v3, v4 in pairs(require(l__Library__1.Directory).Mastery) do
		if v4.enabled and not v2.IsMaxed(p1, v3) then
			return false;
		end;
	end;
	return true;
end;
v1.board = script.Parent:FindFirstChildWhichIsA("BasePart");
return v1;

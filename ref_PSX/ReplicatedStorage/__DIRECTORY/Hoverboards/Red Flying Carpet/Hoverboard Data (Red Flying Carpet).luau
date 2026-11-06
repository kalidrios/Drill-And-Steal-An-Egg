-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

local v1 = {
	name = "Red Flying Carpet", 
	neededDesc = "Top 100 in the Global Leaderboard", 
	thumbnail = "rbxassetid://8312898681", 
	speed = 2, 
	sounds = {
		equip = { "rbxassetid://8323117805", "rbxassetid://8323117725" }, 
		idle = { "rbxassetid://8323137043" }, 
		jump = { "rbxassetid://8323117585" }
	}
};
local l__RunService__1 = game:GetService("RunService");
local u2 = require(game:GetService("ReplicatedStorage"):WaitForChild("Library").Signal);
function v1.callback(p1)
	if not l__RunService__1:IsStudio() then
		local v2 = u2.Invoke("Get Leaderboard Position", p1);
		local v3 = u2.Invoke("Get Power Leaderboard Position", p1);
		if v2 ~= nil and v2 <= 3 or v3 ~= nil and v3 <= 3 then
			return true;
		end;
	end;
end;
v1.board = script.Parent:FindFirstChildWhichIsA("BasePart");
return v1;

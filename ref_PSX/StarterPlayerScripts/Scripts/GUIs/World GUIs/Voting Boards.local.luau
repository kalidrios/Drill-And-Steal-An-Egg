-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

local v1 = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not v1.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end;
local v2 = v1.Player.PlayerGui();
local v3 = {};
local u1 = nil;
local u2 = {
	pressedImage = "rbxassetid://13244996429", 
	image = "rbxassetid://13244996333"
};
local u3 = {
	pressedimage = "rbxassetid://13245061179", 
	image = "rbxassetid://13245051488"
};
function UpdateSign(p1)
	if not v1.Save.Get() then
		return;
	end;
	if not u1 then
		return;
	end;
		
	p1.Title.Text = u1.Vote;
	p1.Positive.PositiveButton.Image = u2.image;
	p1.Negative.NegativeButton.Image = u3.image;
	if u1.PlayerVote ~= nil then
		if u1.PlayerVote == true then
			p1.Positive.PositiveButton.Image = "rbxassetid://13244996429" --u2.pressedImage;
			p1.Negative.NegativeButton.Image = "rbxassetid://13245051488" --u3.image;
		elseif u1.PlayerVote == false then
			p1.Negative.NegativeButton.Image = "rbxassetid://13245061179" --u3.pressedImage;
			p1.Positive.PositiveButton.Image = "rbxassetid://13244996333" --u2.image;
		end;
	end;
end;
local u4 = false;
function LoadSign(p2)
	local l__PrimaryPart__4 = p2.PrimaryPart;
	if not l__PrimaryPart__4 then
		return;
	end;
	local v5 = l__PrimaryPart__4:FindFirstChildOfClass("SurfaceGui");
	if not v5 then
		return;
	end;
	UpdateSign(v5);
	local l__NegativeButton__6 = v5.Negative.NegativeButton;
	v1.GUIFX.ButtonFX(l__NegativeButton__6);
	l__NegativeButton__6.Activated:Connect(function()
		if not u4 then
			u4 = true;
			v1.Network.Fire("Submit Vote", false);
			u4 = false;
		end;
	end);
	local l__PositiveButton__7 = v5.Positive.PositiveButton;
	v1.GUIFX.ButtonFX(l__PositiveButton__7);
	l__PositiveButton__7.Activated:Connect(function()
		if not u4 then
			u4 = true;
			v1.Network.Fire("Submit Vote", true);
			u4 = false;
		end;
	end);
end;
function LoadWorld()
	local l__Interactive__8 = v1.WorldCmds.GetMap():FindFirstChild("Interactive");
	if l__Interactive__8 then
		for v9, v10 in ipairs(l__Interactive__8:GetChildren()) do
			if v10.Name == "Vote Sign" then
				LoadSign(v10);
			end;		
		end;
	end;
end;
function UpdateSigns()
	local l__Interactive__12 = v1.WorldCmds.GetMap():FindFirstChild("Interactive");
	if l__Interactive__12 then
		for v13, v14 in ipairs(l__Interactive__12:GetChildren()) do
			if v14.Name == "Vote Sign" then
				local l__PrimaryPart__16 = v14.PrimaryPart;
				if not l__PrimaryPart__16 then
					warn("No primary");
				else
					local v17 = l__PrimaryPart__16:FindFirstChildOfClass("SurfaceGui");
					if not v17 then
						warn("No surface gui", l__PrimaryPart__16);
					else
						UpdateSign(v17);
					end;
				end;
			end;		
		end;
	end;
end;
v1.Signal.Fired("World Changed"):Connect(function()
	LoadWorld();
end);
v1.Network.Fired("Update Vote Signs"):Connect(function(p3)
	u1 = p3;
	UpdateSigns();
end);

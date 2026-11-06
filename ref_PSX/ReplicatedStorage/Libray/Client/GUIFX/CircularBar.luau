return function(p1) 
	local u1 = nil;
	local Right = nil;
	local u2 = nil;
	local UIGradient = nil;
	local function Setup()
		local Left = p1:FindFirstChild("Left");
		Right = p1:FindFirstChild("Right");
		u1 = Left;
		local UIGradient2 = u1:FindFirstChildOfClass("UIGradient");
		UIGradient = Right:FindFirstChildOfClass("UIGradient");
		u2 = UIGradient2;
	end
	if not pcall(Setup) or p1:GetAttribute("Progress") then
		warn("Could not setup CircularBar for " .. p1.Name);
		return;
	end
	local function Draw(p2)
		p2 = math.clamp(p2, 0, 1);
		if p1 and u2 and UIGradient then
			local v2 = math.clamp(p2 * 2, 0, 1) * 180;
			local v3 = math.clamp((p2 - 0.5) * 2, 0, 1) * 180 + 180;
			UIGradient.Rotation = v2;
			u2.Rotation = v3;
			UIGradient.Enabled = p2 < 0.5;
			u2.Enabled = p2 < 1;
			p1.Visible = p2 > 0;
		end
	end
	p1:SetAttribute("Progress", 1);
	p1:GetAttributeChangedSignal("Progress"):Connect(function()
		Draw(p1:GetAttribute("Progress"));
	end);
end;

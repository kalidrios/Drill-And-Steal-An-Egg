-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

local l__ReplicatedStorage__1 = game:GetService("ReplicatedStorage");
local l__Library__2 = l__ReplicatedStorage__1:WaitForChild("Library");
local v3 = require(l__Library__2.Shared);
local l__Assets__1 = l__ReplicatedStorage__1:WaitForChild("Assets");
local u2 = {};
local u3 = require(l__Library__2.Functions);
local l____DEBRIS__4 = workspace:WaitForChild("__DEBRIS");
local u5 = require(l__Library__2.Directory);
return function(p1, p2, p3, p4)
	if typeof(p1) == "Vector3" then
		p1 = CFrame.new(p1);
	end;
	debug.profilebegin("AddCurrency");
	local v4 = l__Assets__1.Billboards:FindFirstChild("Reward"):Clone();
	if p3 == "Diamonds" then
		p1 = p1 + Vector3.new(0, 3, 0);
	elseif p3 == "Halloween Candy" or p3 == "Gingerbread" or p3 == "Valentine Hearts" or p3 == "Clover Coins" or p3 == "Easter Coins" then
		p1 = p1 + Vector3.new(0, -3, 0);
	end;
	local v5 = false;
	if p4 then
		debug.profilebegin("AddCurrency.TryCombine");
		for v6, v7 in pairs(u2) do
			if not v6 then
				u2[v6] = nil;
			elseif v7.currencyType == p3 and (p1.Position - v7.pos).Magnitude <= 10 then
				v5 = true;
				p2 = p2 + v7.amount;
				u2[v6] = nil;
				if v6.Parent then
					u3.AddDebris(v6.Parent, 0);
				end;
			end;
		end;
		u2[v4] = {
			pos = p1.Position, 
			amount = p2, 
			currencyType = p3
		};
		debug.profileend();
	end;
	local v8 = Instance.new("Part");
	v8.Anchored = true;
	v8.CanCollide = false;
	v8.CanTouch = false;
	v8.CanQuery = false;
	v8.Size = Vector3.new();
	v8.Transparency = 1;
	v8.CFrame = p1;
	v8.Name = "RewardBillboard";
	v8.Parent = l____DEBRIS__4;
	v4.amount.AutoLocalize = false;
	v4.amount.Text = u3.FormatAbbreviated(p2);
	p3 = p3 or "Coins";
	local v9 = u5.Currency[p3];
	v4.icon.Image = v9.Image;
	v4.icon.shadow.Image = v9.Image;
	v9.Gradient:Clone().Parent = v4.amount;
	v4.Parent = v8;
	local v10
	if v5 then
		v10 = 1.3;
	else
		v10 = 1.3;
	end;
	v4.Size = UDim2.new(v4.Size.X.Scale * v10, v4.Size.X.Offset * v10, v4.Size.Y.Scale * v10, v4.Size.Y.Offset * v10);
	local l__Size__6 = v4.Size;
	task.delay(0.05, function()
		u3.Tween(v4, {
			Size = l__Size__6
		}, { 0.1, "Expo", "Out" });
	end);
	if v5 then
		local v11 = v4:FindFirstChild("amount"):FindFirstChildOfClass("UIGradient");
		v11.Enabled = false;
		task.delay(0.075, function()
			v11.Enabled = true;
		end);
	end;
	local function u7()
		debug.profilebegin("AddCurrency.FadeOut");
		local v12 = nil;
		for v13, v14 in ipairs(v4:GetDescendants()) do
			if v14.ClassName == "TextLabel" then
				v12 = u3.Tween(v14, {
					TextTransparency = 1, 
					TextStrokeTransparency = 1
				}, { 0.7, "Sine", "Out" });
			elseif v14.ClassName == "ImageLabel" then
				v12 = u3.Tween(v14, {
					ImageTransparency = 1
				}, { 0.7, "Sine", "Out" });
			elseif v14.ClassName == "UIStroke" then
				v12 = u3.Tween(v14, {
					Transparency = 1
				}, { 0.7, "Sine", "Out" });
			end;		
		end;
		debug.profileend();
		v12.Completed:Wait();
		u3.AddDebris(v8, 0);
		u2[v4] = nil;
	end;
	u3.Tween(v4, {
		StudsOffsetWorldSpace = v4.StudsOffsetWorldSpace + Vector3.new(0, 1, 0)
	}, { 1.9000000000000001, "Quint", "Out" }).Completed:Connect(function()
		if v4 and v4.Parent then
			u7();
		end;
	end);
	debug.profileend();
end;

-- https://github.com/kalidrios

local m_Tween = require(script.Parent.Tween);
return function(p1, p2, p3) -- Line: 18
	--[[
		Upvalues:
			[1] = m_Tween
	--]]
	if not p3 then
		p3 = 0.1;
	end
	local v1 = typeof(p1) == "CFrame" and p1 or CFrame.new(p1);
	local function MakePart() -- Line: 30
		local Part = Instance.new("Part");
		Part.Anchored = true;
		Part.CanCollide = false;
		Part.Transparency = 0.65;
		Part.Color = Color3.fromRGB(255, 255, 255);
		Part.Material = Enum.Material.SmoothPlastic;
		return Part;
	end
	local v2 = v1 + p2;
	local Part2 = Instance.new("Part");
	Part2.Anchored = true;
	Part2.CanCollide = false;
	Part2.Transparency = 0.65;
	Part2.Color = Color3.fromRGB(255, 255, 255);
	Part2.Material = Enum.Material.SmoothPlastic;
	local t_Magnitude = (v1.Position - v2.Position).Magnitude;
	Part2.Size = Vector3.new(0.075, 0.075, t_Magnitude);
	Part2.CFrame = CFrame.new(v1.Position, v2.Position) * CFrame.new(0, 0, -t_Magnitude / 2);
	Part2.Parent = game.Workspace.CurrentCamera;
	local Part3 = Instance.new("Part");
	Part3.Anchored = true;
	Part3.CanCollide = false;
	Part3.Transparency = 0.65;
	Part3.Color = Color3.fromRGB(255, 255, 255);
	Part3.Material = Enum.Material.SmoothPlastic;
	Part3.Color = Color3.fromRGB(46, 255, 10);
	Part3.Transparency = 0;
	Part3.Size = Vector3.new(0.2, 0.2, 0.2);
	Part3.CFrame = v1;
	Part3.Parent = game.Workspace.CurrentCamera;
	local Part4 = Instance.new("Part");
	Part4.Anchored = true;
	Part4.CanCollide = false;
	Part4.Transparency = 0.65;
	Part4.Color = Color3.fromRGB(255, 255, 255);
	Part4.Material = Enum.Material.SmoothPlastic;
	Part4.Color = Color3.fromRGB(255, 16, 16);
	Part4.Transparency = 0;
	Part4.Size = Vector3.new(0.2, 0.2, 0.2);
	Part4.CFrame = CFrame.new(v2.Position);
	Part4.Parent = game.Workspace.CurrentCamera;
	m_Tween({
		Part2,
		Part3,
		Part4
	}, {Transparency = 1}, {p3}).Completed:Connect(function() -- Line: 63
		--[[
			Upvalues:
				[1] = Part2
		--]]
		Part2:Destroy();
	end);
end;

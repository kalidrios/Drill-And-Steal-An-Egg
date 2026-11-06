-- https://github.com/kalidrios

local RunService = game:GetService("RunService");
return function(p1, p2, p3, p4) -- Line: 37
	--[[
		Upvalues:
			[1] = RunService
	--]]
	local u1 = p2 or 1;
	local u2 = p3 or 0.8;
	local v1 = p4 == true;
	if not p1 then
		warn("Object is missing");
		return function() -- Line: 49
		end;
	end
	local table1 = {};
	if p1:IsA("BasePart") then
		table.insert(table1, p1);
	end
	for _, descendant1 in ipairs(p1:GetDescendants()) do
		if not descendant1:IsA("BasePart") or descendant1.Name == "Grinch" or descendant1.Name == "TrappedPet" then continue end
		table.insert(table1, descendant1);
	end
	local table2 = {
		Enum.NormalId.Back,
		Enum.NormalId.Front,
		Enum.NormalId.Left,
		Enum.NormalId.Right,
		Enum.NormalId.Top,
		Enum.NormalId.Bottom
	};
	local table3 = {};
	for _, val2 in ipairs(table1) do
		for index1 = 1, 6 do
			local _SELECTIONFX = Instance.new("Decal");
			_SELECTIONFX.Texture = "rbxassetid://6381483576";
			_SELECTIONFX.Name = "_SELECTIONFX";
			_SELECTIONFX.Transparency = u2;
			_SELECTIONFX.Face = table2[index1];
			_SELECTIONFX.Parent = val2;
			table.insert(table3, _SELECTIONFX);
		end
	end
	local Connect_ret = nil;
	local function destroy() -- Line: 94
		--[[
			Upvalues:
				[1] = Connect_ret
				[2] = table3
		--]]
		if Connect_ret then
			Connect_ret:Disconnect();
		end
		for _, val3 in ipairs(table3) do
			if not val3 then continue end
			val3:Destroy();
		end
	end
	local u4 = 0;
	if not v1 then
		Connect_ret = RunService.RenderStepped:Connect(function(p5) -- Line: 107
			--[[
				Upvalues:
					[1] = p1
					[2] = table3
					[3] = destroy
					[4] = u4
					[5] = u1
					[6] = u2
			--]]
			if not p1 or not p1.Parent or not table3[1] then
				destroy();
				return;
			end
			u4 = u4 + p5;
			local v2 = u2 + (1 - u2) * ((math.cos(math.pi * 1.6 * u1 * u4) + 1) / 2);
			for _, val4 in ipairs(table3) do
				if not val4 then
					destroy();
					return;
				end
				val4.Transparency = v2;
			end
		end);
	end
	return destroy;
end;

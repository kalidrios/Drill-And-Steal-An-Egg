-- https://github.com/kalidrios

local table1 = {
	function(p4) -- Line: 17
		return p4:IsA("Humanoid") and p4 or nil;
	end,
	function(p5) -- Line: 20
		return p5:FindFirstChildOfClass("Humanoid");
	end,
	function(p6) -- Line: 23
		return p6:IsA("Animator") and p6 or nil;
	end,
	function(p7) -- Line: 26
		return p7:FindFirstChildOfClass("Animator");
	end,
	function(p8) -- Line: 29
		return p8:IsA("AnimationController") and p8 or nil;
	end,
	function(p9) -- Line: 32
		return p9:FindFirstChildOfClass("AnimationController");
	end,
	function(p10) -- Line: 35
		if p10:IsA("Player") then
			local t_Character = p10.Character;
			if t_Character then
				return t_Character:FindFirstChildOfClass("Humanoid");
			end
		end
		return nil;
	end
};
return function(p1, p2, p3) -- Line: 46
	--[[
		Upvalues:
			[1] = table1
	--]]
	p3 = p3 or 1;
	for _, val1 in ipairs(table1) do
		local v1 = val1(p2);
		if not v1 then continue end
		local Animation = Instance.new("Animation");
		Animation.AnimationId = "rbxassetid://" .. tostring(p1);
		local LoadAnimation_ret = v1:LoadAnimation(Animation);
		LoadAnimation_ret:Play(nil, nil, p3);
		return LoadAnimation_ret;
	end
	error("No way to animate!");
end;

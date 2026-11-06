-- https://github.com/kalidrios

local t_CurrentCamera = game.Workspace.CurrentCamera;
local u1 = nil;
local u2 = nil;
return function() -- Line: 25
	--[[
		Upvalues:
			[1] = t_CurrentCamera
			[2] = u2
			[3] = u1
	--]]
	local t_ViewportSize = t_CurrentCamera.ViewportSize;
	if t_ViewportSize == u2 then
		return u1;
	end
	local math_clamp_ret = math.clamp(t_ViewportSize.Magnitude / 1800, 0.33, 2);
	u1 = math_clamp_ret;
	u2 = t_ViewportSize;
	return math_clamp_ret;
end;

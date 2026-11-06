-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

local v1 = require(script.Parent.ColorToVec);
local v2 = require(script.Parent.VecMax);
local u1 = v1(Color3.fromRGB(165, 118, 212)):Max((v1(Color3.fromRGB(123, 201, 225))));
local u2 = v1(Color3.fromRGB(255, 255, 255));
local u3 = require(script.Parent.RobloxSaturation);
local u4 = require(script.Parent.VecToColor);
return function(p1)
	return u4((v1(u3(u4(v1(p1) * 1.5 * u1 * u2 * 1.08), 0.7))));
end;

-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

local v1 = require(script.Parent.VecToColor);
local v2 = require(script.Parent.ColorToVec);
local v3 = require(script.Parent.DegNorm);
local u1 = require(script.Parent.Map3);
return function(p1)
	local v4 = Vector3.new(p1.R, p1.G, p1.B);
	local v5 = math.min(0, v4.X, v4.Y, v4.Z);
	local v6 = math.max(1, v4.X, v4.Y, v4.Z);
	local v7 = u1(v4, Vector3.new(v5, v5, v5), Vector3.new(v6, v6, v6), Vector3.zero, Vector3.one);
	return Color3.new(v7.X, v7.Y, v7.Z);
end;

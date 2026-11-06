-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

return function(p1)
	return Color3.new(math.clamp(p1.X, 0, 1), math.clamp(p1.Y, 0, 1), (math.clamp(p1.Z, 0, 1)));
end;

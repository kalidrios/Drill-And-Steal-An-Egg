-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

return function(p1, p2)
	return math.clamp((Vector3.new(p1:ToHSV()) - Vector3.new(p2:ToHSV())).Magnitude / 1.7320508075688772, 0, 1);
end;

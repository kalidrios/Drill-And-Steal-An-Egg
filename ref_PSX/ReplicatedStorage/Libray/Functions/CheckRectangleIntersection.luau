local function rectangle_intersection(p1, p2, p3, p4, p5, p6, p7, p8)
	if p3 < p1 then
		p1, p3 = p3, p1
	end
	if p4 < p2 then
		p2, p4 = p4, p2
	end
	if p7 < p5 then
		p5, p7 = p7, p5
	end
	if p8 < p6 then
		p6, p8 = p8, p6
	end
	local math_max_ret = math.max(p1, p5)
	local math_max_ret2 = math.max(p2, p6)
	local math_min_ret = math.min(p3, p7)
	local math_min_ret2 = math.min(p4, p8)
	if math_max_ret < math_min_ret and math_max_ret2 < math_min_ret2 then
		return true
	end
	return false
end

return function(p9, p10, p11, p12)
	return rectangle_intersection(p9.X, p9.Y, p10.X, p10.Y, p11.X, p11.Y, p12.X, p12.Y)
end

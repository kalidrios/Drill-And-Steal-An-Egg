-- https://github.com/kalidrios

function isClipped(p1) -- Line: 1
	local t_Parent = p1.Parent;
	local t_AbsolutePosition = t_Parent.AbsolutePosition;
	local v1 = t_AbsolutePosition + t_Parent.AbsoluteSize;
	local t_AbsolutePosition2 = p1.AbsolutePosition;
	local v2 = t_AbsolutePosition2 + p1.AbsoluteSize;
	local function cmpVectors(p2, p3) -- Line: 9
		return p2.X < p3.X and true or p2.Y < p3.Y;
	end
	return t_AbsolutePosition2.X < t_AbsolutePosition.X and true or t_AbsolutePosition2.Y < t_AbsolutePosition.Y or v1.X < v2.X and true or v1.Y < v2.Y;
end
return isClipped;

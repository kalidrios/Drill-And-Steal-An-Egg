-- https://github.com/kalidrios

return function(p1, p2) -- Line: 14
	for _, val1 in ipairs(typeof(p1) == "table" and p1 or {p1}) do
		local table1 = {};
		for _, val2 in ipairs(val1.Size.Keypoints) do
			table.insert(table1, NumberSequenceKeypoint.new(val2.Time, val2.Value * p2, val2.Envelope * p2));
		end
		val1.Size = NumberSequence.new(table1);
		val1.Drag = val1.Drag * p2;
		val1.VelocityInheritance = val1.VelocityInheritance * p2;
		val1.Speed = NumberRange.new(val1.Speed.Min * p2, val1.Speed.Max * p2);
		val1.Acceleration = Vector3.new(val1.Acceleration.X * p2, val1.Acceleration.Y * p2, val1.Acceleration.Z * p2);
		val1.ZOffset = val1.ZOffset * p2;
	end
end;

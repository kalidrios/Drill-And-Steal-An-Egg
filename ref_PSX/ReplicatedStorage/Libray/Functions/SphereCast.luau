-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

local v1 = require(script.Parent.DrawRaycast);
function fibonacciSphere(p1, p2)
	local v2 = {};
	if p2 == 1 then
		table.insert(v2, (Vector3.new(0, p1, 0)));
		return v2;
	end;
	local v3 = math.pi * 0.7639320225002102;
	local v4 = p2 - 1;
	local v5 = 0 - 1;
	while true do
		local v6 = 1 - v5 / (p2 - 1) * 2;
		local v7 = math.sqrt(1 - v6 * v6);
		local v8 = v3 * v5;
		table.insert(v2, Vector3.new(math.cos(v8) * v7, v6, math.sin(v8) * v7) * p1);
		if 0 <= 1 then
			if v5 < v4 then

			else
				break;
			end;
		elseif v4 < v5 then

		else
			break;
		end;
		v5 = v5 + 1;	
	end;
	return v2;
end;
function fibonacciSphereTop(p3)
	local v9 = {};
	if p3 == 1 then
		table.insert(v9, (Vector3.new(0, 1, 0)));
		return v9;
	end;
	local v10 = math.pi * 0.7639320225002102;
	local v11 = p3 - 1;
	local v12 = 0 - 1;
	while true do
		local v13 = 1 - v12 / (p3 - 1);
		local v14 = math.sqrt(1 - v13 * v13);
		local v15 = v10 * v12;
		table.insert(v9, (Vector3.new(math.cos(v15) * v14, v13, math.sin(v15) * v14)));
		if 0 <= 1 then
			if v12 < v11 then

			else
				break;
			end;
		elseif v11 < v12 then

		else
			break;
		end;
		v12 = v12 + 1;	
	end;
	return v9;
end;
function nearestPointOnLine(p4, p5, p6)
	return p4 + (p6 - p4):Dot(p5) * p5;
end;
function findNearestIntersection(p7, p8, p9, p10)
	local v16 = p7:Dot(p10);
	if math.abs(v16) <= 1E-06 then
		return nearestPointOnLine(p9, p10, p8);
	end;
	return p9 + p10 * (p7:Dot(p8 - p9) / v16);
end;
return function(p11, p12, p13, p14, p15)
	p14 = math.ceil(p14);
	p14 = math.max(p14, 1);
	if p13.Magnitude <= 1E-06 then
		p14 = 1;
	end;
	if p12.Magnitude <= 1E-06 then
		p14 = 1;
	end;
	local l__Unit__17 = p12.Unit;
	local v18 = CFrame.lookAt(Vector3.zero, l__Unit__17) + p11;
	local v19 = nil;
	for v20, v21 in ipairs((fibonacciSphereTop(p14))) do
		local v23 = v21 * p13;
		local v24 = workspace:Raycast(v18 * Vector3.new(v23.X, v23.Z, -v23.Y), p12, p15);
		if v24 then
			local v25 = findNearestIntersection(v24.Normal, v24.Position, p11, l__Unit__17);
			local l__Magnitude__26 = (v25 - p11).Magnitude;
			if not v19 or l__Magnitude__26 < v19.Distance then
				v19 = {
					Distance = l__Magnitude__26, 
					Instance = v24.Instance, 
					Material = v24.Material, 
					Position = v25, 
					Normal = v24.Normal
				};
			end;
		end;	
	end;
	return v19;
end;

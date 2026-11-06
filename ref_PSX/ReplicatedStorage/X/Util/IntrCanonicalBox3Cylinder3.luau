-- https://github.com/kalidrios

local table1 = {};
function table1.Intersects(p1, p2, p3, p4, p5) -- Line: 42
	--[[
		Upvalues:
			[1] = table1
	--]]
	assert(p5 >= 0, "Infinite cylinders are not yet supported.");
	if table1.BoxIsOutsideCylinderSlab(p1, p2, p3, p5) then
		return false;
	end
	local v1 = p2;
	local v2 = p3;
	local v3 = p5 * 0.5;
	local vec3 = Vector3.new(v2.X < 0 and -1 or 1, v2.Y < 0 and -1 or 1, v2.Z < 0 and -1 or 1);
	local v4 = v2 * vec3;
	local v5 = v1 * vec3;
	if v4.X > 0 then
		if v4.Y > 0 then
			if v4.Z > 0 then
				return table1.DoQueryNoZeros(v5, v4, p4, v3, p1);
			end
			return table1.DoQueryOneZero(v5, v4, p4, v3, p1);
		end
		if v4.Z > 0 then
			return table1.DoQueryOneZero(Vector3.new(v5.Z, v5.X, v5.Y), Vector3.new(v4.Z, v4.X, v4.Y), p4, v3, (Vector3.new(p1.Z, p1.X, p1.Y)));
		end
		return table1.DoQueryTwoZeros(v5, p4, p1);
	end
	if v4.Y > 0 then
		if v4.Z > 0 then
			return table1.DoQueryOneZero(Vector3.new(v5.Y, v5.Z, v5.X), Vector3.new(v4.Y, v4.Z, v4.X), p4, v3, (Vector3.new(p1.Y, p1.Z, p1.X)));
		end
		return table1.DoQueryTwoZeros(Vector3.new(v5.Y, v5.Z, v5.X), p4, (Vector3.new(p1.Y, p1.Z, p1.X)));
	end
	if v4.Z > 0 then
		return table1.DoQueryTwoZeros(Vector3.new(v5.Z, v5.X, v5.Y), p4, (Vector3.new(p1.Z, p1.X, p1.Y)));
	end
	error("The cylinder direction cannot be (0,0,0).");
end
function table1.BoxIsOutsideCylinderSlab(p6, p7, p8, p9) -- Line: 110
	local vec3_2 = Vector3.new(math.abs(p8.X), math.abs(p8.Y), (math.abs(p8.Z)));
	local v6 = p9 * 0.5;
	local v7 = -p8:Dot(p7);
	local Dot_ret = p6:Dot(vec3_2);
	if math.abs(v7) > Dot_ret + v6 then
		return true;
	end
	return false;
end
function table1.CylinderAxisIntersectsBox3D(p10, p11, p12, p13) -- Line: 136
	local vec3_3 = Vector3.new((-p13.X - p10.X) / p11.X, (-p13.Y - p10.Y) / p11.Y, (-p13.Z - p10.Z) / p11.Z);
	local vec3_4 = Vector3.new((p13.X - p10.X) / p11.X, (p13.Y - p10.Y) / p11.Y, (p13.Z - p10.Z) / p11.Z);
	local math_max_ret = math.max(vec3_3.X, vec3_3.Y);
	local math_max_ret2 = math.max(vec3_3.Z, -p12);
	local math_max_ret3 = math.max(math_max_ret, math_max_ret2);
	local math_min_ret = math.min(vec3_4.X, vec3_4.Y);
	local math_min_ret2 = math.min(vec3_4.Z, p12);
	return math_max_ret3 <= math.min(math_min_ret, math_min_ret2);
end
function table1.ComputeSqrDistance(p14, p15, p16, p17, p18) -- Line: 161
	local v8 = p14 - p16;
	local v9 = p15 - p16;
	local vec2 = Vector2.new(p17:Dot(v8), p18:Dot(v8));
	local vec2_2 = Vector2.new(p17:Dot(v9), p18:Dot(v9));
	local v10 = vec2_2 - vec2;
	if v10:Dot(vec2_2) <= 0 then
		return vec2_2:Dot(vec2_2);
	end
	local Dot_ret2 = v10:Dot(vec2);
	if Dot_ret2 >= 0 then
		return vec2:Dot(vec2);
	end
	local v11 = vec2 + Dot_ret2 / v10:Dot(v10) * v10;
	return v11:Dot(v11);
end
function table1.DoQueryTwoZeros(p19, p20, p21) -- Line: 185
	local math_abs_ret = math.abs(p19.Y);
	local math_abs_ret2 = math.abs(p19.Z);
	local t_Y = p21.Y;
	local t_Z = p21.Z;
	if math_abs_ret <= t_Y and math_abs_ret2 <= t_Z then
		return true;
	end
	local v12 = 0;
	local v13 = math_abs_ret - t_Y;
	if v13 > 0 then
		v12 = v12 + v13 * v13;
	end
	local v14 = math_abs_ret2 - t_Z;
	if v14 > 0 then
		v12 = v12 + v14 * v14;
	end
	return v12 <= p20 * p20;
end
function table1.DoQueryOneZero(p22, p23, p24, p25, p26) -- Line: 217
	local t_X = p22.X;
	local t_Y2 = p22.Y;
	local t_Z2 = p22.Z;
	local t_X2 = p23.X;
	local t_Y3 = p23.Y;
	local t_X3 = p26.X;
	local t_Y4 = p26.Y;
	local t_Z3 = p26.Z;
	local v15 = t_X3 + t_X;
	local v16 = t_X3 - t_X;
	local v17 = t_Y4 + t_Y2;
	local v18 = t_Y4 - t_Y2;
	local math_abs_ret3 = math.abs(t_Z2);
	if math_abs_ret3 <= t_Z3 then
		local vec2_3 = Vector2.new(-v15 / t_X2, -v17 / t_Y3);
		local vec2_4 = Vector2.new(v16 / t_X2, v18 / t_Y3);
		if math.max(math.max(vec2_3.X, vec2_3.Y), -p25) <= math.min(math.min(vec2_4.X, vec2_4.Y), p25) then
			return true;
		end
	end
	local v19 = t_Y3 * v18 - t_X2 * v15;
	local v20 = -p25 <= v19 and (v19 <= p25 and -(t_X2 * v18 + t_Y3 * v15) or -(v17 + t_X2 * p25) / t_Y3) or -(v18 + t_Y3 * p25) / t_X2;
	local v21 = t_X2 * v16 - t_Y3 * v17;
	local v22 = -p25 <= v21 and (v21 <= p25 and t_X2 * v17 + t_Y3 * v16 or (v17 + t_Y3 * p25) / t_X2) or (v16 + t_X2 * p25) / t_Y3;
	if v22 <= v20 then
		return false;
	end
	local v23 = 0;
	if v20 > 0 then
		v23 = v23 + v20 * v20;
	elseif v22 < 0 then
		v23 = v23 + v22 * v22;
	end
	local v24 = math_abs_ret3 - t_Z3;
	if v24 > 0 then
		v23 = v23 + v24 * v24;
	end
	return v23 <= p24 * p24;
end
function table1.Orthonormalize(p27) -- Line: 292
	local v25 = p27[1].Magnitude;
	p27[1] = p27[1] / v25;
	for index1 = 2, #p27 do
		for index2 = 1, index1 - 1 do
			p27[index1] = p27[index1] - p27[index2] * p27[index1]:Dot(p27[index2]);
		end
		local t_Magnitude = p27[index1].Magnitude;
		p27[index1] = p27[index1] / t_Magnitude;
		v25 = math.min(v25, t_Magnitude);
	end
	return v25;
end
function table1.ComputeOrthogonalComplement(p28) -- Line: 307
	--[[
		Upvalues:
			[1] = table1
	--]]
	if #p28 == 1 then
		if math.abs(p28[1].X) > math.abs(p28[1].Y) then
			table.insert(p28, (Vector3.new(-p28[1].Z, 0, p28[1].X)));
		else
			table.insert(p28, (Vector3.new(0, p28[1].Z, -p28[1].Y)));
		end
	end
	if #p28 == 2 then
		table.insert(p28, p28[1]:Cross(p28[2]));
		return table1.Orthonormalize(p28);
	end
	return 0;
end
function table1.DoQueryNoZeros(p29, p30, p31, p32, p33) -- Line: 322
	--[[
		Upvalues:
			[1] = table1
	--]]
	local vec3_5 = Vector3.new((-p33.X - p29.X) / p30.X, (-p33.Y - p29.Y) / p30.Y, (-p33.Z - p29.Z) / p30.Z);
	local vec3_6 = Vector3.new((p33.X - p29.X) / p30.X, (p33.Y - p29.Y) / p30.Y, (p33.Z - p29.Z) / p30.Z);
	local math_max_ret4 = math.max(vec3_5.X, vec3_5.Y);
	local math_max_ret5 = math.max(vec3_5.Z, -p32);
	local math_max_ret6 = math.max(math_max_ret4, math_max_ret5);
	local math_min_ret3 = math.min(vec3_6.X, vec3_6.Y);
	local math_min_ret4 = math.min(vec3_6.Z, p32);
	if math_max_ret6 <= math.min(math_min_ret3, math_min_ret4) then
		return true;
	end
	local Dot_ret3 = p30:Dot(p29);
	local v26 = p30.X * p33.X;
	local v27 = p30.Y * p33.Y;
	local v28 = p30.Z * p33.Z;
	local v29 = v26 - v27 - v28 - Dot_ret3;
	local v30 = v29 + p32;
	local v31 = v29 - p32;
	local v32 = -v26 + v27 - v28 - Dot_ret3;
	local v33 = v32 + p32;
	local v34 = v32 - p32;
	local v35 = v26 + v27 - v28 - Dot_ret3;
	local v36 = v35 + p32;
	local v37 = v35 - p32;
	local v38 = -v26 - v27 + v28 - Dot_ret3;
	local v39 = v38 + p32;
	local v40 = v38 - p32;
	local v41 = v26 - v27 + v28 - Dot_ret3;
	local v42 = v41 + p32;
	local v43 = v41 - p32;
	local v44 = -v26 + v27 + v28 - Dot_ret3;
	local v45 = v44 + p32;
	local v46 = v44 - p32;
	local table2 = {p30};
	table1.ComputeOrthogonalComplement(table2);
	local v47 = table2[2];
	local v48 = table2[3];
	local v49 = p31 * p31;
	local v50 = v30 >= 0 and -p33.Z or -p33.Z - v30 / p30.Z;
	local v51 = v43 <= 0 and p33.Z or p33.Z - v43 / p30.Z;
	local v52 = v51;
	if v50 <= v51 then
		local vec3_17 = Vector3.new(p33.X, -p33.Y, v50);
		local vec3_18 = Vector3.new(p33.X, -p33.Y, v52);
		if table1.ComputeSqrDistance(vec3_17, vec3_18, p29, v47, v48) <= v49 then
			return true;
		end
	end
	local v53 = v33 >= 0 and -p33.Z or -p33.Z - v33 / p30.Z;
	local v54 = v46 <= 0 and p33.Z or p33.Z - v46 / p30.Z;
	local v55 = v54;
	if v53 <= v54 then
		local vec3_15 = Vector3.new(-p33.X, p33.Y, v53);
		local vec3_16 = Vector3.new(-p33.X, p33.Y, v55);
		if table1.ComputeSqrDistance(vec3_15, vec3_16, p29, v47, v48) <= v49 then
			return true;
		end
	end
	local v56 = v30 >= 0 and -p33.Y or -p33.Y - v30 / p30.Y;
	local v57 = v37 <= 0 and p33.Y or p33.Y - v37 / p30.Y;
	local v58 = v57;
	if v56 <= v57 then
		local vec3_13 = Vector3.new(p33.X, v56, -p33.Z);
		local vec3_14 = Vector3.new(p33.X, v58, -p33.Z);
		if table1.ComputeSqrDistance(vec3_13, vec3_14, p29, v47, v48) <= v49 then
			return true;
		end
	end
	local v59 = v39 >= 0 and -p33.Y or -p33.Y - v39 / p30.Y;
	local v60 = v46 <= 0 and p33.Y or p33.Y - v46 / p30.Y;
	local v61 = v60;
	if v59 <= v60 then
		local vec3_11 = Vector3.new(-p33.X, v59, p33.Z);
		local vec3_12 = Vector3.new(-p33.X, v61, p33.Z);
		if table1.ComputeSqrDistance(vec3_11, vec3_12, p29, v47, v48) <= v49 then
			return true;
		end
	end
	local v62 = v33 >= 0 and -p33.X or -p33.X - v33 / p30.X;
	local v63 = v37 <= 0 and p33.X or p33.X - v37 / p30.X;
	local v64 = v63;
	if v62 <= v63 then
		local vec3_9 = Vector3.new(v62, p33.Y, -p33.Z);
		local vec3_10 = Vector3.new(v64, p33.Y, -p33.Z);
		if table1.ComputeSqrDistance(vec3_9, vec3_10, p29, v47, v48) <= v49 then
			return true;
		end
	end
	local v65 = v39 >= 0 and -p33.X or -p33.X - v39 / p30.X;
	local v66 = v43 <= 0 and p33.X or p33.X - v43 / p30.X;
	local v67 = v66;
	if v65 <= v66 then
		local vec3_7 = Vector3.new(v65, -p33.Y, p33.Z);
		local vec3_8 = Vector3.new(v67, -p33.Y, p33.Z);
		if table1.ComputeSqrDistance(vec3_7, vec3_8, p29, v47, v48) <= v49 then
			return true;
		end
	end
	if (v36 >= 0 and -p33.Z or -p33.Z - v36 / p30.Z) <= (v42 <= 0 and p33.Z or p33.Z - v42 / p30.Z) and table1.ComputeSqrDistance(v36 >= 0 and Vector3.new(p33.X, p33.Y - v36 / p30.Y, -p33.Z) or Vector3.new(p33.X, p33.Y, -p33.Z - v36 / p30.Z), v42 <= 0 and Vector3.new(p33.X, -p33.Y - v42 / p30.Y, p33.Z) or Vector3.new(p33.X, -p33.Y, p33.Z - v42 / p30.Z), p29, v47, v48) <= v49 then
		return true;
	end
	if (v34 >= 0 and -p33.Z or -p33.Z - v34 / p30.Z) <= (v40 <= 0 and p33.Z or p33.Z - v40 / p30.Z) and table1.ComputeSqrDistance(v34 >= 0 and Vector3.new(-p33.X, p33.Y - v34 / p30.Y, -p33.Z) or Vector3.new(-p33.X, p33.Y, -p33.Z - v34 / p30.Z), v40 <= 0 and Vector3.new(-p33.X, -p33.Y - v40 / p30.Y, p33.Z) or Vector3.new(-p33.X, -p33.Y, p33.Z - v40 / p30.Z), p29, v47, v48) <= v49 then
		return true;
	end
	if (v45 >= 0 and -p33.X or -p33.X - v45 / p30.X) <= (v36 <= 0 and p33.X or p33.X - v36 / p30.X) and table1.ComputeSqrDistance(v45 >= 0 and Vector3.new(-p33.X, p33.Y, p33.Z - v45 / p30.Z) or Vector3.new(-p33.X - v45 / p30.X, p33.Y, p33.Z), v36 <= 0 and Vector3.new(p33.X, p33.Y, -p33.Z - v36 / p30.Z) or Vector3.new(p33.X - v36 / p30.X, -p33.Y, -p33.Z), p29, v47, v48) <= v49 then
		return true;
	end
	if (v40 >= 0 and -p33.X or -p33.X - v40 / p30.X) <= (v31 <= 0 and p33.X or p33.X - v31 / p30.X) and table1.ComputeSqrDistance(v40 >= 0 and Vector3.new(-p33.X, -p33.Y, p33.Z - v40 / p30.Z) or Vector3.new(-p33.X - v40 / p30.X, -p33.Y, p33.Z), v31 <= 0 and Vector3.new(p33.X, -p33.Y, -p33.Z - v31 / p30.Z) or Vector3.new(p33.X - v31 / p30.X, -p33.Y, -p33.Z), p29, v47, v48) <= v49 then
		return true;
	end
	if (v42 >= 0 and -p33.Y or -p33.Y - v42 / p30.Z) <= (v45 <= 0 and p33.Y or p33.Y - v45 / p30.Z) and table1.ComputeSqrDistance(v42 >= 0 and Vector3.new(p33.X - v42 / p30.X, -p33.Y, p33.Z) or Vector3.new(p33.X, -p33.Y - v42 / p30.Y, p33.Z), v45 <= 0 and Vector3.new(-p33.X - v45 / p30.X, p33.Y, p33.Z) or Vector3.new(-p33.X, p33.Y - v45 / p30.Y, p33.Z), p29, v47, v48) <= v49 then
		return true;
	end
	if (v31 >= 0 and -p33.Y or -p33.Y - v31 / p30.Z) <= (v34 <= 0 and p33.Y or p33.Y - v34 / p30.Z) and table1.ComputeSqrDistance(v31 >= 0 and Vector3.new(p33.X - v31 / p30.X, -p33.Y, -p33.Z) or Vector3.new(p33.X, -p33.Y - v31 / p30.Y, -p33.Z), v34 <= 0 and Vector3.new(-p33.X - v34 / p30.X, p33.Y, -p33.Z) or Vector3.new(-p33.X, p33.Y - v34 / p30.Y, -p33.Z), p29, v47, v48) <= v49 then
		return true;
	end
	return false;
end
return table1;

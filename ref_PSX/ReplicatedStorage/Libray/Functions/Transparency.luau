-- https://github.com/kalidrios

function applyNumberSequence(p1, p2, p3) -- Line: 3
	local table1 = {};
	for _, val1 in ipairs(p1.Keypoints) do
		local v1 = val1.Value * (1 - p3) + p2 * p3;
		local math_min_ret = math.min(val1.Envelope, (math.max(0, (math.min(v1, 1 - v1)))));
		table.insert(table1, NumberSequenceKeypoint.new(val1.Time, v1, math_min_ret));
	end
	return NumberSequence.new(table1);
end
return function() -- Line: 14
	local table2 = {};
	local function original(p4, p5) -- Line: 16
		--[[
			Upvalues:
				[1] = table2
		--]]
		local v2 = table2[p4];
		if v2 == nil then
			v2 = p5();
			table2[p4] = v2;
		end
		assert(v2 ~= nil);
		return v2;
	end
	local function apply(p6, p7, p8) -- Line: 26
		--[[
			Upvalues:
				[1] = table2
				[2] = apply
		--]]
		if p6:IsA("BasePart") then
			local function v3() -- Anonymous function at line 28
				--[[
					Upvalues:
						[1] = p6
				--]]
				return p6.Transparency;
			end
			local v4 = table2[p6];
			if v4 == nil then
				v4 = v3();
				table2[p6] = v4;
			end
			assert(v4 ~= nil);
			p6.Transparency = v4 * (1 - p8) + p7 * p8;
		elseif p6:IsA("Frame") then
			local function v5() -- Anonymous function at line 31
				--[[
					Upvalues:
						[1] = p6
				--]]
				return p6.Transparency;
			end
			local v6 = table2[p6];
			if v6 == nil then
				v6 = v5();
				table2[p6] = v6;
			end
			assert(v6 ~= nil);
			p6.Transparency = v6 * (1 - p8) + p7 * p8;
		elseif p6:IsA("ParticleEmitter") then
			local function v7() -- Anonymous function at line 34
				--[[
					Upvalues:
						[1] = p6
				--]]
				return p6.Transparency;
			end
			local v8 = table2[p6];
			if v8 == nil then
				v8 = v7();
				table2[p6] = v8;
			end
			assert(v8 ~= nil);
			p6.Transparency = applyNumberSequence(v8, p7, p8);
		elseif p6:IsA("Trail") then
			local function v9() -- Anonymous function at line 37
				--[[
					Upvalues:
						[1] = p6
				--]]
				return p6.Transparency;
			end
			local v10 = table2[p6];
			if v10 == nil then
				v10 = v9();
				table2[p6] = v10;
			end
			assert(v10 ~= nil);
			p6.Transparency = applyNumberSequence(v10, p7, p8);
		end
		for _, child2 in ipairs(p6:GetChildren()) do
			apply(child2, p7, p8);
		end
	end
	return apply;
end;

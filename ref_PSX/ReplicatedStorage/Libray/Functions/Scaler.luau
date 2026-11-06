-- !strict

--------|     Setting     |--------

--------|    Reference    |--------

--------|    Variables    |--------
local ScaleNumberSequence = require(script.Parent.ScaleNumberSequence)

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function()
	local u2 = {}
	
	local function original(p1, p2, p3)
		local v1 = u2[p1]
		if not v1 then
			v1 = {}
			u2[p1] = v1
		end
		assert(v1)
		local v2 = v1[p2]
		if v2 == nil then
			v2 = p3()
			v1[p2] = v2
		end
		assert(v2 ~= nil)
		return v2
	end
	
	local function apply(p4, p5, p6)
		if p4:IsA("BasePart") then
			local v3 = nil
			local v4 = p4:FindFirstAncestorWhichIsA("Model")
			if v4 then
				v3 = v4.PrimaryPart
			end
			if not v3 then
				v3 = p4.AssemblyRootPart
			end
			local v5 = v3 or p4
			local v6 = v5:GetPivot()
			local l__Size__5 = v5.Size
			local u6 = p4:GetPivot()
			local v7 = original(p4, "ObjectCFrame", function()
				return v6:ToObjectSpace(u6)
			end)
			p4:PivotTo(((v6 * CFrame.new(l__Size__5 * p6) * CFrame.new(original(v5, "Size", function()
				return l__Size__5
			end) * p5 * -p6)):ToWorldSpace(v7 - v7.Position + v7.Position * p5)))
			local l__Size__7 = p4.Size
			p4.Size = original(p4, "Size", function()
				return l__Size__7
			end) * p5
		elseif p4:IsA("SpecialMesh") then
			p4.Scale = original(p4, "Scale", function()
				return p4.Scale
			end) * p5
			p4.Offset = original(p4, "Offset", function()
				return p4.Offset
			end) * p5
		elseif p4:IsA("ParticleEmitter") then
			local TEST = nil
			if typeof(p5) == "Vector3" then
				TEST = (p5.X + p5.Y + p5.Z) / 3
			else
				TEST = p5
			end			
			p4.Size = ScaleNumberSequence(original(p4, "Size", function()
				return p4.Size
			end), TEST) 
			p4.Drag = original(p4, "Drag", function()
				return p4.Drag
			end) * TEST
			p4.VelocityInheritance = original(p4, "VelocityInheritance", function()
				return p4.VelocityInheritance
			end) * TEST
			local v8 = original(p4, "Speed", function()
				return p4.Speed
			end)
			p4.Speed = NumberRange.new(v8.Min * TEST, v8.Max * TEST)
			p4.Acceleration = original(p4, "Acceleration", function()
				return p4.Acceleration
			end) * TEST
			p4.ZOffset = original(p4, "ZOffset", function()
				return p4.ZOffset
			end) * TEST
		elseif p4:IsA("Attachment") then
			local v9 = original(p4, "CFrame", function()
				return p4.CFrame
			end)
			p4.CFrame = v9 - v9.Position + v9.Position * p5
		elseif p4:IsA("BillboardGui") then

		end
		for v10, v11 in ipairs(p4:GetChildren()) do
			apply(v11, p5, p6)		
		end
	end
	
	return function(p7, p8, p9)
		return apply(p7, p8, p9 or Vector3.new())
	end
end
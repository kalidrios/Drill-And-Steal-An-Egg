-- https://github.com/kalidrios

local m_ScaleParticle = require(script.Parent.ScaleParticle);
return function(p1, p2) -- Line: 20
	--[[
		Upvalues:
			[1] = m_ScaleParticle
	--]]
	for _, val1 in ipairs(typeof(p1) == "table" and p1 or p1:GetChildren()) do
		local v1 = nil;
		local t_CFrame = nil;
		if val1:IsA("Model") then
			local t_PrimaryPart = val1.PrimaryPart;
			if t_PrimaryPart then
				v1 = t_PrimaryPart;
				t_CFrame = t_PrimaryPart.CFrame;
			end
		elseif val1:IsA("BasePart") then
			v1 = val1;
			t_CFrame = val1.CFrame;
			val1.Size = val1.Size * p2;
		end
		for _, descendant2 in pairs(val1:GetDescendants()) do
			if descendant2:IsA("BasePart") then
				descendant2.Size = descendant2.Size * p2;
				if v1 then
					assert(t_CFrame);
					descendant2.CFrame = (t_CFrame + t_CFrame:Inverse() * descendant2.CFrame.Position * p2) * CFrame.fromEulerAnglesXYZ(descendant2.CFrame:ToEulerAnglesXYZ());
					continue;
				end
				v1 = descendant2;
				t_CFrame = descendant2.CFrame;
				continue;
			end
			if descendant2:IsA("Attachment") then
				descendant2.Position = descendant2.Position * p2;
				continue;
			end
			if descendant2:IsA("ParticleEmitter") then
				m_ScaleParticle(descendant2, p2);
				continue;
			end
			if not descendant2:IsA("SpecialMesh") then continue end
			descendant2.Scale = descendant2.Scale * p2;
		end
	end
end;

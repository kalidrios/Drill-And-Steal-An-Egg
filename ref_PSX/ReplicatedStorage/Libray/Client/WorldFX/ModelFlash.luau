-- https://github.com/kalidrios

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Library = ReplicatedStorage:WaitForChild("Library");
local __DEBRIS = workspace:WaitForChild("__DEBRIS");
local m_Functions = require(Library.Functions);
return function(p1, p2, p3) -- Line: 36
	--[[
		Upvalues:
			[1] = m_Functions
			[2] = __DEBRIS
	--]]
	local u1 = p3 or Color3.new(1, 1, 1);
	local u2 = p2 or 1;
	local Model = Instance.new("Model");
	Model.Name = "Explosion FX";
	local function CleanPart(p4) -- Line: 44
		--[[
			Upvalues:
				[1] = u1
		--]]
		p4.Color = u1;
		p4.Material = Enum.Material.Neon;
		p4.Transparency = 0;
		p4.Anchored = true;
		p4.CanCollide = false;
		p4.CastShadow = false;
		if p4:IsA("MeshPart") then
			p4.TextureID = "";
		end
		for _, child2 in ipairs(p4:GetChildren()) do
			if child2:IsA("SpecialMesh") then
				child2.TextureId = "";
				continue;
			end
			if child2:IsA("BlockMesh") then continue end
			child2:Destroy();
		end
	end
	local function FX(p5) -- Line: 67
		--[[
			Upvalues:
				[1] = CleanPart
				[2] = Model
				[3] = m_Functions
				[4] = u2
		--]]
		local coroutine_wrap_ret = coroutine.wrap(function() -- Line: 68
			--[[
				Upvalues:
					[1] = p5
					[2] = CleanPart
					[3] = Model
					[4] = m_Functions
					[5] = u2
			--]]
			local Clone_ret = p5:Clone();
			CleanPart(Clone_ret);
			Clone_ret.Parent = Model;
			local v3 = Clone_ret.Size * 1.25;
			m_Functions.Tween(Clone_ret, {
				Size = v3,
				CFrame = Clone_ret.CFrame,
				Transparency = 1
			}, {
				1 / u2,
				"Expo",
				"Out"
			}).Completed:Wait();
			Clone_ret:Destroy();
		end);
		coroutine_wrap_ret();
	end
	Model.Parent = __DEBRIS;
	if p1:IsA("BasePart") then
		local coroutine_wrap_ret3 = coroutine.wrap(function() -- Line: 68
			--[[
				Upvalues:
					[1] = p1
					[2] = CleanPart
					[3] = Model
					[4] = m_Functions
					[5] = u2
			--]]
			local Clone_ret3 = p1:Clone();
			CleanPart(Clone_ret3);
			Clone_ret3.Parent = Model;
			local v1 = Clone_ret3.Size * 1.25;
			m_Functions.Tween(Clone_ret3, {
				Size = v1,
				CFrame = Clone_ret3.CFrame,
				Transparency = 1
			}, {
				1 / u2,
				"Expo",
				"Out"
			}).Completed:Wait();
			Clone_ret3:Destroy();
		end);
		coroutine_wrap_ret3();
	end
	for _, descendant1 in ipairs(p1:GetDescendants()) do
		if not descendant1:IsA("BasePart") then continue end
		local coroutine_wrap_ret2 = coroutine.wrap(function() -- Line: 68
			--[[
				Upvalues:
					[1] = descendant1
					[2] = CleanPart
					[3] = Model
					[4] = m_Functions
					[5] = u2
			--]]
			local Clone_ret2 = descendant1:Clone();
			CleanPart(Clone_ret2);
			Clone_ret2.Parent = Model;
			local v2 = Clone_ret2.Size * 1.25;
			m_Functions.Tween(Clone_ret2, {
				Size = v2,
				CFrame = Clone_ret2.CFrame,
				Transparency = 1
			}, {
				1 / u2,
				"Expo",
				"Out"
			}).Completed:Wait();
			Clone_ret2:Destroy();
		end);
		coroutine_wrap_ret2();
	end
	m_Functions.AddDebris(Model, 1 / u2 * 3);
end;

-- https://github.com/kalidrios

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Library = ReplicatedStorage:WaitForChild("Library");
local Assets = ReplicatedStorage:WaitForChild("Assets");
local m_Functions = require(Library.Functions);
return function(p1) -- Line: 11
	--[[
		Upvalues:
			[1] = Assets
			[2] = m_Functions
	--]]
	local Clone_ret = Assets.Particles:FindFirstChild("Pet Boom"):Clone();
	local v1 = m_Functions.CreateParticleHost(p1);
	Clone_ret.Parent = v1;
	Clone_ret:Emit(3);
	m_Functions.AddDebris(v1, 4);
end;

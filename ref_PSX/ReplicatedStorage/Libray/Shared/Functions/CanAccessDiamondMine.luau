-- https://github.com/kalidrios

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local m_Directory = require(ReplicatedStorage:WaitForChild("Library").Directory);
local m_GetSave = require(script.Parent.GetSave);
local m_OwnsGamepass = require(script.Parent.OwnsGamepass);
local t_ID = m_Directory.Gamepasses.VIP.ID;
return function(p1) -- Line: 14
	--[[
		Upvalues:
			[1] = m_GetSave
			[2] = m_OwnsGamepass
			[3] = t_ID
	--]]
	local v1 = m_GetSave(p1);
	if not v1 then
		return false;
	end
	if game.PrivateServerOwnerId ~= 0 and game.PrivateServerOwnerId ~= p1.UserId and p1.MembershipType ~= Enum.MembershipType.Premium and not m_OwnsGamepass(p1, t_ID) then
		return false;
	end
	return true;
end;

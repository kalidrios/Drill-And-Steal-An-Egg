-- https://github.com/kalidrios

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local m_Signal = require(ReplicatedStorage:WaitForChild("Library").Signal);
return function(p1, p2) -- Line: 9
	--[[
		Upvalues:
			[1] = m_Signal
	--]]
	local v1;
	if typeof(p1) == "number" then
		v1 = p1;
	else
		assert(typeof(p1) == "Instance" and p1:IsA("Player") or false);
		v1 = p1.UserId;
	end
	local table1 = {
		booth = m_Signal.Invoke("Is In Booth Transaction", v1) == true,
		trade = m_Signal.Invoke("Is In Trade", v1) == true,
		generic = m_Signal.Invoke("Is In Generic Transaction", v1) == true
	};
	assert(p2 == nil and true or typeof(p2) == "string" and table1[string.lower(p2)] ~= nil or false);
	for key1, val1 in pairs(table1) do
		if p2 and string.lower(p2) == key1 or not val1 then continue end
		return true;
	end
	return false;
end;

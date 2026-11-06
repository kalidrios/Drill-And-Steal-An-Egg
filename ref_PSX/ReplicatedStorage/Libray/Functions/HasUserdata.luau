-- https://github.com/kalidrios

return function(p1) -- Line: 13
	local bool1 = false;
	local function Scan(p2) -- Line: 18
		--[[
			Upvalues:
				[1] = bool1
				[2] = Scan
		--]]
		if bool1 then return end
		for key1, val1 in pairs(p2) do
			if bool1 then return end
			if type(val1) == "userdata" or type(key1) == "userdata" then
				bool1 = true;
				return;
			end
			if type(val1) ~= "table" then continue end
			Scan(val1);
		end
	end
	Scan(p1);
	return bool1;
end;

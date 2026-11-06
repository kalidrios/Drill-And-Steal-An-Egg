-- https://github.com/kalidrios

local m_Commas = require(script.Parent.Commas);
return function(p1, p2) -- Line: 5
	--[[
		Upvalues:
			[1] = m_Commas
	--]]
	if p2 == nil then
		p2 = true;
	end
	local str1 = "";
	local function RoundNumber(p3) -- Line: 13
		--[[
			Upvalues:
				[1] = p2
		--]]
		if not p2 then
			return string.format("%.2f", p3);
		end
		if p3 >= 100 then
			if p3 % 10 == 0 then
				return string.format("%.2f", p3);
			end
			return string.format("%.0f", p3);
		end
		if p3 >= 10 and p3 % 1 ~= 0 then
			if p3 % 1 == 0 then
				return string.format("%.2f", p3);
			end
			return string.format("%.1f", p3);
		end
		return string.format("%.2f", p3);
	end
	local v3;
	if p1 >= 1.e+21 then
		v3 = RoundNumber(p1 / 1.e+21);
		str1 = "Sx";
	elseif p1 >= 1000000000000000000 then
		v3 = RoundNumber(p1 / 1000000000000000000);
		str1 = "Qt";
	elseif p1 >= 1000000000000000 then
		v3 = RoundNumber(p1 / 1000000000000000);
		str1 = "q";
	elseif p1 >= 1000000000000 then
		v3 = RoundNumber(p1 / 1000000000000);
		str1 = "t";
	elseif p1 >= 1000000000 then
		v3 = RoundNumber(p1 / 1000000000);
		str1 = "b";
	elseif p1 >= 1000000 then
		v3 = RoundNumber(p1 / 1000000);
		str1 = "m";
	elseif p1 > 1000 then
		v3 = RoundNumber(p1 / 1000);
		str1 = "k";
	else
		v3 = m_Commas(p1);
	end
	if p1 > 1000 then
		while #v3 > 1 and string.find(v3, "%.") ~= nil and v3:sub(#v3, #v3) == "0" do
			v3 = v3:sub(1, #v3 - 1);
		end
		if v3:sub(#v3, #v3) == "." then
			v3 = v3:sub(1, #v3 - 1);
		end
	end
	local v2 = v3 .. str1;
	if v2 == "1000m" then
		return "1b";
	end
	if v2 == "1000k" then
		return "1m";
	end
	if v2 ~= "1000b" then
		return v2;
	end
	return "1t";
end;

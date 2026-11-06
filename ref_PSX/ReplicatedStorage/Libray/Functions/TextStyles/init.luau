-- https://github.com/kalidrios

local m_styles = require(script:WaitForChild("styles"));
local IsStudio_ret = game:GetService("RunService"):IsStudio();
function UTF8sub(p1, p2, p3) -- Line: 22
	p2 = utf8.offset(p1, p2);
	p3 = utf8.offset(p1, p3 + 1) - 1;
	return string.sub(p1, p2, p3);
end
return function(p4, p5) -- Line: 30
	--[[
		Upvalues:
			[1] = IsStudio_ret
			[2] = m_styles
	--]]
	if not IsStudio_ret then
		for key1, _ in pairs(m_styles) do
			local v2 = "%[" .. tostring(key1) .. "]";
			local v3 = "%[/" .. tostring(key1) .. "]";
			p4 = string.gsub(p4, v2, "");
			p4 = string.gsub(p4, v3, "");
		end
		return p4;
	end
	local function Replace(p6, p7) -- Line: 45
		--[[
			Upvalues:
				[1] = m_styles
		--]]
		local v1 = m_styles[p7];
		for index1 = 1, 62 do
			local string_sub_ret = string.sub("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789", index1, index1);
			local UTF8sub_ret = UTF8sub(v1, index1, index1);
			p6 = string.gsub(p6, string_sub_ret, UTF8sub_ret);
		end
		return p6;
	end
	if p5 then
		p4 = Replace(p4, p5);
	end
	if not p5 then
		for key2, _ in pairs(m_styles) do
			local u2 = "%[" .. tostring(key2) .. "]";
			local u3 = "%[/" .. tostring(key2) .. "]";
			local v4 = u2 .. "-.-" .. u3;
			p4 = string.gsub(p4, v4, function(p8) -- Line: 71
				--[[
					Upvalues:
						[1] = Replace
						[2] = u2
						[3] = u3
						[4] = key2
				--]]
				return Replace(string.gsub(string.gsub(p8, u2, ""), u3, ""), key2);
			end);
		end
	end
	return p4;
end;

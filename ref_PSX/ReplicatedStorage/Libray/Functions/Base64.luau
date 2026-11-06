-- https://github.com/kalidrios

function Encode(p1) -- Line: 17
	return (p1:gsub(".", function(p6) -- Line: 18
		local v5 = "";
		local byte_ret = p6:byte();
		for index4 = 8, 1, -1 do
			v5 = v5 .. (byte_ret % 2 ^ index4 - byte_ret % 2 ^ (index4 - 1) > 0 and "1" or "0");
		end
		return v5;
	end) .. "0000"):gsub("%d%d%d?%d?%d?%d?", function(p5) -- Line: 24
		if #p5 < 6 then
			return "";
		end
		local v4 = 0;
		for index3 = 1, 6 do
			v4 = v4 + (p5:sub(index3, index3) == "1" and 2 ^ (6 - index3) or 0);
		end
		return ("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"):sub(v4 + 1, v4 + 1);
	end) .. ({
		"",
		"==",
		"="
	})[#p1 % 3 + 1];
end
function Decode(p2) -- Line: 35
	p2 = string.gsub(p2, "[^" .. "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/" .. "=]", "");
	local gsub_ret = p2:gsub(".", function(p3) -- Line: 37
		if p3 == "=" then
			return "";
		end
		local find_ret = ("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"):find(p3);
		local v1 = "";
		local v2 = find_ret - 1;
		for index1 = 6, 1, -1 do
			v1 = v1 .. (v2 % 2 ^ index1 - v2 % 2 ^ (index1 - 1) > 0 and "1" or "0");
		end
		return v1;
	end);
	return gsub_ret:gsub("%d%d%d?%d?%d?%d?%d?%d?", function(p4) -- Line: 43
		if #p4 ~= 8 then
			return "";
		end
		local v3 = 0;
		for index2 = 1, 8 do
			v3 = v3 + (p4:sub(index2, index2) == "1" and 2 ^ (8 - index2) or 0);
		end
		return string.char(v3);
	end);
end
return {
	Encode = Encode,
	Decode = Decode
};

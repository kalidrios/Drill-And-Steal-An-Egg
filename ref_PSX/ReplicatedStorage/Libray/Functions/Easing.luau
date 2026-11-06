-- https://github.com/kalidrios

local table1 = {};
function Get(p1, p2, p3) -- Line: 39
	--[[
		Upvalues:
			[1] = table1
	--]]
	local v1 = p2 == nil and "Sine" or typeof(p2) == "string" and p2 or p2.Name;
	local v2 = p3 == nil and "Sine" or typeof(p3) == "string" and p3 or p3.Name;
	if type(v1) ~= "string" then
		v1 = string.sub(tostring(v1), 18);
	end
	if type(v2) ~= "string" then
		v2 = string.sub(tostring(v2), 22);
	end
	if v1 == "Circular" then
		v1 = "Circ";
	elseif v1 == "Exponential" then
		v1 = "Expo";
	end
	if v1 == "Linear" then
		return p1;
	end
	local v3 = table1[v1 .. v2];
	if v3 then
		return v3(p1);
	end
	error("Tween function '" .. v1 .. "." .. v2 .. "' doesn't exist.");
end
function table1.QuadIn(p4) -- Anonymous function at line 99
	p4 = p4 / 1;
	return math.pow(p4, 2) * 1 + 0;
end
function table1.QuadOut(p5) -- Anonymous function at line 105
	p5 = p5 / 1;
	return p5 * -1 * (p5 - 2) + 0;
end
function table1.QuadInOut(p6) -- Anonymous function at line 111
	p6 = p6 / 1 * 2;
	if p6 < 1 then
		return math.pow(p6, 2) * 0.5 + 0;
	end
	return ((p6 - 1) * (p6 - 3) - 1) * -0.5 + 0;
end
function table1.QuadOutIn(p7) -- Anonymous function at line 121
	--[[
		Upvalues:
			[1] = table1
	--]]
	if p7 < 0.5 then
		return table1.QuadOut(p7 * 2);
	end
	return table1.QuadIn(p7 * 2 - 1);
end
function table1.CubicIn(p8) -- Anonymous function at line 130
	p8 = p8 / 1;
	return math.pow(p8, 3) * 1 + 0;
end
function table1.CubicOut(p9) -- Anonymous function at line 136
	p9 = p9 / 1 - 1;
	return (math.pow(p9, 3) + 1) * 1 + 0;
end
function table1.CubicInOut(p10) -- Anonymous function at line 142
	p10 = p10 / 1 * 2;
	if p10 < 1 then
		return p10 * 0.5 * p10 * p10 + 0;
	end
	p10 = p10 - 2;
	return (p10 * p10 * p10 + 2) * 0.5 + 0;
end
function table1.CubicOutIn(p11) -- Anonymous function at line 153
	--[[
		Upvalues:
			[1] = table1
	--]]
	if p11 < 0.5 then
		return table1.CubicOut(p11 * 2);
	end
	return table1.CubicIn(p11 * 2 - 1);
end
function table1.QuartIn(p12) -- Anonymous function at line 162
	p12 = p12 / 1;
	return math.pow(p12, 4) * 1 + 0;
end
function table1.QuartOut(p13) -- Anonymous function at line 168
	p13 = p13 / 1 - 1;
	return (math.pow(p13, 4) - 1) * -1 + 0;
end
function table1.QuartInOut(p14) -- Anonymous function at line 174
	p14 = p14 / 1 * 2;
	if p14 < 1 then
		return math.pow(p14, 4) * 0.5 + 0;
	end
	p14 = p14 - 2;
	return (math.pow(p14, 4) - 2) * -0.5 + 0;
end
function table1.QuartOutIn(p15) -- Anonymous function at line 185
	--[[
		Upvalues:
			[1] = table1
	--]]
	if p15 < 0.5 then
		return table1.QuartOut(p15 * 2);
	end
	return table1.QuartIn(p15 * 2 - 1);
end
function table1.QuintIn(p16) -- Anonymous function at line 194
	p16 = p16 / 1;
	return math.pow(p16, 5) * 1 + 0;
end
function table1.QuintOut(p17) -- Anonymous function at line 200
	p17 = p17 / 1 - 1;
	return (math.pow(p17, 5) + 1) * 1 + 0;
end
function table1.QuintInOut(p18) -- Anonymous function at line 206
	p18 = p18 / 1 * 2;
	if p18 < 1 then
		return math.pow(p18, 5) * 0.5 + 0;
	end
	p18 = p18 - 2;
	return (math.pow(p18, 5) + 2) * 0.5 + 0;
end
function table1.QuintOutIn(p19) -- Anonymous function at line 217
	--[[
		Upvalues:
			[1] = table1
	--]]
	if p19 < 0.5 then
		return table1.QuintOut(p19 * 2);
	end
	return table1.QuintIn(p19 * 2 - 1);
end
function table1.SineIn(p20) -- Anonymous function at line 226
	return math.cos(p20 / 1 * (math.pi / 2)) * -1 + 1 + 0;
end
function table1.SineOut(p21) -- Anonymous function at line 231
	return math.sin(p21 / 1 * (math.pi / 2)) * 1 + 0;
end
function table1.SineInOut(p22) -- Anonymous function at line 236
	return (math.cos(math.pi * p22 / 1) - 1) * -0.5 + 0;
end
function table1.SineOutIn(p23) -- Anonymous function at line 241
	--[[
		Upvalues:
			[1] = table1
	--]]
	if p23 < 0.5 then
		return table1.SineOut(p23 * 2);
	end
	return table1.SineIn(p23 * 2);
end
function table1.ExpoIn(p24) -- Anonymous function at line 250
	if p24 == 0 then
		return 0;
	end
	return math.pow(2, (p24 / 1 - 1) * 10) * 1 + 0 - 0.001;
end
function table1.ExpoOut(p25) -- Anonymous function at line 259
	if p25 == 1 then
		return 1;
	end
	return (-math.pow(2, p25 * -10 / 1) + 1) * 1.001 + 0;
end
function table1.ExpoInOut(p26) -- Anonymous function at line 268
	if p26 == 0 then
		return 0;
	end
	if p26 == 1 then
		return 1;
	end
	p26 = p26 / 1 * 2;
	if p26 < 1 then
		return math.pow(2, (p26 - 1) * 10) * 0.5 + 0 - 0.0005;
	end
	p26 = p26 - 1;
	return (-math.pow(2, p26 * -10) + 2) * 0.50025 + 0;
end
function table1.ExpoOutIn(p27) -- Anonymous function at line 281
	--[[
		Upvalues:
			[1] = table1
	--]]
	if p27 < 0.5 then
		return table1.ExpoOut(p27 * 2);
	end
	return table1.ExpoIn(p27 * 2 - 1);
end
function table1.CircIn(p28) -- Anonymous function at line 290
	p28 = p28 / 1;
	return (math.sqrt(1 - math.pow(p28, 2)) - 1) * -1 + 0;
end
function table1.CircOut(p29) -- Anonymous function at line 296
	p29 = p29 / 1 - 1;
	return math.sqrt(1 - math.pow(p29, 2)) * 1 + 0;
end
function table1.CircInOut(p30) -- Anonymous function at line 302
	p30 = p30 / 1 * 2;
	if p30 < 1 then
		return (math.sqrt(1 - p30 * p30) - 1) * -0.5 + 0;
	end
	p30 = p30 - 2;
	return (math.sqrt(1 - p30 * p30) + 1) * 0.5 + 0;
end
function table1.CircOutIn(p31) -- Anonymous function at line 313
	--[[
		Upvalues:
			[1] = table1
	--]]
	if p31 < 0.5 then
		return table1.CircOut(p31 * 2);
	end
	return table1.CircIn(p31 * 2 - 1);
end
function table1.ElasticIn(p32) -- Anonymous function at line 322
	if p32 == 0 then
		return 0;
	end
	p32 = p32 / 1;
	if p32 == 1 then
		return 1;
	end
	local num1 = nil;
	local num2 = nil;
	if not num1 then
		num1 = 0.3;
	end
	local v5;
	if not num2 or num2 < 1 then
		num2 = 1;
		v5 = num1 / 4;
	else
		v5 = num1 / (math.pi * 2) * math.asin(1 / num2);
	end
	p32 = p32 - 1;
	return -(num2 * math.pow(2, p32 * 10) * math.sin((p32 * 1 - v5) * (math.pi * 2) / num1)) + 0;
end
function table1.ElasticOut(p33) -- Anonymous function at line 344
	if p33 == 0 then
		return 0;
	end
	p33 = p33 / 1;
	if p33 == 1 then
		return 1;
	end
	local num3 = nil;
	local num4 = nil;
	if not num3 then
		num3 = 0.3;
	end
	local v6;
	if not num4 or num4 < 1 then
		num4 = 1;
		v6 = num3 / 4;
	else
		v6 = num3 / (math.pi * 2) * math.asin(1 / num4);
	end
	return num4 * math.pow(2, p33 * -10) * math.sin((p33 * 1 - v6) * (math.pi * 2) / num3) + 1 + 0;
end
function table1.ElasticInOut(p34) -- Anonymous function at line 364
	if p34 == 0 then
		return 0;
	end
	p34 = p34 / 1 * 2;
	if p34 == 2 then
		return 1;
	end
	local num5 = nil;
	local num6 = nil;
	if not num5 then
		num5 = 0.44999999999999996;
	end
	if not num6 then
		num6 = 0;
	end
	local v7;
	if not num6 or num6 < 1 then
		num6 = 1;
		v7 = num5 / 4;
	else
		v7 = num5 / (math.pi * 2) * math.asin(1 / num6);
	end
	if p34 < 1 then
		p34 = p34 - 1;
		return num6 * math.pow(2, p34 * 10) * math.sin((p34 * 1 - v7) * (math.pi * 2) / num5) * -0.5 + 0;
	end
	p34 = p34 - 1;
	return num6 * math.pow(2, p34 * -10) * math.sin((p34 * 1 - v7) * (math.pi * 2) / num5) * 0.5 + 1 + 0;
end
function table1.ElasticOutIn(p35) -- Anonymous function at line 392
	--[[
		Upvalues:
			[1] = table1
	--]]
	if p35 < 0.5 then
		return table1.ElasticOut(p35 * 2);
	end
	return table1.ElasticIn(p35 * 2 - 1);
end
function table1.BackIn(p36) -- Anonymous function at line 401
	p36 = p36 / 1;
	return p36 * 1 * p36 * (p36 * 2.70158 - 1.70158) + 0;
end
function table1.BackOut(p37) -- Anonymous function at line 408
	p37 = p37 / 1 - 1;
	return (p37 * p37 * (p37 * 2.70158 + 1.70158) + 1) * 1 + 0;
end
function table1.BackInOut(p38) -- Anonymous function at line 415
	local v4 = 1.70158 * 1.525;
	p38 = p38 / 1 * 2;
	if p38 < 1 then
		return p38 * p38 * ((v4 + 1) * p38 - v4) * 0.5 + 0;
	end
	p38 = p38 - 2;
	return (p38 * p38 * ((v4 + 1) * p38 + v4) + 2) * 0.5 + 0;
end
function table1.BackOutIn(p39) -- Anonymous function at line 428
	--[[
		Upvalues:
			[1] = table1
	--]]
	if p39 < 0.5 then
		return table1.BackOut(p39 * 2);
	end
	return table1.BackIn(p39 * 2 - 1);
end
function table1.BounceOut(p40) -- Anonymous function at line 437
	p40 = p40 / 1;
	if p40 < 4 / 11 then
		return p40 * 7.5625 * p40 * 1 + 0;
	end
	if p40 < 8 / 11 then
		p40 = p40 - 6 / 11;
		return (p40 * 7.5625 * p40 + 0.75) * 1 + 0;
	end
	if p40 < 10 / 11 then
		p40 = p40 - 9 / 11;
		return (p40 * 7.5625 * p40 + 0.9375) * 1 + 0;
	end
	p40 = p40 - 21 / 22;
	return (p40 * 7.5625 * p40 + 0.984375) * 1 + 0;
end
function table1.BounceIn(p41) -- Anonymous function at line 454
	--[[
		Upvalues:
			[1] = table1
	--]]
	return 1 - table1.BounceOut(1 - p41) + 0;
end
function table1.BounceInOut(p42) -- Anonymous function at line 459
	--[[
		Upvalues:
			[1] = table1
	--]]
	if p42 < 0.5 then
		return table1.BounceIn(p42 * 2) * 0.5 + 0;
	end
	return table1.BounceOut(p42 * 2 - 1) * 0.5 + 0.5 + 0;
end
function table1.BounceOutIn(p43) -- Anonymous function at line 468
	--[[
		Upvalues:
			[1] = table1
	--]]
	if p43 < 0.5 then
		return table1.BounceOut(p43 * 2);
	end
	return table1.BounceIn(p43 * 2 - 1);
end
return Get;

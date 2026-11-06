-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

function epsRound(p1, p2)
	return math.round(p1 / p2) * p2;
end;
function perceivedBlackness(p3, p4, p5)
	return 1 - p5;
end;
function perceivedWhiteness(p6, p7, p8)
	return p8 * (1 - p7);
end;
function perceivedGrayness(p9, p10, p11)
	return 1 - p10;
end;
function perceivedColorfulness(p12, p13, p14)
	local v1 = 1 - p13;
	return p14 * p13 * math.sqrt(1 - v1 * v1);
end;
function perceivedBrightness(p15, p16, p17)
	local v2 = math.sqrt(p17);
	if p16 < 0.1 then
		v2 = p17;
	end;
	return v2;
end;
local u1 = {
	Black = 0.7, 
	Gray = 0.85, 
	White = 0.9
};
local u2 = {
	Black = 3, 
	Gray = 2, 
	White = 1, 
	Default = 0
};
function perceivedOrder(p18, p19, p20)
	if u1.Black <= perceivedBlackness(p18, p19, p20) then
		return u2.Black;
	end;
	if u1.White <= perceivedWhiteness(p18, p19, p20) then
		return u2.White;
	end;
	if u1.Gray <= perceivedGrayness(p18, p19, p20) then
		return u2.Gray;
	end;
	return u2.Default;
end;
local u3 = require(script.Parent.ClampColor);
local u4 = require(script.Parent.CorrectColor);
local u5 = require(script.Parent.DegDelta);
return function(p21, p22)
	p21 = u3(p21);
	p22 = u3(p22);
	p21 = u4(p21);
	p22 = u4(p22);
	local v3, v4, v5 = p21:ToHSV();
	local v6, v7, v8 = p22:ToHSV();
	local v9 = perceivedOrder(v3, v4, v5);
	local v10 = perceivedOrder(v6, v7, v8);
	if v9 ~= v10 then
		return v9 - v10;
	end;
	local v11 = perceivedColorfulness(v3, v4, v5);
	local v12 = perceivedColorfulness(v6, v7, v8);
	local v13 = 0;
	if v3 ~= v6 then
		v13 = v3 - v6;
	else
		if v11 ~= v12 then
			return -(v11 - v12);
		end;
		if v4 ~= v7 then
			v13 = -(v4 - v7);
		elseif v5 ~= v8 then
			v13 = -(v5 - v8);
		end;
	end;
	local v14 = epsRound(u5(0, v3 * 360) / 360, 0.027777777777777776) - epsRound(u5(0, v6 * 360) / 360, 0.027777777777777776);
	if v14 ~= 0 then
		return v14;
	end;
	local v15 = epsRound(v11, 0.05) - epsRound(v12, 0.05);
	if v15 == 0 then
		return v13;
	end;
	return -v15;
end;

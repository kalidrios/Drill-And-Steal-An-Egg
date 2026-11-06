-- https://github.com/kalidrios

local string_char = string.char;
local string_byte = string.byte;
local _ = string.format;
local string_rep = string.rep;
local string_sub = string.sub;
local bit32_bnot = bit32.bnot;
local function tobit(p1) -- Line: 10
	--[[
		Upvalues:
			[1] = bit32_bnot
	--]]
	return p1 <= 2147483647 and p1 or -(bit32_bnot(p1) + 1);
end
local function normalize(p2) -- Line: 14
	--[[
		Upvalues:
			[1] = tobit
			[2] = bit32_bnot
	--]]
	return function(p48, p49) -- Line: 15
		--[[
			Upvalues:
				[1] = p2
				[2] = tobit
				[3] = bit32_bnot
		--]]
		local v129 = p2(tobit(p48), (tobit(p49)));
		return v129 <= 2147483647 and v129 or -(bit32_bnot(v129) + 1);
	end;
end
local bit32_bor = bit32.bor;
local function u2(p3, p4) -- Anonymous function at line 15
	--[[
		Upvalues:
			[1] = bit32_bor
			[2] = tobit
			[3] = bit32_bnot
	--]]
	local v1 = bit32_bor(tobit(p3), (tobit(p4)));
	return v1 <= 2147483647 and v1 or -(bit32_bnot(v1) + 1);
end
local bit32_band = bit32.band;
local function u3(p5, p6) -- Anonymous function at line 15
	--[[
		Upvalues:
			[1] = bit32_band
			[2] = tobit
			[3] = bit32_bnot
	--]]
	local v2 = bit32_band(tobit(p5), (tobit(p6)));
	return v2 <= 2147483647 and v2 or -(bit32_bnot(v2) + 1);
end
local bit32_bxor = bit32.bxor;
local function u4(p7, p8) -- Anonymous function at line 15
	--[[
		Upvalues:
			[1] = bit32_bxor
			[2] = tobit
			[3] = bit32_bnot
	--]]
	local v3 = bit32_bxor(tobit(p7), (tobit(p8)));
	return v3 <= 2147483647 and v3 or -(bit32_bnot(v3) + 1);
end
local bit32_rshift = bit32.rshift;
local function u5(p9, p10) -- Anonymous function at line 15
	--[[
		Upvalues:
			[1] = bit32_rshift
			[2] = tobit
			[3] = bit32_bnot
	--]]
	local v4 = bit32_rshift(tobit(p9), (tobit(p10)));
	return v4 <= 2147483647 and v4 or -(bit32_bnot(v4) + 1);
end
local bit32_lshift = bit32.lshift;
local function u6(p11, p12) -- Anonymous function at line 15
	--[[
		Upvalues:
			[1] = bit32_lshift
			[2] = tobit
			[3] = bit32_bnot
	--]]
	local v5 = bit32_lshift(tobit(p11), (tobit(p12)));
	return v5 <= 2147483647 and v5 or -(bit32_bnot(v5) + 1);
end
local function lei2str(p13) -- Line: 23
	--[[
		Upvalues:
			[1] = u3
			[2] = u5
			[3] = string_char
	--]]
	local function _(p50) -- Anonymous function at line 24
		--[[
			Upvalues:
				[1] = u3
				[2] = u5
				[3] = p13
				[4] = string_char
		--]]
		return string_char(u3(u5(p13, p50), 255));
	end
	return string_char(u3(u5(p13, 0), 255)) .. string_char(u3(u5(p13, 8), 255)) .. string_char(u3(u5(p13, 16), 255)) .. string_char(u3(u5(p13, 24), 255));
end
local function str2lei(p14) -- Line: 30
	--[[
		Upvalues:
			[1] = string_byte
	--]]
	local v6 = 0;
	for index1 = #p14, 1, -1 do
		v6 = v6 * 256 + string_byte(p14, index1);
	end
	return v6;
end
local function cut_le_str(p15) -- Line: 40
	--[[
		Upvalues:
			[1] = string_sub
			[2] = string_byte
	--]]
	local table1 = {};
	local v7 = string_sub(p15, 1, 4);
	local v8 = 0;
	for index2 = #v7, 1, -1 do
		v8 = v8 * 256 + string_byte(v7, index2);
	end
	local v9 = v8;
	local v10 = string_sub(p15, 5, 8);
	local v11 = 0;
	for index3 = #v10, 1, -1 do
		v11 = v11 * 256 + string_byte(v10, index3);
	end
	local v12 = v11;
	local v13 = string_sub(p15, 9, 12);
	local v14 = 0;
	for index4 = #v13, 1, -1 do
		v14 = v14 * 256 + string_byte(v13, index4);
	end
	local v15 = v14;
	local v16 = string_sub(p15, 13, 16);
	local v17 = 0;
	for index5 = #v16, 1, -1 do
		v17 = v17 * 256 + string_byte(v16, index5);
	end
	local v18 = v17;
	local v19 = string_sub(p15, 17, 20);
	local v20 = 0;
	for index6 = #v19, 1, -1 do
		v20 = v20 * 256 + string_byte(v19, index6);
	end
	local v21 = v20;
	local v22 = string_sub(p15, 21, 24);
	local v23 = 0;
	for index7 = #v22, 1, -1 do
		v23 = v23 * 256 + string_byte(v22, index7);
	end
	local v24 = v23;
	local v25 = string_sub(p15, 25, 28);
	local v26 = 0;
	for index8 = #v25, 1, -1 do
		v26 = v26 * 256 + string_byte(v25, index8);
	end
	local v27 = v26;
	local v28 = string_sub(p15, 29, 32);
	local v29 = 0;
	for index9 = #v28, 1, -1 do
		v29 = v29 * 256 + string_byte(v28, index9);
	end
	local v30 = v29;
	local v31 = string_sub(p15, 33, 36);
	local v32 = 0;
	for index10 = #v31, 1, -1 do
		v32 = v32 * 256 + string_byte(v31, index10);
	end
	local v33 = v32;
	local v34 = string_sub(p15, 37, 40);
	local v35 = 0;
	for index11 = #v34, 1, -1 do
		v35 = v35 * 256 + string_byte(v34, index11);
	end
	local v36 = v35;
	local v37 = string_sub(p15, 41, 44);
	local v38 = 0;
	for index12 = #v37, 1, -1 do
		v38 = v38 * 256 + string_byte(v37, index12);
	end
	local v39 = v38;
	local v40 = string_sub(p15, 45, 48);
	local v41 = 0;
	for index13 = #v40, 1, -1 do
		v41 = v41 * 256 + string_byte(v40, index13);
	end
	local v42 = v41;
	local v43 = string_sub(p15, 49, 52);
	local v44 = 0;
	for index14 = #v43, 1, -1 do
		v44 = v44 * 256 + string_byte(v43, index14);
	end
	local v45 = v44;
	local v46 = string_sub(p15, 53, 56);
	local v47 = 0;
	for index15 = #v46, 1, -1 do
		v47 = v47 * 256 + string_byte(v46, index15);
	end
	local v48 = v47;
	local v49 = string_sub(p15, 57, 60);
	local v50 = 0;
	for index16 = #v49, 1, -1 do
		v50 = v50 * 256 + string_byte(v49, index16);
	end
	local v51 = v50;
	local v52 = string_sub(p15, 61, 64);
	local v53 = 0;
	for index17 = #v52, 1, -1 do
		v53 = v53 * 256 + string_byte(v52, index17);
	end
	table1[2] = v9
	table1[3] = v12
	table1[4] = v15
	table1[5] = v18
	table1[6] = v21
	table1[7] = v24
	table1[8] = v27
	table1[9] = v30
	table1[10] = v33
	table1[11] = v36
	table1[12] = v39
	table1[13] = v42
	table1[14] = v45
	table1[15] = v48
	table1[16] = v51
	table1[17] = v53;
	return table1;
end
local table2 = {
	3614090360,
	3905402710,
	606105819,
	3250441966,
	4118548399,
	1200080426,
	2821735955,
	4249261313,
	1770035416,
	2336552879,
	4294925233,
	2304563134,
	1804603682,
	4254626195,
	2792965006,
	1236535329,
	4129170786,
	3225465664,
	643717713,
	3921069994,
	3593408605,
	38016083,
	3634488961,
	3889429448,
	568446438,
	3275163606,
	4107603335,
	1163531501,
	2850285829,
	4243563512,
	1735328473,
	2368359562,
	4294588738,
	2272392833,
	1839030562,
	4259657740,
	2763975236,
	1272893353,
	4139469664,
	3200236656,
	681279174,
	3936430074,
	3572445317,
	76029189,
	3654602809,
	3873151461,
	530742520,
	3299628645,
	4096336452,
	1126891415,
	2878612391,
	4237533241,
	1700485571,
	2399980690,
	4293915773,
	2240044497,
	1873313359,
	4264355552,
	2734768916,
	1309151649,
	4149444226,
	3174756917,
	718787259,
	3951481745,
	1732584193,
	4023233417,
	2562383102,
	271733878
};
local function u9(p16, p17, p18) -- Anonymous function at line 84
	--[[
		Upvalues:
			[1] = u2
			[2] = u3
	--]]
	return u2(u3(p16, p17), u3(-p16 - 1, p18));
end
local function u10(p19, p20, p21) -- Anonymous function at line 85
	--[[
		Upvalues:
			[1] = u2
			[2] = u3
	--]]
	return u2(u3(p19, p21), u3(p20, -p21 - 1));
end
local function u11(p22, p23, p24) -- Anonymous function at line 86
	--[[
		Upvalues:
			[1] = u4
	--]]
	return u4(p22, u4(p23, p24));
end
local function u12(p25, p26, p27) -- Anonymous function at line 87
	--[[
		Upvalues:
			[1] = u4
			[2] = u2
	--]]
	return u4(p26, u2(p25, -p27 - 1));
end
local function u13(p28, p29, p30, p31, p32, p33, p34, p35) -- Anonymous function at line 88
	--[[
		Upvalues:
			[1] = u3
			[2] = u2
			[3] = u6
			[4] = u5
	--]]
	p29 = u3(p29 + p28(p30, p31, p32) + p33 + p35, 4294967295);
	return u2(u6(u3(p29, u5(4294967295, p34)), p34), u5(p29, 32 - p34)) + p30;
end
local function transform(p36, p37, p38, p39, p40) -- Line: 94
	--[[
		Upvalues:
			[1] = table2
			[2] = u13
			[3] = u9
			[4] = u10
			[5] = u11
			[6] = u12
			[7] = u3
	--]]
	local v54 = p37;
	local v55 = p38;
	local v56 = p39;
	local v57 = table2;
	local v58 = u13(u9, p36, v54, v55, v56, p40[0], 7, v57[1]);
	local v59 = u13(u9, v56, v58, v54, v55, p40[1], 12, v57[2]);
	local v60 = u13(u9, v55, v59, v58, v54, p40[2], 17, v57[3]);
	local v61 = u13(u9, v54, v60, v59, v58, p40[3], 22, v57[4]);
	local v62 = u13(u9, v58, v61, v60, v59, p40[4], 7, v57[5]);
	local v63 = u13(u9, v59, v62, v61, v60, p40[5], 12, v57[6]);
	local v64 = u13(u9, v60, v63, v62, v61, p40[6], 17, v57[7]);
	local v65 = u13(u9, v61, v64, v63, v62, p40[7], 22, v57[8]);
	local v66 = u13(u9, v62, v65, v64, v63, p40[8], 7, v57[9]);
	local v67 = u13(u9, v63, v66, v65, v64, p40[9], 12, v57[10]);
	local v68 = u13(u9, v64, v67, v66, v65, p40[10], 17, v57[11]);
	local v69 = u13(u9, v65, v68, v67, v66, p40[11], 22, v57[12]);
	local v70 = u13(u9, v66, v69, v68, v67, p40[12], 7, v57[13]);
	local v71 = u13(u9, v67, v70, v69, v68, p40[13], 12, v57[14]);
	local v72 = u13(u9, v68, v71, v70, v69, p40[14], 17, v57[15]);
	local v73 = u13(u9, v69, v72, v71, v70, p40[15], 22, v57[16]);
	local v74 = u13(u10, v70, v73, v72, v71, p40[1], 5, v57[17]);
	local v75 = u13(u10, v71, v74, v73, v72, p40[6], 9, v57[18]);
	local v76 = u13(u10, v72, v75, v74, v73, p40[11], 14, v57[19]);
	local v77 = u13(u10, v73, v76, v75, v74, p40[0], 20, v57[20]);
	local v78 = u13(u10, v74, v77, v76, v75, p40[5], 5, v57[21]);
	local v79 = u13(u10, v75, v78, v77, v76, p40[10], 9, v57[22]);
	local v80 = u13(u10, v76, v79, v78, v77, p40[15], 14, v57[23]);
	local v81 = u13(u10, v77, v80, v79, v78, p40[4], 20, v57[24]);
	local v82 = u13(u10, v78, v81, v80, v79, p40[9], 5, v57[25]);
	local v83 = u13(u10, v79, v82, v81, v80, p40[14], 9, v57[26]);
	local v84 = u13(u10, v80, v83, v82, v81, p40[3], 14, v57[27]);
	local v85 = u13(u10, v81, v84, v83, v82, p40[8], 20, v57[28]);
	local v86 = u13(u10, v82, v85, v84, v83, p40[13], 5, v57[29]);
	local v87 = u13(u10, v83, v86, v85, v84, p40[2], 9, v57[30]);
	local v88 = u13(u10, v84, v87, v86, v85, p40[7], 14, v57[31]);
	local v89 = u13(u10, v85, v88, v87, v86, p40[12], 20, v57[32]);
	local v90 = u13(u11, v86, v89, v88, v87, p40[5], 4, v57[33]);
	local v91 = u13(u11, v87, v90, v89, v88, p40[8], 11, v57[34]);
	local v92 = u13(u11, v88, v91, v90, v89, p40[11], 16, v57[35]);
	local v93 = u13(u11, v89, v92, v91, v90, p40[14], 23, v57[36]);
	local v94 = u13(u11, v90, v93, v92, v91, p40[1], 4, v57[37]);
	local v95 = u13(u11, v91, v94, v93, v92, p40[4], 11, v57[38]);
	local v96 = u13(u11, v92, v95, v94, v93, p40[7], 16, v57[39]);
	local v97 = u13(u11, v93, v96, v95, v94, p40[10], 23, v57[40]);
	local v98 = u13(u11, v94, v97, v96, v95, p40[13], 4, v57[41]);
	local v99 = u13(u11, v95, v98, v97, v96, p40[0], 11, v57[42]);
	local v100 = u13(u11, v96, v99, v98, v97, p40[3], 16, v57[43]);
	local v101 = u13(u11, v97, v100, v99, v98, p40[6], 23, v57[44]);
	local v102 = u13(u11, v98, v101, v100, v99, p40[9], 4, v57[45]);
	local v103 = u13(u11, v99, v102, v101, v100, p40[12], 11, v57[46]);
	local v104 = u13(u11, v100, v103, v102, v101, p40[15], 16, v57[47]);
	local v105 = u13(u11, v101, v104, v103, v102, p40[2], 23, v57[48]);
	local v106 = u13(u12, v102, v105, v104, v103, p40[0], 6, v57[49]);
	local v107 = u13(u12, v103, v106, v105, v104, p40[7], 10, v57[50]);
	local v108 = u13(u12, v104, v107, v106, v105, p40[14], 15, v57[51]);
	local v109 = u13(u12, v105, v108, v107, v106, p40[5], 21, v57[52]);
	local v110 = u13(u12, v106, v109, v108, v107, p40[12], 6, v57[53]);
	local v111 = u13(u12, v107, v110, v109, v108, p40[3], 10, v57[54]);
	local v112 = u13(u12, v108, v111, v110, v109, p40[10], 15, v57[55]);
	local v113 = u13(u12, v109, v112, v111, v110, p40[1], 21, v57[56]);
	local v114 = u13(u12, v110, v113, v112, v111, p40[8], 6, v57[57]);
	local v115 = u13(u12, v111, v114, v113, v112, p40[15], 10, v57[58]);
	local v116 = u13(u12, v112, v115, v114, v113, p40[6], 15, v57[59]);
	local v117 = u13(u12, v113, v116, v115, v114, p40[13], 21, v57[60]);
	local v118 = u13(u12, v114, v117, v116, v115, p40[4], 6, v57[61]);
	local v119 = u13(u12, v115, v118, v117, v116, p40[11], 10, v57[62]);
	local v120 = u13(u12, v116, v119, v118, v117, p40[2], 15, v57[63]);
	local v121 = u13(u12, v117, v120, v119, v118, p40[9], 21, v57[64]);
	return u3(p36 + v118, 4294967295), u3(p37 + v121, 4294967295), u3(p38 + v120, 4294967295), u3(p39 + v119, 4294967295);
end
function update(p41, p42) -- Line: 182
	--[[
		Upvalues:
			[1] = cut_le_str
			[2] = string_sub
			[3] = transform
	--]]
	p41.pos = p41.pos + #p42;
	p42 = p41.buf .. p42;
	for index18 = 1, #p42 - 63, 64 do
		local v123 = cut_le_str((string_sub(p42, index18, index18 + 63)));
		assert(#v123 == 16);
		v123[0] = table.remove(v123, 1);
		local v124, v125, v126, v127 = transform(p41.a, p41.b, p41.c, p41.d, v123);
		p41.a = v124;
		p41.b = v125;
		p41.c = v126;
		p41.d = v127;
	end
	p41.buf = string_sub(p42, math.floor(#p42 / 64) * 64 + 1, #p42);
	return p41;
end
function finish(p43) -- Line: 195
	--[[
		Upvalues:
			[1] = string_char
			[2] = string_rep
			[3] = lei2str
			[4] = u3
	--]]
	local t_pos = p43.pos;
	local v122 = 56 - t_pos % 64;
	if t_pos % 64 > 56 then
		v122 = v122 + 64;
	end
	if v122 == 0 then
		v122 = 64;
	end
	update(p43, string_char(128) .. string_rep(string_char(0), v122 - 1) .. lei2str(u3(t_pos * 8, 4294967295)) .. lei2str((math.floor(t_pos / 536870912))));
	assert(p43.pos % 64 == 0);
	return lei2str(p43.a) .. lei2str(p43.b) .. lei2str(p43.c) .. lei2str(p43.d);
end
local table3 = {
	new = function() -- new (Line: 242)
		--[[
			Upvalues:
				[1] = table2
		--]]
		local table4 = {
			a = table2[65],
			b = table2[66],
			c = table2[67],
			d = table2[68],
			pos = 0,
			buf = "",
			update = update,
			finish = finish
		};
		return table4;
	end,
	str2bei = function(p47) -- str2bei (Line: 256)
		--[[
			Upvalues:
				[1] = string_byte
		--]]
		local v128 = 0;
		for index19 = 1, #p47 do
			v128 = v128 * 256 + string_byte(p47, index19);
		end
		return v128;
	end
};
function table3.tohex(p44) -- Line: 264
	--[[
		Upvalues:
			[1] = table3
	--]]
	return string.format("%08x%08x%08x%08x", table3.str2bei(p44:sub(1, 4)), table3.str2bei(p44:sub(5, 8)), table3.str2bei(p44:sub(9, 12)), table3.str2bei(p44:sub(13, 16)));
end
function table3.sum(p45) -- Line: 269
	--[[
		Upvalues:
			[1] = table3
	--]]
	return table3.new():update(p45):finish();
end
function table3.sumhexa(p46) -- Line: 273
	--[[
		Upvalues:
			[1] = table3
	--]]
	return table3.tohex(table3.sum(p46));
end
return table3;

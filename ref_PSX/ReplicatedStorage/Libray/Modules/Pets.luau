-- https://github.com/kalidrios

local table1 = {MAX_OWNER_HISTORY_LENGTH = 2};
function table1.AddOwner(p1, _, p2) -- Line: 168
	--[[
		Upvalues:
			[1] = table1
	--]]
	local v1 = p2.h;
	if not v1 then
		local table2 = {
			n = 0,
			l = {}
		};
		v1 = table2;
		p2.h = table2;
	end
	assert(v1);
	local bool1 = true;
	if #v1.l > 0 and v1.l[1][1] == p1 then
		bool1 = false;
	end
	if bool1 then
		v1.n = v1.n + 1;
		table.insert(v1.l, 1, {
			p1,
			math.floor((os.time()))
		});
	end
	while #v1.l > table1.MAX_OWNER_HISTORY_LENGTH do
		table.remove(v1.l, #v1.l);
	end
end
return table1;

-- https://github.com/kalidrios

local table1 = {
	AND = function(...) -- AND (Line: 5)
		local table2 = {...};
		return function(...) -- Line: 7
			--[[
				Upvalues:
					[1] = table2
			--]]
			for _, val1 in ipairs(table2) do
				if val1(...) then continue end
				return false;
			end
			return true;
		end;
	end,
	OR = function(...) -- OR (Line: 17)
		local table3 = {...};
		return function(...) -- Line: 19
			--[[
				Upvalues:
					[1] = table3
			--]]
			for _, val2 in ipairs(table3) do
				if not val2(...) then continue end
				return true;
			end
			return false;
		end;
	end
};
return table1;

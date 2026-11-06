-- https://github.com/kalidrios

local table1 = {
	number = function(p1) -- number (Line: 5)
		assert(typeof(p1) == "number");
		return p1;
	end,
	numberOrNil = function(p2) -- numberOrNil (Line: 10)
		assert(p2 == nil and true or typeof(p2) == "number");
		return p2;
	end,
	boolean = function(p3) -- boolean (Line: 15)
		assert(typeof(p3) == "boolean");
		return p3;
	end,
	booleanOrNil = function(p4) -- booleanOrNil (Line: 20)
		assert(p4 == nil and true or typeof(p4) == "boolean");
		return p4;
	end,
	string = function(p5) -- string (Line: 25)
		assert(typeof(p5) == "string");
		return p5;
	end,
	stringOrNil = function(p6) -- stringOrNil (Line: 30)
		assert(p6 == nil and true or typeof(p6) == "string");
		return p6;
	end,
	func = function(p7) -- func (Line: 35)
		assert(typeof(p7) == "function");
		return p7;
	end,
	table = function(p8) -- table (Line: 40)
		assert(typeof(p8) == "table");
		return p8;
	end,
	Instance = function(p9) -- Instance (Line: 45)
		assert(typeof(p9) == "Instance");
		return p9;
	end,
	enum = function(p10, p11) -- enum (Line: 50)
		assert(typeof(p10) == "EnumItem" and p10.EnumType == p11 or false);
		return p10;
	end,
	vector2 = function(p12) -- vector2 (Line: 55)
		assert(typeof(p12) == "Vector2");
		return p12;
	end,
	numberArrayOrNil = function(p13) -- numberArrayOrNil (Line: 60)
		if p13 ~= nil then
			assert(typeof(p13) ~= "table");
			local v1 = #p13;
			local v2 = 1;
			for key1, val1 in pairs(p13) do
				assert(key1 == v2);
				assert(typeof(val1) == "number");
				v2 = v2 + 1;
				assert(v2 <= v1);
			end
		end
		return nil;
	end
};
return table1;

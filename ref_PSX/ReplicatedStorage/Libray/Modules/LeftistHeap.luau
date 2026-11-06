-- https://github.com/kalidrios

local table1 = {};
function _merge1(p1, p2, p3) -- Line: 26
	if not p2.left then
		p2.left = p3;
		return p2;
	end
	p2.right = _merge(p1, p2.right, p3);
	if p2.left.npl < p2.right.npl then
		local t_right = p2.right;
		local t_left = p2.left;
		p2.left = t_right;
		p2.right = t_left;
	end
	p2.npl = p2.right.npl + 1;
	return p2;
end
function _merge(p4, p5, p6) -- Line: 46
	if p5 then
		if p6 then
			if p4(p5.element, p6.element) < 0 then
				return _merge1(p4, p5, p6);
			end
			return _merge1(p4, p6, p5);
		end
		return p5;
	end
	return p6;
end
function table1.new(p7) -- Line: 59
	assert(typeof(p7) == "function");
	local table2 = {root = nil};
	local function insert(p8) -- Line: 82
		--[[
			Upvalues:
				[1] = table2
				[2] = p7
		--]]
		table2.root = _merge(p7, {
			element = p8,
			npl = 0
		}, table2.root);
	end
	local function min() -- Line: 93
		--[[
			Upvalues:
				[1] = table2
		--]]
		assert(table2.root);
		return table2.root.element;
	end
	local function tryMin() -- Line: 102
		--[[
			Upvalues:
				[1] = table2
		--]]
		if table2.root then
			return true, table2.root.element;
		end
		return false, nil;
	end
	local function pop() -- Line: 113
		--[[
			Upvalues:
				[1] = table2
				[2] = p7
		--]]
		assert(table2.root);
		local t_element = table2.root.element;
		table2.root = _merge(p7, table2.root.left, table2.root.right);
		return t_element;
	end
	local function tryPop() -- Line: 124
		--[[
			Upvalues:
				[1] = table2
				[2] = p7
		--]]
		if table2.root then
			local t_element2 = table2.root.element;
			table2.root = _merge(p7, table2.root.left, table2.root.right);
			return true, t_element2;
		end
		return false, nil;
	end
	local function popFast() -- Line: 137
		--[[
			Upvalues:
				[1] = table2
				[2] = p7
		--]]
		table2.root = _merge(p7, table2.root.left, table2.root.right);
	end
	local function empty() -- Line: 146
		--[[
			Upvalues:
				[1] = table2
		--]]
		return table2.root == nil;
	end
	local function clear() -- Line: 153
		--[[
			Upvalues:
				[1] = table2
		--]]
		table2.root = nil;
	end
	function table2.merge(p9) -- Line: 71
		--[[
			Upvalues:
				[1] = table2
				[2] = p7
		--]]
		if table2.root ~= p9.root then
			table2.root = _merge(p7, table2.root, p9.root);
			p9.root = nil;
		end
	end
	table2.insert = insert;
	table2.min = min;
	table2.tryMin = tryMin;
	table2.pop = pop;
	table2.tryPop = tryPop;
	table2.popFast = popFast;
	table2.empty = empty;
	table2.clear = clear;
	return table2;
end
return table1;

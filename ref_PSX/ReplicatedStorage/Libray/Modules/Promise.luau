-- https://github.com/kalidrios

local table1 = {__mode = "k"};
local function isCallable(p1) -- Line: 10
	if type(p1) == "function" then
		return true;
	end
	if type(p1) == "table" then
		local metatable = getmetatable(p1);
		if metatable and type((rawget(metatable, "__call"))) == "function" then
			return true;
		end
	end
	return false;
end
local function makeEnum(p2, p3) -- Line: 28
	local table2 = {};
	for _, val1 in ipairs(p3) do
		table2[val1] = val1;
	end
	return setmetatable(table2, {
		__index = function(_, p129) -- __index (Line: 36)
			--[[
				Upvalues:
					[1] = p2
			--]]
			error(string.format("%s is not in %s!", p129, p2), 2);
		end,
		__newindex = function() -- __newindex (Line: 39)
			--[[
				Upvalues:
					[1] = p2
			--]]
			error(string.format("Creating new members in %s is not allowed!", p2), 2);
		end
	});
end
local table3 = {Kind = makeEnum("Promise.Error.Kind", {
	"ExecutionError",
	"AlreadyCancelled",
	"NotResolvedInTime",
	"TimedOut"
})};
table3.__index = table3;
function table3.new(p4, p5) -- Line: 64
	--[[
		Upvalues:
			[1] = table3
	--]]
	p4 = p4 or {};
	return setmetatable({
		error = tostring(p4.error) or "[This error has no error text.]",
		trace = p4.trace,
		context = p4.context,
		kind = p4.kind,
		parent = p5,
		createdTick = os.clock(),
		createdTrace = debug.traceback()
	}, table3);
end
function table3.is(p6) -- Line: 77
	if type(p6) == "table" then
		local metatable2 = getmetatable(p6);
		if type(metatable2) == "table" then
			local v40;
			if rawget(p6, "error") == nil then
				v40 = false;
			else
				v40 = type((rawget(metatable2, "extend"))) == "function";
			end
			return v40;
		end
	end
	return false;
end
function table3.isKind(p7, p8) -- Line: 89
	--[[
		Upvalues:
			[1] = table3
	--]]
	assert(p8 ~= nil, "Argument #2 to Promise.Error.isKind must not be nil");
	return table3.is(p7) and p7.kind == p8;
end
function table3.extend(p9, p10) -- Line: 95
	--[[
		Upvalues:
			[1] = table3
	--]]
	p10 = p10 or {};
	p10.kind = p10.kind or p9.kind;
	return table3.new(p10, p9);
end
function table3.getErrorChain(p11) -- Line: 103
	local table4 = {p11};
	while table4[#table4].parent do
		table.insert(table4, table4[#table4].parent);
	end
	return table4;
end
function table3.__tostring(p12) -- Line: 113
	local table5 = {string.format("-- Promise.Error(%s) --", p12.kind or "?")};
	for _, val2 in ipairs(p12:getErrorChain()) do
		table.insert(table5, table.concat({
			val2.trace or val2.error,
			val2.context
		}, "\n"));
	end
	return table.concat(table5, "\n");
end
local function pack(...) -- Line: 137
	return select("#", ...), {...};
end
local function packResult(p13, ...) -- Line: 144
	return p13, select("#", ...), {...};
end
local function makeErrorHandler(p14) -- Line: 148
	--[[
		Upvalues:
			[1] = table3
	--]]
	assert(p14 ~= nil, "traceback is nil");
	return function(p96) -- Line: 151
		--[[
			Upvalues:
				[1] = table3
				[2] = p14
		--]]
		if type(p96) == "table" then
			return p96;
		end
		return table3.new({
			error = p96,
			kind = table3.Kind.ExecutionError,
			trace = debug.traceback(tostring(p96), 2),
			context = "Promise created at:\n\n" .. p14
		});
	end;
end
local function runExecutor(p15, p16, ...) -- Line: 171
	--[[
		Upvalues:
			[1] = packResult
			[2] = table3
	--]]
	local v24 = packResult;
	local g_xpcall = xpcall;
	local v25 = p16;
	assert(p15 ~= nil, "traceback is nil");
	local function v26(p97) -- Anonymous function at line 151
		--[[
			Upvalues:
				[1] = table3
				[2] = p15
		--]]
		if type(p97) == "table" then
			return p97;
		end
		return table3.new({
			error = p97,
			kind = table3.Kind.ExecutionError,
			trace = debug.traceback(tostring(p97), 2),
			context = "Promise created at:\n\n" .. p15
		});
	end
	return v24(g_xpcall(v25, v26, ...));
end
local function createAdvancer(p17, p18, p19, p20) -- Line: 179
	--[[
		Upvalues:
			[1] = runExecutor
	--]]
	return function(...) -- Line: 180
		--[[
			Upvalues:
				[1] = runExecutor
				[2] = p17
				[3] = p18
				[4] = p19
				[5] = p20
		--]]
		local v37, v38, v39 = runExecutor(p17, p18, ...);
		if v37 then
			p19(unpack(v39, 1, v38));
			return;
		end
		p20(v39[1]);
	end;
end
local function isEmpty(p21) -- Line: 191
	return next(p21) == nil;
end
local table6 = {
	Error = table3,
	Status = makeEnum("Promise.Status", {
		"Started",
		"Resolved",
		"Rejected",
		"Cancelled"
	}),
	_getTime = os.clock,
	_timeEvent = game:GetService("RunService").Heartbeat,
	_unhandledRejectionCallbacks = {},
	prototype = {}
};
table6.__index = table6.prototype;
function table6._new(p22, p23, p24) -- Line: 230
	--[[
		Upvalues:
			[1] = table6
			[2] = table1
			[3] = runExecutor
	--]]
	if p24 ~= nil and not table6.is(p24) then
		error("Argument #2 to Promise.new must be a promise or nil", 2);
	end
	local table7 = {
		_thread = nil,
		_source = p22,
		_status = table6.Status.Started,
		_values = nil,
		_valuesLength = -1,
		_unhandledRejection = true,
		_queuedResolve = {},
		_queuedReject = {},
		_queuedFinally = {},
		_cancellationHook = nil,
		_parent = p24,
		_consumers = setmetatable({}, table1)
	};
	if p24 and p24._status == table6.Status.Started then
		p24._consumers[table7] = true;
	end
	setmetatable(table7, table6);
	local function resolve(...) -- Line: 278
		--[[
			Upvalues:
				[1] = table7
		--]]
		table7:_resolve(...);
	end
	local function reject(...) -- Line: 282
		--[[
			Upvalues:
				[1] = table7
		--]]
		table7:_reject(...);
	end
	local function onCancel(p98) -- Line: 286
		--[[
			Upvalues:
				[1] = table7
				[2] = table6
		--]]
		if p98 then
			if table7._status == table6.Status.Cancelled then
				p98();
			else
				table7._cancellationHook = p98;
			end
		end
		return table7._status == table6.Status.Cancelled;
	end
	table7._thread = coroutine.create(function() -- Line: 298
		--[[
			Upvalues:
				[1] = runExecutor
				[2] = table7
				[3] = p23
				[4] = resolve
				[5] = reject
				[6] = onCancel
		--]]
		local v41, _, v42 = runExecutor(table7._source, p23, resolve, reject, onCancel);
		if not v41 then
			reject(v42[1]);
		end
	end);
	task.spawn(table7._thread);
	return table7;
end
function table6.new(p25) -- Line: 349
	--[[
		Upvalues:
			[1] = table6
	--]]
	return table6._new(debug.traceback(nil, 2), p25);
end
function table6.__tostring(p26) -- Line: 353
	return string.format("Promise(%s)", p26._status);
end
function table6.defer(p27) -- Line: 375
	--[[
		Upvalues:
			[1] = table6
			[2] = runExecutor
	--]]
	local debug_traceback_ret = debug.traceback(nil, 2);
	local v27 = table6._new(debug_traceback_ret, function(p99, p100, p101) -- Line: 378
		--[[
			Upvalues:
				[1] = table6
				[2] = runExecutor
				[3] = debug_traceback_ret
				[4] = p27
		--]]
		local Connect_ret = nil;
		Connect_ret = table6._timeEvent:Connect(function() -- Line: 380
			--[[
				Upvalues:
					[1] = Connect_ret
					[2] = runExecutor
					[3] = debug_traceback_ret
					[4] = p27
					[5] = p99
					[6] = p100
					[7] = p101
			--]]
			Connect_ret:Disconnect();
			local v53, _, v54 = runExecutor(debug_traceback_ret, p27, p99, p100, p101);
			if not v53 then
				p100(v54[1]);
			end
		end);
	end);
	return v27;
end
table6.async = table6.defer;
function table6.resolve(...) -- Line: 418
	--[[
		Upvalues:
			[1] = pack
			[2] = table6
	--]]
	local u10, u11 = pack(...);
	return table6._new(debug.traceback(nil, 2), function(p102) -- Line: 420
		--[[
			Upvalues:
				[1] = u11
				[2] = u10
		--]]
		p102(unpack(u11, 1, u10));
	end);
end
function table6.reject(...) -- Line: 435
	--[[
		Upvalues:
			[1] = pack
			[2] = table6
	--]]
	local u12, u13 = pack(...);
	return table6._new(debug.traceback(nil, 2), function(_, p103) -- Line: 437
		--[[
			Upvalues:
				[1] = u13
				[2] = u12
		--]]
		p103(unpack(u13, 1, u12));
	end);
end
function table6._try(p28, p29, ...) -- Line: 446
	--[[
		Upvalues:
			[1] = pack
			[2] = table6
	--]]
	local u14, u15 = pack(...);
	return table6._new(p28, function(p104) -- Line: 449
		--[[
			Upvalues:
				[1] = p29
				[2] = u15
				[3] = u14
		--]]
		p104(p29(unpack(u15, 1, u14)));
	end);
end
function table6.try(p30, ...) -- Line: 477
	--[[
		Upvalues:
			[1] = table6
	--]]
	return table6._try(debug.traceback(nil, 2), p30, ...);
end
function table6._all(p31, p32, p33) -- Line: 486
	--[[
		Upvalues:
			[1] = table6
	--]]
	if type(p32) ~= "table" then
		error(string.format("Please pass a list of promises to %s", "Promise.all"), 3);
	end
	for key3, val3 in pairs(p32) do
		if table6.is(val3) then continue end
		error(string.format("Non-promise value passed into %s at index %s", "Promise.all", tostring(key3)), 3);
	end
	if #p32 == 0 or p33 == 0 then
		return table6.resolve({});
	end
	return table6._new(p31, function(p105, p106, p107) -- Line: 504
		--[[
			Upvalues:
				[1] = p33
				[2] = p32
		--]]
		local table8 = {};
		local table9 = {};
		local u26 = 0;
		local u27 = 0;
		local bool1 = false;
		local function cancel() -- Line: 515
			--[[
				Upvalues:
					[1] = table9
			--]]
			for _, val17 in ipairs(table9) do
				val17:cancel();
			end
		end
		local function resolveOne(p130, ...) -- Line: 522
			--[[
				Upvalues:
					[1] = bool1
					[2] = u26
					[3] = p33
					[4] = table8
					[5] = p32
					[6] = p105
					[7] = table9
			--]]
			if bool1 then return end
			u26 = u26 + 1;
			if p33 == nil then
				table8[p130] = ...;
			else
				table8[u26] = ...;
			end
			if u26 >= (p33 or #p32) then
				bool1 = true;
				p105(table8);
				for _, val24 in ipairs(table9) do
					val24:cancel();
				end
			end
		end
		p107(cancel);
		for key9, val9 in ipairs(p32) do
			table9[key9] = val9:andThen(function(...) -- Line: 547
				--[[
					Upvalues:
						[1] = resolveOne
						[2] = key9
				--]]
				resolveOne(key9, ...);
			end, function(...) -- Line: 549
				--[[
					Upvalues:
						[1] = u27
						[2] = p33
						[3] = p32
						[4] = table9
						[5] = bool1
						[6] = p106
				--]]
				u27 = u27 + 1;
				if p33 == nil or #p32 - u27 < p33 then
					for _, val31 in ipairs(table9) do
						val31:cancel();
					end
					bool1 = true;
					p106(...);
				end
			end);
		end
		if bool1 then
			for _, val14 in ipairs(table9) do
				val14:cancel();
			end
		end
	end);
end
function table6.all(p34) -- Line: 591
	--[[
		Upvalues:
			[1] = table6
	--]]
	return table6._all(debug.traceback(nil, 2), p34);
end
function table6.fold(p35, p36, p37) -- Line: 620
	--[[
		Upvalues:
			[1] = table6
	--]]
	assert(type(p35) == "table", "Bad argument #1 to Promise.fold: must be a table");
	local bool2;
	while true do
		if type(p36) == "function" then
			bool2 = true;
		else
			if type(p36) == "table" then
				local metatable3 = getmetatable(p36);
				if metatable3 and type((rawget(metatable3, "__call"))) == "function" then
					bool2 = true;
					break;
				end
			end
			bool2 = false;
		end
		break;
	end
	assert(bool2, "Bad argument #2 to Promise.fold: must be a function");
	local u16 = table6.resolve(p37);
	local v28 = table6.each(p35, function(p108, p109) -- Line: 625
		--[[
			Upvalues:
				[1] = u16
				[2] = p36
		--]]
		u16 = u16:andThen(function(p133) -- Line: 626
			--[[
				Upvalues:
					[1] = p36
					[2] = p108
					[3] = p109
			--]]
			return p36(p133, p108, p109);
		end);
	end);
	return v28:andThen(function() -- Line: 629
		--[[
			Upvalues:
				[1] = u16
		--]]
		return u16;
	end);
end
function table6.some(p38, p39) -- Line: 653
	--[[
		Upvalues:
			[1] = table6
	--]]
	assert(type(p39) == "number", "Bad argument #2 to Promise.some: must be a number");
	return table6._all(debug.traceback(nil, 2), p38, p39);
end
function table6.any(p40) -- Line: 677
	--[[
		Upvalues:
			[1] = table6
	--]]
	return table6._all(debug.traceback(nil, 2), p40, 1):andThen(function(p110) -- Line: 678
		return p110[1];
	end);
end
function table6.allSettled(p41) -- Line: 699
	--[[
		Upvalues:
			[1] = table6
	--]]
	if type(p41) ~= "table" then
		error(string.format("Please pass a list of promises to %s", "Promise.allSettled"), 2);
	end
	for key4, val4 in pairs(p41) do
		if table6.is(val4) then continue end
		error(string.format("Non-promise value passed into %s at index %s", "Promise.allSettled", tostring(key4)), 2);
	end
	if #p41 == 0 then
		return table6.resolve({});
	end
	return table6._new(debug.traceback(nil, 2), function(p111, _, p112) -- Line: 717
		--[[
			Upvalues:
				[1] = p41
		--]]
		local table10 = {};
		local table11 = {};
		local u29 = 0;
		local function resolveOne(p131, ...) -- Line: 727
			--[[
				Upvalues:
					[1] = u29
					[2] = table10
					[3] = p41
					[4] = p111
			--]]
			u29 = u29 + 1;
			table10[p131] = ...;
			if u29 >= #p41 then
				p111(table10);
			end
		end
		p112(function() -- Line: 737
			--[[
				Upvalues:
					[1] = table11
			--]]
			for _, val18 in ipairs(table11) do
				val18:cancel();
			end
		end);
		for key10, val10 in ipairs(p41) do
			table11[key10] = val10:finally(function(...) -- Line: 746
				--[[
					Upvalues:
						[1] = resolveOne
						[2] = key10
				--]]
				resolveOne(key10, ...);
			end);
		end
	end);
end
function table6.race(p42) -- Line: 777
	--[[
		Upvalues:
			[1] = table6
	--]]
	assert(type(p42) == "table", string.format("Please pass a list of promises to %s", "Promise.race"));
	for key5, val5 in pairs(p42) do
		assert(table6.is(val5), string.format("Non-promise value passed into %s at index %s", "Promise.race", tostring(key5)));
	end
	return table6._new(debug.traceback(nil, 2), function(p113, p114, p115) -- Line: 784
		--[[
			Upvalues:
				[1] = p42
		--]]
		local table12 = {};
		local bool3 = false;
		local function cancel() -- Line: 788
			--[[
				Upvalues:
					[1] = table12
			--]]
			for _, val19 in ipairs(table12) do
				val19:cancel();
			end
		end
		local function finalize(p132) -- Line: 794
			--[[
				Upvalues:
					[1] = table12
					[2] = bool3
			--]]
			return function(...) -- Line: 795
				--[[
					Upvalues:
						[1] = table12
						[2] = bool3
						[3] = p132
				--]]
				for _, val27 in ipairs(table12) do
					val27:cancel();
				end
				bool3 = true;
				return p132(...);
			end;
		end
		if p115(function(...) -- Line: 795
			--[[
				Upvalues:
					[1] = table12
					[2] = bool3
					[3] = p114
			--]]
			for _, val22 in ipairs(table12) do
				val22:cancel();
			end
			bool3 = true;
			return p114(...);
		end) then return end
		for key11, val11 in ipairs(p42) do
			local function v50(...) -- Anonymous function at line 795
				--[[
					Upvalues:
						[1] = table12
						[2] = bool3
						[3] = p113
				--]]
				for _, val25 in ipairs(table12) do
					val25:cancel();
				end
				bool3 = true;
				return p113(...);
			end
			local function v51(...) -- Anonymous function at line 795
				--[[
					Upvalues:
						[1] = table12
						[2] = bool3
						[3] = p114
				--]]
				for _, val26 in ipairs(table12) do
					val26:cancel();
				end
				bool3 = true;
				return p114(...);
			end
			table12[key11] = val11:andThen(v50, v51);
		end
		if bool3 then
			for _, val15 in ipairs(table12) do
				val15:cancel();
			end
		end
	end);
end
function table6.each(p43, p44) -- Line: 872
	--[[
		Upvalues:
			[1] = table6
			[2] = table3
	--]]
	assert(type(p43) == "table", string.format("Please pass a list of promises to %s", "Promise.each"));
	local bool4;
	while true do
		if type(p44) == "function" then
			bool4 = true;
		else
			if type(p44) == "table" then
				local metatable4 = getmetatable(p44);
				if metatable4 and type((rawget(metatable4, "__call"))) == "function" then
					bool4 = true;
					break;
				end
			end
			bool4 = false;
		end
		break;
	end
	assert(bool4, string.format("Please pass a handler function to %s!", "Promise.each"));
	return table6._new(debug.traceback(nil, 2), function(p116, p117, p118) -- Line: 876
		--[[
			Upvalues:
				[1] = p43
				[2] = table6
				[3] = table3
				[4] = p44
		--]]
		local table13 = {};
		local table14 = {};
		local bool5 = false;
		local function cancel() -- Line: 882
			--[[
				Upvalues:
					[1] = table14
			--]]
			for _, val20 in ipairs(table14) do
				val20:cancel();
			end
		end
		p118(function() -- Line: 888
			--[[
				Upvalues:
					[1] = bool5
					[2] = table14
			--]]
			bool5 = true;
			for _, val21 in ipairs(table14) do
				val21:cancel();
			end
		end);
		local table15 = {};
		for key12, val12 in ipairs(p43) do
			if table6.is(val12) then
				if val12:getStatus() == table6.Status.Cancelled then
					for _, val28 in ipairs(table14) do
						val28:cancel();
					end
					return p117(table3.new({
						error = "Promise is cancelled",
						kind = table3.Kind.AlreadyCancelled,
						context = string.format("The Promise that was part of the array at index %d passed into Promise.each was already cancelled when Promise.each began.\n\nThat Promise was created at:\n\n%s", key12, val12._source)
					}));
				end
				if val12:getStatus() == table6.Status.Rejected then
					for _, val29 in ipairs(table14) do
						val29:cancel();
					end
					return p117(select(2, val12:await()));
				end
				local andThen_ret = val12:andThen(function(...) -- Line: 921
					return ...;
				end);
				table.insert(table14, andThen_ret);
				table15[key12] = andThen_ret;
				continue;
			end
			table15[key12] = val12;
		end
		for key13, val13 in ipairs(table15) do
			if table6.is(val13) then
				local await_ret1_2, val13 = val13:await();
				if not await_ret1_2 then
					for _, val30 in ipairs(table14) do
						val30:cancel();
					end
					return p117(val13);
				end
			end
			if bool5 then return end
			local v52 = table6.resolve(p44(val13, key13));
			table.insert(table14, v52);
			local await_ret1, await_ret2 = v52:await();
			if not await_ret1 then
				for _, val23 in ipairs(table14) do
					val23:cancel();
				end
				return p117(await_ret2);
			end
			table13[key13] = await_ret2;
		end
		p116(table13);
	end);
end
function table6.is(p45) -- Line: 971
	--[[
		Upvalues:
			[1] = table6
	--]]
	if type(p45) ~= "table" then
		return false;
	end
	local metatable5 = getmetatable(p45);
	if metatable5 == table6 then
		return true;
	end
	if metatable5 == nil then
		local t_andThen = p45.andThen;
		if type(t_andThen) == "function" then
			return true;
		end
		if type(t_andThen) == "table" then
			local metatable7 = getmetatable(t_andThen);
			if metatable7 and type((rawget(metatable7, "__call"))) == "function" then
				return true;
			end
		end
		return false;
	end
	if type(metatable5) == "table" and type((rawget(metatable5, "__index"))) == "table" then
		local rawget_ret = rawget(rawget(metatable5, "__index"), "andThen");
		local bool6;
		while true do
			if type(rawget_ret) == "function" then
				bool6 = true;
			else
				if type(rawget_ret) == "table" then
					local metatable6 = getmetatable(rawget_ret);
					if metatable6 and type((rawget(metatable6, "__call"))) == "function" then
						bool6 = true;
						break;
					end
				end
				bool6 = false;
			end
			break;
		end
		if bool6 then
			return true;
		end
	end
	return false;
end
function table6.promisify(p46) -- Line: 1020
	--[[
		Upvalues:
			[1] = table6
	--]]
	return function(...) -- Line: 1021
		--[[
			Upvalues:
				[1] = table6
				[2] = p46
		--]]
		return table6._try(debug.traceback(nil, 2), p46, ...);
	end;
end
local u4 = nil;
local Connect_ret2 = nil;
function table6.delay(p47) -- Line: 1051
	--[[
		Upvalues:
			[1] = table6
			[2] = Connect_ret2
			[3] = u4
	--]]
	assert(type(p47) == "number", "Bad argument #1 to Promise.delay, must be a number.");
	if p47 < 1 / 60 or p47 == math.huge then
		p47 = 1 / 60;
	end
	return table6._new(debug.traceback(nil, 2), function(p119, _, p120) -- Line: 1059
		--[[
			Upvalues:
				[1] = table6
				[2] = p47
				[3] = Connect_ret2
				[4] = u4
		--]]
		local v44 = table6._getTime();
		local v45 = v44 + p47;
		local table16 = {
			resolve = p119,
			startTime = v44,
			endTime = v45
		};
		if Connect_ret2 == nil then
			u4 = table16;
			Connect_ret2 = table6._timeEvent:Connect(function() -- Line: 1071
				--[[
					Upvalues:
						[1] = table6
						[2] = u4
						[3] = Connect_ret2
				--]]
				local v64 = table6._getTime();
				while u4 ~= nil and u4.endTime < v64 do
					local v65 = u4;
					u4 = v65.next;
					if u4 == nil then
						Connect_ret2:Disconnect();
						Connect_ret2 = nil;
					else
						u4.previous = nil;
					end
					v65.resolve(table6._getTime() - v65.startTime);
				end
			end);
		elseif u4.endTime < v45 then
			local v55 = u4;
			local t_next2 = v55.next;
			while t_next2 ~= nil and t_next2.endTime < v45 do
				v55 = t_next2;
				t_next2 = t_next2.next;
			end
			v55.next = table16;
			table16.previous = v55;
			if t_next2 ~= nil then
				table16.next = t_next2;
				t_next2.previous = table16;
			end
		else
			table16.next = u4;
			u4.previous = table16;
			u4 = table16;
		end
		p120(function() -- Line: 1116
			--[[
				Upvalues:
					[1] = table16
					[2] = u4
					[3] = Connect_ret2
			--]]
			local t_next = table16.next;
			if u4 == table16 then
				if t_next == nil then
					Connect_ret2:Disconnect();
					Connect_ret2 = nil;
				else
					t_next.previous = nil;
				end
				u4 = t_next;
				return;
			end
			local t_previous = table16.previous;
			t_previous.next = t_next;
			if t_next ~= nil then
				t_next.previous = t_previous;
			end
		end);
	end);
end
local function timeout(p48, p49, p50) -- Line: 1180
	--[[
		Upvalues:
			[1] = table6
			[2] = table3
	--]]
	local debug_traceback_ret2 = debug.traceback(nil, 2);
	return table6.race({
		table6.delay(p49):andThen(function() -- Line: 1184
			--[[
				Upvalues:
					[1] = table6
					[2] = p50
					[3] = table3
					[4] = p49
					[5] = debug_traceback_ret2
			--]]
			return table6.reject(p50 == nil and table3.new({
				kind = table3.Kind.TimedOut,
				error = "Timed out",
				context = string.format("Timeout of %d seconds exceeded.\n:timeout() called at:\n\n%s", p49, debug_traceback_ret2)
			}) or p50);
		end),
		p48
	});
end
table6.prototype.timeout = timeout;
local function getStatus(p51) -- Line: 1204
	return p51._status;
end
table6.prototype.getStatus = getStatus;
local function _andThen(p52, p53, p54, p55) -- Line: 1213
	--[[
		Upvalues:
			[1] = table6
			[2] = runExecutor
	--]]
	p52._unhandledRejection = false;
	if p52._status == table6.Status.Cancelled then
		local v34 = table6.new(function() -- Line: 1218
		end);
		v34:cancel();
		return v34;
	end
	return table6._new(p53, function(p121, p122, p123) -- Line: 1225
		--[[
			Upvalues:
				[1] = p54
				[2] = p53
				[3] = runExecutor
				[4] = p55
				[5] = p52
				[6] = table6
		--]]
		local u31 = p121;
		if p54 then
			local u34 = p53;
			local u35 = p54;
			function u31(...) -- Anonymous function at line 180
				--[[
					Upvalues:
						[1] = runExecutor
						[2] = u34
						[3] = u35
						[4] = p121
						[5] = p122
				--]]
				local v57, v58, v59 = runExecutor(u34, u35, ...);
				if v57 then
					p121(unpack(v59, 1, v58));
					return;
				end
				p122(v59[1]);
			end
		end
		local u32 = p122;
		if p55 then
			local u36 = p53;
			local u37 = p55;
			function u32(...) -- Anonymous function at line 180
				--[[
					Upvalues:
						[1] = runExecutor
						[2] = u36
						[3] = u37
						[4] = p121
						[5] = p122
				--]]
				local v60, v61, v62 = runExecutor(u36, u37, ...);
				if v60 then
					p121(unpack(v62, 1, v61));
					return;
				end
				p122(v62[1]);
			end
		end
		if p52._status == table6.Status.Started then
			table.insert(p52._queuedResolve, u31);
			table.insert(p52._queuedReject, u32);
			p123(function() -- Line: 1244
				--[[
					Upvalues:
						[1] = p52
						[2] = table6
						[3] = u31
						[4] = u32
				--]]
				if p52._status == table6.Status.Started then
					table.remove(p52._queuedResolve, table.find(p52._queuedResolve, u31));
					table.remove(p52._queuedReject, table.find(p52._queuedReject, u32));
				end
			end);
		elseif p52._status == table6.Status.Resolved then
			u31(unpack(p52._values, 1, p52._valuesLength));
		elseif p52._status == table6.Status.Rejected then
			u32(unpack(p52._values, 1, p52._valuesLength));
		end
	end, p52);
end
table6.prototype._andThen = _andThen;
local function andThen(p56, p57, p58) -- Line: 1283
	local bool7 = true;
	while true do
		if p57 ~= nil then
			if type(p57) == "function" then
				bool7 = true;
			else
				if type(p57) == "table" then
					local metatable8 = getmetatable(p57);
					if metatable8 and type((rawget(metatable8, "__call"))) == "function" then
						bool7 = true;
						break;
					end
				end
				bool7 = false;
			end
		end
		break;
	end
	assert(bool7, string.format("Please pass a handler function to %s!", "Promise:andThen"));
	local bool8 = true;
	while true do
		if p58 ~= nil then
			if type(p58) == "function" then
				bool8 = true;
			else
				if type(p58) == "table" then
					local metatable9 = getmetatable(p58);
					if metatable9 and type((rawget(metatable9, "__call"))) == "function" then
						bool8 = true;
						break;
					end
				end
				bool8 = false;
			end
		end
		break;
	end
	assert(bool8, string.format("Please pass a handler function to %s!", "Promise:andThen"));
	return p56:_andThen(debug.traceback(nil, 2), p57, p58);
end
table6.prototype.andThen = andThen;
local function catch(p59, p60) -- Line: 1310
	local bool9 = true;
	while true do
		if p60 ~= nil then
			if type(p60) == "function" then
				bool9 = true;
			else
				if type(p60) == "table" then
					local metatable10 = getmetatable(p60);
					if metatable10 and type((rawget(metatable10, "__call"))) == "function" then
						bool9 = true;
						break;
					end
				end
				bool9 = false;
			end
		end
		break;
	end
	assert(bool9, string.format("Please pass a handler function to %s!", "Promise:catch"));
	return p59:_andThen(debug.traceback(nil, 2), nil, p60);
end
table6.prototype.catch = catch;
local function tap(p61, p62) -- Line: 1331
	--[[
		Upvalues:
			[1] = table6
			[2] = pack
	--]]
	local bool10;
	while true do
		if type(p62) == "function" then
			bool10 = true;
		else
			if type(p62) == "table" then
				local metatable11 = getmetatable(p62);
				if metatable11 and type((rawget(metatable11, "__call"))) == "function" then
					bool10 = true;
					break;
				end
			end
			bool10 = false;
		end
		break;
	end
	assert(bool10, string.format("Please pass a handler function to %s!", "Promise:tap"));
	return p61:_andThen(debug.traceback(nil, 2), function(...) -- Line: 1333
		--[[
			Upvalues:
				[1] = p62
				[2] = table6
				[3] = pack
		--]]
		local v46 = p62(...);
		if table6.is(v46) then
			local u38, u39 = pack(...);
			return v46:andThen(function() -- Line: 1338
				--[[
					Upvalues:
						[1] = u39
						[2] = u38
				--]]
				return unpack(u39, 1, u38);
			end);
		end
		return ...;
	end);
end
table6.prototype.tap = tap;
local function andThenCall(p63, p64, ...) -- Line: 1366
	--[[
		Upvalues:
			[1] = pack
	--]]
	local bool11;
	while true do
		if type(p64) == "function" then
			bool11 = true;
		else
			if type(p64) == "table" then
				local metatable12 = getmetatable(p64);
				if metatable12 and type((rawget(metatable12, "__call"))) == "function" then
					bool11 = true;
					break;
				end
			end
			bool11 = false;
		end
		break;
	end
	assert(bool11, string.format("Please pass a handler function to %s!", "Promise:andThenCall"));
	local u17, u18 = pack(...);
	return p63:_andThen(debug.traceback(nil, 2), function() -- Line: 1369
		--[[
			Upvalues:
				[1] = p64
				[2] = u18
				[3] = u17
		--]]
		return p64(unpack(u18, 1, u17));
	end);
end
table6.prototype.andThenCall = andThenCall;
local function andThenReturn(p65, ...) -- Line: 1396
	--[[
		Upvalues:
			[1] = pack
	--]]
	local u19, u20 = pack(...);
	return p65:_andThen(debug.traceback(nil, 2), function() -- Line: 1398
		--[[
			Upvalues:
				[1] = u20
				[2] = u19
		--]]
		return unpack(u20, 1, u19);
	end);
end
table6.prototype.andThenReturn = andThenReturn;
local function cancel(p66) -- Line: 1414
	--[[
		Upvalues:
			[1] = table6
	--]]
	if p66._status ~= table6.Status.Started then return end
	p66._status = table6.Status.Cancelled;
	if p66._cancellationHook then
		p66._cancellationHook();
	end
	coroutine.close(p66._thread);
	if p66._parent then
		p66._parent:_consumerCancelled(p66);
	end
	for v29 in pairs(p66._consumers) do
		v29:cancel();
	end
	p66:_finalize();
end
table6.prototype.cancel = cancel;
local function _consumerCancelled(p67, p68) -- Line: 1442
	--[[
		Upvalues:
			[1] = table6
	--]]
	if p67._status ~= table6.Status.Started then return end
	p67._consumers[p68] = nil;
	if next(p67._consumers) == nil then
		p67:cancel();
	end
end
table6.prototype._consumerCancelled = _consumerCancelled;
local function _finally(p69, p70, p71) -- Line: 1458
	--[[
		Upvalues:
			[1] = table6
	--]]
	p69._unhandledRejection = false;
	local v30 = table6._new(p70, function(p124, p125, p126) -- Line: 1461
		--[[
			Upvalues:
				[1] = p69
				[2] = p71
				[3] = table6
		--]]
		local u33 = nil;
		p126(function() -- Line: 1464
			--[[
				Upvalues:
					[1] = p69
					[2] = u33
			--]]
			p69:_consumerCancelled(p69);
			if u33 then
				u33:cancel();
			end
		end);
		local v47 = p71 and function(...) -- Line: 1477
			--[[
				Upvalues:
					[1] = p71
					[2] = table6
					[3] = u33
					[4] = p124
					[5] = p69
					[6] = p125
			--]]
			local v63 = p71(...);
			if table6.is(v63) then
				u33 = v63;
				local finally_ret = v63:finally(function(p134) -- Line: 1484
					--[[
						Upvalues:
							[1] = table6
							[2] = p124
							[3] = p69
					--]]
					if p134 ~= table6.Status.Rejected then
						p124(p69);
					end
				end);
				finally_ret:catch(function(...) -- Line: 1489
					--[[
						Upvalues:
							[1] = p125
					--]]
					p125(...);
				end);
				return;
			end
			p124(p69);
		end or p124;
		if p69._status == table6.Status.Started then
			table.insert(p69._queuedFinally, v47);
		else
			v47(p69._status);
		end
	end);
	return v30;
end
table6.prototype._finally = _finally;
local function finally(p72, p73) -- Line: 1559
	local bool12 = true;
	while true do
		if p73 ~= nil then
			if type(p73) == "function" then
				bool12 = true;
			else
				if type(p73) == "table" then
					local metatable13 = getmetatable(p73);
					if metatable13 and type((rawget(metatable13, "__call"))) == "function" then
						bool12 = true;
						break;
					end
				end
				bool12 = false;
			end
		end
		break;
	end
	assert(bool12, string.format("Please pass a handler function to %s!", "Promise:finally"));
	return p72:_finally(debug.traceback(nil, 2), p73);
end
table6.prototype.finally = finally;
local function finallyCall(p74, p75, ...) -- Line: 1573
	--[[
		Upvalues:
			[1] = pack
	--]]
	local bool13;
	while true do
		if type(p75) == "function" then
			bool13 = true;
		else
			if type(p75) == "table" then
				local metatable14 = getmetatable(p75);
				if metatable14 and type((rawget(metatable14, "__call"))) == "function" then
					bool13 = true;
					break;
				end
			end
			bool13 = false;
		end
		break;
	end
	assert(bool13, string.format("Please pass a handler function to %s!", "Promise:finallyCall"));
	local u21, u22 = pack(...);
	return p74:_finally(debug.traceback(nil, 2), function() -- Line: 1576
		--[[
			Upvalues:
				[1] = p75
				[2] = u22
				[3] = u21
		--]]
		return p75(unpack(u22, 1, u21));
	end);
end
table6.prototype.finallyCall = finallyCall;
local function finallyReturn(p76, ...) -- Line: 1599
	--[[
		Upvalues:
			[1] = pack
	--]]
	local u23, u24 = pack(...);
	return p76:_finally(debug.traceback(nil, 2), function() -- Line: 1601
		--[[
			Upvalues:
				[1] = u24
				[2] = u23
		--]]
		return unpack(u24, 1, u23);
	end);
end
table6.prototype.finallyReturn = finallyReturn;
local function awaitStatus(p77) -- Line: 1613
	--[[
		Upvalues:
			[1] = table6
	--]]
	p77._unhandledRejection = false;
	if p77._status == table6.Status.Started then
		local coroutine_running_ret = coroutine.running();
		local finally_ret2 = p77:finally(function() -- Line: 1620
			--[[
				Upvalues:
					[1] = coroutine_running_ret
			--]]
			task.spawn(coroutine_running_ret);
		end);
		finally_ret2:catch(function() -- Line: 1626
		end);
		coroutine.yield();
	end
	if p77._status == table6.Status.Resolved then
		return p77._status, unpack(p77._values, 1, p77._valuesLength);
	end
	if p77._status == table6.Status.Rejected then
		return p77._status, unpack(p77._values, 1, p77._valuesLength);
	end
	return p77._status;
end
table6.prototype.awaitStatus = awaitStatus;
local function awaitHelper(p78, ...) -- Line: 1641
	--[[
		Upvalues:
			[1] = table6
	--]]
	return p78 == table6.Status.Resolved, ...;
end
local function await(p79) -- Line: 1666
	--[[
		Upvalues:
			[1] = awaitHelper
	--]]
	return awaitHelper(p79:awaitStatus());
end
table6.prototype.await = await;
local function expectHelper(p80, ...) -- Line: 1670
	--[[
		Upvalues:
			[1] = table6
	--]]
	if p80 ~= table6.Status.Resolved then
		error(... == nil and "Expected Promise rejected with no value." or ..., 3);
	end
	return ...;
end
local function expect(p81) -- Line: 1703
	--[[
		Upvalues:
			[1] = expectHelper
	--]]
	return expectHelper(p81:awaitStatus());
end
table6.prototype.expect = expect;
table6.prototype.awaitValue = table6.prototype.expect;
local function _unwrap(p82) -- Line: 1717
	--[[
		Upvalues:
			[1] = table6
	--]]
	if p82._status == table6.Status.Started then
		error("Promise has not resolved or rejected.", 2);
	end
	local v31 = p82._status == table6.Status.Resolved;
	return v31, unpack(p82._values, 1, p82._valuesLength);
end
table6.prototype._unwrap = _unwrap;
local function _resolve(p83, ...) -- Line: 1727
	--[[
		Upvalues:
			[1] = table6
			[2] = table3
			[3] = pack
	--]]
	if p83._status ~= table6.Status.Started then
		if table6.is((...)) then
			(...):_consumerCancelled(p83);
		end
		return;
	end
	if not table6.is((...)) then
		p83._status = table6.Status.Resolved;
		local v35, v36 = pack(...);
		p83._valuesLength = v35;
		p83._values = v36;
		for _, val7 in ipairs(p83._queuedResolve) do
			coroutine.wrap(val7)(...);
		end
		p83:_finalize();
		return;
	end
	if select("#", ...) > 1 then
		local string_format_ret = string.format("When returning a Promise from andThen, extra arguments are " .. "discarded! See:\n\n%s", p83._source);
		warn(string_format_ret);
	end
	local u25 = ...;
	local andThen_ret2 = u25:andThen(function(...) -- Line: 1748
		--[[
			Upvalues:
				[1] = p83
		--]]
		p83:_resolve(...);
	end, function(...) -- Line: 1750
		--[[
			Upvalues:
				[1] = u25
				[2] = table3
				[3] = p83
		--]]
		local v48 = u25._error and table3.new({
			error = u25._error,
			kind = table3.Kind.ExecutionError,
			context = "[No stack trace available as this Promise originated from an older version of the Promise library (< v2)]"
		}) or u25._values[1];
		if table3.isKind(v48, table3.Kind.ExecutionError) then
			return p83:_reject(v48:extend({
				error = "This Promise was chained to a Promise that errored.",
				trace = "",
				context = string.format("The Promise at:\n\n%s\n...Rejected because it was chained to the following Promise, which encountered an error:\n", p83._source)
			}));
		end
		p83:_reject(...);
	end);
	if andThen_ret2._status == table6.Status.Cancelled then
		p83:cancel();
		return;
	end
	if andThen_ret2._status == table6.Status.Started then
		p83._parent = andThen_ret2;
		andThen_ret2._consumers[p83] = true;
	end
end
table6.prototype._resolve = _resolve;
local function _reject(p84, ...) -- Line: 1798
	--[[
		Upvalues:
			[1] = table6
			[2] = pack
	--]]
	if p84._status ~= table6.Status.Started then return end
	p84._status = table6.Status.Rejected;
	local v32, v33 = pack(...);
	p84._valuesLength = v32;
	p84._values = v33;
	if next(p84._queuedReject) ~= nil then
		for _, val8 in ipairs(p84._queuedReject) do
			coroutine.wrap(val8)(...);
		end
	else
		local tostring_ret = tostring((...));
		local coroutine_wrap_ret = coroutine.wrap(function() -- Line: 1820
			--[[
				Upvalues:
					[1] = table6
					[2] = p84
					[3] = tostring_ret
			--]]
			table6._timeEvent:Wait();
			if not p84._unhandledRejection then return end
			local string_format_ret2 = string.format("Unhandled Promise rejection:\n\n%s\n\n%s", tostring_ret, p84._source);
			for _, val16 in ipairs(table6._unhandledRejectionCallbacks) do
				task.spawn(val16, p84, unpack(p84._values, 1, p84._valuesLength));
			end
			if table6.TEST then return end
			warn(string_format_ret2);
		end);
		coroutine_wrap_ret();
	end
	p84:_finalize();
end
table6.prototype._reject = _reject;
local function _finalize(p85) -- Line: 1852
	--[[
		Upvalues:
			[1] = table6
	--]]
	for _, val6 in ipairs(p85._queuedFinally) do
		coroutine.wrap(val6)(p85._status);
	end
	p85._queuedFinally = nil;
	p85._queuedReject = nil;
	p85._queuedResolve = nil;
	if not table6.TEST then
		p85._parent = nil;
		p85._consumers = nil;
	end
	task.defer(coroutine.close, p85._thread);
end
table6.prototype._finalize = _finalize;
local function now(p86, p87) -- Line: 1889
	--[[
		Upvalues:
			[1] = table6
			[2] = table3
	--]]
	local debug_traceback_ret3 = debug.traceback(nil, 2);
	if p86._status == table6.Status.Resolved then
		return p86:_andThen(debug_traceback_ret3, function(...) -- Line: 1892
			return ...;
		end);
	end
	return table6.reject(p87 == nil and table3.new({
		kind = table3.Kind.NotResolvedInTime,
		error = "This Promise was not resolved in time for :now()",
		context = ":now() was called at:\n\n" .. debug_traceback_ret3
	}) or p87);
end
table6.prototype.now = now;
function table6.retry(p88, p89, ...) -- Line: 1934
	--[[
		Upvalues:
			[1] = table6
	--]]
	local bool14;
	while true do
		if type(p88) == "function" then
			bool14 = true;
		else
			if type(p88) == "table" then
				local metatable15 = getmetatable(p88);
				if metatable15 and type((rawget(metatable15, "__call"))) == "function" then
					bool14 = true;
					break;
				end
			end
			bool14 = false;
		end
		break;
	end
	assert(bool14, "Parameter #1 to Promise.retry must be a function");
	assert(type(p89) == "number", "Parameter #2 to Promise.retry must be a number");
	local table17 = {...};
	local select_ret = select("#", ...);
	return table6.resolve(p88(...)):catch(function(...) -- Line: 1940
		--[[
			Upvalues:
				[1] = p89
				[2] = table6
				[3] = p88
				[4] = table17
				[5] = select_ret
		--]]
		if p89 > 0 then
			return table6.retry(p88, p89 - 1, unpack(table17, 1, select_ret));
		end
		return table6.reject(...);
	end);
end
function table6.retryWithDelay(p90, p91, p92, ...) -- Line: 1962
	--[[
		Upvalues:
			[1] = table6
	--]]
	local bool15;
	while true do
		if type(p90) == "function" then
			bool15 = true;
		else
			if type(p90) == "table" then
				local metatable16 = getmetatable(p90);
				if metatable16 and type((rawget(metatable16, "__call"))) == "function" then
					bool15 = true;
					break;
				end
			end
			bool15 = false;
		end
		break;
	end
	assert(bool15, "Parameter #1 to Promise.retry must be a function");
	assert(type(p91) == "number", "Parameter #2 (times) to Promise.retry must be a number");
	assert(type(p92) == "number", "Parameter #3 (seconds) to Promise.retry must be a number");
	local table18 = {...};
	local select_ret2 = select("#", ...);
	return table6.resolve(p90(...)):catch(function(...) -- Line: 1969
		--[[
			Upvalues:
				[1] = p91
				[2] = table6
				[3] = p92
				[4] = p90
				[5] = table18
				[6] = select_ret2
		--]]
		if p91 > 0 then
			table6.delay(p92):await();
			return table6.retryWithDelay(p90, p91 - 1, p92, unpack(table18, 1, select_ret2));
		end
		return table6.reject(...);
	end);
end
function table6.fromEvent(p93, p94) -- Line: 2004
	--[[
		Upvalues:
			[1] = table6
	--]]
	p94 = p94 or function() -- Line: 2005
		return true;
	end;
	return table6._new(debug.traceback(nil, 2), function(p127, _, p128) -- Line: 2009
		--[[
			Upvalues:
				[1] = p93
				[2] = p94
		--]]
		local Connect_ret3 = nil;
		local bool16 = false;
		local function disconnect() -- Line: 2013
			--[[
				Upvalues:
					[1] = Connect_ret3
			--]]
			Connect_ret3:Disconnect();
			Connect_ret3 = nil;
		end
		Connect_ret3 = p93:Connect(function(...) -- Line: 2022
			--[[
				Upvalues:
					[1] = p94
					[2] = p127
					[3] = Connect_ret3
					[4] = bool16
			--]]
			local v56 = p94(...);
			if v56 == true then
				p127(...);
				if Connect_ret3 then
					Connect_ret3:Disconnect();
					Connect_ret3 = nil;
					return;
				end
				bool16 = true;
				return;
			end
			if type(v56) ~= "boolean" then
				error("Promise.fromEvent predicate should always return a boolean");
			end
		end);
		if bool16 and Connect_ret3 then
			return disconnect();
		end
		p128(disconnect);
	end);
end
function table6.onUnhandledRejection(p95) -- Line: 2056
	--[[
		Upvalues:
			[1] = table6
	--]]
	table.insert(table6._unhandledRejectionCallbacks, p95);
	return function() -- Line: 2059
		--[[
			Upvalues:
				[1] = table6
				[2] = p95
		--]]
		local table_find_ret = table.find(table6._unhandledRejectionCallbacks, p95);
		if table_find_ret then
			table.remove(table6._unhandledRejectionCallbacks, table_find_ret);
		end
	end;
end
return table6;

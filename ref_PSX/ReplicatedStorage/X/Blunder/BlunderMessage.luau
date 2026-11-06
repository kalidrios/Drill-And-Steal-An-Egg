-- https://github.com/kalidrios

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local HttpService = game:GetService("HttpService");
local X = ReplicatedStorage:WaitForChild("X");
local m_math_helper = require(X:WaitForChild("Util").math_helper);
local _ = require(script.Parent.Config);
local table1 = {
	Source = {
		SCRIPT_CONTEXT = 0,
		LOG_SERVICE = 1,
		OTHER = 2,
		NETWORK = 3
	},
	SourceInv = {}
};
for key1, val1 in pairs(table1.Source) do
	table1.SourceInv[val1] = key1;
end
function table1.new(p1, p2, p3, p4, p5, p6, p7, p8) -- Line: 54
	--[[
		Upvalues:
			[1] = table1
	--]]
	if typeof(p1) ~= "number" or not table1.SourceInv[p1] then
		return nil;
	end
	if typeof(p2) ~= "string" then
		return nil;
	end
	if typeof(p3) ~= "EnumItem" or p3.EnumType ~= Enum.MessageType then
		return nil;
	end
	if typeof(p4) ~= "boolean" then
		return nil;
	end
	if p5 ~= nil and typeof(p5) ~= "string" then
		return nil;
	end
	if p6 ~= nil and typeof(p6) ~= "string" then
		return nil;
	end
	if p7 ~= nil then
		if typeof(p7) ~= "Instance" or not p7:IsA("Player") then
			return nil;
		end
		p2 = p2:gsub(p7.Name, "<Player>");
		if p5 then
			p5 = p5:gsub(p7.Name, "<Player>");
		end
		if p6 then
			p6 = p6:gsub(p7.Name, "<Player>");
		end
	end
	if p8 ~= nil and (typeof(p8) ~= "string" or #p8 ~= 32 or not p8:match("^[0-9a-f]+$")) then
		return nil;
	end
	local ServerTimeNow = workspace:GetServerTimeNow();
	local table2 = {
		source = p1,
		message = p2,
		messageType = p3,
		isServer = p4,
		stackTrace = p5,
		sourceScript = p6,
		id = p8,
		occurrences = 1,
		firstOccurrence = ServerTimeNow,
		lastOccurrence = ServerTimeNow
	};
	local new_mt = setmetatable(table2, {__index = table1});
	return new_mt;
end
function table1.key(p9) -- Line: 114
	--[[
		Upvalues:
			[1] = HttpService
	--]]
	return HttpService:JSONEncode({
		p9.source,
		p9.message,
		p9.messageType.Value,
		p9.isServer,
		p9.stackTrace,
		p9.sourceScript
	});
end
function table1.append(p10, p11) -- Line: 126
	p10.occurrences = p10.occurrences + p11.occurrences;
	p10.firstOccurrence = math.min(p10.firstOccurrence, p11.firstOccurrence);
	p10.lastOccurrence = math.max(p10.lastOccurrence, p11.lastOccurrence);
end
function table1.encode(p12) -- Line: 132
	local table3 = {
		p12.source,
		p12.message,
		p12.messageType,
		p12.stackTrace,
		p12.sourceScript,
		p12.occurrences,
		p12.firstOccurrence,
		p12.lastOccurrence,
		p12.id,
		0
	};
	return table3;
end
function table1.encodeForAPI(p13) -- Line: 147
	--[[
		Upvalues:
			[1] = HttpService
	--]]
	local table4 = {
		source = p13.source,
		message = HttpService:UrlEncode(p13.message),
		type = p13.messageType.Value,
		is_server = p13.isServer
	};
	local v1 = p13.stackTrace;
	if v1 ~= nil then
		v1 = HttpService:UrlEncode(v1);
	end
	table4.stack_trace = v1;
	local v2 = p13.sourceScript;
	if v2 ~= nil then
		v2 = HttpService:UrlEncode(v2);
	end
	table4.source_script = v2;
	table4.occurrences = p13.occurrences;
	table4.first_occurrence = p13.firstOccurrence;
	table4.last_occurrence = p13.lastOccurrence;
	table4.id = p13.id;
	return table4;
end
function table1.decode(p14, p15) -- Line: 174
	--[[
		Upvalues:
			[1] = table1
			[2] = m_math_helper
	--]]
	if typeof(p14) ~= "table" then
		return nil;
	end
	if #p14 ~= 10 then
		return nil;
	end
	if typeof(p15) ~= "boolean" then
		return nil;
	end
	local v3 = p14[1];
	if typeof(v3) ~= "number" or not table1.SourceInv[v3] then
		return nil;
	end
	local v4 = p14[2];
	if typeof(v4) ~= "string" then
		return nil;
	end
	local v5 = p14[3];
	if typeof(v5) ~= "EnumItem" or v5.EnumType ~= Enum.MessageType then
		return nil;
	end
	local v6 = p14[4];
	if v6 ~= nil and typeof(v6) ~= "string" then
		return nil;
	end
	local v7 = p14[5];
	if v7 ~= nil and typeof(v7) ~= "string" then
		return nil;
	end
	local v8 = p14[6];
	if typeof(v8) ~= "number" or not m_math_helper.isfinite(v8) or math.floor(v8) ~= v8 or v8 < 1 then
		return nil;
	end
	local v9 = p14[7];
	if typeof(v9) ~= "number" or not m_math_helper.isfinite(v9) then
		return nil;
	end
	local v10 = p14[8];
	if typeof(v10) ~= "number" or not m_math_helper.isfinite(v10) then
		return nil;
	end
	local v11 = p14[9];
	if v11 ~= nil and (typeof(v11) ~= "string" or #v11 ~= 32 or not v11:match("^[0-9a-f]+$")) then
		return nil;
	end
	if p14[10] ~= 0 then
		return nil;
	end
	local table5 = {
		source = v3,
		message = v4,
		messageType = v5,
		isServer = p15,
		stackTrace = v6,
		sourceScript = v7,
		occurrences = v8,
		firstOccurrence = v9,
		lastOccurrence = v10,
		id = v11
	};
	local new_mt2 = setmetatable(table5, {__index = table1});
	return new_mt2;
end
function table1.isWanted(p16, p17) -- Line: 252
	if p17.AllowedTypes and not p17.AllowedTypes[p16.messageType] then
		return false;
	end
	if p17.MessageBlacklist then
		for _, val2 in ipairs(p17.MessageBlacklist) do
			if not p16.message:find(val2) then continue end
			return false;
		end
	end
	if p17.MessageWhitelist then
		for _, val3 in ipairs(p17.MessageWhitelist) do
			if not p16.message:find(val3) then continue end
			return true;
		end
		return false;
	end
	return true;
end
table.freeze(table1);
return table1;

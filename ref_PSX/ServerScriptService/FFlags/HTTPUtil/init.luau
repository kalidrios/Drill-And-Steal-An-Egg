-- !strict

-- | load library | --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Library = ReplicatedStorage:WaitForChild("Library")
local ServerLibrary = ServerScriptService:WaitForChild("Library")
local Modules = Library:WaitForChild("Modules")
local Types = Library:WaitForChild("Types")

-- | shared modules | --
local Functions = require(Library.Functions)

local RunService = game:GetService("RunService");
local HttpService = game:GetService("HttpService");
local _ = require(script:WaitForChild("Encryption"));
local m_Authentication = require(script:WaitForChild("Authentication"));
local table1 = {
	LOCAL_TEST = false,
	LOCAL_TEST_URL = "http://127.0.0.1:3000/"
};
if table1.LOCAL_TEST and not RunService:IsStudio() then
	table1.LOCAL_TEST = false;
end
function decodeJson(p1) -- Line: 41
	--[[
		Upvalues:
			[1] = HttpService
	--]]
	if p1 then
		local success, pcall_ret2 = pcall(function() -- Line: 43
			--[[
				Upvalues:
					[1] = HttpService
					[2] = p1
			--]]
			return HttpService:JSONDecode(p1);
		end);
		if success then
			if typeof(pcall_ret2) == "table" then
				return true, pcall_ret2;
			end
			return false, nil, "Invalid JSON Body";
		end
		return false, nil, "Malformed JSON Body";
	end
	return false, nil, "No JSON Body";
end
function decodeResponse(p2) -- Line: 71
	local function formatResponse(p7) -- Line: 73
		--[[
			Upvalues:
				[1] = p2
		--]]
		if p7 then
			return string.format("%d %s: %s", p2.StatusCode, p2.StatusMessage, p7);
		end
		return string.format("%d %s", p2.StatusCode, p2.StatusMessage);
	end
	if p2.StatusCode == 405 then
		local decodeJson_ret1_2, decodeJson_ret2_2, decodeJson_ret3_2 = decodeJson(p2.Body);
		if decodeJson_ret1_2 then
			if decodeJson_ret2_2.err ~= nil then
				if typeof(decodeJson_ret2_2.err) == "string" then
					return false, nil, decodeJson_ret2_2.err;
				end
				return false, nil, formatResponse("Malformed JSON Body Error");
			end
			return false, nil, formatResponse("No JSON Body Error");
		end
		return false, nil, formatResponse(decodeJson_ret3_2);
	end
	if p2.StatusCode == 400 then
		return false, nil, formatResponse();
	end
	if p2.StatusCode == 401 then
		return false, nil, formatResponse();
	end
	if p2.StatusCode == 200 then
		local decodeJson_ret1, decodeJson_ret2, decodeJson_ret3 = decodeJson(p2.Body);
		if decodeJson_ret1 then
			return true, decodeJson_ret2;
		end
		return false, nil, formatResponse(decodeJson_ret3);
	end
	return false, nil, formatResponse();
end
local table2 = {
	GET = true,
	POST = true
};
function table1.HttpRequest(p3, p4, p5, p6) -- Line: 125
	--[[
		Upvalues:
			[1] = table2
			[2] = m_Authentication
			[3] = HttpService
			[4] = table1
			[5] = m_Library
	--]]
	assert(table2[p3]);
	local table3 = {};
	if p5 then
		for key1, val1 in pairs(p5) do
			assert(typeof(key1) == "string");
			assert(typeof(val1) == "string" and true or typeof(val1) == "number" and true or typeof(val1) == "boolean");
			table3[key1] = tostring(val1);
		end
	end
	local v2 = p6 and table.clone(p6) or {};
	local AuthParameters = m_Authentication.getAuthParameters();
	local table_clone_ret = table.clone(AuthParameters);
	if p3 == "GET" or p5 and next(p5) then
		for key2, val2 in pairs(table3) do
			table_clone_ret[key2] = val2;
		end
		for key3, val3 in pairs(AuthParameters) do
			table3[key3] = tostring(val3);
		end
	end
	local str1 = nil;
	local JSONEncode_ret = nil;
	if p3 == "POST" then
		for key4, val4 in pairs(v2) do
			assert(typeof(key4) == "string");
			if typeof(val4) ~= "string" and typeof(val4) ~= "number" and typeof(val4) ~= "boolean" then continue end
			table_clone_ret[key4] = tostring(val4);
		end
		for key5, val5 in pairs(AuthParameters) do
			v2[key5] = tostring(val5);
		end
		str1 = "application/json";
		JSONEncode_ret = HttpService:JSONEncode(v2);
	end
	local v3 = table1.LOCAL_TEST and table1.LOCAL_TEST_URL or m_Authentication.API_URL;
	local v4 = v3 .. p4 .. Functions.BuildQueryString(table3);
	local table4 = {
		Url = v4,
		Method = p3,
		Headers = {Authorization = m_Authentication.EncodeAuthenticationString(table_clone_ret)}
	};
	if str1 then
		table4.Headers["Content-Type"] = str1;
	end
	if JSONEncode_ret then
		table4.Body = JSONEncode_ret;
	end
	local success2, pcall_ret2_2 = pcall(function() -- Line: 205
		--[[
			Upvalues:
				[1] = HttpService
				[2] = table4
		--]]
		return HttpService:RequestAsync(table4);
	end);
	local v5;
	if success2 then
		v5 = pcall_ret2_2;
	else
		local table5 = {
			Success = false,
			StatusCode = 400,
			StatusMessage = tostring(pcall_ret2_2),
			Headers = {}
		};
		v5 = table5;
	end
	local table6 = {};
	if v5.Body then
		local JSONDecode_ret = HttpService:JSONDecode(table6);
		local _ = typeof(JSONDecode_ret) == "table";
	end
	return decodeResponse(v5);
end
return table1;

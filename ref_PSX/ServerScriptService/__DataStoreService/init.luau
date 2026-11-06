--[[

	MongoStore is an alternative to DataStoreService
	which uses the Rongo module as an interface to
	MongoDB.
	
	MongoStore includes quite a few of the functions
	which DataStoreService has and it aims to make the
	transition from DataStoreService as smooth as possible
	
	You will need a MongoDB account to use MongoStore
	
	Version: 1.0.0
	License: MIT License
	Contributors:
		- Starnamics (Creator)

--]]

MONGOSTORE_CLUSTER = "Cluster0"
IS_USING_RONGO = true

local DSS = game:GetService("DataStoreService")

local warn = function(...) return warn("[MongoStore]",...) end
local print = function(...) return print("[MongoStore]",...) end

local Rongo = require(script:WaitForChild("Rongo"))
local Client = nil	
local isOffline = false

local MongoStore = {}

local MongoDataStore = {}
MongoDataStore.__index = MongoDataStore

local function to_base64(data)
	local b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
	return ((data:gsub('.', function(x) 
		local r,b='',x:byte()
		for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
		return r;
	end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
		if (#x < 6) then return '' end
		local c=0
		for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
		return b:sub(c+1,c+1)
	end)..({ '', '==', '=' })[#data%3+1])
end

function from_base64(data)
	local b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
	data = string.gsub(data, '[^'..b..'=]', '')
	return (data:gsub('.', function(x)
		if (x == '=') then return '' end
		local r,f='',(b:find(x)-1)
		for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
		return r;
	end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
		if (#x ~= 8) then return '' end
		local c=0
		for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
		return string.char(c)
	end))
end

local function encodeProfile(profile)
	local jsonData = game:GetService("HttpService"):JSONEncode(profile)
	local base = to_base64(jsonData)
	base = string.reverse(base)
	
	return base
end

local function decodeProfile(base)
	base = string.reverse(base)
	
	local jsonData = from_base64(base)
	local profile = game:GetService("HttpService"):JSONDecode(jsonData)
	
	return profile
end

function TransformKey(Name,Scope,Key)
	local NewKey = Name
	if Scope then
		NewKey = Name.."'"..Scope
	end
	NewKey = NewKey.."'"..Key
	return NewKey
end

local function checkIsOffline()
	local success, message = pcall(function()
		DSS.GetDataStore("__DS").SetAsync("__DS", os.time());
	end)

	local noInternetAccess = success == false and string.find(message, "ConnectFail", 1, true) ~= nil
	if noInternetAccess then
		warn("No internet access - check your network connection")
	end

	if (success == false) then
		warn("Offline!")
		isOffline = true
	end
end

function MongoStore:Authorize(API_ID:string,API_KEY:string,Cluster: string?): boolean?
	if Cluster then MONGOSTORE_CLUSTER = Cluster end
	
	checkIsOffline()
	Client = Rongo.new(API_ID,API_KEY)
	return true
end

function MongoStore:GetDataStore(Name: string,Scope: string)
	if not Client then repeat task.wait() until Client end
	local DataStore = {}
	setmetatable(DataStore,MongoDataStore)
	DataStore.Name = Name
	DataStore.Scope = Scope
	
	if not isOffline then
		DataStore.DSS = DSS:GetDataStore(Name,Scope)
	end
	return DataStore
end

function MongoDataStore:GetAsync(Key: string): {[string]: any?}?
	local Data = ((not isOffline) and self.DSS:GetAsync(Key) or nil)
	
	if not Data then
		local Collection = Client:GetCluster(MONGOSTORE_CLUSTER):GetDatabase("Datastore"):GetCollection("PlayerData")
		Key = TransformKey(self.Name,self.Scope,Key)
		local Document = Collection:FindOne({["key"] = Key})
		if Document then Data = Document["data"] else Data = nil end
	end
	
	local realData = Data ~= nil and decodeProfile(Data) or nil
	return realData
end

function MongoDataStore:RemoveAsync(Key: string): boolean
	if not isOffline then
		self.DSS:RemoveAsync(Key)
	end
	
	local Collection = Client:GetCluster(MONGOSTORE_CLUSTER):GetDatabase("Datastore"):GetCollection("PlayerData")
	Key = TransformKey(self.Name,self.Scope,Key)
	local Result = Collection:DeleteOne({["key"] = Key})
	if not Result or Result == 0 then return false end
	return true
end

function MongoDataStore:SetAsync(Key: string,Value: any): boolean
	Value = encodeProfile(Value)
	
	if not isOffline then
		self.DSS:SetAsync(Key,Value)
	end
	
	spawn(function()
		local Collection = Client:GetCluster(MONGOSTORE_CLUSTER):GetDatabase("Datastore"):GetCollection("PlayerData")
		Key = TransformKey(self.Name,self.Scope,Key)
		local Result = Collection:ReplaceOne({["key"] = Key},{["key"] = Key,["data"] = Value},true)
		if not Result or Result.modifiedCount == 0 then return false end
	end)
	return Value
end

function MongoDataStore:UpdateAsync(Key: string,Value: any): boolean
	local OldData = self:GetAsync(Key)
	local NewData = Value(OldData)
	self:SetAsync(Key,NewData)
	return NewData
end

local mockDB = require(script:WaitForChild("MockDataStoreService"))
function MongoStore:GetOrderedDataStore(Name,Scope)
	if not isOffline then
		return game:GetService("DataStoreService"):GetOrderedDataStore(Name,Scope)
	end
	
	return mockDB:GetOrderedDataStore(Name,Scope)
end

if not IS_USING_RONGO then
	checkIsOffline()
	
	if not isOffline then
		return game:GetService("DataStoreService")
	end
	
	return mockDB
end

MongoStore:Authorize(" "," ")
return MongoStore

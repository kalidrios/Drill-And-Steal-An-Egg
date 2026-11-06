-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")

local function WaitForDescendant(p1, p2, p3) --[[ WaitForDescendant | Line: 127 | Upvalues: RunService (copy) ]]
	local v1 = p1:FindFirstChild(p2, true)

	if v1 ~= nil then
		return v1
	end

	local v2 = os.clock()
	local v4 = p1.DescendantAdded:Connect(function(p1) --[[ Line: 132 | Upvalues: p2 (copy), v1 (ref) ]]
		if p1.Name ~= p2 then
			return
		end

		v1 = p1
	end)

	while v1 == nil do
		if v2 ~= nil and (os.clock() - v2 > 1 and (RunService:IsServer() == true or game:IsLoaded() == true)) then
			warn("[" .. script.Name .. "]: Missing " .. p3 .. " \"" .. p2 .. "\" in " .. p1:GetFullName() .. "; Please check setup documentation")
			v2 = nil
		end

		task.wait()
	end

	v4:Disconnect()

	return v1
end

local ReplicaRemoteEvents

if RunService:IsServer() == true then
	ReplicaRemoteEvents = Instance.new("Folder")
	ReplicaRemoteEvents.Name = "ReplicaRemoteEvents"
	ReplicaRemoteEvents.Parent = game:GetService("ReplicatedStorage")
else
	ReplicaRemoteEvents = WaitForDescendant(game:GetService("ReplicatedStorage"), "ReplicaRemoteEvents", "folder")
end

local t = {
	GetShared = function(p1, p2) --[[ GetShared | Line: 163 | Upvalues: WaitForDescendant (copy) ]]
		return WaitForDescendant(game:GetService("ReplicatedStorage"), p2, "module")
	end,
	GetModule = function(p1, p2) --[[ GetModule | Line: 167 | Upvalues: WaitForDescendant (copy) ]]
		return WaitForDescendant(game:GetService("ServerScriptService"), p2, "module")
	end,
	SetupRemoteEvent = function(p1) --[[ SetupRemoteEvent | Line: 170 | Upvalues: RunService (copy), ReplicaRemoteEvents (ref), WaitForDescendant (copy) ]]
		if RunService:IsServer() == true then
			local v1 = Instance.new("RemoteEvent")

			v1.Name = p1
			v1.Parent = ReplicaRemoteEvents

			return v1
		end

		return WaitForDescendant(ReplicaRemoteEvents, p1, "remote event")
	end,
	Shared = {}
}
local v1 = require(t.GetShared("Madwork", "MadworkScriptSignal"))

t.NewScriptSignal = v1.NewScriptSignal
t.NewArrayScriptConnection = v1.NewArrayScriptConnection

local t2 = {
	InitialDataReceived = false,
	NewReplicaSignal = t.NewScriptSignal(),
	InitialDataReceivedSignal = t.NewScriptSignal(),
	_replicas = {},
	_class_listeners = {},
	_child_listeners = {}
}
local v2 = require(t.GetShared("Madwork", "MadworkMaid"))
local v3 = nil
local _replicas = t2._replicas
local NewReplicaSignal = t2.NewReplicaSignal
local _class_listeners = t2._class_listeners
local _child_listeners = t2._child_listeners
local v4 = t.SetupRemoteEvent("Replica_ReplicaRequestData")
local v5 = t.SetupRemoteEvent("Replica_ReplicaSetValue")
local v6 = t.SetupRemoteEvent("Replica_ReplicaSetValues")
local v7 = t.SetupRemoteEvent("Replica_ReplicaArrayInsert")
local v8 = t.SetupRemoteEvent("Replica_ReplicaArraySet")
local v9 = t.SetupRemoteEvent("Replica_ReplicaArrayRemove")
local v10 = t.SetupRemoteEvent("Replica_ReplicaWrite")
local v11 = t.SetupRemoteEvent("Replica_ReplicaSignal")
local v12 = t.SetupRemoteEvent("Replica_ReplicaSetParent")
local v13 = t.SetupRemoteEvent("Replica_ReplicaCreate")
local v14 = t.SetupRemoteEvent("Replica_ReplicaDestroy")
local v15 = false
local t3 = {}
local v16 = false

local function v17(p1, p2, p3) --[[ GetWriteLibFunctionsRecursive | Line: 300 | Upvalues: v17 (copy) ]]
	for k, v in pairs(p2) do
		if type(v) == "table" then
			v17(p1, v, p3 .. k .. ".")

			continue
		end

		if type(v) == "function" then
			table.insert(p1, { p3 .. k, v })

			continue
		end

		error("[ReplicaController]: Invalid write function value \"" .. tostring(v) .. "\" (" .. typeof(v) .. "); name_stack = \"" .. p3 .. "\"")
	end
end

local function LoadWriteLib(p1) --[[ LoadWriteLib | Line: 312 | Upvalues: t3 (copy), v17 (copy) ]]
	local v1 = t3[p1]

	if v1 ~= nil then
		return v1
	end

	local list = {}

	v17(list, require(p1), "")
	table.sort(list, function(p1, p2) --[[ Line: 323 ]]
		return p1[1] < p2[1]
	end)

	local t = {}
	local t2 = {}

	for i, v in ipairs(list) do
		t[i] = v[2]
		t2[v[1]] = i
	end

	local t4 = { t, t2 }

	t3[p1] = t4

	return t4
end

local function StringPathToArray(p1) --[[ StringPathToArray | Line: 342 ]]
	local t = {}

	if p1 ~= "" then
		for v1 in string.gmatch(p1, "[^%.]+") do
			table.insert(t, v1)
		end
	end

	return t
end

local function v18(p1, p2) --[[ DestroyReplicaAndDescendantsRecursive | Line: 352 | Upvalues: v18 (copy), _replicas (copy), _child_listeners (copy) ]]
	for i, v in ipairs(p1.Children) do
		v18(v, true)
	end

	local Id = p1.Id

	_replicas[Id] = nil
	p1._maid:Cleanup()

	if p2 == true or p1.Parent == nil then
		_child_listeners[Id] = nil

		return
	end

	local Children = p1.Parent.Children

	table.remove(Children, table.find(Children, p1))
	_child_listeners[Id] = nil
end

local function CreateTableListenerPathIndex(p1, p2, p3) --[[ CreateTableListenerPathIndex | Line: 374 ]]
	local _table_listeners = p1._table_listeners

	for i = 1, #p2 do
		local v1 = _table_listeners[1][p2[i]]

		if v1 == nil then
			local t = {
				{}
			}

			_table_listeners[1][p2[i]] = t
			v1 = t
		end

		_table_listeners = v1
	end

	local v2 = _table_listeners[p3]

	if v2 == nil then
		v2 = {}
		_table_listeners[p3] = v2
	end

	return v2
end

local function CleanTableListenerTable(p1) --[[ CleanTableListenerTable | Line: 395 ]]
	local v1 = p1[1]
	local v2 = p1[2]
	local v3, v4 = v1, { v1 }

	for i = 1, #v2 do
		v3 = v3[1][v2[i]]
		table.insert(v4, v3)
	end

	for j = #v4, 2, -1 do
		local v5 = v4[j]

		if next(v5[1]) ~= nil then
			break
		end

		for k = 2, 6 do
			if v5[k] ~= nil and #v5[k] > 0 then
				return
			end
		end

		v4[j - 1][1][v2[j - 1]] = nil
	end
end

local function CreateReplicaBranch(p1, p2) --[[ CreateReplicaBranch | Line: 420 | Upvalues: _replicas (copy), LoadWriteLib (copy), v2 (copy), v3 (ref) ]]
	local list = {}

	for k, v in pairs(p1) do
		v[6] = tonumber(k)
		table.insert(list, v)
	end

	table.sort(list, function(p1, p2) --[[ Line: 428 ]]
		return p1[6] < p2[6]
	end)

	local tbl = {}
	local v22 = if p2 then p2 else {}

	for i, v in ipairs(list) do
		local v32, v4, v5
		local v6 = v[6]
		local v7 = v[4]
		local v8 = false

		if v7 == 0 then
			v32 = nil
		else
			v32 = _replicas[v7]

			if v32 == nil then
				v8 = true
			end
		end

		if v[5] == nil then
			v4 = nil
			v5 = nil
		else
			local v9 = LoadWriteLib(v[5])

			v4 = v9[1]
			v5 = v9[2]
		end

		local t = {
			Data = v[3],
			Id = v6,
			Class = v[1],
			Tags = v[2],
			Parent = v32,
			Children = {},
			_write_lib = v4,
			_write_lib_dictionary = v5,
			_table_listeners = {
				{}
			},
			_function_listeners = {},
			_raw_listeners = {},
			_signal_listeners = {},
			_maid = v2.NewMaid()
		}

		setmetatable(t, v3)

		if v32 == nil then
			if v8 == true then
				local v11 = tbl[v7]

				if v11 == nil then
					v11 = {}
					tbl[v7] = v11
				end

				table.insert(v11, t)
			end
		else
			table.insert(v32.Children, t)
		end

		_replicas[v6] = t
		table.insert(v22, t)

		local v12 = tbl[v6]

		if v12 ~= nil then
			tbl[v6] = nil

			for i2, v9 in ipairs(v12) do
				v9.Parent = t
				table.insert(t.Children, v9)
			end
		end
	end

	if next(tbl) ~= nil then
		local v13 = "[ReplicaService]: BRANCH REPLICATION ERROR - Missing parents: "

		for k, v in pairs(tbl) do
			local v14 = v13 .. "[" .. tostring(k) .. "]: {"

			for i, v6 in ipairs(v) do
				v14 = v14 .. (if i == 1 then "" else ", ") .. v6:Identify()
			end

			v13 = v14 .. "}; "
		end

		error(v13)
	end

	return v22
end

local function ReplicaSetValue(p1, p2, p3)
	local v1 = _replicas[p1]
	if not v1 then return end
	local Data = v1.Data
	local _table_listeners = v1._table_listeners

	for i = 1, #p2 - 1 do
		Data = Data[p2[i]]

		if _table_listeners ~= nil then
			_table_listeners = _table_listeners[1][p2[i]]
		end
	end

	local v2 = p2[#p2]
	local v3 = Data[v2]

	Data[v2] = p3

	if v3 ~= p3 and _table_listeners ~= nil then
		if v3 == nil and _table_listeners[3] ~= nil then
			for i, v in ipairs(_table_listeners[3]) do
				v(p3, v2)
			end
		end

		local v4 = _table_listeners[1][p2[#p2]]

		if v4 ~= nil and v4[2] ~= nil then
			for i, v in ipairs(v4[2]) do
				v(p3, v3)
			end
		end
	end

	for i, v in ipairs(v1._raw_listeners) do
		v("SetValue", p2, p3)
	end
end

local function ReplicaSetValues(p1, p2, p3)
	local v1 = _replicas[p1]
	if not v1 then return end
	local Data = v1.Data
	local _table_listeners = v1._table_listeners

	for i = 1, #p2 do
		Data = Data[p2[i]]

		if _table_listeners ~= nil then
			_table_listeners = _table_listeners[1][p2[i]]
		end
	end

	for k, v in pairs(p3) do
		local v2 = Data[k]

		Data[k] = v

		if v2 ~= v and _table_listeners ~= nil then
			if v2 == nil and _table_listeners[3] ~= nil then
				for i, v3 in ipairs(_table_listeners[3]) do
					v3(v, k)
				end
			end

			local v3 = _table_listeners[1][k]

			if v3 ~= nil and v3[2] ~= nil then
				for i, v4 in ipairs(v3[2]) do
					v4(v, v2)
				end
			end
		end
	end

	for i, v in ipairs(v1._raw_listeners) do
		v("SetValues", p2, p3)
	end
end

local function ReplicaArrayInsert(p1, p2, p3)
	local v1 = _replicas[p1]
	if not v1 then return end
	local Data = v1.Data
	local _table_listeners = v1._table_listeners

	for i = 1, #p2 do
		Data = Data[p2[i]]

		if _table_listeners ~= nil then
			_table_listeners = _table_listeners[1][p2[i]]
		end
	end

	table.insert(Data, p3)

	local v2 = #Data

	if _table_listeners ~= nil and _table_listeners[4] ~= nil then
		for i, v in ipairs(_table_listeners[4]) do
			v(v2, p3)
		end
	end

	for i, v in ipairs(v1._raw_listeners) do
		v("ArrayInsert", p2, p3, v2)
	end

	return v2
end

local function ReplicaArraySet(p1, p2, p3, p4)
	local v1 = _replicas[p1]
	if not v1 then return end
	local Data = v1.Data
	local _table_listeners = v1._table_listeners

	for i = 1, #p2 do
		Data = Data[p2[i]]

		if _table_listeners ~= nil then
			_table_listeners = _table_listeners[1][p2[i]]
		end
	end

	Data[p3] = p4

	if _table_listeners ~= nil and _table_listeners[5] ~= nil then
		for i, v in ipairs(_table_listeners[5]) do
			v(p3, p4)
		end
	end

	for i, v in ipairs(v1._raw_listeners) do
		v("ArraySet", p2, p3, p4)
	end
end

local function ReplicaArrayRemove(p1, p2, p3)
	local v1 = _replicas[p1]
	if not v1 then return end
	local Data = v1.Data
	local _table_listeners = v1._table_listeners

	for i = 1, #p2 do
		Data = Data[p2[i]]

		if _table_listeners ~= nil then
			_table_listeners = _table_listeners[1][p2[i]]
		end
	end

	local v2 = table.remove(Data, p3)

	if _table_listeners ~= nil and _table_listeners[6] ~= nil then
		for i, v in ipairs(_table_listeners[6]) do
			v(p3, v2)
		end
	end

	for i, v in ipairs(v1._raw_listeners) do
		v("ArrayRemove", p2, p3, v2)
	end

	return v2
end

v3 = {}
v3.__index = v3
function v3.ListenToChange(p1, p2, p3) --[[ ListenToChange | Line: 686 | Upvalues: StringPathToArray (copy), CreateTableListenerPathIndex (copy), t (ref), CleanTableListenerTable (copy) ]]
	if type(p3) ~= "function" then
		error("[ReplicaController]: Only a function can be set as listener in Replica:ListenToChange()")
	end

	local v1 = type(p2) == "string" and StringPathToArray(p2) or p2

	if not (#v1 < 1) then
		local v2

		v2 = CreateTableListenerPathIndex(p1, v1, 2)
		table.insert(v2, p3)

		return t.NewArrayScriptConnection(v2, p3, CleanTableListenerTable, { p1._table_listeners, v1 })
	end

	error("[ReplicaController]: Passed empty path - a value key must be specified")
end
function v3.ListenToNewKey(p1, p2, p3) --[[ ListenToNewKey | Line: 702 | Upvalues: StringPathToArray (copy), CreateTableListenerPathIndex (copy), t (ref), CleanTableListenerTable (copy) ]]
	if type(p3) ~= "function" then
		error("[ReplicaController]: Only a function can be set as listener in Replica:ListenToNewKey()")
	end

	local v1 = type(p2) == "string" and StringPathToArray(p2) or p2
	local v2 = CreateTableListenerPathIndex(p1, v1, 3)

	table.insert(v2, p3)

	if #v1 == 0 then
		return t.NewArrayScriptConnection(v2, p3)
	end

	return t.NewArrayScriptConnection(v2, p3, CleanTableListenerTable, { p1._table_listeners, v1 })
end
function v3.ListenToArrayInsert(p1, p2, p3) --[[ ListenToArrayInsert | Line: 719 | Upvalues: StringPathToArray (copy), CreateTableListenerPathIndex (copy), t (ref), CleanTableListenerTable (copy) ]]
	if type(p3) ~= "function" then
		error("[ReplicaController]: Only a function can be set as listener in Replica:ListenToArrayInsert()")
	end

	local v1 = type(p2) == "string" and StringPathToArray(p2) or p2
	local v2 = CreateTableListenerPathIndex(p1, v1, 4)

	table.insert(v2, p3)

	if #v1 == 0 then
		return t.NewArrayScriptConnection(v2, p3)
	end

	return t.NewArrayScriptConnection(v2, p3, CleanTableListenerTable, { p1._table_listeners, v1 })
end
function v3.ListenToArraySet(p1, p2, p3) --[[ ListenToArraySet | Line: 736 | Upvalues: StringPathToArray (copy), CreateTableListenerPathIndex (copy), t (ref), CleanTableListenerTable (copy) ]]
	if type(p3) ~= "function" then
		error("[ReplicaController]: Only a function can be set as listener in Replica:ListenToArraySet()")
	end

	local v1 = type(p2) == "string" and StringPathToArray(p2) or p2
	local v2 = CreateTableListenerPathIndex(p1, v1, 5)

	table.insert(v2, p3)

	if #v1 == 0 then
		return t.NewArrayScriptConnection(v2, p3)
	end

	return t.NewArrayScriptConnection(v2, p3, CleanTableListenerTable, { p1._table_listeners, v1 })
end
function v3.ListenToArrayRemove(p1, p2, p3) --[[ ListenToArrayRemove | Line: 753 | Upvalues: StringPathToArray (copy), CreateTableListenerPathIndex (copy), t (ref), CleanTableListenerTable (copy) ]]
	if type(p3) ~= "function" then
		error("[ReplicaController]: Only a function can be set as listener in Replica:ListenToArrayRemove()")
	end

	local v1 = type(p2) == "string" and StringPathToArray(p2) or p2
	local v2 = CreateTableListenerPathIndex(p1, v1, 6)

	table.insert(v2, p3)

	if #v1 == 0 then
		return t.NewArrayScriptConnection(v2, p3)
	end

	return t.NewArrayScriptConnection(v2, p3, CleanTableListenerTable, { p1._table_listeners, v1 })
end
function v3.ListenToWrite(p1, p2, p3) --[[ ListenToWrite | Line: 770 | Upvalues: t (ref) ]]
	if type(p3) ~= "function" then
		error("[ReplicaController]: Only a function can be set as listener in Replica:ListenToWrite()")
	end

	if p1._write_lib == nil then
		error("[ReplicaController]: _write_lib was not declared for this replica")
	end

	local v1 = p1._write_lib_dictionary[p2]

	if v1 == nil then
		error("[ReplicaController]: Write function \"" .. p2 .. "\" not declared inside _write_lib of this replica")
	end

	local v2 = p1._function_listeners[v1]

	if v2 == nil then
		v2 = {}
		p1._function_listeners[v1] = v2
	end

	table.insert(v2, p3)

	return t.NewArrayScriptConnection(v2, p3)
end
function v3.ListenToRaw(p1, p2) --[[ ListenToRaw | Line: 794 | Upvalues: t (ref) ]]
	local _raw_listeners = p1._raw_listeners

	table.insert(_raw_listeners, p2)

	return t.NewArrayScriptConnection(_raw_listeners, p2)
end
function v3.ConnectOnClientEvent(p1, p2) --[[ ConnectOnClientEvent | Line: 801 | Upvalues: t (ref) ]]
	if type(p2) == "function" then
		local v1

		v1 = p1._signal_listeners
		table.insert(v1, p2)

		return t.NewArrayScriptConnection(p1._signal_listeners, p2)
	end

	error("[ReplicaController]: Only functions can be passed to Replica:ConnectOnClientEvent()")
end
function v3.FireServer(p1, ...) --[[ FireServer | Line: 809 | Upvalues: v11 (copy) ]]
	v11:FireServer(p1.Id, ...)
end
function v3.ListenToChildAdded(p1, p2) --[[ ListenToChildAdded | Line: 814 | Upvalues: _replicas (copy), _child_listeners (copy), t (ref) ]]
	if type(p2) ~= "function" then
		error("[ReplicaController]: Only a function can be set as listener")
	end

	if _replicas[p1.Id] == nil then
		return
	end

	local v1 = _child_listeners[p1.Id]

	if v1 == nil then
		v1 = {}
		_child_listeners[p1.Id] = v1
	end

	table.insert(v1, p2)

	return t.NewArrayScriptConnection(v1, p2)
end
function v3.FindFirstChildOfClass(p1, p2) --[[ FindFirstChildOfClass | Line: 832 ]]
	for i, v in ipairs(p1.Children) do
		if v.Class == p2 then
			return v
		end
	end

	return nil
end
function v3.Identify(p1) --[[ Identify | Line: 842 ]]
	local v1 = ""

	for k, v in pairs(p1.Tags) do
		v1 = v1 .. "" .. tostring(k) .. "=" .. tostring(v)
	end

	return "[Id:" .. tostring(p1.Id) .. ";Class:" .. p1.Class .. ";Tags:{" .. v1 .. "}]"
end
function v3.IsActive(p1) --[[ IsActive | Line: 853 | Upvalues: _replicas (copy) ]]
	return _replicas[p1.Id] ~= nil
end
function v3.AddCleanupTask(p1, p2) --[[ AddCleanupTask | Line: 857 ]]
	return p1._maid:AddCleanupTask(p2)
end
function v3.RemoveCleanupTask(p1, p2) --[[ RemoveCleanupTask | Line: 861 ]]
	p1._maid:RemoveCleanupTask(p2)
end
function v3.SetValue(p1, p2, p3) --[[ SetValue | Line: 867 | Upvalues: v16 (ref), StringPathToArray (copy), ReplicaSetValue (copy) ]]
	if v16 == false then
		error("[ReplicaController]: Replica setters can only be called inside write functions")
	end

	ReplicaSetValue(p1.Id, type(p2) == "string" and StringPathToArray(p2) or p2, p3)
end
function v3.SetValues(p1, p2, p3) --[[ SetValues | Line: 875 | Upvalues: v16 (ref), StringPathToArray (copy), ReplicaSetValues (copy) ]]
	if v16 == false then
		error("[ReplicaController]: Replica setters can only be called inside write functions")
	end

	ReplicaSetValues(p1.Id, type(p2) == "string" and StringPathToArray(p2) or p2, p3)
end
function v3.ArrayInsert(p1, p2, p3) --[[ ArrayInsert | Line: 883 | Upvalues: v16 (ref), StringPathToArray (copy), ReplicaArrayInsert (copy) ]]
	if v16 == false then
		error("[ReplicaController]: Replica setters can only be called inside write functions")
	end

	return ReplicaArrayInsert(p1.Id, type(p2) == "string" and StringPathToArray(p2) or p2, p3)
end
function v3.ArraySet(p1, p2, p3, p4) --[[ ArraySet | Line: 891 | Upvalues: v16 (ref), StringPathToArray (copy), ReplicaArraySet (copy) ]]
	if v16 == false then
		error("[ReplicaController]: Replica setters can only be called inside write functions")
	end

	ReplicaArraySet(p1.Id, type(p2) == "string" and StringPathToArray(p2) or p2, p3, p4)
end
function v3.ArrayRemove(p1, p2, p3) --[[ ArrayRemove | Line: 899 | Upvalues: v16 (ref), StringPathToArray (copy), ReplicaArrayRemove (copy) ]]
	if v16 == false then
		error("[ReplicaController]: Replica setters can only be called inside write functions")
	end

	return ReplicaArrayRemove(p1.Id, type(p2) == "string" and StringPathToArray(p2) or p2, p3)
end
function v3.Write(p1, p2, ...) --[[ Write | Line: 907 | Upvalues: v16 (ref) ]]
	if v16 == false then
		error("[ReplicaController]: Replica setters can only be called inside write functions")
	end

	local v1 = p1._write_lib_dictionary[p2]
	local v2 = table.pack(p1._write_lib[v1](p1, ...))
	local v3 = p1._function_listeners[v1]

	if v3 ~= nil then
		for i, v in ipairs(v3) do
			v(...)
		end
	end

	return table.unpack(v2)
end
function t2.RequestData() --[[ RequestData | Line: 925 | Upvalues: v15 (ref), v4 (copy), t2 (copy) ]]
	if v15 ~= true then
		v15 = true
		task.spawn(function() --[[ Line: 930 | Upvalues: v4 (ref), t2 (ref) ]]
			while game:IsLoaded() == false do
				task.wait()
			end

			v4:FireServer()

			while task.wait(10) and t2.InitialDataReceived ~= true do
				v4:FireServer()
			end
		end)
	end
end
function t2.ReplicaOfClassCreated(p1, p2) --[[ ReplicaOfClassCreated | Line: 944 | Upvalues: _class_listeners (copy), t (ref) ]]
	if type(p1) ~= "string" then
		error("[ReplicaController]: replica_class must be a string")
	end

	if type(p2) ~= "function" then
		error("[ReplicaController]: Only a function can be set as listener in ReplicaController.ReplicaOfClassCreated()")
	end

	local v1 = _class_listeners[p1]

	if v1 == nil then
		v1 = t.NewScriptSignal()
		_class_listeners[p1] = v1
	end

	return v1:Connect(p2, function() --[[ Line: 957 | Upvalues: v1 (ref), _class_listeners (ref), p1 (copy) ]]
		if v1:GetListenerCount() ~= 0 or _class_listeners[p1] ~= v1 then
			return
		end

		_class_listeners[p1] = nil
	end)
end
function t2.GetReplicaById(p1) --[[ GetReplicaById | Line: 965 | Upvalues: _replicas (copy) ]]
	return _replicas[p1]
end
v4.OnClientEvent:Connect(function() --[[ Line: 972 | Upvalues: t2 (copy) ]]
	t2.InitialDataReceived = true
	print("[ReplicaController]: Initial data received")
	t2.InitialDataReceivedSignal:Fire()
end)
v5.OnClientEvent:Connect(ReplicaSetValue)
v6.OnClientEvent:Connect(ReplicaSetValues)
v7.OnClientEvent:Connect(ReplicaArrayInsert)
v8.OnClientEvent:Connect(ReplicaArraySet)
v9.OnClientEvent:Connect(ReplicaArrayRemove)
v10.OnClientEvent:Connect(function(p1, p2, ...) --[[ Line: 989 | Upvalues: _replicas (copy), v16 (ref) ]]
	local v1 = _replicas[p1]

	v16 = true
	v1._write_lib[p2](v1, ...)
	v16 = false

	local v2 = v1._function_listeners[p2]

	if v2 == nil then
		return
	end

	for i, v in ipairs(v2) do
		v(...)
	end
end)
v11.OnClientEvent:Connect(function(p1, ...) --[[ Line: 1005 | Upvalues: _replicas (copy) ]]
	for i, v in ipairs(_replicas[p1]._signal_listeners) do
		v(...)
	end
end)
v12.OnClientEvent:Connect(function(p1, p2) --[[ Line: 1015 | Upvalues: _replicas (copy), _child_listeners (copy) ]]
	local v1 = _replicas[p1]
	local Children = v1.Parent.Children
	local v2 = _replicas[p2]

	table.remove(Children, table.find(Children, v1))
	table.insert(v2.Children, v1)
	v1.Parent = v2

	local v3 = _child_listeners[p2]

	if v3 == nil then
		return
	end

	for i = 1, #v3 do
		v3[i](v1)
	end
end)
v13.OnClientEvent:Connect(function(p1, p2) --[[ Line: 1032 | Upvalues: CreateReplicaBranch (copy), _child_listeners (copy), NewReplicaSignal (copy), _class_listeners (copy) ]]
	local list = {}

	if type(p1) == "table" then
		table.sort(p1, function(p1, p2) --[[ Line: 1046 ]]
			return p1[1] < p2[1]
		end)

		for i, v in ipairs(p1) do
			CreateReplicaBranch(v[2], list)
		end
	elseif p2[1] == nil then
		CreateReplicaBranch(p2, list)
	else
		CreateReplicaBranch({
			[tostring(p1)] = p2
		}, list)
	end

	table.sort(list, function(p1, p2) --[[ Line: 1058 ]]
		return p1.Id < p2.Id
	end)

	for i, v in ipairs(list) do
		local v1 = v.Parent

		if v1 ~= nil then
			local v2 = _child_listeners[v1.Id]

			if v2 ~= nil then
				for i2 = 1, #v2 do
					v2[i2](v)
				end
			end
		end
	end

	for i, v in ipairs(list) do
		NewReplicaSignal:Fire(v)

		local v3 = _class_listeners[v.Class]

		if v3 ~= nil then
			v3:Fire(v)
		end
	end
end)
v14.OnClientEvent:Connect(function(p1) --[[ Line: 1084 | Upvalues: _replicas (copy), v18 (copy) ]]
	v18(_replicas[p1])
end)

return t2
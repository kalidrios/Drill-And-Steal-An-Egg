-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local t = {}
local v1 = nil

local function AcquireRunnerThreadAndCallEventHandler(p1, ...) --[[ AcquireRunnerThreadAndCallEventHandler | Line: 41 | Upvalues: v1 (ref) ]]
	local v12 = v1

	v1 = nil
	p1(...)
	v1 = v12
end

local function RunEventHandlerInFreeThread(...) --[[ RunEventHandlerInFreeThread | Line: 49 | Upvalues: AcquireRunnerThreadAndCallEventHandler (copy) ]]
	AcquireRunnerThreadAndCallEventHandler(...)

	while true do
		AcquireRunnerThreadAndCallEventHandler(coroutine.yield())
	end
end

local function CleanupTask(p1, ...) --[[ CleanupTask | Line: 56 ]]
	if type(p1) == "function" then
		p1(...)

		return
	end

	if typeof(p1) == "RBXScriptConnection" then
		p1:Disconnect()

		return
	end

	if typeof(p1) == "Instance" then
		p1:Destroy()

		return
	end

	if type(p1) ~= "table" then
		return
	end

	if type(p1.Destroy) == "function" then
		p1:Destroy()

		return
	end

	if type(p1.Disconnect) ~= "function" then
		return
	end

	p1:Disconnect()
end

local function PerformCleanupTask(...) --[[ PerformCleanupTask | Line: 72 | Upvalues: v1 (ref), RunEventHandlerInFreeThread (copy), CleanupTask (copy) ]]
	if v1 then
		task.spawn(v1, CleanupTask, ...)

		return
	end

	v1 = coroutine.create(RunEventHandlerInFreeThread)
	task.spawn(v1, CleanupTask, ...)
end

local t2 = {}

t2.__index = t2
function t2.AddCleanupTask(p1, p2) --[[ AddCleanupTask | Line: 89 | Upvalues: PerformCleanupTask (copy) ]]
	if p1._is_cleaned == true then
		PerformCleanupTask(p2)

		return function() --[[ Line: 92 ]] end
	end

	if type(p2) == "function" or (typeof(p2) == "RBXScriptConnection" or typeof(p2) == "Instance") then
		table.insert(p1._cleanup_tasks, p2)
	elseif type(p2) == "table" then
		if type(p2.Destroy) == "function" or type(p2.Disconnect) == "function" then
			table.insert(p1._cleanup_tasks, p2)
		else
			error("[MadworkMaid]: Received object table as cleanup task, but couldn\'t detect a :Destroy() method")
		end
	else
		error("[MadworkMaid]: Cleanup task of type \"" .. typeof(p2) .. "\" not supported")
	end

	return function(...) --[[ Line: 110 | Upvalues: p1 (copy), p2 (copy), PerformCleanupTask (ref) ]]
		p1:RemoveCleanupTask(p2)
		PerformCleanupTask(p2, ...)
	end
end
function t2.RemoveCleanupTask(p1, p2) --[[ RemoveCleanupTask | Line: 116 ]]
	local _cleanup_tasks = p1._cleanup_tasks
	local v1 = table.find(_cleanup_tasks, p2)

	if v1 == nil then
		return
	end

	table.remove(_cleanup_tasks, v1)
end
function t2.CleanupOfOne(p1, p2, ...) --[[ CleanupOfOne | Line: 124 | Upvalues: PerformCleanupTask (copy) ]]
	p1:RemoveCleanupTask(p2)
	PerformCleanupTask(p2, ...)
end
function t2.Cleanup(p1, ...) --[[ Cleanup | Line: 129 | Upvalues: PerformCleanupTask (copy) ]]
	for i, v in ipairs(p1._cleanup_tasks) do
		PerformCleanupTask(v, ...)
	end

	p1._cleanup_tasks = {}
	p1._is_cleaned = true
end
function t.NewMaid() --[[ NewMaid | Line: 139 | Upvalues: t2 (copy) ]]
	local t = {
		_is_cleaned = false,
		_cleanup_tasks = {}
	}

	setmetatable(t, t2)

	return t
end
t.Cleanup = PerformCleanupTask

return t
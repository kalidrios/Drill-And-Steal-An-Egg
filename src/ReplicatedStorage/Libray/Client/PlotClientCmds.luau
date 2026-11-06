--!strict
--[[
	PlotClientCmds.luau
	Módulo cliente que gerencia o estado local dos plots,
	sincronização de donos e fornece dados dos plots para outros módulos.
]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

local PlotClientCmds = {}
local Network: any = nil
local Library: any = nil

local ownersBySlot: { [number]: number } = {}
local mySlot: number? = nil

local onLocalPlotUpdatedBindable = Instance.new("BindableEvent")
local onAnyPlotUpdatedBindable = Instance.new("BindableEvent")

PlotClientCmds.OnLocalPlotUpdated = onLocalPlotUpdatedBindable.Event
PlotClientCmds.OnAnyPlotUpdated = onAnyPlotUpdatedBindable.Event

function PlotClientCmds.GetPlotsFolder(): Folder?
	local map = Workspace:FindFirstChild("Map")
	if map then
		local lobby = map:FindFirstChild("Lobby")
		if lobby then
			local plots = lobby:FindFirstChild("Plots")
			if plots and plots:IsA("Folder") then
				return plots
			end
		end
	end
	local direct = Workspace:FindFirstChild("Plots")
	return direct and direct:IsA("Folder") and direct or nil
end

function PlotClientCmds.GetState(): { [number]: number }
	local copy = {}
	for k, v in pairs(ownersBySlot) do
		copy[k] = v
	end
	return copy
end

function PlotClientCmds.GetSlotOwner(slot: number): number?
	return ownersBySlot[slot]
end

function PlotClientCmds.GetMySlot(): number?
	if mySlot then return mySlot end
	local attr = LocalPlayer:GetAttribute("PlotId")
	if typeof(attr) == "number" then
		mySlot = attr
		return mySlot
	end
	return nil
end

function PlotClientCmds.GetPlotData(player: Player?)
	local targetPlayer = player or LocalPlayer
	local targetUserId = targetPlayer.UserId
	
	local targetSlot: number? = nil
	if targetPlayer == LocalPlayer and mySlot then
		targetSlot = mySlot
	else
		for slot, uid in pairs(ownersBySlot) do
			if uid == targetUserId then
				targetSlot = slot
				break
			end
		end
	end
	
	if not targetSlot then
		local attr = targetPlayer:GetAttribute("PlotId")
		if typeof(attr) == "number" then
			targetSlot = attr
		end
	end
	
	if not targetSlot then return nil end
	
	local folder = PlotClientCmds.GetPlotsFolder()
	if not folder then return nil end
	
	local plotModel = folder:FindFirstChild(tostring(targetSlot))
	if not plotModel then return nil end
	
	local Center = plotModel:FindFirstChild("Center")
	local plotSign = plotModel:FindFirstChild("PlotSign")
	local spawnPart = plotModel:FindFirstChild("Spawn") or plotModel:FindFirstChild("SpawnPoint")
	
	return {
		Slot = targetSlot,
		PlotFolder = plotModel,
		Center = Center,
		PlotSign = plotSign,
		SpawnPart = spawnPart,
	}
end

function PlotClientCmds.RequestTeleportToBase()
	if Network then
		Network.Fire("Plots_RequestTeleport")
	end
end

local function applySlotUpdate(slot: number, userId: number?)
	local prevOwner = ownersBySlot[slot]
	if userId then
		ownersBySlot[slot] = userId
	else
		ownersBySlot[slot] = nil
	end
	
	if userId == LocalPlayer.UserId then
		mySlot = slot
		onLocalPlotUpdatedBindable:Fire(slot)
	elseif prevOwner == LocalPlayer.UserId and userId ~= LocalPlayer.UserId then
		mySlot = nil
		onLocalPlotUpdatedBindable:Fire(nil)
	end
	
	onAnyPlotUpdatedBindable:Fire(slot, userId)
end

function PlotClientCmds.Init(frameworkLibrary: any)
	Library = frameworkLibrary
	Network = Library.Network
	
	if Network then
		Network.Fired("Plots_StateUpdate"):Connect(function(payload: any)
			if payload and typeof(payload.Slot) == "number" then
				applySlotUpdate(payload.Slot, payload.UserId)
			end
		end)
		
		task.spawn(function()
			local ok, result = pcall(function()
				return Network.Invoke("Plots_RequestState")
			end)
			if ok and result and typeof(result.OwnersBySlot) == "table" then
				for slotStr, uid in pairs(result.OwnersBySlot) do
					local sNum = tonumber(slotStr)
					if sNum then
						applySlotUpdate(sNum, uid)
					end
				end
			end
		end)
	end
	
	LocalPlayer:GetAttributeChangedSignal("PlotId"):Connect(function()
		local val = LocalPlayer:GetAttribute("PlotId")
		if typeof(val) == "number" then
			mySlot = val
			onLocalPlotUpdatedBindable:Fire(val)
		end
	end)
end

return PlotClientCmds


--------|     Setting     |--------

--------|     Library     |--------
local _L = require(game.ReplicatedStorage:WaitForChild("Library")) _L.Load()

--------|    Reference    |--------
local TradingTemplate = {
	sender = nil,
	target = nil,
	targetReady = false,
	senderReady = false,
	targetConfirmed = false,
	senderConfirmed = false,
	confirmStage = false,
	processing = false,
	counter = 0,
	lastCounter = 0,
	senderItems = {
		pets = {},
		diamonds = 0,
	},
	targetItems = {
		pets = {},	
		diamonds = 0,
	},
	messages = {},
	confirmTick = 0
}

--------|    Variables    |--------
local trades = {}
local plrcache = {}

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function _G.GetTradeByPlayer(player)
	for k, v in pairs(trades) do
		if v.sender == player or v.target == player then
			return v, k
		end
	end
	
	return nil, nil
end

function getTrade(id)
	return trades[id]
end

function getProfile(player)
	return plrcache[tostring(player.UserId)]
end

function canPlayerTrade(player)
	local profile = getProfile(player)
	if not profile then
		return nil
	end
	
	local joinTime = profile.Join
	if joinTime then
		return (joinTime-os.time()>=60) or false
	end
	
	return nil
end

local Network = {}
function Network.PartnersFire(id, remote, ...)
	local args = {...}
	
	local trade = getTrade(id)
	if not trade or not checkTrade(id) then
		return nil
	end
	
	local function fire(player)
		task.spawn(function() pcall(function()
				_L.Network.Fire(remote, player,unpack(args))
			end)
		end)
	end
	
	fire(trade.sender) fire(trade.target)
end

function Network.PartnersInvoke(id, remote, ...)
	local args = {...}

	local trade = getTrade(id)
	if not trade or not checkTrade(id) then
		return nil
	end

	local function fire(player)
		task.spawn(function() pcall(function()
				local s, r = _L.Network.Invoke(remote, player,unpack(args))
				return s,r
			end)
		end)
	end

	local s1,r1,s2,r2 = fire(trade.sender), fire(trade.target)
	return {s1,r1},{s2,r2}
end

function UpdateTrade(id)
	local trade = getTrade(id)
	if not trade then
		return nil
	end

	coroutine.wrap(function()
		Network.PartnersFire(id,"Update Trade",id,trade)
	end)()
	return true
end

function figureOutTradeRole(player)
	local trade, id = _G.GetTradeByPlayer(player)
	if not trade then
		return nil
	end
	
	if trade.sender == player then
		return "sender"
	elseif trade.target == player then
		return "target"
	end
	
	return nil
end

function playerLoaded(player, init)
	if not (player and _L.Saving.Get(player) and player:FindFirstChild("__LOADED")) or (_G.GetTradeByPlayer(player) and init) then
		return false
	end
	
	return true
end

function getPartners(id)
	local trade = getTrade(id)
	if not trade then
		return nil
	end
	
	return trade.sender, trade.target
end

function stopTrade(id, ...)
	Network.PartnersFire(id, "Trade Processed", ...)
	trades[id] = nil
end

function checkTrade(id)
	local sender, target = getPartners(id)
	local loadedSender, loadedTarget = playerLoaded(sender), playerLoaded(target)
	if not (loadedSender and loadedTarget and getTrade(id)) then
		return nil
	end
	
	return true
end

function initTrade(player, otherPlayer)
	local playerTrade, otherPlayerTrade =  _G.GetTradeByPlayer(player), _G.GetTradeByPlayer(otherPlayer)
	if playerTrade or otherPlayerTrade then
		 return nil
	end
	
	
end

function init(player)
	plrcache[tostring(player.UserId)] = {
		Join = os.time(),
		Invites = {},
		LastInvite = {},
	}
end

_L.Signal.Fired("Player Added"):Connect(init)
_L.Players.PlayerRemoving:Connect(function(player)
	plrcache[tostring(player.UserId)] = nil
end)
--[[ Last synced 9/21/2025 04:54                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         Às vezes é mais fácil desistir mesmo ]]    --[[                                                                                                  ]]--
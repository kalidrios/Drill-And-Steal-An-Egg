--[[

     THIS WAS ORIGINALLY SCRIPTED BY Velvet GAMES .gg/velte     join: .gg/imperiox

--]]

--------|     Setting     |--------

--------|     Library     |--------
local _L = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"))
while (not _L.Loaded) do  game:GetService("RunService").Heartbeat:Wait()  end

--------|    Reference    |--------

--------|    Variables    |--------
local trades = {}

--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------

local function GetByPlyr(plyr)
	for i,v in pairs(trades) do
		if v.sender == plyr or v.target == plyr then
			return v, tostring(i)
		end
	end
	return
end

_G.GetByPlyr = GetByPlyr

_G.Friends = {}
local function iterPageItems(pages)
	return coroutine.wrap(function()
		local pagenum = 1
		while true do
			for _, item in ipairs(pages:GetCurrentPage()) do
				coroutine.yield(item, pagenum)
			end
			if pages.IsFinished then
				break
			end
			pages:AdvanceTkalidriostPageAsync()
			pagenum = pagenum + 1
		end
	end)
end

_L.Signal.Fired("Player Added"):connect(function(plyr)
	pcall(function()
		local friendPages = game.Players:GetFriendsAsync(plyr.UserId)
		local usernames = {}

		for item, pageNo in iterPageItems(friendPages) do
			table.insert(usernames, item.Id)
		end
		if plyr and plyr.Parent then
			_G.Friends[tostring(plyr.UserId)] = usernames
		end
	end)
end)

game.Players.PlayerRemoving:Connect(function(plyr)
	_G.Friends[tostring(plyr.UserId)] = nil
end)

local WL = {}
for i,v in pairs({ "id", "uid", "idt", "s", "nk", "l", "snk", "hc", "powers", "merchData", "g", "r", "dm", "sh" }) do
	WL[v] = true
end

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
		pawTokens = 0,
	},
	targetItems = {
		pets = {},	
		diamonds = 0,
		pawTokens = 0,
	},
	messages = {},
	confirmTick = 0
}

local Plyr_Info = {}

_L.Signal.Fired("Player Added"):connect(function(plyr)
	Plyr_Info[tostring(plyr.UserId)] = {os.clock(), false}
end)

game.Players.PlayerRemoving:Connect(function(plyr)
	Plyr_Info[tostring(plyr.UserId)] = nil
end)

local function GetTradingTimer(plyr)
	if Plyr_Info[tostring(plyr.UserId)] then
		local f = os.clock() - Plyr_Info[tostring(plyr.UserId)][1]		
		if f >= 60 then
			return true
		else
			return false
			--return tostring(plyr.Name).. " needs wait 20-40 seconds before trading."
		end
	end

	return "No info for other player"
end


------------------------------------------------------------------------------------------------
--[[ PROCESSING NOTES ]]--
-- TODO: WHEN SETTING BOTH READY SET OSACCEPTED AS OS.CLOCK AND START HB LOOP
-- TODO: REMEMBER TO CHECK IF THIS IS *NIL* SPECIFICALLY. FALSE MEANS ITS PROCESSING BUT NOTHING HAS GONE WRONG
------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------
--[[ NOTES ]]--
-- TODO: MAKE SURE PLAYER SENDS THE CORRECT IDS
------------------------------------------------------------------------------------------------

-- target, sender, targetReady, senderReady
local function CheckBro(plyr, IsInit)
	if ((not (plyr and plyr:IsDescendantOf(game.Players) and game.Players:FindFirstChild(plyr.Name))) or (not _L.Saving.Get(plyr))) or not plyr:FindFirstChild("__LOADED") then
		return false
	end
	if GetByPlyr(plyr) and IsInit then
		return false
	end
	return true
end

local function Get(id)
	return trades[tostring(id)]
end

local function GetPartners(id)
	local f = Get(id)
	if not f then
		return
	end
	return f.sender, f.target
end


local function CheckTrade(id)
	local PartnerA, partnerB = GetPartners(id)
	if not (CheckBro(PartnerA) and CheckBro(partnerB)) then
		return
	end
	if not Get(id) then
		return
	end
	return true
end

local function NotifyPartners(id, message, x, f)
	local function send(plyr)
		task.spawn(function()
			pcall(function()
				_L.Network.Fire((x or "Send Message"), plyr, (message == true and true) or tostring(message))
			end)
		end)
	end
	local trade = Get(id)
	if f and f[1] and f[2] then
		send(f[1])
		send(f[2])
	else
		if (not trade) or (not CheckTrade(id)) then
			return false
		end
		send(trade.sender)
		send(trade.target)
	end
	return true
end

local function SendPartners(id, f, THEN_DO, ...)
	local x = {...}
	local function send(plyr)
		pcall(function()
			_L.Network.Fire(f, plyr, unpack(x))
		end)
	end
	local trade = Get(id)
	if (not trade) or (not CheckTrade(id)) then
		return false
	end
	send(trade.sender)
	send(trade.target)
	THEN_DO()
	return true
end

local function ForceStopTrade(id, r)
	if trades[tostring(id)] then
		if r == "/" then
			SendPartners(id, "Trade Processed", function()
				trades[tostring(id)] = nil
			end, "/")
		else
			warn(tostring(r))
			SendPartners(id, "Trade Processed", function()
				trades[tostring(id)] = nil
			end, false)
		end
		trades[tostring(id)] = nil
	end
end

local function Update(id)
	local function send(plyr)
		_L.Network.Fire("Update Trade", plyr, tostring(id), Get(id))
	end
	local trade = Get(id)
	if not trade then
		return false
	end
	if not CheckTrade(id) then
		return false
	end
	send(trade.sender)
	send(trade.target)
	return true
end

local function SafelyUpdate(id)
	if not Update(id) then
		ForceStopTrade(id, "Something went wrong while updating the trade partners")
		return false
	end
	return true
end

local function DeepCopy(original)
	local copy = {}
	for k, v in pairs(original) do
		if type(v) == "table" then
			v = DeepCopy(v)
		end
		copy[k] = v
	end
	return copy
end

local function Initialize(plyr, otherplyr)
	if (not GetByPlyr(plyr)) and (not GetByPlyr(otherplyr)) then
		if not (CheckBro(plyr, true) and CheckBro(otherplyr, true) and plyr.UserId ~= otherplyr.UserId) then
			return
		end
		if not Plyr_Info[tostring(plyr.UserId)] then
			return
		end

		local trade = _L.Functions.CloneTable(TradingTemplate)
		if not( trade and trade.senderItems) then
			return
		end
		local id = _L.Functions.GenerateUID()

		trade.sender = plyr
		trade.target = otherplyr
		trade.id = tostring(id)
		trade["messages"] = {}

		trades[id] = trade

		_L.Network.Fire("Init Trade", plyr, id, trades[id])
		_L.Network.Fire("Init Trade", otherplyr, id, trades[id])


		Plyr_Info[tostring(plyr.UserId)][2] = true
		Plyr_Info[tostring(otherplyr.UserId)][2] = true

		return trades[id], id
	end
end

local function FigureOutOfferString(plyr)
	local trade, id = GetByPlyr(plyr)
	if not trade then
		return
	end
	if trade.sender == plyr then
		return "senderItems"
	end
	if trade.target == plyr then
		return "targetItems"
	end
	return
end

local function FigureOutSenderData(plyr)
	local trade, id = GetByPlyr(plyr)
	if not trade then
		return
	end
	if trade.sender == plyr then
		return "sender"
	end
	if trade.target == plyr then
		return "target"
	end
	return
end

local function FigureSendMessage(plyr)
	local trade, id = GetByPlyr(plyr)
	if not trade then
		return
	end
	if trade.sender == plyr then
		return "messages"
	end
	return
end

-- TODO: HERE.
local function AddPet(plyr, f, petId)
	local s = _L.Saving.Get(plyr)
	if not s then
		return false, "Could not find save for player. This is crucial"
	end
	if not (Plyr_Info[tostring(plyr.UserId)] and Plyr_Info[tostring(plyr.UserId)][2]) then
		return false, "You cant add pets!"
	end
	local pet, oplyr = _L.Pets.Get(tostring(petId))
	if not (pet and tostring(pet.uid) == tostring(petId) and oplyr and oplyr == plyr) then
		return false, "Could not add pet to trade because of failed ownership check"
	end
	local trade, id = GetByPlyr(plyr)
	if tostring(id) ~= f then
		return false, "IDs were not the same"
	end
	if not trade or not id then
		return false, "Could not identify trade"
	end

	if pet.l or pet.l == true then
		return false, "Pet is locked, unlock it first!"
	end

	if pet.s <= 0 and pet.s ~= 0 then
		return false, "Pet has negative power, you cant trade it!"
	end

	local dir = _L.Directory.Pets[tostring(pet.id)]
	if not dir then
		return false, "No directory"
	end
	if not dir.tradeable then
		return false, "This pet is not tradeable"
	end
	local offer = FigureOutOfferString(plyr)
	if not offer then
		return false, "Could not figure out offer string"
	end
	if not trade[offer] then
		return false, "Offer string was invalid"
	end
	if _L.Functions.SearchArray(trade[offer].pets, tostring(pet.uid)) then
		return false, "Pet is already in offer."
	end
	if #trade[offer].pets >= 30 then
		return false, "Your side full"
	end
	table.insert(trade[offer].pets, tostring(pet.uid))
	trade.senderReady = false
	trade.targetReady = false
	trade.targetConfirmed = false
	trade.senderConfirmed = false
	
	-- asf
	trade.confirmStage = false
	
	if not SafelyUpdate(id) then
		return false, "Trade could not safely update"
	end
	
	--[[if trade.counter ~= 0 then -- idk
		if trade.lastCounter == 0 then
			trade.lastCounter = trade.counter --workspace:GetServerTimeNow()
			trade.counter = workspace:GetServerTimeNow()
		else
			trade.lastCounter = workspace:GetServerTimeNow()
			trade.counter = trade.lastCounter
		end	
	else
		trade.counter = workspace:GetServerTimeNow()
	end]]--
	trade.counter = workspace:GetServerTimeNow() + 3
	trade.lastCounter = workspace:GetServerTimeNow() -- idk
	
	return true
end

_L.Network.Invoked("Send Trade Message").OnInvoke = function(plyr, f, Text)
	local s = _L.Saving.Get(plyr)
	local trade, id = GetByPlyr(plyr)
	if tostring(id) ~= f then
		return false, "IDs were not the same"
	end

	if not trade or not id then
		return false, "Could not identify trade"
	end

	if not s then
		return false, "No file"
	end

	if not Text or Text == nil or Text == "" then
		return false, "Please say anything first!"
    end
    
    local filtered
    local success,e = pcall(function()
        filtered = _L.TextService:FilterStringAsync(Text, plyr.UserId)
        filtered = filtered:GetNonChatStringForBroadcastAsync()
    end)

    if not success or not filtered then
        return nil, "Unable to filter your message. Try something else"
    end

	trade.senderReady = false
	trade.targetReady = false
	trade.targetConfirmed = false
	trade.senderConfirmed = false
	
	-- asf
	trade.confirmStage = false

	if plyr == trade.sender then
        table.insert(trade.messages,{isSender = true, message = tostring(filtered)})
	elseif plyr == trade.target then
        table.insert(trade.messages,{isSender = false, message = tostring(filtered)})
	else
		return false, "something went wrong try again later"
	end

	return true
end

_L.Network.Invoked("Change Trade Diamonds").OnInvoke = function(plyr , f, amt)
	local s = _L.Saving.Get(plyr)
	if not s then
		return false, "Could not find save for player. This is crucial"
	end

	if not (Plyr_Info[tostring(plyr.UserId)] and Plyr_Info[tostring(plyr.UserId)][2]) then
		return false, "You cant add pets!"
	end

	local trade, id = GetByPlyr(plyr)
	if tostring(id) ~= f then
		return false, "IDs were not the same"
	end

	if not trade or not id then
		return false, "Could not identify trade"
	end

	local TAmt = tonumber(amt)
	if not TAmt then
		return false
	end

	if TAmt > s.Diamonds then
		return false
	end

	if TAmt < 0 then
		return false
	end

	local offer = FigureOutOfferString(plyr)
	if not (offer and trade[offer]) then
		return false, "Offer string is invalid"
	end
	trade[offer].diamonds = math.round(TAmt)
	trade.senderReady = false
	trade.targetReady = false
	trade.targetConfirmed = false
	trade.senderConfirmed = false
	
	-- asf
	trade.confirmStage = false

	if not SafelyUpdate(id) then
		return false, "Trade could not safely update"
	end
	
	trade.counter = workspace:GetServerTimeNow() + 3
	trade.lastCounter = workspace:GetServerTimeNow() -- idk

	return true
end

_L.Network.Invoked("Change Trade PawTokens").OnInvoke = function(plyr, f, amt)
	local s = _L.Saving.Get(plyr)
	if not s then
		return false, "Could not find save for player. This is crucial"
	end

	if not (Plyr_Info[tostring(plyr.UserId)] and Plyr_Info[tostring(plyr.UserId)][2]) then
		return false, "You cant add paw tokens!"
	end

	local trade, id = GetByPlyr(plyr)
	if tostring(id) ~= f then
		return false, "IDs were not the same"
	end

	if not trade or not id then
		return false, "Could not identify trade"
	end

	local TAmt = tonumber(amt)
	if not TAmt then
		return false
	end

	if TAmt > (s["Paw Tokens"] or 0) then
		return false
	end

	if TAmt < 0 then
		return false
	end

	local offer = FigureOutOfferString(plyr)
	if not (offer and trade[offer]) then
		return false, "Offer string is invalid"
	end
	trade[offer].pawTokens = math.round(TAmt)
	trade.senderReady = false
	trade.targetReady = false
	trade.targetConfirmed = false
	trade.senderConfirmed = false
	
	-- asf
	trade.confirmStage = false

	if not SafelyUpdate(id) then
		return false, "Trade could not safely update"
	end
	
	trade.counter = workspace:GetServerTimeNow() + 3
	trade.lastCounter = workspace:GetServerTimeNow() -- idk

	return true
end



_L.Network.Invoked("Add Trade Pet").OnInvoke = AddPet

_L.Network.Invoked("Get Trade").OnInvoke = function(plyr, sesh)
	return trades[tostring(sesh)]
end

local function FigureOutDetails(plyr, f)
	local f = Get(tostring(f))
	if not f then
		return
	end
	if f.target == plyr then
		return nil, f.sender
	else
		return nil, f.target
	end
end

--[[_L.Network.Invoked("Cancel Trade").OnInvoke = function(plyr, sesh)
	local GET, ID = GetByPlyr(plyr)
	if not (GET and ID) then
		return false, "NO GET OR ID"
	end
	if tostring(ID) ~= tostring(sesh) then
		return false, "Invalid session id"
	end
	if not (Plyr_Info[tostring(plyr.UserId)] and Plyr_Info[tostring(plyr.UserId)][2]) then
		return false, "You cant do actions"
	end
	local f, OTHER = FigureOutDetails(plyr, ID)
	SendPartners(ID, "Trade Cancelled", function()
		if not (Plyr_Info[tostring(plyr.UserId)] and Plyr_Info[tostring(plyr.UserId)][2]) then
			return
		end
		ForceStopTrade(ID, "/")
	end, ID, OTHER or {DisplayName = "???"})
	return true
end]]

_L.Network.Invoked("Remove Trade Pet").OnInvoke = function(plyr, id , petId)
	local s = _L.Saving.Get(plyr)
	if not s then
		return false, "Could not find save for player. This is crucial"
	end
	if not (Plyr_Info[tostring(plyr.UserId)] and Plyr_Info[tostring(plyr.UserId)][2]) then
		return false, "You cant change pets!"
	end
	local pet, oplyr = _L.Pets.Get(tostring(petId))
	if not (pet and tostring(pet.uid) == tostring(petId) and oplyr and oplyr == plyr) then
		return false, "Could not add pet to trade because of failed ownership check"
	end
	local trade, id = GetByPlyr(plyr)
	if not trade or not id then
		return false, "Could not identify trade"
	end
	if tostring(id) ~= id then
		return false, "IDs were not the same"
	end
	local offer = FigureOutOfferString(plyr)
	if not offer then
		return false, "Could not figure out offer string"
	end
	if not trade[offer] then
		return false, "Offer string was invalid"
	end
	if not _L.Functions.SearchArray(trade[offer].pets, tostring(petId)) then
		return false, "Pet not in offer."
	end
	local removed
	for v1 = #trade[offer].pets, 1, -1 do
		if trade[offer].pets[v1] == tostring(petId) then
			table.remove(trade[offer].pets, v1)
			removed = true
		end
	end
	trade.senderReady = false
	trade.targetReady = false
	trade.targetConfirmed = false
	trade.senderConfirmed = false
	
	-- asf
	trade.confirmStage = false
	
	if not removed then
		return false, "Failed to remove"
	end
	if not SafelyUpdate(id) then
		return false, "Trade could not safely update"
	end
	return true
end


local function CorrectPetIds(id)
	local trade = Get(id)
	if not (trade and trade.senderItems and trade.targetItems) then
		return
	end
	local f = true
	for i,v in pairs(trade.senderItems.pets) do
		if not _L.Pets.Get(tostring(v)) then
			f = false
			break
		end
	end
	if f then
		for i,v in pairs(trade.targetItems.pets) do
			if not _L.Pets.Get(tostring(v)) then
				f = false
				break
			end
		end
	end
	return f
end

local function ProcessTrade(id)
	local timeStart = os.clock()
	local trade = Get(id)
	if not trade then
		return
	end
	if not CheckTrade(id) then
		ForceStopTrade(id, "PROCESSING: Something went wrong while checking the trade session")
		return
	end
	if not (trade.senderConfirmed and trade.targetConfirmed) then
		return
	end
	if not CorrectPetIds(tostring(id)) then
		ForceStopTrade(id, "PROCESSING: Something went wrong while checking pets")
		return
	end
	local PleaseStopTrade
	local function InitializePlayerStats(plyr)
		local succes, err = pcall(function()
			local s = _L.Saving.Get(plyr)
			if not s then
				PleaseStopTrade = "No statistics for " .. tostring(plyr.Name)
				return
			end
			if (not s.PickedStarter) then
				PleaseStopTrade = "One player has not picked their starter pet yet"
				return
			end
			local offers = FigureOutOfferString(plyr)
			if not offers and tostring(offers) ~= "nil" then
				PleaseStopTrade = "Could not figure out offer string for " .. tostring(plyr.Name)
				return
			end
			if not (s.Diamonds and s.Diamonds >= trade[offers].diamonds) then
				PleaseStopTrade = tostring(plyr.Name) .. " lacks diamonds that were previously available"
				return
			end
			if not ((s["Paw Tokens"] or 0) >= (trade[offers].pawTokens or 0)) then
				PleaseStopTrade = tostring(plyr.Name) .. " lacks paw tokens that were previously available"
				return
			end

			if not Plyr_Info[tostring(plyr.UserId)] then
				PleaseStopTrade = "No player info for one of the two players"
				return
			end
			if not pcall(function() Plyr_Info[tostring(plyr.UserId)][2] = false end) then
				PleaseStopTrade = "Failed to set player info to false"
				return
			end
		end)
		if not succes then
			PleaseStopTrade = "An error occured during a trade: " .. tostring(err)
			return
		end
	end
	if ((not trade.sender) and CheckBro(trade.sender) and trade.target and CheckBro(trade.target)) then
		ForceStopTrade(id, "PROCESSING: Something went wrong while checking trading partners")
		return
	end

	InitializePlayerStats(trade.sender)
	if PleaseStopTrade then
		ForceStopTrade(id, "PROCESSING: " .. tostring(PleaseStopTrade))
		return
	end
	InitializePlayerStats(trade.target)
	if PleaseStopTrade then
		ForceStopTrade(id, "PROCESSING: " .. tostring(PleaseStopTrade))
		return
	end

	-- NOW OFFICIALLY PROCESSING
	trade.isProcess = true
	if not (trade.senderConfirmed and trade.targetConfirmed) then
		return
	end

	-- Give diamonds
	local DiamondsFrame = {-1, -1}
	local function AddToDiamondsFrame(plyr, T)
		local s = _L.Saving.Get(plyr)
		if not s then
			PleaseStopTrade = "No statistics for " .. tostring(plyr.Name)
			return
		end
		local offers = FigureOutOfferString(plyr)
		if not offers and tostring(offers) ~= "nil" then
			PleaseStopTrade = "Could not figure out offer string for " .. tostring(plyr.Name)
			return
		end
		if not (s.Diamonds and s.Diamonds >= trade[offers].diamonds) then
			PleaseStopTrade = tostring(plyr.Name) .. " lacks diamonds that were previously available"
			return
		end
		DiamondsFrame[T] = trade[offers].diamonds
    end
    
	AddToDiamondsFrame(trade.sender, 1)
    AddToDiamondsFrame(trade.target, 2)
    
	if PleaseStopTrade then
		ForceStopTrade(id, "PROCESSING: " .. tostring(PleaseStopTrade))
		return
    end
    
	-- Give Paw Tokens (same security as Diamonds)
	local PawTokensFrame = {-1, -1}
	local function AddToPawTokensFrame(plyr, T)
		local s = _L.Saving.Get(plyr)
		if not s then
			PleaseStopTrade = "No statistics for " .. tostring(plyr.Name)
			return
		end
		local offers = FigureOutOfferString(plyr)
		if not offers and tostring(offers) ~= "nil" then
			PleaseStopTrade = "Could not figure out offer string for " .. tostring(plyr.Name)
			return
		end
		local playerTokens = s["Paw Tokens"] or 0
		local offeredTokens = trade[offers].pawTokens or 0
		if playerTokens < offeredTokens then
			PleaseStopTrade = tostring(plyr.Name) .. " lacks paw tokens that were previously available"
			return
		end
		PawTokensFrame[T] = offeredTokens
	end
	
	AddToPawTokensFrame(trade.sender, 1)
	AddToPawTokensFrame(trade.target, 2)
	
	if PleaseStopTrade then
		ForceStopTrade(id, "PROCESSING: " .. tostring(PleaseStopTrade))
		return
	end
    
	local C_PETS = {-1, -1}
	local NeedSlots = nil
	local function SayNah(f)
		if not NotifyPartners(id, (f or "One of the players needs more inventory space. (Or needs atleast 1 pet!)")) then
			return
		end
		trade.senderConfirmed = false
		trade.targetConfirmed = false
		trade.senderReady = false
		trade.targetReady = false
		-- asf
		trade.confirmStage = false
		
		trade.processing = false
		trade.isProcess = false
		pcall(function()
			Plyr_Info[tostring(trade.sender.UserId)][2] = true
		end)
		pcall(function()
			Plyr_Info[tostring(trade.target.UserId)][2] = true
		end)
		if not SafelyUpdate(id) then
			return
		end
		return true
	end

	local function ConvertPets(plyr, numb)
		local s = _L.Saving.Get(plyr)
		if not s then
			PleaseStopTrade = "No statistics for " .. tostring(plyr.Name)
			return
		end
		local offers = FigureOutOfferString(plyr)
		if not offers and tostring(offers) ~= "nil" then
			PleaseStopTrade = "Could not figure out offer string for " .. tostring(plyr.Name)
			return
		end
		C_PETS[numb] = {}
		for i,v in pairs(trade[offers].pets) do
			local pet, oplyr = _L.Pets.Get(tostring(v))
			if not (pet and oplyr == plyr and tostring(pet.uid) == tostring(v)) then
				PleaseStopTrade = "A pet was invalid for " .. tostring(plyr.Name)
				return
			end
			local NewTab = {}
			for i,v in pairs(pet) do
				local m = tostring(i)
			--	if WL[m] then
					NewTab[m] = v
			--	end
			end
			table.insert(C_PETS[numb], NewTab)
		end
	end


	ConvertPets(trade.sender, 1)
	ConvertPets(trade.target, 2)

	local function CheckSlots(plyr, numb, oppNumb)
		-- TODO: CHECK IF WILL DELETE FINAL PET
		local s = _L.Saving.Get(plyr)
		if not s then
			PleaseStopTrade = "No statistics for " .. tostring(plyr.Name)
			return
		end
		local offers = FigureOutOfferString(plyr)
		if not offers and tostring(offers) ~= "nil" then
			PleaseStopTrade = "Could not figure out offer string for " .. tostring(plyr.Name)
			return
		end
		local Hash = #C_PETS[numb]
		if #s.Pets - #C_PETS[oppNumb] < 1 then
			NeedSlots = true
		end
		if Hash > 0 then
			if (#s.Pets + Hash) > s.MaxSlots then
				NeedSlots = true
			end
		end
	end

	-- CHECK SLOTS
	CheckSlots(trade.sender, 2, 1)
	CheckSlots(trade.target, 1, 2)

	if PleaseStopTrade then
		ForceStopTrade(id, "PROCESSING: " .. tostring(PleaseStopTrade))
		return
	end
	if NeedSlots then
		if not SayNah() then
			ForceStopTrade(id, "Something went wrong while fixing trade")
			return
		else
			return
		end
	end

	local NeedStopDiamondTrade = false
	local function CheckGems(plyr, numb)
		-- TODO: CHECK IF WILL DELETE FINAL PET
		local s = _L.Saving.Get(plyr)
		if (not s) or (not s.Diamonds) then
			PleaseStopTrade = "No statistics for " .. tostring(plyr.Name)
			return
		end
		local offers = FigureOutOfferString(plyr)
		if not offers and tostring(offers) ~= "nil" then
			PleaseStopTrade = "Could not figure out offer string for " .. tostring(plyr.Name)
			return
		end
		if (s.Diamonds + DiamondsFrame[numb]) > _L.Directory.Currency["Diamonds"].Limit then
			NeedStopDiamondTrade = true
		end
	end

	-- CHECK SLOTS
	CheckGems(trade.sender, 2)
	CheckGems(trade.target, 1)


	if PleaseStopTrade then
		ForceStopTrade(id, "PROCESSING: " .. tostring(PleaseStopTrade))
		return
	end
	if NeedStopDiamondTrade then
		if not SayNah("One player does not have enough space for more diamonds") then
			ForceStopTrade(id, "Something went wrong while fixing DIAMONDS")
			return
		else
			return
		end
	end

	if PleaseStopTrade then
		ForceStopTrade(id, "PROCESSING: " .. tostring(PleaseStopTrade))
		return
	end

	-- GIVE THE ITEMS AFTER A FINAL CHECK --
	-- TODO: HERE
	local trade = Get(id)
	if not trade then
		return
	end
	if not CheckTrade(id) then
		ForceStopTrade(id, "PROCESSING: Something went wrong while checking the trade session")
		return
	end

	CheckSlots(trade.sender, 2, 1)
	CheckSlots(trade.target, 1, 2)

	if NeedSlots then
		ForceStopTrade(id, "Need more slots [last check]")
		return
	end

	local function TakeGems(plyr, numb)
		local s = _L.Saving.Get(plyr)
		if not s then
			PleaseStopTrade = "No save for plyr DURING DIAMOND CHECK"
			return
		end
		local o = FigureOutOfferString(plyr)
		if not (o and trade[o]) then
			PleaseStopTrade = "Invalid offer string during diamond check"
			return
		end
		if s.Diamonds < trade[o].diamonds then
			PleaseStopTrade = "Lacks diamonds"
			return
		end
		s.Diamonds = s.Diamonds - math.clamp(trade[o].diamonds, 0, 99999999999999999999999999999)
		return true
	end

	local function TakePawTokens(plyr, numb)
		local s = _L.Saving.Get(plyr)
		if not s then
			PleaseStopTrade = "No save for plyr DURING PAW TOKENS CHECK"
			return
		end
		local o = FigureOutOfferString(plyr)
		if not (o and trade[o]) then
			PleaseStopTrade = "Invalid offer string during paw tokens check"
			return
		end
		local pawTokensAmount = trade[o].pawTokens or 0
		if (s["Paw Tokens"] or 0) < pawTokensAmount then
			PleaseStopTrade = "Lacks paw tokens"
			return
		end
		s["Paw Tokens"] = (s["Paw Tokens"] or 0) - math.clamp(pawTokensAmount, 0, 99999999999999999)
		return true
	end


	if not TakeGems(trade.sender, 1) then
		ForceStopTrade(id, tostring(PleaseStopTrade or "Diamond take failure"))
		return
	end
	if not TakeGems(trade.target, 2) then
		ForceStopTrade(id, tostring(PleaseStopTrade  or "Diamond take failure"))
		return
	end
	if not TakePawTokens(trade.sender, 1) then
		ForceStopTrade(id, tostring(PleaseStopTrade or "Paw Tokens take failure"))
		return
	end
	if not TakePawTokens(trade.target, 2) then
		ForceStopTrade(id, tostring(PleaseStopTrade or "Paw Tokens take failure"))
		return
	end
	if PleaseStopTrade then
		ForceStopTrade(id, tostring(PleaseStopTrade))
		return
	end
	if (not trade.sender) or (not trade.target) then
		return
	end

	-- TODO: TAKE AWAY PETS HERE
	local TakeFailure
	local function Delete(plyr, numb)
		if not _L.Saving.Get(plyr) then
			PleaseStopTrade = "NO SAVE 3"
			return
		end
		for i,v in pairs(C_PETS[numb]) do
			if not v.uid then
				warn("NO UID")
				TakeFailure = true
				break
			end
			if not _L.Pets.Delete(v.uid) then
				TakeFailure = true
				break
			end
		end
	end
	Delete(trade.sender, 1)
	if PleaseStopTrade then
		ForceStopTrade(id, tostring(PleaseStopTrade))
		return
	end
	Delete(trade.target, 2)
	if PleaseStopTrade then
		ForceStopTrade(id, tostring(PleaseStopTrade))
		return
	end

	if TakeFailure then
		ForceStopTrade(id, "Unfortunately, a pet failed to delete. No pets will be refunded (to prevent duping) 😢")
		return
	end

	--------------------------------------------------------------------------------
	local domonds 
	if DiamondsFrame[1] ~= -1 and DiamondsFrame[2] ~= -1 and PleaseStopTrade == nil and C_PETS[1] ~= -1 and C_PETS[2] ~= -1 then
		local function GiveDiamondsToPlyr(plyr, numb)
			coroutine.wrap(function()
				local success , err = pcall(function()
					local s = _L.Saving.Get(plyr)
					s.Diamonds = s.Diamonds + math.clamp(DiamondsFrame[numb], 0, _L.Directory.Currency["Diamonds"].Limit)
					domonds = math.clamp(DiamondsFrame[numb], 0, _L.Directory.Currency["Diamonds"].Limit)
				end)
				if not success then
					warn("CRITICAL: " .. tostring(err))
				end
			end)()
		end
		GiveDiamondsToPlyr(trade.sender, 2)
		GiveDiamondsToPlyr(trade.target, 1)
		
		-- Give Paw Tokens (using pre-validated PawTokensFrame)
		local function GivePawTokensToPlyr(plyr, numb)
			coroutine.wrap(function()
				local success, err = pcall(function()
					local s = _L.Saving.Get(plyr)
					-- Same pattern as GiveDiamondsToPlyr: numb indexes the opposite player's offer
					local tokensToGive = PawTokensFrame[numb] or 0
					if tokensToGive > 0 then
						s["Paw Tokens"] = (s["Paw Tokens"] or 0) + math.clamp(tokensToGive, 0, 999999999999)
					end
				end)
				if not success then
					warn("CRITICAL PAW TOKENS: " .. tostring(err))
				end
			end)()
		end
		GivePawTokensToPlyr(trade.sender, 2)  -- sender receives target's tokens (PawTokensFrame[2])
		GivePawTokensToPlyr(trade.target, 1)  -- target receives sender's tokens (PawTokensFrame[1])
		

        
        local function history(plyr, isSender) -- @pggondim
            --[[
                TODO: update plyrs trading history
                
                data set example:
                
                   save.TradeHistory2 = {
                {
                    u = otherPlyr.UserId,
                    ts = os.time(),
                    p = yourPets,
                    pn = #yourPets,
                    op = otherPets,
                    opn = #otherPets,
                    d = yourDiamonds,
                    od = otherDiamonds,
                    t = 0
                }

            }
            --]]
            
            local save = _L.Saving.Get(plyr)
            if not save then
                ForceStopTrade(id, "Failed to get a plyrs save :(")
                return
            end
            
            local otherPlyr = isSender == true and trade.target or trade.sender
            if not otherPlyr then
                ForceStopTrade(id, "Failed to get a plyrs data :(")
                return
            end
            
            local numb = isSender and 1 or 2
            local otherNumb = isSender and 2 or 1
            local yourPets = C_PETS[numb]
            local otherPets = C_PETS[otherNumb]
            local otherPetsN = #otherPets
            local yourDiamonds = DiamondsFrame[numb]
            local otherDiamonds = DiamondsFrame[otherNumb]
            if not yourPets or not otherPets or not otherPetsN or not yourDiamonds or not otherDiamonds then
                ForceStopTrade(id, "Something went wrong :(")
                return
            end
            
            local yourTokens = PawTokensFrame[numb]
            local otherTokens = PawTokensFrame[otherNumb]
            
            table.insert(save.TradeHistory2, {
                u = otherPlyr.UserId,
                ts = os.time(),
                p = yourPets,
                pn = #yourPets,
                op = otherPets,
                opn = #otherPets,
                d = yourDiamonds,
                od = otherDiamonds,
                tk = yourTokens or 0,
                otk = otherTokens or 0,
                t = 0
            })
        end
        
        history(trade.sender, true)
        history(trade.target, false)
        
		-- CHECK FOR DUPLICATE IDS
		local RegisteredIds = {}
		local FoundDuplicate

		local function CheckForDupes(numb)
			for i,v in pairs(C_PETS[numb]) do
				if not v.uid then
					warn("NO UID")
					PleaseStopTrade = "NO UID"
					break
				end
				if RegisteredIds[tostring(v.uid)] then
					FoundDuplicate = true
					break
				end
				RegisteredIds[tostring(v.uid)] = true
			end
		end
		CheckForDupes(1)
		CheckForDupes(2)
		if FoundDuplicate then
			ForceStopTrade(id, "Unfortunately, a pet duplicated. No pets will be refunded (to prevent duping) 😢")
			return
		end
		if PleaseStopTrade then
			ForceStopTrade(id, PleaseStopTrade)
			return
		end

		if (not trade.sender) or (not trade.target) then
			return
		end

		local function GivePetsToPlyr(plyr, oppositeNumber, regularNumber)
			coroutine.wrap(function()

				local s , e = pcall(function()
					for i,v in pairs(C_PETS[oppositeNumber]) do
						-- TODO: GIVE
						if v and type(v) == "table" and v.id and v.uid then
							_L.Pets.Create(plyr, tostring(v.id), v, nil, true)
						else
							warn("no id")
						end
					end
				end)
				if not s then
					warn("CRITICAL : " .. tostring(e))
				end

				--_G.CantJoinPlaza[tostring(plyr.UserId)] = true
				local saveStatus = _L.Saving.Save(plyr)
				if not saveStatus then
					wait(2)
					warn("Save failed for " .. tostring(plyr.UserId) .. ", trying again.")
					if not _L.Saving.Save(plyr) then
						warn("Save failed twice for " .. tostring(plyr.UserId))
					end
				end
				--_G.CantJoinPlaza[tostring(plyr.UserId)] = nil
			end)()
		end
		GivePetsToPlyr(trade.sender, 2, 1)
		GivePetsToPlyr(trade.target, 1, 2)


		local function Follow(plyr, oppositeNumber)
			coroutine.wrap(function()
				for i,v in pairs(C_PETS[oppositeNumber]) do
					if v.uid then
						_L.Signal.Fire("Force Change Target", v.uid)
					end
				end
			end)()
		end
		Follow(trade.sender, 2)
		Follow(trade.target, 1)

		SendPartners(id, "Trade Processed", function()
			trades[tostring(id)] = nil
		end, true)
		trades[tostring(id)] = nil

		return true
	else
		ForceStopTrade(id, "Something went wrong while giving currencies to plyrs")
		return
	end
	--------------------------------------------------------------------------------

end -- ends here



local function CheckProcessingState(id)
	local trade = Get(id)
	if not trade then
		return
	end
	
	if trade.senderReady and trade.targetReady then
		if not trade.confirmStage then
			trade.confirmStage = true
		end
	else
		trade.confirmStage = false
	end
	
	if trade.senderConfirmed and trade.targetConfirmed then
		coroutine.wrap(function()
			local tme = os.clock()
			local timeExpired = false
			if not SafelyUpdate(id) then
				return
			end
			while true do
				if not Get(id) then
					break
				end
				if not (trade.senderConfirmed and trade.targetConfirmed) then
					break
				end
				if not CheckTrade(id) then
					break
				end
				if os.clock() - tme > 4 then
					timeExpired = true
					break
				end
				_L.Heartbeat(3)
			end
			if not SafelyUpdate(id) then
				return
			end
			if timeExpired then
				-- final check
				local t = Get(id)
				if not t then
					return
				end
				if not (trade.senderConfirmed and trade.targetConfirmed) then
					return
				end
				if not CheckTrade(id) then	
					return
				end
				trade.processing = true
				trade.confirmTick = workspace:GetServerTimeNow()
				-- Process it
				ProcessTrade(tostring(id))
			end
		end)()
	end
end

_L.Network.Invoked("Ready Trade").OnInvoke = function(plyr, f, counter)
	local s = _L.Saving.Get(plyr)
	if not s then
		return false, "Could not find save for player. This is crucial"
	end
	if not (Plyr_Info[tostring(plyr.UserId)] and Plyr_Info[tostring(plyr.UserId)][2]) then
		return false, "You cant ready up!"
	end
	local trade, id = GetByPlyr(plyr)
	if tostring(id) ~= f then
		return false, "IDs were not the same"
	end
	if not trade or not id then
		return false, "Could not identify trade"
	end
	--[[if workspace:GetServerTimeNow() - counter > 0 then
		return false, "Time left.."
	end]]--
	warn()
	local str = FigureOutSenderData(plyr)
	if not str then
		return false, "Sender data was not valid"
	end
	local ss = str .. "Ready"
	if trade[ss] then
		return false, "You are already readied!"
	end
	trade[ss] = true
	if not SafelyUpdate(id) then
		return false, "Could not safely update"
	end
	CheckProcessingState(id)
	return true
end

_L.Network.Invoked("Confirm Trade").OnInvoke = function(plyr, f, counter)
	local s = _L.Saving.Get(plyr)
	if not s then
		return false, "Could not find save for player. This is crucial"
	end
	if not (Plyr_Info[tostring(plyr.UserId)] and Plyr_Info[tostring(plyr.UserId)][2]) then
		return false, "You cant ready up!"
	end
	local trade, id = GetByPlyr(plyr)
	if tostring(id) ~= f then
		return false, "IDs were not the same"
	end
	if not trade or not id then
		return false, "Could not identify trade"
	end
	
	local str = FigureOutSenderData(plyr)
	if not str then
		return false, "Sender data was not valid"
	end
	local ss = str .. "Confirmed"
	if trade[ss] then
		return false, "You are already confirmed!"
	end
	trade[ss] = true
	if not SafelyUpdate(id) then
		return false, "Could not safely update"
	end
	CheckProcessingState(id)
	return true
end

_L.Network.Invoked("Unready Trade").OnInvoke = function(plyr, f, counter)
	local s = _L.Saving.Get(plyr)
	if not s then
		return false, "Could not find save for player. This is crucial"
	end
	if not (Plyr_Info[tostring(plyr.UserId)] and Plyr_Info[tostring(plyr.UserId)][2]) then
		return false, "You cant unconfirm!"
	end
	local trade, id = GetByPlyr(plyr)
	if tostring(id) ~= f then
		return false, "IDs were not the same"
	end
	if not trade or not id then
		return false, "Could not identify trade"
	end
	local str = FigureOutSenderData(plyr)
	if not str then
		return false, "Sender data was not valid"
	end
	local ss = str .. "Confirm"
	if not trade[ss] then
		return false, "You are already unconfirmed!"
	end
	trade[ss] = false
	if not SafelyUpdate(id) then
		return false, "Could not safely update"
	end
	return true
end

_L.Network.Invoked("Unready Trade").OnInvoke = function(plyr, f, counter)
	local s = _L.Saving.Get(plyr)
	if not s then
		return false, "Could not find save for player. This is crucial"
	end
	if not (Plyr_Info[tostring(plyr.UserId)] and Plyr_Info[tostring(plyr.UserId)][2]) then
		return false, "You cant unready!"
	end
	local trade, id = GetByPlyr(plyr)
	if tostring(id) ~= f then
		return false, "IDs were not the same"
	end
	if not trade or not id then
		return false, "Could not identify trade"
	end
	local str = FigureOutSenderData(plyr)
	if not str then
		return false, "Sender data was not valid"
	end
	local ss = str .. "Ready"
	if not trade[ss] then
		return false, "You are already unreadied!"
	end
	trade[ss] = false
	if not SafelyUpdate(id) then
		return false, "Could not safely update"
	end
	return true
end


_L.Signal.Fired("Pet Deleted"):connect(function(petId, plyr)
	local trade, id = GetByPlyr(plyr)
	if trade and not trade.isProcess then
		local Figured = FigureOutOfferString(plyr)
		if not (Figured and trade[Figured]) then
			ForceStopTrade(id, "Could not figure out trading")
			return
		end
		local x 
		pcall(function()
			x =tostring(plyr.Name)
		end)
		ForceStopTrade(id, "Forcibly stopped trade because " .. x .. " had a pet removed")
	end
end)

_L.Signal.Fired("Stat Changed"):connect(function(plyr, stat)
	if stat == "Diamonds" or stat == "RobuxSpent" or stat == "OwnsTradingPlaza" then
		local trade, id = GetByPlyr(plyr)
		if trade then
			local s = _L.Saving.Get(plyr)
			if not (s and s.Diamonds) then
				ForceStopTrade(tostring(id), "No save for one plyr")
				return
			end
			local Figured = FigureOutOfferString(plyr)
			if not (Figured and trade[Figured]) then
				ForceStopTrade(id, "Could not figure out trading")
				return
			end
			if trade[Figured].diamonds > s.Diamonds then
				trade[Figured].diamonds = s.Diamonds
				if not SafelyUpdate(id) then
					ForceStopTrade(id, "Could not safely update diamonds")
					return
				end
			end
		end
	end
end)

local Invites = {}
local C = {}

_L.Signal.Fired("Player Added"):connect(function(plyr)
	Invites[tostring(plyr.UserId)] = {}
	C[tostring(plyr.UserId)] = {}
end)

game.Players.PlayerRemoving:Connect(function(plyr)
	Invites[tostring(plyr.UserId)] = nil
end)

_L.Network.Invoked("Get Invites Open").OnInvoke = function(plyr)
	return Invites[tostring(plyr.UserId)]
end


_L.Network.Invoked("Send Trade Invite").OnInvoke = function(plyr, plyr2)
	local s = _L.Saving.Get(plyr)

	if not s then
		return false, "No file"
	end
	if not s.PickedStarter then
		return false, "You need a starter pet first"
	end
	if #s.Pets < 1 then
		return false, "You need a pet"
	end

	local abc2 = os.clock() - Plyr_Info[tostring(plyr.UserId)][1]

	if not GetTradingTimer(plyr) then
		return false, tostring(plyr.Name).. " needs wait ".. tostring(math.clamp(math.round(60-abc2), 0, 60)) .." seconds before trading."
	end

	local s2 = _L.Saving.Get(plyr2)
	if not s2 then
		return false, "No file for other player"
	end

	local abc = os.clock() - Plyr_Info[tostring(plyr2.UserId)][1]	
	if not GetTradingTimer(plyr2) then
		return false, tostring(plyr2.Name).. " needs wait ".. tostring(math.clamp(math.round(60-abc), 0, 60)) .." seconds before trading."
	end

	if not (s2.Settings and s2.Settings.Trading) then
		return false, "???"
	end
	if Get(plyr2) then
		return false, "This player is currently in a trade"
	end
	if not s2.PickedStarter then
		return false, "This player has no starter"
	end
	if #s2.Pets < 1 then
		return false, "The other player needs a pet"
	end
	if C[tostring(plyr.UserId)][tostring(plyr2.UserId)] and os.clock() - C[tostring(plyr.UserId)][tostring(plyr2.UserId)] < 15 then
		return false, "Please do not send too many requests to this player."
	end

	C[tostring(plyr.UserId)][tostring(plyr2.UserId)] = os.clock()

	if (s2.Settings.Trading == 1) or (not _G.Friends[tostring(plyr2.UserId)]) or (s2.Settings.Trading == 2 and _G.Friends[tostring(plyr2.UserId)] and _L.Functions.SearchArray(_G.Friends[tostring(plyr2.UserId)], plyr.UserId)) then
		Invites[tostring(plyr.UserId)][tostring(plyr2.UserId)] = true

		_L.Network.Fire("Update Trade Invites Open", plyr, Invites[tostring(plyr.UserId)])

		task.spawn(function()
			local o = os.clock()
			_L.Network.Fire("Trade Recieved", plyr2, plyr2, {sender = plyr})
			
			--local success = _L.Network.Invoke("Trade Recieved2", plyr2, plyr)
			--if success then
				_L.Network.Fired("Accept Trade Invite"):Connect(function()
					task.spawn(function()
						if plyr and plyr.Parent and plyr2 and plyr2.Parent then

							if os.clock() - o > 20 then
								return
							end

							if not CheckBro(plyr) then
								return
							end

							if not CheckBro(plyr2) then
								return
							end

							if Get(plyr2) then
								return
							end

							if GetTradingTimer(plyr2) ~= true or GetTradingTimer(plyr) ~= true then
								return
							end

							local ss = _L.Saving.Get(plyr)
							if not (ss and ss.Settings and ss.Settings.Trading) then
								return
							end
							if Get(plyr) then
								return
							end
							if (ss.Settings.Trading ~= 2) or (ss.Settings.Trading == 2 and _G.Friends and _G.Friends[tostring(plyr2.UserId)] and _L.Functions.SearchArray(_G.Friends[tostring(plyr2.UserId)], plyr.UserId)) then
								Initialize(plyr, plyr2)
							end
						end
					end)
				end);
				if plyr and plyr.Parent then
					Invites[tostring(plyr.UserId)][tostring(plyr2.UserId)] = nil
					_L.Network.Fire("Update Trade Invites Open", plyr, Invites[tostring(plyr.UserId)])
				end
			--end
		end)
		return true
	else
		return false, "You can't trade this player."
	end
end

-- idk
_L.Network.Fired("Ignore Trade"):Connect(function(player, plyr)
	--local trade, id = GetByPlyr(plyr)
	--[[print(trade, id)
	
	local otherPlayer = nil
	local isSender = false
	if trade.sender == player then
		otherPlayer  = trade.target.Name
		isSender = true
	else
		otherPlayer  = trade.sender.Name
	end]]--
	
	--print(trade,id,plyr,player)
	--if trade and id then
	--	ForceStopTrade(tostring(id), "Ignored")
		_L.Network.Fire("Trade Ignored", plyr, player)
	--end
end)

_L.Network.Invoked("Cancel Trade").OnInvoke = function(player, data)
	if data.processing == true then
		return false, 'already processing'
	end
	
	local trade, id = GetByPlyr(player)
	if not trade or not id then
		return false, "error"
	end

	if not (Plyr_Info[tostring(player.UserId)] and Plyr_Info[tostring(player.UserId)][2]) then
		return false, "You cant do actions"
	end
	
	local f, OTHER = FigureOutDetails(player, id)
	SendPartners(id, "Trade Cancelled", function()
		if not (Plyr_Info[tostring(player.UserId)] and Plyr_Info[tostring(player.UserId)][2]) then
			return
		end
		ForceStopTrade(id, false)
	end, id, OTHER or {DisplayName = "???"})
	return true
end

_L.Signal.Fired("Server Closing"):connect(function()
	for i,v in pairs(trades) do
		if not v.processing then
			ForceStopTrade(tostring(i), "Server closing")
		end
	end
end)
_L.Signal.Fired("Save Fail"):connect(function(player)
	local trade, id = GetByPlyr(player)
	if trade and id then
		ForceStopTrade(tostring(id), "One player failed to save")
	end
end)

while true do
	for i, _ in pairs(trades) do
		if not CheckTrade(i) then
			ForceStopTrade(i, "A player that was in the trade is now unavailable")
		end
	end
	_L.Heartbeat(2)
end



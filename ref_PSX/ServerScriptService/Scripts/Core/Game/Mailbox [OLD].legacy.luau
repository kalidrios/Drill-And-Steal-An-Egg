local _L = require(game:GetService("ReplicatedStorage"):WaitForChild("Library"))
while (not _L.Loaded) do game:GetService("RunService").Heartbeat:Wait() end

local mailDatastore = _L.DataStoreService:GetDataStore("mailData" .. _L.Settings.MailVersion)

local defaultMailData = {
	Inbox = {},
	Settings = {
		Rarities = {
			Basic = false,
			Rare = false,
			Epic = false,
			Legendary = false,
			Mythical = false,
			Secret = false,
			Event = false,
			Exclusive = false
		},
		OtherSettings = {
			HugesSetting = false,
			EnabledSetting = false,
			RequiredPetSetting = false,
			FriendsOnlySetting = false
		}
	}
}

local joinTime = nil

local function prefix(plyr, isUserId)
	local userid = isUserId and plyr or plyr.UserId
	
	return "us"..tostring(userid)
end

local function setPlayerData(plyr, data, isUserId, Settings)
	local plyrPrefix = prefix(plyr, isUserId)
	
	if not Settings then
		mailDatastore:SetAsync(plyrPrefix, data)
	else
		local data2 = mailDatastore:GetAsync(plyrPrefix)
		data2.Settings = data
		mailDatastore:SetAsync(plyrPrefix, data2)
	end	
end

local function getPlayerData(plyr, isUserId)
	local plyrPrefix = prefix(plyr, isUserId)
	
	local data = mailDatastore:GetAsync(plyrPrefix)
	
	if (not data) then
		local plyrUserId = isUserId and plyr or plyr.UserId
        setPlayerData(tostring(plyrUserId), table.clone(defaultMailData))
        return table.clone(defaultMailData)
	else
		return data
	end
end

local function genUUID()
	return "mail".._L.Functions.GenerateUID()
end

local osTimes = {}
local function checkTime(plyr)	
	local dev = ( joinTime - os.clock() ) * -1 
	
	if dev < 30 then
		return false, "You must wait 30 seconds before using the mailbox!"
	end
	
	local ok = osTimes[plyr.UserId]
	if not ok then
		osTimes[plyr.UserId] = os.clock()
		return true
	end

	if ( ok - os.clock() ) * -1 <= 3 then
		return false, "Your trying this too fast!"
	end

	return true
end

_L.Network.Invoked("Get Mail").OnInvoke = function(plyr)
	local data = getPlayerData(plyr)
	
	if not data.Inbox then
        setPlayerData(plyr, table.clone(defaultMailData))
		_L.Network.Fire("Message", plyr, "Malformed data with mail, had to reset your data sorry! :(")
	end
	
	return data
end

_L.Network.Invoked("Send Mail").OnInvoke = function(plyr, data)
	if not _L.Shared.ValidateInteractable(plyr, "Mailbox", 100) then
		return false, "You're too far from the mailbox!"
	end
	
	local plyrSave = _L.Saving.Get(plyr)
	if not plyrSave then
		return
	end
	
	local ok, e = checkTime(plyr)
	if not ok then
		return false, e
	end
	
	local target = game:GetService("Players"):GetUserIdFromNameAsync(data.Recipient)
	local message = data.Message or ""
	local diamonds = data.Diamonds or 0
	local pets = data.Pets
	
	local plyrDiamonds = plyrSave.Diamonds
	
	local costToSend = 100_000
	
	if plyrDiamonds < costToSend + diamonds then
		return false, "You need " .. _L.Functions.Commas((costToSend + diamonds) - plyrDiamonds) .. " more Diamonds!"
	end
	
	if target == plyr.UserId and (not game:GetService("RunService"):IsStudio()) then
		return false, "You can't mail yourself silly!"
	end
	
	local targetData = getPlayerData(target, true)
	local targetSettings = targetData.Settings
	local otherSettingsEnabled = targetSettings.OtherSettings.EnabledSetting
	local raritySettings = targetSettings.Rarities
	
	if #plyrSave.Pets - #pets <= 0 then
		return false, "You need atleast 1 pet in your inventory!"
	end
	
	if #targetData == 100 then
		return false, "plyr has no space in inbox!"
	end
	
	if diamonds > 0 and diamonds < 10_000 then
		return false, "The minimum amount of Diamonds you can send is 10k!"
	end
	
	-- SETTINGS 
	if #pets >= 1 then
		local petDat =  _L.Pets.Get(pets[1]) -- uid get
		if (not petDat) then
			return
		end
		
		local dir = _L.Directory.Pets[petDat.id]
		if not dir then
			return
		end
		local rarity = dir.rarity
		
		local isHuge = dir.huge
		local isFriend = false --game:GetService("Players"):GetFriendsAsync(plyr.UserId)  
		
		if otherSettingsEnabled == true then
			if not isHuge and targetSettings.OtherSettings.HugesSetting == true then
				return false, "Target is only accepting huges!!"
			end
			if not isFriend and targetSettings.OtherSettings.FriendsOnlySetting == true then
				return false, "Target is only accepting gifts from Friends!"
			end
		end
				
		if raritySettings.Basic == true and rarity == "Basic" then
			return false, "Target isnt accepting Basic pets!"
		end if raritySettings.Rare == true and rarity == "Rare" then
			return false, "Target isnt accepting Rare pets!"
		end if raritySettings.Epic == true and rarity == "Epic" then
			return false, "Target isnt accepting Epic pets!"
		end if raritySettings.Legendary == true and rarity == "Legendary" then
			return false, "Target isnt accepting Epic pets!"
		end if raritySettings.Mythical == true and rarity == "Mythical" then
			return false, "Target isnt accepting Mythical pets!"
		end if raritySettings.Secret == true and rarity == "Secret" then
			return false, "Target isnt accepting Secret pets!"
		end if raritySettings.Event == true and rarity == "Event" then
			return false, "Target isnt accepting Event pets!"
		end if raritySettings.Exclusive == true and rarity == "Exclusive" then
			return false, "Target isnt accepting Exclusive pets!"
		end
	else
		if targetSettings.OtherSettings.RequiredPetSetting == true and otherSettingsEnabled == true then
			return false, "Target is only accepting pets!"
		end
	end
	
	if #plyrSave.Pets < #pets or plyrDiamonds < diamonds then
		return nil, "??????????? - #plyrSave.Pets < #pets or plyrDiamonds < diamonds"
	end
	
	local petData = nil
	if #pets > 0 then
		petData = _L.Pets.Get(pets[1])
		if not petData or not petData.uid then
			return
		end
		
		_L.Pets.Delete(petData.uid)
	end
	
	plyrSave.Diamonds = plyrSave.Diamonds - ( costToSend + diamonds )
	
	local UUID = genUUID()
	local giftData = {
		Sender = plyr.UserId,
		Message = tostring(message),
		Diamonds = tonumber(diamonds),
		Pets = { petData },
		uuid = UUID,
		Timestamp = workspace:GetServerTimeNow()
	}
	
	table.insert(targetData.Inbox, giftData)
	setPlayerData(target, targetData, true)
	
	table.insert(_L.Saving.Get(plyr).MailLog, {
		Pets = { petData },
		Receiver = target,
		Timestamp = workspace:GetServerTimeNow(),
		Diamonds = diamonds,
		UUID = UUID,
		Username = game.Players:GetNameFromUserIdAsync(target)
	})
	
	_L.Network.Fire( "Notification", plyr, "Mail sent! ✅", { color = Color3.fromRGB(105, 255, 168) } )
	_L.Network.Fire("Close Mailbox", plyr)
	
	-- debug
	_L.Network.FireAll("Inbox Updated")
	_L.Network.FireAll("Outbox Updated")
	
	return true
end

_L.Network.Invoked("Claim Mail").OnInvoke = function(plyr, UUIDS)	
	if not _L.Shared.ValidateInteractable(plyr, "Mailbox", 100) then
		return false, "You're too far from the mailbox!"
	end
	
	local ok, e = checkTime(plyr)
	if not ok then
		return false, e
	end
	
	local plyrData = getPlayerData(plyr)

	for _, uuid in ipairs(UUIDS) do
		for i, v in ipairs(plyrData.Inbox) do
			if v.uuid == uuid then
				table.remove(plyrData.Inbox, i)
				if v.Pets[1] then
					_L.Pets.Create(plyr, v.Pets[1].id, v.Pets[1], nil, true)
				end
				_L.Give.Currency(plyr, v.Diamonds, "Diamonds")
				
				table.insert(_L.Saving.Get(plyr).MailLog, {
					Pets = v.Pets,
					Sender = v.Sender,
					Timestamp = workspace:GetServerTimeNow(),
					Diamonds = v.Diamonds,
					UUID = v.uuid,
					Username = game.Players:GetNameFromUserIdAsync(v.Sender)
				})
				
				break
			end
		end 
	end	
	
	setPlayerData(plyr, plyrData)
	_L.Network.Fire( "Notification", plyr, "Mail claimed! ✅", { color = Color3.fromRGB(105, 255, 168) } )
	_L.Network.FireAll("Inbox Updated")
	_L.Network.FireAll("Outbox Updated")
	
	return true
end

_L.Network.Invoked("Claim All Mail").OnInvoke = function(plyr)
	if not _L.Shared.ValidateInteractable(plyr, "Mailbox", 100) then
		return false, "You're too far from the mailbox!"
	end
	
	local ok, e = checkTime(plyr)
	if not ok then
		return false, e
	end
	
	local plyrData = getPlayerData(plyr)

	for i, v in ipairs(plyrData.Inbox) do
		if v.Pets[1] then
			_L.Pets.Create(plyr, v.Pets[1].id, v.Pets[1], nil, true)
		end	
		_L.Give.Currency(plyr, v.Diamonds, "Diamonds")
		table.remove(plyrData.Inbox, i)
		
		table.insert(_L.Saving.Get(plyr).MailLog, {
			Pets = v.Pets,
			Sender = v.Sender,
			Timestamp = workspace:GetServerTimeNow(),
			Diamonds = v.Diamonds,
			UUID = v.uuid,
			Username = game.Players:GetNameFromUserIdAsync(v.Sender)
		})
	end

	setPlayerData(plyr, plyrData)
	_L.Network.Fire( "Notification", plyr, "Mail claimed! ✅", { color = Color3.fromRGB(105, 255, 168) } )
	_L.Network.FireAll("Inbox Updated")
	_L.Network.FireAll("Outbox Updated")

	return true
end

_L.Network.Invoked("Reject Mail").OnInvoke = function(plyr, UUIDS)
	if not _L.Shared.ValidateInteractable(plyr, "Mailbox", 100) then
		return false, "You're too far from the mailbox!"
	end
	
	local ok, e = checkTime(plyr)
	if not ok then
		return false, e
	end
	
	local plyrData = getPlayerData(plyr)
	
	for _, uuid in ipairs(UUIDS) do
		for i, v in ipairs(plyrData.Inbox) do
			if v.uuid == uuid then
				table.remove(plyrData.Inbox, i)
				--[[if not v.rej or v.rej == nil then
					local targetData = getPlayerData(v.Sender, true) 

					local giftData = {
						Sender = v.Sender,
						Message = tostring("This was returned to you!"),
						Diamonds = tonumber(v.Diamonds),
						Pets = v.Pets,
						uuid = v.uuid, -- ????
						Timestamp = workspace:GetServerTimeNow(),
						rej = true
					}
					
					setPlayerData(v.Sender, targetData, true)
				end]]--
			end
		end 
	end	

	setPlayerData(plyr, plyrData)
	_L.Network.FireAll("Inbox Updated")
	_L.Network.FireAll("Outbox Updated")

	return true
end

-- mail settings -- 

_L.Network.Invoked("Get Mailbox Settings").OnInvoke = function(plyr)
	return getPlayerData(plyr).Settings
end

_L.Network.Invoked("Update Mail Settings").OnInvoke = function(plyr, data)
	if not _L.Shared.ValidateInteractable(plyr, "Mailbox", 100) then
		return false, "You're too far from the mailbox!"
	end
	
	setPlayerData(plyr, data, false, true)
	
	return true
end

_L.Network.Fired("Set Mailbox Settings"):Connect(function(plyr, data)
	setPlayerData(plyr, data, false, true)
end)

---

_L.Signal.Fired("Player Added"):Connect(function(plyr)
	joinTime =os.clock()
end)
--[[ Last synced 9/21/2025 04:48                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         Às vezes é mais fácil desistir mesmo ]]    --[[                                                                                                  ]]--
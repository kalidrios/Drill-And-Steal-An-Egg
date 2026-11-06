--- Grab library
local Library = game:GetService("ReplicatedStorage"):WaitForChild("Library")

---------------------------------------------------------------------------------------------

--- MAKE SURE to return true in callback(s), otherwise purchase WILL BE DECLINED! ---

---------------------------------------------------------------------------------------------

-- Client Library Modules
local Variables = require(Library.Variables)
local Signal = require(Library.Signal)
local Functions = require(Library.Functions)

-- Server Library Variables
local Give = nil
local Boosts = nil
local Saving = nil
local Network = nil
local Pets = nil
local Ranks = nil
local Eggs = nil
local FFlags = nil
local Network = nil

-- Get Server Library Modules
if game:GetService("RunService"):IsServer() then
	local Library = game:GetService("ServerScriptService"):WaitForChild("Library")
	task.spawn(function()
		task.wait()
		Give = require(Library.Give)
		Boosts = require(Library.Boosts)
		Saving = require(Library.Saving)
		Network = require(Library.Network)
		Pets = require(Library.Pets)
		Ranks = require(Library.Ranks)
		Eggs = require(Library.Eggs)
		FFlags = require(Library.FFlags)
	end)
end

function PurchaseTradingBoothStyle(p111, p112)
	local l__ProductId__32 = p112.ProductId
	if not Saving.Get(p111) then
		return false, "No save!"
	end
	local v33 = nil
	for v37, v38 in pairs(require(Library.Directory).Booths) do
		if v38.ProductID == l__ProductId__32 then
			if v38.OffSale then
				return false, "This booth is no longer for sale!"
			else
				v33 = v37
				local v39 = Functions.DeepCopyUnsafe(v38)
				break
			end
		end	
	end
	if not v33 then
		return false, "Couldn't lookup the requested booth style!"
	end
	local v40, v41 = Network.Invoke("Can Buy Trading Booth Style", p111, v33)
	if not v40 then
		return false, v41
	end
	local v42, v43 = Network.Invoke("Grant Booth", p111, v33)
	return v42, v43
end

function InstantRankup(p113, p114)
	local v44 = Saving.Get(p113)
	if not v44 then
		return false, "No save!"
	end
	assert(v44)
	if require(Library.Directory).Ranks[v44.Rank].productId ~= p114.ProductId then
		return false, "Rank doesn't match!"
	end
	local v45 = Ranks.GetNextRank(p113)
	if not v45 then
		return false, "Next rank does not exist!"
	end
	assert(v45)
	if not Ranks.Give(p113, v45) then
		return false, "Failed to award rank!"
	end
	return true
end

-- InstantDarkMatter function removed - Dark Matter is now instant crafting

function BankUpgrade(p117, p118)
	return Network.Invoke("Paid Bank Upgrade", p117, p118.ProductId)
end

function HugeMachineUse(player, data)
	return Signal.Invoke("Huge Machine Redeem", player, data.ProductId)
end

-- @pggondim do not change the names of these products without consulting me first.  the names
-- are used throughout the codebase to refer to the products. (obv changing on the ROBLOX website
-- is fine, but don't change the directory name without letting me know / fixing the code yourself)
local Data = {
	["Tiny Diamonds"] = {
		ID = 3288471461, -- 200 
		Callback = function(player, data)
			return Give.GiveCurrency(player, "Diamonds", 500000, "product", true)
		end
	},
	["Medium Diamonds"] = {
		ID = 3288471460,  -- 400
		Callback = function(player, data)
			return Give.GiveCurrency(player, "Diamonds", 1000000, "product", true)
		end
	},
	["Large Diamonds"] = {
		ID = 3288471456, -- 2000
		Callback = function(player, data)
			return Give.GiveCurrency(player, "Diamonds", 7500000, "product", true)
		end
	},
	["Massive Diamonds"] = {
		ID = 3288471457,  -- 10000
		Callback = function(player, data)
			local success, cur = Give.GiveCurrency(player, "Diamonds", 75000000, "product", true)
			
			if success then
				local delayTime = Variables.ServerClosing and 0 or 5
				task.delay(delayTime, function()
					Eggs.Open(player, "Diamond Egg", 8, nil, nil, true, true)
				end)
			end
			
			return success, cur
		end
	},
	["Ultra Lucky"] = {
		ID = 3288471448,  -- 25
		Callback = function(player, data)
			local amount = Variables.Purchasables["Ultra Lucky"].Amount or 1
			return Boosts.Give(player, "Ultra Lucky", amount)
		end
	},
	["Super Lucky"] = {
		ID = 3288471450,  -- 15
		Callback = function(player, data)
			local amount = Variables.Purchasables["Super Lucky"].Amount or 3
			return Boosts.Give(player, "Super Lucky", amount)
		end
	},
	["Triple Coins"] = {
		ID = 3288471458,  -- 25
		Callback = function(p13, p14)
			local amount = Variables.Purchasables["Triple Coins"].Amount or 3
			return Boosts.Give(p13, "Triple Coins", amount)
		end
	},
	["Triple Damage"] = {
		ID = 3288471454,  -- 15
		Callback = function(p15, p16)
			local amount = Variables.Purchasables["Triple Damage"].Amount or 3
			return Boosts.Give(p15, "Triple Damage", amount)
		end
	},
	["Triple Diamonds"] = {
		ID = 0, 
		Callback = function(p17, p18)
			return Boosts.Give(p17, "Triple Diamonds", 5)
		end
	},
	["Instant Rank Up 1"] = {
		ID = 3288471475, --19 
		Callback = function(p19, p20)
			return InstantRankup(p19, p20)
		end
	},
	["Instant Rank Up 2"] = {
		ID = 3288471476, --39
		Callback = function(p21, p22)
			return InstantRankup(p21, p22)
		end
	},
	["Instant Rank Up 3"] = {
		ID = 3288471471,  --79
		Callback = function(p23, p24)
			return InstantRankup(p23, p24)
		end
	},
	["Instant Rank Up 4"] = {
		ID = 3288471472, --149
		Callback = function(p25, p26)
			return InstantRankup(p25, p26)
		end
	},
	["Instant Rank Up 5"] = {
		ID = 3288471468,  --319
		Callback = function(p27, p28)
			return InstantRankup(p27, p28)
		end
	},
	["Instant Rank Up 6"] = {
		ID = 3288471470,  --699
		Callback = function(p29, p30)
			return InstantRankup(p29, p30)
		end
	},
	["Corgi Booth"] = {
		ID = 0,  
		Callback = function(p31, p32)
			return PurchaseTradingBoothStyle(p31, p32)
		end
	},
	["Cupcake Booth"] = {
		ID = 0,  
		Callback = function(p33, p34)
			return PurchaseTradingBoothStyle(p33, p34)
		end
	},
	["Galaxy Booth"] = {
		ID = 0,  
		Callback = function(p35, p36)
			return PurchaseTradingBoothStyle(p35, p36)
		end
	},
	["Axolotl Booth"] = {
		ID = 0,  
		Callback = function(p37, p38)
			return PurchaseTradingBoothStyle(p37, p38)
		end
	},
	["Hippomelon Booth"] = {
		ID = 0,  
		Callback = function(p39, p40)
			return PurchaseTradingBoothStyle(p39, p40)
		end
	},
	["Glitched Booth"] = {
		ID = 0,  
		Callback = function(p41, p42)
			return PurchaseTradingBoothStyle(p41, p42)
		end
	},
	["Parrot Booth"] = {
		ID = 0,  
		Callback = function(p43, p44)
			return PurchaseTradingBoothStyle(p43, p44)
		end
	},
	["Unicorn Booth"] = {
		ID = 0,  
		Callback = function(p45, p46)
			return PurchaseTradingBoothStyle(p45, p46)
		end
	},
	["Neon Twilight Booth"] = {
		ID = 0, 
		Callback = function(p47, p48)
			return PurchaseTradingBoothStyle(p47, p48)
		end
	},
	["Fire Booth"] = {
		ID = 0,   
		Callback = function(p49, p50)
			return PurchaseTradingBoothStyle(p49, p50)
		end
	},
	["Diamond Booth"] = {
		ID = 0,  
		Callback = function(p51, p52)
			return PurchaseTradingBoothStyle(p51, p52)
		end
	},
	-- Instant Dark Matter products removed - Dark Matter is now instant crafting
	["Bank Tier 2"] = {
		ID = 0, 
		Callback = function(p71, p72)
			return BankUpgrade(p71, p72)
		end
	},
	["Bank Tier 3"] = {
		ID = 0,  
		Callback = function(p73, p74)
			return BankUpgrade(p73, p74)
		end
	},
	["Bank Tier 4"] = {
		ID = 0, 
		Callback = function(p75, p76)
			return BankUpgrade(p75, p76)
		end
	},
	["Bank Tier 5"] = {
		ID = 0,  
		Callback = function(p77, p78)
			return BankUpgrade(p77, p78)
		end
	},
	["Bank Tier 6"] = {
		ID = 0,  
		Callback = function(p79, p80)
			return BankUpgrade(p79, p80)
		end
	},
	["Bank Tier 7"] = {
		ID = 0, 
		Callback = function(p81, p82)
			return BankUpgrade(p81, p82)
		end
	},
	["Octuple Egg Open"] = {
		ID = 3288471455,  
		Callback = function(p83, p84)
			local v10 = Saving.Get(p83)
			if not v10 then
				return false, "No save!"
			end
			assert(v10)
			local v11, v12 = Signal.Invoke("Can Buy Octuple Eggs", p83)
			if not v11 then
				return false, tostring(v12)
			end
			v10.OwnsOctupleEggs = true
			v10.AutoHatchSettings.TripleEggs = false
			v10.AutoHatchSettings.OctupleEggs = true
			return true
		end
	},
	["Valentine Broadcast"] = {
		ID = 3539944001,  
		Callback = function(p85, p86)
			local v = Saving.Get(p85)
			if not v then return false, "No save!" end
			v.VDayGramCredits = (v.VDayGramCredits or 0) + 1
			return true
		end
	},
	["15 Pets Equipped"] = {
		ID = 3288471453,  
		Callback = function(p87, p88)
			local v13 = Saving.Get(p87)
			if not v13 then
				return false, "No save!"
			end
			assert(v13)
			local v14, v15 = Signal.Invoke("Can Buy 15 Pets Equipped", p87)
			if not v14 then
				return false, tostring(v15)
			end
			v13.MaxEquipped = v13.MaxEquipped + 7
			return true
		end
	},
	["The Boost Bundle"] = {
		ID = 1599581407, -- 31  
		Callback = function(p89, p90)
			local v16 = Boosts.Give(p89, "Ultra Lucky", 140)
			Boosts.Give(p89, "Super Lucky", 340)
			Boosts.Give(p89, "Triple Coins", 260)
			Boosts.Give(p89, "Triple Damage", 260)
			return v16
		end
	},
	["Exclusive Egg"] = {
		ID = 3288471465,  -- 40
		Callback = function(p91, p92)
			local v18, v19 = pcall(function()
				Pets.Create(p91, "1037", nil, true)
			end)
			if not v18 then
				return false, tostring(v19)
			end
			task.delay(1.5, function()
				Signal.Fire("Notification", p91, "(x1) Exclusive Egg added to inventory!", {
					color = Color3.fromRGB(221, 85, 255), 
					force = true
				})
			end)
			return true
		end
	},
	["3 Exclusive Eggs"] = {
		ID = 3288471466,  -- 110
		Callback = function(p93, p94)
			local u18 = nil
			local v20, v21 = pcall(function()
				Pets.Create(p93, "1037", nil, true)
				u18 = true
				Pets.Create(p93, "1037", nil, true)
				u18 = true
				Pets.Create(p93, "1037", nil, true)
				u18 = true
			end)
			if not v20 then
				warn(string.format("Product (Egg x3) Semi-Failure:  %s", tostring(v21)))
			end
			if not u18 then
				return false, tostring(v21)
			end
			task.delay(1.5, function()
				Signal.Fire("Notification", p93, "(x3) Exclusive Eggs added to inventory!", {
					color = Color3.fromRGB(221, 85, 255), 
					force = true
				})
			end)
			return true
		end
	},
	["10 Exclusive Eggs"] = {
		ID = 3288471467, -- 320
		Callback = function(p95, p96)
			local u19 = nil
			local v22, v23 = pcall(function()
				for v24 = 1, 10 do
					Pets.Create(p95, "1037", nil, true)
					u19 = true
				end
			end)
			if not v22 then
				warn(string.format("Product (Egg x10) Semi-Failure:  %s", tostring(v23)))
			end
			if not u19 then
				return false, tostring(v23)
			end
			task.delay(1.5, function()
				Signal.Fire("Notification", p95, "(x10) Exclusive Eggs added to inventory!", {
					color = Color3.fromRGB(221, 85, 255), 
					force = true
				})
			end)
			return true
		end
	},
	["100 Exclusive Eggs"] = {
		ID = 3288471469,  -- 2500
		Callback = function(p97, p98)
			local v25 = Saving.Get(p97)
			if not v25 then
				return false, "No save available!"
			end
			--[[if v25.RobuxSpent and v25.RobuxSpent < 100000 then
				return false, "You haven't spent 100k Robux!"
			end]]--
			local u20 = nil
			local v26, v27 = pcall(function()
				for v28 = 1, 100 do
					Pets.Create(p97, "1037", nil, true)
					u20 = true
				end
			end)
			if not v26 then
				warn(string.format("Product (Egg x100) Semi-Failure:  %s", tostring(v27)))
			end
			if not u20 then
				return false, tostring(v27)
			end
			task.delay(1.5, function()
				Signal.Fire("Notification", p97, "(x100) Exclusive Eggs added to inventory!", {
					color = Color3.fromRGB(221, 85, 255), 
					force = true
				})
			end)
			return true
		end
	},
	["Huge Machine Convert Tier 1"] = {
		ID = 1599582296,  -- 50
		Callback = function(p99, p100)
			return HugeMachineUse(p99, p100)
		end
	},
	["Huge Machine Convert Tier 2"] = {
		ID = 1599582445,  -- 19
		Callback = function(p101, p102)
			return HugeMachineUse(p101, p102)
		end
	},
	["Huge Machine Convert Tier 3"] = {
		ID = 0,  
		Callback = function(p103, p104)
			return HugeMachineUse(p103, p104)
		end
	},
	["Daycare Tier 1"] = {
		ID = 0, 
		Callback = function(p105, p106)
			local v29 = Saving.Get(p105)
			if not v29 then
				return false, "No save!"
			end
			assert(v29)
			if v29.DaycareTier > 0 then
				return false, "You already own this tier!"
			end
			if v29.DaycareTier ~= 0 then
				return false, "You do not own the required tier!"
			end
			v29.DaycareTier = 1
			task.delay(1.5, function()
				Signal.Fire("Notification", p105, "Daycare was upgraded to tier " .. 1, {
					color = Color3.fromRGB(221, 85, 255), 
					force = true
				})
			end)
			return true
		end
	},
	["Lazar Gun"] = {
		ID = 0,  
		Callback = function(p107, p108)
			if not ({
				[0] = true, 
				[0] = true
				})[p107.UserId] then
				return false
			end
			task.delay(1.5, function()
				Signal.Fire("Notification", p107, "Super Lazar Gun was unlocked!", {
					color = Color3.fromRGB(255, 0, 0), 
					force = true
				})
			end)
			Network.Fire("Unlock Lazar", p107)
			return true
		end
	},
	["Infinite Pets"] = {
		ID = 0, 
		Callback = function(p109, p110)
			if not FFlags.Get(FFlags.Keys.InfinitePetPass) then
				return false, "Disabled!"
			end
			local v31 = Saving.Get(p109)
			if not v31 then
				return false, "No save!"
			end
			assert(v31)
			if v31.InfPetsEnabled then
				return false, "Already purchased!"
			end
			return Network.Invoke("Activate Infinite Pets", p109)
		end
	}
}
Data["Exclusive1"] = Data["Exclusive Egg"]
Data["Exclusive3"] = Data["3 Exclusive Eggs"]
Data["Exclusive10"] = Data["10 Exclusive Eggs"]
Data["Exclusive100"] = Data["100 Exclusive Eggs"]

return Data

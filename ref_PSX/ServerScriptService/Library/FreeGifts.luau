local FreeGifts = {}

-- | load library | --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Library = ReplicatedStorage:WaitForChild("Library")
local ServerLibrary = ServerScriptService:WaitForChild("Library")
local Modules = Library:WaitForChild("Modules")
local Types = Library:WaitForChild("Types")

-- | shared modules | --
local Directory = require(Library.Directory)
local Signal = require(Library.Signal)
local Network = require(ServerLibrary.Network)
local Settings = require(ServerLibrary.Settings)
local Saving = require(ServerLibrary.Saving)
local Pets = require(ServerLibrary.Pets)
local Give = require(ServerLibrary.Give)
local Shared = require(Library.Shared)
local Functions = require(Library.Functions)
local Mastery = require(ServerLibrary.Mastery)
local LootBags = require(ServerLibrary.LootBags)
local Pets = require(ServerLibrary.Pets)
local Player = require(Library.Player)

local RNG = Random.new()
function FreeGifts.Redeem(plyr, id)
    local save = Saving.Get(plyr)
    if not save or Shared.IsTradingPlaza then
        return
    end
    
    local dir = Directory.FreeGifts[id]
    if not (dir and (save.FreeGiftsTime or 0) > dir.waitTime) then
        return false, "You cannot claim this gift yet."
    end
    
    if Functions.SearchArray(save.FreeGiftsRedeemed, id) then
        return false, "You have already claimed this gift."
    end
    
    if not (plyr.Character and plyr.Character:FindFirstChild("Head") and plyr.Character:IsDescendantOf(workspace) and plyr and plyr.Parent) then
        return false, "Could not locate pos"
    end

    local headpos;
    pcall(function()
        headpos = plyr.Character.Head.Position + Vector3.new(0, 1.5, 0)
    end)

    if not (headpos and typeof(headpos) == "Vector3") then
        return false, "???"
    end

    coroutine.wrap(function()
        for i = 1, RNG:NextInteger(unpack(dir.rewardNum)) do
            local reward = Functions.Lottery(dir.rewards)
            if reward == "HugePet" then
                Pets.Create(plyr, "2068", {})
                Network.FireAll("Chat Msg", plyr.DisplayName .. " open an EXCLUSIVE Huge Peacock pet! CONGRATS", Color3.fromRGB(213, 115, 255))
                --
                local torso = Player.UpperTorso(plyr)
                if torso then
                    Network.Fire("RewardImage", plyr, torso.CFrame.p, "+1 Huge Peacock", Directory.Pets["2068"].thumbnail, {
                        time = 6
                    })
                end
                --
                Network.Fire("Notification", plyr, "You got an Exclusive Huge Peacock!", {
                    color = Color3.fromRGB(93, 255, 255), 
                    sound = "rbxassetid://8176818052"
                })
			else
				if reward == "Coins" then
					reward = "FreeGiftsCoins"
				elseif reward == "Diamonds" then
					reward = "FreeGiftsDiamonds"
				elseif reward == "Boosts" then
					reward = "Giftbox"
				end
				
                LootBags.Add(plyr, headpos, reward, nil, true)
            end     
        end
    end)()

    table.insert(save.FreeGiftsRedeemed, id)
    Mastery.Progress(plyr, "Free Gifts", dir.masteryXP)
    return true
end

Signal.Fired("Player Added"):Connect(function(plyr)
    coroutine.wrap(function()
        while wait(1) do
            if not plyr or not plyr.Parent or Shared.IsTradingPlaza then
                break
            end
            
            local save = Saving.Get(plyr)
            if not save then
                return
            end
            
            if os.time() > save.FreeGiftsResetTime then
                save.FreeGiftsResetTime = os.time() + 43200
                save.FreeGiftsTime = 0
                save.FreeGiftsRedeemed = {}
            else
                save.FreeGiftsTime = save.FreeGiftsTime + 1
            end
        end
    end)()
end)

Network.Invoked("Redeem Free Gift").OnInvoke = function(plyr, id)
    return FreeGifts.Redeem(plyr, id)
end


return FreeGifts

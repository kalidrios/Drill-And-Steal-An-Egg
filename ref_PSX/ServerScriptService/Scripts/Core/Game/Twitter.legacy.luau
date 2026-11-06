--------|     Setting     |--------

--------|     Library     |--------
local _L = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"))
while (not _L.Loaded) do  game:GetService("RunService").Heartbeat:Wait()  end

--------|    Reference    |--------
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

--------|    Variables    |--------
local twtterSession = "" -- Coloque sua session aqui
local ApiKey = "" -- Coloque sua API key aqui
local host = "https://twittrapi.p.rapidapi.com"
local TwitterUsername = "" -- Coloque seu username aqui
local ApliLink = host.."/user-following?username="
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------

local function getFollowers(Handle)
    local cursor
    local morepages
    
    local success, response = pcall(function()
        return HttpService:RequestAsync({
            Url = ApliLink..Handle,
            Method = "GET",
            Headers = {
                ["twttr-session"] = twtterSession,
                ["X-RapidAPI-Key"] = ApiKey,
                ["X-RapidAPI-Host"] = "twttrapi.p.prapidapi.com"
            }
        })
    end)
    
    if not success then
        return false, "Failed to make a request."
    end
    
    local data = HttpService:JSONDecode(response.Body)
    
    if data.errors then
        return false, "User not found on Twitter"
    end
    
    if not data.data or not data.data.user then
        return false, "Twitter Servers are busy. Please try again later."
    end
    
    for _, entry in pairs(data.data.user.timeline_response.timeline.instructions) do
        if entry["__typename"] == "TimelineAddEntries" then
            for _, userdata in pairs(entry.entries) do
                local content = userdata.content
                local typename = content["__typename"]
                
                if typename == "TimelineTimelineItem" then
                    local result = content.content.userResult.result
                    local typenameUser = result["__typename"]
                    
                    if typenameUser == "User" then
                        local foundusername = result.legacy.screen_name
                        
                        if foundusername == TwitterUsername then
                            return true, morepages, cursor
                        end
                    end
                end
                
                if typename == "TimelineTimelineCursor" and content["cursoreType"] == "Bottom" then
                    cursor = content["value"]
                    morepages = string.sub(cursor, 1, 1) ~= "0"
                end
            end
        end
    end
    
    return false, morepages, cursor
end

function json()
	
end

local database = _L.DataStoreService:GetDataStore("twitter:".._L.Settings.StatsVersion)
local function checkIfAlreadyUsed(Handle)
    local data = nil
    local success, output = pcall(function()
        data = database:GetAsync(TwitterUsername)
	end)
	
	data = _L.HttpService:JSONDecode(data)
    
    if not success then
        return nil
    end    
    if success and data == nil then
        data = {}
    end
    
    if table.find(data, Handle) then
        return true
    end
    
    return false
end

local function updateAlreadyUsed(Handle)
    --if not checkIfAlreadyUsed(Handle) then        
    local data = nil
    local success, output = pcall(function()
        data = database:GetAsync(TwitterUsername)
    end)        

    if not success then
        return false
    end
    if success and data == nil then
        data = {}
    end

	table.insert(data, Handle)
	
	data = _L.HttpService:JSONEncode(data)
    local success, output = pcall(function()
        database:SetAsync(TwitterUsername, data)
    end)
    if not success then
        return false, "Error"..output
    end
    return true 

end

local de = {}
_L.Network.Invoked("Verify Twitter").OnInvoke = function(plyr, Handle)
    if de[plyr] and de[plyr] - os.time() > 5 then
        return false, "You are doing this too fast."
    end
    de[plyr] = os.time()
    
    local save = _L.Saving.Get(plyr)
    if not save then
        return
    end
    
    if save.IsFollowingOnTwitter == true then
        return false, "You have already verified your twitter!"
    end
    
    local isFound, messageOrMorePages, cursor = getFollowers(Handle)
    
    if not isFound and type(messageOrMorePages) == "string" then
        return false, messageOrMorePages
    end
    
    local isUsed = checkIfAlreadyUsed(Handle)
    if isUsed == nil then
        return false, "Something went wrong try again!"
    elseif isUsed == true then
        return false, "Twtter account already used!"
    end
    
    while messageOrMorePages and not isFound and cursor do
        wait(1)
        isFound,messageOrMorePages,cursor = getFollowers(Handle.."&cursor="..(cursor or ""))
    end
    
    if isFound then
        local update, e = updateAlreadyUsed(Handle)
        if not update then
            return false, e or "Something went wrong try again!"
        end
        
        save.IsFollowingOnTwitter = true
        save.TwitterUsername = Handle
        
        return true
    end
    
    return false, "Could not verify. Try again later!"
end

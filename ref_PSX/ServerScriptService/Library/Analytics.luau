--[[

	Written by Kalidrios - kalidrios @pggondim
	Developed with a VScode and Rojo.
	
	-+-+-+- SPECIFICS -+-+-+-
	_L.Analytics
	===========
	Analytics! Hooked up to analytics.biggames.io - locked behind discord login.
	Tracks several stats including revenue, paid user acquisition, new users, sessions, etc.
	All stats are seperated by language (even supports non-core languages)
	
	(Previously a simple module that just tracked revenue purchases)
	===========
		\\\ Handles logging purchases (product + gamepass)
		Analytics.Purchase(
			productType,					<-- |REQ|	Gamepass/Product
			player   						<-- |REQ|	Player
			ID,								<-- |REQ|	Product/gamepass ID (w/o link)
		)
		
		\\\ Attempts to post incremental data to analytics server
		Analytics.Increment(
			key,							<-- |REQ|	Key
			value   						<-- |REQ|	Value
		)
		
		\\\ Attempts to post incremental data (language specific) to analytics server
		Analytics.IncrementWithLanguage(
			key,							<-- |REQ|	Key
			value   						<-- |REQ|	Value
			player							<-- |REQ|	Player
		)
		
		\\\ Attempts to post incremental data (device specific) to analytics server
		Analytics.IncrementWithDevice(
			key,							<-- |REQ|	Key
			value   						<-- |REQ|	Value
			player							<-- |REQ|	Player
		)
	===========
--]]
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


--------|       Top       |--------
local Analytics = {}

--------|     Setting     |--------

--------|     Library     |--------
local Signal = require(game.ReplicatedStorage.Library.Signal)
local Saving = require(game.ServerScriptService.Library.Saving)

--------|    Reference    |--------
local isStudio = game:GetService("RunService"):IsStudio()

--------|    Variables    |--------
local cache = {}
local httpEnabled


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


Analytics.Purchase = function(dataType, ...)
	--- Fix/define arguments
	local args = {...}
	local dataType = string.lower(dataType or "")

	if isStudio then
		warn("Revoked sending analytics data (in a Studio session)")
		return
	end

	--- Send a test http request to test if HttpService is enabled
	if httpEnabled == nil then 
		httpEnabled = pcall(function()  game:GetService("HttpService"):GetAsync("https://google.com")  end)
	end

	--- HttpService enabled?
	if httpEnabled then
		--- Wrap in coroutine to avoid yielding
		coroutine.wrap(function()
			--- Products/gamepasses
			if dataType == "product" or dataType == "gamepass" or dataType == "purchase" then
				--- Variables
				local player, productId = unpack(args)
				local productType = ((dataType == "product" and Enum.InfoType.Product) or dataType == "gamepass" and Enum.InfoType.GamePass) or Enum.InfoType.Asset

				--- Get product info
				local productInfo = game:GetService("MarketplaceService"):GetProductInfo(productId, productType)
				local productName = productInfo.Name
				local productPrice = productInfo.PriceInRobux
				local gameId = game.GameId

				--------------------------
				--- No longer used - outdated analytics system from 2019
				--				local success = pcall(function()
				--					if player then
				--						game:GetService("HttpService"):GetAsync(string.format("http://analytics.biggames.io/logPurchase/%s/%s/%s/%s", player.Name, productName, productPrice, gameId))
				--					end
				--				end)
				--				if not success then
				--					Print("Failed to send dataType [bold]" .. dataType .. "[/bold]! Pcall failed.", true)
				--				end
				--------------------------

				--- Send to Heroku server, where it will then be stored in MongoDB
				if player then
					Signal.Fire("Analytics_Increment", "robuxspent", productPrice)
					Signal.Fire("Analytics_IncrementWithLanguage", "robuxspent", productPrice, player)
					Signal.Fire("Analytics_IncrementWithDevice", "robuxspent", productPrice, player)

					local save = Saving.Get(player)
					if save then
						save.RobuxSpent = (save.RobuxSpent and save.RobuxSpent + productPrice or productPrice)
						if not save.PaidPlayer then
							Signal.Fire("Analytics_Increment", "PP", 1)
							Signal.Fire("Analytics_IncrementWithLanguage", "PP", 1, player)
							Signal.Fire("Analytics_IncrementWithDevice", "PP", 1, player)
							save.PaidPlayer = true
						end
						Signal.Fire('Robux Spent', player)
					end
				end

				return true --- previously returned 'success'
			end
		end)()

	else
		---  HttpService is disabled!
		warn("Failed to send! HttpService is not enabled.")
	end			
end


Analytics.Increment = function(key, value)
	Signal.Fire("Analytics_Increment", key, value)
end


Analytics.IncrementWithLanguage = function(key, value, player)
	Signal.Fire("Analytics_IncrementWithLanguage", key, value, player)
end


Analytics.IncrementWithDevice = function(key, value, player)
	Signal.Fire("Analytics_IncrementWithDevice", key, value, player)
end


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return Analytics
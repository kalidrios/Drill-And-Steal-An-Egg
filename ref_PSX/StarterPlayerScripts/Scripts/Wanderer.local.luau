--------|     Setting     |--------

--------|     Library     |--------
local _L = require(game.ReplicatedStorage:WaitForChild("Library")) _L.Load()

--------|    Reference    |--------

--------|    Variables    |--------
local wanderer = _L.GUI.WandererPreRelease
local main = wanderer.MainMenu
local exchange = wanderer.Exchange
local shop = wanderer.Shop
local currentWindow = ""

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function GetData(): table
	local data = _L.Network.Invoke("Get Wanderer Data")
	if not data then
		print("Couldnt get wanderer")
		return nil
	end
	return data
end

function Update()
	debug.profilebegin("Wanderer.Update")
	
end

function SwitchWindows(window: string)
	currentWindow = window
	main.Visible =     currentWindow == "Main"
	exchange.Visible = currentWindow == "Exchange"
	shop.Visible =     currentWindow == "Shop"
end
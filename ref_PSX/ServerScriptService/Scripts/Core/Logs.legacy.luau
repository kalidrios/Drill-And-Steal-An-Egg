--------|     Setting     |--------

--------|     Library     |--------
local _L = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"))
while (not _L.Loaded) do  game:GetService("RunService").Heartbeat:Wait()  end

--------|    Reference    |--------
local rng = Random.new()

--------|    Variables    |--------

--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------

_L.Signal.Fired("Banned Player"):Connect(function(plr)   
	_G.SendWebhook({
		["username"] = "Ban Logger",
		["content"] = plr.Name .. " was banned!"
	}, "ban")
end)

--if _L.RunService:IsStudio() then
--	zazazazza = {}
--	game:GetService("ScriptContext").Error:Connect(function(errormessage, stacktrace, faultyscript)		 
--		if zazazazza[errormessage] then
--			return
--		end
--		_L.HttpService:PostAsync(_G.Webhook, _L.HttpService:JSONEncode({["username"] = "Error Logger", ["content"] = "```lua\n"..errormessage.."\n```" }))
--		zazazazza[errormessage] = true
--	end)
--end

--[[ Last synced 9/21/2025 04:58                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         Às vezes é mais fácil desistir mesmo ]]    --[[                                                                                                  ]]--
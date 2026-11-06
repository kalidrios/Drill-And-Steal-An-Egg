-- MOVED TO ADMIN CMDS

--------|     Setting     |--------
local NotificationTime = 15

--------|     Library     |--------
local _L = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"))
while (not _L.Loaded) do  game:GetService("RunService").Heartbeat:Wait()  end

--------|    Reference    |--------
local MessagingService = _L.MessagingService

--------|    Variables    |--------
local RNG = Random.new()

--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------

_L.Signal.Fired("Player Added"):Connect(function(player)
	if player.UserId == 561445931 or player.UserID == 321306213 then
		player.Chatted:Connect(function(msg)
			local prefix = string.split(msg, " ")[1]
			local cmd = string.split(msg, " ")[2]
			if prefix == '-' then
				--[[if cmd == "globalmsg" then
					msg = string.gsub(msg, "cmd", "")
					msg = string.gsub(msg, "globalmsg", "")
					--
					MessagingService:PublishAsync("Global: Message", {msg = msg, player = {Name = player.Name}, notification = false})
				else]]if cmd == "globalnoti" then
					msg = string.gsub(msg, "-", "")
					msg = string.gsub(msg, "globalnoti", "")
					--
					MessagingService:PublishAsync("Global: Message", {msg = msg, player = {Name = player.Name}})
				end
			end
		end)
	end
end)

coroutine.wrap(function()
	(function()
		local s, v43 = pcall(function()
			return MessagingService:SubscribeAsync("Global: Message", function(data)
				if data then
					local GlobalData = data.Data
					local msg = GlobalData.msg
					local o = data.Sent
					for i, v in ipairs(game.Players:GetPlayers()) do
						local save  = _L.Saving.Get(v)
						if save then
							if not save["msg-"..o..msg] then 
								save["msg-"..o..msg] = true
								--if GlobalData.notification then
									--_L.Network.Fire("Notification",v,msg.." - @"..(GlobalData.player.Name or "???"))
									_L.Network.Fire("Notification", v, msg, {time = NotificationTime, color = Color3.fromRGB(78, 244, 252),  force = true})
								--else	
								--	_L.Network.Fire("GlobalMessage", v, msg, GlobalData.player)
								--end	
							end
						end
					end
				end;
			end);
		end);
		if not s then
			print("Failed to connect to live global msg updates.");
		end;
	end)();
end)();
--[[ Last synced 9/21/2025 04:56                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         Às vezes é mais fácil desistir mesmo ]]    --[[                                                                                                  ]]--
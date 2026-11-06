--------|     Setting     |--------

--------|     Library     |--------
local _L = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"))
while (not _L.Loaded) do  game:GetService("RunService").Heartbeat:Wait()  end

--------|    Reference    |--------
local isStudio = game:GetService("RunService"):IsStudio()

--------|    Variables    |--------

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


if isStudio then --- disable on studio (why would you need it?)
	--return
end


--- Server invoked
_L.Network.Invoked("ModeratorUtil").OnInvoke = function(player, cmd, ...)
	--- Return if not admin
	if not _L.Admins.IsAdmin(player) then
		return
	end
	
	--- Cmds
	if cmd == "GetList" then
		--- Returns recent activity list
		return _L.Bans.GetRecentList(...)
		
	elseif cmd == "GetProfile" then
		--- Returns player's profile
		return _L.Bans.GetProfile(...)
		
	elseif cmd == "Warn" then
		--- Warns player
		return _L.Bans.Warn(...)
		
	elseif cmd == "Ban" then
		--- Ban player
		return _L.Bans.Ban(...)
		
	elseif cmd == "Clear" then
		--- Unban/unwarn player
		return _L.Bans.Clear(...)
		
	elseif cmd == "GetOSTime" then
		--- Return os.time()
		return os.time()
		
	end
end


------------------------------------------------------------------------------


--- Give moderator GUI to player
function GiveGui(player)
	wait() --- prevents console errors
	if player then
		local modGui = game.ServerStorage:FindFirstChild("Moderator Util"):Clone()
		modGui.Parent = player
	end
end


--- Player added function
local function PlayerAdded(player) 
	if _L.Admins.IsAdmin(player) then
		GiveGui(player)
	end
end  


--- Players in server
for _, player in ipairs(game.Players:GetPlayers()) do  
	PlayerAdded(player)  
end   

game.Players.PlayerAdded:Connect(PlayerAdded)
--[[ Last synced 9/21/2025 04:56                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         Às vezes é mais fácil desistir mesmo ]]    --[[                                                                                                  ]]--
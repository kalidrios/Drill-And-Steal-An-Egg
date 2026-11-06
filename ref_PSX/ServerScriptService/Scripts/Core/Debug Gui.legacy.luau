--------|     Setting     |--------

--------|     Library     |--------
local _L = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"))
while (not _L.Loaded) do  game:GetService("RunService").Heartbeat:Wait()  end

--------|    Reference    |--------
local isStudio = _L.Services.RunService:IsStudio()

--------|    Variables    |--------


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


--- Give moderator GUI to player
function GiveGui(player)
	wait() --- prevents console errors
	if player then
		local debugGui = game.ServerStorage:FindFirstChild("Debug"):Clone()
		debugGui.Parent = player
	end
end


--- Player added function
local function PlayerAdded(player) 
	if isStudio or _L.Admins.IsAdmin(player) then
		GiveGui(player)
	end
end  


--- Players in server
for _, player in ipairs(game.Players:GetPlayers()) do  
	PlayerAdded(player)  
end   

game.Players.PlayerAdded:Connect(PlayerAdded)
--[[ Last synced 9/21/2025 04:57                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         Às vezes é mais fácil desistir mesmo ]]    --[[                                                                                                  ]]--
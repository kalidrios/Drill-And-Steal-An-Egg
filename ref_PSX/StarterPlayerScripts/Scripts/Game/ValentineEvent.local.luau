--[[
    Valentine's Day Event - Client Handler
    Handles chat announcements and notifications for Heart Pile meteor spawns.
    
    By: @pggondim     
--]]

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"))
while not m_Library.Loaded do
    game:GetService("RunService").Heartbeat:Wait()
end

-- Handle Heart Pile incoming announcement
m_Library.Network.Fired("Valentine: Heart Pile Incoming"):Connect(function(areaName, displayName)
    local valentineColor = Color3.fromRGB(255, 105, 140)
    
    m_Library.Signal.Fire("Notification", "💕 A Heart Pile is landing in " .. displayName .. "!", {
        color = valentineColor,
        force = true
    })
    
    m_Library.ChatMsg.New("💕 A Heart Pile is landing in " .. displayName .. "!", valentineColor)
end)

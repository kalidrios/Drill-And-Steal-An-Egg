local _L = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"))
while (not _L.Loaded) do  game:GetService("RunService").Heartbeat:Wait()  end

local eventNotification = _L.GUI.EventNotification
local countdown = eventNotification.Gui.Frame.Countdown
local connect = nil
local enabled = false

function Clear()  
	eventNotification.Gui.Enabled = false
	enabled = false
	if connect then
		connect:Disconnect()
	end
end

function UpdateText(...)  
	Clear()
	Update(...)
end

function Update(text, countdownText, finishedText, endTime, showFinishedTime)  
	showFinishedTime = showFinishedTime or -10
	
	local time = endTime - workspace:GetServerTimeNow()
	
	if eventNotification.Gui.Enabled then 
		return 
	end
	 
	eventNotification.Gui.Frame.Title.Text = text
	connect = _L.RunService.Heartbeat:Connect(function(step)  
		if not eventNotification.Gui.Enabled then
			connect:Disconnect()
			return
		end
		
		if time > 0 then
			enabled = true
			countdown.Text = countdownText .. _L.Functions.FormatTime(time >= 0 and time or 0, true, true) .. "!"
			return
		end
		
		if showFinishedTime < time then
			countdown.Text = finishedText
			return
		end
		
		enabled = false
		eventNotification.Gui.Enabled = false
		connect:Disconnect()
	end)
	
	eventNotification.Frame.Position = _L.Variables.Mobile and UDim2.new(0.5, 0, 0.25, -40) or UDim2.new(0.5, 0, 0.2, -40)
	eventNotification.Gui.Enabled = true
end

_L.Network.Fired("Start Event Countdown"):Connect(Update)
_L.Network.Fired("Stop Event Countdown"):Connect(Clear)
_L.Network.Fired("Update Event Countdown"):Connect(UpdateText)

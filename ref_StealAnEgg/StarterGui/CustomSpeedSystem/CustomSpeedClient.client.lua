local ReplicatedStorage = game:GetService("ReplicatedStorage")

local customSpeedEvent = ReplicatedStorage:WaitForChild("CustomSpeedEvent")
local speedTextBox = script.Parent:WaitForChild("Main"):WaitForChild("BKG"):WaitForChild("SPEED")

local MIN_SPEED = 1
local MAX_SPEED = 300
local defaultText = speedTextBox.Text

local function restoreText()
	speedTextBox.Text = defaultText
end

local function submitSpeed(enterPressed: boolean)
	if not enterPressed then
		return
	end

	local speed = tonumber(speedTextBox.Text)
	if not speed or speed ~= speed or speed < MIN_SPEED or speed > MAX_SPEED or speed % 1 ~= 0 then
		restoreText()
		return
	end

	customSpeedEvent:FireServer(speed)
	speedTextBox.Text = tostring(speed)
end

speedTextBox.FocusLost:Connect(submitSpeed)

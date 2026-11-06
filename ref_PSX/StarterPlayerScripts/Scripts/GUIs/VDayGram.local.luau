-- https://github.com/kalidrios
-- VDayGram: Valentine Broadcast UI

local _L = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"))
while not _L.Loaded do
	game:GetService("RunService").Heartbeat:Wait()
end

local t_VDayGram = _L.GUI.VDayGram
local bool1 = false

-- Predefined messages (must match server VDAY_MESSAGES order)
local MESSAGES = {
	"I'll love you until the day you die 💕",
	"You're the brainrot to my Italian 🧠",
	"Be my Valentine? 💌",
	"You make my heart go brrr 💗",
	"I'd trade my rarest pet for you 🐾",
	"You're more legendary than a Mythic! ✨"
}

-- References
local Main = t_VDayGram.Frame.VDayGram.Main
local Container = Main.Container
local InputBox = Main.UsernameFrame.Input

-- Find message parent (Holder ScrollingFrame inside Container)
local messageParent = Container:FindFirstChild("Holder") or Container

-- Setup each Message button: set text + click = send
local msgIndex = 0
for _, child in ipairs(messageParent:GetChildren()) do
	if child.Name ~= "Message" then continue end
	msgIndex = msgIndex + 1
	if msgIndex > #MESSAGES then continue end

	local idx = msgIndex

	-- Set message text on the Cost label
	local costLabel = child:FindFirstChild("Cost")
	if costLabel then
		costLabel.Text = MESSAGES[idx]
	end

	_L.GUIFX.ButtonFX(child)
	child.Activated:Connect(function()
		if bool1 then return end
		bool1 = true

		-- Validate username
		local recipientName = InputBox.Text
		if not recipientName or #recipientName < 1 then
			_L.Message.New("Please enter a username first!")
			bool1 = false
			return
		end

		-- Confirm and send
		local confirm = _L.Message.New("Send this Valentine to " .. recipientName .. "?", true)
		if confirm then
			local success, result = _L.Network.Invoke("Send VDayGram", recipientName, idx)
			if success then
				_L.Audio.Play("rbxassetid://7399584366", script, 1, 1.25)
				_L.Message.New(result or "💕 VDayGram sent!")
				t_VDayGram.Gui.Enabled = false
				InputBox.Text = ""
			else
				_L.Message.New(result or "Something went wrong.")
			end
		end

		bool1 = false
	end)
end

-- Close button
_L.GUIFX.ButtonFX(t_VDayGram.Frame.VDayGram.Close)
t_VDayGram.Frame.VDayGram.Close.Activated:Connect(function()
	if not bool1 then
		bool1 = true
		t_VDayGram.Gui.Enabled = false
		bool1 = false
	end
end)

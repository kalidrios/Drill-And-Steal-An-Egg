local ReplicatedStorage = game:GetService("ReplicatedStorage")

local panel = script.Parent :: Frame
local scrollingFrame = panel:WaitForChild("ScrollingFrame")

local function remote(name: string): RemoteEvent
	return ReplicatedStorage:WaitForChild(name) :: RemoteEvent
end

local function armButton(button: GuiButton)
	button.Active = true
end

local function wireStatRow(rowName: string, addRemoteName: string, setRemoteName: string)
	local row = scrollingFrame:FindFirstChild(rowName)
	local frame = row and row:FindFirstChild("Frame")
	local box = frame and frame:FindFirstChildWhichIsA("TextBox")
	if not (frame and box) then return end
	local addButton = frame:FindFirstChild("Add")
	local setButton = frame:FindFirstChild("Set")
	local addRemote = remote(addRemoteName)
	local setRemote = remote(setRemoteName)
	local function amount() return tonumber(box.Text) end
	if addButton and addButton:IsA("GuiButton") then
		armButton(addButton)
		addButton.Activated:Connect(function() local value = amount() if value then addRemote:FireServer(value) end end)
	end
	if setButton and setButton:IsA("GuiButton") then
		armButton(setButton)
		setButton.Activated:Connect(function() local value = amount() if value then setRemote:FireServer(value) end end)
	end
end

wireStatRow("Rebirth", "AddRebirthRemote", "SetRebirthRemote")
wireStatRow("Speed", "AddSpeedRemote", "SetSpeedRemote")
wireStatRow("Money", "AddMoneyRemote", "SetMoneyRemote")

local misc = scrollingFrame:FindFirstChild("Misc")
local hideButton = misc and misc:FindFirstChild("HideButton")
if hideButton and hideButton:IsA("GuiButton") then
	armButton(hideButton)
	local toggleHide = remote("ToggleHideRemote")
	hideButton.Activated:Connect(function() toggleHide:FireServer() end)
	local overlay = hideButton:FindFirstChildOfClass("TextButton")
	if overlay then
		armButton(overlay)
		overlay.Activated:Connect(function() toggleHide:FireServer() end)
	end
end

local brainrotSelector = panel:FindFirstChild("BrainrotSelector1")
local giveRow = scrollingFrame:FindFirstChild("GiveBrainrot")
local openButton = giveRow and giveRow:FindFirstChild("OpenGiveBrainrot")
if brainrotSelector and openButton and openButton:IsA("GuiButton") then
	armButton(openButton)
	local function open() brainrotSelector.Visible = true end
	openButton.Activated:Connect(open)
	local overlay = openButton:FindFirstChildOfClass("TextButton")
	if overlay then armButton(overlay) overlay.Activated:Connect(open) end
	for _, descendant in ipairs(brainrotSelector:GetDescendants()) do
		if descendant.Name == "Close" and descendant:IsA("GuiButton") then
			armButton(descendant)
			descendant.Activated:Connect(function() brainrotSelector.Visible = false end)
		end
	end
	local giveAsset = remote("GiveAssetRemote")
	for _, descendant in ipairs(brainrotSelector:GetDescendants()) do
		if descendant.Name == "ClickDetector" and descendant:IsA("GuiButton") then
			local creatureFrame = descendant.Parent and descendant.Parent.Parent
			if creatureFrame and creatureFrame.Name ~= "Template" then
				local creatureName = creatureFrame.Name
				armButton(descendant)
				descendant.Activated:Connect(function()
					giveAsset:FireServer(creatureName)
					brainrotSelector.Visible = false
				end)
			end
		end
	end
end
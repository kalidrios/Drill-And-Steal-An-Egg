--[[

	Re-scripted 7/8/2023 By: kalidrios
		
--]]

--------|     Library     |--------
local _L = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"))
while (not _L.Loaded) do  game:GetService("RunService").Heartbeat:Wait()  end

local mailsettingsGUI = _L.GUI.MailSettings
local MailboxSettings = nil
local Old_MailboxSettings = nil
local debouce = nil

function UpdateScrolling()
	local Container = mailsettingsGUI.Gui.Frame.Container
	local UIPadding = Container:FindFirstChildOfClass("UIPadding")
	Container.CanvasSize = UDim2.new(0, 0, 0, Container:FindFirstChildOfClass("UIListLayout").AbsoluteContentSize.Y + UIPadding.PaddingTop.Offset + UIPadding.PaddingBottom.Offset)
end

function Update()
	MailboxSettings = _L.Signal.Invoke("Get Mailbox Settings")
	Old_MailboxSettings = _L.Functions.DeepCopyUnsafe(MailboxSettings)
	
	if not MailboxSettings then
		warn("No settings!")
		return
	end
	
	UpdateRaritys()
	UpdateOptions()
	UpdateScrolling()
end

function ToggleRarity(child)
	if not MailboxSettings then
		warn("No Settings!")
		return
	end
	
	_L.Audio.Play("rbxassetid://7004248320", script, 1, 0.5)
	
	if not _L.Shared.PetRarityNumbers[child.Name] then
		warn("No rarity!")
		return
	end
	
	if MailboxSettings.Rarities[child.Name] == nil then
		MailboxSettings.Rarities[child.Name] = true
	else
		MailboxSettings.Rarities[child.Name] = not MailboxSettings.Rarities[child.Name]
	end
	
	_L.Signal.Fire("Set Mailbox Settings", MailboxSettings)
	
	UpdateRaritys()
end

function ToggleSetting(set)
	if not MailboxSettings then
		return
	end

	if set ~= "HugesOnly" or set ~= "Enabled" or set ~= "RequiredPet" or set ~= "FriendsOnly" then
		return
	end
	
	_L.Audio.Play("rbxassetid://7004248320", script, 1, 0.5)

	if not MailboxSettings[set] then
		MailboxSettings[set] = false
	end
	
	MailboxSettings[set] = not MailboxSettings[set]
	
	_L.Signal.Fire("Set Mailbox Settings", MailboxSettings)
	
	UpdateOptions()
end

function UpdateRaritys()
	if not MailboxSettings then
		return
	end
	
	for _, child in ipairs(mailsettingsGUI.Frame.Container:GetChildren()) do
		if child.Name == "Rarity" then
			local ImageButton = child:FindFirstChildOfClass("ImageButton")
			local enabled = MailboxSettings.Rarities[ImageButton.Name]

			ImageButton.Label.Text = enabled and "On" or "Off"
			ImageButton.Image = enabled and "rbxassetid://7045637286" or "rbxassetid://7045637481"
			ImageButton.HoverImage = enabled and "rbxassetid://7045637411" or "rbxassetid://7045637564"
		end	
	end
end

function UpdateOptions()
	if not MailboxSettings then
		return
	end
	
	local hugesOnlyEnabled = MailboxSettings.HugesOnly
	local enabled = MailboxSettings.Enabled
	local requiredPetEnabled = MailboxSettings.RequiredPet
	local friendsOnlyEnabled = MailboxSettings.FriendsOnly

	mailsettingsGUI.HugesSetting.Label.Text = hugesOnlyEnabled and "On" or "Off"
	mailsettingsGUI.HugesSetting.Image = hugesOnlyEnabled and "rbxassetid://7045637286" or "rbxassetid://7045637481"
	mailsettingsGUI.HugesSetting.HoverImage = hugesOnlyEnabled and "rbxassetid://7045637411" or "rbxassetid://7045637564"
	mailsettingsGUI.EnabledSetting.Label.Text = enabled and "On" or "Off"
	mailsettingsGUI.EnabledSetting.Image = enabled and "rbxassetid://7045637286" or "rbxassetid://7045637481"
	mailsettingsGUI.EnabledSetting.HoverImage = enabled and "rbxassetid://7045637411" or "rbxassetid://7045637564"
	mailsettingsGUI.RequiredPetSetting.Label.Text = requiredPetEnabled and "On" or "Off"
	mailsettingsGUI.RequiredPetSetting.Image = requiredPetEnabled and "rbxassetid://7045637286" or "rbxassetid://7045637481"
	mailsettingsGUI.RequiredPetSetting.HoverImage = requiredPetEnabled and "rbxassetid://7045637411" or "rbxassetid://7045637564"
	mailsettingsGUI.FriendsOnlySetting.Label.Text = friendsOnlyEnabled and "On" or "Off"
	mailsettingsGUI.FriendsOnlySetting.Image = friendsOnlyEnabled and "rbxassetid://7045637286" or "rbxassetid://7045637481"
	mailsettingsGUI.FriendsOnlySetting.HoverImage = friendsOnlyEnabled and "rbxassetid://7045637411" or "rbxassetid://7045637564"
end

for _, child in ipairs(mailsettingsGUI.Frame.Container:GetChildren()) do
	if child.Name == "Rarity" then
		local ImageButton = child:FindFirstChildOfClass("ImageButton")
		_L.GUIFX.ButtonFX(ImageButton)

		ImageButton.Activated:Connect(function()
			if not debouce then
				debouce = true
				ToggleRarity(ImageButton)
				debouce = false
			end
		end)
	end
end

task.spawn(function()
	for index = 1, 4 do
		local Button = mailsettingsGUI[index == 1 and "HugesSetting" or index == 2 and "EnabledSetting" or index == 3 and "RequiredPetSetting" or index == 4 and "FriendsOnlySetting" or nil]
		local Setting = index == 1 and "HugesOnly" or index == 2 and "Enabled" or index == 3 and "RequiredPet" or index == 4 and "FriendsOnly" or nil
		if not (Button and Setting) then
			warn("???")
			return
		end

		_L.GUIFX.ButtonFX(Button)

		Button.Activated:Connect(function()
			if not debouce then
				debouce = true
				ToggleSetting(Setting)
				debouce = false
			end
		end)
	end
end)

mailsettingsGUI.Close.Activated:Connect(function()  
	if not debouce then
		debouce = true
		mailsettingsGUI.Gui.Enabled = false
		
		local mailSettings = _L.Signal.Invoke("Get Mail Settings")
		if not mailSettings then
			_L.Signal.Fire("Open Mailbox")
			debouce = false
			return
		end
		
		if not _L.Functions.DeepEqualsUnsafe(mailSettings, Old_MailboxSettings) then
			local success, response = _L.Network.Invoke("Update Mail Settings", mailSettings)

			if success then
				mailSettings = _L.Functions.DeepCopyUnsafe(mailSettings)
			else	
				if mailSettings ~= nil then
					local newData = _L.Functions.DeepCopyUnsafe(mailSettings)
					_L.Signal.Fire("Set Mailbox Settings", newData)
				end
				
				_L.Message.New(response)
				debouce = false
				return
			end
		end
		
		_L.Signal.Fire("Open Mailbox")
		debouce = false
	end
end)

_L.GUIFX.ButtonFX(mailsettingsGUI.Close)

_L.Signal.Fired("Open Mail Settings"):Connect(function()
	Update()
	mailsettingsGUI.Gui.Enabled = true
end)
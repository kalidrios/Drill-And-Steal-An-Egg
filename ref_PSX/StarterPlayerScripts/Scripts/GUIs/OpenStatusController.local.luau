--------|     Setting     |--------

--------|     Library     |--------
local _L = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"))
while (not _L.Loaded) do  game:GetService("RunService").Heartbeat:Wait()  end

--------|    Reference    |--------

--------|    Variables    |--------
local statusButton = _L.GUI.Bottom.MainBottomBar.Container.Top.Info.Status
local openDebounce = false
local player = game.Players.LocalPlayer

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function toggleOpenMode()
	local oldStatus = _L.Variables.MyBakery:GetOpenStatus()
	_L.Audio.Play(5074101610, player.PlayerGui)		

	if oldStatus then
		local confirmedCloseBakery = _L.Message.New("Are you sure you'd like to close your Restaurant?", true)
		
		if confirmedCloseBakery then
			
			if statusButton:FindFirstChild("DeleteGradient") then
				statusButton.DeleteGradient:Destroy()
			end
			
			game.ReplicatedStorage.Assets.UI.OpenGradient:Clone().Parent = statusButton
			statusButton.Title.Text = "Open"	
			_L.Variables.MyBakery:SetOpenStatus(not oldStatus)
		end
	else
		
		if statusButton:FindFirstChild("OpenGradient") then
			statusButton.OpenGradient:Destroy()
		end
		
		-- bakery open sound
		_L.SFX.Play(5152308685, player.PlayerGui)
		
		game.ReplicatedStorage.Assets.UI.DeleteGradient:Clone().Parent = statusButton
		statusButton.Title.Text = "Close"
		_L.Variables.MyBakery:SetOpenStatus(not oldStatus)
	end
end

statusButton.MouseButton1Down:Connect(function()
		
	if not _L.Variables.MyBakery or openDebounce then
		return
	end
	
	local bakery = _L.Variables.MyBakery
	
	if bakery.isTutorial then
		if bakery.tutorial.readyToAllowStoreToOpen and not bakery.tutorial.hasAllowedStoreToOpen then
			toggleOpenMode()
			_L.Signal.Fire("Tutorial_FirstCustomerAllowed")
			bakery.tutorial.hasAllowedStoreToOpen = true
		end
	else
		toggleOpenMode()
	end
	
	openDebounce = true
	wait(3)
	openDebounce = false
	
end)

repeat _L.Services.RunService.RenderStepped:Wait() until _L.Variables.MyBakery

_L.Signal.Fired("ForceBakeryOpen"):Connect(function()
	if not _L.Variables.MyBakery:GetOpenStatus() then
		toggleOpenMode()
	end
end)

wait(4)
if not _L.Variables.MyBakery:GetOpenStatus() and not _L.Variables.MyBakery.isTutorial then
	toggleOpenMode()
end

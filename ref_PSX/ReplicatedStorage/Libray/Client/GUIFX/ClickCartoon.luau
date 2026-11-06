-- | load library | --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Library = ReplicatedStorage:WaitForChild("Library")
local ClientLibrary = Library:WaitForChild("Client")
local Modules = Library:WaitForChild("Modules")
local Types = Library:WaitForChild("Types")

-- | shared modules | --
local Settings = require(ClientLibrary.Settings)

--------|     Setting     |--------

--------|    Reference    |--------
local RunService = game:GetService("RunService")

--------|    Variables    |--------
local GetHolder = require(script.Parent.GetHolder)

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


--- Cartoon effect when clicking button


return function(button) 
	local events = {}
	
	--- Button click event
	events[#events + 1] = button.Activated:Connect(function() 
		for b = 1, 2 do
			coroutine.wrap(function() 
				--- Variables
				local posX, posY = button.AbsolutePosition.X, button.AbsolutePosition.Y
				local sizeX, sizeY = button.AbsoluteSize.X + 6, button.AbsoluteSize.Y + 6
				
				--- Create FX
				local fx = Instance.new("fx")
				fx.Image = "rbxassetid://3134005313"
				fx.BackgroundTransparency = 1
				fx.BorderSizePixel = 0
				fx.AnchorPoint = Vector2.new(0.5, 0.5)
				fx.Size = UDim2.new(0, sizeX, 0, sizeY)
				fx.Rotation = math.random(0, 360)
				fx.Position = UDim2.new(0, posX + sizeX / 2, 0, posY + sizeY / 2)
				fx.Parent = GetHolder()
				
				--- Tween FX
				local startTick = os.clock()
				local buttonLifetime = (b == 1 and 0.1 or 0.2)
				--
				while (fx and button and (os.clock() - startTick) < buttonLifetime) do
					--- Time passed (converted to work with old code which was frame-based)
					local i = (os.clock() - startTick) * 50
					
					--
					if b == 1 then
						--- Close, dramatic
						local add = math.abs(math.sin(i / 5) * 15)
						fx.Size = UDim2.new(0, (sizeX + add), 0, (sizeY + add))

					else
						--- Far, fade out
						local add = math.abs(math.sin(i / 5) * 30)
						fx.Size = UDim2.new(0, (sizeX + add), 0, (sizeY + add))
						fx.ImageTransparency = (i / 10)
					end
					
					--
					RunService.RenderStepped:Wait()
				end
				
				--- Destroy FX
				fx:Destroy()
			end)()
		end
	end)
	
	--- Return function to cancel
	return function()
		--- Disconnect events
		for _, event in ipairs(events) do
			event:disconnect()
		end
		events = nil
	end
end

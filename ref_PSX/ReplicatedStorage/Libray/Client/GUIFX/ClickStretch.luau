-- | load library | --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Library = ReplicatedStorage:WaitForChild("Library")
local ClientLibrary = Library:WaitForChild("Client")
local Modules = Library:WaitForChild("Modules")
local Types = Library:WaitForChild("Types")

-- | shared modules | --
local Functions = require(Library.Functions)

--------|     Setting     |--------

--------|    Reference    |--------
local RunService = game:GetService("RunService")

--------|    Variables    |--------
local CacheProperty = require(script.Parent.CacheProperty)
local EasingStyle = require(Library:WaitForChild("Client").Settings).UIEasingStyle

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


--- Stretch effect when clicking a button


return function(button)
	local events = {}
	local buttonDown = false
	
	--- Cache button size
	local originalSize = CacheProperty(button, "Size")
	
	
	--- Button down
	local function Down()
		if not buttonDown then
			buttonDown = not buttonDown
			Functions.FastTween(button, {Size = originalSize + UDim2.new(0, 10, 0, -5)}, {0.05, EasingStyle, "Out"})
		end
	end

	--- Button up
	local function Up()
		if buttonDown then
			buttonDown = not buttonDown
		    Functions.FastTween(button, {Size = originalSize}, {0.35, "Back", "Out"})
		end
	end

	--- Button events
	events[#events + 1] = button.MouseButton1Down:Connect(function()
		Down()
	end)
	--
	events[#events + 1] = button.MouseButton1Up:Connect(function()
		Up()
	end)
	--
	events[#events + 1] = button.MouseLeave:Connect(function()
		Up()
	end)

	--- Return function to stop
	return function()
		for _, event in ipairs(events) do
			event:disconnect()
		end
		events = nil
	end
end

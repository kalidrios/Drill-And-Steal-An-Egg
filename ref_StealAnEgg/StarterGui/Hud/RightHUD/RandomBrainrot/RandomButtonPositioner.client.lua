-- StarterGui.Hud.LeftHUD.Uilistlayout.RandomBrainrot.RandomButtonPositioner
-- Keeps RandomButton pinned to a FIXED fraction of the real screen (not of its own tiny parent
-- RandomBrainrot), so it lands in the same relative spot on any device.
--
-- BUG FIX (user report: dragged RandomButton on purpose far outside its normal list slot, then
-- "en movil ni se ve" -- a Position expressed as pure Scale of RandomBrainrot drifts badly on a
-- different aspect ratio, because RandomBrainrot's own width/height ratio relative to the full
-- screen isn't the same on a phone's narrow-tall screen as on a desktop's wide one, and X/Y
-- scale off RandomBrainrot's width/height independently -- confirmed directly: RandomBrainrot
-- and everything above it (Uilistlayout/LeftHUD/Hud) IS pure Scale end to end, so this isn't a
-- fixed-pixel problem, it's an aspect-ratio one. Couldn't just reparent RandomButton to a
-- stable full-screen frame instead -- RandomBrainrotClient (sibling script) does
-- `script.Parent:WaitForChild("RandomButton")`, so it has to stay inside RandomBrainrot -- so
-- this recomputes Position/Size every time the viewport changes instead, keeping the button at
-- the same fraction of the REAL screen it was placed at (captured once, below, from the user's
-- own device), translated into whatever RandomBrainrot's actual geometry happens to be on any
-- given device.

local frame = script.Parent
local button = frame:WaitForChild("RandomButton")
local screenGui = frame:FindFirstAncestorOfClass("ScreenGui")
assert(screenGui, "RandomButtonPositioner requires a ScreenGui ancestor")

-- Captured from the exact spot/size the user placed it at on their own screen (1271x576
-- viewport: center (1224.25, 409.35)px, 86.3px wide).
local CENTER_X_FRACTION = 0.9631
local CENTER_Y_FRACTION = 0.75 -- nudged down a bit per user request (was 0.7107)
local WIDTH_FRACTION = 0.0679

local function reposition()
	local screenSize = screenGui.AbsoluteSize
	local frameSize = frame.AbsoluteSize
	local framePos = frame.AbsolutePosition

	if frameSize.X <= 0 or frameSize.Y <= 0 then
		return
	end

	local targetCenterX = CENTER_X_FRACTION * screenSize.X
	local targetCenterY = CENTER_Y_FRACTION * screenSize.Y
	local targetWidth = WIDTH_FRACTION * screenSize.X

	button.Position = UDim2.new(
		(targetCenterX - framePos.X) / frameSize.X, 0,
		(targetCenterY - framePos.Y) / frameSize.Y, 0
	)
	-- Y is left as whatever it already is -- UIAspectRatioConstraint (DominantAxis = Width)
	-- recalculates it from X to keep the button square regardless.
	button.Size = UDim2.new(targetWidth / frameSize.X, 0, button.Size.Y.Scale, button.Size.Y.Offset)
end

reposition()

local camera = workspace.CurrentCamera
local cameraConn = camera and camera:GetPropertyChangedSignal("ViewportSize"):Connect(reposition)

workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
	if cameraConn then
		cameraConn:Disconnect()
	end
	camera = workspace.CurrentCamera
	cameraConn = camera and camera:GetPropertyChangedSignal("ViewportSize"):Connect(reposition)
	reposition()
end)

frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(reposition)
frame:GetPropertyChangedSignal("AbsolutePosition"):Connect(reposition)
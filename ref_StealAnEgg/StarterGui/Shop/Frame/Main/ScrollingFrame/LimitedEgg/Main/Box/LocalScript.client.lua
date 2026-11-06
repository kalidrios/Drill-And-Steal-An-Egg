-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMTBGdhbWUMVHdlZW5TZXJ2aWNlCkdldFNlcnZpY2UGc2NyaXB0BlBhcmVudAhQb3NpdGlvbgVVRGltMglmcm9tU2NhbGUJVHdlZW5JbmZvA25ldwRFbnVtC0Vhc2luZ1N0eWxlBFNpbmUPRWFzaW5nRGlyZWN0aW9uBUluT3V0BkNyZWF0ZQRQbGF5CUNvbXBsZXRlZARXYWl0AAELAAABAAA9owAAAKQAAQAAAABAbwICALwAABYDAAAAnwADAqQBBQAAAEBATQEBJAYAAABNAgE7BwAAAKQDCgAAJICAjAQAAG8FCwCfAwMCpAQOAAA0wICMBQEApAYSABFA8MCkBxUAFEzwwJ8EBAJSBwEAUggEAOIJFgBDCgIDMAoJOwcAAAC8BQCWFwAAAJ8FBQJSCAEAUgkEAOIKFgAwAgo7BwAAALwGAJYXAAAAnwYFArwHBe4YAAAAnwcCAU0HBRgZAAAAvAcH9xoAAACfBwIBvAcG7hgAAACfBwIBTQcGGBkAAAC8Bwf3GgAAAJ8HAgFIAO//ggABABsDAQQAAABAAwIDAwMEBAAAQEADBQMGAwcDCAQAJICAAnsUrkfhesS/AwkDCgQANMCAAwsDDAMNBBFA8MADDgMPBBRM8MAFAQcDEAMRAxIDEwABAAEYAAAAAAAAAAIAAAABAAEAAAAAAwABAQABAP0GAAABAAD/AAAEAAABAP8AAAUAAAEAAAAAAgAAAQAAAAD7BgEAAAAAAMeO8K3RodDm9ChwrbrgGwe3lufZ9UqarA==

-- decompilation:
local TweenService = game:GetService("TweenService")
local scriptParent = script.Parent
local scriptParentPosition = scriptParent.Position
local uDim2 = UDim2.fromScale(0.0, -0.16)
local tweenInfo = TweenInfo.new(1.0, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
local tween = TweenService:Create(scriptParent, tweenInfo, {
	Position = scriptParentPosition + uDim2
})
local tween2 = TweenService:Create(scriptParent, tweenInfo, {
	Position = scriptParentPosition
})

while true do
	tween:Play()
	tween.Completed:Wait()
	tween2:Play()
	tween2.Completed:Wait()
end


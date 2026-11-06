-- StarterGui.AdminToast.ToastClient
-- Minimal toast/notification popup for ReplicatedStorage.RemoteGUI.UNotifyEvent, which
-- TrollActionServer/TrollFreeAdmin/AdminPanelHandler all already fire into
-- (notifyEvent:FireClient(player, title, duration, kind)). Neither RemoteGUI.UNotifyEvent
-- nor any equivalent existed anywhere in this game before (confirmed via grep across all
-- ~2355 scripts) -- without this, every admin/troll action would apply silently with zero
-- on-screen feedback. Self-contained, doesn't touch any other GUI.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local gui = script.Parent :: ScreenGui
local UNotifyEvent = ReplicatedStorage:WaitForChild("RemoteGUI"):WaitForChild("UNotifyEvent") :: RemoteEvent

local holder = Instance.new("Frame")
holder.Name = "ToastHolder"
holder.AnchorPoint = Vector2.new(0.5, 0)
holder.Position = UDim2.new(0.5, 0, 0, 12)
holder.Size = UDim2.new(0, 420, 1, -24)
holder.BackgroundTransparency = 1
holder.Parent = gui

local layout = Instance.new("UIListLayout")
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 6)
layout.Parent = holder

local KIND_COLORS = {
	Success = Color3.fromRGB(58, 175, 92),
	Error = Color3.fromRGB(200, 60, 60),
}

local function showToast(title, duration, kind)
	if typeof(title) ~= "string" or title == "" then
		return
	end
	duration = tonumber(duration) or 3
	local color = KIND_COLORS[kind] or Color3.fromRGB(60, 64, 90)

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, 0, 0, 0)
	frame.AutomaticSize = Enum.AutomaticSize.Y
	frame.BackgroundColor3 = color
	frame.BackgroundTransparency = 1
	frame.BorderSizePixel = 0
	frame.LayoutOrder = os.clock() * 1000
	frame.Parent = holder

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 10)
	corner.Parent = frame

	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.new(0, 0, 0)
	stroke.Thickness = 2
	stroke.Transparency = 1
	stroke.Parent = frame

	local padding = Instance.new("UIPadding")
	padding.PaddingTop = UDim.new(0, 10)
	padding.PaddingBottom = UDim.new(0, 10)
	padding.PaddingLeft = UDim.new(0, 16)
	padding.PaddingRight = UDim.new(0, 16)
	padding.Parent = frame

	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Size = UDim2.new(1, 0, 0, 0)
	label.AutomaticSize = Enum.AutomaticSize.Y
	label.Text = title
	label.TextWrapped = true
	label.TextScaled = false
	label.TextSize = 18
	label.Font = Enum.Font.GothamBold
	label.TextColor3 = Color3.new(1, 1, 1)
	label.TextTransparency = 1
	label.Parent = frame

	local fadeIn = TweenService:Create(frame, TweenInfo.new(0.2), { BackgroundTransparency = 0.1 })
	local strokeIn = TweenService:Create(stroke, TweenInfo.new(0.2), { Transparency = 0.4 })
	local textIn = TweenService:Create(label, TweenInfo.new(0.2), { TextTransparency = 0 })
	fadeIn:Play()
	strokeIn:Play()
	textIn:Play()

	task.delay(duration, function()
		if not frame.Parent then
			return
		end
		local fadeOut = TweenService:Create(frame, TweenInfo.new(0.3), { BackgroundTransparency = 1 })
		local strokeOut = TweenService:Create(stroke, TweenInfo.new(0.3), { Transparency = 1 })
		local textOut = TweenService:Create(label, TweenInfo.new(0.3), { TextTransparency = 1 })
		fadeOut:Play()
		strokeOut:Play()
		textOut:Play()
		fadeOut.Completed:Wait()
		if frame.Parent then
			frame:Destroy()
		end
	end)
end

UNotifyEvent.OnClientEvent:Connect(showToast)

-- StarterGui.LikeGameBanner.AnimateTicker
-- Scrolls "Like the Game For EXCLUSIVE Rewards" right-to-left across the pill banner, wrapping
-- back to the right the instant it fully exits on the left (classic marquee/news-ticker loop).
-- "Like" and "EXCLUSIVE" cycle through a rainbow color independently of the scroll.

local TweenService = game:GetService("TweenService")

local screenGui = script.Parent
local banner = screenGui:WaitForChild("Banner")
local ticker = banner:WaitForChild("Ticker")

local SCROLL_SPEED = 90 -- pixels/second -- tuned for a clean, easy-to-read pace

local function loop()
	if not ticker.Parent then
		return
	end

	ticker.Position = UDim2.new(0, banner.AbsoluteSize.X, 0.5, 0)

	local distance = banner.AbsoluteSize.X + ticker.AbsoluteSize.X
	local duration = math.max(distance / SCROLL_SPEED, 3)

	local tween = TweenService:Create(ticker, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
		Position = UDim2.new(0, -ticker.AbsoluteSize.X, 0.5, 0),
	})

	tween.Completed:Once(function()
		loop()
	end)

	tween:Play()
end

task.wait(0.1) -- let AutomaticSize/UIListLayout settle before the first width measurement
loop()

local rainbowLabels = {
	{ label = ticker:WaitForChild("SegLike"), offset = 0 },
	{ label = ticker:WaitForChild("SegExclusive"), offset = 0.5 },
}

task.spawn(function()
	while ticker.Parent do
		local hue = (tick() * 0.35) % 1
		for _, entry in ipairs(rainbowLabels) do
			entry.label.TextColor3 = Color3.fromHSV((hue + entry.offset) % 1, 0.85, 1)
		end
		task.wait()
	end
end)
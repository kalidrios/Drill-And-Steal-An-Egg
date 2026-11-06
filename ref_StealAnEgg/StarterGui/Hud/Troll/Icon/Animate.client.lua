-- Shake rapido (izq/der) cada 5 segundos.
local TweenService = game:GetService("TweenService")

local icon = script.Parent

local function tween(rot, time)
	local t = TweenService:Create(icon, TweenInfo.new(time, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
		Rotation = rot,
	})
	t:Play()
	t.Completed:Wait()
end

while true do
	-- Agitar rapido: varios golpes izq/der que decrecen, y vuelve a 0.
	tween(18, 0.07)
	tween(-18, 0.09)
	tween(14, 0.08)
	tween(-14, 0.08)
	tween(8, 0.07)
	tween(0, 0.08)

	task.wait(5)
end
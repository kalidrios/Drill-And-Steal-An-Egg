-- its june and i making a game instead study for my entrance exame
local v7 = require((game.ReplicatedStorage:WaitForChild("Framework")):WaitForChild("Library"))
while not v7.Loaded do
	game:GetService("RunService").Heartbeat:Wait()
end
local v11 = 1185
v10 = 0
local v12 = v7.LocalPlayer
local v13 = {
	[561445931] = false
}
if v13[v12.UserId] then
	local v18 = v12.PlayerGui:WaitForChild("IdleTracking", 9999)
	local v21 = v18:WaitForChild("Time", 9999)
	v18.Enabled = true
end
v7.RunService.Heartbeat:Connect(function(p1)
	if 0 > p1 then
		return 
	end
	if p1 >= 5 then
		return 
	end
	local v26 = v7.Functions.IsFinite(p1)
	if not v26 then
		return 
	end
	v10 = v10 + p1
	if v13[v12.UserId] then 
		(v12.PlayerGui:WaitForChild("IdleTracking", 9999)):WaitForChild("Time", 9999).Text = v7.Functions.FormatTime(v11 - v10)
	end
	if v10 > v11 then
		v7.Network.Fire("Move Server")
	end
end)
local function track(p2, p3)
	if p2.UserInputType == Enum.UserInputType.MouseMovement then
		return 
	end
	v10 = 0
end
v7.UserInputService.InputBegan:Connect(track)
v7.UserInputService.InputChanged:Connect(track)
v7.UserInputService.InputEnded:Connect(track)
v7.Network.Fired("Move Time Change"):Connect(function(p4)
	assert(typeof(p4) == "number")
	v11 = p4
end)

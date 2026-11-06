-- its june and i making a game instead study for my entrance exame
local v7 = require((game.ReplicatedStorage:WaitForChild("Framework")):WaitForChild("Library"))
while not v7.Loaded do 
	game:GetService("RunService").Heartbeat:Wait()
end
local v11
v10 = game.JobId
function HideSign(p1)
    local v14 = p1.Parent
    if not v14 then
        return 
    end
	for v21, v20 in pairs(p1:GetChildren()) do
        v20.Transparency = 1
        v20.CanCollide = false
        v20.CanQuery = false
    end
	p1.PrimaryPart.SurfaceGui.Enabled = false
end
local function Hook()
    local v27 = v11:FindFirstChild("Diamond Mine Collapsed Sign")
    if not v27 then
        return 
    end
	if not v7.Save.Get() then
		HideSign(v27)
        return 
    end
	local v35 = v7.Signal.Invoke("Get Diamond Mine Collpase Time")
    if not v35 then
		HideSign(v27)
        return 
    end
    while true do
		if v27.Parent then
            break
        end
		local v39 = v7.Signal.Invoke("Get Diamond Mine Collpase Time")
        if not v39 then
            break
        end
		v27.PrimaryPart.SurfaceGui.Timer.Text = "Reopening in: " .. v7.Functions.FormatTime(v39)
		wait(0.25)
    end
	if v27.Parent then
		HideSign(v27)
        v7.Signal.Fire("Diamond Mine: Setup Interact")
    end
end
v7.Signal.Fired("World Changed"):Connect(function(p2, p3)
    v11 = nil
    if p2 == "Spawn" then
        v11 = p3:FindFirstChild("Interactive")
        Hook()
    end
end)

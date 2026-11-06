-- its june and i making a game instead study for my entrance exame
local v7 = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"))
while not v7.Loaded do 
	game:GetService("RunService").Heartbeat:Wait()
end
local v11 = {}
local v25 = Color3.new(0.321569, 0.486275, 0.682353)
local v30 = Color3.new(0.356863, 0.603922, 0.298039)
local v35 = Color3.new(0.65098, 0.443137, 0)
local v40 = Color3.new(0.890196, 0.305882, 0.0705882)
v11[1] = Color3.new(0.72549, 0.27451, 0.72549)
v11[2] = Color3.new(0.145098, 0.301961, 1)
v11[3] = Color3.new(1, 0.203922, 0.00392157)
v11[4]= v25
v11[5]=v30
v11[6]=v35
v11[7]=v40
local v45 = TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0)
local v46
local function Hook()
	task.spawn(function()
		local v53 = v46:FindFirstChild("Dance Floor")
		if not v53 then
			return 
		end
		while true do
			if not v46 then
				break
			end
			for v73, v66 in pairs(v53:GetChildren()) do
				local v77 = {}
				v77[1] = 2
				v77[2] = "Linear"
				v77[3] = "Out"
				v7.Functions.Tween(v66, {
					Color = v11[math.random(1, #v11)]
				}, v77):Play()
			end
			wait(1)
		end
	end)
	task.spawn(function()
		local v83 = v46:FindFirstChild("Disco Ball")
		if not v83 then
			return 
		end
		while true do
			if not v46 then
				break
			end
			v83.Orientation = v83.Orientation + Vector3.new(0, 0.5, 0)
			v7.Heartbeat()
		end
	end)
end
v7.Signal.Fired("World Changed"):Connect(function(p1, p2)
	if p1 == "Dog" then
		v46 = p2:FindFirstChild("Interactive")
		Hook()
		return 
	end
	v46 = nil
end)

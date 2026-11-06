-- Decompiled by Electron BETA [ Made By (Co) ]
-- Path: StarterPlayer.StarterPlayerScripts.Scripts.Game.Dog Club Return Door
local u1 = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"))
while not u1.Loaded do
	game:GetService("RunService").Heartbeat:Wait()
end
local u2 = nil

function Teleport()
	local teleport = u1.WorldCmds.GetMap().Teleports:FindFirstChild("Dog Park")
	if u1.WorldCmds.GetMap().Teleports:FindFirstChild("Dog Park") then
		local v1 = u1.Player.Character()
		u1.GUIFX.Flash(0.25, 0.75, Color3.new(255, 255, 255))
		u1.Variables.Teleporting = true
		u1.Signal.Fire("Teleporting")
		u1.Functions.Wait(0.25);
		v1:SetPrimaryPartCFrame(teleport.CFrame + Vector3.new(0, v1.Humanoid().HipHeight + 1, 0))
		u1.Audio.Play("rbxassetid://7210953148", script, 1, 1)
		u1.Network.Fire("Performed Teleport", "Dog Park")
		u1.Functions.Wait(0.25)
		u1.Variables.Teleporting = false
		return
	end
	u1.Message.New("Something went wrong. Try again!")
end

function Setup()
	if u1.WorldCmds.GetMap():FindFirstChild("Interactive") then
		u2 = u1.WorldCmds.GetMap().Interactive:FindFirstChild("Dog Club Return Door")
		if u2 then
			local interactive, v3 = u1.Interact.Add(u2.PrimaryPart, {
				dist = 12,
				label = "Leave Dog Club"
			})
			if interactive then
				interactive:Connect(function()
					Teleport()
				end)
			end
		end
	end
end

u1.Signal.Fired("World Changed"):Connect(function(world)
	if world == "Dog" then
		Setup()
	end
end)
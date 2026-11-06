-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local t = {
	Threads = {},
	StartPositions = {},
	StartRotations = {},
	CancelEvents = {}
}
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local v1 = Random.new()

function t.ShakeOnce(p1, p2, p3, p4, p5) --[[ ShakeOnce | Line: 15 | Upvalues: t (copy), RunService (copy), v1 (copy), TweenService (copy) ]]
	if t.Threads[p1] then
		t.CancelEvents[p1]:Fire()
		task.cancel(t.Threads[p1])
		t.Threads[p1] = nil
	end

	local v12 = t.StartPositions[p1] or p1.Position
	local v2 = t.StartRotations[p1] or p1.Rotation
	local v3 = Instance.new("BindableEvent")
	local v4 = v3.Event

	if not t.StartPositions[p1] then
		t.StartPositions[p1] = v12
	end

	t.StartRotations[p1] = v2
	t.CancelEvents[p1] = v3
	t.Threads[p1] = task.spawn(function() --[[ Line: 35 | Upvalues: p2 (copy), RunService (ref), v1 (ref), p1 (copy), v12 (copy), v2 (copy), TweenService (ref), p4 (copy), p3 (copy), p5 (copy), v3 (copy), v4 (copy), t (ref) ]]
		local v13 = p2 / 800
		local v22 = p2
		local t2 = {
			multiplier = Instance.new("NumberValue"),
			rotation = Instance.new("NumberValue"),
			position = Instance.new("Vector3Value")
		}

		t2.multiplier.Value = 0

		local v32 = nil
		local v42 = nil
		local v5 = task.spawn(function() --[[ Line: 48 | Upvalues: v32 (ref), RunService (ref), v1 (ref), v13 (copy), v22 (copy), t2 (ref), p1 (ref), v12 (ref), v2 (ref) ]]
			v32 = RunService.RenderStepped:Connect(function(p12) --[[ Line: 50 | Upvalues: v1 (ref), v13 (ref), v22 (ref), t2 (ref), p1 (ref), v12 (ref), v2 (ref) ]]
				local v14 = v1:NextNumber(-v13, v13)
				local v23 = v1:NextNumber(-v13, v13)
				local v3 = v1:NextNumber(-v22, v22)

				t2.position.Value = Vector3.new(v14, v23, 0)
				p1.Position = v12 + UDim2.fromScale(t2.position.Value.X * t2.multiplier.Value, t2.position.Value.Y * t2.multiplier.Value)
				t2.rotation.Value = v3
				p1.Rotation = v2 + t2.rotation.Value * t2.multiplier.Value
			end)
		end)
		local v6 = task.spawn(function() --[[ Line: 72 | Upvalues: TweenService (ref), t2 (ref), p4 (ref), p3 (ref), p5 (ref), v3 (ref) ]]
			TweenService:Create(t2.multiplier, TweenInfo.new(p4, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
				Value = 1
			}):Play()
			task.wait(p4)
			t2.multiplier.Value = 1
			task.wait(p3)
			TweenService:Create(t2.multiplier, TweenInfo.new(p5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
				Value = 0
			}):Play()
			task.wait(p5)
			t2.multiplier.Value = 0
			v3:Fire()
		end)

		v42 = v4:Connect(function() --[[ Line: 91 | Upvalues: v5 (copy), v6 (copy), v32 (ref), v42 (ref), v3 (ref), t2 (ref), t (ref), p1 (ref) ]]
			task.cancel(v5)
			task.cancel(v6)
			v32:Disconnect()
			v42:Disconnect()
			v3:Destroy()
			t2.rotation:Destroy()
			t2.position:Destroy()
			t2.multiplier:Destroy()
			t2 = {}
			t.Threads[p1] = nil
		end)
	end)
end

return t
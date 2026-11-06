-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local t = { 0, 1, 2, 3, 4, 5, 6, 7 }
local t2 = { 0, 1, 3, 4, 5, 7 }
local t3 = { 0, 1, 4, 5, 6 }
local t4 = {}

t4.__index = t4
t4.ClassName = "ViewportModel"

local function getIndices(p1) --[[ getIndices | Line: 13 | Upvalues: t2 (copy), t3 (copy), t (copy) ]]
	if p1:IsA("WedgePart") then
		return t2
	end

	if p1:IsA("CornerWedgePart") then
		return t3
	end

	return t
end

local function getCorners(p1, p2, p3) --[[ getCorners | Line: 22 ]]
	local t = {}

	for k, v in pairs(p3) do
		local v1 = math.floor(v / 4) % 2 * 2 - 1

		t[v + 1] = p1 * (p2 * Vector3.new(v1, math.floor(v / 2) % 2 * 2 - 1, 2 * (v % 2) - 1))
	end

	return t
end

local function getModelPointCloud(p1) --[[ getModelPointCloud | Line: 34 | Upvalues: t2 (copy), t3 (copy), t (copy), getCorners (copy) ]]
	local t4 = {}

	for k, v in pairs(p1:GetDescendants()) do
		if v:IsA("BasePart") then
			for k2, v3 in pairs((getCorners(v.CFrame, v.Size / 2, if v:IsA("WedgePart") then t2 elseif v:IsA("CornerWedgePart") then t3 else t))) do
				table.insert(t4, v3)
			end
		end
	end

	return t4
end

local function viewProjectionEdgeHits(p1, p2, p3, p4) --[[ viewProjectionEdgeHits | Line: 48 ]]
	local v1 = (-1 / 0)
	local v2 = (1 / 0)

	for k, v in pairs(p1) do
		local v3 = p4 * (p3 - v.Z)
		local v4 = v[p2] + v3
		local v5 = v[p2] - v3
		local v6 = math.max(v1, v4, v5)

		v1, v2 = v6, math.min(v2, v4, v5)
	end

	return v1, v2
end

function t4.new(p1, p2) --[[ new | Line: 67 | Upvalues: t4 (copy) ]]
	local v2 = setmetatable({}, t4)

	v2.Model = nil
	v2.ViewportFrame = p1
	v2.Camera = p2
	v2._points = {}
	v2._modelCFrame = CFrame.new()
	v2._modelSize = Vector3.new()
	v2._modelRadius = 0
	v2._viewport = {}
	v2:Calibrate()

	return v2
end
function t4.SetModel(p1, p2) --[[ SetModel | Line: 91 | Upvalues: getModelPointCloud (copy) ]]
	p1.Model = p2

	local v1, v2 = p2:GetBoundingBox()

	p1._points = getModelPointCloud(p2)
	p1._modelCFrame = v1
	p1._modelSize = v2
	p1._modelRadius = v2.Magnitude / 2
end
function t4.Calibrate(p1) --[[ Calibrate | Line: 104 ]]
	local t = {}
	local AbsoluteSize = p1.ViewportFrame.AbsoluteSize

	t.aspect = AbsoluteSize.X / AbsoluteSize.Y
	t.yFov2 = math.rad(p1.Camera.FieldOfView / 2)
	t.tanyFov2 = math.tan(t.yFov2)
	t.xFov2 = math.atan(t.tanyFov2 * t.aspect)
	t.tanxFov2 = math.tan(t.xFov2)
	t.cFov2 = math.atan(t.tanyFov2 * math.min(1, t.aspect))
	t.sincFov2 = math.sin(t.cFov2)
	p1._viewport = t
end
function t4.GetFitDistance(p1, p2) --[[ GetFitDistance | Line: 126 ]]
	return (p1._modelRadius + (p2 and (p2 - p1._modelCFrame.Position).Magnitude or 0)) / p1._viewport.sincFov2
end
function t4.GetMinimumFitCFrame(p1, p2) --[[ GetMinimumFitCFrame | Line: 138 | Upvalues: viewProjectionEdgeHits (copy) ]]
	if not p1.Model then
		return CFrame.new()
	end

	local v1 = (p2 - p2.Position):Inverse()
	local _points = p1._points
	local t = { v1 * _points[1] }
	local Z = t[1].Z

	for i = 2, #_points do
		local v2 = v1 * _points[i]
		local v3 = math.min(Z, v2.Z)

		t[i] = v2
		Z = v3
	end

	local v4, v5 = viewProjectionEdgeHits(t, "X", Z, p1._viewport.tanxFov2)
	local v6, v7 = viewProjectionEdgeHits(t, "Y", Z, p1._viewport.tanyFov2)

	return p2 * CFrame.new((v4 + v5) / 2, (v6 + v7) / 2, Z + math.max((v4 - v5) / 2 / p1._viewport.tanxFov2, (v6 - v7) / 2 / p1._viewport.tanyFov2))
end

return t4
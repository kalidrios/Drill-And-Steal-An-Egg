-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local exp = math.exp
local sin = math.sin
local cos = math.cos
local min = math.min
local max = math.max
local sqrt = math.sqrt
local atan2 = math.atan2
local round = math.round

local function magnitudeSq(p1) --[[ magnitudeSq | Line: 53 ]]
	local sum = 0

	for v1, v2 in p1 do
		sum = sum + v2 ^ 2
	end

	return sum
end

local function distanceSq(p1, p2) --[[ distanceSq | Line: 61 ]]
	local sum = 0

	for v1, v2 in p1 do
		sum = sum + (p2[v1] - v2) ^ 2
	end

	return sum
end

local t = {}

t.__index = t
function t.new(p1, p2, p3, p4, p5) --[[ new | Line: 91 | Upvalues: t (copy) ]]
	local v1 = p5.toIntermediate(p3)

	return setmetatable({
		d = p1,
		f = p2,
		g = v1,
		p = v1,
		v = table.create(#v1, 0),
		typedat = p5,
		rawGoal = p4
	}, t)
end
function t.setGoal(p1, p2) --[[ setGoal | Line: 107 ]]
	p1.rawGoal = p2
	p1.g = p1.typedat.toIntermediate(p2)
end
function t.setDampingRatio(p1, p2) --[[ setDampingRatio | Line: 112 ]]
	p1.d = p2
end
function t.setFrequency(p1, p2) --[[ setFrequency | Line: 116 ]]
	p1.f = p2
end
function t.canSleep(p1) --[[ canSleep | Line: 120 ]]
	local sum = 0

	for v1, v2 in p1.v do
		sum = sum + v2 ^ 2
	end

	if sum > 0.0001 then
		return false
	end

	local g = p1.g
	local sum2 = 0

	for v3, v4 in p1.p do
		sum2 = sum2 + (g[v3] - v4) ^ 2
	end

	return not (sum2 > 6.781684027777778e-8)
end
function t.step(p1, p2) --[[ step | Line: 132 | Upvalues: exp (copy), sqrt (copy), cos (copy), sin (copy) ]]
	local d = p1.d
	local v1 = p1.f * 6.283185307179586
	local g = p1.g
	local p = p1.p
	local v = p1.v

	if d == 1 then
		local v2 = exp(-v1 * p2)
		local v3 = p2 * v2
		local v4 = v2 - v3 * v1
		local v5 = v3 * v1 * v1
		local v6 = v2 + v3 * v1

		for i = 1, #p do
			local v7 = p[i] - g[i]

			p[i] = v7 * v6 + v[i] * v3 + g[i]
			v[i] = v[i] * v4 - v7 * v5
		end
	elseif d < 1 then
		local v8 = exp(-d * v1 * p2)
		local v9 = sqrt(1 - d * d)
		local v10 = cos(p2 * v1 * v9)
		local v11 = sin(p2 * v1 * v9)
		local v12

		if v9 > 0.00001 then
			v12 = v11 / v9
		else
			local v13 = p2 * v1

			v12 = v13 + (v13 * v13 * (v9 * v9) * (v9 * v9) / 20 - v9 * v9) * (v13 * v13 * v13) / 6
		end

		local v14

		if v1 * v9 > 0.00001 then
			v14 = v11 / (v1 * v9)
		else
			local v15 = v1 * v9

			v14 = p2 + (p2 * p2 * (v15 * v15) * (v15 * v15) / 20 - v15 * v15) * (p2 * p2 * p2) / 6
		end

		for j = 1, #p do
			local v16 = p[j] - g[j]

			p[j] = (v16 * (v10 + v12 * d) + v[j] * v14) * v8 + g[j]
			v[j] = (v[j] * (v10 - v12 * d) - v16 * (v12 * v1)) * v8
		end
	else
		local v17 = sqrt(d * d - 1)
		local v18 = -v1 * (d + v17)
		local v19 = -v1 * (d - v17)
		local v20 = exp(v18 * p2)
		local v21 = exp(v19 * p2)

		for k = 1, #p do
			local v22 = p[k] - g[k]
			local v23 = (v[k] - v22 * v18) / (2 * v1 * v17)
			local v24 = v20 * (v22 - v23)

			p[k] = v24 + v23 * v21 + g[k]
			v[k] = v24 * v18 + v23 * v21 * v19
		end
	end

	return p1.typedat.fromIntermediate(p1.p)
end

local t2 = {}

t2.__index = t2
function t2.new(p1, p2, p3, p4) --[[ new | Line: 248 | Upvalues: t2 (copy) ]]
	return setmetatable({
		v = Vector3.new(0, 0, 0),
		d = p1,
		f = p2,
		g = p4:Orthonormalize(),
		p = p3:Orthonormalize()
	}, t2)
end
function t2.setGoal(p1, p2) --[[ setGoal | Line: 261 ]]
	p1.g = p2:Orthonormalize()
end
function t2.setDampingRatio(p1, p2) --[[ setDampingRatio | Line: 265 ]]
	p1.d = p2
end
function t2.setFrequency(p1, p2) --[[ setFrequency | Line: 269 ]]
	p1.f = p2
end

local function dot(p1, p2) --[[ dot | Line: 274 ]]
	return p1.X * p2.X + p1.Y * p2.Y + p1.Z * p2.Z
end

local function areRotationsClose(p1, p2) --[[ areRotationsClose | Line: 278 ]]
	local XVector = p1.XVector
	local XVector2 = p2.XVector
	local YVector = p1.YVector
	local YVector2 = p2.YVector
	local ZVector = p1.ZVector
	local ZVector2 = p2.ZVector

	return XVector.X * XVector2.X + XVector.Y * XVector2.Y + XVector.Z * XVector2.Z + (YVector.X * YVector2.X + YVector.Y * YVector2.Y + YVector.Z * YVector2.Z) + (ZVector.X * ZVector2.X + ZVector.Y * ZVector2.Y + ZVector.Z * ZVector2.Z) > 2.9999999695382584
end

local function angleDiff(p1, p2) --[[ angleDiff | Line: 286 | Upvalues: max (copy), sqrt (copy), atan2 (copy) ]]
	local XVector = p1.XVector
	local XVector2 = p2.XVector
	local YVector = p1.YVector
	local YVector2 = p2.YVector
	local ZVector = p1.ZVector
	local ZVector2 = p2.ZVector
	local v3 = XVector.X * XVector2.X + XVector.Y * XVector2.Y + XVector.Z * XVector2.Z + (YVector.X * YVector2.X + YVector.Y * YVector2.Y + YVector.Z * YVector2.Z) + (ZVector.X * ZVector2.X + ZVector.Y * ZVector2.Y + ZVector.Z * ZVector2.Z) - 1

	return atan2(sqrt((max(0, 1 - v3 * v3 * 0.25))), v3 * 0.5)
end

local function fromAxisAngle(p1, p2) --[[ fromAxisAngle | Line: 295 | Upvalues: cos (copy), sin (copy) ]]
	local v1 = cos(p2)
	local v2 = sin(p2)
	local X = p1.X
	local Y = p1.Y
	local Z = p1.Z
	local v3 = X * Y * (1 - v1)
	local v4 = Y * Z * (1 - v1)
	local v5 = Z * X * (1 - v1)
	local v6 = Vector3.new(X * X * (1 - v1) + v1, v3 + Z * v2, v5 - Y * v2)
	local v7 = Vector3.new(v3 - Z * v2, Y * Y * (1 - v1) + v1, v4 + X * v2)

	return CFrame.fromMatrix(Vector3.new(0, 0, 0), v6, v7, (Vector3.new(v5 + Y * v2, v4 - X * v2, Z * Z * (1 - v1) + v1))):Orthonormalize()
end

local function rotateAxis(p1, p2) --[[ rotateAxis | Line: 311 | Upvalues: fromAxisAngle (copy) ]]
	local identity = CFrame.identity
	local Magnitude = p1.Magnitude

	if Magnitude > 1e-6 then
		identity = fromAxisAngle(p1.Unit, Magnitude)
	end

	return identity * p2
end

local function axisAngleDiff(p1, p2) --[[ axisAngleDiff | Line: 321 | Upvalues: angleDiff (copy) ]]
	local v1 = (p1 * p2:Inverse()):ToAxisAngle()

	return v1.Unit * angleDiff(p1, p2)
end

function t2.canSleep(p1) --[[ canSleep | Line: 330 ]]
	local p = p1.p
	local g = p1.g
	local XVector = p.XVector
	local XVector2 = g.XVector
	local YVector = p.YVector
	local YVector2 = g.YVector
	local ZVector = p.ZVector
	local ZVector2 = g.ZVector

	return XVector.X * XVector2.X + XVector.Y * XVector2.Y + XVector.Z * XVector2.Z + (YVector.X * YVector2.X + YVector.Y * YVector2.Y + YVector.Z * YVector2.Z) + (ZVector.X * ZVector2.X + ZVector.Y * ZVector2.Y + ZVector.Z * ZVector2.Z) > 2.9999999695382584 and (if p1.v.Magnitude < 0.0017453292519943296 then true else false)
end
function t2.step(p1, p2) --[[ step | Line: 336 | Upvalues: angleDiff (copy), exp (copy), fromAxisAngle (copy), sqrt (copy), cos (copy), sin (copy) ]]
	local d = p1.d
	local v1 = p1.f * 6.283185307179586
	local g = p1.g
	local p = p1.p
	local v = p1.v
	local v2 = (p * g:Inverse()):ToAxisAngle()
	local v4 = v2.Unit * angleDiff(p, g)
	local v5 = exp(-d * v1 * p2)
	local v6, v7

	if d == 1 then
		local v8 = (v4 * (1 + v1 * p2) + v * p2) * v5
		local identity = CFrame.identity
		local Magnitude = v8.Magnitude

		if Magnitude > 1e-6 then
			identity = fromAxisAngle(v8.Unit, Magnitude)
		end

		v6 = identity * g
		v7 = (v * (1 - p2 * v1) - v4 * (p2 * v1 * v1)) * v5
	elseif d < 1 then
		local v10 = sqrt(1 - d * d)
		local v11 = cos(p2 * v1 * v10)
		local v12 = sin(p2 * v1 * v10)
		local v13 = v12 / v10
		local v14 = (v4 * (v11 + v13 * d) + v * (v12 / (v1 * v10))) * v5
		local identity = CFrame.identity
		local Magnitude = v14.Magnitude

		if Magnitude > 1e-6 then
			identity = fromAxisAngle(v14.Unit, Magnitude)
		end

		v6 = identity * g
		v7 = (v * (v11 - v13 * d) - v4 * (v13 * v1)) * v5
	else
		local v16 = sqrt(d * d - 1)
		local v17 = -v1 * (d + v16)
		local v18 = -v1 * (d - v16)
		local v19 = (v - v4 * v17) / (2 * v1 * v16)
		local v20 = (v4 - v19) * exp(v17 * p2)
		local v21 = v19 * exp(v18 * p2)
		local v22 = v20 + v21
		local identity = CFrame.identity
		local Magnitude = v22.Magnitude

		if Magnitude > 1e-6 then
			identity = fromAxisAngle(v22.Unit, Magnitude)
		end

		v6 = identity * g
		v7 = v20 * v17 + v21 * v18
	end

	p1.p = v6
	p1.v = v7

	return v6
end

local t3 = {
	springType = t.new,
	toIntermediate = function(p1) --[[ toIntermediate | Line: 392 ]]
		return { p1.X, p1.Y, p1.Z }
	end,
	fromIntermediate = function(p1) --[[ fromIntermediate | Line: 396 ]]
		return Vector3.new(p1[1], p1[2], p1[3])
	end
}
local t4 = {}

t4.__index = t4
function t4.new(p1, p2, p3, p4, p5) --[[ new | Line: 406 | Upvalues: t (copy), t3 (copy), t2 (copy), t4 (copy) ]]
	return setmetatable({
		rawGoal = p4,
		_position = t.new(p1, p2, p3.Position, p4.Position, t3),
		_rotation = t2.new(p1, p2, p3.Rotation, p4.Rotation)
	}, t4)
end
function t4.setGoal(p1, p2) --[[ setGoal | Line: 423 ]]
	p1.rawGoal = p2
	p1._position:setGoal(p2.Position)
	p1._rotation:setGoal(p2.Rotation)
end
function t4.setDampingRatio(p1, p2) --[[ setDampingRatio | Line: 429 ]]
	p1._position.d = p2
	p1._rotation.d = p2
end
function t4.setFrequency(p1, p2) --[[ setFrequency | Line: 434 ]]
	p1._position.f = p2
	p1._rotation.f = p2
end
function t4.canSleep(p1) --[[ canSleep | Line: 439 ]]
	return p1._position:canSleep() and p1._rotation:canSleep()
end
function t4.step(p1, p2) --[[ step | Line: 443 ]]
	local v1 = p1._position:step(p2)

	return p1._rotation:step(p2) + v1
end

local function inverseGammaCorrectD65(p1) --[[ inverseGammaCorrectD65 | Line: 454 ]]
	return p1 < 0.0404482362771076 and p1 / 12.92 or 0.87941546140213 * (p1 + 0.055) ^ 2.4
end

local function gammaCorrectD65(p1) --[[ gammaCorrectD65 | Line: 458 ]]
	return p1 < 0.0031306684425 and 12.92 * p1 or 1.055 * p1 ^ 0.4166666666666667 - 0.055
end

local function rgbToLuv(p1) --[[ rgbToLuv | Line: 462 ]]
	local R = p1.R
	local G = p1.G
	local B = p1.B
	local v1, v2

	if R < 0.0404482362771076 then
		v1 = R / 12.92

		if not v1 then
			v2 = R
			v1 = 0.87941546140213 * (R + 0.055) ^ 2.4
		end
	else
		v2 = R
		v1 = 0.87941546140213 * (R + 0.055) ^ 2.4
	end

	local v3, v4

	if G < 0.0404482362771076 then
		v3 = G / 12.92

		if not v3 then
			v4 = G
			v3 = 0.87941546140213 * (G + 0.055) ^ 2.4
		end
	else
		v4 = G
		v3 = 0.87941546140213 * (G + 0.055) ^ 2.4
	end

	local v5, v6

	if B < 0.0404482362771076 then
		v5 = B / 12.92

		if not v5 then
			v6 = B
			v5 = 0.87941546140213 * (B + 0.055) ^ 2.4
		end
	else
		v6 = B
		v5 = 0.87941546140213 * (B + 0.055) ^ 2.4
	end

	local v7 = 0.9257063972951867 * v1 - 0.8333736323779866 * v3 - 0.09209820666085898 * v5
	local v8 = 0.2125862307855956 * v1 + 0.7151703037034108 * v3 + 0.0722004986433362 * v5
	local v9 = 3.6590806972265884 * v1 + 11.442689580057424 * v3 + 4.114991502426484 * v5
	local v10 = v8 > 0.008856451679035631 and 116 * v8 ^ 0.3333333333333333 - 16 or 903.296296296296 * v8
	local v11, v12

	if v9 > 1e-14 then
		v11 = v10 * v7 / v9
		v12 = v10 * (9 * v8 / v9 - 0.46832)
	else
		v11 = -0.19783 * v10
		v12 = -0.46832 * v10
	end

	return { v10, v11, v12 }
end

local function luvToRgb(p1) --[[ luvToRgb | Line: 491 | Upvalues: min (copy) ]]
	local v1 = p1[1]

	if v1 < 0.0197955 then
		return Color3.new(0/255, 0/255, 0/255)
	end

	local v2 = p1[2] / v1 + 0.19783
	local v3 = p1[3] / v1 + 0.46832
	local v4 = (v1 + 16) / 116
	local v5 = v4 > 0.20689655172413793 and v4 * v4 * v4 or v4 * 0.12841854934601665 - 0.01771290335807126
	local v6 = v5 * v2 / v3
	local v7 = v5 * ((3 - v2 * 0.75) / v3 - 5)
	local sum = v6 * 7.2914074 - v5 * 1.537208 - v7 * 0.4986286
	local sum2 = v6 * -2.180094 + v5 * 1.8757561 + v7 * 0.0415175
	local sum3 = v6 * 0.1253477 - v5 * 0.2040211 + v7 * 1.0569959

	if sum < 0 and (sum < sum2 and sum < sum3) then
		sum = 0
		sum2 = sum2 - sum
		sum3 = sum3 - sum
	elseif sum2 < 0 and sum2 < sum3 then
		sum = sum - sum2
		sum2 = 0
		sum3 = sum3 - sum2
	elseif sum3 < 0 then
		sum = sum - sum3
		sum2 = sum2 - sum3
		sum3 = 0
	end

	local v8 = Color3.new
	local v9, v10

	if sum < 0.0031306684425 then
		v9 = 12.92 * sum

		if not v9 then
			v10 = sum
			v9 = 1.055 * sum ^ 0.4166666666666667 - 0.055
		end
	else
		v10 = sum
		v9 = 1.055 * sum ^ 0.4166666666666667 - 0.055
	end

	local v11 = min(v9, 1)
	local v12, v13

	if sum2 < 0.0031306684425 then
		v12 = 12.92 * sum2

		if not v12 then
			v13 = sum2
			v12 = 1.055 * sum2 ^ 0.4166666666666667 - 0.055
		end
	else
		v13 = sum2
		v12 = 1.055 * sum2 ^ 0.4166666666666667 - 0.055
	end

	local v14 = min(v12, 1)
	local v15, v16

	if sum3 < 0.0031306684425 then
		v15 = 12.92 * sum3

		if not v15 then
			v16 = sum3
			v15 = 1.055 * sum3 ^ 0.4166666666666667 - 0.055
		end
	else
		v16 = sum3
		v15 = 1.055 * sum3 ^ 0.4166666666666667 - 0.055
	end

	return v8(v11, v14, (min(v15, 1)))
end

local t5 = {
	boolean = {
		springType = t.new,
		toIntermediate = function(p1) --[[ toIntermediate | Line: 537 ]]
			local t = {}

			t[1] = if p1 then 1 else 0

			return t
		end,
		fromIntermediate = function(p1) --[[ fromIntermediate | Line: 541 ]]
			return p1[1] >= 0.5
		end
	},
	number = {
		springType = t.new,
		toIntermediate = function(p1) --[[ toIntermediate | Line: 549 ]]
			return { p1 }
		end,
		fromIntermediate = function(p1) --[[ fromIntermediate | Line: 553 ]]
			return p1[1]
		end
	},
	NumberRange = {
		springType = t.new,
		toIntermediate = function(p1) --[[ toIntermediate | Line: 561 ]]
			return { p1.Min, p1.Max }
		end,
		fromIntermediate = function(p1) --[[ fromIntermediate | Line: 565 ]]
			return NumberRange.new(p1[1], p1[2])
		end
	},
	UDim = {
		springType = t.new,
		toIntermediate = function(p1) --[[ toIntermediate | Line: 573 ]]
			return { p1.Scale, p1.Offset }
		end,
		fromIntermediate = function(p1) --[[ fromIntermediate | Line: 577 | Upvalues: round (copy) ]]
			return UDim.new(p1[1], (round(p1[2])))
		end
	},
	UDim2 = {
		springType = t.new,
		toIntermediate = function(p1) --[[ toIntermediate | Line: 585 ]]
			local X = p1.X
			local Y = p1.Y

			return {
				X.Scale,
				X.Offset,
				Y.Scale,
				Y.Offset
			}
		end,
		fromIntermediate = function(p1) --[[ fromIntermediate | Line: 591 | Upvalues: round (copy) ]]
			return UDim2.new(p1[1], round(p1[2]), p1[3], (round(p1[4])))
		end
	},
	Vector2 = {
		springType = t.new,
		toIntermediate = function(p1) --[[ toIntermediate | Line: 599 ]]
			return { p1.X, p1.Y }
		end,
		fromIntermediate = function(p1) --[[ fromIntermediate | Line: 603 ]]
			return Vector2.new(p1[1], p1[2])
		end
	},
	Vector3 = t3,
	Color3 = {
		springType = t.new,
		toIntermediate = rgbToLuv,
		fromIntermediate = luvToRgb
	},
	ColorSequence = {
		springType = t.new,
		toIntermediate = function(p1) --[[ toIntermediate | Line: 620 | Upvalues: rgbToLuv (ref) ]]
			local Keypoints = p1.Keypoints
			local v1 = rgbToLuv(Keypoints[1].Value)
			local v2 = rgbToLuv(Keypoints[#Keypoints].Value)

			return {
				v1[1],
				v1[2],
				v1[3],
				v2[1],
				v2[2],
				v2[3]
			}
		end,
		fromIntermediate = function(p1) --[[ fromIntermediate | Line: 632 | Upvalues: luvToRgb (ref) ]]
			return ColorSequence.new(luvToRgb({ p1[1], p1[2], p1[3] }), luvToRgb({ p1[4], p1[5], p1[6] }))
		end
	},
	CFrame = {
		springType = t4.new,
		toIntermediate = error,
		fromIntermediate = error
	}
}
local t6 = {
	Pivot = {
		class = "PVInstance",
		get = function(p1) --[[ get | Line: 658 ]]
			return p1:GetPivot()
		end,
		set = function(p1, p2) --[[ set | Line: 661 ]]
			p1:PivotTo(p2)
		end
	},
	Scale = {
		class = "Model",
		get = function(p1) --[[ get | Line: 667 ]]
			return p1:GetScale()
		end,
		set = function(p1, p2) --[[ set | Line: 670 ]]
			p1:ScaleTo((math.clamp(p2, 1.402e-45, 16777216)))
		end
	}
}

local function getProperty(p1, p2) --[[ getProperty | Line: 679 | Upvalues: t6 (copy) ]]
	local v1 = t6[p2]

	if v1 and p1:IsA(v1.class) then
		return v1.get(p1)
	end

	return p1[p2]
end

local function setProperty(p1, p2, p3) --[[ setProperty | Line: 688 | Upvalues: t6 (copy) ]]
	local v1 = t6[p2]

	if v1 and p1:IsA(v1.class) then
		v1.set(p1, p3)

		return
	end

	p1[p2] = p3
end

local t7 = {}
local t8 = {}
local t9 = {}

local function processSprings(p1, p2) --[[ processSprings | Line: 702 | Upvalues: t6 (copy), t9 (copy) ]]
	for v1, v2 in p1 do
		for v3, v4 in v2 do
			if v4:canSleep() then
				v2[v3] = nil

				local rawGoal = v4.rawGoal
				local v5 = t6[v3]

				if v5 and v1:IsA(v5.class) then
					v5.set(v1, rawGoal)

					continue
				end

				v1[v3] = rawGoal

				continue
			end

			local v6 = v4:step(p2)
			local v7 = t6[v3]

			if v7 and v1:IsA(v7.class) then
				v7.set(v1, v6)

				continue
			end

			v1[v3] = v6
		end

		if not next(v2) then
			p1[v1] = nil

			local v8 = t9[v1]

			if v8 then
				t9[v1] = nil

				for v9, v10 in v8 do
					task.spawn(v10)
				end
			end
		end
	end
end

RunService.PreSimulation:Connect(function(p1) --[[ Line: 731 | Upvalues: processSprings (copy), t7 (copy) ]]
	processSprings(t7, p1)
end)
RunService.PostSimulation:Connect(function(p1) --[[ Line: 735 | Upvalues: processSprings (copy), t8 (copy) ]]
	processSprings(t8, p1)
end)

local function assertType(p1, p2, p3, p4) --[[ assertType | Line: 739 ]]
	if p3:find((typeof(p4))) then
		return
	end

	error(("bad argument #%* to %* (%* expected, got %*)"):format(p1, p2, p3, (typeof(p4))), 3)
end

return table.freeze({
	target = function(p1, p2, p3, p4) --[[ target | Line: 748 | Upvalues: t8 (copy), t7 (copy), t6 (copy), t5 (copy) ]]
		if not ("Instance"):find((typeof(p1))) then
			error(("bad argument #%* to spr.target (Instance expected, got %*)"):format(1, (typeof(p1))), 3)
		end

		if not ("number"):find((typeof(p2))) then
			error(("bad argument #%* to spr.target (number expected, got %*)"):format(2, (typeof(p2))), 3)
		end

		if not ("number"):find((typeof(p3))) then
			error(("bad argument #%* to spr.target (number expected, got %*)"):format(3, (typeof(p3))), 3)
		end

		if not ("table"):find((typeof(p4))) then
			error(("bad argument #%* to spr.target (table expected, got %*)"):format(4, (typeof(p4))), 3)
		end

		if p2 ~= p2 or p2 < 0 then
			error(("expected damping ratio >= 0; got %.2f"):format(p2), 2)
		end

		if p3 ~= p3 or p3 < 0 then
			error(("expected undamped frequency >= 0; got %.2f"):format(p3), 2)
		end

		local v1 = if p1:IsA("Camera") then t8 else t7
		local v2 = v1[p1]

		if not v2 then
			v2 = {}
			v1[p1] = v2
		end

		for v4, v5 in p4 do
			local v3
			local v6 = t6[v4]

			v3 = if v6 and p1:IsA(v6.class) then v6.get(p1) else p1[v4]

			if typeof(v5) ~= typeof(v3) then
				error(("bad property %* to spr.target (%* expected, got %*)"):format(v4, typeof(v3), (typeof(v5))), 2)
			end

			if p3 == (1 / 0) then
				local v8 = t6[v4]

				if v8 and p1:IsA(v8.class) then
					v8.set(p1, v5)
				else
					p1[v4] = v5
				end

				v2[v4] = nil

				continue
			end

			local v9 = v2[v4]

			if not v9 then
				local v10 = t5[typeof(v5)]

				if not v10 then
					error("unsupported type: " .. typeof(v5), 2)
				end

				local v11 = v10.springType(p2, p3, v3, v5, v10)

				v2[v4] = v11
				v9 = v11
			end

			v9:setGoal(v5)
			v9:setDampingRatio(p2)
			v9:setFrequency(p3)
		end

		if next(v2) then
			return
		end

		v1[p1] = nil
	end,
	stop = function(p1, p2) --[[ stop | Line: 807 | Upvalues: t7 (copy), t8 (copy) ]]
		if not ("Instance"):find((typeof(p1))) then
			error(("bad argument #%* to spr.stop (Instance expected, got %*)"):format(1, (typeof(p1))), 3)
		end

		if not ("string|nil"):find((typeof(p2))) then
			error(("bad argument #%* to spr.stop (string|nil expected, got %*)"):format(2, (typeof(p2))), 3)
		end

		if p2 then
			local v1 = t7[p1] or t8[p1]

			if v1 then
				v1[p2] = nil
			end
		else
			t7[p1] = nil
			t8[p1] = nil
		end
	end,
	completed = function(p1, p2) --[[ completed | Line: 824 | Upvalues: t9 (copy) ]]
		if not ("Instance"):find((typeof(p1))) then
			error(("bad argument #%* to spr.completed (Instance expected, got %*)"):format(1, (typeof(p1))), 3)
		end

		if not ("function"):find((typeof(p2))) then
			error(("bad argument #%* to spr.completed (function expected, got %*)"):format(2, (typeof(p2))), 3)
		end

		local v1 = t9[p1]

		if v1 then
			table.insert(v1, p2)
		else
			t9[p1] = { p2 }
		end
	end
})
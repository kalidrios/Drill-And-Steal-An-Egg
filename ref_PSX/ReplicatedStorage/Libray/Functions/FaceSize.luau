local function swapYZ(p)
	return Vector3.new(p.Z, p.X, p.Y)
end

local function swapXZ(p)
	return Vector3.new(p.Z, p.Y, p.X)
end

local function swapXY(p)
	return Vector3.new(p.X, p.Y, p.Z)
end

local operations = {
	[Enum.NormalId.Top] = swapYZ,
	[Enum.NormalId.Bottom] = swapYZ,
	[Enum.NormalId.Left] = swapXZ,
	[Enum.NormalId.Right] = swapXZ,
	[Enum.NormalId.Front] = swapXY,
	[Enum.NormalId.Back] = swapXY
}

return function(normalId, vector3)
	local operation = operations[normalId]
	if operation then
		return operation(vector3)
	else
		return vector3
	end
end
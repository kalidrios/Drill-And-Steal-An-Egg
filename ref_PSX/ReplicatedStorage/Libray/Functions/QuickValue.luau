-- https://github.com/kalidrios

local table1 = {
	boolean = "BoolValue",
	number = "NumberValue",
	string = "StringValue",
	BrickColor = "BrickColorValue",
	CFrame = "CFrameValue",
	Color3 = "Color3Value",
	Ray = "RayValue",
	Vector3 = "Vector3Value",
	Instance = "InstanceValue"
};
return function(p1, p2) -- Line: 24
	--[[
		Upvalues:
			[1] = table1
	--]]
	local v1 = table1[typeof(p1)];
	if not v1 then
		error("Value type not supported: " .. typeof(p1));
		return;
	end
	local Instance_new_ret = Instance.new(v1);
	Instance_new_ret.Value = p1;
	if p2 then
		Instance_new_ret.Parent = p2;
	end
	return Instance_new_ret;
end;

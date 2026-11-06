-- https://github.com/kalidrios

local table1 = {serializers = {}};
function table1.encode(p1, p2) -- Line: 7
	--[[
		Upvalues:
			[1] = table1
	--]]
	if p1 ~= nil then
		local v1 = table1.serializers[typeof(p1)];
		if v1 then
			p1 = v1(p1, p2 or {});
			return p1;
		end
		error(string.format("Unknown type: %s", (typeof(p1))));
	end
	return p1;
end
table1.serializers = {
	["nil"] = function() -- Line: 21
		return nil;
	end,
	boolean = function(p3) -- boolean (Line: 24)
		return p3;
	end,
	number = function(p4) -- number (Line: 27)
		return p4;
	end,
	string = function(p5) -- string (Line: 30)
		return p5;
	end,
	table = function(p6, p7) -- Line: 33
		--[[
			Upvalues:
				[1] = table1
		--]]
		assert(p7[p6] == nil);
		local table2 = {};
		p7[p6] = table2;
		if #p6 > 0 then
			for _, val2 in ipairs(p6) do
				table.insert(table2, table1.encode(val2, p7));
			end
			return table2;
		end
		for key1, val1 in pairs(p6) do
			table2[table1.encode(key1, p7)] = table1.encode(val1, p7);
		end
		return table2;
	end,
	Axes = function(p8) -- Axes (Line: 48)
		return {
			p8.X,
			p8.Y,
			p8.Z,
			p8.Top,
			p8.Bottom,
			p8.Left,
			p8.Right,
			p8.Back,
			p8.Front
		};
	end,
	BrickColor = function(p9) -- BrickColor (Line: 51)
		return p9.Name;
	end,
	CFrame = function(p10) -- CFrame (Line: 54)
		return p10:GetComponents();
	end,
	CatalogSearchParams = function(p11, p12) -- CatalogSearchParams (Line: 57)
		--[[
			Upvalues:
				[1] = table1
		--]]
		local table3 = {
			SearchKeyword = p11.SearchKeyword,
			MinPrice = p11.MinPrice,
			MaxPrice = p11.MaxPrice,
			SortType = table1.encode(p11.SortType, p12),
			CategoryFilter = table1.encode(p11.CategoryFilter, p12),
			BundleType = table1.encode(p11.BundleTypes, p12),
			AssetTypes = table1.encode(p11.AssetTypes, p12)
		};
		return table3;
	end,
	Color3 = function(p13) -- Color3 (Line: 68)
		return {
			p13.R,
			p13.G,
			p13.B
		};
	end,
	ColorSequence = function(p14, p15) -- ColorSequence (Line: 71)
		--[[
			Upvalues:
				[1] = table1
		--]]
		return table1.encode(p14.Keypoints, p15);
	end,
	ColorSequenceKeypoint = function(p16, p17) -- ColorSequenceKeypoint (Line: 74)
		--[[
			Upvalues:
				[1] = table1
		--]]
		local table4 = {
			Time = p16.Time,
			Value = table1.encode(p16.Value, p17)
		};
		return table4;
	end,
	DateTime = function(p18) -- DateTime (Line: 80)
		return p18.UnixTimestampMillis;
	end,
	DockWidgetPluginGuiInfo = function(p19) -- DockWidgetPluginGuiInfo (Line: 83)
		local table5 = {
			InitialEnabled = p19.InitialEnabled,
			InitialEnabledShouldOverrideRestore = p19.InitialEnabledShouldOverrideRestore,
			FloatingXSize = p19.FloatingXSize,
			FloatingYSize = p19.FloatingYSize,
			MinWidth = p19.MinWidth,
			MinHeight = p19.MinHeight
		};
		return table5;
	end,
	Enum = function(p20) -- Enum (Line: 93)
		return tostring(p20);
	end,
	EnumItem = function(p21) -- EnumItem (Line: 96)
		return p21.Name;
	end,
	Faces = function(p22) -- Faces (Line: 102)
		return {
			p22.Top,
			p22.Bottom,
			p22.Left,
			p22.Right,
			p22.Back,
			p22.Front
		};
	end,
	FloatCurveKey = function(p23, p24) -- FloatCurveKey (Line: 105)
		--[[
			Upvalues:
				[1] = table1
		--]]
		local table6 = {
			Interpolation = table1.encode(p23.Interpolation, p24),
			Time = p23.Time,
			Value = p23.Value,
			RightTangent = p23.RightTangent,
			LeftTangent = p23.LeftTangent
		};
		return table6;
	end,
	Font = function(p25, p26) -- Font (Line: 114)
		--[[
			Upvalues:
				[1] = table1
		--]]
		local table7 = {
			Family = table1.encode(p25.Family, p26),
			Weight = table1.encode(p25.Weight, p26),
			Style = table1.encode(p25.Style, p26),
			Bold = p25.Bold
		};
		return table7;
	end,
	NumberRange = function(p27) -- NumberRange (Line: 125)
		return {
			p27.Min,
			p27.Max
		};
	end,
	NumberSequence = function(p28, p29) -- NumberSequence (Line: 128)
		--[[
			Upvalues:
				[1] = table1
		--]]
		return table1.encode(p28.Keypoints, p29);
	end,
	NumberSequenceKeypoint = function(p30) -- NumberSequenceKeypoint (Line: 131)
		local table8 = {
			Envelope = p30.Envelope,
			Time = p30.Time,
			Value = p30.Value
		};
		return table8;
	end,
	OverlapParams = function(p31, p32) -- OverlapParams (Line: 138)
		--[[
			Upvalues:
				[1] = table1
		--]]
		local table9 = {
			FilterDescendantsInstances = table1.encode(p31.FilterDescendantsInstances, p32),
			FilterType = table1.encode(p31.FilterType, p32),
			MaxParts = p31.MaxParts,
			CollisionGroup = p31.CollisionGroup
		};
		return table9;
	end,
	PathWaypoint = function(p33, p34) -- PathWaypoint (Line: 146)
		--[[
			Upvalues:
				[1] = table1
		--]]
		local table10 = {
			Action = table1.encode(p33.Action, p34),
			Position = table1.encode(p33.Position, p34),
			Label = p33.Label
		};
		return table10;
	end,
	PhysicalProperties = function(p35) -- PhysicalProperties (Line: 153)
		local table11 = {
			Density = p35.Density,
			Friction = p35.Friction,
			Elasticity = p35.Elasticity,
			FrictionWeight = p35.FrictionWeight,
			ElasticityWeight = p35.ElasticityWeight
		};
		return table11;
	end,
	Ray = function(p36, p37) -- Ray (Line: 171)
		--[[
			Upvalues:
				[1] = table1
		--]]
		local table12 = {
			Origin = table1.encode(p36.Origin, p37),
			Direction = table1.encode(p36.Direction, p37)
		};
		return table12;
	end,
	RaycastParams = function(p38, p39) -- RaycastParams (Line: 177)
		--[[
			Upvalues:
				[1] = table1
		--]]
		local table13 = {
			FilterDescendantsInstances = table1.encode(p38.FilterDescendantsInstances, p39),
			FilterType = table1.encode(p38.FilterType, p39),
			IgnoreWater = p38.IgnoreWater,
			CollisionGroup = p38.CollisionGroup
		};
		return table13;
	end,
	Rect = function(p40) -- Rect (Line: 194)
		return {
			p40.Min.X,
			p40.Min.Y,
			p40.Max.X,
			p40.Max.Y
		};
	end,
	Region3 = function(p41, p42) -- Region3 (Line: 197)
		--[[
			Upvalues:
				[1] = table1
		--]]
		local v2 = p41.Size / 2;
		return {
			table1.encode(p41.CFrame.Position - v2, p42),
			table1.encode(p41.CFrame.Position + v2, p42)
		};
	end,
	Region3int16 = function(p43, p44) -- Region3int16 (Line: 201)
		--[[
			Upvalues:
				[1] = table1
		--]]
		return {
			table1.encode(p43.Min, p44),
			table1.encode(p43.Max, p44)
		};
	end,
	TweenInfo = function(p45, p46) -- TweenInfo (Line: 204)
		--[[
			Upvalues:
				[1] = table1
		--]]
		local table14 = {
			EasingDirection = table1.encode(p45.EasingDirection, p46),
			Time = p45.Time,
			DelayTime = p45.DelayTime,
			RepeatCount = p45.RepeatCount,
			EasingStyle = table1.encode(p45.EasingStyle, p46),
			Reverses = p45.Reverses
		};
		return table14;
	end,
	UDim = function(p47) -- UDim (Line: 214)
		return {
			p47.Scale,
			p47.Offset
		};
	end,
	UDim2 = function(p48, p49) -- UDim2 (Line: 217)
		--[[
			Upvalues:
				[1] = table1
		--]]
		local table15 = {
			X = table1.encode(p48.X, p49),
			Y = table1.encode(p48.Y, p49),
			Width = table1.encode(p48.Width, p49),
			Height = table1.encode(p48.Height, p49)
		};
		return table15;
	end,
	Vector2 = function(p50) -- Vector2 (Line: 225)
		return {
			p50.X,
			p50.Y
		};
	end,
	Vector2int16 = function(p51) -- Vector2int16 (Line: 228)
		return {
			p51.X,
			p51.Y
		};
	end,
	Vector3 = function(p52) -- Vector3 (Line: 231)
		return {
			p52.X,
			p52.Y,
			p52.Z
		};
	end,
	Vector3int16 = function(p53) -- Vector3int16 (Line: 234)
		return {
			p53.X,
			p53.Y,
			p53.Z
		};
	end
};
return table1;

-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local Random_new_ret = Random.new();
local table1 = nil;
local function getScalar(p1, p2) -- Line: 8
	local FindFirstChild_ret = p1:FindFirstChild(p2);
	if FindFirstChild_ret then
		assert(FindFirstChild_ret:IsA("NumberValue"));
		return FindFirstChild_ret;
	end
	local NumberValue = Instance.new("NumberValue");
	NumberValue.Name = p2;
	NumberValue.Value = 1;
	NumberValue.Parent = p1;
	return NumberValue;
end
local function removeScalar(p3, p4) -- Line: 21
	local FindFirstChild_ret2 = p3:FindFirstChild(p4);
	if FindFirstChild_ret2 then
		FindFirstChild_ret2:Destroy();
	end
	return FindFirstChild_ret2;
end
function UpdateStatues() -- Line: 29
	--[[
		Upvalues:
			[1] = table1
			[2] = m_Library
			[3] = Random_new_ret
	--]]
	if table1 == nil or #table1 < 1 then return end
	local u2 = m_Library.Functions.DeepCopy(require(script.Animations));
	for _, val1 in ipairs(table1) do
		local Attribute = val1:GetAttribute("pool");
		local Attribute2 = val1:GetAttribute("position");
		local u4 = m_Library.Network.Invoke("Player Statues: Get Statue Data", Attribute, Attribute2);
		if u4 == nil then continue end
		task.spawn(function() -- Line: 43
			local t_userId = u4.userId;
			local StatueCharacter = val1:FindFirstChild("StatueCharacter");
			if not StatueCharacter then return end
			if StatueCharacter:GetAttribute("UserId") == t_userId then return end
			StatueCharacter:Destroy();
			local Clone_ret = m_Library.Assets:WaitForChild("Models"):WaitForChild("StatueCharacter"):Clone();
			Clone_ret:SetAttribute("UserId", t_userId);
			local Stand = val1:WaitForChild("Stand");
			assert(Stand:IsA("BasePart"));
			local Attachment = Stand:WaitForChild("Attachment");
			assert(Attachment:IsA("Attachment"));
			local t_PrimaryPart = Clone_ret.PrimaryPart;
			if not t_PrimaryPart then return end
			assert(t_PrimaryPart);
			local Humanoid = Clone_ret:FindFirstChildOfClass("Humanoid");
			if not Humanoid then return end
			assert(Humanoid);
			local Animation = Humanoid:FindFirstChild("Animation");
			if not Animation then return end
			assert(Animation);
			local v1 = Humanoid:FindFirstChildOfClass("Animator");
			if not v1 then
				v1 = Instance.new("Animator");
				v1.Parent = Humanoid;
			end
			assert(v1);
			Clone_ret:PivotTo(CFrame.new(0, -1000, 0));
			t_PrimaryPart.Anchored = true;
			local BodyDepthScale = Humanoid:FindFirstChild("BodyDepthScale");
			if BodyDepthScale then
				BodyDepthScale:Destroy();
			end
			local BodyHeightScale = Humanoid:FindFirstChild("BodyHeightScale");
			if BodyHeightScale then
				BodyHeightScale:Destroy();
			end
			local BodyProportionScale = Humanoid:FindFirstChild("BodyProportionScale");
			if BodyProportionScale then
				BodyProportionScale:Destroy();
			end
			local BodyTypeScale = Humanoid:FindFirstChild("BodyTypeScale");
			if BodyTypeScale then
				BodyTypeScale:Destroy();
			end
			local BodyWidthScale = Humanoid:FindFirstChild("BodyWidthScale");
			if BodyWidthScale then
				BodyWidthScale:Destroy();
			end
			local HeadScale = Humanoid:FindFirstChild("HeadScale");
			if HeadScale then
				HeadScale:Destroy();
			end
			Humanoid.AutomaticScalingEnabled = true;
			Clone_ret.Parent = val1;
			local NextInteger_ret = Random_new_ret:NextInteger(1, #u2);
			Animation.AnimationId = "rbxassetid://" .. u2[NextInteger_ret];
			table.remove(u2, NextInteger_ret);
			local LoadAnimation_ret = v1:LoadAnimation(Animation);
			local HumanoidDescriptionFromUserId = m_Library.Players:GetHumanoidDescriptionFromUserId(t_userId);
			local v2 = (Stand.Size / Vector3.new(1.196, 13.523, 13.523)).Magnitude * 2.5;
			HumanoidDescriptionFromUserId.DepthScale = HumanoidDescriptionFromUserId.DepthScale * v2;
			HumanoidDescriptionFromUserId.HeightScale = HumanoidDescriptionFromUserId.HeightScale * v2;
			HumanoidDescriptionFromUserId.HeadScale = HumanoidDescriptionFromUserId.HeadScale * v2;
			HumanoidDescriptionFromUserId.WidthScale = HumanoidDescriptionFromUserId.WidthScale * v2;
			pcall(function() -- Line: 115
				--[[
					Upvalues:
						[1] = Humanoid
						[2] = HumanoidDescriptionFromUserId
				--]]
				Humanoid:ApplyDescriptionReset(HumanoidDescriptionFromUserId);
			end);
			local t_WorldCFrame = Attachment.WorldCFrame;
			local u6 = t_WorldCFrame + t_WorldCFrame.UpVector * (t_PrimaryPart.Size.Y / 2 + Humanoid.HipHeight);
			task.delay(2.5, function() -- Line: 122
				--[[
					Upvalues:
						[1] = LoadAnimation_ret
						[2] = Clone_ret
						[3] = u6
				--]]
				LoadAnimation_ret:Play();
				Clone_ret:PivotTo(u6);
			end);
		end);
	end
end
function Load(p5, _, p6) -- Line: 132
	--[[
		Upvalues:
			[1] = table1
			[2] = m_Library
			[3] = Random_new_ret
	--]]
	if p5 ~= nil then
		if table1 then
			for _, val3 in ipairs(table1) do
				if val3 == nil then continue end
				val3:Destroy();
			end
		end
		table1 = {};
	end
	local Map = m_Library.WorldCmds.GetMap();
	if not Map then return end
	local Statues = Map:FindFirstChild("Statues");
	if not Statues then return end
	local u3 = m_Library.Functions.DeepCopy(require(script.Animations));
	for _, child2 in ipairs(Statues:GetChildren()) do
		assert(child2:IsA("Model"));
		local Attribute3 = child2:GetAttribute("pool");
		local Attribute4 = child2:GetAttribute("position");
		if p6 ~= nil and Attribute3 ~= p6 then continue end
		local u5 = m_Library.Network.Invoke("Player Statues: Get Statue Data", Attribute3, Attribute4);
		if u5 == nil or table.find(table1, child2) then continue end
		table.insert(table1, child2);
		task.spawn(function() -- Line: 174
			--[[
				Upvalues:
					[1] = u5
					[2] = child2
					[3] = m_Library
					[4] = Random_new_ret
					[5] = u3
			--]]
			local t_userId2 = u5.userId;
			local Stand2 = child2:WaitForChild("Stand");
			assert(Stand2:IsA("BasePart"));
			local Attachment2 = Stand2:WaitForChild("Attachment");
			assert(Attachment2:IsA("Attachment"));
			local Clone_ret2 = m_Library.Assets:WaitForChild("Models"):WaitForChild("StatueCharacter"):Clone();
			assert(Clone_ret2:IsA("Model"));
			local t_PrimaryPart2 = Clone_ret2.PrimaryPart;
			if not t_PrimaryPart2 then return end
			assert(t_PrimaryPart2);
			local Humanoid2 = Clone_ret2:FindFirstChildOfClass("Humanoid");
			if not Humanoid2 then return end
			assert(Humanoid2);
			local Animation2 = Humanoid2:FindFirstChild("Animation");
			if not Animation2 then return end
			assert(Animation2);
			local v3 = Humanoid2:FindFirstChildOfClass("Animator");
			if not v3 then
				v3 = Instance.new("Animator");
				v3.Parent = Humanoid2;
			end
			assert(v3);
			Clone_ret2:PivotTo(CFrame.new(0, -1000, 0));
			t_PrimaryPart2.Anchored = true;
			local BodyDepthScale2 = Humanoid2:FindFirstChild("BodyDepthScale");
			if BodyDepthScale2 then
				BodyDepthScale2:Destroy();
			end
			local BodyHeightScale2 = Humanoid2:FindFirstChild("BodyHeightScale");
			if BodyHeightScale2 then
				BodyHeightScale2:Destroy();
			end
			local BodyProportionScale2 = Humanoid2:FindFirstChild("BodyProportionScale");
			if BodyProportionScale2 then
				BodyProportionScale2:Destroy();
			end
			local BodyTypeScale2 = Humanoid2:FindFirstChild("BodyTypeScale");
			if BodyTypeScale2 then
				BodyTypeScale2:Destroy();
			end
			local BodyWidthScale2 = Humanoid2:FindFirstChild("BodyWidthScale");
			if BodyWidthScale2 then
				BodyWidthScale2:Destroy();
			end
			local HeadScale2 = Humanoid2:FindFirstChild("HeadScale");
			if HeadScale2 then
				HeadScale2:Destroy();
			end
			Humanoid2.AutomaticScalingEnabled = true;
			Clone_ret2.Parent = child2;
			if Clone_ret2:GetAttribute("UserId") == t_userId2 then return end
			Clone_ret2:SetAttribute("UserId", t_userId2);
			local NextInteger_ret2 = Random_new_ret:NextInteger(1, #u3);
			Animation2.AnimationId = "rbxassetid://" .. u3[NextInteger_ret2];
			table.remove(u3, NextInteger_ret2);
			local LoadAnimation_ret2 = v3:LoadAnimation(Animation2);
			local HumanoidDescriptionFromUserId2 = m_Library.Players:GetHumanoidDescriptionFromUserId(t_userId2);
			local v4 = (Stand2.Size / Vector3.new(1.196, 13.523, 13.523)).Magnitude * 2.5;
			HumanoidDescriptionFromUserId2.DepthScale = HumanoidDescriptionFromUserId2.DepthScale * v4;
			HumanoidDescriptionFromUserId2.HeightScale = HumanoidDescriptionFromUserId2.HeightScale * v4;
			HumanoidDescriptionFromUserId2.HeadScale = HumanoidDescriptionFromUserId2.HeadScale * v4;
			HumanoidDescriptionFromUserId2.WidthScale = HumanoidDescriptionFromUserId2.WidthScale * v4;
			pcall(function() -- Line: 248
				--[[
					Upvalues:
						[1] = Humanoid2
						[2] = HumanoidDescriptionFromUserId2
				--]]
				Humanoid2:ApplyDescriptionReset(HumanoidDescriptionFromUserId2);
			end);
			local t_WorldCFrame2 = Attachment2.WorldCFrame;
			local u7 = t_WorldCFrame2 + t_WorldCFrame2.UpVector * (t_PrimaryPart2.Size.Y / 2 + Humanoid2.HipHeight);
			task.delay(2.5, function() -- Line: 255
				--[[
					Upvalues:
						[1] = LoadAnimation_ret2
						[2] = Clone_ret2
						[3] = u7
				--]]
				LoadAnimation_ret2:Play();
				Clone_ret2:PivotTo(u7);
			end);
		end);
	end
end
local u1 = 0;
m_Library.RunService.Heartbeat:Connect(function(p7) -- Line: 278
	--[[
		Upvalues:
			[1] = u1
	--]]
	u1 = u1 + p7;
	if u1 > 10 then
		u1 = u1 - 10;
		UpdateStatues();
	end
end);
m_Library.Signal.Fired("World Changed"):Connect(Load);
m_Library.Network.Fired("Player Statues: Pool loaded"):Connect(function(p8) -- Line: 290
	Load(nil, nil, p8);
end);

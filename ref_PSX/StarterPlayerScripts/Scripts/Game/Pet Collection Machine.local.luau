-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local Random_new_ret = Random.new();
local u1 = nil;
local bool1 = false;
function Setup() -- Line: 19
	--[[
		Upvalues:
			[1] = bool1
			[2] = u1
			[3] = m_Library
			[4] = Random_new_ret
	--]]
	if bool1 then return end
	bool1 = true;
	if u1.PrimaryPart then
		local v1 = m_Library.Audio.Play("rbxassetid://7349142463", u1.PrimaryPart, 0.8, 0.3, nil, nil, true);
		if v1 then
			v1.RollOffMaxDistance = 55;
			v1.RollOffMinDistance = 10;
		end
	end
	local coroutine_wrap_ret4 = coroutine.wrap(function() -- Line: 35
		--[[
			Upvalues:
				[1] = u1
				[2] = m_Library
				[3] = Random_new_ret
				[4] = bool1
		--]]
		local SurfaceGui = u1.Screen:FindFirstChildOfClass("SurfaceGui");
		local function UpdateBottom() -- Line: 38
			--[[
				Upvalues:
					[1] = m_Library
					[2] = u1
					[3] = SurfaceGui
			--]]
			local v2 = m_Library.Save.Get();
			if not v2 then return end
			local v3 = #v2.Collection;
			local v4 = #m_Library.Shared.GetAllCollectablePets();
			if not u1 or not u1.Parent or not SurfaceGui or not SurfaceGui.Parent then return end
			SurfaceGui.PetAm.Text = m_Library.Functions.Commas(#v2.Collection);
			local math_clamp_ret = math.clamp(v3 / v4, 0, 1);
			SurfaceGui.Percent.Text = m_Library.Functions.FormatPercent(math_clamp_ret);
		end
		local function PickRandomPet() -- Line: 56
			--[[
				Upvalues:
					[1] = m_Library
					[2] = Random_new_ret
			--]]
			local AllCollectablePets = m_Library.Shared.GetAllCollectablePets();
			local v5 = AllCollectablePets[Random_new_ret:NextInteger(1, #AllCollectablePets)];
			return v5.petId, v5.isGolden, v5.isRainbow, v5.isDarkMatter;
		end
		local u3 = nil;
		local function UpdatePet() -- Line: 63
			--[[
				Upvalues:
					[1] = m_Library
					[2] = Random_new_ret
					[3] = u3
					[4] = u1
					[5] = SurfaceGui
			--]]
			local v6 = m_Library.Save.Get();
			if not v6 then return end
			local AllCollectablePets2 = m_Library.Shared.GetAllCollectablePets();
			local v7 = AllCollectablePets2[Random_new_ret:NextInteger(1, #AllCollectablePets2)];
			local t_petId = v7.petId;
			local t_isGolden = v7.isGolden;
			local t_isRainbow = v7.isRainbow;
			local t_isDarkMatter = v7.isDarkMatter;
			if not t_petId then return end
			if u3 then
				u3();
				u3 = nil;
			end
			if not u1 or not u1.Parent or not SurfaceGui or not SurfaceGui.Parent or not SurfaceGui.PetFrame or not SurfaceGui.PetFrame.Pet then return end
			local v8 = m_Library.Directory.Pets[t_petId];
			local v9 = m_Library.Functions.SearchArray(v6.Collection, t_petId .. "-" .. (t_isGolden and 2 or t_isRainbow and 3 or t_isDarkMatter and 4 or 1));
			local v10 = t_isDarkMatter and v8.darkMatterThumbnail or t_isGolden and v8.goldenThumbnail or v8.thumbnail;
			m_Library.ContentProvider:PreloadAsync({v10});
			if not u1 or not u1.Parent or not SurfaceGui or not SurfaceGui.Parent or not SurfaceGui.PetFrame or not SurfaceGui.PetFrame.Pet then return end
			local t_Pet = SurfaceGui.PetFrame.Pet;
			local coroutine_wrap_ret = coroutine.wrap(function() -- Line: 99
				--[[
					Upvalues:
						[1] = u1
						[2] = m_Library
						[3] = Random_new_ret
						[4] = t_Pet
				--]]
				local os_clock_ret = os.clock();
				if u1.PrimaryPart then
					m_Library.Audio.Play("rbxassetid://7349614764", u1.PrimaryPart, Random_new_ret:NextNumber(0.8, 1.2), 0.175, 50);
				end
				while os.clock() - os_clock_ret < 0.2 do
					t_Pet.Position = UDim2.new(0.5, math.sin(math.clamp((os.clock() - os_clock_ret) / 0.2, 0, 1) * 100) * 4, 0, 0);
					m_Library.RenderStepped();
				end
			end);
			coroutine_wrap_ret();
			t_Pet.Image = v10;
			t_Pet.ImageColor3 = v9 and Color3.new(1, 1, 1) or Color3.new(0, 0, 0);
			t_Pet.Locked.Visible = not v9;
			if t_isRainbow and v9 then
				u3 = m_Library.GUIFX.Rainbow(t_Pet, "ImageColor3", 3);
			end
		end
		local coroutine_wrap_ret2 = coroutine.wrap(function() -- Line: 120
			--[[
				Upvalues:
					[1] = u1
					[2] = bool1
					[3] = UpdateBottom
			--]]
			while u1 and u1.Parent and bool1 do
				UpdateBottom();
				wait(2);
			end
		end);
		coroutine_wrap_ret2();
		local coroutine_wrap_ret3 = coroutine.wrap(function() -- Line: 127
			--[[
				Upvalues:
					[1] = u1
					[2] = bool1
					[3] = UpdatePet
			--]]
			while u1 and u1.Parent and bool1 do
				UpdatePet();
				wait(2.5);
			end
		end);
		coroutine_wrap_ret3();
	end);
	coroutine_wrap_ret4();
end
function Check() -- Line: 137
	--[[
		Upvalues:
			[1] = m_Library
			[2] = u1
	--]]
	local Map = m_Library.WorldCmds.GetMap();
	if Map:FindFirstChild("Interactive") then
		u1 = Map.Interactive:FindFirstChild("Pet Collection Machine");
		if u1 then
			Setup();
		end
	end
end
m_Library.Signal.Fired("World Changed"):Connect(function() -- Line: 152
	--[[
		Upvalues:
			[1] = bool1
			[2] = u1
	--]]
	bool1 = false;
	u1 = nil;
	Check();
end);

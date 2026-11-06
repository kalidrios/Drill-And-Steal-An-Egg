-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local _ = Random.new();
function PortalAnimation() -- Line: 17
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local Map = m_Library.WorldCmds.GetMap();
	local Interactive = Map:FindFirstChild("Interactive");
	if Interactive then
		local FindFirstChild_ret = Interactive:FindFirstChild("Limbo Portal");
		if FindFirstChild_ret then
			m_Library.Audio.Play("rbxassetid://7210953181", FindFirstChild_ret.PrimaryPart, 0.2, 5, 100, nil, true);
		end
	end
end
function ShakeAnimation() -- Line: 29
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local Map2 = m_Library.WorldCmds.GetMap();
	local Interactive2 = Map2:FindFirstChild("Interactive");
	if Interactive2 then
		local FindFirstChild_ret2 = Interactive2:FindFirstChild("Limbo Portal");
		if FindFirstChild_ret2 then
			local bool1 = false;
			local bool2 = false;
			local u1 = nil;
			local t_TintColor = nil;
			local function revert() -- Line: 40
				--[[
					Upvalues:
						[1] = bool1
						[2] = m_Library
						[3] = u1
						[4] = t_TintColor
				--]]
				if bool1 then
					bool1 = false;
					workspace.CurrentCamera.FieldOfView = 70;
				end
				local ColorCorrectionEffect = m_Library.Lighting:FindFirstChildOfClass("ColorCorrectionEffect");
				if ColorCorrectionEffect then
					if u1 then
						ColorCorrectionEffect.Saturation = u1;
						u1 = nil;
					end
					if t_TintColor then
						ColorCorrectionEffect.TintColor = t_TintColor;
						t_TintColor = nil;
					end
				end
			end
			local coroutine_wrap_ret = coroutine.wrap(function() -- Line: 58
				--[[
					Upvalues:
						[1] = FindFirstChild_ret2
						[2] = m_Library
						[3] = bool1
						[4] = t_TintColor
						[5] = bool2
						[6] = u1
				--]]
				while FindFirstChild_ret2 and FindFirstChild_ret2.Parent do
					local DistanceFromCharacter_ret = m_Library.LocalPlayer:DistanceFromCharacter(FindFirstChild_ret2.PrimaryPart.CFrame.p);
					if DistanceFromCharacter_ret <= 100 then
						local v1 = (100 - math.clamp(DistanceFromCharacter_ret, 15, 100)) / 85;
						bool1 = true;
						local v2 = m_Library.Functions.Lerp(70, 30, v1);
						workspace.CurrentCamera.FieldOfView = v2;
						local ColorCorrectionEffect4 = m_Library.Lighting:FindFirstChildOfClass("ColorCorrectionEffect");
						if ColorCorrectionEffect4 then
							if not t_TintColor then
								t_TintColor = ColorCorrectionEffect4.TintColor;
							end
							ColorCorrectionEffect4.TintColor = t_TintColor:Lerp(Color3.new(0.65, 0, 1), v1);
						end
						if v1 >= 0.5 and not bool2 then
							bool2 = true;
							local v3 = (v1 - 0.5) / 0.5;
							local u2 = m_Library.Functions.Lerp(0.03, 0.33, v3);
							task.spawn(function() -- Line: 89
								--[[
									Upvalues:
										[1] = m_Library
										[2] = u2
										[3] = bool2
								--]]
								m_Library.Shake.Create(0.1, u2, 0.5, false);
								m_Library.Functions.Wait(0.1);
								bool2 = false;
							end);
						end
					else
						if bool1 then
							bool1 = false;
							workspace.CurrentCamera.FieldOfView = 70;
						end
						local ColorCorrectionEffect3 = m_Library.Lighting:FindFirstChildOfClass("ColorCorrectionEffect");
						if ColorCorrectionEffect3 then
							if u1 then
								ColorCorrectionEffect3.Saturation = u1;
								u1 = nil;
							end
							if t_TintColor then
								ColorCorrectionEffect3.TintColor = t_TintColor;
								t_TintColor = nil;
							end
						end
					end
					m_Library.RenderStepped();
				end
				if bool1 then
					bool1 = false;
					workspace.CurrentCamera.FieldOfView = 70;
				end
				local ColorCorrectionEffect2 = m_Library.Lighting:FindFirstChildOfClass("ColorCorrectionEffect");
				if ColorCorrectionEffect2 then
					if u1 then
						ColorCorrectionEffect2.Saturation = u1;
						u1 = nil;
					end
					if t_TintColor then
						ColorCorrectionEffect2.TintColor = t_TintColor;
						t_TintColor = nil;
					end
				end
			end);
			coroutine_wrap_ret();
		end
	end
end
function Animations() -- Line: 111
	PortalAnimation();
	ShakeAnimation();
end
m_Library.Signal.Fired("World Changed"):Connect(function(_) -- Line: 117
	Animations();
end);

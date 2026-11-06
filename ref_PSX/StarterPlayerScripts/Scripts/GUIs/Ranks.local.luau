-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local t_Rank = m_Library.GUI.Main.Status.Rank;
local t_Rank2 = nil;
local bool1 = false;
function Update() -- Line: 20
	--[[
		Upvalues:
			[1] = m_Library
			[2] = t_Rank2
			[3] = t_Rank
	--]]
	local v1 = m_Library.Save.Get();
	if not v1 then return end
	local v2 = m_Library.Directory.Ranks[v1.Rank];
	if not t_Rank2 or t_Rank2 ~= v1.Rank then
		t_Rank2 = v1.Rank;
		t_Rank.RankName.Text = v2.title;
		local FindFirstChild_ret = m_Library.Assets.UI.Ranks:FindFirstChild(v1.Rank);
		for _, descendant2 in ipairs(t_Rank:GetDescendants()) do
			if descendant2.ClassName ~= "UIGradient" then continue end
			FindFirstChild_ret:Clone().Parent = descendant2.Parent;
			descendant2:Destroy();
		end
	end
	t_Rank.Add.Visible = v2.productId ~= 0;
	if v2.needed > 0 then
		local math_clamp_ret = math.clamp(v1.RankProgress / v2.needed, 0, 1);
		m_Library.Functions.Tween(t_Rank.Progress.Bar, {Size = UDim2.new(math_clamp_ret, 0, 1, 0)}, {
			0.2,
			"Quad",
			"Out"
		});
		t_Rank.Percent.Text = math.round(math_clamp_ret * 100) .. "%";
		return;
	end
	t_Rank.Progress.Bar.Size = UDim2.new(1, 0, 1, 0);
	t_Rank.Percent.Text = "MAX";
end
m_Library.Network.Fired("Rank Changed"):Connect(function(p1, p2) -- Line: 57
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	if p1 == m_Library.LocalPlayer then
		m_Library.Signal.Fire("Notification", "Congrats! You've ranked up to " .. p2 .. "!", {
			color = Color3.fromRGB(33, 255, 218),
			time = 5
		});
	end
	local v3 = m_Library.Player.UpperTorso(p1);
	if not v3 then return end
	m_Library.Signal.Fire("Fireworks Animation", p1);
	m_Library.Audio.Play("rbxassetid://74665098405326", v3, 1, 1.25, 400);
	local Children = m_Library.Assets.Particles:FindFirstChild("Rank Up"):GetChildren();
	for _, val1 in ipairs(Children) do
		local Clone_ret = val1:Clone();
		Clone_ret.Parent = v3;
		Clone_ret:Emit(20);
		m_Library.Functions.AddDebris(Clone_ret, 5);
	end
	m_Library.WorldFX.RewardImage(v3.CFrame.p, "Rank Up!", "rbxassetid://6923341333");
end);
function PromptInstantRankup() -- Line: 85
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local v4 = m_Library.Save.Get();
	if not v4 then return end
	local v5 = m_Library.Directory.Ranks[v4.Rank];
	if v5.productId ~= 0 then
		m_Library.Shared.PromptPurchase(v5.productId, true);
	end
end
m_Library.GUIFX.ButtonFX(t_Rank.Add);
t_Rank.Add.Activated:Connect(function() -- Line: 99
	--[[
		Upvalues:
			[1] = bool1
	--]]
	if not bool1 then
		bool1 = true;
		PromptInstantRankup();
		bool1 = false;
	end
end);
Update();
m_Library.Signal.Fired("Stat Changed"):Connect(function(p3) -- Line: 114
	if p3 == "Rank" or p3 == "RankProgress" then
		Update();
	end
end);

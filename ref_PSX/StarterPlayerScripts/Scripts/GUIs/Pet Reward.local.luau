-- https://github.com/kalidrios

local _ = {
	"rbxassetid://6907636858",
	"rbxassetid://6907636843"
};
local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local t_PetReward = m_Library.GUI.PetReward;
local t_Inventory = m_Library.Assets.UI.Inventory;
local Random_new_ret = Random.new();
local bool1 = false;
function Update(p1) -- Line: 26
	--[[
		Upvalues:
			[1] = t_PetReward
			[2] = m_Library
			[3] = t_Inventory
	--]]
	if not p1 or #p1 == 0 then return end
	t_PetReward.Desc.Text = "Valuable Player Rewards";
	t_PetReward.Title.Text = "Congrats!";
	for key1, val1 in ipairs(p1) do
		local v1 = m_Library.PetCmds.Get(val1);
		local t_id = v1.id;
		local _ = v1.idt;
		local _ = v1.s;
		local t_g = v1.g;
		local _ = v1.r;
		local _ = v1.dm;
		local _ = v1.powers;
		local v2 = m_Library.Directory.Pets[t_id];
		local _ = v2.isGift;
		if not t_g or not v2.goldenThumbnail then
			local _ = v2.thumbnail;
		end
		local _ = v2.name;
		local _ = v2.rarity;
		local Clone_ret = t_Inventory.Pet:Clone();
		m_Library.PetUI.Create(Clone_ret, val1);
		Clone_ret.HC:FindFirstChildOfClass("UIStroke").Thickness = 4;
		Clone_ret.DeleteOverlay.Visible = false;
		Clone_ret.PetIcon.ImageTransparency = 0;
		Clone_ret.Stars.Visible = not Clone_ret.Locked.Visible;
		Clone_ret.Visible = true;
		Clone_ret.Parent = t_PetReward.PetHolder:FindFirstChild("Pet" .. key1);
		t_PetReward.PetHolder:FindFirstChild("Pet" .. key1).Visible = true;
	end
	m_Library.GUI.Inventory.Gui.Enabled = false;
	task.delay(1, function() -- Line: 63
		--[[
			Upvalues:
				[1] = t_PetReward
				[2] = m_Library
		--]]
		t_PetReward.Gui.Enabled = true;
		m_Library.Signal.Fire("Fireworks Animation", m_Library.LocalPlayer);
		local v3 = m_Library.Player.UpperTorso(m_Library.LocalPlayer);
		if not v3 then return end
		m_Library.Audio.Play("rbxassetid://7000716222", v3, 1, 1.25, 400);
	end);
end
t_PetReward.Ok.Activated:Connect(function() -- Line: 79
	--[[
		Upvalues:
			[1] = bool1
			[2] = m_Library
			[3] = Random_new_ret
			[4] = t_PetReward
	--]]
	if not bool1 then
		bool1 = true;
		m_Library.Audio.Play("rbxassetid://8951380772", script, Random_new_ret:NextNumber(0.95, 1.05), 0.1);
		m_Library.Signal.Fire("Notification", "Valuable Player Rewards added to inventory!", {color = Color3.fromRGB(221, 85, 255)});
		t_PetReward.Gui.Enabled = false;
		bool1 = false;
	end
end);
m_Library.GUIFX.ButtonFX(t_PetReward.Ok);
m_Library.Network.Fired("Notify Pet Rewards"):Connect(Update);

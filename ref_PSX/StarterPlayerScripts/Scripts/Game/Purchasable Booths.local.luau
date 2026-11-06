-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local u1 = m_Library.Shared.IsTradingPlaza or m_Library.RunService:IsStudio();
local table1 = {};
local bool1 = false;
function RemoveInteract(p1) -- Line: 19
	--[[
		Upvalues:
			[1] = m_Library
			[2] = table1
	--]]
	local Interact = p1:FindFirstChild("Interact");
	local Booth = p1:FindFirstChild("Booth");
	if Interact then
		Interact:Destroy();
	end
	if Booth then
		local OwnedAttachment = Booth:FindFirstChild("OwnedAttachment");
		if OwnedAttachment then
			OwnedAttachment:FindFirstChild("Owned").Enabled = true;
		end
	end
	m_Library.Functions.RemoveTable(table1, p1);
end
function IsPurchased(p2) -- Line: 39
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	local v1 = m_Library.Save.Get();
	if v1 then
		return v1.TradingBoothStyles and m_Library.Functions.SearchArray(v1.TradingBoothStyles, p2:GetAttribute("Product"));
	end
	return false;
end
function Prompt(p3) -- Line: 48
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	if not p3:GetAttribute("Product") then
		warn("Invalid booth, doesn't have name attribute");
		return;
	end
	local Attribute = p3:GetAttribute("Product");
	local v2 = m_Library.Directory.Booths[Attribute];
	if not v2 then
		m_Library.Message.New("Something went wrong!");
		return;
	end
	local t_ProductId = v2.ProductId;
	if t_ProductId then
		local v3 = m_Library.Network.Invoke("Attempt Buy Trading Booth Style", Attribute);
		if v3 then
			m_Library.Shared.PromptPurchase(t_ProductId, true);
		end
		return;
	end
	if v2.RequirementMessage then
		m_Library.Message.New(v2.RequirementMessage);
		return;
	end
	if v2.DiamondPrice then
		local v4 = "Buy " .. v2.DisplayName .. " for " .. m_Library.Functions.Commas(v2.DiamondPrice) .. " Diamonds?";
		local v5 = m_Library.Message.New(v4, true);
		if v5 then
			local v7, v8 = m_Library.Network.Invoke("Purchase Booth Style", Attribute);
			if not v7 then
				m_Library.Message.New(v8 or "Something went wrong!");
				return;
			end
			m_Library.Signal.Fire("Notification", "Success! \226\156\133", {
				color = Color3.fromRGB(105, 255, 168),
				sound = "rbxassetid://11648890466"
			});
		end
	end
end
function Setup() -- Line: 88
	--[[
		Upvalues:
			[1] = u1
			[2] = m_Library
			[3] = bool1
			[4] = table1
	--]]
	if not u1 then return end
	local Map = m_Library.WorldCmds.GetMap();
	local Interactive = Map:FindFirstChild("Interactive");
	if Interactive then
		local PurchasableBooths = Interactive:FindFirstChild("PurchasableBooths");
		if PurchasableBooths then
			for _, child1 in pairs(PurchasableBooths:GetChildren()) do
				local _ = child1:GetAttribute("Product");
				if IsPurchased(child1) then
					RemoveInteract(child1);
				else
					local v9, _ = m_Library.Interact.Add(child1.PrimaryPart, {dist = 12});
					if v9 then
						v9:Connect(function() -- Line: 106
							--[[
								Upvalues:
									[1] = bool1
									[2] = child1
							--]]
							if not bool1 then
								bool1 = true;
								Prompt(child1);
								bool1 = false;
							end
						end);
					end
				end
				table.insert(table1, child1);
			end
		end
	end
end
m_Library.Signal.Fired("World Changed"):Connect(function(p4) -- Line: 123
	if p4 == "Trading Plaza" then
		Setup();
	end
end);
m_Library.Signal.Fired("Stat Changed"):Connect(function(p5) -- Line: 130
	--[[
		Upvalues:
			[1] = m_Library
			[2] = table1
	--]]
	if p5 == "TradingBoothStyles" then
		local v6 = m_Library.Save.Get();
		if v6 then
			for _, val2 in ipairs(table1) do
				if not m_Library.Functions.SearchArray(v6.TradingBoothStyles, val2:GetAttribute("Product")) then continue end
				RemoveInteract(val2);
			end
		end
	end
end);

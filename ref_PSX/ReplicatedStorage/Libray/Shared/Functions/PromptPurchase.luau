-- https://github.com/kalidrios

local RunService = game:GetService("RunService");
local MarketplaceService = game:GetService("MarketplaceService");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Library = ReplicatedStorage:WaitForChild("Library");
local Client = Library:WaitForChild("Client");
local m_FFlags = nil;
local m_Message = nil;
local m_Gamepasses = nil;
if RunService:IsClient() then
	m_FFlags = require(Client.FFlags);
	m_Message = require(Client.Message);
	m_Gamepasses = require(Client.Gamepasses);
end
local m_Audio = require(Library.Audio);
local m_Signal = require(Library.Signal);
return function(p1, p2) -- Line: 22
	if not m_FFlags.Get(m_FFlags.Keys.Purchases) and not m_FFlags.CanBypass() then
		m_Message.New("Sorry! Roblox is having trouble so we have temporarily disabled purchases! Try back soon!");
		return;
	end
	if p1 == 0 then
		m_Message.New("Sorry! This product hasn't been uploaded yet! Come back soon!")
		return
	end
	if p2 then
		m_Audio.Play("rbxassetid://6926253319", script, 1.35, 0.6);
		m_Signal.Fire("Prompting Purchase");
		MarketplaceService:PromptProductPurchase(Players.LocalPlayer, p1);
		return;
	end
	local v1 = m_Gamepasses.Owns(p1);
	if not v1 then
		m_Audio.Play("rbxassetid://6926253319", script, 1.35, 0.6);
		m_Signal.Fire("Prompting Purchase");
		MarketplaceService:PromptGamePassPurchase(Players.LocalPlayer, p1);
	end
end;

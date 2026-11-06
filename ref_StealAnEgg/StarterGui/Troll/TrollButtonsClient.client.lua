local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local localPlayer = Players.LocalPlayer
local trollGui = script.Parent
local trollFrame = trollGui:WaitForChild("TrollFrame")
local serverTrollFrame = trollGui:WaitForChild("ServerTrollFrame")
local freeTrollAction = ReplicatedStorage:WaitForChild("Events"):WaitForChild("FreeTrollAction")

local singleProducts = {
	fling = {id = 3710872795, action = "Fling"},
	explode = {id = 3710872835, action = "Explode"},
	freeze = {id = 3710872862, action = "Freeze"},
	trip = {id = 3710872895, action = "Trip"},
	kill = {id = 3710872934, action = "Kill"},
	kick = {id = 3710872968, action = "Kick"},
}

local allProducts = {
	fling = {id = 3710872994, action = "FlingAll"},
	explode = {id = 3710873021, action = "ExplodeAll"},
	freeze = {id = 3710873048, action = "FreezeAll"},
	kill = {id = 3710873079, action = "KillAll"},
	trip = {id = 3710873105, action = "TripAll"},
}

local function promptOrUseFreeAction(info)
	if localPlayer:GetAttribute("TrollFree") == true then
		freeTrollAction:FireServer(info.action)
	else
		MarketplaceService:PromptProductPurchase(localPlayer, info.id)
	end
end

local function wire(frame, products)
	for buttonName, info in pairs(products) do
		local button = frame:FindFirstChild(buttonName)
		if button and button:IsA("GuiButton") then
			button.Active = true
			button.Activated:Connect(function() promptOrUseFreeAction(info) end)
		else
			warn("[TrollButtonsClient] Missing button '" .. buttonName .. "' in " .. frame:GetFullName())
		end
	end
end

wire(trollFrame, singleProducts)
wire(serverTrollFrame, allProducts)
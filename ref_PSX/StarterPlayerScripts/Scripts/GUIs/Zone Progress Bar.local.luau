-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"))
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait()
end

local GUI = m_Library.GUI
local progressBarsUI = nil

-- Wait for the ProgressBars ScreenGui to be indexed
while not progressBarsUI do
	progressBarsUI = GUI.ProgressBars
	if not progressBarsUI then
		task.wait(0.1)
	end
end

local Main = progressBarsUI.Main
local Req = Main:WaitForChild("Req")
local CoinsFrame = Req:WaitForChild("Coins")
local Icon = CoinsFrame:WaitForChild("Icon")
local Amount = CoinsFrame:WaitForChild("Amount")
local Bar = Main:WaitForChild("Progress"):WaitForChild("Bar")
local Buy = Main:WaitForChild("Buy")
local Teleport = Main:WaitForChild("Teleport")
local Title = Main:WaitForChild("Title")

local isHardcore = m_Library.Shared.IsHardcore
local isBuying = false

local function GetCurrencyAmount(currencyName, save, hardcore, currencyData)
	if not save then return 0 end
	if hardcore then
		if currencyData.HardcoreSeparate then
			return save.HardcoreCurrency and save.HardcoreCurrency[currencyName] or 0
		else
			return save[currencyName] or 0
		end
	else
		return save[currencyName] or 0
	end
end

local function GetNextGate(world, unlocked)
	local nextGateArea = nil
	local minId = math.huge
	
	for areaName, areaData in pairs(m_Library.Directory.Areas) do
		if areaData.world == world and areaData.gate then
			local isUnlocked = table.find(unlocked, areaName)
			if not isUnlocked and areaData.id < minId then
				minId = areaData.id
				nextGateArea = areaData
				nextGateArea.areaName = areaName
			end
		end
	end
	
	return nextGateArea
end

local function Update()
	local save = m_Library.Save.Get()
	if not save then return end
	
	local world = m_Library.WorldCmds.Get()
	if not world then return end
	
	local unlocked = isHardcore and save.Hardcore.AreasUnlocked or save.AreasUnlocked
	local nextGateArea = GetNextGate(world, unlocked)
	
	if not nextGateArea then
		Main.Visible = false
		return
	end
	
	Main.Visible = true
	Title.Text = nextGateArea.name or nextGateArea.areaName
	
	local cost = nextGateArea.gate.cost
	local currencyName = nextGateArea.gate.currency
	local currencyData = m_Library.Directory.Currency[currencyName]
	
	-- Update Currency Icon
	if currencyData then
		Icon.Image = currencyData.ImageOutline or currencyData.Image
	end
	
	-- Get Current Player Balance
	local currentMoney = GetCurrencyAmount(currencyName, save, isHardcore, currencyData)
	
	-- Calculate ratio
	local ratio = math.clamp(currentMoney / cost, 0, 1)
	
	-- Tween progress bar
	m_Library.Functions.Tween(Bar, {Size = UDim2.new(ratio, 0, 1, 0)}, {
		0.25,
		"Quad",
		"Out"
	})
	Bar.Visible = ratio >= 0.01
	
	-- Update Requirement Text
	local remaining = math.max(0, cost - currentMoney)
	if remaining > 0 then
		if remaining >= 1000000 then
			Amount.Text = m_Library.Functions.NumberShorten(remaining, false)
		else
			Amount.Text = m_Library.Functions.Commas(remaining)
		end
		Req.Visible = true
	else
		Amount.Text = "0"
		Req.Visible = false
	end
	
	-- Buy / Teleport Button visibility
	if currentMoney >= cost then
		Buy.Visible = true
		Teleport.Visible = false
	else
		Buy.Visible = false
		-- Teleport can be shown or hidden based on preference. Let's hide it for now as it's a simple bar.
		Teleport.Visible = false
	end
end

-- Buy Button behavior
Buy.Activated:Connect(function()
	if isBuying then return end
	
	local save = m_Library.Save.Get()
	if not save then return end
	
	local world = m_Library.WorldCmds.Get()
	if not world then return end
	
	local unlocked = isHardcore and save.Hardcore.AreasUnlocked or save.AreasUnlocked
	local nextGateArea = GetNextGate(world, unlocked)
	
	if nextGateArea then
		local cost = nextGateArea.gate.cost
		local currencyName = nextGateArea.gate.currency
		local currencyData = m_Library.Directory.Currency[currencyName]
		local currentMoney = GetCurrencyAmount(currencyName, save, isHardcore, currencyData)
		
		if currentMoney >= cost then
			isBuying = true
			local success, err = m_Library.Network.Invoke("Buy Area", nextGateArea.areaName)
			if not success and err then
				m_Library.Message.New(err)
			end
			isBuying = false
		end
	end
end)

-- Periodically update UI (similar to the original script)
task.spawn(function()
	while task.wait(0.25) do
		pcall(Update)
	end
end)

Update()

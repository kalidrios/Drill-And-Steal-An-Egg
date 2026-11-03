--!strict
--[[
	StatusHUD.local.luau
	Conecta os dados do DataStore (Speed, Strength, Money) com game.StarterGui.Main.Frame.Status,
	exibindo a quantidade que o jogador possui em (Frame).Value.
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Library = require(ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"))

while not Library.Loaded do
	RunService.Heartbeat:Wait()
end

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local mainGui = PlayerGui:WaitForChild("Main")
local mainFrame = mainGui:WaitForChild("Frame")
local statusFrame = mainFrame:WaitForChild("Status")

local NUMBER_SUFFIXES = {
	"", "K", "M", "B", "T", "Qa", "Qi", "Sx", "Sp", "Oc", "No", "Dc",
	"Ud", "Dd", "Td", "Qad", "Qid", "Sxd", "Spd", "Ocd", "Nod", "Vg",
}

local function formatStatValue(value: number): string
	if Library.StageClientCmds and Library.StageClientCmds.FormatNumber then
		return Library.StageClientCmds.FormatNumber(value)
	end

	if type(value) ~= "number" or value ~= value then
		return "0"
	end
	if value < 1000 then
		return tostring(math.floor(value))
	end

	local suffixIndex = math.min(math.floor(math.log(value, 1000)), #NUMBER_SUFFIXES - 1)
	local scaled = value / (1000 ^ suffixIndex)
	local suffix = NUMBER_SUFFIXES[suffixIndex + 1] or ""

	if scaled >= 100 then
		return string.format("%.0f%s", scaled, suffix)
	elseif scaled >= 10 then
		return string.format("%.1f%s", scaled, suffix)
	end
	return string.format("%.2f%s", scaled, suffix)
end

local function updateFrameValue(statContainer: Instance?, numericValue: number)
	if not statContainer then
		return
	end

	local valueLabel = statContainer:FindFirstChild("Value")
	if valueLabel and valueLabel:IsA("TextLabel") then
		valueLabel.Text = formatStatValue(numericValue)
	end
end

local function refreshStatusHUD(customData: { [string]: any }?)
	local data = customData or (Library.Save and Library.Save.Get()) or {}

	local speedVal = tonumber(LocalPlayer:GetAttribute("Speed")) or tonumber(data.Speed) or 16
	local strengthVal = tonumber(LocalPlayer:GetAttribute("Strength")) or tonumber(data.Strength) or 0
	local moneyVal = tonumber(LocalPlayer:GetAttribute("Money"))
		or tonumber(LocalPlayer:GetAttribute("Cash"))
		or tonumber(data.Money)
		or tonumber(data.Cash)
		or 0

	local speedFrame = statusFrame:FindFirstChild("Speed")
	local strengthFrame = statusFrame:FindFirstChild("Strength")
	local moneyFrame = statusFrame:FindFirstChild("Money") or statusFrame:FindFirstChild("Cash")

	updateFrameValue(speedFrame, speedVal)
	updateFrameValue(strengthFrame, strengthVal)
	updateFrameValue(moneyFrame, moneyVal)
end

-- 1. Atualização reativa via Library.Save (eventos de rede StatsUpdated)
if Library.Save and Library.Save.OnUpdated then
	Library.Save.OnUpdated(function(updatedStats)
		refreshStatusHUD(updatedStats)
	end)
end

-- 2. Atualização reativa imediata via Attributes do LocalPlayer
LocalPlayer.AttributeChanged:Connect(function(attributeName: string)
	if attributeName == "Speed" or attributeName == "Strength" or attributeName == "Money" or attributeName == "Cash" then
		refreshStatusHUD()
	end
end)

-- 3. Sincronização inicial ao carregar o cliente
task.spawn(function()
	refreshStatusHUD()
end)

print("[StatusHUD] Conectado a Main.Frame.Status (Speed, Strength, Money)!")


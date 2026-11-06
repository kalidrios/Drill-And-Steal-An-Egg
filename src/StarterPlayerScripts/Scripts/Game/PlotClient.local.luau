--!strict
--[[
	PlotClient.local.luau
	Controlador visual do cliente para os Plots.
	- Exibe o ícone de casa (YourBase) exclusivamente para o dono do Plot.
	- Aplica fade suave (distância > 40 studs = visível, <= 40 studs = transparente).
	- Conecta o clique do botão da casa para solicitar teleporte de volta à base.
	- Atualiza o AlwaysOnTop da placa do jogador quando você se aproxima.
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer

local Library = require(ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"))

while not Library.Loaded do
	RunService.Heartbeat:Wait()
end

local PlotClientCmds = Library.PlotClientCmds
if not PlotClientCmds and Library.Client then
	PlotClientCmds = Library.Client.PlotClientCmds
end
if not PlotClientCmds then
	PlotClientCmds = require(ReplicatedStorage:WaitForChild("Libray"):WaitForChild("Client"):WaitForChild("PlotClientCmds"))
end

PlotClientCmds.Init(Library)

local FADE_DISTANCE = 40.0
local MAX_DISTANCE = 400.0

local homeTweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local activeHomeTween: Tween? = nil
local isHomeVisible: boolean? = nil

local function getLocalPlotData()
	return PlotClientCmds.GetPlotData(LocalPlayer)
end

-- Desativa o 'YourBase' de todos os outros plots
local function sanitizeAllPlots()
	local folder = PlotClientCmds.GetPlotsFolder()
	if not folder then return end
	
	local mySlot = PlotClientCmds.GetMySlot()
	
	for _, plot in ipairs(folder:GetChildren()) do
		local slotNum = tonumber(plot.Name)
		local sign = plot:FindFirstChild("PlotSign")
		local attachment = sign and sign:FindFirstChild("Attachment")
		local yourBase = attachment and attachment:FindFirstChild("YourBase")
		
		if yourBase and yourBase:IsA("BillboardGui") then
			if slotNum ~= mySlot then
				yourBase.Enabled = false
			end
		end
	end
end

-- Gerencia a transição e visibilidade do botão da casa
local function setHomeButtonVisible(yourBase: BillboardGui, homeBtn: ImageButton, visible: boolean)
	if isHomeVisible == visible then return end
	isHomeVisible = visible
	
	if activeHomeTween then
		activeHomeTween:Cancel()
		activeHomeTween = nil
	end
	
	if visible then
		yourBase.Enabled = true
	end
	
	local targetTransparency = visible and 0.0 or 1.0
	activeHomeTween = TweenService:Create(homeBtn, homeTweenInfo, {
		ImageTransparency = targetTransparency
	})
	
	activeHomeTween.Completed:Connect(function()
		if not visible and yourBase and yourBase.Parent then
			yourBase.Enabled = false
		end
		activeHomeTween = nil
	end)
	
	activeHomeTween:Play()
end

-- Conexão do clique para voltar à base
local function setupHomeClick(homeBtn: ImageButton)
	if homeBtn:GetAttribute("ClickConnected") then return end
	homeBtn:SetAttribute("ClickConnected", true)
	
	homeBtn.MouseButton1Click:Connect(function()
		PlotClientCmds.RequestTeleportToBase()
	end)
end

-- Loop de verificação de distância
local function onHeartbeat()
	local char = LocalPlayer.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not hrp or not hrp:IsA("BasePart") then return end
	
	local plotData = getLocalPlotData()
	if not plotData then return end
	
	local plotSign = plotData.PlotSign
	local attachment = plotSign and plotSign:FindFirstChild("Attachment")
	local yourBase = attachment and attachment:FindFirstChild("YourBase")
	local homeBtn = yourBase and yourBase:FindFirstChild("Home")
	local center = plotData.Center or plotData.SpawnPart
	
	if yourBase and homeBtn and homeBtn:IsA("ImageButton") and center and center:IsA("BasePart") then
		yourBase.MaxDistance = MAX_DISTANCE
		yourBase.AlwaysOnTop = true
		
		setupHomeClick(homeBtn)
		
		local dist = (hrp.Position - center.Position).Magnitude
		local shouldShow = dist > FADE_DISTANCE
		
		setHomeButtonVisible(yourBase, homeBtn, shouldShow)
	end
	
	-- Ajuste de AlwaysOnTop nas placas de plots de outros jogadores quando perto
	local folder = PlotClientCmds.GetPlotsFolder()
	if folder then
		for _, plot in ipairs(folder:GetChildren()) do
			local pSign = plot:FindFirstChild("PlotSign")
			local pPlotSign = pSign and pSign:FindFirstChild("PlayerPlotSign")
			local pCenter = plot:FindFirstChild("Center")
			if pPlotSign and pPlotSign:IsA("BillboardGui") and pCenter and pCenter:IsA("BasePart") then
				local pDist = (hrp.Position - pCenter.Position).Magnitude
				pPlotSign.AlwaysOnTop = (pDist <= FADE_DISTANCE)
			end
		end
	end
end

sanitizeAllPlots()
PlotClientCmds.OnLocalPlotUpdated:Connect(function()
	sanitizeAllPlots()
end)
PlotClientCmds.OnAnyPlotUpdated:Connect(function()
	sanitizeAllPlots()
end)

RunService.Heartbeat:Connect(onHeartbeat)

print("[PlotClient] Controlador visual dos Plots e Base inicializado com sucesso!")


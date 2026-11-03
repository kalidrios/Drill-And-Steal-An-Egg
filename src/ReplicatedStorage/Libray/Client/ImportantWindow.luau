--!strict
--[[
	ImportantWindow / WindowManager
	Gerencia a abertura e fechamento único de ScreenGuis/Frames.
	
	Comportamento:
	- Apenas 1 janela aberta por vez (controlada pela variável ImportantWindow).
	- Ao abrir uma nova janela, a anterior fecha automaticamente.
	- Animação de popIn/popOut com TweenService (escala de tamanho e transparência).
	- Suporte a modo 'SlideRight' (desliza da direita para a esquerda), perfeito para painéis laterais como 'Right'.
	- BlurEffect no Lighting e efeito de aproximação/FOV na Camera.
	- Conexão universal com botões 'Close'.
]]

local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

--------------------------------------------------------------------------------
-- CONFIGURAÇÕES VISUAIS
--------------------------------------------------------------------------------
local TWEEN_INFO = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
local SLIDE_TWEEN_INFO = TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local SLIDE_CLOSE_INFO = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

local BLUR_SIZE = 20
local FOV_OFFSET = 10

-- Blur Effect global no Lighting
local blurEffect = Lighting:FindFirstChild("UI_ImportantBlur") :: BlurEffect?
if not blurEffect then
	local newBlur = Instance.new("BlurEffect")
	newBlur.Name = "UI_ImportantBlur"
	newBlur.Size = 0
	newBlur.Enabled = false
	newBlur.Parent = Lighting
	blurEffect = newBlur
end

--------------------------------------------------------------------------------
-- ESTADO DO GERENCIADOR
--------------------------------------------------------------------------------
local ImportantWindowManager = {}

ImportantWindowManager.ImportantWindow = nil :: ScreenGui?
ImportantWindowManager.OriginalFOV = (Camera and Camera.FieldOfView) or 70

type WindowEntry = {
	ScreenGui: ScreenGui,
	Frame: GuiObject,
	OriginalSize: UDim2,
	OriginalPosition: UDim2,
	AnimationType: "Pop" | "SlideRight",
	IsOpen: boolean,
}

local registeredEntries: { [ScreenGui]: WindowEntry } = {}

local activeCamTween: Tween? = nil
local activeBlurTween: Tween? = nil

local function tweenCameraAndBlur(targetFov: number, targetBlur: number)
	if activeCamTween then activeCamTween:Cancel() end
	if activeBlurTween then activeBlurTween:Cancel() end

	if blurEffect then
		blurEffect.Enabled = true
		activeBlurTween = TweenService:Create(blurEffect, TWEEN_INFO, { Size = targetBlur })
		activeBlurTween:Play()
	end

	activeCamTween = TweenService:Create(Camera, TWEEN_INFO, { FieldOfView = targetFov })
	activeCamTween:Play()
end

--------------------------------------------------------------------------------
-- REGISTRO
--------------------------------------------------------------------------------
function ImportantWindowManager.Register(screenGui: ScreenGui, customFrame: GuiObject?, animationType: ("Pop" | "SlideRight")?): WindowEntry
	if registeredEntries[screenGui] then
		if animationType then
			registeredEntries[screenGui].AnimationType = animationType
		end
		return registeredEntries[screenGui]
	end

	local targetFrame = customFrame or screenGui:FindFirstChild("Frame") :: GuiObject?
	assert(targetFrame, "[ImportantWindow] Frame não encontrado para ScreenGui: " .. screenGui.Name)

	local origSize = targetFrame.Size
	local origPos = targetFrame.Position
	local animType = animationType or "Pop"

	local entry: WindowEntry = {
		ScreenGui = screenGui,
		Frame = targetFrame,
		OriginalSize = origSize,
		OriginalPosition = origPos,
		AnimationType = animType,
		IsOpen = screenGui.Enabled,
	}

	-- Se começa fechada, inicializa fora da tela ou zerada
	if not screenGui.Enabled then
		if animType == "SlideRight" then
			targetFrame.Position = UDim2.new(1.1, 0, origPos.Y.Scale, origPos.Y.Offset)
		else
			targetFrame.Size = UDim2.new(0, 0, 0, 0)
			targetFrame.BackgroundTransparency = 1
		end
	end

	-- Conectar automaticamente qualquer botão de fechar dentro do Frame
	local function bindClose(desc: Instance)
		if desc.Name == "Close" and desc:IsA("GuiButton") then
			desc.Activated:Connect(function()
				ImportantWindowManager.Close(screenGui)
			end)
		end
	end

	for _, desc in ipairs(targetFrame:GetDescendants()) do
		bindClose(desc)
	end
	targetFrame.DescendantAdded:Connect(bindClose)

	registeredEntries[screenGui] = entry
	return entry
end

--------------------------------------------------------------------------------
-- ABERTURA
--------------------------------------------------------------------------------
function ImportantWindowManager.Open(screenGui: ScreenGui)
	local entry = registeredEntries[screenGui] or ImportantWindowManager.Register(screenGui)

	if ImportantWindowManager.ImportantWindow == screenGui and entry.IsOpen then
		return
	end

	-- Fecha a janela anterior se for diferente
	if ImportantWindowManager.ImportantWindow and ImportantWindowManager.ImportantWindow ~= screenGui then
		ImportantWindowManager.Close(ImportantWindowManager.ImportantWindow)
	end

	ImportantWindowManager.ImportantWindow = screenGui
	entry.IsOpen = true
	screenGui.Enabled = true
	entry.Frame.Visible = true

	if entry.AnimationType == "SlideRight" then
		-- Desliza da direita para esquerda
		entry.Frame.Position = UDim2.new(1.1, 0, entry.OriginalPosition.Y.Scale, entry.OriginalPosition.Y.Offset)
		local slideTween = TweenService:Create(entry.Frame, SLIDE_TWEEN_INFO, {
			Position = entry.OriginalPosition
		})
		slideTween:Play()
	else
		-- Pop central tradicional
		local frameTween = TweenService:Create(entry.Frame, TWEEN_INFO, {
			Size = entry.OriginalSize,
			BackgroundTransparency = 0,
		})
		frameTween:Play()
	end

	tweenCameraAndBlur(ImportantWindowManager.OriginalFOV + FOV_OFFSET, BLUR_SIZE)
end

--------------------------------------------------------------------------------
-- FECHAMENTO
--------------------------------------------------------------------------------
function ImportantWindowManager.Close(screenGui: ScreenGui)
	local entry = registeredEntries[screenGui]
	if not entry or not entry.IsOpen then
		return
	end

	entry.IsOpen = false
	if ImportantWindowManager.ImportantWindow == screenGui then
		ImportantWindowManager.ImportantWindow = nil
	end

	if entry.AnimationType == "SlideRight" then
		-- Desliza saindo para a direita
		local targetPos = UDim2.new(1.1, 0, entry.OriginalPosition.Y.Scale, entry.OriginalPosition.Y.Offset)
		local slideTween = TweenService:Create(entry.Frame, SLIDE_CLOSE_INFO, {
			Position = targetPos
		})
		slideTween:Play()
		slideTween.Completed:Connect(function()
			if not entry.IsOpen then
				screenGui.Enabled = false
				entry.Frame.Visible = false
			end
		end)
	else
		-- Pop central encolhendo
		local frameTween = TweenService:Create(entry.Frame, TWEEN_INFO, {
			Size = UDim2.new(0, 0, 0, 0),
			BackgroundTransparency = 1,
		})
		frameTween:Play()
		frameTween.Completed:Connect(function()
			if not entry.IsOpen then
				screenGui.Enabled = false
				entry.Frame.Visible = false
			end
		end)
	end

	-- Se nenhuma janela estiver aberta, restaura câmera e blur
	if not ImportantWindowManager.ImportantWindow then
		tweenCameraAndBlur(ImportantWindowManager.OriginalFOV, 0)
		task.delay(TWEEN_INFO.Time, function()
			if not ImportantWindowManager.ImportantWindow and blurEffect then
				blurEffect.Enabled = false
			end
		end)
	end
end

--------------------------------------------------------------------------------
-- TOGGLE
--------------------------------------------------------------------------------
function ImportantWindowManager.Toggle(screenGui: ScreenGui)
	local entry = registeredEntries[screenGui] or ImportantWindowManager.Register(screenGui)
	if entry.IsOpen then
		ImportantWindowManager.Close(screenGui)
	else
		ImportantWindowManager.Open(screenGui)
	end
end

--------------------------------------------------------------------------------
-- VINCULAR BOTÃO DE ATIVAÇÃO
--------------------------------------------------------------------------------
function ImportantWindowManager.BindButton(button: GuiObject, screenGui: ScreenGui, animationType: ("Pop" | "SlideRight")?)
	ImportantWindowManager.Register(screenGui, nil, animationType)

	local function onTrigger()
		ImportantWindowManager.Toggle(screenGui)
	end

	if button:IsA("GuiButton") then
		button.Activated:Connect(onTrigger)
	else
		button.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				onTrigger()
			end
		end)
	end
end

return ImportantWindowManager

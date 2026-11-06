--!strict
-- Mismo patrón que SelectMutationController: clic resalta el botón y envía
-- el valor (numérico, parseado del Name "2"/"4"/"6"/"8"/"10"). Re-clic
-- deselecciona y envía "" para limpiar override.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local label = script.Parent :: ImageLabel
local scrollingFrame = label:FindFirstChild("ScrollingFrame") :: ScrollingFrame?
if not scrollingFrame then
	warn("[SelectLuckController] ScrollingFrame no encontrado bajo SelectLuck")
	return
end

local function getOrCreateRemote(name: string): RemoteEvent
	local r = ReplicatedStorage:FindFirstChild(name)
	if r and r:IsA("RemoteEvent") then return r end
	local rev = Instance.new("RemoteEvent")
	rev.Name = name
	rev.Parent = ReplicatedStorage
	return rev
end

local setNextLuckRemote = getOrCreateRemote("SetNextKickLuckRemote")

local ACCENT = Color3.fromRGB(255, 230, 90)
local activeButton: ImageButton? = nil
local activeOriginalColor: Color3? = nil

local function deselect()
	if activeButton and activeOriginalColor then
		activeButton.ImageColor3 = activeOriginalColor
	end
	activeButton = nil
	activeOriginalColor = nil
end

local function selectButton(button: ImageButton)
	if activeButton == button then
		deselect()
		setNextLuckRemote:FireServer("")
		return
	end
	deselect()
	activeOriginalColor = button.ImageColor3
	activeButton = button
	button.ImageColor3 = ACCENT
	setNextLuckRemote:FireServer(button.Name)
end

local wired: { [Instance]: boolean } = {}

local function wireButton(button: Instance)
	if wired[button] then return end
	if not button:IsA("ImageButton") then return end
	wired[button] = true
	button.MouseButton1Click:Connect(function()
		selectButton(button)
	end)
end

for _, child in ipairs(scrollingFrame:GetChildren()) do
	wireButton(child)
end
scrollingFrame.ChildAdded:Connect(wireButton)

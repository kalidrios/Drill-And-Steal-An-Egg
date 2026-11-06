-- Btn_TreadmillUpgrade.TreadmillUpgradeButton (rewrite)
-- Muestra las 3 MEJORES cintas reales del juego (por SpeedMultiplier en
-- ReplicatedStorage.Directory.Treadmills: AngelicTreadmill x2000, DemonicTreadmill x1000,
-- HackerTreadmill x500) rotando en Icon_VP cada ~5s, con su precio en Robux en
-- Info.Txt_Price. Clic -> prompt del gamepass real (mismo patron que Fly/Lap/BanHammer/
-- TreadmillUpgrade: MarketplaceService:PromptGamePassPurchase directo, el server escucha
-- PromptGamePassPurchaseFinished -- ver ServerScriptService.Controllers.TreadmillGamepassService).
--
-- El script anterior aqui era de OTRO juego (ReplicatedStorage.Modules/Events/Treadmill, que
-- no existen en este rip -- confirmado colgado para siempre en el Output real:
-- "Infinite yield possible on 'ReplicatedStorage:WaitForChild("Modules")'" en este mismo
-- script). Reescrito contra las rutas reales de este juego.
--
-- Sesion 12: el user creo 6 de los 9 gamepasses reales (captura del Dashboard) -- sustituidos
-- abajo para Sci-Fi/Flame/Celebrity/Golden/Freeze/LuckyBlock, y ampliado BEST_IDS para rotar los
-- 9 tiers comprables (2-10) en vez de solo el top-3 de antes. Angelic/Demonic/Hacker (8-10)
-- siguen con el ID que vino del rip (de otra cuenta, "My Roleplays Studios") -- pendiente que el
-- user los cree tambien. Misma tabla duplicada a proposito en
-- ServerScriptService.Controllers.TreadmillGamepassService (server es la autoridad real, esto
-- solo decide que mostrar/prompt-ear).

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local MarketplaceService = game:GetService("MarketplaceService")

local Treadmills = require(ReplicatedStorage.Directory.Treadmills)
local MonetizationGamepassUtil = require(ReplicatedStorage.Library.Util.MonetizationGamepassUtil)
local TreadmillModels = ReplicatedStorage.Assets.Models.Treadmills

local btn = script.Parent
local icon = btn:WaitForChild("Icon_VP")
local txtPrice = btn:WaitForChild("Info"):WaitForChild("Txt_Price")

local CYCLE_SECONDS = 5

local TREADMILL_GAMEPASS_IDS = {
	["Sci-FiTreadmill"] = 1954567487, -- real, Dashboard del user
	FlameTreadmill = 1955443420, -- real, Dashboard del user
	CelebrityTreadmill = 1955581402, -- real, Dashboard del user
	GoldenTreadmill = 1952896047, -- real, Dashboard del user
	["The FreezeTreadmill"] = 1954157730, -- real, Dashboard del user
	["Lucky BlockTreadmill"] = 1955257463, -- real, Dashboard del user
	HackerTreadmill = 1955574745, -- TODO: aun no es real, de otra cuenta
	DemonicTreadmill = 1955652727, -- TODO: aun no es real, de otra cuenta
	AngelicTreadmill = 1954974815, -- TODO: aun no es real, de otra cuenta
}

-- Los 9 tiers comprables con Robux (todo menos la gratis), en orden de nivel ascendente.
local BEST_IDS = {
	"Sci-FiTreadmill", "FlameTreadmill", "CelebrityTreadmill", "GoldenTreadmill",
	"The FreezeTreadmill", "Lucky BlockTreadmill", "HackerTreadmill", "DemonicTreadmill", "AngelicTreadmill",
}

local BEST = {}
for _, id in ipairs(BEST_IDS) do
	local cfg = Treadmills.Directory[id]
	if cfg then
		table.insert(BEST, cfg)
	else
		warn("[TreadmillUpgradeButton] Missing Directory.Treadmills entry: " .. id)
	end
end

local index = 1
local cam = nil
local center = Vector3.zero
local dist = 10
local yaw = 0

-- Tool (no Model) -- no tiene :GetBoundingBox(), se calcula a mano recorriendo sus BaseParts.
local function computeExtents(instance)
	local min, max = nil, nil
	for _, part in ipairs(instance:GetDescendants()) do
		if part:IsA("BasePart") then
			local half = part.Size / 2
			local corner1 = part.Position - half
			local corner2 = part.Position + half
			if not min then
				min, max = corner1, corner2
			else
				min = Vector3.new(math.min(min.X, corner1.X), math.min(min.Y, corner1.Y), math.min(min.Z, corner1.Z))
				max = Vector3.new(math.max(max.X, corner2.X), math.max(max.Y, corner2.Y), math.max(max.Z, corner2.Z))
			end
		end
	end
	if not min then
		return Vector3.zero, Vector3.new(4, 4, 4)
	end
	return (min + max) / 2, (max - min)
end

local function show(entry)
	if not entry then
		return
	end
	for _, c in ipairs(icon:GetChildren()) do
		c:Destroy()
	end
	local template = TreadmillModels:FindFirstChild(entry._id)
	if not template then
		warn("[TreadmillUpgradeButton] Missing treadmill model: " .. tostring(entry._id))
		return
	end
	local model = template:Clone()
	model.Parent = icon

	cam = Instance.new("Camera")
	cam.Parent = icon
	icon.CurrentCamera = cam

	local pos, size = computeExtents(model)
	center = pos
	local maxDim = math.max(size.X, size.Y, size.Z, 1)
	dist = maxDim * 0.9 + 3
	yaw = 0

	local passId = TREADMILL_GAMEPASS_IDS[entry._id]
	if passId and passId > 0 then
		local ok, price = pcall(MonetizationGamepassUtil.GetGamepassPriceInRobux, passId)
		txtPrice.Text = (ok and type(price) == "number" and price > 0) and ("\238\128\130" .. tostring(price)) or "..."
	else
		txtPrice.Text = "Coming Soon"
	end
end

show(BEST[index])

task.spawn(function()
	while true do
		task.wait(CYCLE_SECONDS)
		if #BEST > 0 then
			index = index % #BEST + 1
			show(BEST[index])
		end
	end
end)

-- Orbita lenta de la camara para que la cinta se vea girando (igual que el original).
RunService.RenderStepped:Connect(function(dt)
	if cam then
		yaw += dt * 0.6
		local offset = (CFrame.Angles(0, yaw, 0) * CFrame.Angles(math.rad(-15), 0, 0)) * Vector3.new(0, 0, dist)
		cam.CFrame = CFrame.lookAt(center + offset, center)
	end
end)

btn.MouseButton1Click:Connect(function()
	local entry = BEST[index]
	local passId = entry and TREADMILL_GAMEPASS_IDS[entry._id]
	if passId and passId > 0 then
		MarketplaceService:PromptGamePassPurchase(Players.LocalPlayer, passId)
	end
end)

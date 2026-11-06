--[[
	FeaturesClient: Клиентская логика для промокодов, ежедневных наград и питомцев
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Client = ReplicatedStorage:WaitForChild("Client")
local InterfaceClient = require(Client:WaitForChild("InterfaceClient"))
local Databases = ReplicatedStorage:WaitForChild("Databases")
local PetsListModule = Databases:FindFirstChild("PetsList")
local PetsList = PetsListModule and require(PetsListModule) or nil

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local ServerRemotes = Remotes:WaitForChild("Server")
local ClientRemotes = Remotes:WaitForChild("Client")

local RedeemCodeRemote = ServerRemotes:WaitForChild("RedeemCode")
local ClaimDailyRemote = ServerRemotes:WaitForChild("ClaimDailyReward")
local ClaimPlaytimeRemote = ServerRemotes:WaitForChild("ClaimPlaytimeReward")

local HatchEggRemote = ServerRemotes:FindFirstChild("HatchEgg")
local EquipPetRemote = ServerRemotes:FindFirstChild("EquipPet")
local UnequipPetRemote = ServerRemotes:FindFirstChild("UnequipPet")
local HatchResultRemote = ClientRemotes:FindFirstChild("HatchResult")

local Main = LocalPlayer.PlayerGui:WaitForChild("Main")

-- Регистрируем новые фреймы в InterfaceClient
local CodesFrame = Main:WaitForChild("CodesFrame")
local DailyRewardsFrame = Main:WaitForChild("DailyRewardsFrame")
local PetsFrame = Main:FindFirstChild("PetsFrame")
InterfaceClient.Frames.CodesFrame = CodesFrame
InterfaceClient.Frames.DailyRewardsFrame = DailyRewardsFrame
if PetsFrame then
    InterfaceClient.Frames.PetsFrame = PetsFrame
end

local FeaturesClient = {}

--- Настройка CodesFrame
local function setupCodesFrame()
    local content = CodesFrame:FindFirstChild("Content")
    if not content then return end

    local textBox = content:FindFirstChild("CodeInput")
    local redeemBtn = content:FindFirstChild("RedeemButton")

    if redeemBtn and textBox then
        redeemBtn.Activated:Connect(function()
            local code = textBox.Text
            if code and code ~= "" and code ~= "Enter code..." then
                RedeemCodeRemote:FireServer(code)
                textBox.Text = ""
            end
        end)

        -- Enter key support
        textBox.FocusLost:Connect(function(enterPressed)
            if enterPressed then
                local code = textBox.Text
                if code and code ~= "" then
                    RedeemCodeRemote:FireServer(code)
                    textBox.Text = ""
                end
            end
        end)
    end

    -- Exit button
    local exit = CodesFrame:FindFirstChild("Exit")
    if exit then
        exit.Activated:Connect(function()
            InterfaceClient:Close(CodesFrame)
        end)
        exit.MouseButton1Click:Connect(function()
            InterfaceClient:Close(CodesFrame)
        end)
    end
end

--- Настройка DailyRewardsFrame
local function setupDailyRewardsFrame()
    local content = DailyRewardsFrame:FindFirstChild("Content")
    local ptContent = DailyRewardsFrame:FindFirstChild("PlaytimeContent")
    local tabs = DailyRewardsFrame:FindFirstChild("TabsContainer")
    if not content then return end

    local claimBtn = content:FindFirstChild("ClaimButton")
    local streakLabel = content:FindFirstChild("StreakLabel")

    if claimBtn then
        claimBtn.Activated:Connect(function()
            ClaimDailyRemote:FireServer()
        end)
        claimBtn.MouseButton1Click:Connect(function()
            ClaimDailyRemote:FireServer()
        end)
    end

    -- Exit button
    local exit = DailyRewardsFrame:FindFirstChild("Exit")
    if exit then
        exit.Activated:Connect(function()
            InterfaceClient:Close(DailyRewardsFrame)
        end)
        exit.MouseButton1Click:Connect(function()
            InterfaceClient:Close(DailyRewardsFrame)
        end)
    end

    -- Tabs navigation (in exact game ImageButton style)
    if tabs and ptContent then
        local dailyTab = tabs:FindFirstChild("DailyTabBtn")
        local ptTab = tabs:FindFirstChild("PlaytimeTabBtn")
        if dailyTab and ptTab then
            dailyTab.Activated:Connect(function()
                content.Visible = true
                ptContent.Visible = false
                if dailyTab:IsA("ImageButton") then
                    dailyTab.Image = "rbxassetid://139350295149302"
                    if dailyTab:FindFirstChild("Title") then dailyTab.Title.TextColor3 = Color3.fromRGB(255, 255, 255) end
                end
                if ptTab:IsA("ImageButton") then
                    ptTab.Image = "rbxassetid://137659582455071"
                    if ptTab:FindFirstChild("Title") then ptTab.Title.TextColor3 = Color3.fromRGB(220, 220, 220) end
                end
            end)
            ptTab.Activated:Connect(function()
                content.Visible = false
                ptContent.Visible = true
                if ptTab:IsA("ImageButton") then
                    ptTab.Image = "rbxassetid://139350295149302"
                    if ptTab:FindFirstChild("Title") then ptTab.Title.TextColor3 = Color3.fromRGB(255, 255, 255) end
                end
                if dailyTab:IsA("ImageButton") then
                    dailyTab.Image = "rbxassetid://137659582455071"
                    if dailyTab:FindFirstChild("Title") then dailyTab.Title.TextColor3 = Color3.fromRGB(220, 220, 220) end
                end
            end)
        end
    end

    -- Update streak from replica
    local function updateStreak(streak)
        if streakLabel then
            streakLabel.Text = "Current Streak: " .. tostring(streak) .. " / 30"
        end
    end

    -- Listen to replica changes & update Playtime cards
    local ReplicaController = require(Client:WaitForChild("DataClient")):GetReplica()
    if ReplicaController then
        ReplicaController:ListenToChange({"DailyRewardStreak"}, function(newStreak)
            updateStreak(newStreak)
        end)
        local data = ReplicaController.Data
        if data then
            updateStreak(data.DailyRewardStreak or 0)
        end

        -- Playtime buttons hookup and timer loop
        if ptContent then
            local ptGrid = ptContent:FindFirstChild("PlaytimeGrid")
            if ptGrid then
                for _, card in ipairs(ptGrid:GetChildren()) do
                    if card:IsA("ImageLabel") then
                        local btn = card:FindFirstChild("ClaimButton")
                        if btn then
                            btn.Activated:Connect(function()
                                local giftId = btn:GetAttribute("GiftId")
                                if giftId and ClaimPlaytimeRemote then
                                    ClaimPlaytimeRemote:FireServer(giftId)
                                end
                            end)
                        end
                    end
                end

                local function formatPlaytime(sec)
                    local m = math.floor(sec / 60)
                    local s = sec % 60
                    return string.format("%02d:%02d", m, s)
                end

                local localSec = 0
                local lastRepSec = -1
                local lastSyncTime = os.clock()

                task.spawn(function()
                    while true do
                        task.wait(1)
                        if not ptContent.Parent then break end
                        local repData = ReplicaController.Data
                        if repData then
                            local currentRepSec = repData.PlaytimeSeconds or 0
                            if currentRepSec ~= lastRepSec then
                                lastRepSec = currentRepSec
                                localSec = currentRepSec
                                lastSyncTime = os.clock()
                            else
                                local elapsed = math.floor(os.clock() - lastSyncTime + 0.5)
                                localSec = lastRepSec + elapsed
                            end
                            local currentSec = localSec
                            local claimedMap = repData.PlaytimeRewardsClaimed or {}
                            for _, card in ipairs(ptGrid:GetChildren()) do
                                if card:IsA("ImageLabel") then
                                    local btn = card:FindFirstChild("ClaimButton")
                                    if btn then
                                        local giftId = btn:GetAttribute("GiftId")
                                        local reqSec = btn:GetAttribute("RequiredSeconds") or 0
                                        local titleLabel = btn:FindFirstChild("Title")
                                        if claimedMap[tostring(giftId)] then
                                            if titleLabel and titleLabel.Text ~= "CLAIMED" then
                                                titleLabel.Text = "CLAIMED"
                                                btn.Image = "rbxassetid://137659582455071"
                                                btn.ImageColor3 = Color3.fromRGB(120, 120, 120)
                                            end
                                        elseif currentSec >= reqSec then
                                            if titleLabel and titleLabel.Text ~= "CLAIM!" then
                                                titleLabel.Text = "CLAIM!"
                                                btn.Image = "rbxassetid://139350295149302"
                                                btn.ImageColor3 = Color3.fromRGB(255, 255, 255)
                                            end
                                        else
                                            local remain = reqSec - currentSec
                                            if titleLabel then
                                                titleLabel.Text = formatPlaytime(remain)
                                            end
                                            btn.Image = "rbxassetid://137659582455071"
                                            btn.ImageColor3 = Color3.fromRGB(255, 255, 255)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end)
            end
        end
    end
end

--- Создаёт карточку питомца в инвентаре
local function createPetCard(petId, uniqueId, isEquipped, petsContainer)
    if not PetsList or not EquipPetRemote or not UnequipPetRemote then return end
    local petData = PetsList[petId]
    if not petData then return end

    local card = Instance.new("TextButton")
    card.Name = uniqueId
    card.Text = petData.Name .. "\n" .. petData.Rarity .. (isEquipped and "\n(Equipped)" or "\n(Tap to equip)")
    card.TextColor3 = Color3.fromRGB(255, 255, 255)
    card.TextScaled = true
    card.Font = Enum.Font.GothamBold
    card.BackgroundColor3 = isEquipped and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(40, 40, 55)
    card.BackgroundTransparency = 0.2
    card.ZIndex = 11
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = card

    card.MouseButton1Click:Connect(function()
        if isEquipped then
            UnequipPetRemote:FireServer(uniqueId)
        else
            EquipPetRemote:FireServer(uniqueId)
        end
    end)

    card.Parent = petsContainer
end

--- Обновляет список питомцев
local function refreshPetsList(petsData)
    if not PetsFrame or not PetsList then return end
    local content = PetsFrame:FindFirstChild("Content")
    if not content then return end
    local petsContainer = content:FindFirstChild("PetsContainer")
    if not petsContainer then return end

    -- Очищаем старые карточки
    for _, child in ipairs(petsContainer:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end

    -- Создаём новые
    if petsData then
        for uniqueId, pet in pairs(petsData) do
            createPetCard(pet.PetId, uniqueId, pet.Equipped, petsContainer)
        end
    end
end

--- Настройка PetsFrame
local function setupPetsFrame()
    if not PetsFrame or not HatchEggRemote or not HatchResultRemote or not PetsList then return end
    local content = PetsFrame:FindFirstChild("Content")
    if not content then return end

    -- Egg buttons
    local eggsContainer = content:FindFirstChild("EggsContainer")
    if eggsContainer then
        for _, eggBtn in ipairs(eggsContainer:GetChildren()) do
            if eggBtn:IsA("TextButton") then
                eggBtn.MouseButton1Click:Connect(function()
                    local eggId = eggBtn:GetAttribute("EggId")
                    if eggId then
                        HatchEggRemote:FireServer(eggId)
                    end
                end)
            end
        end
    end

    -- Exit button
    local exit = PetsFrame:FindFirstChild("Exit")
    if exit then
        exit.MouseButton1Click:Connect(function()
            InterfaceClient:Close(PetsFrame)
        end)
    end

    -- Hatch result handler
    HatchResultRemote.OnClientEvent:Connect(function(petId, rarity)
        local petData = PetsList[petId]
        if petData then
            print("[FeaturesClient]: Hatched " .. petData.Name .. " (" .. rarity .. ")!")
        end
    end)

    -- Listen to replica for pets changes
    local DataClient = require(Client:WaitForChild("DataClient"))
    local ReplicaController = DataClient:GetReplica()
    if ReplicaController then
        ReplicaController:ListenToChange({"Pets"}, function(newPets)
            refreshPetsList(newPets)
        end)
        local data = ReplicaController.Data
        if data then
            refreshPetsList(data.Pets)
        end
    end
end

--- Создаёт кнопки в LeftFrame для открытия новых окон
local function setupLeftFrameButtons()
    local LeftFrame = Main:WaitForChild("LeftFrame")
    local container4 = LeftFrame:WaitForChild("4")

    -- Кнопка промокодов (ImageButton, клонирована из ShopButton)
    local codesBtn = container4:FindFirstChild("CodesButton")
    if codesBtn then
        codesBtn.Activated:Connect(function()
            InterfaceClient:Open(CodesFrame)
        end)
        codesBtn.MouseButton1Click:Connect(function()
            InterfaceClient:Open(CodesFrame)
        end)
    end

    -- Кнопка ежедневных наград
    local dailyBtn = container4:FindFirstChild("DailyButton")
    if dailyBtn then
        dailyBtn.Activated:Connect(function()
            InterfaceClient:Open(DailyRewardsFrame)
        end)
        dailyBtn.MouseButton1Click:Connect(function()
            InterfaceClient:Open(DailyRewardsFrame)
        end)
    end

    -- Кнопка питомцев
    local petsBtn = container4:FindFirstChild("PetsButton")
    if petsBtn and PetsFrame then
        petsBtn.Activated:Connect(function()
            InterfaceClient:Open(PetsFrame)
        end)
        petsBtn.MouseButton1Click:Connect(function()
            InterfaceClient:Open(PetsFrame)
        end)
    end
end

function FeaturesClient.Start(self)
    setupCodesFrame()
    setupDailyRewardsFrame()
    setupPetsFrame()
    setupLeftFrameButtons()
    print("[FeaturesClient]: Started")
end

return FeaturesClient
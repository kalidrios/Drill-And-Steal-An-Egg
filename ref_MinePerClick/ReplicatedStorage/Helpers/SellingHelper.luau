--[[
	SellingHelper: Вспомогательный модуль для расчёта стоимости продажи предметов
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Databases = ReplicatedStorage:WaitForChild("Databases")
local Helpers = ReplicatedStorage:WaitForChild("Helpers")

local LevelsHelper = require(Helpers:WaitForChild("LevelsHelper"))
local ItemsHelper = require(Helpers:WaitForChild("ItemsHelper"))
local IndexHelper = require(Helpers:WaitForChild("IndexHelper"))

local SellingHelper = {}

--- Рассчитывает доход от продажи конкретного предмета
function SellingHelper.GetRevenue(self, item, rebirths, cashMultiplier, traitIndex, _unused, auraMultiplier)
	local calculatedPreset = ItemsHelper:GetCalculatedPreset(item)
	if not calculatedPreset then
		return 0
	end

	-- Базовая выручка * множитель за уровни/ребирты * множитель доната * множитель ауры
	local revenue = calculatedPreset.Revenue 
		* LevelsHelper:GetCashMultiplier(rebirths) 
		* (cashMultiplier or 1) 
		* (auraMultiplier or 1)

	-- Бонус 1.5x, если коллекция трейтов полностью собрана
	if IndexHelper:IsTraitIndexComplete(traitIndex) then
		revenue = revenue * 1.5
	end

	return math.floor(revenue)
end

--- Рассчитывает стоимость использования Trait Machine для предмета
function SellingHelper.GetTraitMachinePrice(self, item, rebirths, cashMultiplier, traitIndex, _unused, auraMultiplier)
	local itemRevenue = SellingHelper:GetRevenue(item, rebirths, cashMultiplier, traitIndex, _unused, auraMultiplier) or 0
	local baseRevenue = SellingHelper:GetRevenue(item, 0, 1, traitIndex) or 0
	
	local price = itemRevenue * 0.25 - baseRevenue * 0.25 * 0.3
	return math.max(0, math.floor(price))
end

return SellingHelper
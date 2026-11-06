local Daycare = {}

local Time = 21600
if game:GetService("RunService"):IsStudio() then
    Time = 15
end

Daycare.DURATION_SECONDS = Time

Daycare.ORIGINAL_DURATION_SECONDS = 21600

Daycare.ONLINE_SPEEDUP = 3

Daycare.SLOTS_FREE = 10

Daycare.SLOT_TIERS = { {
    Amount = 10, 
    Product = "Daycare Tier 1"
} }

local Slots = Daycare.SLOTS_FREE

for i, v in ipairs(Daycare.SLOT_TIERS) do
    Slots = Slots + v.Amount
end

Daycare.SLOTS_MAX = Slots

return Daycare

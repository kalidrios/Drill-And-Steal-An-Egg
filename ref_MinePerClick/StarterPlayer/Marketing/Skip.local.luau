-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")

game:GetService("TweenService")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Helpers = ReplicatedStorage:WaitForChild("Helpers")
local PurchasesHelper = require(Helpers:WaitForChild("PurchasesHelper"))
local Utils = ReplicatedStorage:WaitForChild("Utils")
local ModelTweener = require(Utils:WaitForChild("ModelTweener"))
local Databases = ReplicatedStorage:WaitForChild("Databases")
local StagesList = require(Databases:WaitForChild("StagesList"))

for k, v in pairs(StagesList) do
	local v1 = false
	local v2 = StagesList[k + 1]

	if v2 and v2.ProductId and v2.ProductId > 0 then
		local Marketing = v.Folder:FindFirstChild("Marketing")

		if Marketing then
			local v3 = Marketing:FindFirstChild("Skip Stage")

			if v3 then
				local Hitbox = v3:FindFirstChild("Hitbox")

				if Hitbox then
					local Amount = v3:FindFirstChild("Marker"):FindFirstChild("Title"):FindFirstChild("BillboardGui"):FindFirstChild("Amount")

					if Amount then
						Amount.Text = ("%s %s"):format(utf8.char(57346), tostring(PurchasesHelper:GetProductPrice(v2.ProductId)))
						Hitbox.Touched:Connect(function(p1) --[[ Line: 41 | Upvalues: Players (copy), LocalPlayer (copy), v1 (ref), v2 (copy), ModelTweener (copy), v3 (copy) ]]
							local v12 = Players:GetPlayerFromCharacter(p1.Parent)

							if not v12 then
								return
							end

							if v12 ~= LocalPlayer then
								return
							end

							if not v1 then
								v1 = true
								task.delay(1, function() --[[ Line: 50 | Upvalues: v1 (ref) ]]
									v1 = false
								end)
								game:GetService("MarketplaceService"):PromptProductPurchase(LocalPlayer, v2.ProductId)
								task.spawn(function() --[[ Line: 58 | Upvalues: ModelTweener (ref), v3 (ref) ]]
									ModelTweener.TweenScale(v3, 1, 0.7, TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
									task.wait(0.15)
									ModelTweener.TweenScale(v3, 0.7, 1, TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
								end)
							end
						end)
					end
				end
			end
		end
	end
end
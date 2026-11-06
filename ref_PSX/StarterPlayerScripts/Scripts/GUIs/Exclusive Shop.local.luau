-- https://github.com/kalidrios

local _L = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"))
while (not _L.Loaded) do  game:GetService("RunService").Heartbeat:Wait()  end
local t_ExclusiveShop = _L.GUI.ExclusiveShop
local u1 = _L.Network.Invoke("Get OSTime")
local ServerTimeNow = workspace:GetServerTimeNow()
local bool1 = false
local table1 = {}
local table2 = {}
local table3 = {}
local rng = Random.new()
function UpdateBoosts()  
	local function UpdateBoost(p11) 
		local v23 = _L.Save.Get()
		local Attribute = p11:GetAttribute("Boost")
		local v24 = v23.Boosts[Attribute]
		p11.TimeLeft.Visible = v24 ~= nil
		if v24 then
			if v24 < 86400 then
				p11.TimeLeft.Text = _L.Functions.TimerString(v24)
			else
				p11.TimeLeft.Text = _L.Functions.TimeString(v24) .. " Left"
			end
		end
		local v25 = v23.BoostsInventory[Attribute]
		local Use = p11.Buttons:FindFirstChild("Use")
		Use.Visible = v25 ~= nil
		if v25 then
			Use:FindFirstChild("Label").Text = "Use (" .. _L.Functions.Commas(v25) .. ")"
		end
		if Attribute == "Triple Diamonds" then
			p11.Visible = v25 and v25 > 0 and true or v24 and v24 > 0
		end
	end
	local function SetupBoost(p12)  
		local t_ID2 = _L.Directory.Products[p12:GetAttribute("Product")].ID
		local Attribute2 = p12:GetAttribute("Boost")
		local Buttons = p12:FindFirstChild("Buttons")
		local Price2 = Buttons:FindFirstChild("Price")
		local Frame = Price2:FindFirstChild("Frame")
		UpdatePriceFrame(Price2:FindFirstChild("Frame"), Attribute2)
		_L.GUIFX.ButtonFX(Price2)
		Price2.Activated:Connect(function() 
			if not bool1 then
				bool1 = true
				if Attribute2 == "Triple Diamonds" then
					_L.Message.New("This is temporarily disabled!")
					bool1 = false
					return
				end
				Purchase(Attribute2)
				bool1 = false
			end
		end)
		local Use2 = Buttons:FindFirstChild("Use")
		_L.GUIFX.ButtonFX(Use2)
		Use2.Activated:Connect(function()  
			if not bool1 then
				bool1 = true
				_L.Network.Fire("Activate Boost", Attribute2)
				bool1 = false
			end
		end)
	end
	for _, child3 in ipairs(t_ExclusiveShop.Container.Boosts:GetChildren()) do
		if not child3:GetAttribute("Boost") then continue end
		UpdateBoost(child3)
		if table3[child3] then continue end
		table3[child3] = true
		SetupBoost(child3)
	end
end
function UpdateDiamonds()  
	local t_BestCurrency = t_ExclusiveShop.Container.Diamonds.BestCurrency
	for key4, val4 in ipairs(_L.Directory.Eggs["Diamond Egg"].drops) do
		local FindFirstChild_ret = t_BestCurrency:FindFirstChild(tostring(key4))
		_L.PetUI.CreateStaticHover(FindFirstChild_ret, val4[1])
	end
	local function SetupDiamonds(p13)  
		if table2[p13] then return end
		table2[p13] = true
		local t_ID3 = _L.Directory.Products[p13:GetAttribute("Product")].ID
		UpdateRobuxPriceFrame(p13:FindFirstChild("Price"), t_ID3, false)
		_L.GUIFX.ButtonFX(p13)
		p13.Activated:Connect(function()  
			if not bool1 then
				bool1 = true
				_L.Shared.PromptPurchase(t_ID3, true)
				bool1 = false
			end
		end)
	end
	SetupDiamonds(t_ExclusiveShop.Container.Diamonds.BestCurrency)
	for _, child5 in ipairs(t_ExclusiveShop.Container.Diamonds.CurrencyGroup:GetChildren()) do
		if child5.ClassName ~= "TextButton" then continue end
		SetupDiamonds(child5)
	end
end
function UpdateGamepasses()  
	local function UpdateGamepass(p14)  
		local gamepass = p14:GetAttribute("Gamepass")
		local t_ID4 = _L.Directory.Gamepasses[gamepass].ID
		local v26 = _L.Gamepasses.Owns(t_ID4)
		if v26 then
			p14:FindFirstChild("Price").Robux.Text = "Owns"
			p14:FindFirstChild("Price").RobuxIcon.Image = "rbxassetid://6516386809"
			return
		end
		UpdatePriceFrame(p14:FindFirstChild("Price"), gamepass)
	end
	local function SetupGamepass(p15)  
		_L.GUIFX.ButtonFX(p15)
		local gamepass = p15:GetAttribute("Gamepass")
		local t_ID5 = _L.Directory.Gamepasses[gamepass].ID
		p15.Activated:Connect(function()
			if bool1 then return end
			if _L.Gamepasses.Owns(_L.Directory.Gamepasses[gamepass].ID) then
				_L.Message.New("You already own this Game Pass!")
				return
			end
			bool1 = true
			Purchase(gamepass)
			bool1 = false
		end)
	end
	for _, child6 in ipairs(t_ExclusiveShop.Gamepasses:GetChildren()) do
		for _, child10 in ipairs(child6:GetChildren()) do
			if not child10:GetAttribute("Gamepass") then continue end
			if not table1[child10] then
				table1[child10] = true
				SetupGamepass(child10)
			end
			UpdateGamepass(child10)
		end
	end
end
function Update15PetsEquipped()
	local t_Deal = t_ExclusiveShop.Container["15Pets"].Deal
	if not t_Deal.Visible then return end
	local v7 = _L.Save.Get()
	if not v7 then return end
	local v8 = v7.MaxEquipped >= 15
	t_Deal.Title.Text = math.max(v8 and v7.MaxEquipped or v7.MaxEquipped + 7, 15) .. " Pets Equipped!"
	local Price3 = t_Deal.Buttons:FindFirstChild("Price")
	if v8 then
		Price3.Robux.Text = "Owned"
		Price3.RobuxIcon.Visible = false
	else
		UpdatePriceFrame(Price3, "15 Pets Equipped")
	end
	if not t_Deal:GetAttribute("Setup") then
		t_Deal:SetAttribute("Setup", true)
		_L.GUIFX.ButtonFX(Price3)
		Price3.Activated:Connect(function() 
			if not bool1 then
				bool1 = true
				local v41, v42 = _L.Network.Invoke("Can Purchase 15 Pets Equipped")
				if v41 then
					Purchase("15 Pets Equipped")
				elseif v42 == "You need to buy the 8 Pets More pass first. Would you like to buy it now?" then
					local v47 = _L.Message.New(v42, true)
					if v47 then
						Purchase("8 Pets Equipped")
					end
				else
					_L.Message.New(v42 or "Error")
				end
				bool1 = false
			end
		end)
		coroutine.wrap(function()
			local Splash = t_Deal:FindFirstChild("Splash")
			local t_Position = Splash.Position
			while true do
				_L.Functions.Tween(Splash, {Position = t_Position - UDim2.new(0, 0, 0.05, 0)}, {
					1.5,
					"Sine",
					"InOut"
				}).Completed:Wait()
				_L.Functions.Tween(Splash, {Position = t_Position}, {
					1.25,
					"Sine",
					"InOut"
				}).Completed:Wait()
			end
		end)()
	end
end
function UpdateLazarGun() 
	if not ({[1436154219] = true})[_L.LocalPlayer.UserId] then return end
	t_ExclusiveShop.Container.LazarGun.Visible = true
	local t_Deal2 = t_ExclusiveShop.Container.LazarGun.Deal
	if not t_Deal2.Visible then return end
	local v9 = _L.Save.Get()
	if not v9 then return end
	local Price4 = t_Deal2.Buttons:FindFirstChild("Price")
	UpdateRobuxPriceFrame(Price4, _L.Directory.Products["Lazar Gun"].ID, false)
	if not t_Deal2:GetAttribute("Setup") then
		t_Deal2:SetAttribute("Setup", true)
		_L.GUIFX.ButtonFX(Price4)
		Price4.Activated:Connect(function()  
			if not bool1 then
				bool1 = true
				_L.Shared.PromptPurchase(_L.Directory.Products["Lazar Gun"].ID, true)
				bool1 = false
			end
		end)
	end
end
function UpdateOctupleEgg()   
	local t_Deal3 = t_ExclusiveShop.Container.FeaturedOctuple.Deal
	if not t_Deal3.Visible then return end
	local v10 = _L.Save.Get()
	if not v10 then return end
	local t_OwnsOctupleEggs = v10.OwnsOctupleEggs
	local Price5 = t_Deal3.Buttons:FindFirstChild("Price")
	if t_OwnsOctupleEggs then
		Price5.Robux.Text = "Owned"
		Price5.RobuxIcon.Visible = false
	else
		UpdatePriceFrame(Price5, "Octuple Egg Open")
	end
	if not t_Deal3:GetAttribute("Setup") then
		t_Deal3:SetAttribute("Setup", true)
		_L.GUIFX.ButtonFX(Price5)
		Price5.Activated:Connect(function()  
			if not bool1 then
				bool1 = true
				local v43, v44 = _L.Network.Invoke("Can Purchase Octuple Eggs")
				if v43 then
					Purchase("Octuple Egg Open")
				elseif v44 == "You need to buy the triple egg pass first. Would you like to buy it now?" then
					local v48 = _L.Message.New(v44, true)
					if v48 then
						Purchase("Triple Egg Open")
					end
				else
					_L.Message.New(v44 or "Error")
				end
				bool1 = false
			end
		end)
		local coroutine_wrap_ret2 = coroutine.wrap(function() 
			local Splash2 = t_Deal3:FindFirstChild("Splash")
			local t_Position2 = Splash2.Position
			while true do
				_L.Functions.Tween(Splash2, {Position = t_Position2 - UDim2.new(0, 0, 0.05, 0)}, {
					1.25,
					"Sine",
					"InOut"
				}).Completed:Wait()
				_L.Functions.Tween(Splash2, {Position = t_Position2}, {
					1.15,
					"Sine",
					"InOut"
				}).Completed:Wait()
			end
		end)
		coroutine_wrap_ret2()
	end
end
function UpdateSecretHunter()  
	local t_Deal4 = t_ExclusiveShop.Container.Featured.Deal
	if not t_Deal4.Visible then return end
	local v11 = _L.Save.Get()
	if not v11 then return end
	local t_ID6 = _L.Directory.Gamepasses["Secret Hunter"].ID
	local v12 = _L.Gamepasses.Owns(t_ID6)
	local Price6 = t_Deal4.Buttons:FindFirstChild("Price")
	if v12 then
		Price6.Robux.Text = "Owned"
		Price6.RobuxIcon.Visible = false
	else
		UpdatePriceFrame(Price6, "Secret Hunter")
	end
	if not t_Deal4:GetAttribute("Setup") then
		t_Deal4:SetAttribute("Setup", true)
		_L.GUIFX.ButtonFX(Price6)
		Price6.Activated:Connect(function()  
			if not bool1 then
				bool1 = true
				Purchase("Secret Hunter")
				bool1 = false
			end
		end)
		local coroutine_wrap_ret3 = coroutine.wrap(function() 
			local Splash3 = t_Deal4:FindFirstChild("Splash")
			local t_Position3 = Splash3.Position
			while true do
				_L.Functions.Tween(Splash3, {Position = t_Position3 - UDim2.new(0, 0, 0.05, 0)}, {
					1.15,
					"Sine",
					"InOut"
				}).Completed:Wait()
				_L.Functions.Tween(Splash3, {Position = t_Position3}, {
					1,
					"Sine",
					"InOut"
				}).Completed:Wait()
			end
		end)
		coroutine_wrap_ret3()
	end
end
function UpdateVDayGram()
	local t_VDay = t_ExclusiveShop.Container:FindFirstChild("FeaturedVDay")
	if not t_VDay then return end
	local t_Deal5 = t_VDay.Deal
	if not t_Deal5 or not t_Deal5.Visible then return end
	local Price7 = t_Deal5.Buttons:FindFirstChild("Price")
	if not Price7 then return end
	-- Show DevProduct price
	UpdatePriceFrame(Price7, "Valentine Broadcast")
	if not t_Deal5:GetAttribute("Setup") then
		t_Deal5:SetAttribute("Setup", true)
		_L.GUIFX.ButtonFX(Price7)
		Price7.Activated:Connect(function()
			if not bool1 then
				bool1 = true
				local sv = _L.Save.Get()
				if sv and (sv.VDayGramCredits or 0) > 0 then
					-- Already has credit, open GUI directly
					_L.GUI.VDayGram.Gui.Enabled = true
				else
					-- Buy the DevProduct, then auto-open VDayGram
					Purchase("Valentine Broadcast")
					-- After purchase, check if credits were added and open VDayGram
					task.delay(1, function()
						local sv2 = _L.Save.Get()
						if sv2 and (sv2.VDayGramCredits or 0) > 0 then
							_L.GUI.VDayGram.Gui.Enabled = true
						end
					end)
				end
				bool1 = false
			end
		end)
		-- Splash animation (bob up and down)
		local Splash = t_Deal5:FindFirstChild("Splash")
		local Splash2 = t_Deal5:FindFirstChild("Splash2")
		if Splash then
			coroutine.wrap(function()
				local pos = Splash.Position
				while true do
					_L.Functions.Tween(Splash, {Position = pos - UDim2.new(0, 0, 0.05, 0)}, {1.25, "Sine", "InOut"}).Completed:Wait()
					_L.Functions.Tween(Splash, {Position = pos}, {1.15, "Sine", "InOut"}).Completed:Wait()
				end
			end)()
		end
		if Splash2 then
			coroutine.wrap(function()
				local pos2 = Splash2.Position
				while true do
					_L.Functions.Tween(Splash2, {Position = pos2 + UDim2.new(0, 0, 0.05, 0)}, {1.5, "Sine", "InOut"}).Completed:Wait()
					_L.Functions.Tween(Splash2, {Position = pos2}, {1.25, "Sine", "InOut"}).Completed:Wait()
				end
			end)()
		end
	end
end
function MerchAnimation()  
	local Deal = t_ExclusiveShop.Container:FindFirstChild("Merch"):FindFirstChild("Deal")
	local One = Deal.Illustrations:FindFirstChild("One")
	local Two = Deal.Illustrations:FindFirstChild("Two")
	local t_Position4 = One.Position
	local t_Position5 = Two.Position
	local coroutine_wrap_ret4 = coroutine.wrap(function()  
		while true do
			_L.Functions.Tween(One, {Position = t_Position4 - UDim2.new(0, 0, 0.05, 0)}, {
				0.25,
				"Expo",
				"InOut"
			}).Completed:Wait()
			_L.Functions.Tween(One, {Position = t_Position4}, {
				0.35,
				"Quad",
				"InOut"
			}).Completed:Wait()
			_L.Functions.Wait(math.random(0, 2))
		end
	end)
	coroutine_wrap_ret4()
	local coroutine_wrap_ret5 = coroutine.wrap(function()  
		while true do
			_L.Functions.Tween(Two, {Position = t_Position5 - UDim2.new(0, 0, 0.05, 0)}, {
				0.25,
				"Expo",
				"InOut"
			}).Completed:Wait()
			_L.Functions.Tween(Two, {Position = t_Position5}, {
				0.35,
				"Quad",
				"InOut"
			}).Completed:Wait()
			_L.Functions.Wait(math.random(0, 2))
		end
	end)
	coroutine_wrap_ret5()
end
local triangleWave = function(p7)
	p7 = p7 % 2
	if p7 >= 1 then
		p7 = 2 - p7
	end
	return (p7 + 1) / 2
end
function UpdateExclusiveEggs() 
	local t_ID7 = _L.Directory.Products["Exclusive Egg"].ID
	local t_ID8 = _L.Directory.Products["3 Exclusive Eggs"].ID
	local t_ID9 = _L.Directory.Products["10 Exclusive Eggs"].ID
	local hunId = _L.Directory.Products["100 Exclusive Eggs"].ID
	local t_Pets = t_ExclusiveShop.Container.Pets
	local t_Price = t_Pets.Deal.Buttons.Price
	local t_PriceTriple = t_Pets.Deal.Buttons.PriceTriple
	local t_PriceTen = t_Pets.Deal.Buttons.PriceTen
	local t_PriceHundred = t_Pets.Deal.Buttons.PriceHundred
	for key7, val7 in ipairs(_L.Directory.Eggs["Season 1 Legendary Gift"].drops) do
		local FindFirstChild_ret2 = t_Pets.Deal.Pets:FindFirstChild(tostring(key7))
		local dir = _L.Directory.Pets[val7[1]]
		local replacements = dir.replacements
		local rep = {}
		if replacements then
			for i, v in pairs(replacements) do
				table.insert(rep, i)
			end
		end
		--FindFirstChild_ret2.PetIcon = _L.Directory.Pets[val7[1]].thumbnail 
		_L.PetUI.CreateStaticHover(FindFirstChild_ret2, val7[1], {rep = rep})
	end

	_L.GUIFX.ButtonFX(t_Price)
	_L.GUIFX.ButtonFX(t_PriceTriple)
	_L.GUIFX.ButtonFX(t_PriceTen)
	_L.GUIFX.ButtonFX(t_PriceHundred)
	t_PriceHundred.Visible = _L.Network.Invoke("Can Buy 100 Eggs") or false 
	local prices = _L.Shared.ExclusiveEggCosts
	local frameThings = {t_Price,t_PriceTriple,t_PriceTen,t_PriceHundred}
	UpdatePriceFrame(t_Price.Frame, "Exclusive1")
	UpdatePriceFrame(t_PriceTriple.Frame, "Exclusive3")
	UpdatePriceFrame(t_PriceTen.Frame, "Exclusive10")
	UpdatePriceFrame(t_PriceHundred.Frame, "Exclusive100")
	t_PriceTen.Frame.Robux.OGPrice.Text = _L.Functions.Commas(_L.Shared.Purchasables["Exclusive10"].Cost*0.25)
	t_PriceHundred.Frame.Robux.OGPrice.Text = _L.Functions.Commas(_L.Shared.Purchasables["Exclusive100"].Cost*0.33334)
	t_Price.Activated:Connect(function()
		if not bool1 then
			bool1 = true
			local v31 = _L.Save.Get()
			if #v31.Pets + 1 <= v31.MaxSlots then
				Purchase("Exclusive1")
			else
				_L.Message.New("Your inventory is full! Clear some pets first.")
			end
			bool1 = false
		end
	end)
	t_PriceTriple.Activated:Connect(function()
		if not bool1 then
			bool1 = true
			local v32 = _L.Save.Get()
			if #v32.Pets + 3 <= v32.MaxSlots then
				Purchase("Exclusive3")
			else
				_L.Message.New("You need more inventory space first!")
			end
			bool1 = false
		end
	end)
	t_PriceTen.Activated:Connect(function()
		if not bool1 then
			bool1 = true
			local v33 = _L.Save.Get()
			if #v33.Pets + 10 <= v33.MaxSlots then
				Purchase("Exclusive10")
			else
				_L.Message.New("You need more inventory space first!")
			end
			bool1 = false
		end
	end)
	t_PriceHundred.Activated:Connect(function()
		if not bool1 then
			bool1 = true
			local v33 = _L.Save.Get()
			if #v33.Pets + 100 <= v33.MaxSlots then
				Purchase("Exclusive100")
			else
				_L.Message.New("You need more inventory space first!")
			end
			bool1 = false
		end
	end)
	coroutine.wrap(function() 
		local t_Egg = t_Pets.Deal.Egg
		local t_Position6 = t_Egg.Position
		while true do
			_L.Functions.Tween(t_Egg, {Position = t_Position6 - UDim2.new(0, 0, 0.05, 0)}, {0.4,"Sine","InOut"}).Completed:Wait()
			_L.Functions.Tween(t_Egg, {Position = t_Position6}, {0.4,"Sine","InOut"}).Completed:Wait()
		end
	end)()

	local v743 = {}
	local v936 = {"377", "368", "378", "2182", "2183", "3028"}
	for v744, v740 in ipairs(t_Pets.Deal.Pets:GetChildren()) do
		if not v740:IsA("GuiObject") then continue end
		table.insert(v743, v740:FindFirstChild("PetIcon"))
		local petDir = _L.Directory.Pets[v936[tonumber(v740.Name)]]
		local v1036 = petDir and petDir.titanic
		if not v1036 then
			local stars = v740:FindFirstChild("Stars")
			if stars then stars.Visible = false end
		end
	end

	local function animatePets()
		local v897 = t_Pets.Deal.bg
		local v896 = t_Pets.Deal.bg2
		local v902 = Vector2.new(-0.5, 0.5)
		local p1 = UDim2.new(0.5,0,0.5,0) --v897.Position
		local p2 = UDim2.new(0.5,0,0.5,0) --v896.Position
		_L.Functions.RenderStepped(function(p8, p9)
			local v908 = triangleWave(p9 * 0.05)
			local v913 = _L.Functions.Lerp(v902.X, v902.Y, v908)
			v897.Position = p1 + UDim2.fromScale(v913, 0) --v897.Position + UDim2.fromScale(v913, 0)
			v896.Position = p2 + UDim2.fromScale(-v913, 0) --v896.Position + UDim2.fromScale(-v913, 0)
			v897.ImageTransparency = v908
			v896.ImageTransparency = 1 - v908
		end)

		for index, v940 in ipairs(v936) do
			task.spawn(function()
				local v951 = t_Pets.Deal.Pets:WaitForChild(index)
				local v949 = {
					v951:WaitForChild("PetIcon"),
					v951:WaitForChild("PetIcon2"),
					v951:WaitForChild("PetIcon3")
				}

				local v988 = 1
				while true do
					local v957 = 1 + v988 % #v949

					local render = _L.Functions.RenderStepped(function(_, p11)
						v949[v957].ImageTransparency = p11
						v949[v957 % #v949 + 1].ImageTransparency = 1 - p11
					end, rng:NextNumber(1, 3), true)	

					local renderThen = render:Then(function()
						v949[v957].ImageTransparency = 1
						v949[v957 % #v949 + 1].ImageTransparency = 0
					end)

					v988 = v957
					renderThen:Wait()
				end
			end)
		end
	end

	--task.spawn(animatePets)

	-- nightmare
	--[[coroutine.wrap(function()
		local GUI = t_Pets.Deal.Pets
		
		task.spawn(function()
			while true do
				_L.Functions.Tween(GUI["1"].PetIconGlowing, {ImageTransparency = 0}, { 2, "Sine", "InOut" }).Completed:Wait()
				_L.Functions.Tween(GUI["1"].PetIconGlowing, {ImageTransparency = 1}, { 2, "Sine", "InOut" }).Completed:Wait()
			end
		end)
		task.spawn(function()
			while true do
				_L.Functions.Tween(GUI["2"].PetIconGlowing, {ImageTransparency = 0}, { 2, "Sine", "InOut" }).Completed:Wait()
				_L.Functions.Tween(GUI["2"].PetIconGlowing, {ImageTransparency = 1}, { 2, "Sine", "InOut" }).Completed:Wait()
			end
		end)
		task.spawn(function()
			task.spawn(function()
				while wait() do
					vv = GUI["3"].PetIconLayer
					vv.Rotation += 5
					if vv.Rotation >= 360 then
						vv.Rotation = 0
					end
				end
			end)

			while wait(math.random(0.75,1)) do
				local random = math.random(1, 4)
				GUI["3"].PetIcon.Visible = random == 4
				GUI["3"].PetIconBlink1.Visible = random == 1
				GUI["3"].PetIconBlink2.Visible = random == 2
				GUI["3"].PetIconBlink3.Visible = random == 3
			end
		end)
		task.spawn(function()
			while true do
				_L.Functions.Tween(GUI["4"].PetIconGlowing, {ImageTransparency = 0}, { 2, "Sine", "InOut" }).Completed:Wait()
				_L.Functions.Tween(GUI["4"].PetIconGlowing, {ImageTransparency = 1}, { 2, "Sine", "InOut" }).Completed:Wait()
			end
		end)
		task.spawn(function()
			task.spawn(function()
				while wait() do
					vv = GUI["5"].PetIconLayer
					vv.Rotation += 5
					if vv.Rotation >= 360 then
						vv.Rotation = 0
					end
				end
			end)

			while wait(math.random(0.75,1)) do
				local random = math.random(1, 4)
				GUI["5"].PetIcon.Visible = random == 4
				GUI["5"].PetIconBlink1.Visible = random == 1
				GUI["5"].PetIconBlink2.Visible = random == 2
				GUI["5"].PetIconBlink3.Visible = random == 3
			end
		end)
		task.spawn(function()
			while true do
				_L.Functions.Tween(GUI["6"].PetIconGlowing, {ImageTransparency = 0}, { 2, "Sine", "InOut" }).Completed:Wait()
				_L.Functions.Tween(GUI["6"].PetIconGlowing, {ImageTransparency = 1}, { 2, "Sine", "InOut" }).Completed:Wait()
			end
		end)
	end)()]]--


	-- jelly animation
 	--[[coroutine.wrap(function() 
		for i, v in ipairs({'1','2','3','4','5','6'}) do
			coroutine.wrap(function() 
				local del = rng:NextNumber(0.75,2.5)
				task.wait(del)--idk
				local Pet = t_Pets.Deal.Pets[v]:FindFirstChild("PetIcon")
				local size = Pet.Size
				task.spawn(function()
					if v == '6' then
						local star = t_Pets.Deal.Star
						local pos = star.Position
						while true do
							_L.Functions.Tween(star, {Position = pos + UDim2.new(0, 0, 0.1, 0)}, { 1.5, "Sine", "InOut" }).Completed:Wait()
							_L.Functions.Tween(star, {Position = pos}, { 1.5, "Sine", "InOut" }).Completed:Wait()
						end
					end 
				end)
				while true do
					_L.Functions.Tween(Pet, {Size = size - UDim2.new(0, 0, 0.2, 0)}, { 1.5, "Sine", "InOut" }).Completed:Wait()
					_L.Functions.Tween(Pet, {Size = size}, { 1.5, "Sine", "InOut" }).Completed:Wait()
				end
			end)()
		end
	end)()]]--
end

---- TESTING ------
--_L.GUIFX.Rainbow(t_ExclusiveShop.Container.PetsChroma.Deal.Pets["6"], "ImageColor3", 10)
--_L.GUIFX.Rainbow(t_ExclusiveShop.Container.PetsChroma.Deal.Pets["5"], "ImageColor3", 10)
--_L.GUIFX.Rainbow(t_ExclusiveShop.Container.PetsChroma.Deal.Pets["4"], "ImageColor3", 10)
--_L.GUIFX.Rainbow(t_ExclusiveShop.Container.PetsChroma.Deal.Pets["3"], "ImageColor3", 10)
--_L.GUIFX.Rainbow(t_ExclusiveShop.Container.PetsChroma.Deal.Pets["2"], "ImageColor3", 10)
--_L.GUIFX.Rainbow(t_ExclusiveShop.Container.PetsChroma.Deal.Pets["1"], "ImageColor3", 10)
--_L.GUIFX.Rainbow(t_ExclusiveShop.Container.PetsChroma.Deal.Egg, "ImageColor3", 10)
--task.spawn(function()  _L.GUIFX.Rainbow(t_ExclusiveShop.Container.PetsChroma.Deal.UIGradient, "Color", 10)  end)
---- TESTING ------


function UpdateInfinitePets()  
	local t_InfinitePets = t_ExclusiveShop.Container.InfinitePets
	if not _L.FFlags.Get(_L.FFlags.Keys.InfinitePetPass) then
		t_InfinitePets.Visible = false
		return
	end
	t_InfinitePets.Visible = true
	local t_ID15 = _L.Directory.Products["Infinite Pets"].ID
	local t_Price5 = t_InfinitePets.Deal.Buttons.Price
	local function BuyInfPets() 
		local v27 = _L.Save.Get()
		if v27 and not v27.InfPetsEnabled then
			local v39 = _L.Message.New("Infinite Brainrots will only last for 72 hours. Are you sure?", true)
			if v39 then
				_L.Shared.PromptPurchase(t_ID15, true)
			end
		end
	end
	if not t_InfinitePets:GetAttribute("Setup") then
		t_InfinitePets:SetAttribute("Setup", true)
		_L.GUIFX.ButtonFX(t_Price5)
		t_Price5.Activated:Connect(function() 
			if not bool1 then
				bool1 = true
				BuyInfPets()
				bool1 = false
			end
		end)
	end
	local v13 = _L.Save.Get()
	if not v13 then return end
	if v13.InfPetsEnabled then
		t_Price5.Robux.Text = "Owned"
		t_Price5.RobuxIcon.Visible = false
		local v21 = (v13.InfPetsTimeStart or 0) + 259200 - (u1 + (workspace:GetServerTimeNow() - ServerTimeNow))
		t_InfinitePets.Deal.TimeLeft.Visible = true
		t_InfinitePets.Deal.TimeLeft.Text = v21 > 0 and _L.Functions.TimeString(v21) .. " Left" or "Expired"
		return
	end
	UpdateRobuxPriceFrame(t_Price5, t_ID15, false)
end
function UpdatePriceFrame(button, p2)
	if _L.Directory.Gamepasses[p2] and _L.Gamepasses.Owns(_L.Directory.Gamepasses[p2].ID) then
		button.Robux.Text = "Owned"
		button.RobuxIcon.Image = "rbxassetid://6516386809"
		return
	end
	local v14 = _L.Shared.Purchasables[p2]
	local Robux = button:FindFirstChild("Robux")
	if v14 and v14.Cost then
		Robux.Text = _L.Functions.Commas(v14.Cost)
		return
	end
	Robux.Text = "???"
end
function Scrollbar() 
	local UIListLayout = t_ExclusiveShop.Container:FindFirstChildOfClass("UIListLayout")
	local UIPadding = t_ExclusiveShop.Container:FindFirstChildOfClass("UIPadding")
	local v16 = UIListLayout.AbsoluteContentSize.Y + UIPadding.PaddingTop.Offset + UIPadding.PaddingBottom.Offset
	t_ExclusiveShop.Container.CanvasSize = UDim2.new(0, 0, 0, v16)
end
function SizeFrame(p4) 
	local v17 = _L.Functions.ResolutionScale()
	local v18 = 1
	for _, child8 in ipairs(p4:GetChildren()) do
		if child8.ClassName == "UIPadding" then
			local v28 = _L.GUIFX.CacheProperty(child8, "PaddingTop")
			local v29 = _L.GUIFX.CacheProperty(child8, "PaddingBottom")
			child8.PaddingTop = UDim.new(v28.Scale, v28.Offset * v17)
			child8.PaddingBottom = UDim.new(v29.Scale, v29.Offset * v17)
			v18 = v18 + (child8.PaddingTop.Offset + child8.PaddingBottom.Offset)
			continue
		end
		if child8.ClassName ~= "UIListLayout" and child8.ClassName ~= "UIGridLayout" then continue end
		v18 = v18 + child8.AbsoluteContentSize.Y
		if child8.ClassName == "UIListLayout" then
			local v30 = _L.GUIFX.CacheProperty(child8, "Padding")
			child8.Padding = UDim.new(v30.Scale, v30.Offset * v17)
		elseif child8.ClassName == "UIGridLayout" then
			local v40 = _L.GUIFX.CacheProperty(child8, "CellPadding")
			child8.CellPadding = UDim2.new(v40.X.Scale, v40.X.Offset * v17, v40.Y.Scale, v40.Y.Offset * v17)
		end
		if child8.ClassName ~= "UIGridLayout" or not child8:FindFirstChildOfClass("UIAspectRatioConstraint") then continue end
		child8.CellSize = UDim2.new(child8.CellSize.X.Scale, child8.CellSize.X.Offset, 0, child8.AbsoluteCellSize.Y + 2)
	end
	p4.Size = UDim2.new(p4.Size.X.Scale, p4.Size.X.Offset, 0, v18)
end
function Scaling()   
	if not t_ExclusiveShop.Gui.Enabled then return end
	local v19 = game.Workspace.CurrentCamera.ViewportSize.Y <= 1000
	local UIAspectRatioConstraint2 = t_ExclusiveShop.Frame:FindFirstChildOfClass("UIAspectRatioConstraint")
	UIAspectRatioConstraint2.AspectRatio = v19 and 1.6 or 1.2
	t_ExclusiveShop.Tabs.Size = v19 and UDim2.new(0.075, 0, 0.6, 0) or UDim2.new(0.075, 0, 0.039, 0)
	for _, child9 in ipairs(t_ExclusiveShop.Container:GetChildren()) do
		if not child9:IsA("GuiObject") then continue end
		for _, child11 in ipairs(child9:GetChildren()) do
			if not child11:FindFirstChildOfClass("UIListLayout") and not child11:FindFirstChildOfClass("UIGridLayout") then continue end
			SizeFrame(child11)
		end
		SizeFrame(child9)
	end
	Scrollbar()
end
local coroutine_wrap_ret9 = coroutine.wrap(function() 
	while true do
		_L.Heartbeat()
		Scaling()
	end
end)
coroutine_wrap_ret9()
function UpdateRobuxPriceFrame()

end
function UpdateShopButton(a1) 
	if not _L.Save.Get() then
		return
	end
	_L.GUI.Main.Bottom.ExclusiveShop.Notification.Visible = _L.Save.Get().LastShopClick ~= _L.Shared.ShopNumber
	if a1 then
		task.spawn(function()
			while true do
				wait(5)
			end
		end)
	end
end
function UseTab(p5)   
	local FindFirstChild_ret3 = t_ExclusiveShop.Container:FindFirstChild(p5.Name)
	if not FindFirstChild_ret3 then
		warn("No frame!")
		return
	end
	if not t_ExclusiveShop.Container then
		warn("No frame!")
		return
	end
	local v20 = t_ExclusiveShop.Container.CanvasPosition.Y + (FindFirstChild_ret3.AbsolutePosition.Y - t_ExclusiveShop.Container.AbsolutePosition.Y)
	_L.Functions.Tween(t_ExclusiveShop.Container, {CanvasPosition = Vector2.new(0, v20)}, {
		0.2,
		"Expo",
		"Out"
	})
	_L.Audio.Play("rbxassetid://7004248320", script, 1, 0.5)
end
function SetupTab(p6)  
	_L.GUIFX.ButtonFX(p6)
	_L.GUIFX.Tooltip(p6, p6.Name)
	p6.Activated:Connect(function()  
		if not bool1 then
			bool1 = true
			UseTab(p6)
			bool1 = false
		end
	end)
end
for _, child1 in ipairs(t_ExclusiveShop.Tabs:GetChildren()) do
	if child1.ClassName ~= "ImageButton" then continue end
	SetupTab(child1)
end
local t_Redeem = t_ExclusiveShop.Container.Codes.Frame.Buttons.Redeem
_L.GUIFX.ButtonFX(t_Redeem)
t_Redeem.Activated:Connect(function()  
	if not bool1 then
		bool1 = true
		_L.GUI.TwitterCodes.Gui.Enabled = true
		bool1 = false
	end
end)
if t_ExclusiveShop.Container.BoosterPack.Visible then
	local t_Price6 = t_ExclusiveShop.Container.BoosterPack.Deal.Buttons.Price
	UpdatePriceFrame(t_Price6, "The Boost Bundle")
	_L.GUIFX.ButtonFX(t_Price6)
	t_Price6.Activated:Connect(function()  
		if not bool1 then
			bool1 = true
			Purchase("The Boost Bundle")
			bool1 = false
		end
	end)
end
function Purchase(purchasable: string)
	local s, r = _L.Network.Invoke("Exclusive Shop Purchase", purchasable)
	if not s then
		-- veio mensagem "… Paw Tokens 😥"
		if r and string.find(r, "Paw Tokens") then
			_L.Message.New(r)
			local data = _L.Shared.Purchasables[purchasable]
			if data then
				local id
				if data.class == "Gamepass" then
					id = _L.Directory.Gamepasses[purchasable].ID
				elseif data.class == "Product" or data.class == "Boost" or data.class == "ExclusiveEgg" then
					id = _L.Directory.Products[purchasable].ID
				end
				if id then
					_L.Shared.PromptPurchase(id, true) -- abre o prompt Robux no cliente
				end
			end
			return
		end
		_L.Message.New(r or "Something went wrong, try again!")
		return
	end
	_L.Message.New("Purchase successful ✅")
end

if t_ExclusiveShop.Container.Deal.Visible then
	local priceButton = t_ExclusiveShop.Container.Deal.Deal.Buttons.RedeemButton
	priceButton.Activated:Connect(function()
		if not bool1 then
			bool1 = true
			if _L.Message.New("Would you like to redeem these rewards?", true) then
				_L.Message.New("Calculating compensation... (this may take a while)")
				local s, r = _L.Network.Invoke("Calculate Gamepass Rewards")
				if not s then
					_L.Message.New(r or "Something went wrong, Please try again!")
				end
				_L.Message.New("✅ You have recieved your rewards! Thank you so much for your support! 😊")
			end	
			bool1 = false
		end
	end)
	coroutine.wrap(function()
		local Splash4 = t_ExclusiveShop.Container.Deal.Deal:FindFirstChild("Illustrations").Image
		local t_Position8 = Splash4.Position
		while true do
			_L.Functions.Tween(Splash4, {Position = t_Position8 - UDim2.new(0, 0, 0.025, 0)}, {
				1.25,
				"Sine",
				"InOut"
			}).Completed:Wait()
			_L.Functions.Tween(Splash4, {Position = t_Position8}, {
				1.15,
				"Sine",
				"InOut"
			}).Completed:Wait()
		end
	end)()
end
local t_Redeem2 = t_ExclusiveShop.Container.Merch.Deal.Buttons.Redeem
_L.GUIFX.ButtonFX(t_Redeem2)
t_Redeem2.Activated:Connect(function()  
	if not bool1 then
		bool1 = true
		_L.GUI.MerchCodes.Gui.Enabled = true
		bool1 = false
	end
end)
_L.GUIFX.ButtonFX(t_ExclusiveShop.Close)
t_ExclusiveShop.Close.Activated:Connect(function()  
	if not bool1 then
		bool1 = true
		t_ExclusiveShop.Gui.Enabled = false
		bool1 = false
	end
end)
local u2 = 0
local t_Subtitle = t_ExclusiveShop.Container.Pets.Deal.Subtitle
_L.RunService.Heartbeat:Connect(function(p7) 
	u2 = u2 + p7
	if u2 > 1 then
		u2 = u2 - 1
		if not _L.FFlags.Get(_L.FFlags.Keys.ExclusiveEggTimer) then
			if t_Subtitle.Text ~= "Limited Time Pets!" then
				t_Subtitle.Text = "Limited Time Pets!"
			end
			return
		end
		local v22 = 9 - workspace:GetServerTimeNow()
		if v22 > 0 then
			if v22 < 345600 then
				t_Subtitle.Text = "Limited time for " .. _L.Functions.FormatTime(v22 >= 0 and v22 or 0, true, true) .. "!"
			end
		else
			t_Subtitle.Text = "Leaving any second! \240\159\142\137"
		end
	end
end)
UpdateGamepasses()
UpdateDiamonds()
UpdateBoosts()
UpdateOctupleEgg()
UpdateSecretHunter()
Update15PetsEquipped()
MerchAnimation()
UpdateExclusiveEggs()
UpdateLazarGun()
UpdateInfinitePets()
UpdateVDayGram()
_L.Signal.Fired("Stat Changed"):Connect(function(p8)  
	if p8 == "Gamepasses" then
		UpdateGamepasses()
		UpdateSecretHunter()
		return
	end
	if p8 == "Boosts" or p8 == "BoostsInventory" then
		UpdateBoosts()
		return
	end
	if p8 == "MaxEquipped" then
		Update15PetsEquipped()
		return
	end
	if p8 == "InfPetsEnabled" or p8 == "InfPetsTimeStart" then
		UpdateInfinitePets()
		return
	end
	if p8 == "OwnsOctupleEggs" then
		UpdateOctupleEgg()
	end
end)
_L.Signal.Fired("FFlags Changed"):Connect(function()  
	UpdateInfinitePets()
end)
_L.Signal.Fired("Exlusive Shop Tab"):Connect(function(p9) 
	local FindFirstChild_ret4 = t_ExclusiveShop.Tabs:FindFirstChild(p9)
	t_ExclusiveShop.Gui.Enabled = true
	UseTab(FindFirstChild_ret4)
end)
_L.Signal.Fired("Clicked Shop Button"):Connect(function()
	UpdateShopButton()
end)

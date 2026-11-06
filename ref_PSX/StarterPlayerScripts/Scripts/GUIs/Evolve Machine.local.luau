--[[

	Re-scripted 7/9/2023 By: kalidrios
		
--]]

--------|     Library     |--------
local _L = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"))
while (not _L.Loaded) do  game:GetService("RunService").Heartbeat:Wait()  end 

local SelectedPets = {}
local EvolveGUI = _L.GUI.EvolvePets
local DeepSelectedPets = {}
local EvolveInSession = false
local debounce = false
local RNG = Random.new()

function PetsSelect(uid)
	local pet = _L.PetCmds.Get(uid)
	if not uid then
		return
	end
	
	local save = _L.Save.Get()
	if not save then
		return
	end
	assert(save)
	
	if 5 <= #SelectedPets then
		return
	end
	
	if table.find(SelectedPets, uid) then
		return
	end
	
	_L.Audio.Play("rbxassetid://7139317934", script, RNG:NextNumber(0.95, 1.05), 0.75)
	table.insert(SelectedPets, uid)
	Update()
end

function PetsDeselect(uid)
	_L.Audio.Play("rbxassetid://7139317909", script, RNG:NextNumber(0.95, 1.05), 0.75)
	table.remove(SelectedPets, table.find(SelectedPets, uid))
	Update()
end

function Update()
	PetsUpdate()
	LootUpdate()
	EvolveGUI.Side.Evolve.ImageColor3 = #SelectedPets == 5 and Color3.new(1, 1, 1) or Color3.new(0.5, 0.5, 0.5);
	
	(function()
		local hasSelected = 0 < #SelectedPets
		EvolveGUI.Side.LeftNotice1.Visible = not hasSelected
		EvolveGUI.Side.RightNotice1.Visible = #SelectedPets == 0
		EvolveGUI.Side.LeftNotice2.Visible = hasSelected
		
		local doesntQualify = false
		if 0 < #SelectedPets then
			doesntQualify = #SelectedPets < 5
		end
		
		EvolveGUI.Side.RightNotice2.Visible = doesntQualify
		EvolveGUI.Side.ChanceFrame.Visible = 5 <= #SelectedPets
		EvolveGUI.Side.ChanceFrame.RainbowChance.Text = "Rainbow: " .. GetRainbowChance() .. "%"
		EvolveGUI.Side.ChanceFrame.ShinyChance.Text = "Shiny: " .. GetShinyChance() .. "%"
		
		if _L.Variables.Console then
			EvolveGUI.Side.Evolve.ButtonKeybind.Visible = true
		else
			EvolveGUI.Side.Evolve.ButtonKeybind.Visible = false
		end
		
		if hasSelected then
			EvolveGUI.Side.LeftNotice2.Text = "Selected " .. #SelectedPets .. "/" .. 5 .. " Pets"
		end
	end)()
end

function PetsUpdate()
	(function()
		for _, child in ipairs(EvolveGUI.LeftHolder:GetChildren()) do
			if child.ClassName == "TextButton" then
				local locked = child:GetAttribute("Locked")
				
				if child:GetAttribute("DirId") then
					local search = _L.Functions.SearchArray(SelectedPets, child.Name)
					
					child.Equipped.Visible = search
					child.BackgroundColor3 = search and Color3.fromRGB(69, 239, 69) or Color3.fromRGB(39, 233, 55)
					
					if not locked then
						child.BackgroundColor3 = search and Color3.fromRGB(69, 239, 69) or Color3.fromRGB(39, 233, 55)
						child.PetIcon.ImageTransparency = 0
					end
				end
			end		
		end
	end)()
	
	ScalePets()
end

function LootUpdate()
	local data = GetData()
	if not data then
		Clear()
		return
	end
	
	local computed = _L.Shared.ComputeEvolveMachinePets(data)
	if not computed then
		Clear()
		return
	end
	
	local function GetLayoutOrder(name)
		local order = 1
		local pet = computed[name]
		
		for i, v in pairs(computed) do
			if i ~= name then
				if pet < v then
					order = order + 1
				end
			end		
		end
		
		return order
	end
	
	(function()
		for _, child in ipairs(EvolveGUI.RightHolder:GetChildren()) do
			if child.ClassName == "Frame" then
				local childName = child.Name
				
				if not (#SelectedPets < 5) then
					if not computed[childName] then
						if not child:GetAttribute("Template") then
							child:Destroy()
						end
					else
						child.LootRange.Subtitle.Text = computed[childName] .. "% Chance"
						child.LayoutOrder = GetLayoutOrder(childName)
					end
				elseif not child:GetAttribute("Template") then
					child:Destroy()
				end
			end		
		end
		
		if #SelectedPets == 5 then
			for i, v in pairs(computed) do
				local dir = _L.Directory.Pets[i]
				
				if not EvolveGUI.RightHolder:FindFirstChild(i) then
					local loot = EvolveGUI.RightHolder:FindFirstChild("Loot"):Clone()
					loot.NonPet.Icon.Image = dir.thumbnail
					loot.LootRange.Title.Text = dir.name
					loot.LootRange.Subtitle.Text = computed[i] .. "% Chance"
					loot.LayoutOrder = GetLayoutOrder(i)
					loot.Name = i
					loot:SetAttribute("Template", false)
					loot.Visible = true
					loot.Parent = EvolveGUI.RightHolder
				end			
			end
		end
	end)()
	
	ScaleLoot()
end

function Evolve()
	if 0 < #DeepSelectedPets then
		_L.Variables.UsingMachine = true
		EvolveGUI.Gui.Enabled = false
		EvolveInSession = true
		
		local success, response = _L.Network.Invoke("Attempt Use Evolve Machine", DeepSelectedPets)
		if not success then
			_L.Message.New(response or "error")
			EvolveInSession = false
		else
			task.delay(15, function()
				EvolveInSession = false
			end)
		end
		
		_L.Variables.UsingMachine = false
	end
end

function GetRainbowChance()
	local chance = 0
	local data = GetData()
	if not data then
		return chance
	end
	
	for _, pet in ipairs(data) do
		if pet.r then
			chance = chance + 20
		end	
	end
	
	if chance ~= 0 then
		return chance
	end
	
	return 2
end

function GetShinyChance()
	local chance = 0
	local data = GetData()
	if not data then
		return chance
	end
	
	for _, pet in ipairs(data) do
		if pet.sh then
			chance = chance + 20
		end	
	end
	
	if chance ~= 0 then
		return chance
	end
	return 2
end

function GetData()
	local pets = {}
	
	for _, uid in ipairs(SelectedPets) do
		local pet = _L.PetCmds.Get(uid)
		if not pet then
			return nil
		end
		
		table.insert(pets, pet)	
	end
	
	return pets
end

function Setup()
	local save = _L.Save.Get()
	if not save then
		return
	end
	assert(save)
	
	local qualifyingPets = {}
	for _, pet in ipairs(save.Pets) do
		local dir = _L.Directory.Pets[pet.id]
		if dir then
			assert(dir)
			if dir.evolve then
				table.insert(qualifyingPets, pet)
			end
		end	
	end
	
	table.sort(qualifyingPets, function(i, v)
		return _L.Shared.PetOrderBest(i, v) < 0
	end)
	
	EvolveGUI.Divider.Visible = 0 < #qualifyingPets
	EvolveGUI.LeftHolder.Visible = 0 < #qualifyingPets
	EvolveGUI.RightHolder.Visible = 0 < #qualifyingPets
	EvolveGUI.NoPets.Visible = #qualifyingPets == 0
	
	for index, pet in ipairs(qualifyingPets) do
		local uid = pet.uid
		local petFrame = _L.Assets.UI.Inventory.Pet:Clone()
		_L.PetUI.Create(petFrame, uid)
		local dir = _L.Directory.Pets[pet.id]
		
		petFrame.Stars.Visible = false
		petFrame.LayoutOrder = index
		petFrame:SetAttribute("DirId", pet.id)
		petFrame.Parent = EvolveGUI.LeftHolder
		petFrame.Activated:Connect(function()
			if not debounce then
				debounce = true
				local locked = _L.Signal.Invoke("Is Trading Booth Pet", uid)
				
				if pet.l then
					_L.Message.New("This pet is locked! Unlock it before you can use it in the Evolve Machine!")
				elseif locked then
					_L.Message.New("This pet is currently in your trading booth! Remove it before you can use it in the Evolve Machine!")
				elseif not _L.Functions.SearchArray(SelectedPets, uid) then
					PetsSelect(uid)
				else
					PetsDeselect(uid)
				end
				
				debounce = false
			end
		end)
		
		_L.GUIFX.ButtonFX(petFrame)	
	end
	Update()
end

function ScalePets()
	local LeftHolder = EvolveGUI.Pets.LeftHolder
	local UIGridLayout = LeftHolder:FindFirstChildOfClass("UIGridLayout")
	local UIPadding = LeftHolder:FindFirstChildOfClass("UIPadding")
	local ResolutionScale = _L.Functions.ResolutionScale()
	local com = (LeftHolder.AbsoluteSize.X - LeftHolder.ScrollBarThickness - UIPadding.PaddingLeft.Offset - UIPadding.PaddingRight.Offset) / 3 - UIGridLayout.CellPadding.X.Offset
	
	UIGridLayout.CellSize = UDim2.new(0, com, 0, com)
	UIGridLayout:ApplyLayout()
	LeftHolder.CanvasSize = UDim2.new(0, UIGridLayout.AbsoluteContentSize.X, 0, UIGridLayout.AbsoluteContentSize.Y + 30)
end

function ScaleLoot()
	local RightHolder = EvolveGUI.RightHolder
	local UIListLayout = RightHolder:FindFirstChildOfClass("UIListLayout")
	local UIPadding = RightHolder:FindFirstChildOfClass("UIPadding")
	
	UIListLayout:ApplyLayout()
	RightHolder.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + UIPadding.PaddingBottom.Offset + UIPadding.PaddingTop.Offset)
end

function Clear()
	SelectedPets = {}
	
	for _, child in ipairs(EvolveGUI.LeftHolder:GetChildren()) do
		if child.ClassName == "TextButton" then
			if child.Name ~= "Template" then
				child:Destroy()
			end
		end	
	end
	
	for _, child in ipairs(EvolveGUI.RightHolder:GetChildren()) do
		if child.ClassName == "Frame" then
			if not child:GetAttribute("Template") then
				child:Destroy()
			end
		end	
	end
end

EvolveGUI.Side.Evolve.Activated:Connect(function()
	if not (#SelectedPets >= 5) then
		return
	end
	
	if not debounce then
		debounce = true
		
		DeepSelectedPets = _L.Functions.DeepCopyUnsafe(SelectedPets)
		if _L.Message.New("Are you sure you want to evolve these pets? You will lose the selected pets!", true) then
			Evolve()
		end
		
		debounce = false
	end
end)

EvolveGUI.Close.Activated:Connect(function()
	if not debounce then
		debounce = true
		
		EvolveGUI.Gui.Enabled = false
		
		debounce = false
	end
end)

_L.GUIFX.ButtonFX(EvolveGUI.Close)
_L.GUIFX.ButtonFX(EvolveGUI.Side.Evolve)

_L.Signal.Fired("Window Closed"):Connect(function(GUI)
	if EvolveInSession then
		return
	end
	
	if GUI == EvolveGUI.Gui then
		Clear()
	end
end)

_L.Signal.Fired("Window Opened"):Connect(function(GUI)
	if GUI == EvolveGUI.Gui then
		if EvolveInSession then
			EvolveGUI.Gui.Enabled = false
			return
		end
		
		local save = _L.Save.Get()
		if not save then
			return
		end
		assert(save)
		
		if not save.OwnsHugeMachine then
			_L.Message.New("You don't own this machine! Buy it in the Town area!")
			return
		end
		
		Clear()
		Setup() 
		
		if EvolveGUI.Gui.Enabled and _L.Variables.Console then
			_L.GuiService.SelectedObject = _L.LocalPlayer.PlayerGui:FindFirstChild("EvolvePets"):FindFirstChild("Frame"):FindFirstChild("Pets"):FindFirstChild("LeftHolder")
		end
	end
end)

_L.Signal.Fired("Resolution Changed"):Connect(function()
	if EvolveGUI.Gui.Enabled then
		task.defer(function()
			ScalePets()
			ScaleLoot()
		end)
	end
end)

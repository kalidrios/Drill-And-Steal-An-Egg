-- @pggondim | pggondim
local v_u_1 = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"))
while not v_u_1.Loaded do
	game:GetService("RunService").Heartbeat:Wait()
end
require(game.ReplicatedStorage.Library.Modules.Pets)
require(game.ReplicatedStorage.Library.Modules.DefaultStats)
require(game.ReplicatedStorage.Library.Modules.Pets)
local v_u_2 = require(script.Riding)
local v_u_3 = Random.new()
local v_u_4 = v_u_1.Shared.IsHardcore
require(script.Common)
local v_u_5 = {}
local v_u_6 = 0
local v_u_7 = false
local v_u_8 = nil
local v_u_9 = nil
local v_u_10 = nil
local v_u_11 = nil
local v_u_12 = 0
local v_u_13 = {}
local v_u_14 = { 1.9, 4.7, 16 }
local v_u_15 = { 2.6, 7.4, 22.3 }
local PET_DISTANCE = { 4, 6, 22 }  -- Distance for Normal, Huge, Titanic (Huge reduced)

-- Fibonacci function for row sizing
local function Fibonacci(n)
	if n <= 1 then return n end
	local a, b = 0, 1
	for _ = 2, n do
		a, b = b, a + b
	end
	return b
end

local v_u_16 = table.create(#v_u_14, 0)
local v_u_17 = table.create(#v_u_15, 0)
v_u_16[1] = 0.5 + v_u_14[1] * 1.2
v_u_17[1] = 0.5 + v_u_15[1] * 1.2
v_u_16[2] = 0.5 + v_u_14[2] * 1.2
v_u_17[2] = 0.5 + v_u_15[2] * 1.2
v_u_16[3] = 0.5 + v_u_14[3] * 1.2
v_u_17[3] = 0.5 + v_u_15[3] * 1.2
local function v_u_29(p18, p19, p20)
	-- upvalues: (copy) v_u_1, (ref) v_u_12, (copy) v_u_5
	debug.profilebegin("Pets.Create (pt1)")
	local v21, _ = v_u_1.PetCmds.GetFrom(p18, p19, p20)
	if v21 then
		assert(v21)
		local v22 = v_u_1.Directory.Pets[v21.id]
		if v22 then
			assert(v22)
			local v23 = p18.Character
			if v23 then
				assert(v23)
				local v24 = v23.PrimaryPart
				if v24 then
					assert(v24)
					local v25 = v23:FindFirstChildOfClass("Humanoid")
					if v25 then
						assert(v25)
						local v26 = v_u_1.PetCmds.Spawn(v21, p18)
						local v27 = v26.part
						v27.CFrame = v24.CFrame * CFrame.new(0, 0, -5) - Vector3.new(0, v25.HipHeight / 2, 0)
						if p18 == v_u_1.LocalPlayer and v22.titanic then
							local v28 = Instance.new("ClickDetector")
							v28.MaxActivationDistance = math.huge
							v28.CursorIcon = "rbxassetid://11901225868"
							v28.Parent = v27
							if not v_u_1.Settings.MountingTitanicsEnabled then
								v27.CanQuery = false
							end
						end
						v27.Parent = v_u_1.Things.Pets
						v_u_5[p20] = {
							["row"] = 0, 
							["rowPlace"] = 0, 
							["rowTotal"] = 0, 
							["moving"] = false, 
							["farming"] = false, 
							["arrived"] = false, 
							["playerDistCheckTick"] = 0, 
							["targetuid"] = 0, 
							["spawnTick"] = v_u_12, 
							["movingTick"] = 0, 
							["animationTick"] = 0, 
							["spawned"] = v26, 
							["petData"] = v21,
							["idleTime"] = 0
						}
						debug.profileend()
						if p18 == v_u_1.LocalPlayer then
							v_u_1.Signal.Fire("Added Client Pet", p20)
						end
					else
						debug.profileend()
					end
				else
					debug.profileend()
					return
				end
			else
				debug.profileend()
				return
			end
		else
			debug.profileend()
			return
		end
	else
		debug.profileend()
		return
	end
end
local function v_u_35(p_u_30)
	-- upvalues: (copy) v_u_5, (copy) v_u_2, (copy) v_u_1, (ref) v_u_6, (ref) v_u_7
	debug.profilebegin("Pets.Remove")
	local v31 = v_u_5[p_u_30]
	if v31 then
		assert(v31)
		local v32 = v_u_2.getLocal()
		if v32 and v32.petInfo == v31 then
			v_u_2.stopRidingLocal()
		end
		local v33 = v31.spawned.part
		if v33 then
			v_u_1.Functions.AddDebris(v33, 0)
		end
		local v34 = v31.spawned.coinSelection
		if v34 then
			v31.spawned.coinSelection = nil
			destroyCoinSelection(v34)
		end
		if 0 < v_u_6 and not v_u_7 then
			v_u_7 = true
			warn(string.format("PetWhileIterating: %s", debug.traceback()))
		end
		v_u_5[p_u_30] = nil
		if v31.spawned.owner == v_u_1.LocalPlayer then
			task.spawn(function()
				-- upvalues: (ref) v_u_1, (copy) p_u_30
				v_u_1.Signal.Fire("Removed Client Pet", p_u_30)
			end)
		end
		debug.profileend()
	else
		debug.profileend()
	end
end
local function v_u_39()
	-- upvalues: (ref) v_u_6, (copy) v_u_5, (copy) v_u_35
	debug.profilebegin("Pets.Clear")
	local v36 = {}
	v_u_6 = v_u_6 + 1
	for v37, _ in pairs(v_u_5) do
		table.insert(v36, v37)
	end
	v_u_6 = v_u_6 - 1
	for _, v38 in ipairs(v36) do
		v_u_35(v38)
	end
	debug.profileend()
end
function _insert(p40, p41, p42)
	if #p40 < p42 then
		table.insert(p40, p41)
	else
		p40[p42] = p41
	end
end
function _trim(p43, p44)
	for v45 = #p43, p44 + 1, -1 do
		table.remove(p43, v45)
	end
end
local v_u_46 = {}
local v_u_47 = {}
function destroyCoinSelection(p48)
	-- upvalues: (copy) v_u_1
	v_u_1.Functions.AddDebris(p48.dottedLine)
	v_u_1.Functions.AddDebris(p48.selection1)
	v_u_1.Functions.AddDebris(p48.selection2)
end
local function v_u_102()
	-- upvalues: (copy) v_u_1, (ref) v_u_8, (copy) v_u_4, (copy) v_u_5, (copy) v_u_29, (ref) v_u_6, (copy) v_u_35, (ref) v_u_9, (copy) v_u_2, (copy) v_u_13, (copy) v_u_14
	debug.profilebegin("Pets.Check")
	local v49 = v_u_1.Save.Get()
	if v49 then
		assert(v49)
		if not v_u_8 or 0.2 <= os.clock() - v_u_8 then
			debug.profilebegin("Pets.Check.pt1")
			local v50 = v49.Settings.ShowOtherPets == 2
			local v51 = v_u_1.WorldCmds.Get()
			for _, v52 in ipairs(game.Players:GetPlayers()) do
				local v53 = ((not v50 or v52 == v_u_1.LocalPlayer) and true or false) and v_u_1.Save.Get(v52, true)
				if v53 then
					assert(v53)
					if v52 == v_u_1.LocalPlayer or (v_u_4 and v53.Hardcore.World or v53.World) == v51 then
						for _, v54 in ipairs((v_u_1.PetCmds.GetEquipped(v52, true))) do
							if not v_u_5[v54] then
								v_u_29(v52, v53, v54)
							end
						end
					end
				end
			end
			v_u_8 = os.clock()
			debug.profileend()
		end
		debug.profilebegin("Pets.Check.pt2")
		v_u_6 = v_u_6 + 1
		local v55 = {}
		local v_u_56 = {}
		for _, v57 in pairs(v_u_5) do
			local v58 = v57.spawned.uid
			local v59, v60 = v_u_1.PetCmds.Get(v58)
			local v61
			if v59 then
				v_u_56[v58] = v59
				local v62 = v_u_1.Save.Get(v60)
				v61 = v62 and v_u_1.Shared.HasPetEquipped(v62, v59) or false
			else
				v61 = false
			end
			if not (v59 and v61 and v60) then
				table.insert(v55, v58)
			end
		end
		v_u_6 = v_u_6 - 1
		for _, v63 in ipairs(v55) do
			v_u_35(v63)
		end
		debug.profileend()
		if not v_u_9 or 0.2 < os.clock() - v_u_9 then
			debug.profilebegin("Pets.Check.pt3")
			local v64 = v_u_1.WorldCmds.Get()
			v_u_6 = v_u_6 + 1
			for _, v65 in pairs(v_u_5) do
				local v66 = v65.spawned.uid
				local v67 = v65.spawned.owner
				if v67 ~= v_u_1.LocalPlayer then
					local v68 = v_u_1.Save.Get(v67, true)
					if not v68 or (v_u_4 and v68.Hardcore.World or v68.World) ~= v64 then
						table.insert(v55, v66)
					end
				end
			end
			v_u_6 = v_u_6 - 1
			for _, v69 in ipairs(v55) do
				v_u_35(v69)
			end
			v_u_9 = os.clock()
			debug.profileend()
		end
		debug.profilebegin("Pets.Check.pt4")
		for _, v70 in pairs(v_u_5) do
			local v71 = v70.target
			local _ = v70.spawned.part
			if v70.farming and (v71 == nil or v71.Parent == nil) then
				v70.farming = false
			end
		end
		debug.profileend()
		local v72 = {}
		debug.profilebegin("Pets.Check.pt5")
		for _, v73 in pairs(v_u_5) do
			local v74 = v73.spawned.uid
			local v75 = v73.spawned.owner
			local v76 = v73.target
			v73.petData = v_u_56[v74]
			if v76 == nil or v76.Parent == nil then
				v73.target = v75
				v76 = v75
			end
			if v76 == v75 and not v_u_2.isRiding(v73, v_u_56[v74]) then
				if not v72[v75] then
					v72[v75] = {
						["organized"] = {
							{}
						}, 
						["list"] = {}
					}
				end
				table.insert(v72[v75].list, v74)
				v72[v75].dirty = true
			else
				v73.row = 0
				v73.rowPlace = 0
				v73.rowTotal = 0
			end
		end
		debug.profileend()
		debug.profilebegin("Pets.Check.pt6")
		for _, v77 in pairs(v72) do
			table.sort(v77.list, function(p78, p79)
				-- upvalues: (copy) v_u_56, (ref) v_u_1
				local v80 = v_u_56[p78]
				local v81 = v_u_56[p79]
				if v80 then
					return not v81 and true or v_u_1.Shared.PetOrderParty(v80, v81) < 0
				else
					return false
				end
			end)
		end
		debug.profileend()
		debug.profilebegin("Pets.Check.pt7-2")
		for v82, v83 in pairs(v72) do
			local v84 = v83.list
			local v85 = v_u_13[v82]
			if not v85 then
				v85 = {
					["displayNumTotals"] = table.create(#v_u_14, 0), 
					["displayNumColumns"] = table.create(#v_u_14, 0), 
					["displayNumRows"] = table.create(#v_u_14, 0)
				}
				v_u_13[v82] = v85
			end
			local v86 = {
				{}, 
				{}, 
				{}
			}
			for _, v87 in ipairs(v84) do
				local v88 = v_u_1.Directory.Pets[v_u_5[v87].spawned.id]
				table.insert(v86[v88.titanic and 3 or v88.huge and 2 or 1], v87)
			end
			
			-- PS99-style: Calculate rows using Fibonacci for Normal pets
			local v90 = { "normalPlace", "hugePlace", "titanicPlace" }
			
			-- NORMAL PETS: Use expanding rows (5, 8, 13, 21...)
			local normalPets = v86[1]
			local normalRows = {}
			local currentRow = {}
			local rowIndex = 0
			local rowSize = 5 -- Start with 5 pets per row
			
			for i, petId in ipairs(normalPets) do
				table.insert(currentRow, petId)
				if #currentRow >= rowSize or i == #normalPets then
					table.insert(normalRows, currentRow)
					rowIndex = rowIndex + 1
					-- Fibonacci-like growth: next row size = previous + some offset
					rowSize = 5 + (rowIndex > 0 and Fibonacci(rowIndex + 3) or 0)
					currentRow = {}
				end
			end
			
			v85.displayNumTotals[1] = #normalPets
			v85.displayNumRows[1] = #normalRows
			v85.displayNumColumns[1] = #normalRows > 0 and #normalRows[1] or 0
			
			for rowNum, row in ipairs(normalRows) do
				for colNum, petId in ipairs(row) do
					local petData = v_u_5[petId]
					petData.row = rowNum
					petData.rowPlace = colNum
					petData.rowTotal = #row
					petData[v90[1]] = (rowNum - 1) * 10 + colNum
				end
			end
			
			-- HUGE PETS: Smart balanced distribution
			local hugePets = v86[2]
			local hugeRows = {}
			local totalHuge = #hugePets
			
			-- Calculate optimal row sizes based on total count
			local rowSizes = {}
			if totalHuge <= 3 then
				rowSizes = {totalHuge}  -- 1-3: single row
			elseif totalHuge == 4 then
				rowSizes = {2, 2}  -- 4: 2+2
			elseif totalHuge == 5 then
				rowSizes = {3, 2}  -- 5: 3+2 (center first row)
			elseif totalHuge == 6 then
				rowSizes = {3, 3}  -- 6: 3+3
			elseif totalHuge == 7 then
				rowSizes = {3, 4}  -- 7: 3+4
			elseif totalHuge == 8 then
				rowSizes = {4, 4}  -- 8: 4+4
			else
				-- 9+: Fill middle first, then spread to sides
				-- Aim for balanced rows with slightly more in front
				local numRows = math.ceil(totalHuge / 5)  -- Max ~5 per row
				local basePerRow = math.floor(totalHuge / numRows)
				local remainder = totalHuge % numRows
				
				for r = 1, numRows do
					-- Add 1 extra to earlier rows if remainder exists
					local size = basePerRow + (r <= remainder and 1 or 0)
					table.insert(rowSizes, size)
				end
			end
			
			-- Distribute pets to rows
			local petIndex = 1
			for rowNum, size in ipairs(rowSizes) do
				local row = {}
				for col = 1, size do
					if petIndex <= totalHuge then
						table.insert(row, hugePets[petIndex])
						petIndex = petIndex + 1
					end
				end
				if #row > 0 then
					table.insert(hugeRows, row)
				end
			end
			
			v85.displayNumTotals[2] = totalHuge
			v85.displayNumRows[2] = #hugeRows
			v85.displayNumColumns[2] = #hugeRows > 0 and #hugeRows[1] or 0
			
			for rowNum, row in ipairs(hugeRows) do
				for colNum, petId in ipairs(row) do
					local petData = v_u_5[petId]
					petData.row = rowNum
					petData.rowPlace = colNum
					petData.rowTotal = #row
					petData[v90[2]] = (rowNum - 1) * 10 + colNum
				end
			end
			
			-- TITANIC PETS: Max 3 per row (straight line)
			local titanicPets = v86[3]
			local titanicRows = {}
			currentRow = {}
			
			for i, petId in ipairs(titanicPets) do
				table.insert(currentRow, petId)
				if #currentRow >= 3 or i == #titanicPets then
					table.insert(titanicRows, currentRow)
					currentRow = {}
				end
			end
			
			v85.displayNumTotals[3] = #titanicPets
			v85.displayNumRows[3] = #titanicRows
			v85.displayNumColumns[3] = #titanicRows > 0 and #titanicRows[1] or 0
			
			for rowNum, row in ipairs(titanicRows) do
				for colNum, petId in ipairs(row) do
					local petData = v_u_5[petId]
					petData.row = rowNum
					petData.rowPlace = colNum
					petData.rowTotal = #row
					petData[v90[3]] = (rowNum - 1) * 10 + colNum
				end
			end
		end
		debug.profileend()
	else
		debug.profileend()
	end
end
function ChangePetTargetPlayer(p103)
	-- upvalues: (copy) v_u_1, (copy) v_u_5
	debug.profilebegin("Pets.ChangePetTargetPlayer")
	if p103 then
		local v104, v105 = v_u_1.PetCmds.Get(p103)
		local v106 = v104 and v105 and v105 ~= v_u_1.LocalPlayer and v_u_5[p103]
		if v106 then
			v106.target = v106.spawned.owner
			v106.farming = false
		end
		debug.profileend()
	else
		debug.profileend()
	end
end
function ChangePetTargetCoin(p107, p108)
	-- upvalues: (copy) v_u_1, (copy) v_u_5
	debug.profilebegin("Pets.ChangePetTargetCoin")
	if p107 and p108 then
		local v109, v110 = v_u_1.PetCmds.Get(p107)
		if v109 and v110 and v110 ~= v_u_1.LocalPlayer then
			local v111 = v_u_5[p107]
			local v112 = v_u_1.Things.Coins:FindFirstChild(p108)
			if v111 and v112 then
				v111.target = v112:FindFirstChild("POS")
				v111.farming = true
			end
		end
		debug.profileend()
	else
		debug.profileend()
	end
end
function NetworkUpdate()
	-- upvalues: (copy) v_u_5, (copy) v_u_1, (ref) v_u_10
	
	for _, v113 in pairs(v_u_5) do
		local v114 = v113.spawned.uid
		local v115 = v113.spawned.owner
		local v116 = v113.target
		local v117 = v113.farming
		if v115 == v_u_1.LocalPlayer and v116 ~= v113.networkTarget then
			v113.networkTarget = v116
			if v117 then
				local v118 = v116.Parent:GetAttribute("ID")
				if v118 then
					v_u_1.Network.Fire("Change Pet Target", v114, "Coin", v118)
				end
			elseif v116 == v115 then
				v_u_1.Network.Fire("Change Pet Target", v114, "Player")
			end
		end
	end
	if not v_u_10 or 1.5 < os.clock() - v_u_10 then
		v_u_10 = os.clock()
		task.spawn(function()
			-- upvalues: (ref) v_u_1, (ref) v_u_5
			local v119 = v_u_1.Network.Invoke("Get Coin Targets")
			if v119 then
				
				for v120, v121 in pairs(v119) do
					local v122 = v121.t
					local v123 = v121.id
					if v_u_5[v120] then
						if v122 == "Coin" then
							ChangePetTargetCoin(v120, v123)
						elseif v122 == "Player" then
							ChangePetTargetPlayer(v120)
						end
					end
				end
				
			else
				v_u_1.Print("Failed to get targets of other players")
			end
		end)
	end
end
local function v_u_166(p124, p125, p_u_126)
	-- upvalues: (copy) v_u_1, (ref) v_u_6, (copy) v_u_2, (copy) v_u_5, (copy) v_u_3
	local v127 = v_u_1.Save.Get()
	if v127 then
		assert(v127)
		if p124 then
			if p125 == nil then
				p125 = v127.Settings.PetsControl == 2
			end
			local v_u_128 = p124:FindFirstChild("POS")
			local v_u_129 = p124:GetAttribute("ID")
			local _ = v_u_1.Directory.Coins[p124:GetAttribute("Name")]
			local function v138(p130)
				-- upvalues: (ref) v_u_6, (ref) v_u_2, (ref) v_u_5, (ref) v_u_1, (copy) v_u_128
				local v131 = nil
				local v132 = nil
				local v133 = nil
				v_u_6 = v_u_6 + 1
				local v134 = v_u_2.getLocal()
				for v135, v136 in pairs(v_u_5) do
					if v136.spawned.owner == v_u_1.LocalPlayer then
						local v137 = (v_u_128.CFrame.Position - v136.spawned.part.CFrame.Position).Magnitude
						if v134 then
							if v134.petInfo.petData.uid == v135 then
								v137 = v137 + 99999999
							end
						end
						if not v131 or v137 < v132 then
							if p130 and p130(v135, v136) then
								v133 = v136
								v132 = v137
								v131 = v135
							elseif not p130 then
								v133 = v136
								v132 = v137
								v131 = v135
							end
						end
					end
				end
				v_u_6 = v_u_6 - 1
				return v131, v133
			end
			local v139 = {}
			local v140 = {}
			if p125 then
				v_u_6 = v_u_6 + 1
				for v141, v142 in pairs(v_u_5) do
					if v142.spawned.owner == v_u_1.LocalPlayer then
						table.insert(v139, v141)
					end
				end
				v_u_6 = v_u_6 - 1
			else
				local v145, _ = v138(function(p143, p144)
					-- upvalues: (copy) p_u_126
					if p_u_126 and p_u_126[p143] ~= true then
						return false
					else
						return not p144.farming
					end
				end)
				if v145 then
					table.insert(v139, v145)
				else
					local v149, _ = v138(function(p146, p147)
						-- upvalues: (copy) p_u_126, (copy) v_u_128
						if p_u_126 and p_u_126[p146] ~= true then
							return false
						end
						local v148 = p147.farming
						if v148 then
							v148 = p147.target ~= v_u_128
						end
						return v148
					end)
					if v149 then
						table.insert(v139, v149)
					else
						local v153, _ = v138(function(p150, p151)
							-- upvalues: (copy) p_u_126, (copy) v_u_128
							if p_u_126 and p_u_126[p150] ~= true then
								return false
							end
							local v152 = p151.farming
							if v152 then
								v152 = p151.target == v_u_128
							end
							return v152
						end)
						if v153 then
							local v154 = {}
							v_u_6 = v_u_6 + 1
							for v155, v156 in pairs(v_u_5) do
								if v156.spawned.owner == v_u_1.LocalPlayer and v156.farming and v156.target == v_u_128 then
									table.insert(v154, v155)
								end
							end
							v_u_6 = v_u_6 - 1
							if 0 < #v154 then
								v140 = v154
							end
						end
					end
				end
			end
			--print(#v139)
			if 0 < #v139 then
				--print('a')
				local v157 = false
				local v158 = false
				for v_u_159, v_u_160 in pairs((v_u_1.Network.Invoke("Join Coin", v_u_129, v139))) do
					--print(v_u_159, v_u_160)
					if v_u_160 == true then
						--print('A')
						v158 = true
						local v_u_161 = v_u_5[v_u_159]
						--print(v_u_5)
						if v_u_161 then
						--	print('ok')
							if v_u_161.selectionFx then
								v_u_161.selectionFx()
								v_u_161.selectionFx = nil
							end
							v_u_161.farming = true
							v_u_161.target = v_u_128
							v_u_161.arrived = false
							v_u_161.targetuid = v_u_161.targetuid + 1
							v_u_161.randomRotation = v_u_3:NextNumber(0, 360)
							local v_u_162 = v_u_161.targetuid
							function v_u_161.onArrive()
								-- upvalues: (ref) v_u_5, (copy) v_u_159, (copy) v_u_161, (copy) v_u_128, (copy) v_u_162, (ref) v_u_1, (copy) v_u_129
								if v_u_5[v_u_159] and v_u_161.farming and v_u_161.target == v_u_128 and v_u_162 == v_u_161.targetuid then
									--print('ffffff')
									v_u_1.Network.Fire("Farm Coin", v_u_129, v_u_159)
								end
							end
						end
					elseif typeof(v_u_160) == "string" then
						if not v157 then
							task.spawn(function()
								-- upvalues: (ref) v_u_1, (copy) v_u_160
								v_u_1.Message.New(v_u_160)
							end)
							v157 = true
						end
					end
				end
				if v158 then
					v_u_1.Audio.Play("rbxassetid://7004964432", script)
				end
			end
			if 0 < #v140 then
				for v163, v164 in pairs((v_u_1.Network.Invoke("Leave Coin", v_u_129, v140))) do
					if v164 then
						local v165 = v_u_5[v163]
						if v165 then
							if v165.selectionFx then
								v165.selectionFx()
								v165.selectionFx = nil
							end
							v165.farming = false
							v165.target = nil
						end
					else
						v_u_1.Print("Pet failed to leave coin -- " .. v163)
					end
				end
			end
		else

		end
	else
		return
	end
end
coroutine.wrap(function()
	-- upvalues: (copy) v_u_1, (copy) v_u_5, (copy) v_u_2
	wait(1)
	if not v_u_1.Variables.Mobile then
		local v_u_167 = v_u_1.Player.Mouse()
		local v_u_168 = nil
		local v_u_169 = nil
		game:GetService("RunService").RenderStepped:Connect(function(_)
			-- upvalues: (copy) v_u_167, (ref) v_u_1, (ref) v_u_5, (ref) v_u_2, (ref) v_u_168, (ref) v_u_169
			debug.profilebegin("Pets.Mouse")
			local v170 = v_u_167.Target
			if v170 then
				if not v170:IsDescendantOf(v_u_1.Things.Pets) then
					v170 = nil
				end
			end
			local v171
			if v170 then
				v171 = v_u_5[v170.Name]
				local v172 = v_u_2.getLocal()
				if v172 then
					if v172.petInfo == v171 then
						v171 = nil
					end
				end
			else
				v171 = nil
			end
			if v_u_168 ~= v171 then
				v_u_168 = v171
				if v_u_169 then
					v_u_169()
					v_u_169 = nil
				end
				if v171 and v171.spawned.owner == v_u_1.LocalPlayer and v_u_1.Directory.Pets[v171.spawned.id].titanic then
					v_u_169 = v_u_1.WorldFX.QuestGlow(v171.spawned.part, 1, 0.66)
				end
			end
			debug.profileend()
		end)
	end
end)()
function UpdateRaycastParams()
	-- upvalues: (copy) v_u_1, (ref) v_u_11
	debug.profilebegin("Pets.UpdateRaycastParams")
	local v173 = {}
	for _, v174 in ipairs(v_u_1.WorldCmds.GetMap():GetChildren()) do
		if v174.Name ~= "Debris" and v174.Name ~= "PlayerSpawns" and v174.Name ~= "Teleports" and v174.Name ~= "Audio" then
			table.insert(v173, v174)
		end
	end
	local v175 = RaycastParams.new()
	v175.FilterDescendantsInstances = { v173 }
	v175.FilterType = Enum.RaycastFilterType.Whitelist
	v175.IgnoreWater = true
	v_u_11 = v175
	debug.profileend()
end
v_u_1.Signal.Fired("World Changed"):Connect(function()
	UpdateRaycastParams()
end)
function UpdatePetSoundsSetting()
	-- upvalues: (copy) v_u_1
	local v176 = v_u_1.Save.Get()
	if v176 then
		assert(v176)
		v_u_1.Variables.PetSoundsEnabled = v176.Settings.PetSFX == 1
	end
end
v_u_1.Signal.Fired("Stat Changed"):Connect(function(p177)
	-- upvalues: (copy) v_u_1, (copy) v_u_2
	if p177 == "Settings" then
		UpdatePetSoundsSetting()
	end
	if p177 == (v_u_1.Shared.IsHardcore and "HardcoreRidingPet" or "RidingPet") then
		v_u_2.petRidingLocal = nil
		v_u_2.hasPetRidingLocal = false
	end
end)
UpdatePetSoundsSetting()
v_u_1.Network.Fired("Pet Target Coin"):Connect(function(p178, p179)
	ChangePetTargetCoin(p178, p179)
end)
v_u_1.Network.Fired("Pet Target Player"):Connect(function(p180)
	ChangePetTargetPlayer(p180)
end)
v_u_1.Network.Fired("Player Teleported"):Connect(function(p181)
	-- upvalues: (copy) v_u_1, (copy) v_u_5, (copy) v_u_35
	debug.profilebegin("Pets.Player Teleported")
	local v182 = v_u_1.Save.Get(p181, true)
	if v182 and v182.Pets then
		assert(v182)
		for _, v183 in ipairs(v182.Pets) do
			local v184 = v183.uid
			local v185 = v_u_5[v184]
			if v_u_1.Shared.HasPetEquipped(v182, v183) and v185 and not v185.farming then
				v_u_35(v184)
			end
		end
		debug.profileend()
	else
		debug.profileend()
	end
end)
v_u_1.Signal.Fired("Select Coin"):Connect(function(p186)
	-- upvalues: (copy) v_u_166
	v_u_166(p186)
end)
v_u_1.Signal.Fired("Group Select Coin"):Connect(function(p187)
	-- upvalues: (copy) v_u_166
	v_u_166(p187, true)
end)
v_u_1.Signal.Fired("Select Pet"):Connect(function(p188, _)
	-- upvalues: (copy) v_u_5, (copy) v_u_1, (copy) v_u_2
	local v189 = v_u_5[p188.Name]
	if v189 and v189.spawned.owner == v_u_1.LocalPlayer and v_u_1.Directory.Pets[v189.spawned.id].titanic then
		if v_u_2.petRidingLocal == v189.spawned.uid and not v_u_1.Variables.UsingHoverboard and v189.target == v189.spawned.owner then
			v_u_2.petRidingLocal = nil
			v_u_2.destroyByPlayer(v189.spawned.owner)
		else
			v_u_2.petRidingLocal = v189.spawned.uid
			v_u_1.Signal.Fire("Stop Using Hoverboard")
			v189.target = v189.spawned.owner
			v189.farming = false
			v189.target = nil
			if v189.selectionFx then
				v189.selectionFx()
				v189.selectionFx = nil
			end
		end
		v_u_2.hasPetRidingLocal = true
		v_u_1.Network.Fire("Set Riding Pet", v_u_2.petRidingLocal)
	end
end)
v_u_1.Network.Fired("Set Riding Pet"):Connect(function(p190, p191)
	-- upvalues: (copy) v_u_1
	local v192 = v_u_1.Save.Get(p190)
	if v192 then
		v192[v_u_1.Shared.IsHardcore and "HardcoreRidingPet" or "RidingPet"] = p191
	end
end)
v_u_1.Network.Fired("Select Coin"):Connect(function(p193, p194, p195)
	-- upvalues: (copy) v_u_1, (copy) v_u_166
	local v196 = v_u_1.Things:WaitForChild("Coins"):FindFirstChild(p193)
	if v196 then
		v_u_166(v196, p194, p195)
	end
end)
v_u_1.Signal.Fired("World Changed"):Connect(function()
	-- upvalues: (copy) v_u_39
	v_u_39()
end)
function Tick(p_u_197)
	-- upvalues: (ref) v_u_12, (copy) v_u_1, (ref) v_u_6, (copy) v_u_5, (copy) v_u_13, (copy) v_u_14, (copy) v_u_2, (copy) v_u_15, (copy) v_u_3, (copy) v_u_17, (copy) v_u_16, (ref) v_u_11, (copy) v_u_46, (copy) v_u_47, (copy) v_u_35
	debug.profilebegin("Pets.Tick")
	local v_u_198 = v_u_12 + p_u_197
	v_u_12 = v_u_198
	if v_u_1.WorldCmds.HasLoaded() then
		local v_u_199 = p_u_197 * 60
		local v_u_200 = v_u_1.Save.Get()
		assert(v_u_200)
		local v_u_201 = v_u_1.WorldCmds.Get()
		assert(v_u_201)
		local v_u_202 = 0
		local v203 = {}
		v_u_6 = v_u_6 + 1
		for _, v_u_204 in pairs(v_u_5) do
			local v205 = v_u_204.spawned.uid
			local v_u_206 = v_u_204.spawned.owner
			local v_u_207 = v_u_13[v_u_206]
			if not v_u_207 then
				v_u_207 = {
					["displayNumTotals"] = table.create(#v_u_14, 0), 
					["displayNumColumns"] = table.create(#v_u_14, 0), 
					["displayNumRows"] = table.create(#v_u_14, 0)
				}
				v_u_13[v_u_206] = v_u_207
			end
			local v_u_208 = v_u_204.petData
			local v337 = (function()
				-- upvalues: (copy) v_u_208, (copy) v_u_200, (copy) v_u_206, (ref) v_u_1, (copy) v_u_204, (ref) v_u_2, (copy) v_u_198, (copy) v_u_201, (ref) v_u_15, (ref) v_u_3, (ref) v_u_207, (ref) v_u_17, (ref) v_u_16, (ref) v_u_11, (copy) p_u_197, (copy) v_u_199, (ref) v_u_202, (ref) v_u_46, (ref) v_u_47
				debug.profilebegin("Pets.Tick.RenderPet")
				if v_u_208 then
					assert(v_u_208)
					if v_u_200.Settings.ShowOtherPets == 2 and v_u_206 ~= v_u_1.LocalPlayer then
						debug.profileend()
						return "critical"
					else
						local v209 = v_u_204.spawned.part
						local _ = v209.CFrame
						local v210 = v_u_204.spawned.id
						local v211 = v_u_1.Directory.Pets[v210]
						local v212 = v211.fly == true
						local _ = v_u_208.g == true
						local _ = v_u_208.r == true
						local _ = v_u_208.dm == true
						local _ = v_u_208.sh == true
						local _ = v_u_208.hc == true
						local v213 = v211.titanic and 3 or v211.huge and 2 or 1
						local v214 = v_u_204.target
						local v215 = v_u_204.farming
						local v216 = v214 == v_u_206
						if v216 then
							v214 = v214.Character
						end
						if v214 == nil or v214.Parent == nil then
							debug.profileend()
						else
							if v_u_206 == nil or v_u_206.Parent == nil then
								debug.profileend()
								return "critical"
							end
							if v209 == nil or v209.Parent == nil then
								debug.profileend()
								return "critical"
							end
							if not v214 or not v214:IsA("Model") or v214.PrimaryPart then
								local v217 = v_u_2.process(v_u_204, v_u_208)
								if v_u_206 == v_u_1.LocalPlayer and v211.titanic then
									v209.CanQuery = v_u_1.Settings.MountingTitanicsEnabled
								end
								if v216 and not v217 and 1 <= v_u_198 - v_u_204.playerDistCheckTick then
									if 200 <= v_u_206:DistanceFromCharacter(v209.CFrame.Position) then
										v209.CFrame = v214:GetPivot() * CFrame.new(0, 0, -5)
									else
										v_u_204.playerDistCheckTick = v_u_198
									end
								end
								local v218 = math.clamp(1 + (v_u_1.Shared.ComputePetStrength(v_u_208) / 100) ^ 0.4, 1, 7) * 0.25
								if v215 then
									v218 = v218 + (v_u_200.Upgrades["Pet Walkspeed"] or 0) * 0.2
								end
								local v219, v220 = v_u_1.Shared.HasPower(v_u_208, "Agility")
								if v219 then
									local v221 = v_u_1.Shared.GetPowerDir("Agility", v220)
									if v221 then
										v218 = v218 * v221.value
									end
								end
								local v222, _ = v_u_1.Shared.HasPower(v_u_208, "Royalty")
								if v222 then
									v218 = v218 * 1.5
								end
								local v223 = v_u_201 == "Void"
								if v223 then
									v218 = v218 * 0.4
								end
								if v216 then
									v218 = math.min(v218, 1) + math.sin(v_u_204.spawnTick) / 8
								end
								local v224 = v211.flySpeed or 1
								if v217 then
									local v225 = v_u_206.Character
									if v225 then
										local v226 = 1
										local v227 = 1
										local v228 = v225.PrimaryPart
										if v228 then
											local v229 = v228.AssemblyLinearVelocity
											v226 = v226 + (v229 * Vector3.new(1, 0, 1)).Magnitude
											v227 = v227 + math.abs(v229.Y)
										end
										local v230 = v225:FindFirstChildOfClass("Humanoid")
										local v231
										if v230 then
											v218 = v230.WalkSpeed
											v231 = v230.WalkSpeed
										else
											v231 = v218
										end
										v218 = v218 * v226
										local _ = v231 * v227
									end
								end
								if v214 then
									if v215 then
										if not v214:IsA("Model") then
											v214 = v214.Parent:FindFirstChild("Coin")
										end
									end
								end
								local v232 = CFrame.identity
								if v214 then
									if v214:IsA("Model") then
										v232 = v214:GetPivot()
									elseif v214:IsA("BasePart") then
										v232 = v214:GetPivot()
									end
								end
								local v233 = 0
								local v234 = 2.5 + v_u_15[v213] / 2 
								if #v_u_204.spawned.meshes > 0 then
									--v_u_204.spawned.mesh.Offset.Z
									v234 = v234 - v_u_204.spawned.meshes[1].Offset.Z
								end
								local v_u_235
								if v215 then
									local v236 = v214.Size
									local v237 = v232 * CFrame.new(0, -v236.Y / 2 + 0.01, 0)
									if not v_u_204.randomRotation then
										v_u_204.randomRotation = v_u_3:NextNumber(0, 360)
									end
									assert(v_u_204.randomRotation)
									local v238 = v237 * CFrame.Angles(0, math.rad(v_u_204.randomRotation), 0)
									local v239 = math.max(v236.X, v236.Z) / 2 * 1.1
									for v240 = 1, v213 do
										v234 = v234 + v_u_15[v240] * 0.333
									end
									v_u_235 = v238 * CFrame.new(v233, 0, v234 + math.max(4.5, v239))
								elseif v217 then
									v_u_235 = v217:computePetCFrame()
									v232 = v_u_235
								elseif v216 then
									if v_u_204.row == 0 or v_u_204.rowPlace == 0 or v_u_204.rowTotal == 0 then
										v_u_235 = v232
									else
										local baseDistance = PET_DISTANCE[v213]
										
										-- Add distance for previous tiers (reduced spacing)
										for i = 1, v213 - 1 do
											if 0 < v_u_207.displayNumTotals[i] then
												baseDistance = baseDistance + v_u_207.displayNumRows[i] * 3 -- Reduced from (4+i*2)
											end
										end
										baseDistance = baseDistance + (v_u_204.row - 1) * 3 -- Reduced from 4
										
										-- Check if player is riding a pet (and this pet isn't the one being ridden)
										if not v217 and v_u_2.get(v_u_206) then
											baseDistance = baseDistance + 12
										end

										if v213 == 3 then  -- TITANIC: Straight line formation
											local colOffset = v_u_204.rowPlace - 1 - math.floor(v_u_204.rowTotal / 2)
											if v_u_204.rowTotal % 2 == 0 then
												colOffset = colOffset + 0.5
											end
											local lateralOffset = 24 * colOffset 
											
											local behindPlayer = v232 * CFrame.new(0, 0, baseDistance)
											local baseAngle = math.atan2(behindPlayer.Z - v232.Z, behindPlayer.X - v232.X)
											
											local pos = v232.Position 
												+ Vector3.new(baseDistance * math.cos(baseAngle), 0, baseDistance * math.sin(baseAngle))
												+ Vector3.new(lateralOffset * math.cos(baseAngle + math.pi/2), 0, lateralOffset * math.sin(baseAngle + math.pi/2))
											v_u_235 = CFrame.new(pos)
										else  -- NORMAL/HUGE: Semicircle formation
									local SEMICIRCLE_ARC = 2.967 -- approx 170 degrees
									
									-- Increase lateral spacing multiplier for better separation
									local spacingMultiplier = v213 == 2 and 1.5 or 1.2  -- More spacing for Huge
									local angleSpacing = (SEMICIRCLE_ARC / (v_u_204.rowTotal + 1)) * spacingMultiplier
									
									local colOffset = v_u_204.rowPlace - 1 - math.floor(v_u_204.rowTotal / 2)
									if v_u_204.rowTotal % 2 == 0 then
										colOffset = colOffset + 0.5
									end
									
									-- GOLDEN RATIO STAGGER: Per-pet offset using global index
									-- This distributes each pet individually, not by row
									if v213 == 2 and v_u_204.hugePlace then  -- Huge pets only
										local GOLDEN_RATIO = 0.618033988749895
										local petOffset = (v_u_204.hugePlace * GOLDEN_RATIO) % 1  -- Each pet gets unique offset
										colOffset = colOffset + (petOffset - 0.5) * 0.3  -- Reduced intensity (0.3)
									end
									
									local angle = colOffset * angleSpacing
									
									local behindPlayer = v232 * CFrame.new(0, 0, baseDistance)
									local baseAngle = math.atan2(behindPlayer.Z - v232.Z, behindPlayer.X - v232.X) + angle
									
									local pos = v232.Position + Vector3.new(
										baseDistance * math.cos(baseAngle),
										0,
										baseDistance * math.sin(baseAngle)
									)
									v_u_235 = CFrame.new(pos)
								end
										
										v232 = v232 * CFrame.new(0, 0, 0)
									end
								else
									v_u_235 = v232
								end
								local function v250()
									-- upvalues: (ref) v_u_204, (ref) v_u_198, (ref) v_u_235, (ref) v_u_11
									debug.profilebegin("Pets.Tick.UpdatePetRaycast")
									local v246 = v_u_204.lastRaycast
									local v247
									if v_u_204.nextRaycastTime and v_u_198 < v_u_204.nextRaycastTime then
										v247 = v_u_204.lastRaycast
									else
										v_u_204.nextRaycastTime = v_u_198 + math.random() * 0.3 + 0.15
										local v248 = v_u_204.spawned.bottom.WorldCFrame.Position
										assert(v_u_11)
										local v249 = workspace:Raycast(v248 + Vector3.new(0, math.max(v_u_235.Y - v248.Y + 3, 0), 0), Vector3.new(0, -200, 0), v_u_11)
										if v249 then
											v247 = v249.Position
											local _ = v249.Normal
											if not v249.Instance then
												v247 = v246
											end
										else
											v247 = v246
										end
										v_u_204.lastRaycast = v247
									end
									debug.profileend()
									return v247
								end
								local v251 = v_u_235.Position
								if not v217 then
									if not v215 or not v_u_204.arrived or v_u_204.moving then
										v251 = v250() or v251
									end
								end
								local v252 = v_u_204.lastPositionLerp or CFrame.new(v_u_235.Position) - Vector3.new(0, v_u_235.Y, 0)
								local v253 = v_u_204.lastRotationLerp or CFrame.identity
								local v254 = v_u_204.lastRaycastLerp or CFrame.new(0, v251.Y, 0)
								local v255 = v_u_204.lastAnimationLerp or CFrame.identity
								local v256 = v_u_204.lastFarmingLerp or CFrame.identity
								local v257 = v_u_204.lastMountCFrame or CFrame.identity
								local v258 = CFrame.identity
								local v259 = v_u_204.spawned.mount
								if v259 then
									local v260 = v259.CFrame
									v258 = v260 - Vector3.new(0, v260.Y, 0)
								end
								v_u_204.lastMountCFrame = v258
								local v261 = v252 * v254 * v253
								local v262 = v_u_235
								local v263 = v262 + Vector3.new(0, v251.Y - v262.Y, 0)
								if v217 then
									v261 = v261 * v257
									v263 = v263 * v258
								end
								local v264 = math.max(0.001, (Vector2.new(v263.X, v263.Z) - Vector2.new(v261.X, v261.Z)).Magnitude)
								local v265 = math.max(0.001, (math.abs(v263.Y - v261.Y)))
								local v266 = 11
								if v223 then
									v266 = v266 * 0.4090909090909091
								end
								if v211.balloon then
									v266 = v266 * 0.5
								end
								if v211.jelly then
									v266 = v266 * 0.5
								end
								local v267 = false
								local v268 = v_u_204.movingTick
								local v269 = v_u_204.animationTick
								local v270 = 0.1 <= v264
								if v217 then
									if 0.1 <= v265 then
										v266 = v266 * 0.5
										v270 = true
										v267 = true
									end
								end
								if v270 then
									v_u_204.nextMovingCheck = v_u_198 + 0.2
								end
								if not v270 then
									if v_u_204.moving then
										v270 = v_u_198 < (v_u_204.nextMovingCheck or v_u_198) and true or v270
									end
								end
								if v270 ~= v_u_204.moving then
									v269 = 0
									v268 = 0
								end
								if v270 then
									v268 = v268 + p_u_197
									v269 = v269 + p_u_197 * v266
								end
								v_u_204.moving = v270
								v_u_204.movingTick = v268
								v_u_204.animationTick = v269
								--print(v264)
								local v271 = v264 < 1
								v_u_204.arrived = not v271 --/!??!?
								--local v272 = not v_u_204.arrived and v271 and v_u_204.onArrive
								if not v_u_204.arrived and v271 then
									--print('aaa')
									local t_onArrive = v_u_204.onArrive;
									if t_onArrive then
										v_u_204.onArrive = nil;
										t_onArrive();
									end
								end
								 
								local v273 = v252:Lerp(CFrame.new(v_u_235.X, 0, v_u_235.Z), (math.clamp(v_u_199 * 1 / v264 * v218, 0, 1)))
								local v274 = CFrame.new(0, v251.Y, 0)
								local v275
								if v217 then
									v275 = v254:Lerp(v274, (math.clamp(v_u_199 * 1 / v265 * v218, 0, 1)))
								else
									v275 = v254:Lerp(v274, (math.clamp(v_u_199 * 0.2, 0, 1)))
								end
								local _, v276, _ = v232:ToOrientation()
								if not v217 then
									local v277 = v273 * v275
									local v278 = Vector3.new(v277.X, 0, v277.Z)
									local v279 = Vector3.new(v232.X, 0, v232.Z)
									
									if v216 then -- Following player
										-- Get player's look direction
										local playerPart = v214.PrimaryPart
										if playerPart then
											local lookDir = Vector3.new(playerPart.CFrame.LookVector.X, 0, playerPart.CFrame.LookVector.Z).Unit
											local lookDistance = v211.titanic and 35 or 15
											
											if v264 > 2 then
												-- Pet is FAR: look towards destination
												if 0.001 < (v279 - v278).Magnitude then
													local _, yaw, _ = CFrame.new(v278, v_u_235.Position):ToOrientation()
													v276 = yaw
												end
											else
												-- Pet is CLOSE: look in SAME DIRECTION as player
												local behindPet = v278 - lookDir * lookDistance
												if 0.001 < (playerPart.Position - behindPet).Magnitude then
													local _, yaw, _ = CFrame.new(behindPet, playerPart.Position):ToOrientation()
													v276 = yaw
												end
											end
										end
									elseif v215 then -- Farming/attacking breakable
										if v264 > 4.5 then
											-- Far from breakable: look towards target
											if 0.001 < (v279 - v278).Magnitude then
												local _, yaw, _ = CFrame.new(v278, v_u_235.Position):ToOrientation()
												v276 = yaw
											end
										else
											-- Close to breakable: look at it
											local petPos2D = Vector3.new(v278.X, 0, v278.Z)
											local targetPos2D = Vector3.new(v232.X, 0, v232.Z)
											if 0.001 < (targetPos2D - petPos2D).Magnitude then
												local _, yaw, _ = CFrame.new(petPos2D, targetPos2D):ToOrientation()
												v276 = yaw
											end
										end
									else
										-- Other cases: look towards target
										if 0.001 < (v279 - v278).Magnitude then
											local _, yaw, _ = CFrame.new(v278, v279):ToOrientation()
											v276 = yaw
										end
									end
								end
								local v282 = 0
								local v283 = 0
								if v211.swerve then
									if v270 then
										if not v215 then
											if not v271 then
												if not v217 then
													local _, v284, _ = v_u_235:ToOrientation()
													local v285 = v_u_1.Functions.RadDelta(v276, v284)
													local v286 = math.clamp(math.abs(v285) * (v211.swerveAggression or 1) / math.pi, 0, 1)
													v283 = v286 * v_u_1.Functions.Sigmoid(1 - v286, nil, 3) * math.rad(v211.swerveMaxAngle or 45) * math.sign(v285)
												end
											end
										end
									end
								end
								local v287 = v253:Lerp(CFrame.fromOrientation(v282, v276, v283), (math.clamp(v_u_199 * 0.1, 0, 1)))
								local v288 = 1
								local v289
								if v211.jelly then
									v289 = 0
									if v211.titanic then
										v288 = v288 * 3
									elseif v211.huge then
										v288 = v288 * 2
									else
										v288 = v288 * 1
									end
								else
									v289 = 1
								end
								local v290 = math.sin(v269)
								local v291 = (1 - math.cos(v269 * 2)) / 2
								local _ = Vector3.one
								local v292 = v211.flyHeight or 1
								local v293 = v211.flyHeightChange or 1
								local v294, v295
								if v212 then
									v294 = CFrame.new(0, math.sin(v_u_198 * v224 * 4) * v293 * 0.5 + v292 * 3.5, 0)
									v295 = CFrame.Angles(v270 and -0.08726646259971647 or 0, 0, 0)
								else
									v294 = CFrame.new(0, v291 * 3 * v288, 0)
									v295 = CFrame.Angles(v290 * v289 / 2, 0, v290 * v289 / 8)
								end
								if v211.hybridFly then
									local v296 = math.clamp((v_u_204.flyHeightAnimation or v270 and 1 or 0) + p_u_197 * (v270 and 3.5 or -0.5), 0, 1)
									v_u_204.flyHeightAnimation = v296
									local v297 = Vector3.new(-0.08726646259971647, 0, 0) * v296 + Vector3.new(v290 / 2, 0, v290 / 8) * (1 - v296)
									v294 = CFrame.new(Vector3.new(0, math.sin(v_u_198 * v224 * 4) * v293 * 0.5 + v292 * 3.5, 0) * v296 + Vector3.new(0, v291 * 3, 0) * (1 - v296))
									v295 = CFrame.Angles(v297.X, v297.Y, v297.Z)
								end
								if v210 == "154" or v210 == "242" or v210 == "2067" then
									v295 = v295 * CFrame.Angles(0, 0, (math.rad(v_u_198 * 100)))
								end
								if v210 == "3025" or v210 == "649" then
									local v298 = v_u_204.spawned.spinTick + p_u_197 * 1
									v_u_204.spawned.spinTick = v298
									v295 = v295 * CFrame.Angles(0, v298 * 1.5707963267948966, 0)
								end
								local v299 = v255:Lerp(v294 * v295, (math.clamp(v_u_199 * (v270 and 0.5 or 0.2), 0, 1)))
								local v300 = v_u_204.farmingTick == nil and v_u_204.farming and v271 and v_u_198 or v_u_204.farmingTick
								v_u_204.farmingTick = v300
								if v215 then
									if v271 then
										v271 = v300 ~= nil
									end
								else
									v271 = v215
								end
								local v301 = v271 and v_u_198 - v300 or 0
								local v302 = (1 - math.cos(v301 * v266 * 2)) / 2
								
								-- IMPROVED FARMING ANIMATION: Forward/backward + roll
								local farmSpeed = v266 * 1.5  -- Faster farming speed
								local farmBounce = v271 and math.sin(v301 * farmSpeed) * 0.3 or 0  -- Forward/back
								local farmRoll = v271 and math.sin(v301 * farmSpeed) * 0.25 or 0   -- Side roll
								local v303 = CFrame.Angles(farmBounce, 0, farmRoll)
								
								local v304 = CFrame.identity
								if v211.jelly then
									v304 = v304 * CFrame.new(0, v302 * 1.5 * v288, 0)
								end
								local v305 = v256:Lerp(v304 * v303, (math.clamp(v_u_199 * (v271 and 0.5 or 0.2), 0, 1)))

								-- IMPROVED IDLE ANIMATION
								local v_idleAnim = CFrame.identity
								if not v270 and not v271 then  -- not moving and not farming
									v_u_204.idleTime = (v_u_204.idleTime or 0) + p_u_197
									local swaySpeed = 0.3 * (0.5 * math.sin(v_u_198 * 0.05) + 0.5) + 0.7
									v_idleAnim = CFrame.Angles(
										math.sin(v_u_198 * 0.97) * 0.025 * 1.35 * swaySpeed,  -- pitch
										math.sin(v_u_198 * 0.76) * 0.0095 * 1.35 * swaySpeed, -- yaw
										0
									)
								else
									v_u_204.idleTime = 0
								end

								local v306 = v273 * v275 * v305 * v287 * v299 * v_idleAnim * CFrame.new(0, -v_u_204.spawned.bottom.CFrame.Y, 0)
								v_u_202 = v_u_202 + 1
								_insert(v_u_46, v209, v_u_202)
								_insert(v_u_47, v306, v_u_202)
								local v307 = {
									[v209] = v306
								}
								if next(v_u_204.spawned.scriptedWelds) then
									for _, v308 in pairs(v_u_204.spawned.scriptedWelds) do
										local v309 = v308.part
										local v310 = v308.offset
										if v308.scaling then
											v310 = v310 - v310.Position + v310.Position * v_u_204.spawned.scale
										end
										local v311 = v308.rotationRate
										if v311 then
											local v312 = v311 * v_u_198
											v310 = v310 * CFrame.fromOrientation(v312.X, v312.Y, v312.Z)
										end
										if v_u_204.spawned.id == "606" or v_u_204.spawned.id == "2148" then
											if v309.Name == "Basketball" then
												v310 = v310 + Vector3.new(0, v_u_1.PetCmds.BasketballBounce(v_u_198, 3, v_u_204.spawned.id == "606" and 2 or 5, 2), 0) * v_u_204.spawned.scale
											end
										end
										if v_u_204.spawned.id == "630" or v_u_204.spawned.id == "631" then
											if v309.Name == "Beachball" then
												v310 = v310 + Vector3.new(0, v_u_1.PetCmds.BasketballBounce(v_u_198, 3, (v_u_204.spawned.id == "630" or v_u_204.spawned.id == "631") and 2 or 5, 2), 0) * v_u_204.spawned.scale
											end
										end
										v308.lastOffset = v310
										local v313 = v308.root
										local v314 = (v307[v313] or v313:GetPivot()):ToWorldSpace(v310)
										v307[v309] = v314
										v_u_202 = v_u_202 + 1
										_insert(v_u_46, v309, v_u_202)
										_insert(v_u_47, v314, v_u_202)
									end
								end
								v_u_204.spawned.moving = v270
								v_u_204.spawned.farming = v271
								v_u_204.spawned.movingTick = v268
								v_u_204.spawned.jumping = v267
								v_u_204.spawned.riding = v217 ~= nil
								v_u_1.PetCmds.Effects(v_u_204.spawned, v_u_208, v_u_198, p_u_197, false, v307)
								if v217 then
									v217:updateCharacterCopy(v306)
								end
								v_u_204.lastPositionLerp = v273
								v_u_204.lastRotationLerp = v287
								v_u_204.lastRaycastLerp = v275
								v_u_204.lastAnimationLerp = v299
								v_u_204.lastFarmingLerp = v305
								debug.profilebegin("Pets.Tick.RenderPet.CoinSelection")
								local v315 = v_u_204.spawned.coinSelection
								if v215 and v214 and v_u_206 == v_u_1.LocalPlayer then
									if v315 then
										if v315.coin ~= v214 then
											destroyCoinSelection(v315)
											v_u_204.spawned.coinSelection = nil
											v315 = nil
										end
									end
									if not v315 then
										local v316 = v214.Size
										local v317 = v209.Size
										local v318 = Color3.new(1, 1, 1)
										local v319 = v_u_1.Assets.Other.Selection:FindFirstChild("DottedLine"):Clone()
										local v320 = v_u_1.Assets.Other.Selection:FindFirstChild("SelectionCircle"):Clone()
										local v321 = v_u_1.Assets.Other.Selection:FindFirstChild("SelectionCircle"):Clone()
										local v322 = v320:FindFirstChild("Attachment")
										local v323 = v321:FindFirstChild("Attachment")
										v319.Attachment0 = v322
										v319.Attachment1 = v323
										v319.Color = ColorSequence.new(v318)
										v320.SurfaceGui.Circle.ImageColor3 = v318
										v321.SurfaceGui.Circle.ImageColor3 = v318
										local v324 = math.max(v317.X, v317.Z)
										local v325 = math.max(v316.X, v316.Z)
										local v326 = Vector3.new(v324 + 1.5, 0.05, v324 + 1.5)
										local v327 = Vector3.new(v325 + 1.5, 0.05, v325 + 1.5)
										v322.Position = Vector3.new(0, 0, -v326.Z / 2)
										v323.Position = Vector3.new(0, 0, -v327.Z / 2)
										v320.Size = v326
										v321.Size = v327
										v315 = {
											["coin"] = v214, 
											["dottedLine"] = v319, 
											["selection1"] = v320, 
											["selection2"] = v321, 
											["petSize"] = v317, 
											["coinSize"] = v316, 
											["coinCFrame"] = v214.CFrame, 
											["parented"] = false
										}
										v_u_204.spawned.coinSelection = v315
									end
									assert(v315)
									local v328 = v306 * CFrame.new(0, -v315.petSize.Y / 2 + 0.01, 0)
									local v329 = v315.coinCFrame * CFrame.new(0, -v315.coinSize.Y / 2 + 0.01, 0)
									local v330 = v328 - Vector3.new(0, v328.Position.Y, 0) + Vector3.new(0, v329.Position.Y, 0)
									local v331 = CFrame.new(v330.Position, v329.Position) + Vector3.new(0, 0.025, 0)
									local v332 = CFrame.new(v329.Position, v330.Position) + Vector3.new(0, 0.025, 0)
									local _, v333 = v331:ToOrientation()
									local _, v334 = v332:ToOrientation()
									local v335 = CFrame.new(v331.Position) * CFrame.fromOrientation(0, v333, 0)
									local v336 = CFrame.new(v332.Position) * CFrame.fromOrientation(0, v334, 0)
									if v315.parented then
										v_u_202 = v_u_202 + 1
										_insert(v_u_46, v315.selection1, v_u_202)
										_insert(v_u_47, v335, v_u_202)
										v_u_202 = v_u_202 + 1
										_insert(v_u_46, v315.selection2, v_u_202)
										_insert(v_u_47, v336, v_u_202)
									else
										v315.parented = true
										v315.selection1.CFrame = v335
										v315.selection2.CFrame = v336
										v315.dottedLine.Parent = v315.selection1
										v315.selection1.Parent = v_u_1.Debris
										v315.selection2.Parent = v_u_1.Debris
									end
								elseif v315 then
									v_u_204.spawned.coinSelection = nil
									destroyCoinSelection(v315)
								end
								debug.profileend()
								return true
							end
							debug.profileend()
						end
					end
				else
					debug.profileend()
					return "critical"
				end
			end)()
			if v337 ~= true and v337 == "critical" then
				table.insert(v203, v205)
			end
		end
		v_u_6 = v_u_6 - 1
		for _, v338 in ipairs(v203) do
			v_u_35(v338)
		end
		_trim(v_u_46, v_u_202)
		_trim(v_u_47, v_u_202)
		workspace:BulkMoveTo(v_u_46, v_u_47, Enum.BulkMoveMode.FireCFrameChanged)
		debug.profileend()
	else
		debug.profileend()
	end
end
game:GetService('RunService'):BindToRenderStep("PetsRender", Enum.RenderPriority.Last.Value, Tick);
game:GetService("RunService").Stepped:Connect(function(_, _)
	-- upvalues: (copy) v_u_1, (copy) v_u_102
	if v_u_1.WorldCmds.HasLoaded() then
		v_u_102()
		NetworkUpdate()
	end
end)
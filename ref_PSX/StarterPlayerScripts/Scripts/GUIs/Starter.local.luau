local _L = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"))

while not _L.Loaded do
	game:GetService("RunService").Heartbeat:Wait()
end

local selectedStarter = nil
local StarterGUI = _L.GUI.Starter
local isPickingStarter = false

-- Function to set up the starter selection GUI
function Setup()
	if _L.Save.Get().PickedStarter then
		return
	end

	local function SelectStarter(starterName)
		selectedStarter = starterName

		-- Update the visual appearance of the selected starter button
		for _, button in ipairs(StarterGUI.Pets:GetChildren()) do
			if button.ClassName == "TextButton" then
				local isSelected = button.Name == selectedStarter
				button.Picked.Visible = isSelected
				button.BackgroundColor3 = isSelected and Color3.fromRGB(69, 239, 69) or Color3.fromRGB(39, 233, 55)
			end
		end

		StarterGUI.Pick.Visible = true
	end

	-- Connect the starter buttons to the selection function
	for _, button in ipairs(StarterGUI.Pets:GetChildren()) do
		if button.ClassName == "TextButton" then
			button.Activated:Connect(function()
				if not isPickingStarter then
					isPickingStarter = true
					SelectStarter(button.Name)
					isPickingStarter = false
				end
			end)
		end
	end

	-- Function to handle picking the starter
	local function PickStarter()
		if selectedStarter then
			local success, petName = _L.Network.Invoke("Pick Starter", selectedStarter)
			if success then
				-- Play a sound, disable the GUI, and invoke a signal to rename the pet
				_L.Audio.Play(113921203653235, script, 1, 0.65)
				StarterGUI.Gui.Enabled = false
				_L.Signal.Invoke("Rename Pet", petName)
				_L.Variables.PickingStarter = false

				-- SIMULATOR: Start tutorial for new players
				task.spawn(function()
					print("[TUTORIAL DEBUG] Starting tutorial spawn...")
					task.wait(2)

					local TutorialBotModule = _L["6 - TutorialBot"]
					print("[TUTORIAL DEBUG] TutorialBotModule =", TutorialBotModule)

					if TutorialBotModule then
						print("[TUTORIAL DEBUG] Creating bot...")
						local bot = TutorialBotModule.new()
						print("[TUTORIAL DEBUG] Bot created:", bot)

						if bot then
							_L.Variables.TutorialBot = bot
							_L.Variables.InTutorial = true -- Block other windows during tutorial

							local tutorialCancelled = false
							_L.Signal.Fired("TutorialSkipped"):Connect(function()
								tutorialCancelled = true
								_L.Variables.InTutorial = false
								_L.Variables.TutorialBot = nil
								pcall(function()
									local cam = workspace.CurrentCamera
									cam.CameraType = Enum.CameraType.Custom
									local p = game.Players.LocalPlayer
									if p.Character and p.Character:FindFirstChild("Humanoid") then
										cam.CameraSubject = p.Character.Humanoid
									end
								end)
								_L.Signal.Fire("Window Closed")
							end)

							_L.Network.Fire("GiveTutorialBoost")
							print("[TUTORIAL DEBUG] Requested GiveTutorialBoost from server")

							-- Helper: camera
							local function showCameraAngle(posPart, lookPart)
								local camera = workspace.CurrentCamera
								camera.CameraType = Enum.CameraType.Scriptable
								camera.CFrame = CFrame.new(posPart.Position, lookPart.Position)
							end

							local function resetCameraAngle()
								local camera = workspace.CurrentCamera
								camera.CameraType = Enum.CameraType.Custom
								local player = game.Players.LocalPlayer
								if player.Character and player.Character:FindFirstChild("Humanoid") then
									camera.CameraSubject = player.Character.Humanoid
								end
							end

							-- Helper: 3D GuideArrow (BillboardGui floating above target)
							local currentGuideArrow = nil
							local function createGuideArrow(adorneePart)
								local arrowFolder = game.ReplicatedStorage.Assets.UI.TutorialArrow
								local guideArrow = arrowFolder:FindFirstChild("GuideArrow")
								if not guideArrow then
									warn("[TUTORIAL] No GuideArrow found inside TutorialArrow folder!")
									return nil
								end
								guideArrow = guideArrow:Clone()
								guideArrow.Adornee = adorneePart
								guideArrow.Parent = game.Players.LocalPlayer.PlayerGui
								guideArrow.Enabled = true
								local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1, true)
								local tween = game:GetService("TweenService"):Create(guideArrow, tweenInfo, {StudsOffset = Vector3.new(0, 4, 0)})
								tween:Play()
								return guideArrow
							end
							local function cleanupGuideArrow()
								if currentGuideArrow then
									currentGuideArrow:Destroy()
									currentGuideArrow = nil
								end
							end

							-- Helper: Guide Beam (visual beam from player to target Part)
							local currentBeam = nil
							local currentBeamAttachment0 = nil
							local currentBeamAttachment1 = nil
							local function createGuideBeam(targetPart)
								if currentBeam then currentBeam:Destroy() end
								if currentBeamAttachment0 then currentBeamAttachment0:Destroy() end
								if currentBeamAttachment1 then currentBeamAttachment1:Destroy() end

								local player = game.Players.LocalPlayer
								local character = player.Character
								if not character then return end
								local rootPart = character:FindFirstChild("HumanoidRootPart")
								if not rootPart then return end

								local beam = game.ReplicatedStorage.Assets.UI.TutorialArrow.Beam:Clone()
								beam.Parent = rootPart

								local a1 = Instance.new("Attachment")
								a1.Parent = rootPart
								beam.Attachment0 = a1

								local a2 = Instance.new("Attachment")
								a2.Parent = targetPart
								beam.Attachment1 = a2

								beam.Enabled = true

								currentBeam = beam
								currentBeamAttachment0 = a1
								currentBeamAttachment1 = a2
							end
							local function cleanupGuideBeam()
								if currentBeam then currentBeam:Destroy(); currentBeam = nil end
								if currentBeamAttachment0 then currentBeamAttachment0:Destroy(); currentBeamAttachment0 = nil end
								if currentBeamAttachment1 then currentBeamAttachment1:Destroy(); currentBeamAttachment1 = nil end
							end

							-- Combined: create both GuideArrow + Beam at the same time
							local function createGuide(arrowPart, beamPart)
								if arrowPart then
									currentGuideArrow = createGuideArrow(arrowPart)
								end
								if beamPart then
									createGuideBeam(beamPart)
								end
							end
							local function cleanupGuide()
								cleanupGuideArrow()
								cleanupGuideBeam()
							end

							-- Track boost
							local boostActivated = false
							local boostConnection = _L.Network.Fired("Boost Activated"):Connect(function(boostName)
								print("[TUTORIAL DEBUG] Boost Activated event fired:", boostName)
								if boostName and (tostring(boostName):find("Lucky") or tostring(boostName):find("Luck")) then
									boostActivated = true
								end
							end)

							-- Track egg
							local eggOpened = false
							local eggOpenCount = 0
							local eggConnection = _L.Signal.Fired("Done Opening Egg"):Connect(function()
								print("[TUTORIAL DEBUG] Done Opening Egg event fired")
								eggOpened = true
								eggOpenCount = eggOpenCount + 1
							end)

							local chatNext = _L.GUI.Tutorial and _L.GUI.Tutorial.Main and _L.GUI.Tutorial.Main.Next
							local player = game.Players.LocalPlayer

							-- Helper: 2D arrow management
							local currentArrow = nil
							local function updateArrow(target, position)
								if currentArrow and currentArrow.Parent == target then return end
								if currentArrow then currentArrow:Destroy(); currentArrow = nil end
								if target and _L.GUIFX.ArrowPing then
									currentArrow = _L.GUIFX.ArrowPing(target, position or "ABOVE")
									if currentArrow and not currentArrow.Parent then currentArrow.Parent = target end
								end
							end
							local function clearArrow()
								if currentArrow then currentArrow:Destroy(); currentArrow = nil end
							end

							----------------------------------------------------
							-- MSG 1: Welcome
							----------------------------------------------------
							bot:PlayLoadedAnimation("wave")
							bot:Chat("Hey, " .. player.Name .. "! Welcome to Italian Brainrot Simulator! I'll show you how things work around here.", true).finished(function()

								----------------------------------------------------
								-- MSG 2: Open ExclusiveShop + Drink Luck Potion
								----------------------------------------------------
								bot:Chat("First, let's boost your luck! Open the Exclusive Shop and drink a Luck Potion. I gave you one!", false)

								if chatNext then chatNext.Visible = false end
								_L.Variables.InTutorial = false -- Allow opening ExclusiveShop

								-- Loop until boost is activated or tutorial cancelled
								while not boostActivated and not tutorialCancelled do
									local ShopGui = _L.GUI.ExclusiveShop and _L.GUI.ExclusiveShop.Gui
									local ShopFrame = _L.GUI.ExclusiveShop and _L.GUI.ExclusiveShop.Frame
									local ExclusiveShopBtn = _L.GUI.Main and _L.GUI.Main.Bottom and _L.GUI.Main.Bottom:FindFirstChild("ExclusiveShop")
									local InventoryBtn = _L.GUI.Main and _L.GUI.Main.Bottom and _L.GUI.Main.Bottom:FindFirstChild("Inventory")

									if not ShopGui or not ShopGui.Enabled then
										if ExclusiveShopBtn and not ExclusiveShopBtn.Visible and InventoryBtn and InventoryBtn.Visible then
											updateArrow(InventoryBtn, "ABOVE")
										else
											updateArrow(ExclusiveShopBtn, "ABOVE")
										end
									else
										local BoostsFrame = _L.GUI.ExclusiveShop.Container and _L.GUI.ExclusiveShop.Container:FindFirstChild("Boosts")
										if not BoostsFrame or not BoostsFrame.Visible then
											local BoostTab = ShopFrame:FindFirstChild("Tabs") and ShopFrame.Tabs:FindFirstChild("Boosts")
											updateArrow(BoostTab, "ABOVE")
										else
											local targetBtn = nil
											for _, child in pairs(BoostsFrame:GetChildren()) do
												if child:GetAttribute("Boost") == "Super Lucky" or child:GetAttribute("Boost") == "Super Lucky Potion" then
													targetBtn = child:FindFirstChild("Buttons") and child.Buttons:FindFirstChild("Use")
													break
												end
											end
											if not targetBtn then
												for _, child in pairs(BoostsFrame:GetChildren()) do
													if tostring(child:GetAttribute("Boost")):find("Lucky") then
														targetBtn = child:FindFirstChild("Buttons") and child.Buttons:FindFirstChild("Use")
														break
													end
												end
											end
											updateArrow(targetBtn, "ABOVE")
										end
									end
									task.wait(0.1)
								end

								if tutorialCancelled then clearArrow(); cleanupGuide(); return end
								clearArrow()

								-- Arrow on Close
								local ShopFrame = _L.GUI.ExclusiveShop and _L.GUI.ExclusiveShop.Frame
								local CloseBtn = ShopFrame and ShopFrame:FindFirstChild("Close")
								updateArrow(CloseBtn, "ABOVE")

								repeat
									task.wait(0.1)
									local ShopGui = _L.GUI.ExclusiveShop and _L.GUI.ExclusiveShop.Gui
								until tutorialCancelled or (not ShopGui or not ShopGui.Enabled)

								clearArrow()
								if tutorialCancelled then cleanupGuide(); return end
								_L.Variables.InTutorial = true -- Block again
								if chatNext then chatNext.Visible = true end

								bot:Chat("Great! The luck potion will help you get rarer Brainrots!", true).finished(function()
									if tutorialCancelled then return end

									----------------------------------------------------
									-- MSG 3: Explain PawTokens
									----------------------------------------------------
									local pawTokens = _L.GUI.Main and _L.GUI.Main.Right and (_L.GUI.Main.Right:FindFirstChild("PawTokens") or _L.GUI.Main.Right:FindFirstChild("Paw Tokens"))
									local arrow2 = nil
									if pawTokens and _L.GUIFX.ArrowPing then
										arrow2 = _L.GUIFX.ArrowPing(pawTokens, "LEFT")
									end

									bot:Chat("You can buy more potions, exclusive boxes, and gamepasses using Paw Tokens - earned every minute you play! Or buy with Robux.", true).finished(function()
										if tutorialCancelled then if arrow2 then arrow2:Destroy() end return end
										if arrow2 then arrow2:Destroy() end

										----------------------------------------------------
										-- MSG 4: Show Mercatello (camera only)
										----------------------------------------------------
										if chatNext then chatNext.Visible = true end

										if workspace:FindFirstChild("__CAMERA_ANGLES") then
											local angles = workspace.__CAMERA_ANGLES
											if angles:FindFirstChild("AngleOnePos") and angles:FindFirstChild("AngleOneLook") then
												showCameraAngle(angles.AngleOnePos, angles.AngleOneLook)
											end
										end

										bot:Chat("This is the Mercatello, where you can buy boxes to get new Brainrots!", true).finished(function()
											if tutorialCancelled then resetCameraAngle(); return end
											resetCameraAngle()

											----------------------------------------------------
											-- MSG 4b: Buy egg (GuideArrow + Beam after camera resets)
											-- false = NO Next button. Player must buy egg to proceed.
											----------------------------------------------------
											local guideArrowPart = workspace:FindFirstChild("__Guide_Arrow") and workspace.__Guide_Arrow:FindFirstChild("FirstArrow")
											local guideBeamPart = workspace:FindFirstChild("__Guide_Beam") and workspace.__Guide_Beam:FindFirstChild("FirstBeam")
											createGuide(guideArrowPart, guideBeamPart)

											bot:Chat("Now let's grow your team! Buy an egg - look for the $ sign that means you can afford it!", false)

											if chatNext then chatNext.Visible = false end
											repeat task.wait(0.1) until eggOpened or tutorialCancelled
											cleanupGuide()
											if tutorialCancelled then return end
											if chatNext then chatNext.Visible = true end

											bot:Chat("Awesome! You got a new Brainrot!", true).finished(function()
												if tutorialCancelled then return end

												----------------------------------------------------
												-- MSG 5: Teleport to Piazzara
												-- Flow: arrow on Teleport btn → open → arrow on Town → buy → arrow on Town again → teleport → arrow on Close
												----------------------------------------------------
												local teleportBtn = _L.GUI.Main and _L.GUI.Main.Left and _L.GUI.Main.Left.Tools and _L.GUI.Main.Left.Tools:FindFirstChild("Teleport")
												if teleportBtn then
													updateArrow(teleportBtn, "ABOVE")
												end

												bot:Chat("Now let's explore! Open the Teleport and go to Piazzara!", false)
												if chatNext then chatNext.Visible = false end
												_L.Variables.InTutorial = false -- Allow opening Teleport

												-- Wait for Teleport GUI to open
												local t_Teleport = _L.GUI.Teleport
												repeat task.wait(0.1) until tutorialCancelled or (t_Teleport and t_Teleport.Gui and t_Teleport.Gui.Enabled)
												clearArrow()
												if tutorialCancelled then cleanupGuide(); return end
												_L.Variables.InTutorial = true -- Block again while inside Teleport

												-- Arrow on Town button — player clicks to buy
												local townBtn = t_Teleport.Gui.Frame.RightContainer.Holder:FindFirstChild("Town")
												if townBtn then updateArrow(townBtn, "ABOVE") end

												-- Wait for purchase
												repeat task.wait(0.2) until tutorialCancelled or _L.WorldCmds.HasTeleport("Town")
												if tutorialCancelled then clearArrow(); cleanupGuide(); return end
												-- Purchase done! Arrow on Town AGAIN — player needs to click to teleport
												clearArrow()
												task.wait(0.3)
												if townBtn then updateArrow(townBtn, "ABOVE") end

												-- Wait for GUI to close (teleport loading closes it)
												repeat task.wait(0.1) until tutorialCancelled or not t_Teleport.Gui.Enabled
												clearArrow()
												if tutorialCancelled then cleanupGuide(); return end

												-- After teleport, if GUI reopens, arrow on Close
												task.wait(1)
												if t_Teleport.Gui.Enabled then
													local closeBtn = t_Teleport.Close
													if closeBtn then updateArrow(closeBtn, "ABOVE") end
													repeat task.wait(0.1) until tutorialCancelled or not t_Teleport.Gui.Enabled
													clearArrow()
													if tutorialCancelled then cleanupGuide(); return end
												end

												if chatNext then chatNext.Visible = true end

												----------------------------------------------------
												-- MSG 6a: Collect 1500 Coins in Piazzara
												----------------------------------------------------
												bot:Chat("Great, we're in Piazzara! Collect 1500 coins so you can open a Golden Box and get a Golden Brainrot! Click on coins to send your Brainrots to break them.", true).finished(function()
													if tutorialCancelled then return end
													----------------------------------------------------
													-- MSG 6b: PS tip about coin piles
													----------------------------------------------------
													bot:Chat("PS: Your Brainrots are still weak, so focus on coin piles - they're faster than chests!", false)
													if chatNext then chatNext.Visible = false end

													repeat
														task.wait(0.5)
														local save = _L.Save.Get()
													until tutorialCancelled or (save and (save.Coins or 0) >= 1500)

													if tutorialCancelled then return end
													if chatNext then chatNext.Visible = true end

													----------------------------------------------------
													-- MSG 7: Teleport to Mercatello
													-- Same flow: arrow on Teleport → open → arrow on Shop → buy → arrow on Shop again → teleport → arrow on Close
													----------------------------------------------------
													if teleportBtn then
														updateArrow(teleportBtn, "ABOVE")
													end

													bot:Chat("Nice work! Now open the Teleport and head to Mercatello!", false)
													if chatNext then chatNext.Visible = false end
													_L.Variables.InTutorial = false -- Allow opening Teleport

													repeat task.wait(0.1) until tutorialCancelled or (t_Teleport and t_Teleport.Gui and t_Teleport.Gui.Enabled)
													clearArrow()
													if tutorialCancelled then cleanupGuide(); return end
													_L.Variables.InTutorial = true -- Block again

													-- Arrow on Shop button — player clicks to buy
													local shopBtn = t_Teleport.Gui.Frame.RightContainer.Holder:FindFirstChild("Shop")
													if shopBtn then updateArrow(shopBtn, "ABOVE") end

													-- Wait for purchase
													repeat task.wait(0.2) until tutorialCancelled or _L.WorldCmds.HasTeleport("Shop")
													if tutorialCancelled then clearArrow(); cleanupGuide(); return end

													-- Purchase done! Arrow on Shop AGAIN — player needs to click to teleport
													clearArrow()
													task.wait(0.3)
													if shopBtn then updateArrow(shopBtn, "ABOVE") end

													-- Wait for GUI to close (teleport loading)
													repeat task.wait(0.1) until tutorialCancelled or not t_Teleport.Gui.Enabled
													clearArrow()
													if tutorialCancelled then cleanupGuide(); return end

													-- After teleport, if GUI reopens, arrow on Close
													task.wait(1)
													if t_Teleport.Gui.Enabled then
														local closeBtn = t_Teleport.Close
														if closeBtn then updateArrow(closeBtn, "ABOVE") end
														repeat task.wait(0.1) until tutorialCancelled or not t_Teleport.Gui.Enabled
														clearArrow()
														if tutorialCancelled then cleanupGuide(); return end
													end

													if chatNext then chatNext.Visible = true end

													----------------------------------------------------
													-- MSG 8: Buy Egg at SecondArrow/SecondBeam
													-- false = NO Next button. Player must buy egg to proceed.
													----------------------------------------------------
													local guideArrowPart2 = workspace:FindFirstChild("__Guide_Arrow") and workspace.__Guide_Arrow:FindFirstChild("SecondArrow")
													local guideBeamPart2 = workspace:FindFirstChild("__Guide_Beam") and workspace.__Guide_Beam:FindFirstChild("SecondBeam")
													createGuide(guideArrowPart2, guideBeamPart2)

													bot:Chat("Buy another egg to grow your team!", false)

													if chatNext then chatNext.Visible = false end
													local targetCount = eggOpenCount
													repeat task.wait(0.1) until tutorialCancelled or eggOpenCount > targetCount
													cleanupGuide()
													if tutorialCancelled then return end
													if chatNext then chatNext.Visible = true end

													----------------------------------------------------
													-- MSG 9: Farewell + FinishedTutorial
													----------------------------------------------------
													bot:Chat("Use your coins to buy new areas! See you soon!", true).finished(function()
														if tutorialCancelled then return end
														bot:PlayLoadedAnimation("wave")
														task.wait(1.4)

														if boostConnection then boostConnection:Disconnect() end
														if eggConnection then eggConnection:Disconnect() end

														bot:Cleanup()
														_L.Network.Fire("FinishedTutorial")
														_L.Variables.InTutorial = false -- Unblock! Phase 1 done
														_L.Signal.Fire("Window Closed")

														----------------------------------------------------
														-- Phase 2: Wait for Forest (Boscarello) gate purchase
														----------------------------------------------------
														local function runPhase2()
															task.wait(2)

															local TutorialBotModule2 = _L["6 - TutorialBot"]
															if not TutorialBotModule2 then return end
															local bot2 = TutorialBotModule2.new()
															if not bot2 then return end

															_L.Variables.InTutorial = true -- Block during Phase 2

															local phase2Cancelled = false
															_L.Signal.Fired("TutorialSkipped"):Connect(function()
																phase2Cancelled = true
																_L.Variables.InTutorial = false
																_L.Signal.Fire("Window Closed")
															end)

															local chatNext2 = _L.GUI.Tutorial and _L.GUI.Tutorial.Main and _L.GUI.Tutorial.Main.Next

															bot2:PlayLoadedAnimation("wave")
															bot2:Chat("Hey, I'm back! Now I'll teach you some advanced mechanics. You probably noticed some machines in the first area - they're for improving your Brainrots!", true).finished(function()
																if phase2Cancelled then return end
																if workspace:FindFirstChild("__CAMERA_ANGLES") then
																	local angles = workspace.__CAMERA_ANGLES
																	if angles:FindFirstChild("AngleThreePos") and angles:FindFirstChild("AngleThreeLook") then
																		showCameraAngle(angles.AngleThreePos, angles.AngleThreeLook)
																	end
																end

																bot2:Chat("Use your diamonds to turn duplicate Brainrots into Golden ones!", true).finished(function()
																	if phase2Cancelled then resetCameraAngle(); return end
																	resetCameraAngle()

																	if workspace:FindFirstChild("__CAMERA_ANGLES") then
																		local angles = workspace.__CAMERA_ANGLES
																		if angles:FindFirstChild("AngleFourPos") and angles:FindFirstChild("AngleFourLook") then
																			showCameraAngle(angles.AngleFourPos, angles.AngleFourLook)
																		end
																	end

																	bot2:Chat("When you have many Golden Brainrots, use more diamonds to make them Rainbow!", true).finished(function()
																		if phase2Cancelled then resetCameraAngle(); return end
																		resetCameraAngle()

																		if workspace:FindFirstChild("__CAMERA_ANGLES") then
																			local angles = workspace.__CAMERA_ANGLES
																			if angles:FindFirstChild("AngleFivePos") and angles:FindFirstChild("AngleFiveLook") then
																				showCameraAngle(angles.AngleFivePos, angles.AngleFiveLook)
																			end
																		end

																		bot2:Chat("Finally, use diamonds on the Upgrade Machine to improve your character's speed, your Brainrots' strength, and more!", true).finished(function()
																			if phase2Cancelled then resetCameraAngle(); return end
																			resetCameraAngle()

																			-- GuideArrow + Beam to Third target for Upgrades
																			local guideArrowPart3 = workspace:FindFirstChild("__Guide_Arrow") and workspace.__Guide_Arrow:FindFirstChild("ThirdArrow")
																			local guideBeamPart3 = workspace:FindFirstChild("__Guide_Beam") and workspace.__Guide_Beam:FindFirstChild("ThirdBeam")
																			createGuide(guideArrowPart3, guideBeamPart3)

																			bot2:Chat("Go check if you've collected enough diamonds to upgrade something about your character!", false)

																			if chatNext2 then chatNext2.Visible = false end
																			_L.Variables.InTutorial = false -- Allow opening Upgrades

																			local t_Upgrades = _L.GUI.Upgrades
																			repeat task.wait(0.1) until phase2Cancelled or (t_Upgrades and t_Upgrades.Gui and t_Upgrades.Gui.Enabled)
																			if phase2Cancelled then cleanupGuide(); return end
																			_L.Variables.InTutorial = true -- Block again
																			repeat task.wait(0.1) until phase2Cancelled or not t_Upgrades.Gui.Enabled

																			cleanupGuide()
																			if phase2Cancelled then return end
																			if chatNext2 then chatNext2.Visible = true end

																			bot2:Chat("That's it! I hope you enjoy the game. A big hug from your dev, kalidrios!", true).finished(function()
																				if phase2Cancelled then return end
																				bot2:PlayLoadedAnimation("wave")
																				task.wait(1.4)
																				bot2:Cleanup()
																				_L.Variables.InTutorial = false -- Done! Unblock forever
																				_L.Signal.Fire("Window Closed")
																			end)
																		end)
																	end)
																end)
															end)
														end

														if _L.WorldCmds.HasArea("Forest") then
															task.spawn(runPhase2)
														else
															local phase2Connection
															phase2Connection = _L.Signal.Fired("Stat Changed"):Connect(function(stat)
																if stat ~= "AreasUnlocked" then return end
																if not _L.WorldCmds.HasArea("Forest") then return end
																phase2Connection:Disconnect()
																task.spawn(runPhase2)
															end)
														end
													end)
												end)
											end)
										end)
									end)
								end)
							end)
						end
					end
				end)
			else
				_L.Message.New("Failed to pick starter pet! (unknown reason)")
				return
			end
		else
			return
		end
	end

	-- Connect the pick button to the picking function
	StarterGUI.Pick.Activated:Connect(function()
		if not isPickingStarter then
			isPickingStarter = true
			PickStarter()
			isPickingStarter = false
		end
	end)

	StarterGUI.Gui.Enabled = true
	_L.Variables.PickingStarter = true

	-- Set the selected object for gamepad navigation
	task.defer(function()
		if _L.UserInputService.GamepadEnabled then
			_L.GuiService.SelectedObject = _L.GUI.Starter.Frame.Pets.cat
		end
	end)
end

-- Apply button effects to the pick button and starter buttons
_L.GUIFX.ButtonFX(StarterGUI.Pick)
for _, button in ipairs(StarterGUI.Pets:GetChildren()) do
	if button.ClassName == "TextButton" then
		_L.GUIFX.ButtonFX(button)
	end
end

while not _L.Save.Get() do
	_L.Heartbeat()
end

Setup()
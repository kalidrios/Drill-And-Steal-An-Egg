-- its june and i making a game instead study for my entrance exame
local v2 = game
local v7 = require((v2.ReplicatedStorage:WaitForChild("Framework")):WaitForChild("Library"))
while true do
    local v8 = v7.Loaded
    if not v8 then
        break
    end
    v2 = game
    v8 = v2:GetService("RunService").Heartbeat
    v8:Wait()
end
local v12 = Random.new()
v10 = {}
local v17 = Color3.fromRGB(255, 49, 49)
local v22 = Color3.fromRGB(255, 179, 55)
local v27 = Color3.fromRGB(255, 255, 53)
local v32 = Color3.fromRGB(105, 255, 79)
local v37 = Color3.fromRGB(70, 252, 255)
local v42 = Color3.fromRGB(193, 85, 255)
v10[1] = v17
v10[2] = v22
v10[3] = v27
v10[4] = Color3.fromRGB(255, 169, 225)
v17 = false
v27 = v7.GUI
v22 = v27.FireworkLauncher
v27 = v22.Close
v42 = v7.Assets
v37 = v42.Models
v32 = v37.FireworkProjectile
local v47 = v7.Assets
v37 = v47.Models.FireworkLauncher
local v816 = {}
v47 = {}
local v48 = {}
v48.fpsOffset = CFrame.new(1.5, -1, -3)
v48.fpsRot = CFrame.Angles(0, 3.1415926535898, 0)
v48.lao = CFrame.new(0.5, -1.5, -2)
v48.lar = CFrame.Angles(1.5707963267949, -0.17453292519943, 0.5235987755983)
v48.rao = CFrame.new(2.5, -2, -2)
v48.rar = CFrame.Angles(1.5707963267949, -0.5235987755983, 0)
v48.rotx = -1.5707963267949
v48.roty = 3.1415926535898
v48.rotz = -1.5707963267949
v48.offset = CFrame.new(-0.5, -0.6, 0.2)
local v80 = game.Players.LocalPlayer:GetMouse()
function createProjectile(p1, p2, p3, p4, p5)
    local v82 = v7
    if p1 == v82.LocalPlayer then
        v82 = v7.Network
        v82 = "FireworkLauncher_FireProjectile"
        v82.Fire(v82, p2, p3, p4, p5)
    end
    v7.Audio.Play(4537511307, p2, nil)
    local v96 = v7.Functions.GenerateUID()
    local v97 = v32:Clone()
    v97.Anchored = true
    v97.Position = p2
    v97.Parent = workspace.__DEBRIS
    local v101 = CFrame.new(p2.X, p2.Y, p2.Z)
    v97.CFrame = v101
    v101 = false
    v97.CanCollide = v101
    v101 = v10[v12:NextInteger(1, #v10)]
    local v111 = (v7.Assets.Particles.Achievements:FindFirstChild("SuperFirework-Trail")):Clone()
    local v129 = ColorSequence.new({
        [1] = ColorSequenceKeypoint.new(0, v101), [2] = ColorSequenceKeypoint.new(1, v101)
    })
    v111.Color = v129
    v111.Parent = v97
    v129 = 1
    v118 = p4
    local v130 = math.tan(v118)
    v130 = 600
    if (p5) * v130 >= v130 then
        v119 = p4
        v130 = (p5) * math.tan(v119)
        v129 = (600) / v130
    end
    local function getCFrame_1(p6)
        local v154 = Vector3.new(p2.X + (((math.cos(p3)) * p5) * p6) * v129, p2.Y + (((p5) * math.tan(p4)) * p6 - (28.1) * math.pow(p6, 2)) * v129, p2.Z + (((math.sin(p3)) * p5) * p6) * v129)
        return (CFrame.new(v154, v154 + v154 - v97.CFrame.p)) * CFrame.Angles(0, 1.5707963267949, 0)
    end
    v130 = nil
    v133 = getCFrame_1
    local v195 = v133(0.0001)
    v120 = CFrame.new
    v122 = v97.CFrame
    v121 = v122.Position
    v122 = v195.Position
    local v197 = v120(v121, v122).LookVector
    v124 = v97.CFrame
    v123 = v124.Position
    v127 = v97.Size
    v126 = v127.X
    v125 = (v126) / 2
    v124 = (v197) * v125
    v124 = v195.Position
    v128 = v97.Size
    v127 = v128.X
    v126 = (v127) / 2
    v125 = (v197) * v126
    v123 = v124 + v125
    v124 = 1.5707963267949
    v125 = 0
    v97.CFrame = (CFrame.new(v123 + v124, v123)) * CFrame.Angles(0, v124, v125)
    p2 = v97.CFrame.Position
    v7.Services.RunService:BindToRenderStep("Projectile" .. v96, 1, function()
        local v206 = v130
        if not v206 then
            v206 = tick
            v130 = v206()
        end
        v207 = v97.CFrame.Position
        v97.CFrame = getCFrame_1(tick() - v130)
        local v217 = v97
        local v223 = {
            [1] = workspace.__DEBRIS
        }
        local v320 = p1
        if v320.Character then
            v217 = p1.Character
            v320 = v223
            table.insert(v320, v217)
        end
        v225 = v223
        local v228, v229 = workspace:FindPartOnRayWithIgnoreList(Ray.new(v97.CFrame.Position, (v207 - v97.CFrame.Position.Magnitude) * CFrame.new(v207, v217.CFrame.Position).LookVector), v225)
        if not v228 then
            local v232 = v130
            if tick() - v232 >= 10 then
                v232 = v7
                v232 = "Projectile" .. v96
                v232.Services.RunService:UnbindFromRenderStep(v232)
                local v236 = v229
                if not v236 then
                    v236 = v97.CFrame.Position
                end
                v237 = "Part"
                local v238 = Instance.new(v237)
                v238.CanCollide = false
                v238.Anchored = true
                v238.CFrame = CFrame.new(v236)
                v238.Size = Vector3.zero
                v238.Name = "firework"
                v238.Parent = v7.Debris
                local v244 = (v7.Assets.Particles.Achievements:FindFirstChild("SuperFirework")):Clone()
                v244.Color = ColorSequence.new({
                    [1] = ColorSequenceKeypoint.new(0, v101), [2] = ColorSequenceKeypoint.new(1, v101)
                })
                v244.Parent = v238
                v244:Emit(250)
                v252 = 1
                v253 = 1.2
                v254 = 250
                v7.Audio.Play("rbxassetid://11981238658", v238, v252, v253, v254)
                v7.Functions.AddDebris(v238, 4)
                local v273 = v97:FindFirstChild("SuperFirework-Trail")
                if v273 then
                    v273.Enabled = false
                end
                v274 = v7.Functions.AddDebris
                v274(v97, 1)
                local v281 = v7.Functions.VerifyPlayerMagnitude(v7.LocalPlayer, v236, 200)
                if v281 then
                    v281 = {}
                    v281[1] = 10231636855
                    v281[2] = 10231636725
                    v281[3] = 10231636318
                    v255 = 0.35
                    v7.Audio.Play(v281[math.random(#v281)], v236, nil, v255)
                end
                if v228 then
                    local v289 = v228:FindFirstAncestorOfClass("Model")
                    if v289 then
                        local v290 = v7
                        local v293 = v290.Players:GetPlayerFromCharacter(v289)
                        if v293 then
                            v290 = p1
                            if v293 ~= v290 then
                                v290 = v289.PrimaryPart
                                if v290 then
                                end
                                local v296 = Instance.new("Highlight")
                                v296.Adornee = v289
                                v296.DepthMode = Enum.HighlightDepthMode.Occluded
                                v256 = 0
                                v257 = 0
                                v296.FillColor = Color3.new(1, v256, v257)
                                v296.FillTransparency = 0.5
                                v296.OutlineTransparency = 1
                                v296.Parent = v289
                                local v357 = {}
                                v258 = 0.25
                                v259 = "Cubic"
                                v260 = "In"
                                v357[1] = v258
                                v357[2] = v259
                                v357[3] = v260
                                v7.Functions.Tween(v296, {
                                    FillTransparency = 1
                                }, v357)
                                v7.Functions.AddDebris(v296, 0.25)
                            end
                        end
                    end
                end
            end
            return 
        end
    end)
end
function disableUpperBody(p7)
end
function enableUpperBody(p8)
end
function getWeaponState(p9)
    local v394 = p9
    if not v394 then
        v394 = v7.LocalPlayer
    end
    return v47[v394]
end
function fireWeapon()
    local v399 = getWeaponState()
    if not v399 then
        return 
    end
    local v400 = v399.lastShot
    if v400 then
        v400 = tick() - v399.lastShot
        if 0.35 >= v400 then
            return 
        end
    end
    v400 = tick
    v399.lastShot = v400()
    if v399.gyro then
        v402 = 100000
        v399.gyro.P = v402
        v402 = function()
            task.wait(0.2)
            local v407 = v399
            local v408 = v407.gyro
            if v408 then
                v407 = v399.gyro
                v408 = v407.P
                if v408 == 100000 then
                    v407 = v399
                    v408 = v407.gyro
                    v407 = 400
                    v408.P = v407
                end
            end
        end
        task.spawn(v402)
    end
    task.spawn(function()
        local v413 = v399.part
        local v415 = v413:FindFirstChild("TipAttachment")
        if not v415 then
            return 
        end
        v415 = v80
        v415.TargetFilter = workspace.__DEBRIS
        local v442 = v413.TipAttachment.WorldPosition
        local v444 = v80.Hit.p
        local v420 = Vector2.new(v444.X, v444.Z)
        local v424 = Vector2.new(v442.X, v442.Z)
        local v425 = v420 - v424
        createProjectile(v7.LocalPlayer, v442, math.atan2(v425.Y, v425.X), math.atan((v444.Y - v442.Y) / v420 - v424.Magnitude), 200)
    end)
end
function unequipWeapon(p10)
    local v457 = v47[p10]
    if not v457 then
        return 
    end
    local v477 = v47
    v457 = v477[p10]
    local v458 = v7
    if p10 ~= v458.LocalPlayer then
        v477 = false
    end
    if true then
        v458 = v22
        v458 = false
        v458.Gui.Enabled = v458
    end
    enableUpperBody(p10)
    local v464 = v457.uid
    v7.Services.RunService:UnbindFromRenderStep("FireworkLauncher" .. v464)
    local v465 = v457.weld
    if v465 then
        v465 = v457.weld
        v465:Destroy()
    end
    local v466 = v457.gyro
    if v466 then
        v466 = v457.gyro
        v466:Destroy()
    end
    v457.part:Destroy()
    local v469, v470, v471 = pairs(v457.cframeValues)
    for v463, v464 in v469, v470, v471 do
        v464:Destroy()
    end
    v471 = v7
    v470 = v471.Player
    v469 = v470.RightShoulder
    v470 = p10
    v471 = v7.Player
    v471 = p10
    v469(v470).C0 = v457.originalRightShoulder
    v471.LeftShoulder(v471).C0 = v457.originalLeftShoulder
    v47[p10] = nil
end
function equipWeapon(p11)
    local v491 = getWeaponState(p11)
    if v491 then
        return 
    end
    local v492 = game
    v491 = v492.Players.LocalPlayer
    if p11 == v491 then
        v492 = "FireworkLauncher"
        if not p11:GetAttribute(v492) then
            return 
        end
    end
    if p11 ~= v7.LocalPlayer then
        v494 = false
    end
    v494 = true
    local v496 = v7
    local v497 = v496.Functions.GenerateUID()
    local v498 = v37:Clone()
    v496 = workspace.__DEBRIS
    v498.Parent = v496
    v496 = "WEAPON_" .. p11.Name
    v498.Name = v496
    v496 = {}
    v496.uid = v497
    v496.part = v498
    local v501 = v7
    v496.character = v501.Player.Character(p11)
    v496.isEquipped = true
    v496.lastShot = nil
    v496.weld = nil
    v496.gyro = nil
    v496.cframeValues = {}
    local v650 = v47
    v650[p11] = v496
    if v494 then
        v650 = v27.Activated
        v501 = function()
            unequipWeapon(v7.LocalPlayer)
        end
        v650:Connect(v501)
        v22.Gui.Enabled = true
    end
    local function make3rdPersonWeld_1()
        local v511 = Instance.new("Weld")
        v511.Part0 = v498
        v511.Part1 = v7.Player.RightHand(p11)
        v511.Parent = v498
        v511.C0 = (v48.offset) * CFrame.Angles(v48.rotx, v48.roty, v48.rotz)
        v496.weld = v511
    end
    local v531 = v7
    v503 = v531.Player.PrimaryPart
    local v533 = v503(p11)
    local v534 = v498.CFrame
    if v494 then
        v531 = v7.Network.Fire
        v531("FireworkLauncher_Equip")
        local v541 = Instance.new("BodyGyro", v7.Player.PrimaryPart())
        v541.MaxTorque = (100000000) * Vector3.one
        v541.P = 400
        v496.gyro = v541
    end
    v542 = v7
    v543 = v542.Audio
    v541 = v543.Play
    v543 = 10231636563
    v542 = v533.Position
    v541(v543, v542)
    local v547 = v7.Player.RightShoulder(p11)
    v540 = v7
    local v549 = v540.Player.LeftShoulder(p11)
    v540 = "CFrameValue"
    local v551 = Instance.new(v540)
    v539 = "CFrameValue"
    local v553 = Instance.new(v539)
    v551.Value = v48.lao
    v553.Value = v48.lar
    local v556 = Instance.new("CFrameValue")
    local v559 = Instance.new("CFrameValue")
    v556.Value = v48.rao
    v559.Value = v48.rar
    local v562 = Instance.new("CFrameValue")
    local v565 = Instance.new("CFrameValue")
    v562.Value = v48.fpsOffset
    v565.Value = v48.fpsRot
    v496.cframeValues.leftOffset = v551
    v496.cframeValues.leftRot = v553
    v496.cframeValues.rightOffset = v556
    v496.cframeValues.rightRot = v559
    v496.cframeValues.weaponOffset = v562
    v496.cframeValues.weaponRot = v565
    v496.originalRightShoulder = v547.C0
    v496.originalLeftShoulder = v549.C0
    disableUpperBody(p11)
    local v570 = Instance.new("Weld")
    v570.Part0 = v498
    v570.Part1 = v7.Player.RightHand(p11)
    v570.Parent = v498
    v570.C0 = (v48.offset) * CFrame.Angles(v48.rotx, v48.roty, v48.rotz)
    v496.weld = v570
    v7.Services.RunService:BindToRenderStep("FireworkLauncher" .. v497, 1, function()
        v7.Services.UserInputService.MouseIconEnabled = true
        v496.weld.C0 = (v48.offset) * CFrame.Angles(v48.rotx, v48.roty, v48.rotz)
        v547.C0 = (CFrame.new(0.5, 0.5, 0.8)) * CFrame.Angles(1.5707963267949, 0, -0.26179938779915)
        local v601 = CFrame.new(-0.8, 0.5, 0)
        local v606 = CFrame.Angles(1.5707963267949, 0, 1.0471975511966)
        local v630 = (v601) * v606
        v549.C0 = v630
        if v494 then
            v606 = v80.Hit
            v601 = v606.p
            v630 = v601.X
            v606 = v533.Position
            v601 = v606.Y
            v606 = v80.Hit.p.Z
            v496.gyro.CFrame = CFrame.new(v533.Position, Vector3.new(v630, v601, v606))
        end
    end)
end
function initializeOtherPlayers()
    local v701, v702, v703 = pairs(v7.Network.Invoke("FireworkLauncher_GetPlayersEquipped"))
    for v707, v712 in v701, v702, v703 do
        local v704 = game
        local v708 = v704.Players:GetPlayerByUserId(v707)
        if v708 then
            local v710 = v7.Players
            v704 = v710.Get
            if v708 ~= v704() then
                v710 = v708
                equipWeapon(v710)
            end
        end
    end
end
function animateTargetHit(p12, p13)
end
function allTargetsHit()
end
local function shootingLoop_1()
    while true do
        local v719 = v7
        v719.RenderStepped()
        while true do
            local v721 = v17
            if not v721 then
                break
            end
            v719 = v7
            v721 = v719.RenderStepped
            v721()
        end
        local v723 = getWeaponState()
        local v727 = v723.isEquipped
        local v728 = v723.lastShot
        if tick() - v723.lastShot >= 0.35 then
            fireWeapon()
        end
    end
    return 
    if v719 then
    end
    if v719 then
    end
    if v723 then
    end
end
shootingLoop = shootingLoop_1
shootingLoop_1 = v7.Network.Fired
(shootingLoop_1("FireworkLauncher_OtherPlayerFiredProjectile")):Connect(function(p14, p15, p16, p17, p18)
    createProjectile(p14, p15, p16, p17, p18)
end)
(v7.Signal.Fired("FireworkLauncher_Equip")):Connect(function()
    equipWeapon(v7.LocalPlayer)
end)
(v7.Network.Fired("FireworkLauncher_Equip")):Connect(function(p19)
    equipWeapon(p19)
end)
(v7.Signal.Fired("FireworkLauncher_Unequip")):Connect(function()
    unequipWeapon(v7.LocalPlayer)
end)
(v7.Network.Fired("FireworkLauncher_Unequip")):Connect(function(p20)
    unequipWeapon(p20)
end)
local function v769()
    return getWeaponState(v7.LocalPlayer) ~= nil
end
v7.Signal.Invoked("FireworkLauncher_IsEquipped").OnInvoke = v769
v769 = v7.Network
v769 = "FireworkLauncher_HackyEquip"
(v769.Fired(v769)):Connect(function()
    local v777 = v7
    local v780 = v777.Signal.Invoke("FireworkLauncher_IsEquipped")
    if v780 then
        v777 = v7
        v780 = v777.Signal.Fire
        v780("FireworkLauncher_Unequip")
        return 
    end
    v7.Signal.Fire("FireworkLauncher_Equip")
end)
v7.Services.UserInputService.InputBegan:Connect(function(p21, p22)
    if p22 then
        return 
    end
    if not getWeaponState() then
        return 
    end
    if p21.UserInputType ~= Enum.UserInputType.MouseButton1 then
        if p21.UserInputType ~= Enum.UserInputType.Touch then
            if p21.KeyCode == Enum.KeyCode.ButtonR2 then
                v17 = true
            end
            return 
        end
    end
end)
v7.Services.UserInputService.InputEnded:Connect(function(p23, p24)
    if p24 then
        return 
    end
    if p23.UserInputType ~= Enum.UserInputType.MouseButton1 then
        if p23.UserInputType ~= Enum.UserInputType.Touch then
            if p23.KeyCode == Enum.KeyCode.ButtonR2 then
                v17 = false
            end
            return 
        end
    end
end)
task.spawn(initializeOtherPlayers)
task.spawn(shootingLoop)
game.Players.PlayerRemoving:Connect(unequipWeapon)

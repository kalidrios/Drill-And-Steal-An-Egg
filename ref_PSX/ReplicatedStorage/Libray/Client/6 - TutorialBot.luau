--[[
    TutorialBot Module
    Controla o NPC do tutorial e a GUI de chat
    
    Adaptado para Italian Brainrot Simulator
    Baseado na documentação do Tycoon
--]]

--------|     Library     |--------
-- ⚠️ CRÍTICO: Use exatamente esta sintaxe (com o = )
local _L = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"))

--------|    Variables    |--------
local player = game.Players.LocalPlayer

local TutorialBot = {}

-- ============================================
-- FUNÇÃO: TutorialBot.new()
-- Cria o bot e inicializa tudo
-- ============================================
function TutorialBot.new() 
	local bot = setmetatable({}, {__index = TutorialBot})
	bot.animations = {}
	bot.isDeleted = false
	bot.busyWalking = false
	bot.confirmationActive = false

	-- ⚠️ CAMINHO DO MODELO (ajustado para Simulator):
	bot.model = game.ReplicatedStorage.Assets.Tutorial.TutorialBot:Clone()
	bot.model.Parent = workspace

	-- Ajuste específico de hat (remova se não tiver):
	if bot.model:FindFirstChild("Head") and bot.model.Head:FindFirstChild("HatWeld") then
		bot.model.Head.HatWeld.C0 = CFrame.new(-0.6, 0, 0.1)
	end

	bot.humanoid = bot.model:WaitForChild("Humanoid")

	-- Collision group (opcional)
	for _, descendant in ipairs(bot.model:GetDescendants()) do
		if descendant:IsA("BasePart") then
			pcall(function()
				descendant.CollisionGroup = "NPCGroup"
			end)
		end
	end

	-- Posição inicial (perto do player)
	local spawnPos = Vector3.new(0, 5, 0)
	if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		spawnPos = player.Character.HumanoidRootPart.Position + Vector3.new(5, 0, 5)
	end

	if bot.model.PrimaryPart then
		bot.model:SetPrimaryPartCFrame(CFrame.new(spawnPos))
	end

	bot.state = "FollowingPlayer"
	bot:InitChatbox()
	bot:InitAnimations()
	bot:PlayLoadedAnimation("idle")
	bot:InitStareAtPlayer()
	bot:StartActionLoop()

	return bot
end

-- ============================================
-- FUNÇÃO: InitChatbox()
-- Configura a GUI de tutorial e o botão Skip
-- ============================================
function TutorialBot:InitChatbox()
	-- ⚠️ CAMINHO DO SKIP BUTTON (ajustado para Simulator):
	local skipTutorial = _L.GUI.Tutorial.Main.SkipTutorial

	-- chatbox é a referência para a GUI Tutorial
	self.chatbox = _L.GUI.Tutorial

	skipTutorial.Visible = true

	-- Efeito de wiggle no botão Next a cada 6 segundos
	local UID1 = nil
	local Next = self.chatbox.Main.Next
	if Next then
		Next:GetPropertyChangedSignal("Visible"):Connect(function() 
			if not Next.Visible then return end
			local UID = _L.Functions and _L.Functions.GenerateUID and _L.Functions.GenerateUID() or tostring(tick())
			UID1 = UID
			task.spawn(function()
				while task.wait(6) and Next.Visible and UID1 == UID do
					if _L.GUIFX and _L.GUIFX.Wiggle then
						_L.GUIFX.Wiggle(Next)
					end
				end
			end)
		end)
	end

	-- Preview 3D do bot no ViewportFrame
	local Render = self.chatbox.Main.Container.Render
	local WorldModel = Instance.new("WorldModel", Render)

	-- ⚠️ CAMINHO DO MODELO (ajustado para Simulator):
	local TutorialModel = game.ReplicatedStorage.Assets.Tutorial.TutorialBot:Clone()

	if TutorialModel.PrimaryPart then
		TutorialModel:SetPrimaryPartCFrame(CFrame.new())
	end

	if TutorialModel:FindFirstChild("Head") and TutorialModel.Head:FindFirstChild("HatWeld") then
		TutorialModel.Head.HatWeld.C0 = CFrame.new(-0.6, 0, 0.1)
	end

	if TutorialModel:FindFirstChild("HumanoidRootPart") then
		WorldModel.PrimaryPart = TutorialModel.HumanoidRootPart
	end

	-- Camera para o viewport
	local Camera = Instance.new("Camera", Render)
	Camera.CFrame = CFrame.new(Vector3.new(0.5, 1.3, -2.5), Vector3.new(0, 1, 0))
	Render.CurrentCamera = Camera

	-- Animação idle no preview
	TutorialModel.Parent = workspace -- temporário para carregar animação
	local Animation = Instance.new("Animation")
	Animation.AnimationId = "rbxassetid://507766388"
	Animation.Parent = TutorialModel.Humanoid
	local idleAnimation = TutorialModel.Humanoid:LoadAnimation(Animation)
	idleAnimation.Looped = true
	idleAnimation:Play()
	TutorialModel.Parent = WorldModel

	-- Handler do botão Skip Tutorial
	skipTutorial.MouseButton1Down:Connect(function() 
		_L.Audio.Play(5074101610, player.PlayerGui)
		if self.confirmationActive then return end
		self.confirmationActive = true

		local confirmSkipTutorial = _L.Message.New("Are you sure you'd like to skip the tutorial? It's quick!", true)
		self.confirmationActive = false

		if not confirmSkipTutorial then return end

		-- Reset camera if it was in a tutorial camera angle
		local camera = workspace.CurrentCamera
		camera.CameraType = Enum.CameraType.Custom
		if player.Character and player.Character:FindFirstChild("Humanoid") then
			camera.CameraSubject = player.Character.Humanoid
		end

		-- Cleanup
		HideGui()
		self:PlayLoadedAnimation("wave")
		task.wait(1.4)
		self:Cleanup()
		_L.Network.Fire("FinishedTutorial")
		_L.Variables.InTutorial = false
		_L.Variables.PickingStarter = false
		_L.Signal.Fire("Window Closed")
		-- Fire local signal so Starter script loops can break immediately
		_L.Signal.Fire("TutorialSkipped")
	end)

	_L.GUIFX.ButtonFX(skipTutorial)
end

-- ============================================
-- FUNÇÃO: InitAnimations()
-- Carrega as animações do bot
-- ============================================
function TutorialBot:InitAnimations()
	if self.animations then
		for _, anim in pairs(self.animations) do
			pcall(function() anim:Destroy() end)
		end
	end

	self.animations = {}

	local walkingAnimation = Instance.new("Animation")
	walkingAnimation.AnimationId = "rbxassetid://750783738"  -- Walking

	local idleAnimation = Instance.new("Animation")
	idleAnimation.AnimationId = "rbxassetid://507766388"     -- Idle

	local waveAnimation = Instance.new("Animation")
	waveAnimation.AnimationId = "rbxassetid://507770239"     -- Wave

	self.animations.walking = self.humanoid:LoadAnimation(walkingAnimation)
	self.animations.walking.Looped = true
	self.animations.idle = self.humanoid:LoadAnimation(idleAnimation)
	self.animations.idle.Looped = true
	self.animations.wave = self.humanoid:LoadAnimation(waveAnimation)
	self.animations.wave.Looped = false

	self.animations.idle:Play()
end

-- ============================================
-- FUNÇÃO: InitStareAtPlayer()
-- Faz o bot sempre olhar para o player
-- ============================================
function TutorialBot:InitStareAtPlayer()
	if not self.model.PrimaryPart then return end

	self.gyro = Instance.new("BodyGyro", self.model.PrimaryPart)
	self.gyro.P = 10000
	self.gyro.MaxTorque = Vector3.new(1000, 1000, 1000)

	local primaryPart = self.model.PrimaryPart

	task.spawn(function()
		while not self.isDeleted do
			self:ToggleStare(not self.busyWalking and self.state == "FollowingPlayer")

			if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
				local playerPos = player.Character.HumanoidRootPart.Position
				local lookAt = Vector3.new(playerPos.X, primaryPart.Position.Y, playerPos.Z)
				self.gyro.CFrame = CFrame.new(primaryPart.Position, lookAt)
			end

			game:GetService("RunService").Heartbeat:Wait()
		end
	end)
end

function TutorialBot:ToggleStare(enabled)
	if self.gyro then
		self.gyro.MaxTorque = enabled and Vector3.new(1000, 1000, 1000) or Vector3.new()
	end
end

-- ============================================
-- FUNÇÃO: StartActionLoop()
-- Loop que verifica se precisa seguir o player
-- ============================================
function TutorialBot:StartActionLoop()
	task.spawn(function()
		while not self.isDeleted do
			if self.state == "FollowingPlayer" and not self.busyWalking then
				self:CheckForPlayerFollow()
			end
			task.wait(0.1)
		end
	end)
end

-- ============================================
-- FUNÇÃO: CheckForPlayerFollow()
-- Verifica distância e segue o player se necessário
-- ============================================
function TutorialBot:CheckForPlayerFollow()
	if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
		return false
	end

	if not self.model or not self.model.PrimaryPart then
		return false
	end

	local playerPos = player.Character.HumanoidRootPart.Position
	local botPos = self.model.PrimaryPart.Position
	local distance = (Vector3.new(playerPos.X, 0, playerPos.Z) - Vector3.new(botPos.X, 0, botPos.Z)).Magnitude

	if distance < 10 then
		return false
	end

	self:WalkToPosition(playerPos + Vector3.new(3, 0, 3), function() end)
	return true
end

-- ============================================
-- FUNÇÃO: Chat()
-- Exibe mensagem na GUI Tutorial
-- RETORNA: {finished = function(callback)} para encadear mensagens
-- ============================================
function TutorialBot:Chat(text, canClick)
	local hasFinished = nil

	-- Verificação de segurança do chatbox
	if not self.chatbox or not self.chatbox.Main then
		warn("[TutorialBot] chatbox or chatbox.Main is nil!")
		return {
			finished = function(callback)
				if callback then task.spawn(callback) end
			end
		}
	end

	local Speech = self.chatbox.Main.Container and self.chatbox.Main.Container.Speech
	local Next = self.chatbox.Main.Next

	if not Speech or not Next then
		warn("[TutorialBot] Speech or Next button not found!")
		return {
			finished = function(callback)
				if callback then task.spawn(callback) end
			end
		}
	end

	local Retention = nil

	Speech.Text = ""
	Next.Visible = false

	-- ButtonFX com verificação de segurança
	if _L.GUIFX and _L.GUIFX.ButtonFX then
		_L.GUIFX.ButtonFX(Next)
	end

	-- Se a GUI não está habilitada, anima ela entrando
	if not self.chatbox.Gui.Enabled then
		local chatFrame = self.chatbox.Frame
		if chatFrame then
			local chatPosition = chatFrame.Position
			local UISize = chatFrame.Size

			-- Começa fora da tela e menor
			chatFrame.Position = UDim2.new(0.5, 0, -1, 0)
			chatFrame.Size = UDim2.new(UISize.X.Scale / 2, UISize.X.Offset / 2, UISize.Y.Scale / 2, UISize.Y.Offset / 2)

			-- Anima entrando com verificação
			if _L.Functions and _L.Functions.FastTween then
				local InitMessage = _L.Functions.FastTween(chatFrame, {
					Position = chatPosition,
					Size = UISize
				}, {1, "Back", "Out"})

				self.chatbox.Gui.Enabled = true
				if InitMessage and InitMessage.Completed then
					InitMessage.Completed:Wait()
				end
			else
				-- Fallback sem animação
				chatFrame.Position = chatPosition
				chatFrame.Size = UISize
				self.chatbox.Gui.Enabled = true
			end
		else
			self.chatbox.Gui.Enabled = true
		end
	else
		-- Efeito de "bounce" se já está visível
		local ChatboxFrame = self.chatbox.Frame
		if ChatboxFrame and _L.Functions and _L.Functions.FastTween then
			local Position = ChatboxFrame.Position
			ChatboxFrame.Position = ChatboxFrame.Position + UDim2.new(0, 0, 0.02, 5)
			_L.Functions.FastTween(ChatboxFrame, {Position = Position}, {0.2, "Back", "Out"})
		end
	end

	Speech.Text = text
	task.wait(0.3)

	if canClick then
		Next.Visible = true

		Retention = Next.MouseButton1Down:Connect(function()
			if _L.Audio and _L.Audio.Play then
				_L.Audio.Play(5074101610, player.PlayerGui)
			end
			if self.confirmationActive then return end
			Retention:Disconnect()
			Next.Visible = false
			if hasFinished then
				hasFinished()
			end
		end)

		-- Retorna objeto para encadeamento
		return {
			finished = function(callback) 
				hasFinished = callback
			end
		}
	end

	-- Sempre retorna objeto para evitar nil errors
	return {
		finished = function(callback)
			-- Para mensagens sem botão Next, não encadeia
		end
	}
end

-- ============================================
-- FUNÇÃO: PlayLoadedAnimation()
-- ============================================
function TutorialBot:PlayLoadedAnimation(name)
	if self.animations and self.animations[name] then
		self.animations[name]:Play()
	end
end

-- ============================================
-- FUNÇÃO: StopLoadedAnimation()
-- ============================================
function TutorialBot:StopLoadedAnimation(name)
	if self.animations and self.animations[name] then
		self.animations[name]:Stop()
	end
end

-- ============================================
-- FUNÇÃO: WalkToPosition()
-- Faz o bot andar até uma posição
-- ============================================
function TutorialBot:WalkToPosition(targetPos, callback)
	if self.busyWalking then return end
	self.busyWalking = true
	self:PlayLoadedAnimation("walking")

	task.spawn(function()
		self.humanoid:MoveTo(targetPos)
		self.humanoid.MoveToFinished:Wait()
		self.busyWalking = false
		self:StopLoadedAnimation("walking")
		self:PlayLoadedAnimation("idle")
		if callback then
			callback()
		end
	end)
end

-- ============================================
-- FUNÇÃO: Cleanup()
-- Remove o bot com animação de fade
-- ============================================
function TutorialBot:Cleanup()
	if self.isDeleted then return end

	-- Fade out com verificação de segurança
	if self.model then
		for _, descendant in ipairs(self.model:GetDescendants()) do
			if descendant:IsA("BasePart") and descendant.Name ~= "HumanoidRootPart" then
				if _L.Functions and _L.Functions.FastTween then
					_L.Functions.FastTween(descendant, {Transparency = 1}, {0.2, "Quad", "Out"})
				else
					descendant.Transparency = 1
				end
			end
		end

		task.wait(0.2)
		self.isDeleted = true
		self.model:Destroy()
	else
		self.isDeleted = true
	end

	HideGui()
end

-- ============================================
-- FUNÇÃO GLOBAL: HideGui()
-- Esconde a GUI Tutorial com animação
-- ============================================
function HideGui()
	local Tutorial = _L.GUI.Tutorial
	if not Tutorial then return end

	local Frame = Tutorial.Frame
	if not Frame then 
		if Tutorial.Gui then Tutorial.Gui.Enabled = false end
		return 
	end

	if _L.Functions and _L.Functions.FastTween then
		local tween = _L.Functions.FastTween(Frame, {
			Size = UDim2.new(Frame.Size.X.Scale / 2, Frame.Size.X.Offset / 2, Frame.Size.Y.Scale / 2, Frame.Size.Y.Offset / 2),
			Position = UDim2.new(0.5, 0, -1, 0)
		}, {0.75, "Back", "In"})
		if tween and tween.Completed then
			tween.Completed:Connect(function() 
				Tutorial.Gui.Enabled = false
			end)
		else
			Tutorial.Gui.Enabled = false
		end
	else
		-- Fallback sem animação
		Tutorial.Gui.Enabled = false
	end
end

return TutorialBot

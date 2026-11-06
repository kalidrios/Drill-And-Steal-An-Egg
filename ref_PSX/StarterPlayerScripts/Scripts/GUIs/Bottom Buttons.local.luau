-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local t_Main = m_Library.GUI.Main;
local t_Bottom = t_Main.Bottom;
local _ = Random.new();
local bool1 = false;
local table1 = {}; -- Tabela de tamanhos originais
local table2 = nil;

-- Funções Auxiliares
function CoreIsOpen() 
	for _, child4 in ipairs(t_Bottom:GetChildren()) do
		local v6 = m_Library.GUI[child4.Name];
		if not child4:IsA("GuiObject") or not v6 or not v6.Gui.Enabled then continue end
		return true;
	end
	return false;
end

function CanOpenWindow() 
	return (m_Library.Variables.OpeningEgg <= 0 or not true) and not m_Library.Variables.UsingMachine and not m_Library.Variables.UsingCannon and not m_Library.Variables.LoadingWorld and not m_Library.Variables.PickingStarter and not m_Library.Variables.Trading;
end

-- 1. ATUALIZA AS CORES
function UpdateButtons() 
	for _, child2 in ipairs(t_Bottom:GetChildren()) do
		if not child2:IsA("GuiObject") then continue end

		local v3 = m_Library.GUI[child2.Name];
		if not v3 then continue end

		local uiGradient = child2:FindFirstChild("UIGradient")
		local uiGradientActive = child2:FindFirstChild("UIGradientActive")
		local uiStroke = child2:FindFirstChild("UIStroke")
		local uiStrokeGradientActive = uiStroke and uiStroke:FindFirstChild("UIGradientActive")

		if v3.Gui.Enabled then
			-- ESTADO: ABERTO (Branco/Ativo)
			if child2.Name == "Inventory" then
				if uiStroke then uiStroke.Color = Color3.fromRGB(8, 121, 17) end
				child2.BackgroundColor3 = Color3.fromRGB(77, 247, 82);
			elseif child2.Name == "Trading" then
				if uiGradient then uiGradient.Enabled = false end
				if uiGradientActive then uiGradientActive.Enabled = true end
				if uiStroke then uiStroke.Color = Color3.fromRGB(158, 53, 130) end
				child2.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
			elseif child2.Name == "Mastery" then
				if uiGradient then uiGradient.Enabled = false end
				if uiGradientActive then uiGradientActive.Enabled = true end
				if uiStrokeGradientActive then uiStrokeGradientActive.Enabled = true end
				if uiStroke then uiStroke.Color = Color3.fromRGB(155, 155, 155) end
				child2.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
			elseif child2.Name == "ExclusiveShop" then
				if uiGradient then uiGradient.Enabled = false end
				if uiGradientActive then uiGradientActive.Enabled = true end
				if uiStrokeGradientActive then uiStrokeGradientActive.Enabled = true end
				if uiStroke then uiStroke.Color = Color3.fromRGB(141, 141, 141) end
				child2.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
			elseif child2.Name == "Settings" then
				if uiGradient then uiGradient.Enabled = false end
				if uiGradientActive then uiGradientActive.Enabled = true end
				if uiStroke then uiStroke.Color = Color3.fromRGB(106, 106, 106) end
				if uiStrokeGradientActive then uiStrokeGradientActive.Enabled = true end
				child2.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
			end
		else
			-- ESTADO: FECHADO (Verde/Inativo)
			if uiGradient then uiGradient.Enabled = true end
			if uiGradientActive then uiGradientActive.Enabled = false end
			if uiStrokeGradientActive then uiStrokeGradientActive.Enabled = false end
			child2.BackgroundColor3 = Color3.fromRGB(39, 233, 55);
			if uiStroke then uiStroke.Color = Color3.fromRGB(8, 121, 17) end
		end
	end
end

-- 2. ATUALIZA BARRA MOBILE
function UpdateButtonsBar() 
	local function ImportantWindowIsOpen() 
		for _, val5 in ipairs(m_Library.Variables.ImportantWindows) do
			local v7 = m_Library.GUI[val5];
			if not v7 or not v7.Gui or not v7.Gui.Enabled then continue end
			return true;
		end
	end

	if m_Library.Variables.Mobile then
		local u3 = ImportantWindowIsOpen();
		m_Library.Variables.ImportantWindowOpened = u3;
		m_Library.Signal.Fire("Important Window Toggled", u3);

		local t_Right = t_Main.Right;
		local t_Bottom2 = t_Main.Bottom;

		t_Right.Visible = not u3;
		t_Main.Left.Visible = not u3;
		pcall(function() 
			m_Library.GUI.TouchGui.JumpButton.Visible = not u3;
		end);

		if not table2 then
			table2 = {
				Position = t_Bottom2.Position,
				Size = t_Bottom2.Size,
				AnchorPoint = t_Bottom2.AnchorPoint
			};
		end

		local UIListLayout = t_Bottom2:FindFirstChildOfClass("UIListLayout");

		-- Garante a posição Horizontal no Mobile
		t_Bottom2.Size = table2.Size;
		t_Bottom2.Position = table2.Position;
		t_Bottom2.AnchorPoint = table2.AnchorPoint;
		UIListLayout.Padding = UDim.new(0.01, 10);
		UIListLayout.FillDirection = Enum.FillDirection.Vertical; -- Corrigido para Horizontal
	end
end

-- 3. UPDATE CORE (HÍBRIDO: PC = DOCK / MOBILE = INVISÍVEL)
function UpdateCore() 
	local CoreIsOpen_ret = CoreIsOpen();
	local isMobile = m_Library.Variables.Mobile; -- Verifica se é Mobile

	local showConsoleHints = CoreIsOpen_ret and m_Library.Variables.Console and not m_Library.GUI.Trading.Gui.Enabled
	t_Bottom.XboxKeybindLB.Visible = showConsoleHints
	t_Bottom.XboxKeybindRB.Visible = showConsoleHints

	for _, child3 in ipairs(t_Bottom:GetChildren()) do
		if not child3:IsA("GuiObject") or child3.Name == "Inventory" then continue end

		local originalSize = table1[child3];
		if not originalSize then continue end 

		local targetSize;

		if not CoreIsOpen_ret then
			-- TUDO FECHADO
			if isMobile then
				-- MOBILE: Fica invisível (Tamanho 0)
				targetSize = UDim2.new(0, 0, 0, 0);
			else
				-- PC: Fica no modo DOCK (Visível e tamanho 85%)
				child3.Visible = true; 
				targetSize = UDim2.new(
					originalSize.X.Scale * 0.85, originalSize.X.Offset * 0.85,
					originalSize.Y.Scale * 0.85, originalSize.Y.Offset * 0.85
				);
			end
		else
			-- ABERTO: Tamanho Original
			if not child3.Visible then
				child3.Size = UDim2.new(0,0,0,0);
				child3.Visible = true;
			end
			targetSize = originalSize;
		end

		-- Animação
		if child3.Size ~= targetSize then
			local v5 = child3.LayoutOrder - 1;
			local speed = CoreIsOpen_ret and (v5 * 0.025 + 0.125) or 0.25

			local tween = m_Library.Functions.Tween(child3, {Size = targetSize}, {speed, "Expo", "Out"});

			-- Se for MOBILE e estiver fechando, esconde o botão no final da animação
			if isMobile and not CoreIsOpen_ret then
				tween.Completed:Connect(function()
					-- Confirma se ainda está fechado antes de esconder
					if not CoreIsOpen() then 
						child3.Visible = false;
					end
				end)
			end
		end
	end
end

function UpdatePositioning() 
	local _ = m_Library.Variables.Mobile;
	t_Main.Right.Position = UDim2.new(t_Main.Right.Position.X.Scale, t_Main.Right.Position.X.Offset, t_Main.Right.Position.Y.Scale, -25);
	t_Main.Left.Position = UDim2.new(t_Main.Left.Position.X.Scale, t_Main.Left.Position.X.Offset, t_Main.Left.Position.Y.Scale, 25);
end

function Update() 
	UpdateCore();
	UpdateButtonsBar();
	UpdateButtons();
	UpdatePositioning();
end

function HookButton(p1) 
	local v2 = p1.Name == "Inventory";
	local u1 = m_Library.GUI[p1.Name];
	local t_Name = u1.Gui.Name;

	table1[p1] = p1.Size; 

	m_Library.GUIFX.ButtonFX(p1);
	if not u1 then return end

	local function Activated() 
		if not bool1 then
			bool1 = true;
			local CanOpenWindow_ret = CanOpenWindow();
			if CanOpenWindow_ret or u1.Gui.Enabled and t_Name ~= "Trading" then
				u1.Gui.Enabled = not u1.Gui.Enabled;
				if t_Name == "Inventory" then
					if u1.Gui.Enabled and m_Library.Variables.Console then
						print("Set selected obj");
						m_Library.GuiService.SelectedObject = m_Library.LocalPlayer.PlayerGui:FindFirstChild("Inventory"):FindFirstChild("Frame"):FindFirstChild("Main"):FindFirstChild("Pets");
					end
					m_Library.Audio.Play(u1.Gui.Enabled and "rbxassetid://8951380876" or "rbxassetid://8951380772", script, 1, 0.5);
				elseif t_Name == "ExclusiveShop" and u1.Gui.Enabled then
					if u1.Gui.Enabled and m_Library.Variables.Console then
						print("Set selected obj");
						m_Library.GuiService.SelectedObject = m_Library.LocalPlayer.PlayerGui:FindFirstChild("ExclusiveShop"):FindFirstChild("Frame"):FindFirstChild("Container");
					end
					m_Library.Audio.Play("rbxassetid://8951381026", script, 1.1, 0.5);
					if m_Library.Save.Get() then
						m_Library.Save.Get().LastShopClick = m_Library.Shared.ShopNumber
						m_Library.Signal.Fire("Clicked Shop Button")
					end
				end
			end
			bool1 = false;
		end
	end

	p1.Activated:Connect(function() 
		Activated();
	end);

	if v2 then
		m_Library.UserInputService.InputBegan:Connect(function(input, gameProcessedEvent) 
			if not gameProcessedEvent then
				if m_Library.Signal.Invoke("Is Console Blocking") then return end
				if input.KeyCode == Enum.KeyCode.X or input.KeyCode == Enum.KeyCode.ButtonY then
					Activated();
				end
			end
		end);
	end

	if p1:FindFirstChild("Title") then
		p1.MouseEnter:Connect(function() 
			if not m_Library.Variables.Mobile then
				p1.Title.Visible = true;
			end
		end);
		p1.MouseLeave:Connect(function() 
			if not m_Library.Variables.Mobile then
				p1.Title.Visible = false;
			end
		end);
	end
end

for _, child1 in ipairs(t_Bottom:GetChildren()) do
	if not child1:IsA("GuiObject") or child1:GetAttribute("Keybind") then continue end
	HookButton(child1);
end

m_Library.Signal.Fired("Window Closed"):Connect(function() 
	Update();
end);
m_Library.Signal.Fired("Window Opened"):Connect(function() 
	Update();
end);
m_Library.Signal.Fired("Changed Platform"):Connect(function() 
	UpdateButtonsBar();
end);

task.defer(function()
	task.wait(0.1)
	Update();
end)
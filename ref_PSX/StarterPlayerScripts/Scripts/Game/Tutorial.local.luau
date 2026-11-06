-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local t_cost = m_Library.Directory.Eggs["Cracked Egg"].cost;
function Finished() -- Line: 25
	--[[
		Upvalues:
			[1] = m_Library
	--]]
	m_Library.Signal.Fire("Notification", "Nice! You can afford your first box! Go buy it!", {
		color = Color3.fromRGB(255, 243, 62),
		time = 7
	});
	m_Library.Signal.Fire("Fireworks Animation");
end
function Progress() -- Line: 31
	--[[
		Upvalues:
			[1] = m_Library
			[2] = t_cost
	--]]
	local v1 = m_Library.Save.Get();
	if not v1 then return end
	local t_TutorialProgress = v1.TutorialProgress;
	if t_TutorialProgress < 100 then
		m_Library.Signal.Fire("Notification", "(" .. t_TutorialProgress .. "%) Save up " .. t_cost .. " Coins");
	end
end
m_Library.Signal.Fired("Stat Changed"):Connect(function(p1) -- Line: 44
	if p1 == "TutorialProgress" then
		Progress();
	end
end);
m_Library.Network.Fired("Finished Tutorial"):Connect(function() -- Line: 51
	Finished();
end);

-------------------------------------------------------------------------------
-- GUI Scaling (Mobile Compatibility) 
-------------------------------------------------------------------------------
local table1 = {
	{
		gui = "Tutorial",
		bottomLowestFactor = 0.4 -- Celular update
	},
    --[[	{
		gui = "Tutorial",
		bottomLowestFactor = -- Another resolution
	},
	]]
}

function CalcScale(factor)
    -- Base resolution 1080p
    local resolutionScale = m_Library.Functions.ResolutionScale() 
    
    -- Fórmula: Escala Base + (Diferença para 100%) * Fator de Resolução Ajustado
	return factor + (1 - factor) * math.clamp((resolutionScale - 0.33) / 0.66, 0, 1)
end

function ScaleFunction(config)
	if not m_Library.GUI[config.gui] then return end
    
	local t_Gui = m_Library.GUI[config.gui].Gui
	local newScale = CalcScale(config.bottomLowestFactor)
    
    -- Cria ou atualiza o UIScale
	local scaleObj = t_Gui:FindFirstChild("__AUTOSCALE")
	if not scaleObj then
		scaleObj = Instance.new("UIScale")
		scaleObj.Name = "__AUTOSCALE"
		scaleObj.Parent = t_Gui
	end
	scaleObj.Scale = newScale
end

task.spawn(function()
	while true do
		for _, config in ipairs(table1) do
			ScaleFunction(config)
		end
		task.wait(1) -- Verifica periodicamente
	end
end)

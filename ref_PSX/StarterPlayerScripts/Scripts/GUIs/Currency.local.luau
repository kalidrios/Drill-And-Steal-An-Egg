-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

local v1 = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not v1.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end;
local v2 = Random.new();
local v3 = {};
local u1 = false;
local u2 = {};
local l__IsHardcore__3 = v1.Shared.IsHardcore;
local l__Main__4 = v1.GUI.Main;
local u5 = false;
function Update()
	local v4 = v1.Save.Get();
	if not v4 then
		return;
	end;
	local v5 = v1.Variables.Mobile and v1.Functions.ResolutionScale() <= 0.6;
	if not u1 then
		if v5 then
			u1 = true;
			for v6, v7 in ipairs(u2) do
				v7();			
			end;
			u2 = {};
		end;
	end;
	local v9 = v1.WorldCmds.Get();
	if not v9 then
		return;
	end;
	local v10 = v1.Directory.Worlds[v9];
	local l__mainCurrency__11 = v10.mainCurrency;
	for v15, v16 in pairs(v1.Directory.Currency) do
		local v17
		if l__IsHardcore__3 then
			if v16.HardcoreSeparate then
				v17 = v4.HardcoreCurrency[v15];
			else
				v17 = v4[v15];
			end;
		else
			v17 = v4[v15];
		end;
		if not v17 then
			v17 = 0;
		end;
		local v18 = l__Main__4.Right:FindFirstChild(v15);
		local v19 = false;
		local l__Visibility__20 = v16.Visibility;
		if l__Visibility__20 == v1.Types.Currency.Visibility.Always then
			v19 = true;
		elseif l__Visibility__20 == v1.Types.Currency.Visibility.Selective then
			if l__mainCurrency__11 ~= v15 then
				if 0 < v17 then
					if v10.additionalCurrencies then
						if table.find(v10.additionalCurrencies, v15) then
							v19 = true;
						end;
					end;
				end;
			else
				v19 = true;
			end;
		elseif l__Visibility__20 == v1.Types.Currency.Visibility.Hidden then
			v19 = false;
		else
			error("Unknown Visibility: " .. tostring(l__Visibility__20));
		end;
		if not v19 then
			if v18 then
				v18.Visible = v19;
			end;
		else
			if not v18 then
				v18 = v1.Assets.UI.Main.Currency:Clone();
				v18.Name = v15;
				v18.Icon.Image = v16.ImageOutline;
				local l__Gradient__22 = v16.Gradient;
				l__Gradient__22:Clone().Parent = v18.Amount;
				l__Gradient__22:Clone().Parent = v18:FindFirstChild("UIStroke");
				v18.LayoutOrder = 99999999 - v16.Order;
				if l__IsHardcore__3 then
					if v16.HardcoreSeparate then
						v18.Icon.HC.Visible = true;
					end;
				end;
				if v15 == "Diamonds" then
					v18.Add.Visible = true;
					v1.GUIFX.ButtonFX(v18.Add);
					v18.Add.Activated:Connect(function()
						if not u5 then
							u5 = true;
							v1.Signal.Fire("Exlusive Shop Tab", "Diamonds");
							u5 = false;
						end;
					end);
				end;
				if not v18.Add.Visible then
					local l__Position__23 = v18.Amount.Position;
					local l__Size__24 = v18.Amount.Size;
					v18.Amount.Position = UDim2.new(0.02, l__Position__23.X.Offset, l__Position__23.Y.Scale, l__Position__23.Y.Offset);
					v18.Amount.Size = UDim2.new(0.8, l__Size__24.X.Offset, l__Size__24.Y.Scale, l__Size__24.Y.Offset);
				end;
				v18.Parent = l__Main__4.Right;
				if not u1 then
					table.insert(u2, (v1.GUIFX.Odometer(v18.Amount)));
				end;
			end;
			v18.Amount.AutoLocalize = false;
			if u1 then
				v18.Amount.Text = v1.Functions.NumberShorten(v17, false);
			else
				v18.Amount.Text = v1.Functions.Commas(v17);
			end;
			BloatCurrencyFrame(v18);
			v18.Visible = true;
		end;	
	end;
end;
function BloatCurrencyFrame(p1)
	local v25 = p1:FindFirstChildOfClass("UIScale");
	if not v25 then
		v25 = Instance.new("UIScale");
		v25.Parent = p1;
	end;
	v25.Scale = 1.3;
	v1.Functions.Tween(v25, {
		Scale = 1
	}, { 0.25, "Circular", "Out" });
end;
for v26, v27 in ipairs(l__Main__4.Right:GetChildren()) do
	if v27.ClassName == "Frame" and v27:FindFirstChild("Amount") and v27.Name ~= "Rank" then
		v27:Destroy();
	end;
end;
v1.Signal.Fired("Stat Changed"):Connect(function(p2)
	if v1.Directory.Currency[p2] or p2 == "HardcoreCurrency" then
		Update();
	end;
end);
Update();
v1.Signal.Fired("World Changed"):Connect(function()
	Update();
end);
v1.Signal.Fired("Resolution Changed"):Connect(function()
	task.defer(function()
		Update();
	end);
end);

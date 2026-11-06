-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

local l__ReplicatedStorage__1 = game:GetService("ReplicatedStorage");
local l__Library__2 = l__ReplicatedStorage__1:WaitForChild("Library");
local l__Client__3 = l__Library__2:WaitForChild("Client");
local l__LocalPlayer__4 = game:GetService("Players").LocalPlayer;
local l__PlayerGui = l__LocalPlayer__4:WaitForChild("PlayerGui", 30);
if not l__PlayerGui then
	warn("PlayerGui not found after 30 seconds. Trading script will not run.");
	return;
end
local l__Trading__5 = l__PlayerGui:WaitForChild("Trading", 30);
if not l__Trading__5 then
	warn("Trading GUI not found in PlayerGui after 30 seconds. Trading script will not run.");
	return;
end
local l__Frame__6 = l__Trading__5:WaitForChild("Frame");
local l__Trade__7 = l__Frame__6:WaitForChild("Trade");
local l__TradeBottom__8 = l__Trade__7:WaitForChild("TradeBottom");
local v9 = Color3.fromRGB(252, 58, 252);
local u1 = require(l__Client__3.Save);
local u2 = require(l__Library__2.Shared);
function GetTradeRating(p1)
	local v10 = u1.Get(p1);
	if not v10 then
		return -1, "(Unrated)";
	end;
	assert(v10);
	local v11 = 0;
	local v12 = 0;
	if v10.TradeHistory2 then
		local v13 = {};
		for v14 = #v10.TradeHistory2, 1, -1 do
			local v15 = v10.TradeHistory2[v14];
			if v15.or_ ~= nil and not v13[v15.u]  then
				v13[v15.u] = true;
				if v15.or_ then
					v11 = v11 + 1;
				else
					v12 = v12 + 1;
				end;
			end;
		end;
	end;
	if v11 + v12 < u2.TradeRatingRequirement then
		return 0, "(Unrated)";
	end;
	local v16 = math.round(v11 * 9 / (v11 + v12) * 10) / 10 + 1;
	return v16, "(" .. string.format("%0.1f", v16) .. " Rating)";
end;
local u3 = require(l__Library__2.Functions);
local l__PlayerList__4 = l__Frame__6:WaitForChild("PlayerList");
local u5 = {};
local l__Assets__6 = l__ReplicatedStorage__1:WaitForChild("Assets");
local u7 = require(l__Library__2.Signal);
local u8 = require(l__Client__3.GUIFX);
local u9 = false;
local u10 = require(l__Client__3.Network);
local u11 = require(l__Library__2.Audio);
local u12 = require(l__Client__3.Message);
local u13 = true;
function RenderPlayerList()
	local v17 = nil;
	local v18 = u3.RegexEscape(string.lower(tostring(l__PlayerList__4.Bottom.Search.Query.Text)));
	local v19 = false;
	if v18 ~= nil then
		v19 = v18 ~= "";
	end;
	for v20, v21 in ipairs(game.Players:GetPlayers()) do
		local v23 = u1.Get(v21, true);
		if v23 then
			if v21 ~= l__LocalPlayer__4 then
				local v24 = v23.Settings.Trading ~= 3;
				local v25 = u3.SearchArray(u5, v21);
				local v26 = l__PlayerList__4.Players:FindFirstChild(v21.Name);
				if not v26 then
					local l__Name__27 = v21.Name;
					local l__DisplayName__28 = v21.DisplayName;
					v26 = l__Assets__6.UI.Trading.Player:Clone();
					v26.Username.Text = "@" .. l__Name__27;
					v26.DisplayName.Text = l__DisplayName__28;
					local v29, v30 = GetTradeRating(v21);
					v26.Rating.Text = v30;
					task.spawn(function()
						local v31 = u7.Invoke("Get Trade Suffix", v21);
						if v31 then
							v26.DisplayName.Text = l__DisplayName__28 .. v31;
						end;
					end);
					v26.Name = l__Name__27;
					v26.Parent = l__PlayerList__4.Players;
					u8.ButtonFX(v26);
					local u14 = v24;
					local u15 = v25;
					v26.Activated:Connect(function()
						if not u9 then
							u9 = true;
							u14 = v23.Settings.Trading ~= 3;
							u15 = u3.SearchArray(u5, v21);
							if u14 then
								if not u15 then
									local v32, v33 = u10.Invoke("Send Trade Invite", v21);
									if v32 then
										u11.Play("rbxassetid://7139320704", script, 1, 0.5);
										u12.New("\240\159\147\169 Trade request sent!");
									else
										u12.New(v33 or "Failed to send trade request (unknown)");
									end;
								end;
							end;
							u9 = false;
						end;
					end);
				end;
				v26.Notice.Visible = not v24 and v25;
				v26.Icon.Visible = not v26.Notice.Visible;
				if v19 then
					local v34 = true;
					if string.find(string.lower(v21.Name), v18) == nil then
						v34 = string.find(string.lower(v21.DisplayName), v18) ~= nil;
					end;
					v26.Visible = v34;
				else
					v26.Visible = true;
				end;
				if not u13 then
					if not l__LocalPlayer__4:IsFriendsWith(v21.UserId) then
						v26.Visible = false;
					end;
				end;
				local v35 = true;
				if v24 then
					v26.LayoutOrder = u3.StringByte(v21.Name);
					v26.ImageColor3 = Color3.fromRGB(255, 255, 255);
					if v25 then
						v35 = false;
						v26.Notice.Text = "(Pending)";
					end;
					v26.Fade.ImageColor3 = Color3.fromRGB(255, 255, 255);
				else
					v26.Fade.ImageColor3 = Color3.fromRGB(175, 175, 175);
					v26.LayoutOrder = 999999999;
					v26.ImageColor3 = Color3.fromRGB(144, 144, 144);
					v35 = false;
					v26.Notice.Text = "(Disabled)";
				end;
				v26.Rating.Visible = v35;
				task.spawn(function()
					local v36 = game.Players:GetUserThumbnailAsync(v21.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size180x180);
					if v36 then
						v26.Player.Image = v36;
					end;
				end);
			end;
		end;	
	end;
	v17 = l__PlayerList__4.Players:FindFirstChild("__EMPTY");
	if #game.Players:GetPlayers() <= 1 then
		if not v17 then
			local v37 = l__Assets__6.UI.Trading.EmptyServer:Clone();
			v37.Name = "__EMPTY";
			v37.Parent = l__PlayerList__4.Players;
			l__PlayerList__4.Players.CanvasSize = UDim2.new(0, 0, 0, 0);
		end;
	elseif v17 then
		v17:Destroy();
	end;
	for v38, v39 in ipairs(l__PlayerList__4.Players:GetChildren()) do
		if v39.ClassName == "ImageButton" then
			if not game.Players:FindFirstChild(v39.Name) then
				v39:Destroy();
			end;
		end;	
	end;
	ListScrolling();
end;
function ListScrolling()
	local v41 = l__PlayerList__4.Players:FindFirstChildOfClass("UIListLayout");
	local v42 = l__PlayerList__4.Players:FindFirstChildOfClass("UIPadding");
	v41:ApplyLayout();
	l__PlayerList__4.Players.CanvasSize = UDim2.new(0, 0, 0, v41.AbsoluteContentSize.Y + v42.PaddingTop.Offset + v42.PaddingBottom.Offset);
end;
local u16 = false;
local u17 = nil;
local u18 = require(l__Client__3.PetCmds);
local u19 = require(l__Client__3.PetUI);
local u20 = false;
local l__TradeQuery__21 = l__TradeBottom__8:WaitForChild("TradeSearch"):WaitForChild("TradeQuery");
local u22 = require(l__Library__2.Directory);
local u23 = Random.new();
local u24 = nil;
function UpdatePets()
	if u16 then
		if not u17 then
			return;
		end;
	else
		return;
	end;
	local v43 = u1.Get();
	if not v43 then
		return;
	end;
	assert(v43);
	assert(u17);
	local v44, v45, v46, v47, v48, v49, v50, v51 = FigureOutTrade();
	local v52 = u17.targetReady and u17.senderReady;
	for v53, v54 in ipairs(l__Trade__7.Client.Pets:GetChildren()) do
		if v54.ClassName == "TextButton" then
			local v56, v57 = u18.Get(v54.Name);
			if v56 then
				if v57 ~= l__LocalPlayer__4 then
					v54:Destroy();
				end;
			else
				v54:Destroy();
			end;
		end;	
	end;
	for v58, v59 in ipairs(l__Trade__7.Player.Pets:GetChildren()) do
		if v59.ClassName == "TextButton" then
			if not u3.SearchArray(v45.pets, v59.Name) then
				v59:Destroy();
			end;
		end;	
	end;
	for v61, v62 in ipairs(v45.pets) do
		if u18.Get(v62) then
			local v64 = l__Trade__7.Player.Pets:FindFirstChild(v62);
			if not v64 then
				v64 = l__Assets__6.UI.Inventory.Pet:Clone();
				u19.Create(v64, v62, false);
				if not v64:GetAttribute("HasNewAnimated") then
					v64:SetAttribute("HasNewAnimated", true);
					task.spawn(function()
						local u25 = 0;
						local u26 = nil;
						u26 = game:GetService("RunService").RenderStepped:Connect(function(p2)
							if v64 then
								if v64.Parent then
									if v64.PetIcon then
										if v64:GetAttribute("isVisible") then
											if not l__Trading__5.Enabled then

											else
												u25 = u25 + p2;
												if 4 <= u25 then
													u26:Disconnect();
													v64.PetIcon.ImageTransparency = 0;
													return;
												else
													v64.PetIcon.ImageTransparency = math.abs(math.sin(u25 / 4 * math.pi * 6) / 2);
													return;
												end;
											end;
										end;
									end;
								end;
							end;
						end);
					end);
				end;
				v64.Parent = l__Trade__7.Player.Pets;
			end;
			local v65
			if u20 then
				v65 = 2;
			else
				v65 = 4;
			end;
			v64.Level:FindFirstChildOfClass("UIStroke").Thickness = v65;
			local v66
			if u20 then
				v66 = 2;
			else
				v66 = 4;
			end;
			v64.HC:FindFirstChildOfClass("UIStroke").Thickness = v66;
			v64.LayoutOrder = v61;
		end;	
	end;
	local v67 = false;
	if l__TradeQuery__21.Text ~= "" then
		v67 = l__TradeQuery__21.Text ~= nil;
	end;
	local v68 = v67 and u3.RegexEscape(string.lower(tostring(l__TradeQuery__21.Text))) or nil;
	for v69, v70 in ipairs((u2.SortPets(v43, table.clone(v43.Pets)))) do
		local l__uid__72 = v70.uid;
		local v73 = u22.Pets[v70.id];
		local l__tradeable__74 = v73.tradeable;
		local l__powers__75 = v70.powers;
		local v76 = u3.SearchArray(v44.pets, l__uid__72);
		local v77 = l__Trade__7.Client.Pets:FindFirstChild(l__uid__72);
		if not v77 then
			v77 = l__Assets__6.UI.Inventory.Pet:Clone();
			u19.Create(v77, l__uid__72, false);
			if not l__tradeable__74 then
				v77.BackgroundColor3 = Color3.new(0.5, 0.5, 0.5);
				v77.PetIcon.ImageTransparency = 0.5;
				v77.PetIcon.ImageColor3 = Color3.new(0.5, 0.5, 0.5);
				v77.LayoutOrder = 999999999;
			end;
			if l__tradeable__74 then
				local u27 = v44;
				local u28 = v45;
				local u29 = v46;
				local u30 = v47;
				local u31 = v48;
				local u32 = v49;
				local u33 = v50;
				local u34 = v51;
				local u35 = v76;
				v77.Activated:Connect(function()
					if not u9 then
						if not IsChatting() then
							u9 = true;
							if not IsProcessing() then
								if v70.l then
									u12.New("This pet is locked! Unlock it before you can trade it!");
									u9 = false;
									return;
								end;
								if u7.Invoke("Is Trading Booth Pet", l__uid__72) then
									u12.New("This pet is currently in your trading booth! Remove it before you can trade it!");
									u9 = false;
									return;
								end;
								local v79, v80, v81, v82, v83, v84, v85, v86 = FigureOutTrade();
								u27 = v79;
								u28 = v80;
								u29 = v81;
								u30 = v82;
								u31 = v83;
								u32 = v84;
								u33 = v85;
								u34 = v86;
								u35 = u3.SearchArray(u27.pets, l__uid__72);
								local v87 = u3.SearchArray(u27.pets, l__uid__72);
								if v87 then
									u11.Play("rbxassetid://7139317909", script, u23:NextNumber(0.95, 1.05), 0.75);
								else
									u11.Play("rbxassetid://7139317934", script, u23:NextNumber(0.95, 1.05), 0.75);
								end;
								if v87 then
									local v88, v89 = u10.Invoke("Remove Trade Pet", u24, l__uid__72);
									if not v88 then
										u12.New(v89 or "Something went wrong.");
									end;
								else
									local v90, v91 = u10.Invoke("Add Trade Pet", u24, l__uid__72);
									if not v90 then
										u12.New(v91 or "Something went wrong.");
									end;
								end;
							end;
							u9 = false;
						end;
					end;
				end);
			end;
			u8.ButtonFX(v77);
			v77.Parent = l__Trade__7.Client.Pets;
		end;
		local v92
		if u20 then
			v92 = 2;
		else
			v92 = 4;
		end;
		v77.Level:FindFirstChildOfClass("UIStroke").Thickness = v92;
		local v93
		if u20 then
			v93 = 2;
		else
			v93 = 4;
		end;
		v77.HC:FindFirstChildOfClass("UIStroke").Thickness = v93;
		local v94 = false;
		if v67 and not v52 then
			assert(v68);
			if string.find(string.lower(v73.name), v68, 1, true) then
				v94 = true;
			elseif v70.nk and string.find(string.lower(v70.nk), v68, 1, true) then
				v94 = true;
			elseif string.find(string.lower(v73.rarity), v68, 1, true) then
				v94 = true;
			elseif v70.sh and string.find("shiny", v68, 1, true) then
				v94 = true;
			elseif v70.g and (string.find("gold", v68, 1, true) or string.find("golden", v68, 1, true)) then
				v94 = true;
			elseif v70.r and string.find("rainbow", v68, 1, true) then
				v94 = true;
			elseif v70.dm and string.find("dark matter", v68, 1, true) then
				v94 = true;
			elseif v70.l and string.find("lock", v68, 1, true) then
				v94 = true;
			elseif v70.powers and #v70.powers > 0 then
				for _, val10 in ipairs(v70.powers) do
					local unpack_ret1, unpack_ret2 = unpack(val10);
					local v63, _ = u2.GetPowerDir(unpack_ret1, unpack_ret2);
					if not v63 or not string.find(string.lower(v63.title), v68, 1, true) then continue end
					v94 = true;
					break;
				end
			end
		end
		v77.LayoutOrder = v69;
		if l__tradeable__74 then
			v77.Equipped.Visible = v76;
			v77.BackgroundColor3 = v76 and Color3.fromRGB(69, 239, 69) or Color3.fromRGB(39, 233, 55);
		end;
		if v52 then
			v77.Visible = u3.SearchArray(v44.pets, l__uid__72);
		elseif v67 then
			if not v94 then
				v77.Visible = false;
			else
				v77.Visible = true;
			end;
		else
			v77.Visible = true;
		end;	
	end;
	UpdatePetsScaling();
end;
function UpdatePetsScaling()
	local v102 = 1 - 1;
	while true do
		local v103 = v102 == 1 and l__Trade__7.Client.Pets or l__Trade__7.Player.Pets;
		local v104 = v103:FindFirstChildOfClass("UIGridLayout");
		local v105 = v103:FindFirstChildOfClass("UIPadding");
		local v106 = u3.ResolutionScale();
		local v107
		if v106 <= 0.5 then
			v107 = 2;
		elseif v106 <= 1.1 then
			v107 = 3;
		else
			v107 = 4;
		end;
		if u20 then
			v104.CellPadding = UDim2.new(0, 10, 0, 10);
		else
			v104.CellPadding = UDim2.new(0, 20, 0, 20);
		end;
		local v108 = (v103.AbsoluteSize.X - v103.ScrollBarThickness - v105.PaddingLeft.Offset - v105.PaddingRight.Offset) / v107 - v104.CellPadding.X.Offset;
		local v109 = UDim2.new(0, v108, 0, v108);
		if u20 then
			v109 = UDim2.new(0, v109.X.Offset / 2, 0, v109.Y.Offset / 2);
		end;
		v104.CellSize = v109;
		v104:ApplyLayout();
		local v110
		if u20 then
			v110 = 25.38;
		else
			v110 = 30;
		end;
		v103.CanvasSize = UDim2.new(0, v104.AbsoluteContentSize.X, 0, v104.AbsoluteContentSize.Y + v110);
		if 0 <= 1 then
			if v102 < 2 then

			else
				break;
			end;
		elseif 2 < v102 then

		else
			break;
		end;
		v102 = v102 + 1;	
	end;
end;
function UpdateMessageScroll()
	local l__Holder__111 = l__Trade__7.ChatOverlay.Messages.Holder;
	local v112 = l__Holder__111:FindFirstChildOfClass("UIListLayout");
	local v113 = #l__Holder__111:GetChildren() - 4;
	l__Holder__111.CanvasSize = UDim2.new(0, v112.AbsoluteContentSize.X, 0, v112.AbsoluteContentSize.Y + 30);
end;
local u36 = nil;
local u37 = nil;
function UpdateDiamonds()
	if u16 then
		if not u17 then
			return;
		end;
	else
		return;
	end;
	local v114, v115, v116, v117, v118, v119, v120, v121 = FigureOutTrade();
	local v122 = v114.diamonds or 0;
	local v123 = v115.diamonds or 0;
	if u36 then
		if u36 ~= v122 then
			u11.Play(4586418198, script, 1, 0.2);
			u8.FlashText(l__Trade__7.Client.Diamonds.Display.Input);
		end;
	end;
	if u37 then
		if u37 ~= v123 then
			u11.Play(4586418198, script, 1, 0.2);
			u8.FlashText(l__Trade__7.Player.Diamonds.Amount);
		end;
	end;
	u36 = v122;
	u37 = v123;
	l__Trade__7.Client.Diamonds.Display.Input.PlaceholderText = 0 < v122 and u3.Commas(v122) or "None";
	l__Trade__7.Player.Diamonds.Amount.Text = u3.Commas(v123);
end;
local u38 = require(l__Library__2.Variables);
function UpdateXbox()
	l__Trade__7.Client.Diamonds.Add.Visible = u38.Console;
	l__Trade__7.Client.Diamonds.Minus.Visible = u38.Console;
	l__Trade__7.Buttons.Cancel.ButtonKeybind.Visible = u38.Console;
	l__Trade__7.Buttons.Ready.ButtonKeybind.Visible = u38.Console;
end;
local u39 = Color3.fromRGB(64, 252, 59);
local u40 = Color3.fromRGB(7, 141, 34);
local u41 = nil;
local u42 = nil;
local u43 = require(l__Client__3.GIF);
function UpdateInterface()
	local v124 = nil;
	if u16 then
		if not u17 then
			return;
		end;
	else
		return;
	end;
	assert(u17);
	local v125, v126, v127, v128, v129, v130, v131, v132 = FigureOutTrade();
	local v133 = u17.targetReady;
	local v134 = u17.senderReady;
	if v129 then
		v133 = u17.senderReady;
		v134 = u17.targetReady;
	end;
	local v135 = u17.targetConfirmed;
	local v136 = u17.senderConfirmed;
	if v129 then
		v135 = u17.senderConfirmed;
		v136 = u17.targetConfirmed;
	end;
	local v137 = workspace:GetServerTimeNow() - u17.lastCounter;
	v124 = l__Trade__7.Buttons.Ready;
	local v139
	if not (u17.confirmStage == true) then
		if v133 then
			v124.Image = "rbxassetid://7045637481";
			v124.HoverImage = "rbxassetid://7045637564";
			v124.Label.Text = "Unready!";
		else
			v124.Image = "rbxassetid://7045637286";
			v124.HoverImage = "rbxassetid://7045637411";
			local v138 = math.round(3 - v137) + 1;
			if 3 < v137 then
				v139 = "Ready!";
			else
				v139 = "(" .. v138 .. ")";
			end;
			v124.Label.Text = v139;
		end;
	elseif v135 then
		v124.Image = "rbxassetid://7045637481";
		v124.HoverImage = "rbxassetid://7045637564";
		v124.Label.Text = "Unconfirm!";
	else
		v124.Image = "rbxassetid://7045637286";
		v124.HoverImage = "rbxassetid://7045637411";
		v124.Label.Text = "Confirm!";
	end;
	l__TradeBottom__8.Visible = u17.confirmStage == false;
	local v140
	if u17.confirmStage == false then
		v140 = v133;
		if not v140 then
			v140 = false;
			if u17.confirmStage == true then
				v140 = v135;
			end;
		end;
	else
		v140 = false;
		if u17.confirmStage == true then
			v140 = v135;
		end;
	end;
	local v141
	if u17.confirmStage == false then
		v141 = v134;
		if not v141 then
			v141 = false;
			if u17.confirmStage == true then
				v141 = v136;
			end;
		end;
	else
		v141 = false;
		if u17.confirmStage == true then
			v141 = v136;
		end;
	end;
	local v142 = false;
	if u17.confirmStage == false then
		v142 = v133;
	end;
	l__Trade__7.Client.Ready.Visible = v142;
	local v143 = false;
	if u17.confirmStage == false then
		v143 = v134;
	end;
	l__Trade__7.Player.Ready.Visible = v143;
	local v144 = false;
	if u17.confirmStage == true then
		v144 = v135;
	end;
	l__Trade__7.Client.Confirmed.Visible = v144;
	local v145 = false;
	if u17.confirmStage == true then
		v145 = v136;
	end;
	l__Trade__7.Player.Confirmed.Visible = v145;
	l__Trade__7.Client.ImageColor3 = v140 and u39 or u40;
	l__Trade__7.Client.Title.TextColor3 = v140 and u39 or u40;
	l__Trade__7.Client.Diamonds.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
	l__Trade__7.Client.Arrow.ImageColor3 = v140 and u39 or u40;
	l__Trade__7.Client.Pets.ScrollBarImageColor3 = v140 and u39 or u40;
	l__Trade__7.Player.ImageColor3 = v141 and u39 or u40;
	l__Trade__7.Player.Title.Title.TextColor3 = v141 and u39 or u40;
	l__Trade__7.Player.Arrow.ImageColor3 = v141 and u39 or u40;
	l__Trade__7.Player.Diamonds.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
	l__Trade__7.Player.Pets.ScrollBarImageColor3 = v141 and u39 or u40;
	l__Trade__7.Player.Title.Title.Text = v128.DisplayName;
	l__Trade__7.Player.Title.Subtitle.Text = "@" .. v128.Name;
	task.spawn(function()
		local v146 = u7.Invoke("Get Trade Suffix", v128);
		if v146 then
			l__Trade__7.Player.Title.Title.Text = v128.DisplayName .. v146;
		end;
		l__Trade__7.Player.Title.ImageLabel.Visible = false;
		local u44 = nil;
		local u45 = v129 and u17.target.UserId or u17.sender.UserId;
		pcall(function()
			u44 = game.Players:GetUserThumbnailAsync(u45, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size180x180);
		end);
		l__Trade__7.Player.Title.ImageLabel.Image = u44 ~= nil and u44 or "rbxassetid://11453721156";
		l__Trade__7.Player.Title.ImageLabel.Visible = true;
	end);
	local v147 = nil;
	if u17.confirmStage == true then
		if v136 then
			if v135 then
				if u17.confirmTick then
					if not u41 then
						u41 = u17.confirmTick;
					end;
					assert(u41);
					v147 = math.round(math.clamp(4 - (workspace:GetServerTimeNow() - u41), 0, 4) * 10) / 10;
					l__Trade__7.Notice.Text = 0 < v147 and "\226\140\155 " .. v147 .. " seconds left..." or "Waiting for both players to confirm the trade!";
				else
					u41 = nil;
					l__Trade__7.Notice.Text = "Countdown starts when both players Confirm the trade!";
				end;
			else
				u41 = nil;
				l__Trade__7.Notice.Text = "Countdown starts when both players Confirm the trade!";
			end;
		else
			u41 = nil;
			l__Trade__7.Notice.Text = "Countdown starts when both players Confirm the trade!";
		end;
	else
		u41 = nil;
		l__Trade__7.Notice.Text = "Press Ready when you are satisfied with the trade!";
	end;
	local v148 = u17.processing or v147 and v147 <= 0;
	if v148 then
		l__Trade__7.Notice.Text = "\226\140\155 Trade confirming...";
	end;
	l__Trade__7.Processing.Visible = v148;
	l__Trade__7.Player.Title.Title.Visible = not v148;
	l__Trade__7.Client.Title.Visible = not v148;
	l__Trade__7.Buttons.Visible = not v148;
	l__Trade__7.Client.Diamonds.Display.Input.TextEditable = not v148;
	if l__Trade__7.Client:FindFirstChild("PawTokens") and l__Trade__7.Client.PawTokens:FindFirstChild("Display") then
		l__Trade__7.Client.PawTokens.Display.Input.TextEditable = not v148;
	end;

	local v149
	if u20 then
		v149 = "rbxassetid://6958935961";
	else
		v149 = "rbxassetid://6958936066";
	end;
	l__Trade__7.TradeBottom.Grid.Image = v149;
	if u42 then
		if not v148 then
			u42();
			u42 = nil;
		elseif not u42 then
			if v148 then
				u42 = u43.Create(l__Trade__7.Processing.GIF, { 100, 100 }, { 5, 6 }, 28, 0.65, true);
			end;
		end;
	elseif not u42 then
		if v148 then
			u42 = u43.Create(l__Trade__7.Processing.GIF, { 100, 100 }, { 5, 6 }, 28, 0.65, true);
		end;
	end;
	l__TradeBottom__8.Visible = not v148 and u17.confirmStage == false;
	UpdateXbox();
	UpdateChat();
	UpdateMessageScroll();
end;
function ChangeDiamondAmount()
	local l__Input__150 = l__Trade__7.Client.Diamonds.Display.Input;
	if u16 then
		if u24 then
			local v151, v152, v153, v154, v155, v156, v157, v158 = FigureOutTrade();
			local v159 = u3.ParseNumberSmart(l__Input__150.Text);
			local v161
			local v162
			if v159 then
				local v160 = math.round(v159);
				if not (0 < v160) then
					if v160 == 0 then
						v161 = nil;
						v162 = nil;
						v162, v161 = u10.Invoke("Change Trade Diamonds", u24, v160);
						if v162 then
							v151.diamonds = v161;
						else
							coroutine.wrap(function()
								u12.New(v161 or "Amount is invalid. Try something else!");
							end)();
						end;
					end;
				else
					v161 = nil;
					v162 = nil;
					v162, v161 = u10.Invoke("Change Trade Diamonds", u24, v160);
					if v162 then
						v151.diamonds = v161;
					else
						coroutine.wrap(function()
							u12.New(v161 or "Amount is invalid. Try something else!");
						end)();
					end;
				end;
			end;
		end;
	end;
	l__Input__150.Text = "";
end;
-- Paw Tokens tracking variables
local u44 = nil; -- client pawTokens
local u45 = nil; -- player pawTokens
function UpdatePawTokens()
	local v114, v115, v116, v117, v118, v119, v120, v121 = FigureOutTrade();
	local v122 = v114.pawTokens or 0;
	local v123 = v115.pawTokens or 0;
	if u44 then
		if u44 ~= v122 then
			u11.Play(4586418198, script, 1, 0.2);
			u8.FlashText(l__Trade__7.Client.PawTokens.Display.Input);
		end;
	end;
	if u45 then
		if u45 ~= v123 then
			u11.Play(4586418198, script, 1, 0.2);
			u8.FlashText(l__Trade__7.Player.PawTokens.Amount);
		end;
	end;
	u44 = v122;
	u45 = v123;
	l__Trade__7.Client.PawTokens.Display.Input.PlaceholderText = 0 < v122 and u3.Commas(v122) or "None";
	l__Trade__7.Player.PawTokens.Amount.Text = u3.Commas(v123);
end;
function ChangePawTokensAmount()
	local l__Input__150 = l__Trade__7.Client.PawTokens.Display.Input;
	if u16 then
		if u24 then
			local v151, v152, v153, v154, v155, v156, v157, v158 = FigureOutTrade();
			local v159 = u3.ParseNumberSmart(l__Input__150.Text);
			local v161
			local v162
			if v159 then
				local v160 = math.round(v159);
				if not (0 < v160) then
					if v160 == 0 then
						v161 = nil;
						v162 = nil;
						v162, v161 = u10.Invoke("Change Trade PawTokens", u24, v160);
						if v162 then
							v151.pawTokens = v161;
						else
							coroutine.wrap(function()
								u12.New(v161 or "Amount is invalid. Try something else!");
							end)();
						end;
					end;
				else
					v161 = nil;
					v162 = nil;
					v162, v161 = u10.Invoke("Change Trade PawTokens", u24, v160);
					if v162 then
						v151.pawTokens = v161;
					else
						coroutine.wrap(function()
							u12.New(v161 or "Amount is invalid. Try something else!");
						end)();
					end;
				end;
			end;
		end;
	end;
	l__Input__150.Text = "";
end;

function UpdateChat()
	if u38.Console then
		l__Trade__7.Chat.Visible = false;
		return;
	end;
	if not u17 then
		return;
	end;
	assert(u17);
	local v163 = u17.sender == l__LocalPlayer__4;
	local l__ChatOverlay__164 = l__Trade__7.ChatOverlay;
	local l__Holder__165 = l__ChatOverlay__164.Messages.Holder;
	local l__PlayerLine__166 = l__Holder__165.PlayerLine;
	local l__ClientLine__167 = l__Holder__165.ClientLine;
	local l__Notification__168 = l__Trade__7.Chat.Notification;
	l__Trade__7.Chat.BackgroundColor3 = l__Trade__7.ChatOverlay.Visible and Color3.fromRGB(252, 209, 59) or Color3.fromRGB(39, 233, 55);
	l__ChatOverlay__164.Footer.Send.ImageColor3 = l__ChatOverlay__164.Footer.Message.Input.Text ~= "" and Color3.new(1, 1, 1) or Color3.new(0.5, 0.5, 0.5);
	for v169, v170 in ipairs(u17.messages) do
		if not l__Holder__165:FindFirstChild("Message" .. v169) then
			local v172 = v170.isSender and v163 or not v170.isSender and not v163;
			local v173 = v172 and l__ClientLine__167:Clone() or l__PlayerLine__166:Clone();
			v173.Name = "Message" .. v169;
			(v172 and v173.ClientMessage or v173.PlayerMessage).Label.Text = v170.message;
			if not v172 then
				local u46 = nil;
				local u47 = v163 and u17.target.UserId or u17.sender.UserId;
				pcall(function()
					u46 = game.Players:GetUserThumbnailAsync(u47, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size180x180);
				end);
				v173.ImageLabel.Image = u46 ~= nil and u46 or "rbxassetid://11453721156";
			end;
			v173:SetAttribute("Template", false);
			v173.Parent = l__Holder__165;
			v173.LayoutOrder = v173.LayoutOrder + v169;
			v173.Visible = true;
			if not l__Trade__7.ChatOverlay.Visible then
				l__Notification__168.Count.Text = tostring((tonumber(l__Notification__168.Count.Text) or 0) + 1);
				l__Notification__168.Visible = true;
			end;
			local v174
			if u38.Mobile then
				v174 = 50;
			else
				v174 = 100;
			end;
			v173.Size = UDim2.new(1, 0, 0, v174);
			task.defer(function()
				l__Holder__165.CanvasPosition = l__Holder__165.AbsoluteCanvasSize;
			end);
			local v175
			if l__ChatOverlay__164.Visible then
				v175 = "rbxassetid://11542905025";
			else
				v175 = "rbxassetid://11542904855";
			end;
			u11.Play(v175, script, 1, 1);
		end;	
	end;
end;
function FigureOutTrade()
	assert(u17);
	local v176 = u17.sender == l__LocalPlayer__4;
	return v176 and u17.senderItems or u17.targetItems, v176 and u17.targetItems or u17.senderItems, l__LocalPlayer__4, v176 and u17.target or u17.sender, v176, not v176, not v176, v176;
end;
function IsProcessing()
	if not u17 then
		return false;
	end;
	assert(u17);
	if u41 then
		if math.round(math.clamp(4 - (workspace:GetServerTimeNow() - u41), 0, 4) * 10) / 10 <= 0 then
			return true;
		end;
	end;
	return u17.processing;
end;
function IsChatting()
	return l__Trade__7.ChatOverlay.Visible;
end;
local u48 = "";
function Reset()
	u16 = false;
	u24 = nil;
	u17 = nil;
	u41 = nil;
	u36 = nil;
	u37 = nil;
	u48 = "";
	u20 = false;
	l__Trade__7.TradeBottom.TradeSearch.TradeQuery.Text = "";
	l__Trade__7.Client.Diamonds.Display.Input.Text = "";
	l__Trading__5.Enabled = false;
	local l__ChatOverlay__177 = l__Trade__7.ChatOverlay;
	local l__Notification__178 = l__Trade__7.Chat.Notification;
	l__ChatOverlay__177.Visible = false;
	l__Notification__178.Count.Text = 0;
	l__Notification__178.Visible = false;
	--[[for v182, v183 in pairs(l__ChatOverlay__177.Messages.Holder:GetChildren()) do
		if not v183:GetAttribute("Template") then
			if v183:IsA("Frame") then
				v183:Destroy();
			end;
		end;	
	end;]]--
	for _, child in pairs(l__ChatOverlay__177.Messages.Holder:GetChildren()) do
		if child.Name == "ClientLine" or child.Name == "PlayerLine" then
			for v182, v183 in pairs(child:GetChildren()) do
				if not v183:GetAttribute("Template") then
					if v183:IsA("Frame") then
						v183:Destroy();
					end;
				end;	
			end	
		end	
	end;
	for v184, v185 in ipairs(l__Trade__7.Client.Pets:GetChildren()) do
		if v185.ClassName == "TextButton" then
			v185:Destroy();
		end;	
	end;
end;
function Close()
	if u16 then
		if u16 then

		else
			return;
		end;
	else
		Reset();
		return;
	end;
	local v187, v188 = u10.Invoke("Cancel Trade", u24);
	if not v187 then
		u12.New(v188 or "Something went wrong.");
	end;
	Reset();
end;
function ToggleGrid()
	debug.profilebegin("Trading.ToggleGrid");
	u20 = not u20;
	u11.Play("rbxassetid://7004248320", script, 1, 0.5);
	debug.profileend();
end;
local u49 = false;
function readyTrade()
	if not u9 then
		if u16 then
			if not IsChatting() then
				u9 = true;
				assert(u17);
				local v189, v190, v191, v192, v193, v194, v195, v196 = FigureOutTrade();
				local v197 = u17.targetReady;
				if v193 then
					v197 = u17.senderReady;
				end;
				local v198 = u17.targetConfirmed;
				if v193 then
					v198 = u17.senderConfirmed;
				end;
				if u17.confirmStage == false then
					if not (3 < workspace:GetServerTimeNow() - u17.lastCounter) then
						u9 = false;
						return;
					end;
					local v209
					if v197 then
						if typeof(u24) == "string" then
							local v199, v200 = u10.Invoke("Unready Trade", u24);
							if not v199 then
								u12.New(v200 or "Something went wrong.");
							end;
						end;
					else
						local v201, v202, v203, v204, v205, v206, v207, v208 = FigureOutTrade();
						if not (0 < #v201.pets) then
							v209 = false;
							if 0 < v201.diamonds then
								v209 = false;
								if #v202.pets == 0 then
									v209 = v202.diamonds <= 0;
								end;
							end;
						else
							v209 = false;
							if #v202.pets == 0 then
								v209 = v202.diamonds <= 0;
							end;
						end;
						local v210 = true;
						if v209 then
							v210 = u12.New("Are you sure? You won't get anything from this trade.", true);
						end;
						if v210 then
							if typeof(u24) == "string" then
								local v211, v212 = u10.Invoke("Ready Trade", u24, u17.counter);
							end;
						end;
					end;
				elseif v198 then
					if typeof(u24) == "string" then
						local v213, v214 = u10.Invoke("Unconfirm Trade", u24);
						if not v213 then
							u12.New(v214 or "Something went wrong.");
						end;
					end;
				else
					local v215, v216, v217, v218, v219, v220, v221, v222 = FigureOutTrade();
					if not (0 < #v215.pets) then
						if 0 < v215.diamonds then
							if #v216.pets == 0 then
								if not (v216.diamonds <= 0) then

								end;
							end;
						end;
					elseif #v216.pets == 0 then
						if not (v216.diamonds <= 0) then

						end;
					end;
					local v223 = true;
					if u49 == false then
						v223 = u12.New("Are you sure? Make sure the trade is fair!", true);
						u49 = true;
					end;
					if v223 then
						if typeof(u24) == "string" then
							local v224, v225 = u10.Invoke("Confirm Trade", u24, u17.counter);
							if not v224 then
								if v225 ~= "Trade contents changed!" then
									u12.New(v225 or "Something went wrong.");
								end;
							end;
						end;
					end;
				end;
				u9 = false;
			end;
		end;
	end;
end;
function cancelTrade()
	if not u9 then
		if not IsChatting() then
			u9 = true;
			Close();
			u9 = false;
		end;
	end;
end;
function sendChatMessage()
	local v226 = nil;
	local l__Input__227 = l__Trade__7.ChatOverlay.Footer.Message.Input;
	v226 = l__Input__227.Text;
	if u17 then
		if v226 == "" then
			return;
		end;
	else
		return;
	end;
	assert(u17);
	if 200 < #v226 then
		u12.New("Your message is too long! Please keep it under 200 characters!");
		return;
	end;
	if 50 <= #u17.messages then
		u12.New("This chat is now full! You can use default chat as a backup.");
		return;
	end;
	l__Input__227.Text = "";
	local v228, v229 = u10.Invoke("Send Trade Message", u24, v226);
	if v228 then
		return;
	end;
	u12.New(v229 or "Failed to send trade message (unknown)");
end;
local u50 = require(l__Client__3.WorldCmds);
local l__RunService__51 = game:GetService("RunService");
l__Trade__7.Client.Diamonds.Display.Input.FocusLost:Connect(function()
	ChangeDiamondAmount();
end);
if l__Trade__7.Client:FindFirstChild("PawTokens") and l__Trade__7.Client.PawTokens:FindFirstChild("Display") then
	l__Trade__7.Client.PawTokens.Display.Input.FocusLost:Connect(function()
		ChangePawTokensAmount();
	end);
end
l__Trade__7.Buttons.Ready.Activated:Connect(readyTrade);
l__Trade__7.Buttons.Cancel.Activated:Connect(cancelTrade);
l__Trade__7.Chat.Activated:Connect(function()
	l__Trade__7.ChatOverlay.Visible = not l__Trade__7.ChatOverlay.Visible;
	local l__Notification__232 = l__Trade__7.Chat.Notification;
	l__Notification__232.Count.Text = 0;
	l__Notification__232.Visible = false;
end);
l__TradeBottom__8.Grid.Activated:Connect(function()
	if not u9 then
		u9 = true;
		ToggleGrid();
		u9 = false;
	end;
end);
l__Trade__7.ChatOverlay.Footer.Send.Activated:Connect(function()
	sendChatMessage();
end);
l__Trade__7.ChatOverlay.Footer.Message.Input.FocusLost:Connect(function(p5)
	if not p5 then
		return;
	end;
	sendChatMessage();
end);
l__PlayerList__4.Close.Activated:Connect(function()
	if not u9 then
		u9 = true;
		l__Trading__5.Enabled = false;
		u9 = false;
	end;
end);
l__PlayerList__4.Bottom.Search.Query:GetPropertyChangedSignal("Text"):Connect(function()
	if l__PlayerList__4.Bottom.Search.Query.Text ~= "" then
		l__PlayerList__4.Players.CanvasPosition = Vector2.new();
	end;
	RenderPlayerList();
end);
u8.ButtonFX(l__PlayerList__4.Bottom.Show.ToggleShow);
l__PlayerList__4.Bottom.Show.ToggleShow.Activated:Connect(function()
	if not u9 then
		u9 = true;
		u13 = not u13;
		u11.Play("rbxassetid://7004248320", script, 1, 0.5);
		local v233
		if u13 then
			v233 = "Friends";
		else
			v233 = "All";
		end;
		l__PlayerList__4.Bottom.Show.ToggleShow.TextLabel.Text = v233;
		RenderPlayerList();
		u9 = false;
	end;
end);
u8.ButtonFX(l__PlayerList__4.Bottom.History.ToggleHistory);
l__PlayerList__4.Bottom.History.ToggleHistory.Activated:Connect(function()
	if not u9 then
		u9 = true;
		u7.Fire("Open Trading History");
		u9 = false;
	end;
end);
u7.Fired("Resolution Changed"):Connect(function()
	task.defer(function()
		ListScrolling();
		if u16 then
			UpdatePetsScaling();
		end;
	end);
end);
u7.Fired("Open Trade List"):Connect(function()
	l__Trading__5.Enabled = true;
end);
local u52 = false;
local u53 = 0;
u7.Fired("Xbox Start Subtract"):Connect(function()
	u52 = true;
	u53 = 0;
end);
u7.Fired("Xbox Stop Subtract"):Connect(function()
	u52 = false;
	u53 = 0;
	ChangeDiamondAmount();
end);
local u54 = false;
u7.Fired("Xbox Start Add"):Connect(function()
	u54 = true;
	u53 = 0;
end);
u7.Fired("Xbox Stop Add"):Connect(function()
	u54 = false;
	u53 = 0;
	ChangeDiamondAmount();
end);
u7.Fired("Attempt Accept Trade"):Connect(readyTrade);
u7.Fired("Attempt Cancel Trade"):Connect(cancelTrade);
l__RunService__51.Heartbeat:Connect(function(p6)
	if not u38.Console then
		return;
	end;
	if u16 and u24 and (u52 or u54) then
		u53 = u53 + p6;
		local l__Diamonds__234 = l__Trade__7.Client.Diamonds;
		local v235 = math.pow(10, (math.floor(u53 / 3)));
		local v236, v237, v238, v239, v240, v241, v242, v243 = FigureOutTrade();
		local v244 = l__Diamonds__234.Display.Input:GetAttribute("Amount") or 0;
		if u52 then
			v244 = v244 - 1 * v235;
			if v244 < 10 then
				v244 = 0;
			end;
		elseif u54 then
			v244 = v244 + 1 * v235;
			if v244 < 10 then
				v244 = 10;
			end;
		end;
		if (u54 or u52) and (v244 > 0 or v244 == 0) then
			l__Diamonds__234.Display.Input.PlaceholderText = v244 > 0 and v244 or "None";
			l__Diamonds__234.Display.Input.Text = u3.Commas(v244);
			l__Diamonds__234.Display.Input:SetAttribute("Amount", v244);
		end;
	end;
end);
u10.Fired("Trade Processed"):Connect(function(p7, p8)
	print(p7, p8)
	if p7 then
		Reset();
		u11.Play(4586418071, script);
		u12.New("\226\156\133 Trade successfully completed!");
		return;
	end;
	u12.New(p8 or "Trade failed (unknown error)");
end);
u10.Fired("Init Trade"):Connect(function(p9, p10)
	u17 = p10;
	u24 = p9;
	u16 = true;
	UpdatePets();
	UpdateDiamonds();
	UpdateInterface();
	l__Trading__5.Enabled = true;
end);
u7.Invoked("Get Trade Suffix").OnInvoke = function(p11)
	if p11.UserId < 0 then
		return " (Local:" .. p11.UserId .. ")";
	end;
	if p11:GetRankInGroup(3112828) == 5 then
		return " (\240\159\148\165 Partner)";
	end;
	if u3.SearchDictionary({ 255, 50, 25, 10 }, (p11:GetRankInGroup(1072042))) then
		return " (\240\159\148\165 Staff)";
	end;
	return nil;
end;
function TradeReceived(p3, p4)
	while true do
		if u50.CanDoAction() then
			if u38.BankOpen then

			else
				break;
			end;
		end;
		l__RunService__51.Heartbeat:Wait();	
	end;
	if p4.sender then
		if not p4.sender.Parent then
			return false;
		end;
	else
		return false;
	end;
	u11.Play(4586417948, script);
	local v230 = p4.sender.DisplayName;
	local v231 = u7.Invoke("Get Trade Suffix", p4.sender);
	if v231 then
		v230 = v230 .. v231;
	end;
	return u12.New(v230 .. " sent you a trade request. Do you accept?", true);
end;
u10.Fired("Trade Recieved"):Connect(function(p12, p13)
	if TradeReceived(p12, p13) then
		u10.Fire("Accept Trade Invite", p12);
		return;
	end;
	--u10.Fire("Cancel Trade", p12);
	u10.Fire("Ignore Trade", p12);
end);
u10.Fired("Trade Cancelled"):Connect(function(p14, p15)
	if u16 and p14 == u24 then
		Reset();
		u12.New("Your trade with " .. p15.DisplayName .. " was cancelled 😔");
	end;
end);
u10.Fired("Trade Ignored"):Connect(function(p16)
	if not u16 then
		u12.New("Your trade request with " .. p16.DisplayName .. " was ignored 😔");
	end;
end);
u10.Fired("Trade Errored"):Connect(function(p17)
	u12.New("Your trade with " .. p17.DisplayName .. " could not be created. Try again!");
end);
u10.Fired("Update Trade Invites Open"):Connect(function(p18)
	u5 = p18;
end);
u10.Fired("Trade Sent Chat Result"):Connect(function(p19, p20)
	if p19 then
		u12.New("\240\159\147\169 Trade request sent!");
		return;
	end;
	u12.New(p20 or "Failed to send trade request.");
end);
u10.Fired("Update Trade"):Connect(function(p21, p22)
	if not u16 then
		u24 = p21;
		u16 = true;
	elseif u24 ~= p21 then
		return;
	end;
	u17 = p22;
end);
coroutine.wrap(function()
	while true do
		u38.Trading = u16;
		l__Trade__7.Visible = u16;
		l__PlayerList__4.Visible = not u16;
		if u16 then
			UpdatePets();
			UpdateDiamonds();
			if l__Trade__7.Client:FindFirstChild("PawTokens") then
				UpdatePawTokens();
			end;
			UpdateInterface();
		elseif l__Trading__5.Enabled then
			RenderPlayerList();
		end;
		l__RunService__51.Heartbeat:Wait();	
	end;
end)();
coroutine.wrap(function()
	while true do
		if u16 and u24 then
			u17 = u10.Invoke("Get Trade", u24) or u17;
		end;
		wait(2);	
	end;
end)();
coroutine.wrap(function()
	while true do
		if not u16 then
			u5 = u10.Invoke("Get Invites Open");
		end;
		wait(4);	
	end;
end)();
u8.Tooltip(l__TradeBottom__8.Grid, "Toggle Grid View");
u8.ButtonFX(l__PlayerList__4.Close);
u8.ButtonFX(l__Trade__7.Buttons.Ready);
u8.ButtonFX(l__Trade__7.Buttons.Cancel);
u8.ButtonFX(l__Trade__7.Chat);
u8.ButtonFX(l__Trade__7.ChatOverlay.Footer.Send);
u8.ButtonFX(l__TradeBottom__8.Grid);

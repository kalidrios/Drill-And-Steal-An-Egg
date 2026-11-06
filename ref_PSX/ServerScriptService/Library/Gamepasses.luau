-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

local v1 = {};

-- | load library | --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Library = ReplicatedStorage:WaitForChild("Library")
local ServerLibrary = ServerScriptService:WaitForChild("Library")
local Modules = Library:WaitForChild("Modules")
local Types = Library:WaitForChild("Types")

-- | shared modules | --
local Directory = require(Library.Directory)
local Signal = require(Library.Signal)
local Functions = require(Library.Functions)
local Network = require(ServerLibrary.Network)
local Settings = require(ServerLibrary.Settings)
local Saving = require(ServerLibrary.Saving)
local Analytics = require(ServerLibrary.Analytics)

local MarketplaceService = game:GetService("MarketplaceService")

local v2 = Settings.DisableGamepassAutomaticOwnership or false;
if v2 then
	warn("disableAutomaticOwnership is ENABLED. Check _L.Gamepasses (Server) for more info.");
end;
local u2 = {};
function v1.Give(p1, p2)
	local l__UserId__3 = p1.UserId;
	local v4 = Saving.Get(p1);
	if not v4 then
		return;
	end;
	local v5 = u2["u" .. l__UserId__3];
	if u2["u" .. l__UserId__3] == nil then
		u2["u" .. l__UserId__3] = {};
		v5 = u2["u" .. l__UserId__3];
	end;
	if not Functions.SearchArray(v4.Gamepasses, p2) then
		table.insert(v4.Gamepasses, p2);
		Signal.Fire("Gamepass Added", p1, p2);
		pcall(function()
			Analytics.Purchase("Gamepass", p1, p2);
		end);
		v5["g" .. p2] = true;
	end;
end;
function v1.Owns(p3, p4)
	local v6 = Saving.Get(p3);
	if v6 then
		for v7, v8 in pairs(v6.Gamepasses) do
			if tostring(v8) == tostring(p4) then
				return true;
			end;
		end;
	end;
	return false;
end;
function v1.OwnsAmount(p5)
	local v9 = 0;
	for v10, v11 in pairs(Directory.Gamepasses) do
		if v1.Owns(p5, v11.ID) then
			v9 = v9 + 1;
		end;
	end;
	return v9;
end;
function CheckPlayer(p6)
	local l__UserId__12 = p6.UserId;
	if not Saving.Get(p6) then
		return;
	end;
	local v13 = u2["u" .. l__UserId__12];
	if u2["u" .. l__UserId__12] == nil then
		u2["u" .. l__UserId__12] = {};
		v13 = u2["u" .. l__UserId__12];
	end;
	if v2 then
		return;
	end;
	for v17, v18 in pairs(Directory.Gamepasses) do 
		local l__ID__19 = v18.ID;
		if (v13["g" .. l__ID__19] or false) == false then
			local u3 = false;
			pcall(function()
				u3 = MarketplaceService:UserOwnsGamePassAsync(l__UserId__12, l__ID__19);
			end);
			if u3 == true and Settings.F2P == false then
				v1.Give(p6, l__ID__19);
			end;
		end;	
	end;
end;
function RemovePlayer(p7)
	u2["u" .. p7.UserId] = nil;
end;
MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(p8, p9, p10)
	if p8 and p10 == true then
		Network.Fire("Gamepass Bought", p8, p9);
	end;
end);
Signal.Fired("Player Added"):Connect(function(p11)
	CheckPlayer(p11);
end);
game.Players.PlayerRemoving:Connect(function(p12)
	RemovePlayer(p12);
end);
coroutine.wrap(function()
	while true do
		wait(1);
		for v20, v21 in ipairs(game.Players:GetPlayers()) do
			pcall(function()
				if v21 then
					CheckPlayer(v21);
				end;
			end);		
		end;	
	end;
end)();
return v1;

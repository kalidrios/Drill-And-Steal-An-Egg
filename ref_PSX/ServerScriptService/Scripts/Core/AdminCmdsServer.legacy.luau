--------|     Setting     |--------

--------|     Library     |--------
local _L = require(game.ReplicatedStorage:WaitForChild("Library"))

while not _L.Loaded do
	task.wait()
end

print("✅ Command System: Library is fully loaded. Initializing commands.")

--------|    Reference    |--------

--------|    Variables    |--------
local commands = {}

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--[[ 
     PERM TYPE DIRECTORY
     
     1 = Admin
     2 = Partner
     3 = Gamepass
     4 = Owner
     5 = FFlags
     
     HOW TO MIX PERMS
     type = {1, 3}
]]

function createStringByTable(tbl: table, commas: boolean): string
	local returnString = ""
	if commas then
		for _, text in ipairs(tbl) do
			returnString = (returnString == "" and " " or returnString..", ")..text
		end
	end
	return returnString
end

function addCommand(cmdData: table)
	--local cmd = cmdData["cmd"]
	local function setup(cmd: table): table
		return {
			["cmds"] = {cmdData.cmd};
			["desc"] = cmdData["desc"] or "Forgot to put description lmao";
			["permissions"] = cmdData.perms;
			["developers"] = cmdData.devs;
			["arguments"] = cmdData["arguments"];
			["permtype"] = cmdData["type"] or 1;
			["commandFunction"] = cmdData["function"];
			["neededValues"] = cmdData["neededValues"];
		}
	end

	commands[tostring(_L.Functions.DictionaryLength(commands)+1)] = setup(cmdData)
end

function getCmd(cmd: string): table
	for i, v in pairs(commands) do
		local cmds = v["cmds"]
		if table.find(cmds, cmd)~=nil then
			return v
		end
	end
	return nil
end

function getPlrByDisplay(name: string): Instance
	name = string.gsub(name, "@", "")

	for i, v in ipairs(_L.Players:GetPlayers()) do
		if v.DisplayName == name then
			return v
		end
	end

	return nil
end

function getDirVal(dir: table, value: string): table
	for k, v in pairs(dir) do
		if string.lower(string.gsub(k, " ", "")) == value then
			return k, v
		end
	end
end

function getPetIdByName(name: string): string
	--local dir = 
	for k, v in pairs(_L.Directory.Pets) do
		local module = v._script
		if not module then
			break
		end

		module = require(module)
		
		if string.lower(string.gsub(module.name, " ", "")) == name then
			return v._id
		end
	end

	return nil
end

function setupTextString(text)

end

function notification(plr: instance, text: string)
	_L.Network.Fire("Admin Cmds Notification", plr, text)
end

function getPlayerParts(plr: instance): instance
	local character = plr.Character
	if character then
		local humanoid = character.Humanoid
		if humanoid then
			local hrp = character.HumanoidRootPart
			if hrp then
				return character, humanoid, hrp
			end
		end
	end

	return nil
end

--[[ 
     TODO
     
     /e comet
     /e rap
     /e water
     /e gun
     /e gun2
     /e paintball
     /e god
     /e serverevent
     /e kickall
     /e migrateall
     /e spectate
     /e kickallbut
     /e migrateallbut
     
]]--
----------------------------------------------------------------------------------------------------------

---- COMMAND FUNCTIONS ----
function fling(plr: instance, force: number): boolean
	force = force or 100

	local char, hum, hrp = getPlayerParts(plr)
	if not char then
		return nil, "⚠️ Command failed: (Failed to get Player Parts)"
	end

	hum.Sit = true
	local velocity = Instance.new("BodyVelocity", hrp)  
	velocity.Velocity = Vector3.new(-force,force,-force) 
	velocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
	velocity.P = math.huge

	task.spawn(function()
		task.delay(1.5, function()
			velocity:Destroy()
		end)
	end)

	return true
end

function sit(plr: instance): boolean
	local char, hum, hrp = getPlayerParts(plr)
	if not char then
		return nil, "⚠️ Command failed: (Failed to get Player Parts)"
	end

	hum.Sit = true

	return true
end

function shrink(plr: instance): boolean
	local char, hum, hrp = getPlayerParts(plr)
	if not char then
		return nil, "⚠️ Command failed: (Failed to get Player Parts)"
	end

	hum.HeadScale.Value       = hum.HeadScale.Value - 0.5
	hum.BodyDepthScale.Value  = hum.BodyDepthScale.Value - 0.5
	hum.BodyWidthScale.Value  = hum.BodyWidthScale.Value - 0.5
	hum.BodyHeightScale.Value = hum.BodyHeightScale.Value - 0.5

	return true
end

function hat(plr: instance, id: number): boolean
	local char, hum, hrp = getPlayerParts(plr)
	if not char then
		return nil, "⚠️ Command failed: (Failed to get Player Parts)"
	end

	_L.InsertService:LoadAsset(id):FindFirstChildOfClass("Accessory").Parent = char

	return true
end

function freecam(plr: instance): boolean
	local char, hum, hrp = getPlayerParts(plr)
	if not char then
		return nil, "⚠️ Command failed: (Failed to get Player Parts)"
	end

	local newfreecam = _L.ServerStorage["Freecam"]:Clone()
	newfreecam.Name = "__FREECAM"
	newfreecam.Parent = plr:WaitForChild("PlayerGui")

	return true
end

function morph(plr: instance, username: string): boolean
	local char, hum, hrp = getPlayerParts(plr)
	if not char then
		return nil, "⚠️ Command failed: (Failed to get Player Parts)"
	end

	local userId = _L.Players:GetUserIdFromNameAsync(username)
	if not userId then
		return false, "⚠️ Command failed: (Failed to get morph)"
	end

	local appearance = _L.Players:GetHumanoidDescriptionFromUserId(userId)
	if not appearance then
		return false, "⚠️ Command failed: (Failed to get appearance)"
	end

	pcall(function()
		hum:ApplyDescription(appearance)
	end)

	return true
end

function squash(plr: instance): boolean
	local char, hum, hrp = getPlayerParts(plr)
	if not char then
		return nil, "⚠️ Command failed: (Failed to get Player Parts)"
	end

	hum.BodyHeightScale.Value = hum.BodyHeightScale.Value - 0.5

	return true
end

function sparkles(plr: instance): boolean
	local char, hum, hrp = getPlayerParts(plr)
	if not char then
		return nil, "⚠️ Command failed: (Failed to get Player Parts)"
	end

	Instance.new("Sparkles", hrp)

	return true
end

function bighead(plr: instance): boolean
	local char, hum, hrp = getPlayerParts(plr)
	if not char then
		return nil, "⚠️ Command failed: (Failed to get Player Parts)"
	end

	hum.HeadScale.Value = hum.HeadScale.Value + 0.5

	return true
end

function giant(plr: instance): boolean
	local char, hum, hrp = getPlayerParts(plr)
	if not char then
		return nil, "⚠️ Command failed: (Failed to get Player Parts)"
	end

	hum.HeadScale.Value       = hum.HeadScale.Value + 0.5
	hum.BodyDepthScale.Value  = hum.BodyDepthScale.Value + 0.5
	hum.BodyWidthScale.Value  = hum.BodyWidthScale.Value + 0.5
	hum.BodyHeightScale.Value = hum.BodyHeightScale.Value + 0.5

	return true
end

function walkspeed(plr: instance, speed: number): boolean
	speed = speed or 16

	local char, hum, hrp = getPlayerParts(plr)
	if not char then
		return nil, "⚠️ Command failed: (Failed to get Player Parts)"
	end

	hum.WalkSpeed = speed

	return true
end

function jumppower(plr: instance, power: number): boolean
	power = power or 16

	local char, hum, hrp = getPlayerParts(plr)
	if not char then
		return nil, "⚠️ Command failed: (Failed to get Player Parts)"
	end

	hum.JumpPower = power

	return true
end

function respawn(plr: instance): boolean
	local char, hum, hrp = getPlayerParts(plr)
	if not char then
		return nil, "⚠️ Command failed: (Failed to get Player Parts)"
	end

	plr:LoadCharacter()

	return true
end

function invisible(plr: instance, transparency: number): boolean
	transparency = transparency or 1

	local char, hum, hrp = getPlayerParts(plr)
	if not char then
		return nil, "⚠️ Command failed: (Failed to get Player Parts)"
	end

	for k, v in pairs(char:GetChildren()) do
		if v:IsA("Part") or v:IsA("MeshPart") then
			if v.Name ~= "HumanoidRootPart" then
				v.Transparency = transparency
			end	
		end
	end

	return true
end

function visible(plr: instance): boolean
	local char, hum, hrp = getPlayerParts(plr)
	if not char then
		return nil, "⚠️ Command failed: (Failed to get Player Parts)"
	end

	for k, v in pairs(char:GetChildren()) do
		if v:IsA("Part") or v:IsA("MeshPart") then
			if v.Name ~= "HumanoidRootPart" then
				v.Transparency = 0
			end	
		end
	end

	return true
end

function freeze(plr: instance): boolean
	local char, hum, hrp = getPlayerParts(plr)
	if not char then
		return nil, "⚠️ Command failed: (Failed to get Player Parts)"
	end

	hum.WalkSpeed = 0
	hum.JumpPower = 0

	return true
end

function unfreeze(plr: instance): boolean
	local char, hum, hrp = getPlayerParts(plr)
	if not char then
		return nil, "⚠️ Command failed: (Failed to get Player Parts)"
	end

	hum.WalkSpeed = 16
	hum.JumpPower = 200

	return true
end

function explode(plr: instance, pressure: number): boolean
	pressure = pressure and pressure or 500000

	local char, hum, hrp = getPlayerParts(plr)
	if not char then
		return nil, "⚠️ Command failed: (Failed to get Player Parts)"
	end

	local explosion = Instance.new("Explosion")
	explosion.Position = hrp.Position
	explosion.Parent = hrp
	explosion.BlastPressure = pressure

	return true
end

function kill(plr: instance): boolean
	local char, hum, hrp = getPlayerParts(plr)
	if not char then
		return nil, "⚠️ Command failed: (Failed to get Player Parts)"
	end

	hum.Health = 0

	return true
end

function firework(plr: instance): boolean
	local char, hum, hrp = getPlayerParts(plr)
	if not char then
		return nil, "⚠️ Command failed: (Failed to get Player Parts)"
	end

	pcall(function()
		_L.Signal.Fire("FireworkLauncher_Equip", plr)
	end)

	return true
end

function teleport(plr: instance, targetName: instance): boolean
	local char, hum, hrp = getPlayerParts(plr)
	if not char then
		return nil, "⚠️ Command failed: (Failed to get Player Parts)"
	end

	local isDisplay = targetName:find("@") ~= nil
	local plrTarget = _L.Players:FindFirstChild(targetName)

	if isDisplay then
		plrTarget = getPlrByDisplay(targetName)
		if not plrTarget then
			return  "⚠️ Command failed: (Could not find player)"
		end
	end

	local s, r = _L.Network.Invoke("Teleport To Player", plr, plrTarget)

	return s, "⚠️ Command failed: ("..r or ""..")"
end

function goto(plr: instance, targetName: instance): boolean
	local char, hum, hrp = getPlayerParts(plr)
	if not char then
		return nil, "⚠️ Command failed: (Failed to get Player Parts)"
	end

	local isDisplay = targetName:find("@") ~= nil
	local plrTarget = _L.Players:FindFirstChild(targetName)

	if isDisplay then
		plrTarget = getPlrByDisplay(targetName)
		if not plrTarget then
			return  "⚠️ Command failed: (Could not find player)"
		end
	end

	local s, r = _L.Network.Invoke("Teleport To Player", plr, plrTarget)

	return s, "⚠️ Command failed: ("..r or ""..")"
end

function world(plr: instance, world: string): boolean
	local char, hum, hrp = getPlayerParts(plr)
	if not char then
		return nil, "⚠️ Command failed: (Failed to get Player Parts)"
	end

	if not world then
		return false, "⚠️ Command failed: (Incorrect Usage)"
	end 

	local w, wd = getDirVal(_L.Directory.Worlds, world)
	if not w or not wd then
		return false, "⚠️ Command failed: (Something went wrong)"
	end
	if wd["disabled"] == true then
		return false, "⚠️ Command failed: (World is disabled)"
	end

	if _L.Worlds.HasArea(plr, wd.requiredArea) then
		_L.Network.Fire("Force Load World", plr, w)
	end

	return true
end

function shutdown(): boolean
	game.Workspace:SetAttribute("Shutdown", true)
	task.delay(2, function()
		for _, p in ipairs(game.Players:GetPlayers()) do
			p:Kick("Server Shutdown")
		end
	end)

	return true
end

function reset(plr: instance): boolean
	local char, hum, hrp = getPlayerParts(plr)
	if not char then
		return nil, "⚠️ Command failed: (Failed to get Player Parts)"
	end
	
	_L.Saving.Reset(plr)
	_L.Network.Fire("Notification", plr, "Your data has been reset.", {
		["time"] = 3,
		["color"] = Color3.fromRGB(252, 0, 4), 
		["force"] = true
	})
	
	return true
end

function ban(plr: instance, target: string, reason: string): boolean
	local char, hum, hrp = getPlayerParts(plr)
	if not char then
		return nil, "⚠️ Command failed: (Failed to get Player Parts)"
	end
	
	local userId = _L.Players:GetUserIdFromNameAsync(target)
	if not userId then
		return false, "⚠️ Command failed: (Failed to get userid)"
	end
	
	_L.Bans.Ban(userId, nil, reason)

	return true
end

function unban(plr: instance, target: string, reason: string): boolean
	local char, hum, hrp = getPlayerParts(plr)
	if not char then
		return nil, "⚠️ Command failed: (Failed to get Player Parts)"
	end

	local userId = _L.Players:GetUserIdFromNameAsync(target)
	if not userId then
		return false, "⚠️ Command failed: (Failed to get userid)"
	end

	_L.Bans.Clear(userId, nil, reason)

	return true
end

function _warn(plr: instance, target: string, reason: string): boolean
	local char, hum, hrp = getPlayerParts(plr)
	if not char then
		return nil, "⚠️ Command failed: (Failed to get Player Parts)"
	end

	local userId = _L.Players:GetUserIdFromNameAsync(target)
	if not userId then
		return false, "⚠️ Command failed: (Failed to get userid)"
	end

	_L.Bans.Warn(userId, nil, reason)

	return true
end

function kick(plr: instance): boolean
	local char, hum, hrp = getPlayerParts(plr)
	if not char then
		return nil, "⚠️ Command failed: (Failed to get Player Parts)"
	end

	plr:kick("Please Rejoin.")

	return true
end

function announce(message: instance): boolean
	local msg = ""
	for i, v in ipairs(message) do
		if i ~= 1 and i ~= 2 then
			msg = (msg == "" and "" or msg.." ") .. v
		end
	end
	
	for _, plr in ipairs(_L.Players:GetPlayers()) do
		_L.Network.Fire("Notification", plr, msg, {
			time = 15, 
			color = Color3.fromRGB(78, 244, 252), 
			force = true
		})
	end
	return true
end

function globalAnnounce(message: instance): boolean
	local msg = ""
	for i, v in ipairs(message) do
		if i ~= 1 and i ~= 2 then
			msg = (msg == "" and "" or msg.." ") .. v
		end
	end
	
	_L.MessagingService:PublishAsync("GlobalAnnounce", msg)
	return true
end

_L.MessagingService:SubscribeAsync("GlobalAnnounce", function(data)
	local msg = data.Data
	for _, plr in ipairs(_L.Players:GetPlayers()) do
		_L.Network.Fire("Notification", plr, msg, {
			time = 15, 
			color = Color3.fromRGB(78, 244, 252), 
			force = true
		})
	end
end)

function fflags(plr: instance): boolean
	local char, hum, hrp = getPlayerParts(plr)
	if not char then
		return nil, "⚠️ Command failed: (Failed to get Player Parts)"
	end

	_L.Network.Fire("Open FFlags", plr)

	return true
end

function pet(plr: instance, id: string, raritys: string, amount: number): boolean
	raritys = raritys or ""
	amount = amount or 1
	
	if not (id and raritys and amount) then
		return nil, "⚠️ Command failed: (Incorrect Usage)"
	end
	
	local char, hum, hrp = getPlayerParts(plr)
	if not char then
		return nil, "⚠️ Command failed: (Failed to get Player Parts)"
	end
	
	local specialRaritys = {
		--["example"] = {
		--	variable = "hc";
		--	stat = true
		--}
	}
	local allowedRaritys = {"g","r","d","h","s"}
	local specifics = {["d"] = "dm", ["h"] = "hc", ["s"] = "sh"}
	local petRaritys = {}
	
	for i = 1,#raritys do
		local rarity = string.sub(raritys,i,i)
		if table.find(allowedRaritys,rarity) then
			if specialRaritys[rarity] then
				local spcial = specialRaritys[rarity]
				petRaritys[spcial.variable] = spcial.stat
				continue
			end
			if specifics[rarity] then rarity = specifics[rarity] end
			petRaritys[rarity] = true
		end
	end
	
	if not _L.Directory.Pets[id] then
		id = getPetIdByName(id)
		if not _L.Directory.Pets[id] then
			return nil, "⚠️ Command failed: (Failed to get pet id)"
		end
	end
	
	for _ = 1, amount do
		_L.Pets.Create(plr,id,petRaritys)
	end	

	return true
end

function merch(plr: instance, id: string): boolean
	local char, hum, hrp = getPlayerParts(plr)
	if not char then
		return nil, "⚠️ Command failed: (Failed to get Player Parts)"
	end
	
	if not _L.Directory.Pets[id] then
		id = getPetIdByName(id)
		if not _L.Directory.Pets[id] then
			return nil, "⚠️ Command failed: (Failed to get pet id)"
		end
	end

	return _L.Signal.Invoke("Create Merch Code",plr,id), "⚠️ Command failed: (Something went wrong)"
end

function mastery(plr: instance, mastery: string, progress: number): boolean
	local char, hum, hrp = getPlayerParts(plr)
	if not char then
		return nil, "⚠️ Command failed: (Failed to get Player Parts)"
	end
	
	local fixedMastery, data = getDirVal(_L.Directory.Mastery, mastery)
	if not mastery then
		return false, "⚠️ Command failed: (Failed to get mastery directory)"
	end
	_L.Mastery.Progress(plr, fixedMastery, progress or 1)
	
	return true
end

function rankup(plr: instance): boolean
	local char, hum, hrp = getPlayerParts(plr)
	if not char then
		return nil, "⚠️ Command failed: (Failed to get Player Parts)"
	end

	local nextRank = _L.Ranks.GetNextRank(plr)
	if nextRank then
		_L.Ranks.Give(plr, nextRank) 
	end

	return true
end

function hoverboards(plr: instance, hoverboard: string): boolean
	local char, hum, hrp = getPlayerParts(plr)
	if not char then
		return nil, "⚠️ Command failed: (Failed to get Player Parts)"
	end
	
	local hb, dir = getDirVal(_L.Directory.Hoverboards, hoverboard)
	if not hb or not dir then
		return nil, "⚠️ Command failed: (Something went wrong)"
	end
	
	_G.UnlockHoverboard(hb)
	
	return true
end

function boosts(plr: instance, boost: string, amount: number): boolean
	local char, hum, hrp = getPlayerParts(plr)
	if not char then
		return nil, "⚠️ Command failed: (Failed to get Player Parts)"
	end
	
	local boosts = {["tripledamage"] = "Triple Damage", ["triplecoins"] = "Triple Coins", ["superlucky"] = "Super Lucky", ["ultralucky"] = "Ultra Lucky"}
	local boost = boosts[boost]
	if not boost then
		return false, "⚠️ Command failed: (Something went wrong)"
	end

	_L.Boosts.Give(plr, boost, amount)

	return true
end

function gamepass(plr: instance, pass: string): boolean
	local char, hum, hrp = getPlayerParts(plr)
	if not char then
		return nil, "⚠️ Command failed: (Failed to get Player Parts)"
	end
	
	local gamepass, data = getDirVal(_L.Directory.Gamepasses, pass)  
	if not gamepass or not data then
		return false, "⚠️ Command failed: (Incorrect Usage)"
	end
	
	_L.Gamepasses.Give(plr, gamepass)

	return true
end

function product(plr: instance, duct: string): boolean
	local char, hum, hrp = getPlayerParts(plr)
	if not char then
		return nil, "⚠️ Command failed: (Failed to get Player Parts)"
	end

	local product, data = getDirVal(_L.Directory.Gamepasses, duct)  
	if not product or not data then
		return false, "⚠️ Command failed: (Incorrect Usage)"
	end

	data.Callback(plr, {})

	return true
end

function giveCurrency(currency: string, plr: instance, amount: number): boolean
	local char, hum, hrp = getPlayerParts(plr)
	if not char then
		return nil, "⚠️ Command failed: (Failed to get Player Parts)"
	end
	_L.Give.Currency(plr, amount or 1, currency)
	return true
end

function slots(plr: instance, amount: number): boolean
	local char, hum, hrp = getPlayerParts(plr)
	if not char then
		return nil, "⚠️ Command failed: (Failed to get Player Parts)"
	end
	_L.Give.Slots(plr, amount or 1)
	return true
end

function givefruit(plr: instance, f: string, amount: number): boolean
	local char, hum, hrp = getPlayerParts(plr)
	if not char then
		return nil, "⚠️ Command failed: (Failed to get Player Parts)"
	end
	local fruit = getDirVal(_L.Directory.Fruits, f)
	if not fruit then
		return false, "⚠️ Command failed: (Failed to get Fruit)"
	end
	_L.Fruit.Give(plr, fruit, amount or 1)
	return true
end

function test(plr: instance, command: string): boolean
	local char, hum, hrp = getPlayerParts(plr)
	if not char then
		return nil, "⚠️ Command failed: (Failed to get Player Parts)"
	end
	if command == "spin" then
		local s = _L.Signal.Invoke("SpinTest", plr)
		warn(s)
	end
	return true
end

----------------------------------------------------------------------------------------------------------

---- COMMANDS ----

-- FLING
addCommand({
	["cmd"] = "fling";
	["desc"] = "Fling players around the map!";
	["perms"] = {"igotbanndforagroup", "Developers", "Admins", "Moderators", "Partners", "Gamepass"};
	["devs"] = {"igotbanndforagroup"};
	["arguments"] = {{"Player", nil, "Player"},{"Number",nil,"Force"}};
	["type"] = {
		1; -- admin
		2; -- partner
		3; -- gamepass
	};
	["function"] = fling;
	["neededValues"] = {
		["plr"] = {
			needed = true;
			placement = 1;
		};
		["sL"] = {
			{
				needed = true;
				placement = 2;
				index = 4;
			}
		};
		["s"] = {};
	};
})

-- SIT
addCommand({
	["cmd"] = "sit";
	["desc"] = "Make players sit down!";
	["perms"] = {"igotbanndforagroup", "Developers", "Admins", "Moderators", "Partners", "Gamepass"};
	["devs"] = {"igotbanndforagroup"};
	["arguments"] = {{"Player", nil, "Player"}};
	["type"] = {
		1; -- admin
		2; -- partner
		3; -- gamepass
	};
	["function"] = sit;
	["neededValues"] = {
		["plr"] = {
			needed = true;
			placement = 1;
		};
		["sL"] = {};
		["s"] = {};
	};
})

-- SHRINK
addCommand({
	["cmd"] = "shrink";
	["desc"] = "Shrink people down and make them small!";
	["perms"] = {"igotbanndforagroup", "Developers", "Admins", "Moderators", "Partners", "Gamepass"};
	["devs"] = {"igotbanndforagroup"};
	["arguments"] = {{"Player", nil, "Player"}};
	["type"] = {
		1; -- admin
		2; -- partner
		3; -- gamepass
	};
	["function"] = shrink;
	["neededValues"] = {
		["plr"] = {
			needed = true;
			placement = 1;
		};
		["sL"] = {};
		["s"] = {};
	};
})

-- HAT
addCommand({
	["cmd"] = "hat";
	["desc"] = "Give any player a hat!";
	["perms"] = {"igotbanndforagroup", "Developers", "Admins", "Moderators", "Partners", "Gamepass"};
	["devs"] = {"igotbanndforagroup"};
	["arguments"] = {{"Player", nil, "Player"},{"Number", nil, "ID"}};
	["type"] = {
		1; -- admin
		2; -- partner
		3; -- gamepass
	};
	["function"] = hat;
	["neededValues"] = {
		["plr"] = {
			needed = true;
			placement = 1;
		};
		["sL"] = {
			{
				needed = true;
				placement = 2;
				index = 4;
			}
		};
		["s"] = {};
	};
})

-- FREECAM
addCommand({
	["cmd"] = "freecam";
	["desc"] = "Enable a freecamera that people can move there camera around with!";
	["perms"] = {"igotbanndforagroup", "Developers", "Admins", "Moderators", "Partners", "Gamepass"};
	["devs"] = {"igotbanndforagroup"};
	["arguments"] = {{"Player", nil, "Player"}};
	["type"] = {
		1; -- admin
		2; -- partner
		3; -- gamepass
	};
	["function"] = freecam;
	["neededValues"] = {
		["plr"] = {
			needed = true;
			placement = 1;
		};
		["sL"] = {};
		["s"] = {};
	};
})

-- MORPH
addCommand({
	["cmd"] = "morph";
	["desc"] = "Turn anyone into any player!";
	["perms"] = {"igotbanndforagroup", "Developers", "Admins", "Moderators", "Partners", "Gamepass"};
	["devs"] = {"igotbanndforagroup"};
	["arguments"] = {{"Player", nil, "Player"},{"String", nil, "Username"}};
	["type"] = {
		1; -- admin
		2; -- partner
		3; -- gamepass
	};
	["function"] = morph;
	["neededValues"] = {
		["plr"] = {
			needed = true;
			placement = 1;
		};
		["sL"] = {
			{
				needed = true;
				placement = 2;
				index = 4;
			}
		};
		["s"] = {};
	};
})

-- SQUASH
addCommand({
	["cmd"] = "squash";
	["desc"] = "Squash people like a pancake!";
	["perms"] = {"igotbanndforagroup", "Developers", "Admins", "Moderators", "Partners", "Gamepass"};
	["devs"] = {"igotbanndforagroup"};
	["arguments"] = {{"Player", nil, "Player"}};
	["type"] = {
		1; -- admin
		2; -- partner
		3; -- gamepass
	};
	["function"] = squash;
	["neededValues"] = {
		["plr"] = {
			needed = true;
			placement = 1;
		};
		["sL"] = {};
		["s"] = {};
	};
})

-- SPARKLES
addCommand({
	["cmd"] = "sparkles";
	["desc"] = "Make people sparkley!";
	["perms"] = {"igotbanndforagroup", "Developers", "Admins", "Moderators", "Partners", "Gamepass"};
	["devs"] = {"igotbanndforagroup"};
	["arguments"] = {{"Player", nil, "Player"}};
	["type"] = {
		1; -- admin
		2; -- partner
		3; -- gamepass
	};
	["function"] = sparkles;
	["neededValues"] = {
		["plr"] = {
			needed = true;
			placement = 1;
		};
		["sL"] = {};
		["s"] = {};
	};
})

-- BIGHEAD
addCommand({
	["cmd"] = "bighead";
	["desc"] = "Make players heads grow!";
	["perms"] = {"igotbanndforagroup", "Developers", "Admins", "Moderators", "Partners", "Gamepass"};
	["devs"] = {"igotbanndforagroup"};
	["arguments"] = {{"Player", nil, "Player"}};
	["type"] = {
		1; -- admin
		2; -- partner
		3; -- gamepass
	};
	["function"] = bighead;
	["neededValues"] = {
		["plr"] = {
			needed = true;
			placement = 1;
		};
		["sL"] = {};
		["s"] = {};
	};
})

-- GIANT
addCommand({
	["cmd"] = "giant";
	["desc"] = "Grow people and make them BIG!";
	["perms"] = {"igotbanndforagroup", "Developers", "Admins", "Moderators", "Partners", "Gamepass"};
	["devs"] = {"igotbanndforagroup"};
	["arguments"] = {{"Player", nil, "Player"}};
	["type"] = {
		1; -- admin
		2; -- partner
		3; -- gamepass
	};
	["function"] = giant;
	["neededValues"] = {
		["plr"] = {
			needed = true;
			placement = 1;
		};
		["sL"] = {};
		["s"] = {};
	};
})

-- WALKSPEED
addCommand({
	["cmd"] = "walkspeed";
	["desc"] = "Change players walkspeed!";
	["perms"] = {"igotbanndforagroup", "Developers", "Admins", "Moderators", "Gamepass"};
	["devs"] = {"igotbanndforagroup"};
	["arguments"] = {{"Player", nil, "Player"},{"Number", nil, "Speed"}};
	["type"] = {
		1; -- admin
		3; -- gamepass
	};
	["function"] = walkspeed;
	["neededValues"] = {
		["plr"] = {
			needed = true;
			placement = 1;
		};
		["sL"] = {
			{
				needed = true;
				placement = 2;
				index = 4;
			}
		};
		["s"] = {};
	};
})

-- JUMPPOWER
addCommand({
	["cmd"] = "jumppower";
	["desc"] = "Change players jump power!";
	["perms"] = {"igotbanndforagroup", "Developers", "Admins", "Moderators", "Gamepass"};
	["devs"] = {"igotbanndforagroup"};
	["arguments"] = {{"Player", nil, "Player"},{"Number", nil, "Power"}};
	["type"] = {
		1; -- admin
		3; -- gamepass
	};
	["function"] = jumppower;
	["neededValues"] = {
		["plr"] = {
			needed = true;
			placement = 1;
		};
		["sL"] = {
			{
				needed = true;
				placement = 2;
				index = 4;
			}
		};
		["s"] = {};
	};
})

-- RESPAWN
addCommand({
	["cmd"] = "respawn";
	["desc"] = "Make players respawn!";
	["perms"] = {"igotbanndforagroup", "Developers", "Admins"};
	["devs"] = {"igotbanndforagroup"};
	["arguments"] = {{"Player", nil, "Player"}};
	["type"] = {
	};
	["function"] = respawn;
	["neededValues"] = {
		["plr"] = {
			needed = true;
			placement = 1;
		};
		["sL"] = {};
		["s"] = {};
	};
})

-- INVISIBLE
addCommand({
	["cmd"] = "invisible";
	["desc"] = "Turn players invisible!";
	["perms"] = {"igotbanndforagroup", "Developers", "Admins", "Moderators"};
	["devs"] = {"igotbanndforagroup"};
	["arguments"] = {{"Player", nil, "Player"},{"Number", nil, "Transparency"}};
	["type"] = {
		1; -- admin
	};
	["function"] = invisible;
	["neededValues"] = {
		["plr"] = {
			needed = true;
			placement = 1;
		};
		["sL"] = {
			{
				needed = true;
				placement = 2;
				index = 4;
			}
		};
		["s"] = {};
	};
})

-- VISIBLE
addCommand({
	["cmd"] = "visible";
	["desc"] = "Turn players visible!";
	["perms"] = {"igotbanndforagroup", "Developers", "Admins", "Moderators"};
	["devs"] = {"igotbanndforagroup"};
	["arguments"] = {{"Player", nil, "Player"}};
	["type"] = {
		1; -- admin
	};
	["function"] = visible;
	["neededValues"] = {
		["plr"] = {
			needed = true;
			placement = 1;
		};
		["sL"] = {};
		["s"] = {};
	};
})

-- FREEZE
addCommand({
	["cmd"] = "freeze";
	["desc"] = "Make players frozen!";
	["perms"] = {"igotbanndforagroup", "Developers", "Admins", "Moderators"};
	["devs"] = {"igotbanndforagroup"};
	["arguments"] = {{"Player", nil, "Player"}};
	["type"] = {
		1; -- admin
	};
	["function"] = freeze;
	["neededValues"] = {
		["plr"] = {
			needed = true;
			placement = 1;
		};
		["sL"] = {};
		["s"] = {};
	};
})

-- UNFREEZE
addCommand({
	["cmd"] = "unfreeze";
	["desc"] = "Unfreeze frozen players!";
	["perms"] = {"igotbanndforagroup", "Developers", "Admins", "Moderators"};
	["devs"] = {"igotbanndforagroup"};
	["arguments"] = {{"Player", nil, "Player"}};
	["type"] = {
		1; -- admin
	};
	["function"] = unfreeze;
	["neededValues"] = {
		["plr"] = {
			needed = true;
			placement = 1;
		};
		["sL"] = {};
		["s"] = {};
	};
})

-- EXPLODE
addCommand({
	["cmd"] = "explode";
	["desc"] = "Explode players like a bomb!";
	["perms"] = {"igotbanndforagroup", "Developers", "Admins"};
	["devs"] = {"igotbanndforagroup"};
	["arguments"] = {{"Player", nil, "Player"},{"Number", nil, "Pressure"}};
	["type"] = {
	};
	["function"] = explode;
	["neededValues"] = {
		["plr"] = {
			needed = true;
			placement = 1;
		};
		["sL"] = {
			{
				needed = true;
				placement = 2;
				index = 4;
			}
		};
		["s"] = {};
	};
})

-- KILL
addCommand({
	["cmd"] = "kill";
	["desc"] = "Kill players!";
	["perms"] = {"igotbanndforagroup", "Developers", "Admins"};
	["devs"] = {"igotbanndforagroup"};
	["arguments"] = {{"Player", nil, "Player"}};
	["type"] = {
	};
	["function"] = kill;
	["neededValues"] = {
		["plr"] = {
			needed = true;
			placement = 1;
		};
		["sL"] = {};
		["s"] = {};
	};
})

-- FIREWORK
addCommand({
	["cmd"] = "firework";
	["desc"] = "Give players a firework launcher!";
	["perms"] = {"igotbanndforagroup", "Developers", "Admins", "Moderators"};
	["devs"] = {"igotbanndforagroup"};
	["arguments"] = {{"Player", nil, "Player"}};
	["type"] = {
		1; -- admin
	};
	["function"] = firework;
	["neededValues"] = {
		["plr"] = {
			needed = true;
			placement = 1;
		};
		["sL"] = {};
		["s"] = {};
	};
})

-- TELEPORT
addCommand({
	["cmd"] = "teleport";
	["desc"] = "Teleport players to other players!";
	["perms"] = {"igotbanndforagroup", "Developers", "Admins", "Moderators"};
	["devs"] = {"igotbanndforagroup"};
	["arguments"] = {{"Player", nil, "Player"},{"Player", nil, "Player"}};
	["type"] = {
		1; -- admin
	};
	["function"] = teleport;
	["neededValues"] = {
		["plr"] = {
			needed = true;
			placement = 1;
		};
		["sL"] = {
			{
				needed = true;
				placement = 2;
				index = 4;
			}
		};
		["s"] = {};
	};
})

-- GOTO
addCommand({
	["cmd"] = "goto";
	["desc"] = "Teleport to other players!";
	["perms"] = {"igotbanndforagroup", "Developers", "Admins", "Moderators"};
	["devs"] = {"igotbanndforagroup"};
	["arguments"] = {{"Player", nil, "Player"}};
	["type"] = {
		1; -- admin
	};
	["function"] = goto;
	["neededValues"] = {
		["plr"] = {
			needed = true;
			placement = 1;
			user = true;
		};
		["sL"] = {
			{
				needed = true;
				placement = 2;
				index = 3;
			}
		};
		["s"] = {};
	};
})

-- WORLD
addCommand({
	["cmd"] = "world";
	["desc"] = "Teleport people to any world they own!";
	["perms"] = {"igotbanndforagroup", "Developers", "Admins", "Moderators"};
	["devs"] = {"igotbanndforagroup"};
	["arguments"] = {{"Player", nil, "Player"},{"String", nil, "World"}};
	["type"] = {
		1; -- admin
	};
	["function"] = world;
	["neededValues"] = {
		["plr"] = {
			needed = true;
			placement = 1;
		};
		["sL"] = {
			{
				needed = true;
				placement = 2;
				index = 4;
			}
		};
		["s"] = {};
	};
})

-- SHUTDOWN
addCommand({
	["cmd"] = "shutdown";
	["desc"] = "Shutdown the server you're in!";
	["perms"] = {"igotbanndforagroup", "Developers", "Admins"};
	["devs"] = {"igotbanndforagroup"};
	["arguments"] = {};
	["type"] = {
	};
	["function"] = shutdown;
	["neededValues"] = {
		["plr"] = {
			needed = false;
			placement = 1;
		};
		["sL"] = {};
		["s"] = {};
	};
})

-- BAN
addCommand({
	["cmd"] = "ban";
	["desc"] = "Permanently ban players!";
	["perms"] = {"igotbanndforagroup", "Developers"};
	["devs"] = {"igotbanndforagroup"};
	["arguments"] = {{"Player", nil, "Player"},{"String", nil, "Reason"}};
	["type"] = {
	};
	["function"] = ban;
	["neededValues"] = {
		["plr"] = {
			needed = true;
			placement = 1;
			user = true;
		};
		["sL"] = {
			{
				needed = true;
				placement = 2;
				index = 3;
			};
			{
				needed = true;
				placement = 3;
				index = 4;
			}
		};
		["s"] = {};
	};
})

-- UNBAN
addCommand({
	["cmd"] = "unban";
	["desc"] = "unban players!";
	["perms"] = {"igotbanndforagroup", "Developers"};
	["devs"] = {"igotbanndforagroup"};
	["arguments"] = {{"Player", nil, "Player"},{"String", nil, "Reason"}};
	["type"] = {
	};
	["function"] = unban;
	["neededValues"] = {
		["plr"] = {
			needed = true;
			placement = 1;
			user = true;
		};
		["sL"] = {
			{
				needed = true;
				placement = 2;
				index = 3;
			};
			{
				needed = true;
				placement = 3;
				index = 4;
			}
		};
		["s"] = {};
	};
})

-- WARN
addCommand({
	["cmd"] = "warn";
	["desc"] = "warn players!";
	["perms"] = {"igotbanndforagroup", "Developers", "Admins"};
	["devs"] = {"igotbanndforagroup"};
	["arguments"] = {{"Player", nil, "Player"},{"String", nil, "Reason"}};
	["type"] = {
	};
	["function"] = _warn;
	["neededValues"] = {
		["plr"] = {
			needed = true;
			placement = 1;
			user = true;
		};
		["sL"] = {
			{
				needed = true;
				placement = 2;
				index = 3;
			};
			{
				needed = true;
				placement = 3;
				index = 4;
			}
		};
		["s"] = {};
	};
})

-- KICK
addCommand({
	["cmd"] = "kick";
	["desc"] = "Kick players from a server!";
	["perms"] = {"igotbanndforagroup", "Developers", "Admins"};
	["devs"] = {"igotbanndforagroup"};
	["arguments"] = {{"Player", nil, "Player"}};
	["type"] = {

	};
	["function"] = kick;
	["neededValues"] = {
		["plr"] = {
			needed = true;
			placement = 1;
		};
		["sL"] = {};
		["s"] = {};
	};
})

-- RESET
addCommand({
	["cmd"] = "reset";
	["desc"] = "Reset a players data!";
	["perms"] = {"igotbanndforagroup"};
	["devs"] = {"igotbanndforagroup"};
	["arguments"] = {{"Player", nil, "Player"}};
	["type"] = {
		4; -- igotbanndforagroup
	};
	["function"] = reset;
	["neededValues"] = {
		["plr"] = {
			needed = true;
			placement = 1;
		};
		["sL"] = {};
		["s"] = {};
	};
})

-- ANNOUNCE
addCommand({
	["cmd"] = "announce";
	["desc"] = "Announce a message to a server!";
	["perms"] = {"igotbanndforagroup"};
	["devs"] = {"igotbanndforagroup"};
	["arguments"] = {{"String", nil, "Message"}};
	["type"] = {
		4; -- igotbanndforagroup
	};
	["function"] = announce;
	["neededValues"] = {
		["plr"] = {
			needed = false;
			placement = 1;
		};
		["sL"] = {};
		["s"] = {
			needed = true;
			placement = 1;
			index = 3;
			all = true;
		};
	};
})

-- GLOBAL ANNOUNCE
addCommand({
	["cmd"] = "globalannounce";
	["desc"] = "Announce a message to every server!";
	["perms"] = {"igotbanndforagroup"};
	["devs"] = {"igotbanndforagroup"};
	["arguments"] = {{"String", nil, "Message"}};
	["type"] = {
		4; -- igotbanndforagroup
	};
	["function"] = globalAnnounce;
	["neededValues"] = {
		["plr"] = {
			needed = false;
			placement = 1;
		};
		["sL"] = {};
		["s"] = {
			needed = true;
			placement = 1;
			index = 3;
			all = true;
		};
	};
})

-- FFLAGS
addCommand({
	["cmd"] = "fflags";
	["desc"] = "Enable the FFlags gui!";
	["perms"] = {"igotbanndforagroup"};
	["devs"] = {"igotbanndforagroup"};
	["arguments"] = {{"Player", nil, "Player"}};
	["type"] = {
		 5; -- fflags
	};
	["function"] = fflags;
	["neededValues"] = {
		["plr"] = {
			needed = true;
			placement = 1;
		};
		["sL"] = {};
		["s"] = {};
	};
})

-- PET
-addCommand({
	["cmd"] = "pet";
	["desc"] = "Give players pets!";
	["perms"] = {"igotbanndforagroup", "Moderators"};
	["devs"] = {"igotbanndforagroup"};
	["arguments"] = {{"Player", nil, "Player"},{"String", nil, "Pet"},{"String", nil, "Raritys"},{"Number", nil, "Amount"}};
	["type"] = {
		4; -- igotbanndforagroup
		1; -- igotbanndforagroup
	};
	["function"] = pet;
	["neededValues"] = {
		["plr"] = {
			needed = true;
			placement = 1;
		};
		["sL"] = {};
		["s"] = {
			{
				needed = true;
				placement = 2;
				index = 4;
			};
			{
				needed = true;
				placement = 3;
				index = 5;
			};
			{
				needed = true;
				placement = 4;
				index = 6;
			};
		};
	};
})

-- MERCH
addCommand({
	["cmd"] = "merch";
	["desc"] = "Create a merch code!";
	["perms"] = {"igotbanndforagroup", "Moderators"};
	["devs"] = {"igotbanndforagroup"};
	["arguments"] = {{"Player", nil, "Player"}};
	["type"] = {
		4; -- igotbanndforagroup
        1; 
	};
	["function"] = merch;
	["neededValues"] = {
		["plr"] = {
			needed = true;
			placement = 1;
			user = true;
		};
		["sL"] = {};
		["s"] = {
			{
				needed = true;
				placement = 2;
				index = 4;
			};
		};
	};
})

-- MASTERY
addCommand({
	["cmd"] = "mastery";
	["desc"] = "Give players mastery progress!";
	["perms"] = {"igotbanndforagroup", "Moderators"};
	["devs"] = {"igotbanndforagroup"};
	["arguments"] = {{"Player", nil, "Player"},{"String", nil, "Mastery"},{"Number", nil, "Progress"}};
	["type"] = {
		4; -- igotbanndforagroup
        1;
	};
	["function"] = mastery;
	["neededValues"] = {
		["plr"] = {
			needed = true;
			placement = 1;
		};
		["sL"] = {};
		["s"] = {
			{
				needed = true;
				placement = 2;
				index = 4;
			};
			{
				needed = true;
				placement = 3;
				index = 5;
			};
		};
	};
})

-- RANKUP
addCommand({
	["cmd"] = "rankup";
	["desc"] = "Upgrade players ranks!";
	["perms"] = {"igotbanndforagroup"};
	["devs"] = {"igotbanndforagroup"};
	["arguments"] = {{"Player", nil, "Player"}};
	["type"] = {
		4; -- igotbanndforagroup
	};
	["function"] = rankup;
	["neededValues"] = {
		["plr"] = {
			needed = true;
			placement = 1;
		};
		["sL"] = {};
		["s"] = {};
	};
})

-- HOVERBOARDS
addCommand({
	["cmd"] = "hoverboards";
	["desc"] = "Give players every hoverboard!";
	["perms"] = {"igotbanndforagroup", "Moderators"};
	["devs"] = {"igotbanndforagroup"};
	["arguments"] = {{"Player", nil, "Player"}};
	["type"] = {
		4; -- igotbanndforagroup
		1; -- igotbanndforagroup
	};
	["function"] = hoverboards;
	["neededValues"] = {
		["plr"] = {
			needed = true;
			placement = 1;
		};
		["sL"] = {
			{
				needed = true;
				placement = 2;
				index = 4;
			};
		};
		["s"] = {};
	};
})

-- GAMEPASS
addCommand({
	["cmd"] = "gamepass";
	["desc"] = "Give players gamepasses!";
	["perms"] = {"igotbanndforagroup", "Moderators"};
	["devs"] = {"igotbanndforagroup"};
	["arguments"] = {{"Player", nil, "Player"},{"String", nil, "Gamepass"}};
	["type"] = {
		4; -- igotbanndforagroup
		1; -- igotbanndforagroup
	};
	["function"] = gamepass;
	["neededValues"] = {
		["plr"] = {
			needed = true;
			placement = 1;
		};
		["sL"] = {
			{
				needed = true;
				placement = 2;
				index = 4;
			};
		};
		["s"] = {};
	};
})

-- PRODUCTS
addCommand({
	["cmd"] = "product";
	["desc"] = "Give players products!";
	["perms"] = {"igotbanndforagroup"};
	["devs"] = {"igotbanndforagroup"};
	["arguments"] = {{"Player", nil, "Player"},{"String", nil, "Product"}};
	["type"] = {
		4; -- igotbanndforagroup
	};
	["function"] = product;
	["neededValues"] = {
		["plr"] = {
			needed = true;
			placement = 1;
		};
		["sL"] = {
			{
				needed = true;
				placement = 2;
				index = 4;
			};
		};
		["s"] = {};
	};
})

-- COINS
addCommand({
	["cmd"] = "coins";
	["desc"] = "Give players coins!";
	["perms"] = {"igotbanndforagroup", "Moderators"};
	["devs"] = {"igotbanndforagroup"};
	["arguments"] = {{"Player", nil, "Player"},{"Number", nil, "Amount"}};
	["type"] = {
		4; -- igotbanndforagroup
         1;
	};
	["function"] = function(...)
	    return giveCurrency("Coins",...)	
	end;
	["neededValues"] = {
		["plr"] = {
			needed = true;
			placement = 1;
		};
		["sL"] = {
			{
				needed = true;
				placement = 2;
				index = 4;
			};
		};
		["s"] = {};
	};
})

-- DIAMONDS
addCommand({
	["cmd"] = "diamonds";
	["desc"] = "Give players diamonds!";
	["perms"] = {"igotbanndforagroup", "Moderators"};
	["devs"] = {"igotbanndforagroup"};
	["arguments"] = {{"Player", nil, "Player"},{"Number", nil, "Amount"}};
	["type"] = {
		4; -- igotbanndforagroup
         1;
	};
	["function"] = function(...)
		return giveCurrency("Diamonds",...)	
	end;
	["neededValues"] = {
		["plr"] = {
			needed = true;
			placement = 1;
		};
		["sL"] = {
			{
				needed = true;
				placement = 2;
				index = 4;
			};
		};
		["s"] = {};
	};
})

-- FANTASYCOINS
addCommand({
	["cmd"] = "fantasycoins";
	["desc"] = "Give players fantasy coins!";
	["perms"] = {"igotbanndforagroup", "Moderators"};
	["devs"] = {"igotbanndforagroup"};
	["arguments"] = {{"Player", nil, "Player"},{"Number", nil, "Amount"}};
	["type"] = {
		4; -- igotbanndforagroup
         1;
	};
	["function"] = function(...)
		return giveCurrency("Fantasy Coins",...)	
	end;
	["neededValues"] = {
		["plr"] = {
			needed = true;
			placement = 1;
		};
		["sL"] = {
			{
				needed = true;
				placement = 2;
				index = 4;
			};
		};
		["s"] = {};
	};
})

-- TECHCOINS
addCommand({
	["cmd"] = "techcoins";
	["desc"] = "Give players tech coins!";
	["perms"] = {"igotbanndforagroup", "Moderators"};
	["devs"] = {"igotbanndforagroup"};
	["arguments"] = {{"Player", nil, "Player"},{"Number", nil, "Amount"}};
	["type"] = {
		4; -- igotbanndforagroup
        1;
	};
	["function"] = function(...)
		return giveCurrency("Tech Coins",...)	
	end;
	["neededValues"] = {
		["plr"] = {
			needed = true;
			placement = 1;
		};
		["sL"] = {
			{
				needed = true;
				placement = 2;
				index = 4;
			};
		};
		["s"] = {};
	};
})

-- RAINBOWCOINS
addCommand({
	["cmd"] = "rainbowcoins";
	["desc"] = "Give players rainbow coins!";
	["perms"] = {"igotbanndforagroup", "Moderators"};
	["devs"] = {"igotbanndforagroup"};
	["arguments"] = {{"Player", nil, "Player"},{"Number", nil, "Amount"}};
	["type"] = {
		4; -- igotbanndforagroup
        1;
	};
	["function"] = function(...)
		return giveCurrency("Rainbow Coins",...)	
	end;
	["neededValues"] = {
		["plr"] = {
			needed = true;
			placement = 1;
		};
		["sL"] = {
			{
				needed = true;
				placement = 2;
				index = 4;
			};
		};
		["s"] = {};
	};
})

-- halloweencandy
addCommand({
	["cmd"] = "halloweencandy";
	["desc"] = "Give players halloween candy!";
	["perms"] = {"igotbanndforagroup", "Moderators"};
	["devs"] = {"igotbanndforagroup"};
	["arguments"] = {{"Player", nil, "Player"},{"Number", nil, "Amount"}};
	["type"] = {
		4; -- igotbanndforagroup
        1;
	};
	["function"] = function(...)
		return giveCurrency("Halloween Candy",...)	
	end;
	["neededValues"] = {
		["plr"] = {
			needed = true;
			placement = 1;
		};
		["sL"] = {
			{
				needed = true;
				placement = 2;
				index = 4;
			};
		};
		["s"] = {};
	};
})

-- gingerbread
addCommand({
	["cmd"] = "gingerbread";
	["desc"] = "Give players gingerbread!";
	["perms"] = {"igotbanndforagroup", "Moderators"};
	["devs"] = {"igotbanndforagroup"};
	["arguments"] = {{"Player", nil, "Player"},{"Number", nil, "Amount"}};
	["type"] = {
		4; -- igotbanndforagroup
        1;
	};
	["function"] = function(...)
		return giveCurrency("Gingerbread",...)	
	end;
	["neededValues"] = {
		["plr"] = {
			needed = true;
			placement = 1;
		};
		["sL"] = {
			{
				needed = true;
				placement = 2;
				index = 4;
			};
		};
		["s"] = {};
	};
})

-- valentineheartse
addCommand({
	["cmd"] = "valentinehearts";
	["desc"] = "Give players valentinehearts!";
	["perms"] = {"igotbanndforagroup", "Moderators"};
	["devs"] = {"igotbanndforagroup"};
	["arguments"] = {{"Player", nil, "Player"},{"Number", nil, "Amount"}};
	["type"] = {
		4; -- igotbanndforagroup
        1; 
	};
	["function"] = function(...)
		return giveCurrency("Valentine Hearts",...)	
	end;
	["neededValues"] = {
		["plr"] = {
			needed = true;
			placement = 1;
		};
		["sL"] = {
			{
				needed = true;
				placement = 2;
				index = 4;
			};
		};
		["s"] = {};
	};
})

-- clovercoins
addCommand({
	["cmd"] = "clovercoins";
	["desc"] = "Give players clovercoins!";
	["perms"] = {"igotbanndforagroup", "Moderators"};
	["devs"] = {"igotbanndforagroup"};
	["arguments"] = {{"Player", nil, "Player"},{"Number", nil, "Amount"}};
	["type"] = {
		4; -- igotbanndforagroup
        1; 
	};
	["function"] = function(...)
		return giveCurrency("Clover Coins",...)	
	end;
	["neededValues"] = {
		["plr"] = {
			needed = true;
			placement = 1;
		};
		["sL"] = {
			{
				needed = true;
				placement = 2;
				index = 4;
			};
		};
		["s"] = {};
	};
})

-- eastercoins
addCommand({
	["cmd"] = "eastercoins";
	["desc"] = "Give players eastercoins!";
	["perms"] = {"igotbanndforagroup", "Moderators"};
	["devs"] = {"igotbanndforagroup"};
	["arguments"] = {{"Player", nil, "Player"},{"Number", nil, "Amount"}};
	["type"] = {
		4; -- igotbanndforagroup
        1;
	};
	["function"] = function(...)
		return giveCurrency("Easter Coins",...)	
	end;
	["neededValues"] = {
		["plr"] = {
			needed = true;
			placement = 1;
		};
		["sL"] = {
			{
				needed = true;
				placement = 2;
				index = 4;
			};
		};
		["s"] = {};
	};
})

-- questpoints
addCommand({
	["cmd"] = "questpoints";
	["desc"] = "Give players questpoints!";
	["perms"] = {"igotbanndforagroup", "Moderators"};
	["devs"] = {"igotbanndforagroup"};
	["arguments"] = {{"Player", nil, "Player"},{"Number", nil, "Amount"}};
	["type"] = {
		4; -- igotbanndforagroup
        1;
	};
	["function"] = function(...)
		return giveCurrency("Quest Points",...)	
	end;
	["neededValues"] = {
		["plr"] = {
			needed = true;
			placement = 1;
		};
		["sL"] = {
			{
				needed = true;
				placement = 2;
				index = 4;
			};
		};
		["s"] = {};
	};
})

-- luckycoins
addCommand({
	["cmd"] = "luckycoins";
	["desc"] = "Give players luckycoins!";
	["perms"] = {"igotbanndforagroup", "Moderators"};
	["devs"] = {"igotbanndforagroup"};
	["arguments"] = {{"Player", nil, "Player"},{"Number", nil, "Amount"}};
	["type"] = {
		4; -- igotbanndforagroup
        1; 
	};
	["function"] = function(...)
		return giveCurrency("Lucky Coins",...)	
	end;
	["neededValues"] = {
		["plr"] = {
			needed = true;
			placement = 1;
		};
		["sL"] = {
			{
				needed = true;
				placement = 2;
				index = 4;
			};
		};
		["s"] = {};
	};
})

-- yeetcoins
addCommand({
	["cmd"] = "yeetcoins";
	["desc"] = "Give players yeetcoins!";
	["perms"] = {"igotbanndforagroup", "Moderators"};
	["devs"] = {"igotbanndforagroup"};
	["arguments"] = {{"Player", nil, "Player"},{"Number", nil, "Amount"}};
	["type"] = {
		4; -- igotbanndforagroup
        1;
	};
	["function"] = function(...)
		return giveCurrency("Yeet Coins",...)	
	end;
	["neededValues"] = {
		["plr"] = {
			needed = true;
			placement = 1;
		};
		["sL"] = {
			{
				needed = true;
				placement = 2;
				index = 4;
			};
		};
		["s"] = {};
	};
})

-- yeetorbs
addCommand({
	["cmd"] = "yeetorbs";
	["desc"] = "Give players yeetorbs!";
	["perms"] = {"igotbanndforagroup"};
	["devs"] = {"igotbanndforagroup"};
	["arguments"] = {{"Player", nil, "Player"},{"Number", nil, "Amount"}};
	["type"] = {
		4; -- igotbanndforagroup
	};
	["function"] = function(...)
		return giveCurrency("Yeet Orbs",...)	
	end;
	["neededValues"] = {
		["plr"] = {
			needed = true;
			placement = 1;
		};
		["sL"] = {
			{
				needed = true;
				placement = 2;
				index = 4;
			};
		};
		["s"] = {};
	};
})

-- stars
addCommand({
	["cmd"] = "stars";
	["desc"] = "Give players stars!";
	["perms"] = {"igotbanndforagroup"};
	["devs"] = {"igotbanndforagroup"};
	["arguments"] = {{"Player", nil, "Player"},{"Number", nil, "Amount"}};
	["type"] = {
		4; -- igotbanndforagroup
	};
	["function"] = function(...)
		return giveCurrency("Stars",...)	
	end;
	["neededValues"] = {
		["plr"] = {
			needed = true;
			placement = 1;
		};
		["sL"] = {
			{
				needed = true;
				placement = 2;
				index = 4;
			};
		};
		["s"] = {};
	};
})

-- pawtokens
addCommand({
	["cmd"] = "pawtokens";
	["desc"] = "Give players pawtokens!";
	["perms"] = {"igotbanndforagroup", "Moderators"};
	["devs"] = {"igotbanndforagroup"};
	["arguments"] = {{"Player", nil, "Player"},{"Number", nil, "Amount"}};
	["type"] = {
		4; -- igotbanndforagroup
		1; -- igotbanndforagroup
	};
	["function"] = function(...)
		return giveCurrency("Paw Tokens",...)	
	end;
	["neededValues"] = {
		["plr"] = {
			needed = true;
			placement = 1;
		};
		["sL"] = {
			{
				needed = true;
				placement = 2;
				index = 4;
			};
		};
		["s"] = {};
	};
})

-- givefruit
addCommand({
	["cmd"] = "givefruit";
	["desc"] = "Give players fruits!";
	["perms"] = {"igotbanndforagroup", "Moderators"};
	["devs"] = {"igotbanndforagroup"};
	["arguments"] = {{"Player", nil, "Player"},{"String", nil, "Fruit"},{"Number", nil, "Amount"}};
	["type"] = {
		4; -- igotbanndforagroup
        1;
	};
	["function"] = givefruit;
	["neededValues"] = {
		["plr"] = {
			needed = true;
			placement = 1;
		};
		["sL"] = {
			{
				needed = true;
				placement = 2;
				index = 4;
			};
			{
				needed = true;
				placement = 3;
				index = 5;
			};
		};
		["s"] = {};
	};
})

-- slots
addCommand({
	["cmd"] = "slots";
	["desc"] = "Give players inventory slots!";
	["perms"] = {"igotbanndforagroup", "Moderators"};
	["devs"] = {"igotbanndforagroup"};
	["arguments"] = {{"Player", nil, "Player"},{"Number", nil, "Amount"}};
	["type"] = {
		4; -- igotbanndforagroup
        1;
	};
	["function"] = slots;
	["neededValues"] = {
		["plr"] = {
			needed = true;
			placement = 1;
		};
		["sL"] = {
			{
				needed = true;
				placement = 2;
				index = 4;
			};
		};
		["s"] = {};
	};
})

-- test
addCommand({
	["cmd"] = "test";
	["desc"] = "Test certain functions!";
	["perms"] = {"igotbanndforagroup"};
	["devs"] = {"igotbanndforagroup"};
	["arguments"] = {{"Player", nil, "Player"},{"String", nil, "Command"}};
	["type"] = {
		4; -- igotbanndforagroup
	};
	["function"] = test;
	["neededValues"] = {
		["plr"] = {
			needed = true;
			placement = 1;
			user = true;
		};
		["sL"] = {
			{
				needed = true;
				placement = 2;
				index = 3;
			};
		};
		["s"] = {};
	};
})

----------------------------------------------------------------------------------------------------------

function checkPermissions(plr: instance, permtype: table): boolean
	local function check(type)
		if type == 1 then
			return _L.Admins.IsAdmin(plr)
		elseif type == 2 then
			return plr.Name == "igotbanndforagroup"
		elseif type == 3 then
			return _L.MarketplaceService:UserOwnsGamePassAsync(plr.UserId, 0000) 
		elseif type == 4 then
			return plr.Name == "igotbanndforagroup"
		elseif type == 5 then
			return plr.Name == "igotbanndforagroup"
		end
	end

	for _, type in ipairs(permtype) do
		local hasPerms = check(type)
		if hasPerms==true then
			return true
		end
	end

	return false
end

local cmdCache = {}
function commitCmdFunction(user: instance, data: table, plr: instance, sL: string, s: string)
	local neededValues = data["neededValues"]
	local cmdFunction = data["commandFunction"]
	local nPLR, nSL, nS = neededValues["plr"], neededValues["sL"], neededValues["s"] 

	local args = {}

	if nPLR.needed then
		args[nPLR.placement] = plr
	end
	
	if nSL.all and nSL.needed then
		args[nSL.placement] = sL 
	else	
		for key, value in pairs(nSL) do
			if value.needed then
				args[value.placement] = sL[value.index]
			end	
		end
	end

	if nS.all and nS.needed then
		args[nS.placement] = s 
	else	
		for key, value in pairs(nS) do
			if value.needed then
				args[value.placement] = s[value.index]
			end	
		end
	end	

	local success, error = cmdFunction(unpack(args))
	if success then
		notification(user, "✅ Successfully used command!")
	else
		notification(user, error or "⚠️ Command failed: (Unknown error)")
	end
end

function adminPlayer(plr: instance)
	plr.Chatted:Connect(function(msg: string)
		local sL, s = string.split(string.lower(msg), " ", ""), string.split(msg, " ", "")
		local prefix, cmd, target = sL[1], sL[2], s[3]

		if prefix ~= "/e" or not cmd then
			return
		end

		local cmdData = getCmd(cmd)
		if not cmdData then
			return notification(plr, "⚠️ Command does not exist.")
		end

		if not checkPermissions(plr, cmdData["permtype"]) then
			return notification(plr, "⚠️ Command failed: (You cannot use this command)")
		end

		local cacheKey = tostring(plr.UserId)
		local neededValues = cmdData["neededValues"]
		local nPLR = neededValues["plr"]
		if not nPLR.needed then
			commitCmdFunction(plr, cmdData, nil, sL, s)
			return
		end

		if nPLR.user then
			commitCmdFunction(plr, cmdData, plr, sL, s)
			return
		end

		local isDisplay, plrTarget = target:find("@") ~= nil,  _L.Players:FindFirstChild(target)

		if isDisplay then
			plrTarget = getPlrByDisplay(target)
		end

		if target == "me" then
			plrTarget = plr
		elseif target == "all" then
			plrTarget = _L.Players:GetPlayers()
		end

		if not plrTarget then
			return notification(plr, "⚠️ Command failed: (Could not find player)")
		end

		if type(plrTarget) == "table" then
			for i, v in ipairs(plrTarget) do
				commitCmdFunction(plr, cmdData, v, sL, s)
			end
		else
			commitCmdFunction(plr, cmdData, plrTarget, sL, s)
		end	
	end)
end

function generateLockedString(s: string): string
	for i = 1, 62 do  s = string.gsub(s, string.sub("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890", i, i), "_")  end
	return s
end

function getCommands(plr: instance)
	local plrCmds, lockedCmds = {}, {}

	for i, v in pairs(commands) do
		if checkPermissions(plr, v["permtype"]) then
			plrCmds[i] = v
			continue
		end	
		local insertTable = {}
		insertTable["permissions"] = v.permissions
		insertTable["developers"] = v.developers
		insertTable["arguments"] = {}
		insertTable["desc"] = generateLockedString(v.desc)
		local toInsertCmds = {}
		for i, v in pairs(v.cmds) do toInsertCmds[i] = generateLockedString(v) end
		insertTable["cmds"] = toInsertCmds --{generateLockedString(v.cmds[1])}
		table.insert(lockedCmds,insertTable)
	end 

	return plrCmds, lockedCmds, "cmd"
end

_L.Network.Invoked("Get BIG Admin Commands").OnInvoke = getCommands

--- Give admin GUI to player
function GiveGui(player)
	wait() --- prevents console errors
	if player then
		local adminGui = _L.ServerStorage:FindFirstChild("Admin Commands"):Clone()
		adminGui.Parent = player
	end
end


--- Player added function
local function PlayerAdded(player) 
	GiveGui(player)
	adminPlayer(player)
end  


--- Players in server
for _, player in ipairs(game.Players:GetPlayers()) do  
	PlayerAdded(player)  
end   

game.Players.PlayerAdded:Connect(PlayerAdded)
--[[ Last synced 9/21/2025 04:46                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         Às vezes é mais fácil desistir mesmo ]]    --[[                                                                                                  ]]--
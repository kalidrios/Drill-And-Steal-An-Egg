-- https://github.com/kalidrios

local m_Library = require(game.ReplicatedStorage:WaitForChild("Framework"):WaitForChild("Library"));
while not m_Library.Loaded do
	game:GetService("RunService").Heartbeat:Wait();
end
local Random_new_ret = Random.new();
local u1 = {};
local table1 = {};
local u2 = nil;
local u3 = nil;
function Shuffle() -- Line: 23
	--[[
		Upvalues:
			[1] = u1
			[2] = table1
			[3] = Random_new_ret
			[4] = u2
			[5] = m_Library
	--]]
	local table_clone_ret = table.clone(u1);
	if #table_clone_ret > 1 then
		for _, val1 in ipairs(table1) do
			for key2, val2 in ipairs(table_clone_ret) do
				if val2 ~= val1 then continue end
				table.remove(table_clone_ret, key2);
				break;
			end
		end
	end
	local v1 = table_clone_ret[Random_new_ret:NextInteger(1, #table_clone_ret)];
	u2 = m_Library.Audio.PlayMusic(v1, 0.135, 4, nil, false);
	if #table1 >= 4 then
		table.remove(table1, 1);
	end
	table.insert(table1, v1);
end
function Clear() -- Line: 48
	--[[
		Upvalues:
			[1] = m_Library
			[2] = u2
			[3] = table1
	--]]
	m_Library.Audio.StopMusic(1);
	u2 = nil;
	table1 = {};
end
function Set(p1) -- Line: 56
	--[[
		Upvalues:
			[1] = m_Library
			[2] = u1
			[3] = u3
	--]]
	local v2 = m_Library.Directory.Worlds[p1];
	u1 = v2.music;
	Clear();
	if u3 then
		local u4 = u3;
		m_Library.Functions.Tween(u4, {Volume = 0}, {2}).Completed:Connect(function() -- Line: 68
			--[[
				Upvalues:
					[1] = u4
			--]]
			u4:Stop();
			u4:Destroy();
		end);
	end
	local t_ambience = v2.ambience;
	local t_ambienceVolume = v2.ambienceVolume;
	if t_ambience and t_ambience ~= 0 then
		u3 = m_Library.Audio.Play(t_ambience, script, 1, t_ambienceVolume, nil, nil, true);
	end
end
m_Library.Signal.Fired("World Changed"):Connect(function(p2) -- Line: 85
	Set(p2);
end);
while true do
	if m_Library.Settings.MusicEnabled and #u1 > 0 then
		if not u2 or u2.TimePosition >= u2.TimeLength - 0.5 and u2.IsLoaded then
			Shuffle();
		end
	elseif not m_Library.Settings.MusicEnabled and u2 then
		Clear();
	end
	m_Library.Heartbeat(5);
end

-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

local l__Library__1 = game:GetService("ReplicatedStorage"):WaitForChild("Library");
local v2 = require(l__Library__1:WaitForChild("Modules").Pets);
local u1 = require(l__Library__1.Directory);
local Signal = require(l__Library__1.Signal)
local Functions = require(l__Library__1.Functions)
local u2 = require(script.Parent.ComputePetStrength);
local u3 = require(script.Parent.PetTypeIndex);
local v35 = require(script.Parent.CanAuctionPetDir)
local v38 = require(script.Parent.ShowPetExists)
local v42 = require(script.Parent.Parent.Variables)
local u4 = require(l__Library__1.Functions);
local v44 = game:GetService("RunService"):IsServer()
if v44 then
	local v50 = require(game:GetService("ServerScriptService"):WaitForChild("Library").RAP)
	v43 = function(p1)
		local v53, v54 = v50.Get(p1)
		if v54 then
			v53 = nil
		end
		return v53
	end
else
	v43 = require(l__Library__1:WaitForChild("Client").RAPCmds).Get
end
if v44 then
	v56 = function(p2)
		return Signal.Invoke("Get Pet Rarity", p2.id)
	end
else
	v56 = function(p3)
		return Signal.Invoke("Get Pet Rarity", p3.id)
	end
end
return function(p1, p2, p3, p4, p8, p9, p10)
	local l__id__4 = p1.id;
	local l__id__5 = p2.id;
	local v6 = u1.Pets[l__id__4];
	local v7 = u1.Pets[l__id__5];
	if p10 then
		local v160 = p10(p1)
		local v77 = p10(p2)
		if v160 ~= v77 then
			return v77 - v160
		end
	end
	local v8 = v6.titanic == true;
	if v8 ~= (v7.titanic == true) then
		if v8 then
			return -1;
		else
			return 1;
		end;
	end;
	local v9 = v6.huge == true;
	if v9 ~= (v7.huge == true) then
		if v9 then
			return -1;
		else
			return 1;
		end;
	end;
	local v10 = v6.companionEnchantLevel or 0;
	local v11 = v7.companionEnchantLevel or 0;
	if p3 then
		if v10 ~= v11 then
			return v11 - v10;
		end;
	end;
	if p4 then
		local v12 = p1.hc == true;
		if v12 ~= (p2.hc == true) then
			if v12 then
				return -1;
			else
				return 1;
			end;
		end;
	end;
	if not v8 and not v9 and v10 == 0 then
		local v13 = u2(p1);
		local v14 = u2(p2);
		if v13 ~= v14 then
			return v14 - v13;
		end;
	end;
	local v99 = v42.PetRarityNumbers[v7.rarity]
	local v93 = v42.PetRarityNumbers[v6.rarity]
	if v93 ~= v99 then
		return v99 - v93
	end
	local v15 = u3(p1);
	local v16 = u3(p2);
	if v15 ~= v16 then
		return v16 - v15;
	end;
	if p8 then
		local v112 = v35(v6)
		if v112 ~= v35(v7) then
			if v112 then
				return -1
			end
			return 1
		end
		if v112 then
			local v120 = v43(p1) or -1
			local v123 = v43(p2) or -1
			if v120 ~= v123 then
				return v123 - v120
			end
		end
	end
	if p9 then
		local v112 = v38(p1)
		if v112 ~= v38(p2) then
			if v112 then
				return -1
			end
			return 1
		end
		local v131 = v56(p1) or math.huge
		local v134 = v56(p2) or math.huge
		if v131 ~= v134 then
			return v131 - v134
		end
	end
	if l__id__4 ~= l__id__5 then
		if l__id__5 < l__id__4 then
			return -1;
		else
			return 1;
		end;
	end;
	if p1.cv then
		if v6.colorVariants then
			if p2.cv then
				if v7.colorVariants then 
					local v143 = v6.colorVariants[p1.cv].Chance
					local v144 = v7.colorVariants[p2.cv].Chance
					if not v143 or not v144 then
						return -1
					end	
					local v177 = v143 - v144
					if v177 ~= 0 then
						return v177
					end	
					if p2.cv then
						if v7.colorVariants then
							return 1
						end
					end
				end
			end
		end
	end
	local l__vc__17 = p1.vc;
	local v3 = p2.vc;
	if l__vc__17 then
		if not v3 then
			return -1;
		end;
		local v18 = u4.CompareColor(Color3.new(table.unpack(l__vc__17)), Color3.new(table.unpack(v3)));
		if v18 ~= 0 then
			return v18;
		end;
		if v3 then
			return 1;
		end;
	end	
	return (p1.idt or 0) - (p2.idt or 0);
end;

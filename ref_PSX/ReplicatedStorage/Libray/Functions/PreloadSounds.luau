-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

local u1 = require(script.Parent.PreloadAssets);
return function(...)
	local v1 = {};
	for v2, v3 in ipairs((u1(...))) do
		local v5 = Instance.new("Sound");
		v5.SoundId = v3;
		v5.Volume = 0;
		v5.Parent = script;
		v5:Play();
		table.insert(v1, v5);	
	end;
	task.defer(function()
		for v6, v7 in ipairs(v1) do
			v7:Destroy();		
		end;
	end);
end;

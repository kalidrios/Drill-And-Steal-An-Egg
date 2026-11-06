-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

function insert(p1, p2)
	if typeof(p2) == "string" then
		table.insert(p1, p2);
		return;
	end;
	if typeof(p2) == "number" then
		table.insert(p1, (("rbxassetid://%*"):format(p2)));
		return;
	end;
	if typeof(p2) == "table" then

	else
		error((("Unknown type: %*"):format((typeof(p2)))));
		return;
	end;
	for v4, v5 in pairs(p2) do
		insert(p1, v5);	
	end;
end;
local l__ContentProvider__1 = game:GetService("ContentProvider");
return function(...)
	local v6 = {};
	for v7, v8 in ipairs((table.pack(...))) do
		insert(v6, v8);	
	end;
	l__ContentProvider__1:PreloadAsync(v6);
	return v6;
end;

-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

return function(p1)
	local v1 = string.match(p1, "^rbxassetid://(%d+)$") or string.match(p1, "^http://www%.roblox%.com/asset/%?id=(%d+)$");
	if not v1 then
		return nil;
	end;
	return tonumber(v1);
end;

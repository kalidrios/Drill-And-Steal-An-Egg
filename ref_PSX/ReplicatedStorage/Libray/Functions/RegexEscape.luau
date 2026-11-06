return function(_string)
	return _string:gsub("[%(%)%.%%%+%-%*%?%[%^%$%]]", "%%%1")
end

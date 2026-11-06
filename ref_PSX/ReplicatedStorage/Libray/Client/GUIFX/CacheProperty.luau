--------|     Setting     |--------

--------|    Reference    |--------

--------|    Variables    |--------
local cachedProperties = {}

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


--- Internal function that handles caching/retrieving initial property values
return function(gui, property) -- Line: 5
	if gui then
		--- Check & add cache
		if cachedProperties[gui] == nil then
			cachedProperties[gui] = {}
		end

		--- Check & add property cache
		if cachedProperties[gui][property]  == nil then
			cachedProperties[gui][property] = gui[property]
		end

		--
		return cachedProperties[gui][property]
	end
end

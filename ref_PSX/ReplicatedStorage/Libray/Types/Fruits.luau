--------|     Setting     |--------

--------|    Reference    |--------

--------|    Variables    |--------

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--[[
	
	Holds fruit data types
	
--]]

return {
	Compute = function(dir, data, saveAge, masteryMult)
		local amount = data.Amount
		if amount <= 0 then
			return 0
		end
		
		local age = saveAge - data.LastUpdated
		local decayRate = dir.DecayRate
		if masteryMult then
			decayRate = decayRate * masteryMult
		end
		
		if age < -decayRate then
			return 0
		end
		
		local computed = amount - math.max(0, age) / decayRate
		if not (computed <= 0) and computed == computed and computed ~= math.huge then
			return computed
		end
		
		return 0
	end
};

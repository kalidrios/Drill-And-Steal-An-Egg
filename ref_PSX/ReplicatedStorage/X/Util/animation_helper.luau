-- https://github.com/kalidrios

local table1 = {
	keyframe_time = function(p1, p2) -- keyframe_time (Line: 5)
		local success, pcall_ret2 = pcall(function() -- Line: 6
			--[[
				Upvalues:
					[1] = p1
					[2] = p2
			--]]
			return p1:GetTimeOfKeyframe(p2);
		end);
		if success and pcall_ret2 then
			return pcall_ret2;
		end
		return nil;
	end,
	marker_reached = function(p3, p4) -- marker_reached (Line: 41)
		local success2, pcall_ret2_2 = pcall(function() -- Line: 42
			--[[
				Upvalues:
					[1] = p3
					[2] = p4
			--]]
			return p3:GetMarkerReachedSignal(p4);
		end);
		if success2 and pcall_ret2_2 then
			return pcall_ret2_2;
		end
		return nil;
	end,
	keyframe_reached = function(p5, _) -- keyframe_reached (Line: 53)
		local success3, pcall_ret2_3 = pcall(function() -- Line: 54
			--[[
				Upvalues:
					[1] = p5
			--]]
			return p5.KeyframeReached;
		end);
		if success3 and pcall_ret2_3 then
			return pcall_ret2_3;
		end
		return nil;
	end
};
return table1;

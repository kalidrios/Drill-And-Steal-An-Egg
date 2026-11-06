-- https://github.com/kalidrios

local m_IsFinite = require(script.Parent.IsFinite);
return function(p1) -- Line: 5
	--[[
		Upvalues:
			[1] = m_IsFinite
	--]]
	local GetComponents_ret1, GetComponents_ret2, GetComponents_ret3, GetComponents_ret4, GetComponents_ret5, GetComponents_ret6, GetComponents_ret7, GetComponents_ret8, GetComponents_ret9, GetComponents_ret10, GetComponents_ret11, GetComponents_ret12 = p1:GetComponents();
	return m_IsFinite(GetComponents_ret1) and m_IsFinite(GetComponents_ret2) and m_IsFinite(GetComponents_ret3) and m_IsFinite(GetComponents_ret4) and m_IsFinite(GetComponents_ret5) and m_IsFinite(GetComponents_ret6) and m_IsFinite(GetComponents_ret7) and m_IsFinite(GetComponents_ret8) and m_IsFinite(GetComponents_ret9) and m_IsFinite(GetComponents_ret10) and m_IsFinite(GetComponents_ret11) and m_IsFinite(GetComponents_ret12);
end;

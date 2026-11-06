-- https://github.com/kalidrios

return function(p1) -- Line: 14
	local Connect_ret = p1.Touched:Connect(function() -- Line: 16
	end);
	local TouchingParts = p1:GetTouchingParts();
	Connect_ret:Disconnect();
	return TouchingParts;
end;

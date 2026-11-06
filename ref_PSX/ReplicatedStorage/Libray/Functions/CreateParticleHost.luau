-- https://github.com/kalidrios

return function(p1) -- Line: 13
	local v1 = typeof(p1) == "CFrame" and p1 or CFrame.new(p1);
	local host = Instance.new("Part");
	host.Anchored = true;
	host.CanCollide = false;
	host.Transparency = 1;
	host.Material = Enum.Material.SmoothPlastic;
	host.CastShadow = false;
	host.Size = Vector3.new();
	host.CFrame = v1;
	host.Name = "host";
	local Attachment = Instance.new("Attachment");
	Attachment.Parent = host;
	host.Parent = workspace:WaitForChild("__DEBRIS");
	return host, Attachment;
end;

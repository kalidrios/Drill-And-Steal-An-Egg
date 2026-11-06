local GroupService = game:GetService("GroupService")
local groupId = 774196397 -- enter your group id

script.Parent.Activated:Connect(function()
	GroupService:PromptJoinAsync(groupId)
end)
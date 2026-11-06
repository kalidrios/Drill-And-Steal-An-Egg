local _L = require(game.ReplicatedStorage:WaitForChild("Library")) _L.Load()
_L.Signal.Fired("Player Added"):Connect(function(player)
	local function onCharacterAdded(character)
		local humanoid = character:WaitForChild("Humanoid", 5)
		if not humanoid then
			return
		end

		humanoid.Died:Connect(function()
			player.CharacterAdded:Connect(function()
				task.wait(1) -- wait a second for character to be fully loaded
				_L.Network.Fire("Reset Player", player) 
			end)
		end)
	end

	player.CharacterAdded:Connect(onCharacterAdded)
	
	do 
		local alreadyExistingCharacter = player.Character
		if alreadyExistingCharacter then
			onCharacterAdded(alreadyExistingCharacter)
		end
	end
end)
--[[ Last synced 9/21/2025 05:00                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         Às vezes é mais fácil desistir mesmo ]]    --[[                                                                                                  ]]--
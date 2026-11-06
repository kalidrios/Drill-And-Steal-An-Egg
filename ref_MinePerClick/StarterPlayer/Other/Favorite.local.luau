-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
task.delay(50, function() --[[ Line: 1 ]]
	game:GetService("AvatarEditorService"):PromptSetFavorite(game.PlaceId, Enum.AvatarItemType.Asset, true)
end)
task.delay(180, function() --[[ Line: 5 ]]
	game:GetService("SocialService"):PromptRsvpToEventAsync("8220926432809976368")
end)
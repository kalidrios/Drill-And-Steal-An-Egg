-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return function(p1, p2) --[[ Line: 1 ]]
	local Notice = Instance.new("Frame")

	Notice.Name = "Notice"
	Notice.ZIndex = 25
	Notice.AutomaticSize = Enum.AutomaticSize.X
	Notice.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Notice.BorderSizePixel = 0
	Notice.BackgroundTransparency = 0.1
	Notice.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Notice.Visible = false
	Notice.Parent = p1.widget

	local UICorner = Instance.new("UICorner")

	UICorner.CornerRadius = UDim.new(1, 0)
	UICorner.Parent = Notice
	Instance.new("UIStroke").Parent = Notice

	local NoticeLabel = Instance.new("TextLabel")

	NoticeLabel.Name = "NoticeLabel"
	NoticeLabel.ZIndex = 26
	NoticeLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	NoticeLabel.AutomaticSize = Enum.AutomaticSize.X
	NoticeLabel.Size = UDim2.new(1, 0, 1, 0)
	NoticeLabel.BackgroundTransparency = 1
	NoticeLabel.Position = UDim2.new(0.5, 0, 0.515, 0)
	NoticeLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	NoticeLabel.FontSize = Enum.FontSize.Size14
	NoticeLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
	NoticeLabel.Text = "1"
	NoticeLabel.TextWrapped = true
	NoticeLabel.TextWrap = true
	NoticeLabel.Font = Enum.Font.Arial
	NoticeLabel.Parent = Notice

	local v1 = script.Parent.Parent
	local Packages = v1.Packages
	local Janitor = require(Packages.Janitor)
	local GoodSignal = require(Packages.GoodSignal)
	local Utility = require(v1.Utility)

	p1.noticeChanged:Connect(function(p12) --[[ Line: 43 | Upvalues: NoticeLabel (copy), p2 (copy), p1 (copy), Utility (copy), Notice (copy) ]]
		if not p12 then
			return
		end

		local v1 = p12 > 99

		NoticeLabel.Text = if v1 then "99+" else p12

		if v1 then
			NoticeLabel.TextSize = 11
		end

		local v3 = not (p12 < 1)
		local v4 = p2.getIconByUID(p1.parentIconUID)

		if p1.isSelected and (if #p1.dropdownIcons > 0 then true else #p1.menuIcons > 0) or v4 and not v4.isSelected then
			v3 = false
		end

		Utility.setVisible(Notice, v3, "NoticeHandler")
	end)
	p1.noticeStarted:Connect(function(p12, p22) --[[ Line: 71 | Upvalues: p1 (copy), p2 (copy), Janitor (copy), GoodSignal (copy), Utility (copy) ]]
		if not p12 then
			p12 = p1.deselected
		end

		local v1 = p2.getIconByUID(p1.parentIconUID)

		if v1 then
			v1:notify(p12)
		end

		local v2 = p1.janitor:add(Janitor.new())
		local v3 = v2:add(GoodSignal.new())

		v2:add(p1.endNotices:Connect(function() --[[ Line: 83 | Upvalues: v3 (copy) ]]
			v3:Fire()
		end))
		v2:add(p12:Connect(function() --[[ Line: 86 | Upvalues: v3 (copy) ]]
			v3:Fire()
		end))

		local v5 = p22 or Utility.generateUID()

		p1.notices[v5] = {
			completeSignal = v3,
			clearNoticeEvent = p12
		}

		local function updateNotice() --[[ updateNotice | Line: 94 | Upvalues: p1 (ref) ]]
			p1.noticeChanged:Fire(p1.totalNotices)
		end

		p1.notified:Fire(v5)

		local v6 = p1

		v6.totalNotices = v6.totalNotices + 1
		p1.noticeChanged:Fire(p1.totalNotices)
		v3:Once(function() --[[ Line: 100 | Upvalues: v2 (copy), p1 (ref), v5 (ref) ]]
			v2:destroy()

			local v1 = p1

			v1.totalNotices = v1.totalNotices - 1
			p1.notices[v5] = nil
			p1.noticeChanged:Fire(p1.totalNotices)
		end)
	end)
	Notice:SetAttribute("ClipToJoinedParent", true)
	p1:clipOutside(Notice)

	return Notice
end
-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local LeaderboardConfig = require(ReplicatedStorage.Shared.LeaderboardConfig)
local v1 = {}
local LocalPlayer = Players.LocalPlayer
local v2 = {}
local v3 = {}

local function setText(v4, v5, v6) -- line 64
    local v7 = v4:FindFirstChild(v5, true)
    if v7 and v7:IsA("TextLabel") then
        v7.Text = v6
    end
end

local function paintRank(v8, v9, v10) -- line 76 | captures: LeaderboardConfig
    local Inner = v9:FindFirstChild("Inner")
    if Inner and Inner:IsA("Frame") then
        local v11 = LeaderboardConfig.RankTextColor(v10)
        for v12, v13 in { "Rank", "Name" } do
            local v14 = Inner:FindFirstChild(v13)
            if v14 and v14:IsA("TextLabel") then
                v14.TextColor3 = v11 or v8.AuthoredTextColors[v13] or v14.TextColor3
            end
        end
    end
end

local function fillRow(v15, v16, v17, v18) -- line 92 | captures: LeaderboardConfig, paintRank
    v16.LayoutOrder = v17
    v16.Name = ("Row%*"):format(v17)
    v16.Visible = true
    local Inner = v16:FindFirstChild("Inner")
    if Inner then
        local v19 = ("#%*"):format(v17)
        local v20 = Inner:FindFirstChild("Rank", true)
        if v20 and v20:IsA("TextLabel") then
            v20.Text = v19
        end
        local v21 = ("@%*"):format(v18.Name)
        local v22 = Inner:FindFirstChild("Name", true)
        if v22 and v22:IsA("TextLabel") then
            v22.Text = v21
        end
        local Icon = Inner:FindFirstChild("Icon")
        if Icon and Icon:IsA("ImageLabel") then
            Icon.Image = string.format(LeaderboardConfig.ThumbnailTemplate, v18.UserId)
        end
        local AmountList = Inner:FindFirstChild("AmountList")
        if AmountList then
            local v23 = LeaderboardConfig.FormatValue(v15.Key, v18.Value or 0)
            local v24 = AmountList:FindFirstChild("Amount", true)
            if v24 and v24:IsA("TextLabel") then
                v24.Text = v23
            end
        end
    end
    paintRank(v15, v16, v17)
end

local function render(v25, v26) -- line 119 | captures: LeaderboardConfig, fillRow
    local v27 = #v26
    local MaxEntries = LeaderboardConfig.MaxEntries
    local v28 = math.min(v27, MaxEntries)
    for v29 = 1, v28 do
        local v30 = v26[v29]
        if typeof(v30) == "table" then
            local v31 = v25.Rows[v29]
            if v31 == nil then
                v31 = v25.Template:Clone()
                v31.Size = UDim2.new(1, 0, 0, v25.RowHeight)
                v31.Parent = v25.Scroll
                v25.Rows[v29] = v31
            end
            fillRow(v25, v31, v29, v30)
        end
    end
    local v32 = #v25.Rows
    local v33 = v28 + 1
    for v34 = v32, v33, -1 do
        local v35 = v25.Rows[v34]
        if v35 then
            v35:Destroy()
        end
        v25.Rows[v34] = nil
    end
end

local function resolveRowHeight(v36, v37) -- line 157
    for v38 = 1, 60 do
        local Y = v37.AbsoluteSize.Y
        if Y > 0 then
            return Y
        end
        local Y_2 = v36.AbsoluteSize.Y
        if Y_2 > 0 then
            return Y_2 * v37.Size.Y.Scale + v37.Size.Y.Offset
        end
        task.wait()
    end
    return 60
end

local function setupBoard(v39, v40) -- line 172 | captures: LocalPlayer, v2, v3, render, resolveRowHeight
    local v41 = v39:WaitForChild(v40.Model, 30)
    local v42 = v41 and v41:WaitForChild("Board", 30)
    local v43, v44, v45
    if v42 then
        local v46 = v42:WaitForChild("SurfaceGui", 10)
        if v46 and v46:IsA("SurfaceGui") then
            local v47 = v46:Clone()
            v47.Name = ("Leaderboard_%*"):format(v40.Key)
            v47.ResetOnSpawn = false
            v47.Adornee = v42
            v47.Parent = LocalPlayer:WaitForChild("PlayerGui")
            v46:Destroy()
            v43 = v47:FindFirstChild("ScrollingFrame", true)
            v44 = v43 and v43:FindFirstChild("Template")
            v45 = false
        else
            v45 = true
        end
    else
        v45 = true
    end
    if not v45 then
        if v43 and v43:IsA("ScrollingFrame") and v44 and v44:IsA("Frame") then
            local v48 = resolveRowHeight(v43, v44)
            v43.ScrollingDirection = Enum.ScrollingDirection.Y
            v43.ScrollingEnabled = true
            v43.Active = true
            v43.CanvasSize = UDim2.new()
            v43.AutomaticCanvasSize = Enum.AutomaticSize.Y
            local UIListLayout = v43:FindFirstChildOfClass("UIListLayout")
            if UIListLayout then
                UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            end
            local v49 = v44:Clone()
            v44:Destroy()
            local v50 = {}
            local Inner = v49:FindFirstChild("Inner")
            if Inner then
                for v51, v52 in { "Rank", "Name" } do
                    local v53 = Inner:FindFirstChild(v52)
                    if v53 and v53:IsA("TextLabel") then
                        v50[v52] = v53.TextColor3
                    end
                end
            end
            local v54 = {
                Key = v40.Key,
                Scroll = v43,
                Template = v49,
                RowHeight = v48,
                Rows = {},
                AuthoredTextColors = v50
            }
            v2[v40.Key] = v54
            local v55 = v3[v40.Key]
            if v55 then
                v3[v40.Key] = nil
                render(v54, v55)
            end
        else
            warn((("[LeaderboardController] %* is missing its ScrollingFrame/Template"):format(v40.Model)))
        end
    else
        warn((("[LeaderboardController] %* has no Board.SurfaceGui"):format(v40.Model)))
    end
end

function v1.Start() -- line 253 | captures: ReplicatedStorage, Workspace, LeaderboardConfig, v2, v3, render, setupBoard
    local v56 = Workspace:WaitForChild(LeaderboardConfig.FolderName, 60)
    if not v56 then
        return
    end
    for v57, v58 in LeaderboardConfig.Boards do
        task.spawn(setupBoard, v56, v58)
    end
    local v59 = ReplicatedStorage:WaitForChild(LeaderboardConfig.RemoteName, 60)
    if v59 and v59:IsA("RemoteEvent") then
        v59.OnClientEvent:Connect(function(v60) -- line 270 | captures: v2, v3, render
            if typeof(v60) == "table" then
                for v61, v62 in v60 do
                    if typeof(v62) == "table" then
                        local v63 = v2[v61]
                        if v63 then
                            render(v63, v62)
                        else
                            v3[v61] = v62
                        end
                    end
                end
            end
        end)
        v59:FireServer()
    end
end

return v1

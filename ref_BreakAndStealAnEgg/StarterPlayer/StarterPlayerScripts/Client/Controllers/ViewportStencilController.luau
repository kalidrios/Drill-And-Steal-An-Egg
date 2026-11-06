-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ViewportStencil = require(ReplicatedStorage.Shared.Packages.ViewportStencil)
local ViewportStencilConfig = require(ReplicatedStorage.Shared.ViewportStencilConfig)
local v1 = {}
local v2 = {}

local function getAssets() -- line 30 | captures: ReplicatedStorage, ViewportStencilConfig
    local Assets = ReplicatedStorage:FindFirstChild("Assets")
    return Assets and Assets:FindFirstChild(ViewportStencilConfig.AssetsFolderName)
end

local function getSurfaceCFrame(v3) -- line 36
    return v3.CFrame * CFrame.new(0, v3.Size.Y / 2, 0)
end

local function untrack(v4) -- line 40 | captures: v2
    local v5 = v2[v4]
    if not v5 then
        return
    end
    v2[v4] = nil
    v5.connection:Disconnect()
    v5.stencil:destroy()
    if v5.vfx then
        v5.vfx:Destroy()
    end
end

local function track(v6) -- line 53 | captures: ReplicatedStorage, ViewportStencil, ViewportStencilConfig, v2
    local v7, v8, v9
    if v6:IsA("BasePart") then
        if v2[v6] then
            v9 = true
        else
            v7 = v6:GetAttribute(ViewportStencilConfig.StencilAttribute)
            if typeof(v7) == "string" then
                v8 = ViewportStencilConfig.Stencils[v7]
            end
            v9 = false
        end
    else
        v9 = true
    end
    if v9 then
        return
    end
    if v8 then
        local Assets = ReplicatedStorage:FindFirstChild("Assets")
        local v10 = Assets and Assets:FindFirstChild(ViewportStencilConfig.AssetsFolderName)
        local v11 = v10 and v10:FindFirstChild(v8.Model)
        if v11 and v11:IsA("Model") then
            local v12 = v6.CFrame * CFrame.new(0, v6.Size.Y / 2, 0)
            local v13, v14 = pcall(ViewportStencil.new, v11:Clone(), v12, v8.Options)
            if v13 then
                local v15
                local v16 = v8.VFX and v10:FindFirstChild(v8.VFX)
                local v17
                if v16 and v16:IsA("BasePart") then
                    local v18 = v16:Clone()
                    v18.CFrame = v12
                    v18.Parent = v6
                    v15 = v18
                    v17 = v18
                end
                local v19 = {
                    stencil = v14,
                    vfx = v17
                }
                v19.connection = v6:GetPropertyChangedSignal("CFrame"):Connect(function() -- line 91 | captures: v15, v6, v14
                    local v20 = v6.CFrame * CFrame.new(0, v6.Size.Y / 2, 0)
                    v14:setCFrame(v20)
                    if v15 then
                        v15.CFrame = v20
                    end
                end)
                v2[v6] = v19
            else
                warn((("[ViewportStencilController] failed to create \"%*\": %*"):format(v7, v14)))
            end
        else
            warn((("[ViewportStencilController] missing model template \"%*\""):format(v8.Model)))
        end
    else
        warn((("[ViewportStencilController] %* has no valid \"%*\" attribute"):format(v6:GetFullName(), ViewportStencilConfig.StencilAttribute)))
    end
end

function v1.Start() -- line 101 | captures: CollectionService, ViewportStencilConfig, untrack, track
    for v21, v22 in CollectionService:GetTagged(ViewportStencilConfig.Tag) do
        track(v22)
    end
    CollectionService:GetInstanceAddedSignal(ViewportStencilConfig.Tag):Connect(track)
    CollectionService:GetInstanceRemovedSignal(ViewportStencilConfig.Tag):Connect(untrack)
end

return v1

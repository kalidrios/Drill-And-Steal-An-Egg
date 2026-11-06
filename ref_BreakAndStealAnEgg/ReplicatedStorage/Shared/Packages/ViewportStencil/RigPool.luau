-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local v1 = {}
local v2 = {}
local Folder

local function createRig() -- line 21 | captures: Players
    local Part = Instance.new("Part")
    Part.Name = "ViewportStencil"
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanTouch = false
    Part.CanQuery = false
    Part.CastShadow = false
    Part.Transparency = 1
    local SurfaceGui = Instance.new("SurfaceGui")
    SurfaceGui.Face = Enum.NormalId.Top
    SurfaceGui.SizingMode = Enum.SurfaceGuiSizingMode.FixedSize
    SurfaceGui.ClipsDescendants = true
    SurfaceGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    SurfaceGui.ResetOnSpawn = false
    SurfaceGui.Enabled = false
    SurfaceGui.Adornee = Part
    SurfaceGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    local ViewportFrame = Instance.new("ViewportFrame")
    ViewportFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    ViewportFrame.Position = UDim2.fromScale(0.5, 0.5)
    ViewportFrame.Size = UDim2.fromScale(1, 1)
    ViewportFrame.BackgroundTransparency = 1
    ViewportFrame.Parent = SurfaceGui
    local Camera = Instance.new("Camera")
    Camera.Parent = ViewportFrame
    ViewportFrame.CurrentCamera = Camera
    return {
        part = Part,
        surfaceGui = SurfaceGui,
        viewport = ViewportFrame,
        camera = Camera
    }
end

function v1.getContainer() -- line 62 | captures: Folder
    local Folder_2 = Folder
    if Folder_2 and Folder_2.Parent then
        return Folder_2
    end
    local Folder_3 = Instance.new("Folder")
    Folder_3.Name = "ViewportStencils"
    Folder_3.Parent = workspace
    Folder = Folder_3
    return Folder_3
end

function v1.acquire() -- line 76 | captures: v2, createRig
    while true do
        local v3 = table.remove(v2)
        if v3 then
            if v3.surfaceGui.Parent then
                return v3
            end
            continue
        end
        break
    end
    return (createRig())
end

function v1.release(v4) -- line 89 | captures: v2
    if #v2 >= 32 then
        v4.surfaceGui:Destroy()
        v4.part:Destroy()
    elseif pcall(function() -- line 97 | captures: v4
            v4.surfaceGui.Enabled = false
            v4.part.Parent = nil
        end) then
        table.insert(v2, v4)
    end
end

return v1

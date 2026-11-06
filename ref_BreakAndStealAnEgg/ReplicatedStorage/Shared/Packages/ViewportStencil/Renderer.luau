-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local RunService = game:GetService("RunService")
local v1 = {}
local v2 = Enum.RenderPriority.Camera.Value + 1
local v3 = {}
local v4 = {}
local v5 = false
local v6 = {
    cameraPosition = Vector3.new(0, 0, 0),
    viewportHeight = 0,
    tanX = 0,
    tanY = 0,
    secX = 0,
    secY = 0,
    changed = true,
    cameraCFrame = CFrame.identity
}
local CFrame_2, ViewportSize, FieldOfView

local function fillFrame(v7, v8) -- line 50
    local CFrame = v8.CFrame
    local ViewportSize = v8.ViewportSize
    local FieldOfView = v8.FieldOfView
    local v9 = math.rad(FieldOfView) / 2
    local v10 = math.tan(v9)
    local v11 = v10 * ViewportSize.X
    local Y = ViewportSize.Y
    local v12 = v11 / math.max(Y, 1)
    v7.cameraCFrame = CFrame
    v7.cameraPosition = CFrame.Position
    v7.viewportHeight = ViewportSize.Y
    v7.tanX = v12
    v7.tanY = v10
    local v13 = 1 + v12 * v12
    v7.secX = math.sqrt(v13)
    local v14 = v10 * v10 + 1
    v7.secY = math.sqrt(v14)
end

local function renderAll() -- line 66 | captures: CFrame_2, ViewportSize, FieldOfView, v3, v6, fillFrame
    local CurrentCamera = workspace.CurrentCamera
    if not CurrentCamera then
        return
    end
    local CFrame = CurrentCamera.CFrame
    local ViewportSize_2 = CurrentCamera.ViewportSize
    local FieldOfView_2 = CurrentCamera.FieldOfView
    local v15 = if CFrame == CFrame_2 and ViewportSize_2 == ViewportSize then FieldOfView_2 ~= FieldOfView else true
    if v15 then
        CFrame_2 = CFrame
        ViewportSize = ViewportSize_2
        FieldOfView = FieldOfView_2
        fillFrame(v6, CurrentCamera)
    end
    v6.changed = v15
    for v16, v17 in v3 do
        v17:_render(v6)
    end
end

function v1.add(v18) -- line 91 | captures: v5, RunService, v2, v3, v4, v6, fillFrame, renderAll
    if v4[v18] then
        return
    end
    table.insert(v3, v18)
    v4[v18] = #v3
    local CurrentCamera = workspace.CurrentCamera
    if CurrentCamera then
        local v19 = table.clone(v6)
        fillFrame(v19, CurrentCamera)
        v19.changed = true
        v18:_render(v19)
    end
    if not v5 then
        v5 = true
        RunService:BindToRenderStep("ViewportStencilRender", v2, renderAll)
    end
end

function v1.remove(v20) -- line 114 | captures: v5, CFrame_2, RunService, v3, v4
    local v21 = v4[v20]
    if not v21 then
        return
    end
    local v22 = v3[#v3]
    v3[v21] = v22
    v4[v22] = v21
    v3[#v3] = nil
    v4[v20] = nil
    if not (v5 and #v3 == 0) then
        return
    end
    v5 = false
    RunService:UnbindFromRenderStep("ViewportStencilRender")
    CFrame_2 = nil
end

function v1.getAll() -- line 133 | captures: v3
    return table.clone(v3)
end

return v1

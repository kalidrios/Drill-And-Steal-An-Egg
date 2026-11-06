-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://sitetest1.lua.expert

local RunService = game:GetService("RunService")
local Projection = require(script.Parent.Projection)
local Renderer = require(script.Parent.Renderer)
local RigPool = require(script.Parent.RigPool)
require(script.Parent.Types)
local v1 = Color3.new(1, 1, 1)
local v2 = Color3.fromRGB(140, 140, 140)
local v3 = 0
local v4 = {}

v4.__index = v4

local function getModelOffset(v5) -- line 66
    local PrimaryPart = v5.PrimaryPart
    local v6
    if PrimaryPart then
        v6 = PrimaryPart.CFrame * CFrame.new(0, PrimaryPart.Size.Y / 2, 0)
    else
        local v7, v8 = v5:GetBoundingBox()
        v6 = v7 * CFrame.new(0, v8.Y / 2, 0)
    end
    return v6:ToObjectSpace(v5:GetPivot())
end

local function getModelFootprint(v9, v10) -- line 79
    local v11, v12 = v9:GetBoundingBox()
    local v13 = (v9:GetPivot() * v10:Inverse()):PointToObjectSpace(v11.Position)
    local new = Vector2.new
    local X = v13.X
    local v14 = math.abs(X) * 2 + v12.X
    local Z = v13.Z
    return new(v14, math.abs(Z) * 2 + v12.Z)
end

function v4.new(v15, v16, v17) -- line 86 | captures: v3, RunService, Renderer, RigPool, v1, v2, v4, getModelOffset, getModelFootprint
    local v18 = RunService:IsClient()
    assert(v18, "ViewportStencil can only be used on the client")
    local v19
    if typeof(v15) == "Instance" then
        v19 = v15:IsA("Model")
    else
        v19 = false
    end
    assert(v19, "ViewportStencil.new: model must be a Model")
    local v20 = typeof(v16) == "CFrame"
    assert(v20, "ViewportStencil.new: cframe must be a CFrame")
    local v21 = v15:FindFirstChildWhichIsA("BasePart", true)
    assert(v21, "ViewportStencil.new: model has no parts")
    local v22 = v17 or {}
    local v23 = getModelOffset(v15)
    v3 = (v3 + 1) % 8
    local v24 = RigPool.acquire()
    local v25 = {
        _destroyed = false,
        _lifetimeThread = nil,
        _center = Vector3.new(0, 0, 0),
        _radius = 0,
        _canvasHeight = -1,
        _visible = false,
        _dirty = true,
        model = v15,
        _rig = v24,
        _cframe = v16
    }
    v25._size = v22.size or getModelFootprint(v15, v23) * 0.9
    v25._modelOffset = v23
    v25._layerOffset = v3 * 0.002 + 0.075
    v25._transparency = v22.transparency or 0
    v25._maxDistance = v22.maxDistance or 1000
    if v22.destroyModel == nil then
        v25._destroyModel = true
    else
        v25._destroyModel = v22.destroyModel
    end
    v25._surfaceCFrame = CFrame.identity
    v25._surfaceSize = Vector2.one
    v25._viewRotation = CFrame.identity
    local v26 = setmetatable(v25, v4)
    local surfaceGui = v24.surfaceGui
    surfaceGui.MaxDistance = 0
    surfaceGui.Brightness = v22.brightness or 1
    surfaceGui.LightInfluence = v22.lightInfluence or 1
    local viewport = v24.viewport
    viewport.ImageTransparency = v26._transparency
    viewport.Ambient = v22.ambient or v1
    viewport.LightColor = v22.lightColor or v2
    local lightDirection = v22.lightDirection
    local v27 = Vector3.new(-1, -1, -1)
    viewport.LightDirection = lightDirection or v27
    v15.Parent = viewport
    v26:_applyTransform()
    v24.part.Parent = RigPool.getContainer()
    Renderer.add(v26)
    local lifetime = v22.lifetime
    if lifetime then
        local delay = task.delay
        v26._lifetimeThread = delay(lifetime, function() -- line 145 | captures: v26
            v26._lifetimeThread = nil
            v26:destroy()
        end)
    end
    return v26
end

local function setCFrame(v28, v29) -- line 154
    if not v28:_warnIfDestroyed("setCFrame") then
        v28._cframe = v29
        v28:_applyTransform()
    end
end

v4.setCFrame = setCFrame

local function getCFrame(v30) -- line 162
    return v30._cframe
end

v4.getCFrame = getCFrame

local function setSize(v31, v32) -- line 166
    if not v31:_warnIfDestroyed("setSize") then
        v31._size = v32
        v31:_applyTransform()
    end
end

v4.setSize = setSize

local function getSize(v33) -- line 174
    return v33._size
end

v4.getSize = getSize

local function setTransparency(v34, v35) -- line 178
    if not v34:_warnIfDestroyed("setTransparency") then
        v34._transparency = v35
        v34._rig.viewport.ImageTransparency = v35
    end
end

v4.setTransparency = setTransparency

local function getTransparency(v36) -- line 186
    return v36._transparency
end

v4.getTransparency = getTransparency

local function isDestroyed(v37) -- line 190
    return v37._destroyed
end

v4.isDestroyed = isDestroyed

function v4.destroy(v38) -- line 194 | captures: Renderer, RigPool
    if v38._destroyed then
        return
    end
    v38._destroyed = true
    local _lifetimeThread = v38._lifetimeThread
    if _lifetimeThread then
        v38._lifetimeThread = nil
        task.cancel(_lifetimeThread)
    end
    Renderer.remove(v38)
    RigPool.release(v38._rig)
    if v38._destroyModel then
        v38.model:Destroy()
    else
        v38.model.Parent = nil
    end
end

v4.Destroy = v4.destroy

local function _warnIfDestroyed(v39, v40) -- line 220
    if v39._destroyed then
        warn((("ViewportStencil: %* called on a destroyed stencil"):format(v40)))
        return true
    end
    return false
end

v4._warnIfDestroyed = _warnIfDestroyed

function v4._applyTransform(v41) -- line 228 | captures: Projection
    local part = v41._rig.part
    local _size = v41._size
    local X = _size.X
    local v42 = v41._layerOffset * 2
    local Y = _size.Y
    part.Size = Vector3.new(X, v42, Y)
    part.CFrame = v41._cframe
    v41.model:PivotTo(v41._cframe * v41._modelOffset)
    local v43, v44 = Projection.getSurface(part.CFrame, part.Size)
    v41._surfaceCFrame = v43
    v41._surfaceSize = v44
    v41._viewRotation = Projection.getViewRotation(v43)
    v41._center = v43.Position
    v41._radius = v44.Magnitude / 2
    v41._canvasHeight = -1
    v41._dirty = true
end

local function _isInView(v45, v46) -- line 248
    local v47 = v46.cameraCFrame:PointToObjectSpace(v45._center)
    local _radius = v45._radius
    local v48 = v47.Magnitude - _radius
    if v45._maxDistance < v48 then
        return false
    end
    local v49 = -v47.Z
    if -_radius < v49 then
        local X = v47.X
        if math.abs(X) <= v49 * v46.tanX + _radius * v46.secX then
            local Y = v47.Y
            return math.abs(Y) <= v49 * v46.tanY + _radius * v46.secY
        end
    end
    return false
end

v4._isInView = _isInView

function v4._render(v50, v51) -- line 264 | captures: Projection
    if not (v51.changed or v50._dirty) then
        return
    end
    v50._dirty = false
    local _rig = v50._rig
    local cameraPosition = v51.cameraPosition
    local _surfaceSize = v50._surfaceSize
    local v52 = v50:_isInView(v51)
    local v53, v54, v55, v56, v57
    if v52 then
        local v58
        v53, v54, v55, v56, v57, v58 = Projection.solve(cameraPosition, v50._surfaceCFrame, _surfaceSize)
        v52 = v58 > 0
    else
        v53 = 0
        v54 = 0
        v55 = 1
        v56 = 1
        v57 = 1
    end
    if v52 ~= v50._visible then
        v50._visible = v52
        _rig.surfaceGui.Enabled = v52
    end
    if not v52 then
        return
    end
    local viewportHeight = v51.viewportHeight
    if viewportHeight ~= v50._canvasHeight then
        v50._canvasHeight = viewportHeight
        _rig.surfaceGui.CanvasSize = Vector2.new(viewportHeight * _surfaceSize.X / _surfaceSize.Y, viewportHeight)
    end
    _rig.viewport.Position = UDim2.fromScale(0.5 - v53, 0.5 - v54)
    _rig.viewport.Size = UDim2.fromScale(v55, v55)
    _rig.camera.FieldOfView = v56
    _rig.camera.CFrame = Projection.getCameraCFrame(cameraPosition, v50._viewRotation, v57)
end

return v4

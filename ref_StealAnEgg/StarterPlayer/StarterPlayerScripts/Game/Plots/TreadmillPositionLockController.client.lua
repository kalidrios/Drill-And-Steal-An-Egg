-- StarterPlayer.StarterPlayerScripts.Game.Plots.TreadmillPositionLockController
-- Keeps the local player pinned to their treadmill's Root anchor point (X/Z position only,
-- every frame) while an active treadmill session is running, AND blocks WASD/arrow-key
-- movement input for the duration (character stays still) while leaving jump and camera
-- zoom/rotate completely untouched.
--
-- REBUILT (user report: "en el original tocas la treadmill y el jugador se pone en el Root").
-- A controller with this exact job existed in this project before -- confirmed by this
-- session's own notes describing it in detail (re-anchors X/Z every frame at
-- RenderPriority.Last+1, and used to also zero Humanoid.WalkSpeed) -- but there is zero trace
-- of it anywhere in the current place: not the script, not the name, nothing. A clean loss
-- (this MCP plugin's edits are known to sometimes not persist across sessions), not something
-- removed on purpose.
--
-- Rebuilt from scratch, reusing the one lesson already learned and documented from the lost
-- version: it used to also set Humanoid.WalkSpeed = 0, which broke the run/turn animation
-- completely (Animate's run-vs-idle decision keys off the humanoid's REPORTED speed via
-- Humanoid.Running, which derives from WalkSpeed -- a real WalkSpeed of 0 always reports ~0
-- speed no matter how hard you hold a movement key, leaving the character frozen like a statue
-- and unable to even turn). This version ONLY re-anchors X/Z position every frame (last, after
-- Animate has already run, so it doesn't fight the animation) and leaves rotation and
-- WalkSpeed alone -- that alone is enough to stop the player from actually drifting off the
-- belt mid-session, while still letting Animate/AutoRotate see real movement and animate/turn
-- normally.
--
-- SESSION 2026-08-25, attempt 1 (user report: "el personaje esta como una roca, no se puede
-- mover, wasd no afecta" wanted explicitly, plus camera zoom/rotate should keep working): tried
-- PlayerModule:GetControls():Disable(). REGRESSION reported immediately: jumping stopped
-- exiting the treadmill and camera zoom/rotate got stuck. Controls:Disable() unbinds
-- ControlModule's entire input pipeline (movement AND everything else it owns) and halts its
-- per-frame update loop -- too blunt an instrument for a game with a custom "Kernel" bootstrap
-- (this project has no stock PlayerModule under StarterPlayerScripts, it's runtime-injected),
-- and TreadmillUI's jump-to-exit relies on UserInputService.JumpRequest still firing normally.
--
-- SESSION 2026-08-25, attempt 2: reverted Controls:Disable() entirely. Instead, bind a
-- ContextActionService action for ONLY the movement keys (WASD + arrows) at a priority higher
-- than ControlModule's own internal binding (Enum.ContextActionPriority.High + 1) and Sink the
-- input there -- ControlModule's Keyboard controller (bound at its default, lower priority)
-- never even sees the keypress, so Humanoid never gets a Move() request and Animate settles on
-- Idle cleanly (no WalkSpeed=0 stuck-animation bug either). Jump (Space) and camera controls
-- are completely different bindings, untouched by this, so both keep working exactly as before.
-- Kept the per-frame X/Z reanchor as a belt-and-suspenders guard against residual physics drift
-- (Y is left alone on purpose so a vertical jump arc is never fought).

local ContextActionService = game:GetService("ContextActionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Constants = require(ReplicatedStorage.Library.Globals.Constants)
local Network = require(ReplicatedStorage.Library.Client.Network)
local RuntimeInstanceRegistry = require(ReplicatedStorage.Library.Modules.RuntimeInstanceRegistry)

local Treadmills = Constants.NETWORK_MAP.Treadmills
local LocalPlayer = Players.LocalPlayer

local MOVEMENT_BLOCK_ACTION = "TreadmillMovementBlock"
local MOVEMENT_KEYS = {
	Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D,
	Enum.KeyCode.Up, Enum.KeyCode.Left, Enum.KeyCode.Down, Enum.KeyCode.Right,
}

local function sinkMovementInput()
	return Enum.ContextActionResult.Sink
end

local movementBlocked = false
local function setMovementBlocked(blocked: boolean)
	if blocked == movementBlocked then
		return
	end
	movementBlocked = blocked

	if blocked then
		ContextActionService:BindActionAtPriority(
			MOVEMENT_BLOCK_ACTION,
			sinkMovementInput,
			false,
			Enum.ContextActionPriority.High.Value + 1,
			table.unpack(MOVEMENT_KEYS)
		)
	else
		ContextActionService:UnbindAction(MOVEMENT_BLOCK_ACTION)
	end
end

local activeTreadmillId: string? = nil

Network.Fired(Treadmills.ACTIVE_TREADMILL_EVENT):Connect(function(s2: string?)
	activeTreadmillId = s2
	setMovementBlocked(s2 ~= nil)
end)

RunService:BindToRenderStep("TreadmillPositionLock", Enum.RenderPriority.Last.Value + 1, function()
	if activeTreadmillId == nil then
		return
	end

	local model = RuntimeInstanceRegistry.Get("Treadmill", activeTreadmillId)
	local root = model and model:FindFirstChild("Root")
	if not (root and root:IsA("BasePart")) then
		return
	end

	local character = LocalPlayer.Character
	local hrp = character and character:FindFirstChild("HumanoidRootPart")
	if not hrp then
		return
	end

	local current = hrp.CFrame
	hrp.CFrame = (current - current.Position) + Vector3.new(root.Position.X, current.Position.Y, root.Position.Z)
end)

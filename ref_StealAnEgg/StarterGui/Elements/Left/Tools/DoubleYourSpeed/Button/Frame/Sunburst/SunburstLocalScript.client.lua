-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMICFJvdGF0aW9uBGdhbWUKUnVuU2VydmljZQpHZXRTZXJ2aWNlBnNjcmlwdAZQYXJlbnQNUmVuZGVyU3RlcHBlZAdDb25uZWN0AAIEAQIAAAAL+wEAAIwDFAAJAgMAQwEBAt4BAAD7AQEA+wMAACECAwAwAgE4AQAAAIIAAQACAgAAAAAAgHZAAwEABgABGAAAAAAAAQAAAAABBwAAAAAGAAABAgAWowAAAKQAAQAAAABAbwICALwAABYDAAAAnwADAqQBBQAAAEBATQEBJAYAAACMAgAATQMAzwcAAADZBQAAEgEC/xIAAQC8AwPHCAAAAJ8DAwHBAgAAggABAAkDAgQAAABAAwMDBAMFBAAAQEADBgMHAwgBAAEAARgAAQAAAAAAAQAAAAECAAAAAAAAAAQAAQAAAAAB+7Db3oCuC+ff62exgttXBouozKrJdLHf

-- decompilation:
local RunService = game:GetService("RunService")
local scriptParent = script.Parent
local n1 = 0.0

RunService.RenderStepped:Connect(function(dt) -- line: 6
	-- upvalues: n1 (ref), scriptParent (copy)
	n1 += 20.0 * dt
	scriptParent.Rotation = n1 % 360.0
end)


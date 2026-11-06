local l__Modules__1 = game:GetService("ReplicatedStorage"):WaitForChild("Library"):WaitForChild("Modules");
local v2 = require(l__Modules__1.DefaultStats);
local u1 = require(script.Parent.ComputeSaveAge);
local u2 = require(l__Modules__1.Daycare);
return function(p1, p2, p3)
    local v3 = p3 or workspace:GetServerTimeNow();
    local v = u1(p1, v3)
    --warn(v, p2.CreationAge)
    local v4 = math.max(0, v - p2.CreationAge);
    local test = math.max(0, v3 - p2.CreationTime - v4)
    --warn(v4)
    --warn(test)
    local vt = (v4 * u2.ONLINE_SPEEDUP + test)
    --warn(vt)
    local r = math.max(0, u2.DURATION_SECONDS - vt)
   -- warn(r)
    return r;
end;


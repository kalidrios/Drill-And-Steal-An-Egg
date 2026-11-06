-- Como sou pouco e sei pouco faço pouco que me cabe dado por inteiro

local v1 = {
	Optional = {}
};
local l__Players__1 = game:GetService("Players");
function v1.Player(p1)
	return p1 or l__Players__1.LocalPlayer;
end;
v1.Optional.Character = function(p2)
	return v1.Player(p2).Character;
end;
function v1.Character(p3)
	local v2 = v1.Player(p3);
	return v2.Character or v2.CharacterAdded:Wait();
end;
v1.Optional.PrimaryPart = function(p4)
	local v3 = v1.Optional.Character(p4);
	return v3 and v3.PrimaryPart;
end;
function v1.PrimaryPart(p5)
	local v4 = v1.Character(p5);
	local l__PrimaryPart__5 = v4.PrimaryPart;
	if l__PrimaryPart__5 then
		return l__PrimaryPart__5;
	end;
	v4:WaitForChild("HumanoidRootPart", math.huge);
	local l__PrimaryPart__6 = v4.PrimaryPart;
	assert(l__PrimaryPart__6);
	return l__PrimaryPart__6;
end;
v1.Optional.Humanoid = function(p6)
	local v7 = v1.Optional.Character(p6);
	return v7 and v7:FindFirstChildOfClass("Humanoid");
end;
function v1.Humanoid(p7)
	local v8 = v1.Character(p7);
	local v9 = v8:FindFirstChildOfClass("Humanoid");
	if v9 then
		return v9;
	end;
	v8:WaitForChild("Humanoid", math.huge);
	local v10 = v8:FindFirstChildOfClass("Humanoid");
	assert(v10);
	return v10;
end;
v1.Optional.Part = function(p8, p9)
	return v1.Character(p8):FindFirstChild(p9);
end;
function v1.Part(p10, p11)
	return v1.Character(p10):WaitForChild(p11, math.huge);
end;
v1.Optional.EmbeddedPart = function(p12, p13, p14)
	local v11 = v1.Optional.Part(p12, p13);
	return v11 and v11:FindFirstChild(p14);
end;
function v1.EmbeddedPart(p15, p16, p17)
	return v1.Part(p15, p16):WaitForChild(p17, math.huge);
end;
v1.Optional.Head = function(p18)
	return v1.Optional.Part(p18, "Head");
end;
function v1.Head(p19)
	return v1.Part(p19, "Head");
end;
v1.Optional.UpperTorso = function(p20)
	return v1.Optional.Part(p20, "UpperTorso");
end;
function v1.UpperTorso(p21)
	return v1.Part(p21, "UpperTorso");
end;
v1.Optional.LowerTorso = function(p22)
	return v1.Optional.Part(p22, "LowerTorso");
end;
function v1.LowerTorso(p23)
	return v1.Part(p23, "LowerTorso");
end;
v1.Optional.LeftFoot = function(p24)
	return v1.Optional.Part(p24, "LeftFoot");
end;
function v1.LeftFoot(p25)
	return v1.Part(p25, "LeftFoot");
end;
v1.Optional.LeftHand = function(p26)
	return v1.Optional.Part(p26, "LeftHand");
end;
function v1.LeftHand(p27)
	return v1.Part(p27, "LeftHand");
end;
v1.Optional.LeftLowerArm = function(p28)
	return v1.Optional.Part(p28, "LeftLowerArm");
end;
function v1.LeftLowerArm(p29)
	return v1.Part(p29, "LeftLowerArm");
end;
v1.Optional.LeftLowerLeg = function(p30)
	return v1.Optional.Part(p30, "LeftLowerLeg");
end;
function v1.LeftLowerLeg(p31)
	return v1.Part(p31, "LeftLowerLeg");
end;
v1.Optional.LeftUpperArm = function(p32)
	return v1.Optional.Part(p32, "LeftUpperArm");
end;
function v1.LeftUpperArm(p33)
	return v1.Part(p33, "LeftUpperArm");
end;
v1.Optional.LeftUpperLeg = function(p34)
	return v1.Optional.Part(p34, "LeftUpperLeg");
end;
function v1.LeftUpperLeg(p35)
	return v1.Part(p35, "LeftUpperLeg");
end;
v1.Optional.RightFoot = function(p36)
	return v1.Optional.Part(p36, "RightFoot");
end;
function v1.RightFoot(p37)
	return v1.Part(p37, "RightFoot");
end;
v1.Optional.RightHand = function(p38)
	return v1.Optional.Part(p38, "RightHand");
end;
function v1.RightHand(p39)
	return v1.Part(p39, "RightHand");
end;
v1.Optional.RightLowerArm = function(p40)
	return v1.Optional.Part(p40, "RightLowerArm");
end;
function v1.RightLowerArm(p41)
	return v1.Part(p41, "RightLowerArm");
end;
v1.Optional.RightLowerLeg = function(p42)
	return v1.Optional.Part(p42, "RightLowerLeg");
end;
function v1.RightLowerLeg(p43)
	return v1.Part(p43, "RightLowerLeg");
end;
v1.Optional.RightUpperArm = function(p44)
	return v1.Optional.Part(p44, "RightUpperArm");
end;
function v1.RightUpperArm(p45)
	return v1.Part(p45, "RightUpperArm");
end;
v1.Optional.RightUpperLeg = function(p46)
	return v1.Optional.Part(p46, "RightUpperLeg");
end;
function v1.RightUpperLeg(p47)
	return v1.Part(p47, "RightUpperLeg");
end;
v1.Optional.Root = function(p48)
	return v1.Optional.EmbeddedPart(p48, "LowerTorso", "Root");
end;
function v1.Root(p49)
	return v1.EmbeddedPart(p49, "LowerTorso", "Root");
end;
v1.Optional.Waist = function(p50)
	return v1.Optional.EmbeddedPart(p50, "UpperTorso", "Waist");
end;
function v1.Waist(p51)
	return v1.EmbeddedPart(p51, "UpperTorso", "Waist");
end;
v1.Optional.Neck = function(p52)
	return v1.Optional.EmbeddedPart(p52, "Head", "Neck");
end;
function v1.Neck(p53)
	return v1.EmbeddedPart(p53, "Head", "Neck");
end;
v1.Optional.LeftAnkle = function(p54)
	return v1.Optional.EmbeddedPart(p54, "LeftFoot", "LeftAnkle");
end;
function v1.LeftAnkle(p55)
	return v1.EmbeddedPart(p55, "LeftFoot", "LeftAnkle");
end;
v1.Optional.LeftWrist = function(p56)
	return v1.Optional.EmbeddedPart(p56, "LeftHand", "LeftWrist");
end;
function v1.LeftWrist(p57)
	return v1.EmbeddedPart(p57, "LeftHand", "LeftWrist");
end;
v1.Optional.LeftElbow = function(p58)
	return v1.Optional.EmbeddedPart(p58, "LeftLowerArm", "LeftElbow");
end;
function v1.LeftElbow(p59)
	return v1.EmbeddedPart(p59, "LeftLowerArm", "LeftElbow");
end;
v1.Optional.LeftKnee = function(p60)
	return v1.Optional.EmbeddedPart(p60, "LeftLowerLeg", "LeftKnee");
end;
function v1.LeftKnee(p61)
	return v1.EmbeddedPart(p61, "LeftLowerLeg", "LeftKnee");
end;
v1.Optional.LeftShoulder = function(p62)
	return v1.Optional.EmbeddedPart(p62, "LeftUpperArm", "LeftShoulder");
end;
function v1.LeftShoulder(p63)
	return v1.EmbeddedPart(p63, "LeftUpperArm", "LeftShoulder");
end;
v1.Optional.LeftHip = function(p64)
	return v1.Optional.EmbeddedPart(p64, "LeftUpperLeg", "LeftHip");
end;
function v1.LeftHip(p65)
	return v1.EmbeddedPart(p65, "LeftUpperLeg", "LeftHip");
end;
v1.Optional.RightAnkle = function(p66)
	return v1.Optional.EmbeddedPart(p66, "RightFoot", "RightAnkle");
end;
function v1.RightAnkle(p67)
	return v1.EmbeddedPart(p67, "RightFoot", "RightAnkle");
end;
v1.Optional.RightWrist = function(p68)
	return v1.Optional.EmbeddedPart(p68, "RightHand", "RightWrist");
end;
function v1.RightWrist(p69)
	return v1.EmbeddedPart(p69, "RightHand", "RightWrist");
end;
v1.Optional.RightElbow = function(p70)
	return v1.Optional.EmbeddedPart(p70, "RightLowerArm", "RightElbow");
end;
function v1.RightElbow(p71)
	return v1.EmbeddedPart(p71, "RightLowerArm", "RightElbow");
end;
v1.Optional.RightKnee = function(p72)
	return v1.Optional.EmbeddedPart(p72, "RightLowerLeg", "RightKnee");
end;
function v1.RightKnee(p73)
	return v1.EmbeddedPart(p73, "RightLowerLeg", "RightKnee");
end;
v1.Optional.RightShoulder = function(p74)
	return v1.Optional.EmbeddedPart(p74, "RightUpperArm", "RightShoulder");
end;
function v1.RightShoulder(p75)
	return v1.EmbeddedPart(p75, "RightUpperArm", "RightShoulder");
end;
v1.Optional.RightHip = function(p76)
	return v1.Optional.EmbeddedPart(p76, "RightUpperLeg", "RightHip");
end;
function v1.RightHip(p77)
	return v1.EmbeddedPart(p77, "RightUpperLeg", "RightHip");
end;
v1.Optional.PlayerGui = function(p78)
	return v1.Player(p78):FindFirstChild("PlayerGui");
end;
function v1.PlayerGui(p79)
	return v1.Player(p79):WaitForChild("PlayerGui", math.huge);
end;
function v1.Mouse(p80)
	return v1.Player(p80):GetMouse();
end;
function v1.Camera(p81)
	return workspace.CurrentCamera;
end;
function v1.Name(p82)
	return v1.Player(p82).Name;
end;
function v1.DisplayName(p83)
	return v1.Player(p83).DisplayName;
end;
v1.Optional.Animator = function(p84)
	local v12 = v1.Optional.Humanoid(p84);
	if not v12 then
		return nil;
	end;
	local v13 = v12:FindFirstChildOfClass("Animator");
	if v13 then
		return v13;
	end;
	local v14 = v12:FindFirstChildOfClass("AnimationController");
	if v14 then
		return v14;
	end;
	return v12;
end;
function v1.Animator(p85)
	local v15 = v1.Humanoid(p85);
	local v16 = v15:FindFirstChildOfClass("Animator");
	if v16 then
		return v16;
	end;
	local v17 = v15:FindFirstChildOfClass("AnimationController");
	if v17 then
		return v17;
	end;
	return v15;
end;
return v1;

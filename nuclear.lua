-- =================================================================
-- Nuclear (Official Edition - Fixed & Fully Working + FFlags)
-- =================================================================
pcall(function()
local old = (gethui and gethui():FindFirstChild("Nuclear"))
or game:GetService("CoreGui"):FindFirstChild("Nuclear")
or game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Nuclear")
if old then old:Destroy() end
end)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")
local StatsService = game:GetService("Stats")
local SoundService = game:GetService("SoundService")
local MarketplaceService = game:GetService("MarketplaceService")
local LocalPlayer = Players.LocalPlayer

local function GetCamera()
return workspace.CurrentCamera
end

local TargetParent = (gethui and gethui()) or game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")

-- Палитра цветов для визуалов
local ColorPresets = {
["Blue"]   = Color3.fromRGB(0, 150, 255),
["Red"]    = Color3.fromRGB(255, 50, 50),
["Green"]  = Color3.fromRGB(50, 255, 100),
["Yellow"] = Color3.fromRGB(255, 220, 50),
["Orange"] = Color3.fromRGB(255, 140, 0),
["Purple"] = Color3.fromRGB(180, 50, 255),
["White"]  = Color3.fromRGB(255, 255, 255)
}
local ColorNames = {"Blue", "Red", "Green", "Yellow", "Orange", "Purple", "White"}

local DarkRedColor = Color3.fromRGB(160, 0, 0)

local CFG = {
-- Аимбот (все включения по умолчанию false)
AimEnabled = false,
AimPart = "Head",
AimFOV = 150,
Smoothness = 5,
SmoothType = "Dynamic Bezier",
TeamCheck = false,
Prediction = false,
PredictionFactor = 1.0,
VisibilityCheck = false,
SilentAim = false,
RecoilCompensation = 1.0,
FovCircleHidden = false,
Humanization = false,

Spinbot = false, SpinSpeed = 50,  

HitboxEnabled = false, HitboxSize = 6, HitboxGlow = false, HitboxColor = Color3.fromRGB(255, 30, 30), HitboxTrans = 40,  

-- Визуалы (все выключены)  
ESP_Box = false, ESP_Name = false, ESP_Health = false, ESP_Dist = false, Tracers = false, Crosshair = false,    
ESP_Highlight = false,  

-- Цвета для визуальных элементов  
BoxColor = ColorPresets["White"],  
TracerColor = ColorPresets["White"],  
DistanceColor = ColorPresets["White"],  
HighlightColor = ColorPresets["Green"],  
HighlightTrans = 0.4,  

ChamsEnabled = false, ChamsColor = Color3.fromRGB(255, 30, 30), ChamsTrans = 20,    
    
Speed = false, SpeedVal = 100, Jump = false, JumpVal = 80,     
Bhop = false, Noclip = false, InfJump = false, Invisible = false,    
GravityEnabled = false, GravityVal = 50, CamFOVEnabled = false, CamFOVVal = 70,    
FakeLag = false, FakeLagVal = 0.15,    
  
-- Размеры и прозрачность UI  
MenuWidth = 750,    
MenuHeight = 500,    
MenuScale = 1,    
MenuTransparency = 0,  
AccentColor = DarkRedColor,  

-- HUD / Counters  
HUD_FPS = false,  
HUD_Ping = false,  
HUD_Speed = false,  
HUD_Scale = 1,  
HUD_BgColor = Color3.fromRGB(0, 0, 0),  
HUD_Transparency = 0.2,  

HitmarkerEnabled = false,    
HitSoundID = "8367426384", KillSoundID = "6822839075", MusicID = "", MusicPitch = 1, MusicVolume = 0.5,    
MacroEnabled = false, MacroCPS = 10, MacroKey = Enum.KeyCode.Q, MacroKeyPressed = false,    
  
ComboEnabled = false,  
ComboKey = Enum.KeyCode.C,  
ComboDelay = 0.05,  
ComboKeysText = "Space, One, E",  
  
Fullbright = false, FPSBoost = false, AntiAFK = false,    

-- Shaders CFG
ShadersEnabled = false,
ShaderPreset = "Default",
ShaderBrightness = 0,
ShaderContrast = 0.1,
ShaderSaturation = 0.2,
ShaderBloom = 0.4,
ShaderSunRays = 0.1,

-- FFlags CFG
CustomFFlagsCode = "",

-- Executor CFG
AutoRunEnabled = false,
AutoRunCode = ""
}

local Keybinds = {
Aimbot = Enum.KeyCode.E,
Noclip = Enum.KeyCode.N,
Speed = Enum.KeyCode.X,
Invisible = Enum.KeyCode.V,
Panic = Enum.KeyCode.Delete,
Combo = Enum.KeyCode.C
}

local ThemeElements = {
MainFrames = {}, Sidebars = {}, Sections = {}, Texts = {}, SubTexts = {}, Accents = {}, Switches = {}, Fills = {}
}

local function RegisterElement(elementType, obj)
if ThemeElements[elementType] then table.insert(ThemeElements[elementType], obj) end
return obj
end

-- Черная AMOLED тема по умолчанию
local CurrentTheme = {
Name = "Pure AMOLED Dark",
MainBg = Color3.fromRGB(0, 0, 0),
SidebarBg = Color3.fromRGB(6, 6, 8),
SectionBg = Color3.fromRGB(12, 12, 15),
Text = Color3.fromRGB(255, 255, 255),
SubText = Color3.fromRGB(160, 160, 170),
Accent = DarkRedColor
}

CFG.AccentColor = CurrentTheme.Accent

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Nuclear"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = TargetParent

local MenuUIScale = Instance.new("UIScale", ScreenGui)
MenuUIScale.Scale = CFG.MenuScale

local LocalBoomboxSound = Instance.new("Sound")
LocalBoomboxSound.Name = "LocalBoombox"
LocalBoomboxSound.Volume = CFG.MusicVolume
LocalBoomboxSound.Looped = true
LocalBoomboxSound.Parent = LocalPlayer:WaitForChild("PlayerGui")

local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false
FOVCircle.Thickness = 1.5
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Filled = false
FOVCircle.Radius = CFG.AimFOV

local CrosshairFrame = Instance.new("Frame", ScreenGui)
CrosshairFrame.Size = UDim2.new(0, 16, 0, 16)
CrosshairFrame.AnchorPoint = Vector2.new(0.5, 0.5)
CrosshairFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
CrosshairFrame.BackgroundTransparency = 1
CrosshairFrame.Visible = false

local CH_V = Instance.new("Frame", CrosshairFrame)
CH_V.Size = UDim2.new(0, 2, 1, 0)
CH_V.Position = UDim2.new(0.5, -1, 0, 0)
CH_V.BorderSizePixel = 0
CH_V.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

local CH_H = Instance.new("Frame", CrosshairFrame)
CH_H.Size = UDim2.new(1, 0, 0, 2)
CH_H.Position = UDim2.new(0, 0, 0.5, -1)
CH_H.BorderSizePixel = 0
CH_H.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

-- ==================== HITMARKER & SOUND ENGINE ====================
local HitmarkerGui = Instance.new("Frame", ScreenGui)
HitmarkerGui.Size = UDim2.new(0, 16, 0, 16)
HitmarkerGui.AnchorPoint = Vector2.new(0.5, 0.5)
HitmarkerGui.Position = UDim2.new(0.5, 0, 0.5, 0)
HitmarkerGui.BackgroundTransparency = 1
HitmarkerGui.Visible = false

for _, pos in ipairs({
UDim2.new(0, 0, 0, 0), UDim2.new(0, 10, 0, 0),
UDim2.new(0, 0, 0, 10), UDim2.new(0, 10, 0, 10)
}) do
local hm = Instance.new("Frame", HitmarkerGui)
hm.Size = UDim2.new(0, 6, 0, 2)
hm.Position = pos
hm.BorderSizePixel = 0
hm.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
end

local function PlayLocalSound(id, vol)
if not id or id == "" then return end
local cleanId = tostring(id):gsub("%D", "")
if cleanId == "" then return end

task.spawn(function()  
    local snd = Instance.new("Sound")  
    snd.SoundId = "rbxassetid://" .. cleanId  
    snd.Volume = vol or 1  
    snd.Parent = SoundService  
    snd:Play()  
    snd.Ended:Connect(function()  
        snd:Destroy()  
    end)  
    task.delay(3, function() if snd and snd.Parent then snd:Destroy() end end)  
end)

end

local function TriggerHitmarkerEffect()
if not CFG.HitmarkerEnabled then return end
HitmarkerGui.Visible = true
HitmarkerGui.Size = UDim2.new(0, 22, 0, 22)
TweenService:Create(HitmarkerGui, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
Size = UDim2.new(0, 14, 0, 14)
}):Play()

task.delay(0.2, function()  
    if HitmarkerGui.Size == UDim2.new(0, 14, 0, 14) then  
        HitmarkerGui.Visible = false  
    end  
end)

end

local TrackedHealth = {}
RunService.Heartbeat:Connect(function()
for _, p in ipairs(Players:GetPlayers()) do
if p ~= LocalPlayer and p.Character then
local hum = p.Character:FindFirstChildOfClass("Humanoid")
if hum then
local lastH = TrackedHealth[p] or hum.Health
if hum.Health < lastH and hum.Health > 0 then
TriggerHitmarkerEffect()
PlayLocalSound(CFG.HitSoundID, 1.2)
elseif hum.Health <= 0 and lastH > 0 then
TriggerHitmarkerEffect()
PlayLocalSound(CFG.KillSoundID, 1.5)
end
TrackedHealth[p] = hum.Health
end
end
end
end)

local ESP_List = {}
local GhostClone = nil
local GhostConnection = nil

-- ==================== DRAWING ESP SYSTEM ====================
local function CreatePlayerESP(p)
if ESP_List[p] then return end
local drawings = {
BoxOutline = Drawing.new("Square"),
Box = Drawing.new("Square"),
Name = Drawing.new("Text"),
Distance = Drawing.new("Text"),
Tracer = Drawing.new("Line"),
HealthBarBg = Drawing.new("Line"),
HealthBar = Drawing.new("Line")
}

drawings.BoxOutline.Thickness = 3  
drawings.BoxOutline.Filled = false  
drawings.BoxOutline.Color = Color3.fromRGB(0, 0, 0)  
drawings.BoxOutline.Visible = false  

drawings.Box.Thickness = 1  
drawings.Box.Filled = false  
drawings.Box.Color = Color3.fromRGB(255, 255, 255)  
drawings.Box.Visible = false  

drawings.Name.Size = 13  
drawings.Name.Center = true  
drawings.Name.Outline = true  
drawings.Name.Color = Color3.fromRGB(255, 255, 255)  
drawings.Name.Visible = false  

drawings.Distance.Size = 12  
drawings.Distance.Center = true  
drawings.Distance.Outline = true  
drawings.Distance.Color = Color3.fromRGB(210, 210, 210)  
drawings.Distance.Visible = false  

drawings.Tracer.Thickness = 1.5  
drawings.Tracer.Color = Color3.fromRGB(255, 255, 255)  
drawings.Tracer.Visible = false  

drawings.HealthBarBg.Thickness = 3  
drawings.HealthBarBg.Color = Color3.fromRGB(0, 0, 0)  
drawings.HealthBarBg.Visible = false  

drawings.HealthBar.Thickness = 1.5  
drawings.HealthBar.Color = Color3.fromRGB(0, 255, 0)  
drawings.HealthBar.Visible = false  

ESP_List[p] = drawings

end

local function RemovePlayerESP(p)
if ESP_List[p] then
for _, obj in pairs(ESP_List[p]) do
pcall(function() obj:Remove() end)
end
ESP_List[p] = nil
end
end

for _, p in ipairs(Players:GetPlayers()) do
if p ~= LocalPlayer then CreatePlayerESP(p) end
end
Players.PlayerAdded:Connect(function(p)
if p ~= LocalPlayer then CreatePlayerESP(p) end
end)
Players.PlayerRemoving:Connect(RemovePlayerESP)

local function UpdateDrawingESP()
local Camera = GetCamera()
if not Camera then return end
local myChar = LocalPlayer.Character
local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")

if FOVCircle then  
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)  
end  

for p, drawings in pairs(ESP_List) do  
    local char = p.Character  
    local hum = char and char:FindFirstChildOfClass("Humanoid")  
    local root = char and char:FindFirstChild("HumanoidRootPart")  
    local head = char and char:FindFirstChild("Head")  

    local isTeam = false  
    if CFG.TeamCheck and p.Team and LocalPlayer.Team and p.Team == LocalPlayer.Team then  
        isTeam = true  
    end  

    if char and hum and root and head and hum.Health > 0 and not isTeam then  
        local rootPos, onScreen = Camera:WorldToViewportPoint(root.Position)  
        local head3D = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))  
        local leg3D = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))  

        if onScreen and head3D.Z > 0 and leg3D.Z > 0 then  
            local boxHeight = math.abs(head3D.Y - leg3D.Y)  
            local boxWidth = boxHeight * 0.65  
            local boxPos = Vector2.new(head3D.X - boxWidth / 2, head3D.Y)  

            if CFG.ESP_Box then  
                drawings.BoxOutline.Size = Vector2.new(boxWidth, boxHeight)  
                drawings.BoxOutline.Position = boxPos  
                drawings.BoxOutline.Visible = true  

                drawings.Box.Size = Vector2.new(boxWidth, boxHeight)  
                drawings.Box.Position = boxPos  
                drawings.Box.Color = CFG.BoxColor or Color3.fromRGB(255, 255, 255)  
                drawings.Box.Visible = true  
            else  
                drawings.Box.Visible = false  
                drawings.BoxOutline.Visible = false  
            end  

            if CFG.ESP_Name then  
                drawings.Name.Text = p.DisplayName or p.Name  
                drawings.Name.Position = Vector2.new(head3D.X, boxPos.Y - 16)  
                drawings.Name.Visible = true  
            else  
                drawings.Name.Visible = false  
            end  

            if CFG.ESP_Health then  
                local healthPercent = math.clamp(hum.Health / hum.MaxHealth, 0, 1)  
                local barX = boxPos.X - 5  
                  
                drawings.HealthBarBg.From = Vector2.new(barX, boxPos.Y)  
                drawings.HealthBarBg.To = Vector2.new(barX, boxPos.Y + boxHeight)  
                drawings.HealthBarBg.Visible = true  

                local fillHeight = boxHeight * healthPercent  
                drawings.HealthBar.From = Vector2.new(barX, boxPos.Y + boxHeight)  
                drawings.HealthBar.To = Vector2.new(barX, boxPos.Y + boxHeight - fillHeight)  
                drawings.HealthBar.Color = Color3.fromRGB(255, 0, 0):Lerp(Color3.fromRGB(0, 255, 0), healthPercent)  
                drawings.HealthBar.Visible = true  
            else  
                drawings.HealthBarBg.Visible = false  
                drawings.HealthBar.Visible = false  
            end  

            if CFG.ESP_Dist and myRoot then  
                local dist = math.floor((root.Position - myRoot.Position).Magnitude)  
                drawings.Distance.Text = "[" .. dist .. "m]"  
                drawings.Distance.Position = Vector2.new(head3D.X, boxPos.Y + boxHeight + 2)  
                drawings.Distance.Color = CFG.DistanceColor or Color3.fromRGB(210, 210, 210)  
                drawings.Distance.Visible = true  
            else  
                drawings.Distance.Visible = false  
            end  

            if CFG.Tracers then  
                drawings.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)  
                drawings.Tracer.To = Vector2.new(rootPos.X, rootPos.Y)  
                drawings.Tracer.Color = CFG.TracerColor or Color3.fromRGB(255, 255, 255)  
                drawings.Tracer.Visible = true  
            else  
                drawings.Tracer.Visible = false  
            end  
        else  
            for _, obj in pairs(drawings) do obj.Visible = false end  
        end  
    else  
        for _, obj in pairs(drawings) do obj.Visible = false end  
    end  
end

end

RunService.RenderStepped:Connect(UpdateDrawingESP)

-- ==================== HIGHLIGHT & CHAMS & HITBOX ENGINE ====================
local function UpdateVisualEffects()
for _, p in ipairs(Players:GetPlayers()) do
if p ~= LocalPlayer and p.Character then
local char = p.Character
local hum = char:FindFirstChildOfClass("Humanoid")
local root = char:FindFirstChild("HumanoidRootPart")

local isTeam = false  
        if CFG.TeamCheck and p.Team and LocalPlayer.Team and p.Team == LocalPlayer.Team then  
            isTeam = true  
        end  

        if hum and hum.Health > 0 and not isTeam then  
            local hl = char:FindFirstChild("NuclearHighlight")  
            if CFG.ESP_Highlight then  
                if not hl then  
                    hl = Instance.new("Highlight")  
                    hl.Name = "NuclearHighlight"  
                    hl.Parent = char  
                end  
                hl.FillColor = CFG.HighlightColor  
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)  
                hl.FillTransparency = CFG.HighlightTrans  
                hl.OutlineTransparency = 0.1  
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop  
                hl.Enabled = true  
            elseif hl then  
                hl:Destroy()  
            end  

            local chams = char:FindFirstChild("NuclearChams")  
            if CFG.ChamsEnabled then  
                if not chams then  
                    chams = Instance.new("Highlight")  
                    chams.Name = "NuclearChams"  
                    chams.Parent = char  
                end  
                chams.FillColor = CFG.ChamsColor  
                chams.OutlineColor = CFG.ChamsColor  
                chams.FillTransparency = CFG.ChamsTrans / 100  
                chams.OutlineTransparency = 0  
                chams.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop  
                chams.Enabled = true  
            elseif chams then  
                chams:Destroy()  
            end  

            if root then  
                if CFG.HitboxEnabled then  
                    root.Size = Vector3.new(CFG.HitboxSize, CFG.HitboxSize, CFG.HitboxSize)  
                    root.Transparency = CFG.HitboxTrans / 100  
                    root.CanCollide = false  
                      
                    local glow = root:FindFirstChild("NuclearHitboxGlow")  
                    if CFG.HitboxGlow then  
                        if not glow then  
                            glow = Instance.new("SelectionBox")  
                            glow.Name = "NuclearHitboxGlow"  
                            glow.Adornee = root  
                            glow.Parent = root  
                        end  
                        glow.Color3 = CFG.HitboxColor  
                        glow.LineThickness = 0.05  
                        glow.Transparency = CFG.HitboxTrans / 100  
                    elseif glow then  
                        glow:Destroy()  
                    end  
                else  
                    root.Size = Vector3.new(2, 2, 1)  
                    root.Transparency = 1  
                    local glow = root:FindFirstChild("NuclearHitboxGlow")  
                    if glow then glow:Destroy() end  
                end  
            end  
        else  
            local hl = char:FindFirstChild("NuclearHighlight")  
            if hl then hl:Destroy() end  
            local chams = char:FindFirstChild("NuclearChams")  
            if chams then chams:Destroy() end  
        end  
    end  
end

end

RunService.Heartbeat:Connect(UpdateVisualEffects)

-- ==================== AIMBOT ENGINE ====================
local function GetClosestTarget()
local Camera = GetCamera()
if not Camera then return nil end
local centerLoc = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
local closest, shortestDist = nil, CFG.AimFOV

for _, p in ipairs(Players:GetPlayers()) do  
    if p ~= LocalPlayer and p.Character then  
        local isTeam = false  
        if CFG.TeamCheck and p.Team and LocalPlayer.Team and p.Team == LocalPlayer.Team then  
            isTeam = true  
        end  

        local hum = p.Character:FindFirstChildOfClass("Humanoid")  
        local targetPart = p.Character:FindFirstChild(CFG.AimPart)   
            or p.Character:FindFirstChild("HumanoidRootPart")   
            or p.Character:FindFirstChild("Head")   
            or p.Character:FindFirstChild("Torso")  

        if hum and hum.Health > 0 and targetPart and not isTeam then  
            if CFG.VisibilityCheck then  
                local partsObscuring = Camera:GetPartsObscuringTarget({targetPart.Position}, {LocalPlayer.Character, p.Character})  
                if #partsObscuring > 0 then  
                    continue  
                end  
            end  

            local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)  
            if onScreen then  
                local dist = (Vector2.new(screenPos.X, screenPos.Y) - centerLoc).Magnitude  
                if dist < shortestDist then  
                    shortestDist = dist  
                    closest = targetPart  
                end  
            end  
        end  
    end  
end  
return closest

end

RunService.RenderStepped:Connect(function()
if CFG.AimEnabled then
local target = GetClosestTarget()
if target then
local Camera = GetCamera()
local targetPos = target.Position
if CFG.Prediction and target.Parent and target.Parent:FindFirstChild("HumanoidRootPart") then
local vel = target.Parent.HumanoidRootPart.AssemblyLinearVelocity
targetPos = targetPos + (vel * 0.033 * CFG.PredictionFactor)
end

local targetCFrame = CFrame.lookAt(Camera.CFrame.Position, targetPos)  
        if CFG.Smoothness > 0 then  
            Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, 1 / (CFG.Smoothness * 2 + 1))  
        else  
            Camera.CFrame = targetCFrame  
        end  
    end  
end

end)

-- ==================== MOVEMENT ENGINE ====================
RunService.Stepped:Connect(function()
local char = LocalPlayer.Character
if not char then return end
local hum = char:FindFirstChildOfClass("Humanoid")
local root = char:FindFirstChild("HumanoidRootPart")

if hum then  
    if CFG.Speed then hum.WalkSpeed = CFG.SpeedVal end  
    if CFG.Jump then hum.JumpPower = CFG.JumpVal end  
end  

if CFG.GravityEnabled then  
    workspace.Gravity = CFG.GravityVal  
end  

if CFG.Noclip then  
    for _, part in ipairs(char:GetDescendants()) do  
        if part:IsA("BasePart") then  
            part.CanCollide = false  
        end  
    end  
end  

if CFG.Spinbot and root then  
    root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(CFG.SpinSpeed), 0)  
end  

if CFG.Bhop and hum and hum.FloorMaterial ~= Enum.Material.Air then  
    hum:ChangeState(Enum.HumanoidStateType.Jumping)  
end  

if CFG.CamFOVEnabled then  
    local cam = GetCamera()  
    if cam then cam.FieldOfView = CFG.CamFOVVal end  
end

end)

UserInputService.JumpRequest:Connect(function()
if CFG.InfJump and LocalPlayer.Character then
local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
end
end)

-- ==================== ANTI-AFK & FULLBRIGHT ====================
LocalPlayer.Idled:Connect(function()
if CFG.AntiAFK then
VirtualUser:CaptureController()
VirtualUser:ClickButton2(Vector2.new())
end
end)

RunService.RenderStepped:Connect(function()
if CFG.Fullbright then
Lighting.Brightness = 2
Lighting.ClockTime = 14
Lighting.FogEnd = 100000
Lighting.GlobalShadows = false
Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
end
end)

-- ==================== THEMES & ACCENT SYSTEM ====================
local function ApplyTheme(theme)
CurrentTheme = theme
CFG.AccentColor = theme.Accent
for _, f in ipairs(ThemeElements.MainFrames) do pcall(function() f.BackgroundColor3 = theme.MainBg end) end
for _, f in ipairs(ThemeElements.Sidebars) do pcall(function() f.BackgroundColor3 = theme.SidebarBg end) end
for _, f in ipairs(ThemeElements.Sections) do pcall(function() f.BackgroundColor3 = theme.SectionBg end) end
for _, t in ipairs(ThemeElements.Texts) do pcall(function() t.TextColor3 = theme.Text end) end
for _, t in ipairs(ThemeElements.SubTexts) do pcall(function() t.TextColor3 = theme.SubText end) end
for _, s in ipairs(ThemeElements.Switches) do pcall(function() if s.Parent:GetAttribute("Active") then s.BackgroundColor3 = CFG.AccentColor end end) end
for _, fl in ipairs(ThemeElements.Fills) do pcall(function() fl.BackgroundColor3 = CFG.AccentColor end) end
end

local function PanicClean()
CFG.AimEnabled = false
CFG.HitboxEnabled = false
CFG.ESP_Box = false
CFG.ESP_Name = false
CFG.ESP_Health = false
CFG.ESP_Dist = false
CFG.ESP_Highlight = false
CFG.Tracers = false
CFG.Crosshair = false
CFG.ChamsEnabled = false
CFG.Speed = false
CFG.Jump = false
CFG.Bhop = false
CFG.Noclip = false
CFG.InfJump = false
CFG.Invisible = false
CFG.GravityEnabled = false
CFG.CamFOVEnabled = false
CFG.FakeLag = false
CFG.Spinbot = false
CFG.Fullbright = false
CFG.AntiAFK = false
CFG.ComboEnabled = false
CFG.HUD_FPS = false
CFG.HUD_Ping = false
CFG.HUD_Speed = false

pcall(function()  
    workspace.Gravity = 196.2  
    if LocalPlayer.Character then  
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")  
        if hum then  
            hum.WalkSpeed = 16  
            hum.JumpPower = 50  
        end  
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do  
            if part:IsA("BasePart") then part.CanCollide = true part.Transparency = 0 end  
        end  
    end  
end)  

FOVCircle.Visible = false  
pcall(function() FOVCircle:Remove() end)  
CrosshairFrame.Visible = false  
HitmarkerGui.Visible = false  
  
if GhostClone then GhostClone:Destroy() end  
if GhostConnection then GhostConnection:Disconnect() end  
if LocalBoomboxSound then LocalBoomboxSound:Stop() LocalBoomboxSound:Destroy() end  
  
for p, d in pairs(ESP_List) do  
    for _, obj in pairs(d) do pcall(function() obj:Remove() end) end  
end  
ESP_List = {}  
  
pcall(function()  
    for _, p in ipairs(Players:GetPlayers()) do  
        if p.Character then  
            local h = p.Character:FindFirstChild("NuclearHitboxGlow")  
            local c = p.Character:FindFirstChild("NuclearHighlight")  
            local ch = p.Character:FindFirstChild("NuclearChams")  
            if h then h:Destroy() end  
            if c then c:Destroy() end  
            if ch then ch:Destroy() end  
        end  
    end  
end)  

ScreenGui:Destroy()

end

-- ==================== UI BUTTON & MAIN FRAME ====================
local StarButton = Instance.new("TextButton", ScreenGui)
StarButton.Size = UDim2.new(0, 130, 0, 36)
StarButton.Position = UDim2.new(0.02, 0, 0.2, 0)
StarButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
StarButton.Text = "Nuclear"
StarButton.Font = Enum.Font.GothamBold
StarButton.TextSize = 13
StarButton.TextColor3 = Color3.fromRGB(240, 245, 255)
StarButton.Draggable = true
StarButton.Visible = false
Instance.new("UICorner", StarButton).CornerRadius = UDim.new(0, 8)

local sBtn = Instance.new("UIStroke", StarButton)
sBtn.Color = DarkRedColor
sBtn.Thickness = 1.8
sBtn.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local MainFrame = RegisterElement("MainFrames", Instance.new("Frame", ScreenGui))
MainFrame.Size = UDim2.new(0, CFG.MenuWidth, 0, CFG.MenuHeight)
MainFrame.Position = UDim2.new(0.5, -CFG.MenuWidth/2, 0.5, -CFG.MenuHeight/2)
MainFrame.BackgroundColor3 = CurrentTheme.MainBg
MainFrame.BackgroundTransparency = CFG.MenuTransparency
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
MainFrame.Visible = false
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
local ms = Instance.new("UIStroke", MainFrame) ms.Color = Color3.fromRGB(35, 35, 45) ms.Thickness = 1.5

local function ToggleMenu()
if MainFrame.Visible then
local tween = TweenService:Create(MainFrame, TweenInfo.new(0.65, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
Size = UDim2.new(0, CFG.MenuWidth, 0, 0),
BackgroundTransparency = 1
})
tween:Play()
tween.Completed:Connect(function()
MainFrame.Visible = false
end)
else
MainFrame.Size = UDim2.new(0, CFG.MenuWidth, 0, 0)
MainFrame.BackgroundTransparency = 1
MainFrame.Visible = true
TweenService:Create(MainFrame, TweenInfo.new(0.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
Size = UDim2.new(0, CFG.MenuWidth, 0, CFG.MenuHeight),
BackgroundTransparency = CFG.MenuTransparency
}):Play()
end
end

StarButton.MouseButton1Click:Connect(ToggleMenu)

StarButton.MouseEnter:Connect(function()
TweenService:Create(StarButton, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, 136, 0, 38)}):Play()
end)
StarButton.MouseLeave:Connect(function()
TweenService:Create(StarButton, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, 130, 0, 36)}):Play()
end)

-- ==================== FULLSCREEN ANIMATED LOADING SYSTEM ====================
local BlurEffect = Instance.new("BlurEffect")
BlurEffect.Name = "NuclearBlur"
BlurEffect.Size = 24
BlurEffect.Parent = Lighting

local LoadingGui = Instance.new("Frame", ScreenGui)
LoadingGui.Size = UDim2.new(1, 0, 1, 0)
LoadingGui.Position = UDim2.new(0, 0, 0, 0)
LoadingGui.BackgroundColor3 = Color3.fromRGB(5, 2, 2)
LoadingGui.BackgroundTransparency = 0.05
LoadingGui.ZIndex = 100

-- Ядерный символ на заднем плане (Пульсация)
local NuclearSymbolBg = Instance.new("TextLabel", LoadingGui)
NuclearSymbolBg.Size = UDim2.new(0, 300, 0, 300)
NuclearSymbolBg.Position = UDim2.new(0.5, -150, 0.4, -150)
NuclearSymbolBg.Text = "☢"
NuclearSymbolBg.Font = Enum.Font.GothamBold
NuclearSymbolBg.TextSize = 220
NuclearSymbolBg.TextColor3 = DarkRedColor
NuclearSymbolBg.TextTransparency = 0.85
NuclearSymbolBg.BackgroundTransparency = 1
NuclearSymbolBg.ZIndex = 100

local LoadTitle = Instance.new("TextLabel", LoadingGui)
LoadTitle.Size = UDim2.new(0, 400, 0, 50)
LoadTitle.Position = UDim2.new(0.5, -200, 0.38, -40)
LoadTitle.Text = "NUCLEAR"
LoadTitle.Font = Enum.Font.GothamBold
LoadTitle.TextSize = 42
LoadTitle.TextColor3 = DarkRedColor
LoadTitle.BackgroundTransparency = 1
LoadTitle.ZIndex = 101

local LoadSub = Instance.new("TextLabel", LoadingGui)
LoadSub.Size = UDim2.new(0, 400, 0, 20)
LoadSub.Position = UDim2.new(0.5, -200, 0.38, 20)
LoadSub.Text = "[ SYSTEM INITIALIZATION ]"
LoadSub.Font = Enum.Font.Code
LoadSub.TextSize = 12
LoadSub.TextColor3 = Color3.fromRGB(220, 80, 80)
LoadSub.BackgroundTransparency = 1
LoadSub.ZIndex = 101

local BarBg = Instance.new("Frame", LoadingGui)
BarBg.Size = UDim2.new(0, 340, 0, 6)
BarBg.Position = UDim2.new(0.5, -170, 0.38, 55)
BarBg.BackgroundColor3 = Color3.fromRGB(25, 10, 10)
BarBg.BorderSizePixel = 0
BarBg.ZIndex = 101
Instance.new("UICorner", BarBg).CornerRadius = UDim.new(1, 0)

local BarStroke = Instance.new("UIStroke", BarBg)
BarStroke.Color = Color3.fromRGB(80, 10, 10)
BarStroke.Thickness = 1

local BarFill = Instance.new("Frame", BarBg)
BarFill.Size = UDim2.new(0, 0, 1, 0)
BarFill.BackgroundColor3 = DarkRedColor
BarFill.BorderSizePixel = 0
BarFill.ZIndex = 102
Instance.new("UICorner", BarFill).CornerRadius = UDim.new(1, 0)

-- Дополнительный светящийся эффектик на полоске
local BarGlow = Instance.new("Frame", BarFill)
BarGlow.Size = UDim2.new(0, 20, 1, 0)
BarGlow.Position = UDim2.new(1, -20, 0, 0)
BarGlow.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
BarGlow.BorderSizePixel = 0
BarGlow.ZIndex = 103
Instance.new("UICorner", BarGlow).CornerRadius = UDim.new(1, 0)

-- Прогресс в процентах
local PercentLabel = Instance.new("TextLabel", LoadingGui)
PercentLabel.Size = UDim2.new(0, 200, 0, 20)
PercentLabel.Position = UDim2.new(0.5, -100, 0.38, 68)
PercentLabel.Text = "0%"
PercentLabel.Font = Enum.Font.Code
PercentLabel.TextSize = 11
PercentLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
PercentLabel.BackgroundTransparency = 1
PercentLabel.ZIndex = 101

-- Анимация логотипа и лоадера
task.spawn(function()
    local pulseTween = TweenService:Create(NuclearSymbolBg, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
        TextTransparency = 0.6,
        Rotation = 15
    })
    pulseTween:Play()

    local progressTween = TweenService:Create(BarFill, TweenInfo.new(3.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Size = UDim2.new(1, 0, 1, 0)
    })
    progressTween:Play()

    local startTime = tick()
    local duration = 3.5
    while tick() - startTime < duration do
        local elapsed = tick() - startTime
        local pct = math.clamp(math.floor((elapsed / duration) * 100), 0, 100)
        PercentLabel.Text = pct .. "%"
        
        if pct < 30 then
            LoadSub.Text = "[ LOADING MODULES ]"
        elseif pct < 70 then
            LoadSub.Text = "[ BYPASSING SECURITY ]"
        else
            LoadSub.Text = "[ READY TO LAUNCH ]"
        end
        task.wait(0.03)
    end
    PercentLabel.Text = "100%"

    task.wait(0.3)

    pulseTween:Cancel()

    local blurTween = TweenService:Create(BlurEffect, TweenInfo.new(0.8, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Size = 0
    })
    blurTween:Play()

    local fadeTween = TweenService:Create(LoadingGui, TweenInfo.new(0.8, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        BackgroundTransparency = 1
    })
    TweenService:Create(LoadTitle, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {TextTransparency = 1}):Play()
    TweenService:Create(LoadSub, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {TextTransparency = 1}):Play()
    TweenService:Create(NuclearSymbolBg, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {TextTransparency = 1}):Play()
    TweenService:Create(PercentLabel, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {TextTransparency = 1}):Play()
    TweenService:Create(BarBg, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
    TweenService:Create(BarFill, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
    TweenService:Create(BarGlow, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
    fadeTween:Play()

    fadeTween.Completed:Connect(function()
        LoadingGui:Destroy()
        BlurEffect:Destroy()
        StarButton.Visible = true
    end)
end)

local function PressKeyVirtual(keyCode)
pcall(function()
local virtualInputManager = game:GetService("VirtualInputManager")
if virtualInputManager then
virtualInputManager:SendKeyEvent(true, keyCode, false, game)
task.wait(0.03)
virtualInputManager:SendKeyEvent(false, keyCode, false, game)
end
end)
end

local function ExecuteComboMacro()
if not CFG.ComboEnabled then return end
task.spawn(function()
for kName in string.gmatch(CFG.ComboKeysText, "[^,%s]+") do
local kc = Enum.KeyCode[kName]
if not kc then
if kName:lower() == "space" then kc = Enum.KeyCode.Space
elseif kName:lower() == "one" or kName == "1" then kc = Enum.KeyCode.One
elseif kName:lower() == "two" or kName == "2" then kc = Enum.KeyCode.Two
elseif kName:lower() == "three" or kName == "3" then kc = Enum.KeyCode.Three
end
end
if kc then
PressKeyVirtual(kc)
task.wait(CFG.ComboDelay)
end
end
end)
end

UserInputService.InputBegan:Connect(function(input, gpe)
if not gpe then
if input.KeyCode == Enum.KeyCode.Insert then
ToggleMenu()
elseif input.KeyCode == Keybinds.Panic then
PanicClean()
elseif input.KeyCode == Keybinds.Combo then
ExecuteComboMacro()
elseif input.KeyCode == Keybinds.Aimbot then
CFG.AimEnabled = not CFG.AimEnabled
FOVCircle.Visible = CFG.AimEnabled and not CFG.FovCircleHidden
elseif input.KeyCode == Keybinds.Noclip then
CFG.Noclip = not CFG.Noclip
elseif input.KeyCode == Keybinds.Speed then
CFG.Speed = not CFG.Speed
elseif input.KeyCode == Keybinds.Invisible then
local v = not CFG.Invisible
CFG.Invisible = v
local char = LocalPlayer.Character
if char then
if v then
local root = char:FindFirstChild("HumanoidRootPart")
if root then
char.Archivable = true
GhostClone = char:Clone()
GhostClone.Name = "NuclearGhostSkin"
GhostClone.Parent = workspace
for _, d in ipairs(GhostClone:GetDescendants()) do
if d:IsA("Script") or d:IsA("LocalScript") then d:Destroy() end
end
for _, part in ipairs(char:GetDescendants()) do
if part:IsA("BasePart") or part:IsA("Decal") then part.Transparency = 1 end
end
GhostConnection = RunService.RenderStepped:Connect(function()
if not CFG.Invisible or not char or not GhostClone then
if GhostConnection then GhostConnection:Disconnect() end
return
end
local cRoot = char:FindFirstChild("HumanoidRootPart")
local gRoot = GhostClone:FindFirstChild("HumanoidRootPart")
if cRoot and gRoot then GhostClone:SetPrimaryPartCFrame(cRoot.CFrame) end
end)
end
else
if GhostConnection then GhostConnection:Disconnect() end
if GhostClone then GhostClone:Destroy() GhostClone = nil end
for _, part in ipairs(char:GetDescendants()) do
if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then part.Transparency = 0 end
end
end
end
elseif input.KeyCode == CFG.MacroKey then
CFG.MacroKeyPressed = true
end
end
end)

UserInputService.InputEnded:Connect(function(input)
if input.KeyCode == CFG.MacroKey then
CFG.MacroKeyPressed = false
end
end)

-- TopBar с названием по центру
local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 36)
TopBar.BackgroundTransparency = 1

local AppTitle = RegisterElement("SubTexts", Instance.new("TextLabel", TopBar))
AppTitle.Size = UDim2.new(1, 0, 1, 0)
AppTitle.Position = UDim2.new(0, 0, 0, 0)
AppTitle.Text = "Nuclear - t.me/Rozeris"
AppTitle.Font = Enum.Font.GothamBold
AppTitle.TextSize = 13
AppTitle.TextColor3 = CurrentTheme.SubText
AppTitle.TextXAlignment = Enum.TextXAlignment.Center
AppTitle.BackgroundTransparency = 1

-- Sidebar
local Sidebar = RegisterElement("Sidebars", Instance.new("ScrollingFrame", MainFrame))
Sidebar.Size = UDim2.new(0, 175, 1, -36)
Sidebar.Position = UDim2.new(0, 0, 0, 36)
Sidebar.BackgroundColor3 = CurrentTheme.SidebarBg
Sidebar.BorderSizePixel = 0
Sidebar.ScrollBarThickness = 0
Sidebar.CanvasSize = UDim2.new(0, 0, 0, 800)

local SidebarLayout = Instance.new("UIListLayout", Sidebar)
SidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
SidebarLayout.Padding = UDim.new(0, 4)

local Divider1 = Instance.new("Frame", MainFrame)
Divider1.Size = UDim2.new(0, 1, 1, -36)
Divider1.Position = UDim2.new(0, 175, 0, 36)
Divider1.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
Divider1.BorderSizePixel = 0

-- Content Area
local ContentArea = Instance.new("Frame", MainFrame)
ContentArea.Size = UDim2.new(1, -176, 1, -36)
ContentArea.Position = UDim2.new(0, 176, 0, 36)
ContentArea.BackgroundTransparency = 1
ContentArea.ClipsDescendants = true

local Tabs = {}
local activeTabBtn = nil

-- Создание вкладок БЕЗ иконок/смайликов
local function CreateTab(name)
local Page = Instance.new("ScrollingFrame", ContentArea)
Page.Size = UDim2.new(1, 0, 1, 0)
Page.BackgroundTransparency = 1
Page.Visible = false
Page.ScrollBarThickness = 3
Page.CanvasSize = UDim2.new(0, 0, 0, 440)
Page.ClipsDescendants = true

local PageLayout = Instance.new("UIListLayout", Page)    
PageLayout.FillDirection = Enum.FillDirection.Horizontal    
PageLayout.Padding = UDim.new(0, 12)    
PageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left    

PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()  
    Page.CanvasSize = UDim2.new(0, PageLayout.AbsoluteContentSize.X + 20, 0, 0)  
end)  

local Btn = Instance.new("TextButton", Sidebar)    
Btn.Size = UDim2.new(1, -16, 0, 34)    
Btn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)    
Btn.BackgroundTransparency = 1    
Btn.Text = "   " .. name    
Btn.TextColor3 = CurrentTheme.SubText    
Btn.Font = Enum.Font.GothamMedium    
Btn.TextSize = 11    
Btn.TextXAlignment = Enum.TextXAlignment.Left    
Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)    
  
local btnStroke = Instance.new("UIStroke", Btn)  
btnStroke.Color = Color3.fromRGB(35, 35, 45)  
btnStroke.Transparency = 1  

local ActiveIndicator = Instance.new("Frame", Btn)  
ActiveIndicator.Size = UDim2.new(0, 3, 0, 0)  
ActiveIndicator.Position = UDim2.new(0, 2, 0.5, 0)  
ActiveIndicator.AnchorPoint = Vector2.new(0, 0.5)  
ActiveIndicator.BackgroundColor3 = DarkRedColor  
ActiveIndicator.BorderSizePixel = 0  
Instance.new("UICorner", ActiveIndicator).CornerRadius = UDim.new(1, 0)  
RegisterElement("Fills", ActiveIndicator)  

RegisterElement("SubTexts", Btn)    

Btn.MouseEnter:Connect(function()  
    if activeTabBtn ~= Btn then  
        TweenService:Create(Btn, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundTransparency = 0.6, BackgroundColor3 = Color3.fromRGB(30, 30, 38)}):Play()  
        TweenService:Create(btnStroke, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Transparency = 0.5}):Play()  
    end  
end)  
Btn.MouseLeave:Connect(function()  
    if activeTabBtn ~= Btn then  
        TweenService:Create(Btn, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()  
        TweenService:Create(btnStroke, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Transparency = 1}):Play()  
    end  
end)  

Btn.MouseButton1Click:Connect(function()  
    if activeTabBtn == Btn then return end  

    for _, t in pairs(Tabs) do    
        t.Page.Visible = false  
        t.Btn.TextColor3 = CurrentTheme.SubText    
        TweenService:Create(t.Btn, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()  
        if t.Stroke then TweenService:Create(t.Stroke, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Transparency = 1}):Play() end  
        if t.Indicator then TweenService:Create(t.Indicator, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, 3, 0, 0)}):Play() end  
    end    

    Page.Visible = true    
    activeTabBtn = Btn    
    Btn.TextColor3 = CurrentTheme.Text    
    TweenService:Create(Btn, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundTransparency = 0.3, BackgroundColor3 = Color3.fromRGB(28, 28, 36)}):Play()  
    TweenService:Create(btnStroke, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Transparency = 0}):Play()  
    TweenService:Create(ActiveIndicator, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 3, 0, 18)}):Play()  
end)    

Tabs[name] = {Page = Page, Btn = Btn, Stroke = btnStroke, Indicator = ActiveIndicator}    
return Page

end

local function CreateSection(parent, title, customWidth)
local Sec = RegisterElement("Sections", Instance.new("Frame", parent))
Sec.Size = UDim2.new(0, customWidth or 265, 0, 430)
Sec.BackgroundColor3 = CurrentTheme.SectionBg
Sec.ClipsDescendants = true
Instance.new("UICorner", Sec).CornerRadius = UDim.new(0, 10)
local s = Instance.new("UIStroke", Sec) s.Color = Color3.fromRGB(30, 30, 40) s.Thickness = 1

local SecHeader = Instance.new("TextButton", Sec)  
SecHeader.Size = UDim2.new(1, 0, 0, 36)  
SecHeader.BackgroundTransparency = 1  
SecHeader.Text = ""  

local SecTitle = RegisterElement("Texts", Instance.new("TextLabel", SecHeader))    
SecTitle.Size = UDim2.new(1, -40, 1, 0)    
SecTitle.Position = UDim2.new(0, 12, 0, 0)    
SecTitle.Text = title    
SecTitle.TextColor3 = CurrentTheme.Text    
SecTitle.Font = Enum.Font.GothamBold    
SecTitle.TextSize = 11    
SecTitle.TextXAlignment = Enum.TextXAlignment.Left    
SecTitle.BackgroundTransparency = 1    

local ToggleArrow = Instance.new("TextLabel", SecHeader)  
ToggleArrow.Size = UDim2.new(0, 20, 1, 0)  
ToggleArrow.Position = UDim2.new(1, -26, 0, 0)  
ToggleArrow.Text = "▼"  
ToggleArrow.Font = Enum.Font.GothamBold  
ToggleArrow.TextSize = 10  
ToggleArrow.TextColor3 = CurrentTheme.SubText  
ToggleArrow.BackgroundTransparency = 1  

local Container = Instance.new("ScrollingFrame", Sec)    
Container.Size = UDim2.new(1, -12, 1, -40)    
Container.Position = UDim2.new(0, 6, 0, 36)    
Container.BackgroundTransparency = 1    
Container.ScrollBarThickness = 2    
Container.CanvasSize = UDim2.new(0, 0, 0, 0)    

local Layout = Instance.new("UIListLayout", Container)    
Layout.Padding = UDim.new(0, 8)    
Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()    
    Container.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 15)    
end)    

local isExpanded = true  
SecHeader.MouseButton1Click:Connect(function()  
    isExpanded = not isExpanded  
    if isExpanded then  
        ToggleArrow.Text = "▼"  
        TweenService:Create(Sec, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {  
            Size = UDim2.new(0, customWidth or 265, 0, 430)  
        }):Play()  
    else  
        ToggleArrow.Text = "▲"  
        TweenService:Create(Sec, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {  
            Size = UDim2.new(0, customWidth or 265, 0, 36)  
        }):Play()  
    end  
end)  

return Container

end

local function AddToggle(parent, text, default, callback)
local Frame = Instance.new("Frame", parent)
Frame.Size = UDim2.new(1, 0, 0, 26)
Frame.BackgroundTransparency = 1

local Label = RegisterElement("SubTexts", Instance.new("TextLabel", Frame))    
Label.Size = UDim2.new(1, -38, 1, 0)    
Label.Position = UDim2.new(0, 6, 0, 0)    
Label.Text = text    
Label.Font = Enum.Font.GothamMedium    
Label.TextSize = 10    
Label.TextXAlignment = Enum.TextXAlignment.Left    
Label.TextColor3 = CurrentTheme.SubText    
Label.BackgroundTransparency = 1    

local SwitchTrack = RegisterElement("Switches", Instance.new("TextButton", Frame))    
SwitchTrack.Size = UDim2.new(0, 30, 0, 16)    
SwitchTrack.Position = UDim2.new(1, -32, 0.5, -8)    
SwitchTrack.Text = ""    
SwitchTrack.AutoButtonColor = false    
Instance.new("UICorner", SwitchTrack).CornerRadius = UDim.new(1, 0)    

local SwitchKnob = Instance.new("Frame", SwitchTrack)    
SwitchKnob.Size = UDim2.new(0, 12, 0, 12)    
SwitchKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)    
SwitchKnob.BorderSizePixel = 0    
Instance.new("UICorner", SwitchKnob).CornerRadius = UDim.new(1, 0)    

local st = default    
Frame:SetAttribute("Active", st)  

local function updateVisuals(animate)  
    Frame:SetAttribute("Active", st)  
    local duration = animate and 0.4 or 0  
    if st then    
        TweenService:Create(SwitchTrack, TweenInfo.new(duration, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundColor3 = DarkRedColor}):Play()  
        TweenService:Create(SwitchKnob, TweenInfo.new(duration, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, 15, 0.5, -6)}):Play()  
    else    
        TweenService:Create(SwitchTrack, TweenInfo.new(duration, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(30, 30, 35)}):Play()  
        TweenService:Create(SwitchKnob, TweenInfo.new(duration, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, 3, 0.5, -6)}):Play()  
    end    
end    
updateVisuals(false)    

SwitchTrack.MouseButton1Click:Connect(function()    
    st = not st    
    updateVisuals(true)    
    callback(st)    
end)

end

local function AddColorSelector(parent, text, defaultColorName, callback)
local Frame = Instance.new("Frame", parent)
Frame.Size = UDim2.new(1, -4, 0, 28)
Frame.BackgroundTransparency = 1

local Label = RegisterElement("SubTexts", Instance.new("TextLabel", Frame))  
Label.Size = UDim2.new(0.4, 0, 1, 0)  
Label.Position = UDim2.new(0, 6, 0, 0)  
Label.Text = text  
Label.Font = Enum.Font.GothamMedium  
Label.TextSize = 10  
Label.TextColor3 = CurrentTheme.SubText  
Label.TextXAlignment = Enum.TextXAlignment.Left  
Label.BackgroundTransparency = 1  

local BtnContainer = Instance.new("Frame", Frame)  
BtnContainer.Size = UDim2.new(0.6, -6, 1, 0)  
BtnContainer.Position = UDim2.new(0.4, 0, 0, 0)  
BtnContainer.BackgroundTransparency = 1  

local layout = Instance.new("UIListLayout", BtnContainer)  
layout.FillDirection = Enum.FillDirection.Horizontal  
layout.HorizontalAlignment = Enum.HorizontalAlignment.Right  
layout.VerticalAlignment = Enum.VerticalAlignment.Center  
layout.Padding = UDim.new(0, 4)  

for _, cName in ipairs(ColorNames) do  
    local cColor = ColorPresets[cName]  
    local cBtn = Instance.new("TextButton", BtnContainer)  
    cBtn.Size = UDim2.new(0, 16, 0, 16)  
    cBtn.BackgroundColor3 = cColor  
    cBtn.Text = ""  
    cBtn.AutoButtonColor = false  
    Instance.new("UICorner", cBtn).CornerRadius = UDim.new(1, 0)  
      
    local cStroke = Instance.new("UIStroke", cBtn)  
    cStroke.Color = Color3.fromRGB(255, 255, 255)  
    cStroke.Thickness = 1.5  
    cStroke.Transparency = (cName == defaultColorName) and 0 or 0.85  

    cBtn.MouseButton1Click:Connect(function()  
        for _, child in ipairs(BtnContainer:GetChildren()) do  
            if child:IsA("TextButton") then  
                local st = child:FindFirstChildOfClass("UIStroke")  
                if st then st.Transparency = 0.85 end  
            end  
        end  
        cStroke.Transparency = 0  
        callback(cColor)  
    end)  
end

end

local function AddSlider(parent, text, min, max, default, callback)
local Frame = Instance.new("Frame", parent)
Frame.Size = UDim2.new(1, -4, 0, 36)
Frame.BackgroundTransparency = 1

local Label = RegisterElement("SubTexts", Instance.new("TextLabel", Frame))    
Label.Size = UDim2.new(0.7, 0, 0, 16)    
Label.Position = UDim2.new(0, 6, 0, 0)    
Label.Text = text    
Label.TextColor3 = CurrentTheme.SubText    
Label.Font = Enum.Font.GothamMedium    
Label.TextSize = 10    
Label.TextXAlignment = Enum.TextXAlignment.Left    
Label.BackgroundTransparency = 1    

local ValLabel = RegisterElement("Texts", Instance.new("TextLabel", Frame))    
ValLabel.Size = UDim2.new(0.3, 0, 0, 16)    
ValLabel.Position = UDim2.new(0.7, -6, 0, 0)    
ValLabel.Font = Enum.Font.GothamBold    
ValLabel.TextSize = 10    
ValLabel.TextXAlignment = Enum.TextXAlignment.Right    
ValLabel.TextColor3 = CurrentTheme.Text    
ValLabel.BackgroundTransparency = 1    

local Bar = Instance.new("Frame", Frame)    
Bar.Size = UDim2.new(1, -12, 0, 6)    
Bar.Position = UDim2.new(0, 6, 0, 22)    
Bar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)    
Bar.BorderSizePixel = 0    
Instance.new("UICorner", Bar).CornerRadius = UDim.new(1, 0)    

local Fill = RegisterElement("Fills", Instance.new("Frame", Bar))    
Fill.Size = UDim2.new(0, 0, 1, 0)    
Fill.BackgroundColor3 = DarkRedColor  
Fill.BorderSizePixel = 0    
Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)    

local Thumb = Instance.new("Frame", Fill)
Thumb.Size = UDim2.new(0, 10, 0, 10)
Thumb.Position = UDim2.new(1, -5, 0.5, -5)
Thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Thumb.BorderSizePixel = 0
Instance.new("UICorner", Thumb).CornerRadius = UDim.new(1, 0)

local ThumbStroke = Instance.new("UIStroke", Thumb)
ThumbStroke.Color = DarkRedColor
ThumbStroke.Thickness = 1.5

local Btn = Instance.new("TextButton", Bar)    
Btn.Size = UDim2.new(1, 0, 1, 0)    
Btn.BackgroundTransparency = 1    
Btn.Text = ""    

local function SetValue(val, animate)    
    val = math.clamp(val, min, max)    
    local pos = (val - min) / (max - min)    
    if animate then  
        TweenService:Create(Fill, TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(pos, 0, 1, 0)}):Play()  
    else  
        Fill.Size = UDim2.new(pos, 0, 1, 0)    
    end  
    local roundedVal = math.floor(val * 100 + 0.5) / 100  
    ValLabel.Text = tostring(roundedVal)    
    callback(val)    
end    
SetValue(default, false)    

local function UpdateFromInput(input, animate)  
    local barAbsPos = Bar.AbsolutePosition.X  
    local barAbsSize = math.max(1, Bar.AbsoluteSize.X)  
    local mousePos = input.Position.X  
    local pos = math.clamp((mousePos - barAbsPos) / barAbsSize, 0, 1)  
      
    if pos >= 0.98 then pos = 1 end  
    if pos <= 0.02 then pos = 0 end  
      
    local calculatedVal = min + (max - min) * pos  
    SetValue(calculatedVal, animate)  
end  

local dragging = false    
Btn.InputBegan:Connect(function(input)    
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then    
        dragging = true    
        UpdateFromInput(input, true)  
    end    
end)    
UserInputService.InputEnded:Connect(function(input)    
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then    
        dragging = false    
    end    
end)    
UserInputService.InputChanged:Connect(function(input)    
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then    
        UpdateFromInput(input, false)  
    end    
end)

end

local function AddTextBox(parent, placeholder, callback)
local Frame = Instance.new("Frame", parent)
Frame.Size = UDim2.new(1, -4, 0, 30)
Frame.BackgroundTransparency = 1

local Box = RegisterElement("Texts", Instance.new("TextBox", Frame))    
Box.Size = UDim2.new(1, 0, 1, 0)    
Box.BackgroundColor3 = Color3.fromRGB(18, 18, 22)    
Box.PlaceholderText = placeholder    
Box.Text = ""    
Box.Font = Enum.Font.GothamMedium    
Box.TextSize = 10    
Box.TextColor3 = CurrentTheme.Text    
Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 6)    
local bStroke = Instance.new("UIStroke", Box) bStroke.Color = Color3.fromRGB(30, 30, 35) bStroke.Thickness = 1  

Box.Focused:Connect(function()  
    TweenService:Create(bStroke, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Color = DarkRedColor}):Play()  
end)  
Box.FocusLost:Connect(function(enter)    
    TweenService:Create(bStroke, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Color = Color3.fromRGB(30, 30, 35)}):Play()  
    if enter then callback(Box.Text) end    
end)

end

local function AddKeybindPicker(parent, labelName, keyName)
local Frame = Instance.new("Frame", parent)
Frame.Size = UDim2.new(1, -4, 0, 32)
Frame.BackgroundTransparency = 1

local Label = RegisterElement("SubTexts", Instance.new("TextLabel", Frame))  
Label.Size = UDim2.new(0.6, 0, 1, 0)  
Label.Position = UDim2.new(0, 6, 0, 0)  
Label.Text = labelName  
Label.Font = Enum.Font.GothamMedium  
Label.TextSize = 10  
Label.TextColor3 = CurrentTheme.SubText  
Label.TextXAlignment = Enum.TextXAlignment.Left  
Label.BackgroundTransparency = 1  

local KeyBtn = Instance.new("TextButton", Frame)  
KeyBtn.Size = UDim2.new(0, 90, 0, 24)  
KeyBtn.Position = UDim2.new(1, -94, 0.5, -12)  
KeyBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 28)  
KeyBtn.Text = tostring(Keybinds[keyName] and Keybinds[keyName].Name or "None")  
KeyBtn.Font = Enum.Font.GothamBold  
KeyBtn.TextSize = 10  
KeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)  
Instance.new("UICorner", KeyBtn).CornerRadius = UDim.new(0, 6)  
local kbStroke = Instance.new("UIStroke", KeyBtn) kbStroke.Color = Color3.fromRGB(30, 30, 35) kbStroke.Thickness = 1  
RegisterElement("Texts", KeyBtn)  

local listening = false  
KeyBtn.MouseButton1Click:Connect(function()  
    if listening then return end  
    listening = true  
    KeyBtn.Text = "..."  
    KeyBtn.TextColor3 = Color3.fromRGB(255, 180, 50)  

    local connection  
    connection = UserInputService.InputBegan:Connect(function(input)  
        if input.UserInputType == Enum.UserInputType.Keyboard then  
            Keybinds[keyName] = input.KeyCode  
            KeyBtn.Text = tostring(input.KeyCode.Name)  
            KeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)  
            listening = false  
            connection:Disconnect()  
        end  
    end)  
end)

end

-- ==================== TAB INITIALIZATIONS ====================
local ProfileTab = CreateTab("Profile")
local HUDTab = CreateTab("HUD / Overlay")
local CombatTab = CreateTab("Combat")
local VisTab = CreateTab("Visuals")
local MoveTab = CreateTab("Movement")
local ShaderTab = CreateTab("Shaders")
local FFlagsTab = CreateTab("FFlags")
local MiscTab = CreateTab("Misc")
local KeybindsTab = CreateTab("Keybinds")
local MenuTab = CreateTab("menu")
local PlayersTab = CreateTab("Players")
local ExecutorTab = CreateTab("Executor")
local ServerTab = CreateTab("Server")
local MacroTab = CreateTab("Macro")
local MusicTab = CreateTab("Music")

Tabs["Profile"].Page.Visible = true
activeTabBtn = Tabs["Profile"].Btn
Tabs["Profile"].Btn.TextColor3 = CurrentTheme.Text
Tabs["Profile"].Btn.BackgroundTransparency = 0.3
Tabs["Profile"].Btn.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
if Tabs["Profile"].Stroke then Tabs["Profile"].Stroke.Transparency = 0 end
if Tabs["Profile"].Indicator then Tabs["Profile"].Indicator.Size = UDim2.new(0, 3, 0, 18) end

-- Profile Tab (С расширенной информацией)
local ProfSecMain = CreateSection(ProfileTab, "User Profile & Character Details", 535)

local ProfileCard = Instance.new("Frame", ProfSecMain)
ProfileCard.Size = UDim2.new(1, 0, 0, 240)
ProfileCard.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
Instance.new("UICorner", ProfileCard).CornerRadius = UDim.new(0, 10)
local pcStroke = Instance.new("UIStroke", ProfileCard) pcStroke.Color = Color3.fromRGB(28, 28, 35) pcStroke.Thickness = 1

local LargeAvatar = Instance.new("ImageLabel", ProfileCard)
LargeAvatar.Size = UDim2.new(0, 120, 0, 120)
LargeAvatar.Position = UDim2.new(0, 20, 0.5, -60)
LargeAvatar.BackgroundTransparency = 1
LargeAvatar.Image = "rbxassetid://0"
Instance.new("UICorner", LargeAvatar).CornerRadius = UDim.new(0, 12)

task.spawn(function()
pcall(function()
local content = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
LargeAvatar.Image = content
end)
end)

local ProfDetailsContainer = Instance.new("Frame", ProfileCard)
ProfDetailsContainer.Size = UDim2.new(1, -160, 1, -20)
ProfDetailsContainer.Position = UDim2.new(0, 150, 0, 10)
ProfDetailsContainer.BackgroundTransparency = 1

local ProfLayout = Instance.new("UIListLayout", ProfDetailsContainer)
ProfLayout.Padding = UDim.new(0, 4)

local function AddProfileLine(title, val)
local line = Instance.new("Frame", ProfDetailsContainer)
line.Size = UDim2.new(1, 0, 0, 20)
line.BackgroundTransparency = 1

local tLbl = RegisterElement("SubTexts", Instance.new("TextLabel", line))  
tLbl.Size = UDim2.new(0.45, 0, 1, 0)  
tLbl.Text = title .. ":"  
tLbl.Font = Enum.Font.GothamMedium  
tLbl.TextSize = 10  
tLbl.TextColor3 = CurrentTheme.SubText  
tLbl.TextXAlignment = Enum.TextXAlignment.Left  
tLbl.BackgroundTransparency = 1  

local vLbl = RegisterElement("Texts", Instance.new("TextLabel", line))  
vLbl.Size = UDim2.new(0.55, 0, 1, 0)  
vLbl.Position = UDim2.new(0.45, 0, 0, 0)  
vLbl.Text = tostring(val)  
vLbl.Font = Enum.Font.GothamBold  
vLbl.TextSize = 10  
vLbl.TextColor3 = CurrentTheme.Text  
vLbl.TextXAlignment = Enum.TextXAlignment.Left  
vLbl.BackgroundTransparency = 1

return vLbl
end

AddProfileLine("Username", LocalPlayer.Name)
AddProfileLine("Display Name", LocalPlayer.DisplayName)
AddProfileLine("User ID", LocalPlayer.UserId)
AddProfileLine("Account Age", LocalPlayer.AccountAge .. " days")
AddProfileLine("Membership", LocalPlayer.MembershipType == Enum.MembershipType.Premium and "Premium" or "Standard")
AddProfileLine("Current Place ID", game.PlaceId)

local rigTypeStr = "R6"
if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
    rigTypeStr = (LocalPlayer.Character:FindFirstChildOfClass("Humanoid").RigType == Enum.HumanoidRigType.R15) and "R15" or "R6"
end
AddProfileLine("Rig Type", rigTypeStr)

local accCount = 0
if LocalPlayer.Character then
    for _, v in ipairs(LocalPlayer.Character:GetChildren()) do
        if v:IsA("Accessory") then accCount = accCount + 1 end
    end
end
AddProfileLine("Accessories Count", accCount .. " items")

local skinCostLbl = AddProfileLine("Skin Est. Cost", "Calculating...")

task.spawn(function()
    local totalCost = 0
    local success, info = pcall(function()
        return Players:GetCharacterAppearanceInfoAsync(LocalPlayer.UserId)
    end)
    if success and info and info.assets then
        for _, asset in ipairs(info.assets) do
            if asset.id then
                pcall(function()
                    local pInfo = MarketplaceService:GetProductInfo(asset.id, Enum.InfoType.Asset)
                    if pInfo and pInfo.PriceInRobux then
                        totalCost = totalCost + pInfo.PriceInRobux
                    end
                end)
            end
        end
        skinCostLbl.Text = totalCost .. " R$"
    else
        skinCostLbl.Text = "N/A"
    end
end)

-- HUD Tab
local HUDOverlay = Instance.new("Frame", ScreenGui)
HUDOverlay.Size = UDim2.new(0, 220, 0, 30)
HUDOverlay.Position = UDim2.new(0.5, -110, 0, 10)
HUDOverlay.BackgroundColor3 = CFG.HUD_BgColor
HUDOverlay.BackgroundTransparency = CFG.HUD_Transparency
HUDOverlay.Visible = false
HUDOverlay.Active = true
HUDOverlay.ClipsDescendants = true
Instance.new("UICorner", HUDOverlay).CornerRadius = UDim.new(0, 8)
local hudStroke = Instance.new("UIStroke", HUDOverlay) hudStroke.Color = Color3.fromRGB(35, 35, 45) hudStroke.Thickness = 1.5

local draggingHUD, dragInputHUD, dragStartHUD, startPosHUD = false, nil, nil, nil

HUDOverlay.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
draggingHUD = true
dragStartHUD = input.Position
startPosHUD = HUDOverlay.Position
end
end)

HUDOverlay.InputEnded:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
draggingHUD = false
end
end)

UserInputService.InputChanged:Connect(function(input)
if draggingHUD and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
local delta = input.Position - dragStartHUD
HUDOverlay.Position = UDim2.new(
startPosHUD.X.Scale,
startPosHUD.X.Offset + delta.X,
startPosHUD.Y.Scale,
startPosHUD.Y.Offset + delta.Y
)
end
end)

local HUDUIScale = Instance.new("UIScale", HUDOverlay)
HUDUIScale.Scale = CFG.HUD_Scale

local HUDText = Instance.new("TextLabel", HUDOverlay)
HUDText.Size = UDim2.new(1, -10, 1, 0)
HUDText.Position = UDim2.new(0, 5, 0, 0)
HUDText.BackgroundTransparency = 1
HUDText.Font = Enum.Font.GothamBold
HUDText.TextSize = 11
HUDText.TextColor3 = Color3.fromRGB(255, 255, 255)
HUDText.Text = ""

local function UpdateHUD()
local parts = {}
if CFG.HUD_FPS then
table.insert(parts, "FPS: " .. tostring(math.floor(workspace:GetRealPhysicsFPS())))
end
if CFG.HUD_Ping then
local ping = 0
pcall(function() ping = math.floor(StatsService.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
table.insert(parts, "Ping: " .. ping .. "ms")
end
if CFG.HUD_Speed then
local spd = 0
pcall(function()
local char = LocalPlayer.Character
if char and char:FindFirstChild("HumanoidRootPart") then
spd = math.floor(char.HumanoidRootPart.Velocity.Magnitude)
end
end)
table.insert(parts, "Speed: " .. spd)
end

if #parts > 0 then  
    HUDOverlay.Visible = true  
    HUDText.Text = table.concat(parts, "  |  ")  
    local newWidth = math.max(120, #HUDText.Text * 8 + 20)  
    HUDOverlay.Size = UDim2.new(0, newWidth, 0, 30)  
else  
    HUDOverlay.Visible = false  
end

end

RunService.RenderStepped:Connect(UpdateHUD)

local HUDSec1 = CreateSection(HUDTab, "Top Bar Counters")
local HUDSec2 = CreateSection(HUDTab, "HUD Overlay Style & Scale")

AddToggle(HUDSec1, "FPS Counter", CFG.HUD_FPS, function(v) CFG.HUD_FPS = v end)
AddToggle(HUDSec1, "Ping Counter", CFG.HUD_Ping, function(v) CFG.HUD_Ping = v end)
AddToggle(HUDSec1, "Speed Counter", CFG.HUD_Speed, function(v) CFG.HUD_Speed = v end)

AddSlider(HUDSec2, "Overlay Scale", 0.5, 2.0, CFG.HUD_Scale, function(v)
CFG.HUD_Scale = v
HUDUIScale.Scale = v
end)
AddSlider(HUDSec2, "Overlay Transparency", 0, 100, CFG.HUD_Transparency * 100, function(v)
CFG.HUD_Transparency = v / 100
HUDOverlay.BackgroundTransparency = CFG.HUD_Transparency
end)

-- Combat Tab
local CombSec1 = CreateSection(CombatTab, "Aimbot Settings & Target Part")
local CombSec2 = CreateSection(CombatTab, "Hitbox & Hit Sounds")

AddToggle(CombSec1, "Enable Aimbot", CFG.AimEnabled, function(v) CFG.AimEnabled = v FOVCircle.Visible = v and not CFG.FovCircleHidden end)

local PartLabel = RegisterElement("SubTexts", Instance.new("TextLabel", CombSec1))
PartLabel.Size = UDim2.new(1, -4, 0, 18)
PartLabel.Text = "Aim Target Part:"
PartLabel.Font = Enum.Font.GothamMedium
PartLabel.TextSize = 10
PartLabel.TextColor3 = CurrentTheme.SubText
PartLabel.TextXAlignment = Enum.TextXAlignment.Left
PartLabel.BackgroundTransparency = 1

local PartContainer = Instance.new("Frame", CombSec1)
PartContainer.Size = UDim2.new(1, -4, 0, 28)
PartContainer.BackgroundTransparency = 1

local partBtns = {}
local partsList = {{"Head", "Head"}, {"Body", "HumanoidRootPart"}, {"Torso", "Torso"}}

for i, pInfo in ipairs(partsList) do
local pBtn = Instance.new("TextButton", PartContainer)
pBtn.Size = UDim2.new(0.31, 0, 1, 0)
pBtn.Position = UDim2.new((i-1)*0.34, 0, 0, 0)
pBtn.BackgroundColor3 = CFG.AimPart == pInfo[2] and DarkRedColor or Color3.fromRGB(22, 22, 28)
pBtn.Text = pInfo[1]
pBtn.Font = Enum.Font.GothamBold
pBtn.TextSize = 10
pBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", pBtn).CornerRadius = UDim.new(0, 6)
partBtns[pInfo[2]] = pBtn

pBtn.MouseButton1Click:Connect(function()  
    CFG.AimPart = pInfo[2]  
    for pKey, btn in pairs(partBtns) do  
        btn.BackgroundColor3 = (pKey == pInfo[2]) and DarkRedColor or Color3.fromRGB(22, 22, 28)  
    end  
end)

end

AddSlider(CombSec1, "Smoothness (0 = Snap)", 0, 20, CFG.Smoothness, function(v) CFG.Smoothness = v end)
AddSlider(CombSec1, "FOV Radius", 40, 400, CFG.AimFOV, function(v) CFG.AimFOV = v FOVCircle.Radius = v end)
AddToggle(CombSec1, "Advanced Prediction", CFG.Prediction, function(v) CFG.Prediction = v end)
AddToggle(CombSec1, "Visibility Check (Walls)", CFG.VisibilityCheck, function(v) CFG.VisibilityCheck = v end)
AddToggle(CombSec1, "Hide FOV Circle", CFG.FovCircleHidden, function(v) CFG.FovCircleHidden = v FOVCircle.Visible = CFG.AimEnabled and not v end)
AddToggle(CombSec1, "Team Check", CFG.TeamCheck, function(v) CFG.TeamCheck = v end)

AddToggle(CombSec2, "Hitmarker Effect", CFG.HitmarkerEnabled, function(v) CFG.HitmarkerEnabled = v HitmarkerGui.Visible = false end)
AddTextBox(CombSec2, "Hit Sound ID (e.g. 8367426384)", function(val) CFG.HitSoundID = val end)
AddTextBox(CombSec2, "Kill Sound ID (e.g. 6822839075)", function(val) CFG.KillSoundID = val end)

AddToggle(CombSec2, "Hitbox Expander", CFG.HitboxEnabled, function(v) CFG.HitboxEnabled = v end)
AddSlider(CombSec2, "Hitbox Size", 2, 50, CFG.HitboxSize, function(v) CFG.HitboxSize = v end)
AddToggle(CombSec2, "Hitbox Glow / Outline", CFG.HitboxGlow, function(v) CFG.HitboxGlow = v end)
AddSlider(CombSec2, "Glow Transparency", 0, 100, CFG.HitboxTrans, function(v) CFG.HitboxTrans = v end)

-- Visuals Tab
local VisSec1 = CreateSection(VisTab, "ESP & Highlight Elements")
local VisSec2 = CreateSection(VisTab, "Chams & FOV")

AddToggle(VisSec1, "Highlight (Through Walls)", CFG.ESP_Highlight, function(v) CFG.ESP_Highlight = v end)
AddColorSelector(VisSec1, "Highlight Color", "Green", function(col) CFG.HighlightColor = col end)
AddSlider(VisSec1, "Highlight Fill Transparency", 0, 100, CFG.HighlightTrans * 100, function(v) CFG.HighlightTrans = v / 100 end)

AddToggle(VisSec1, "Box ESP", CFG.ESP_Box, function(v) CFG.ESP_Box = v end)
AddColorSelector(VisSec1, "Box ESP Color", "White", function(col) CFG.BoxColor = col end)

AddToggle(VisSec1, "Name ESP", CFG.ESP_Name, function(v) CFG.ESP_Name = v end)
AddToggle(VisSec1, "Health Bar", CFG.ESP_Health, function(v) CFG.ESP_Health = v end)

AddToggle(VisSec1, "Distance ESP", CFG.ESP_Dist, function(v) CFG.ESP_Dist = v end)
AddColorSelector(VisSec1, "Distance Color", "White", function(col) CFG.DistanceColor = col end)

AddToggle(VisSec1, "Tracers", CFG.Tracers, function(v) CFG.Tracers = v end)
AddColorSelector(VisSec1, "Tracers Color", "White", function(col) CFG.TracerColor = col end)

AddToggle(VisSec1, "Custom Crosshair", CFG.Crosshair, function(v) CrosshairFrame.Visible = v CFG.Crosshair = v end)

AddToggle(VisSec2, "Chams / Outline", CFG.ChamsEnabled, function(v) CFG.ChamsEnabled = v end)
AddSlider(VisSec2, "Chams Transparency", 0, 100, CFG.ChamsTrans, function(v) CFG.ChamsTrans = v end)
AddToggle(VisSec2, "Custom Cam FOV", CFG.CamFOVEnabled, function(v) CFG.CamFOVEnabled = v end)
AddSlider(VisSec2, "FOV Value", 70, 120, CFG.CamFOVVal, function(v) CFG.CamFOVVal = v end)

-- Movement Tab
local MoveSec1 = CreateSection(MoveTab, "Speed & Jump")
local MoveSec2 = CreateSection(MoveTab, "Physics & Tricks")
AddToggle(MoveSec1, "WalkSpeed Hack", CFG.Speed, function(v) CFG.Speed = v end)
AddSlider(MoveSec1, "Speed Value", 16, 500, CFG.SpeedVal, function(v) CFG.SpeedVal = v end)
AddToggle(MoveSec1, "Jump Boost", CFG.Jump, function(v) CFG.Jump = v end)
AddSlider(MoveSec1, "Jump Value", 50, 250, CFG.JumpVal, function(v) CFG.JumpVal = v end)

AddToggle(MoveSec2, "Modify Gravity", CFG.GravityEnabled, function(v)
CFG.GravityEnabled = v
if not v then
workspace.Gravity = 196.2
end
end)
AddSlider(MoveSec2, "Gravity Force", 0, 300, CFG.GravityVal, function(v) CFG.GravityVal = v end)
AddToggle(MoveSec2, "Auto Bhop", CFG.Bhop, function(v) CFG.Bhop = v end)
AddToggle(MoveSec2, "Infinite Jump", CFG.InfJump, function(v) CFG.InfJump = v end)
AddToggle(MoveSec2, "Spinbot", CFG.Spinbot, function(v) CFG.Spinbot = v end)
AddSlider(MoveSec2, "Spin Speed", 10, 200, CFG.SpinSpeed, function(v) CFG.SpinSpeed = v end)

AddToggle(MoveSec2, "Noclip", CFG.Noclip, function(v)
CFG.Noclip = v
if not v and LocalPlayer.Character then
for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
if part:IsA("BasePart") then part.CanCollide = true end
end
end
end)

-- Shaders Tab
local ShaderSec1 = CreateSection(ShaderTab, "Environment & Preset Controls", 265)
local ShaderSec2 = CreateSection(ShaderTab, "Fine Tuning Shaders", 265)

local function RemoveShaderEffects()
for _, obj in ipairs(Lighting:GetChildren()) do
if obj:IsA("BloomEffect") or obj:IsA("ColorCorrectionEffect") or obj:IsA("SunRaysEffect") or obj:IsA("Atmosphere") or obj:IsA("DepthOfFieldEffect") then
if obj.Name:find("Nuclear") or obj.Name:find("Shader") then obj:Destroy() end
end
end
Lighting.GlobalShadows = true
Lighting.Brightness = 2
Lighting.ClockTime = 14
Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
end

local function ApplyShaders()
RemoveShaderEffects()
if not CFG.ShadersEnabled then return end

local bloom = Instance.new("BloomEffect", Lighting)  
bloom.Name = "NuclearBloom"  
bloom.Intensity = CFG.ShaderBloom  
bloom.Size = 24  
bloom.Threshold = 0.8  

local color = Instance.new("ColorCorrectionEffect", Lighting)  
color.Name = "NuclearColor"  
color.Brightness = CFG.ShaderBrightness  
color.Contrast = CFG.ShaderContrast  
color.Saturation = CFG.ShaderSaturation  

local sun = Instance.new("SunRaysEffect", Lighting)  
sun.Name = "NuclearSun"  
sun.Intensity = CFG.ShaderSunRays  
sun.Spread = 0.8

end

AddToggle(ShaderSec1, "Enable Shaders Engine", CFG.ShadersEnabled, function(v)
CFG.ShadersEnabled = v
if v then ApplyShaders() else RemoveShaderEffects() end
end)

local PresetLbl = RegisterElement("SubTexts", Instance.new("TextLabel", ShaderSec1))
PresetLbl.Size = UDim2.new(1, -4, 0, 18)
PresetLbl.Text = "Shader Presets:"
PresetLbl.Font = Enum.Font.GothamMedium
PresetLbl.TextSize = 10
PresetLbl.TextColor3 = CurrentTheme.SubText
PresetLbl.TextXAlignment = Enum.TextXAlignment.Left
PresetLbl.BackgroundTransparency = 1

local ShaderPresetsList = {
    {"Default", 0, 0.15, 0.2, 0.4, 0.1},
    {"Cyberpunk", -0.05, 0.35, 0.6, 0.8, 0.2},
    {"Vibrant", 0.05, 0.2, 0.8, 0.5, 0.15},
    {"Soft Pastel", 0.1, -0.1, -0.1, 0.3, 0.05},
    {"Noir", -0.1, 0.4, -1.0, 0.2, 0.0}
}

for _, pInfo in ipairs(ShaderPresetsList) do
    local pBtn = Instance.new("TextButton", ShaderSec1)
    pBtn.Size = UDim2.new(1, -4, 0, 24)
    pBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
    pBtn.Text = pInfo[1]
    pBtn.Font = Enum.Font.GothamBold
    pBtn.TextSize = 10
    pBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", pBtn).CornerRadius = UDim.new(0, 6)

    pBtn.MouseButton1Click:Connect(function()
        CFG.ShaderBrightness = pInfo[2]
        CFG.ShaderContrast = pInfo[3]
        CFG.ShaderSaturation = pInfo[4]
        CFG.ShaderBloom = pInfo[5]
        CFG.ShaderSunRays = pInfo[6]
        if CFG.ShadersEnabled then ApplyShaders() end
    end)
end

AddSlider(ShaderSec2, "Brightness", -0.5, 0.5, CFG.ShaderBrightness, function(v)
CFG.ShaderBrightness = v
if CFG.ShadersEnabled then ApplyShaders() end
end)

AddSlider(ShaderSec2, "Contrast", -0.5, 1.0, CFG.ShaderContrast, function(v)
CFG.ShaderContrast = v
if CFG.ShadersEnabled then ApplyShaders() end
end)

AddSlider(ShaderSec2, "Saturation", -1.0, 2.0, CFG.ShaderSaturation, function(v)
CFG.ShaderSaturation = v
if CFG.ShadersEnabled then ApplyShaders() end
end)

AddSlider(ShaderSec2, "Bloom Intensity", 0, 2.0, CFG.ShaderBloom, function(v)
CFG.ShaderBloom = v
if CFG.ShadersEnabled then ApplyShaders() end
end)

AddSlider(ShaderSec2, "SunRays Intensity", 0, 1.0, CFG.ShaderSunRays, function(v)
CFG.ShaderSunRays = v
if CFG.ShadersEnabled then ApplyShaders() end
end)

-- ==================== FFLAGS TAB ====================
local FFlagsSec1 = CreateSection(FFlagsTab, "Fast Flags Management", 265)
local FFlagsSec2 = CreateSection(FFlagsTab, "FFlags Presets & Quick Apply", 265)

AddToggle(FFlagsSec1, "Fullbright", CFG.Fullbright, function(v) CFG.Fullbright = v end)
AddToggle(FFlagsSec1, "FPS Boost Mode", CFG.FPSBoost, function(v)
CFG.FPSBoost = v
if v then
for _, obj in ipairs(workspace:GetDescendants()) do
if obj:IsA("BasePart") then
obj.Material = Enum.Material.SmoothPlastic
end
end
end
end)

-- Поле ввода для кастомных ффлагов
local FFlagInput = Instance.new("TextBox", FFlagsSec1)
FFlagInput.Size = UDim2.new(1, -4, 0, 130)
FFlagInput.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
FFlagInput.MultiLine = true
FFlagInput.ClearTextOnFocus = false
FFlagInput.Text = "-- Вставь сюда свои FFlags (JSON или список)\n-- Например: {\"DFIntTaskSchedulerTargetFps\": 240}"
FFlagInput.Font = Enum.Font.Code
FFlagInput.TextSize = 9
FFlagInput.TextColor3 = Color3.fromRGB(220, 220, 240)
FFlagInput.TextXAlignment = Enum.TextXAlignment.Left
FFlagInput.TextYAlignment = Enum.TextYAlignment.Top
Instance.new("UICorner", FFlagInput).CornerRadius = UDim.new(0, 6)
local ffiStroke = Instance.new("UIStroke", FFlagInput) ffiStroke.Color = Color3.fromRGB(30, 30, 40)

local ApplyFFlagsBtn = Instance.new("TextButton", FFlagsSec1)
ApplyFFlagsBtn.Size = UDim2.new(1, -4, 0, 28)
ApplyFFlagsBtn.BackgroundColor3 = DarkRedColor
ApplyFFlagsBtn.Text = "Run Custom FFlags"
ApplyFFlagsBtn.Font = Enum.Font.GothamBold
ApplyFFlagsBtn.TextSize = 10
ApplyFFlagsBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", ApplyFFlagsBtn).CornerRadius = UDim.new(0, 6)

ApplyFFlagsBtn.MouseButton1Click:Connect(function()
    local text = FFlagInput.Text
    if text == "" then return end
    
    pcall(function()
        local data = nil
        local success, res = pcall(function() return HttpService:JSONDecode(text) end)
        if success and type(res) == "table" then
            data = res
        end
        
        if setfflag then
            if data then
                for k, v in pairs(data) do
                    pcall(function() setfflag(tostring(k), tostring(v)) end)
                end
            else
                for line in text:gmatch("[^\r\n]+") do
                    if not line:match("^%s*%-%-") then
                        local k, v = line:match("([^=]+)=(.+)")
                        if k and v then
                            k = k:match("^%s*(.-)%s*$")
                            v = v:match("^%s*(.-)%s*$")
                            pcall(function() setfflag(k, v) end)
                        end
                    end
                end
            end
        end
    end)
end)

-- Готовые пресеты FFlags
local FFlagPresets = {
    {"Unlock FPS (240 FPS)", '{"DFIntTaskSchedulerTargetFps": 240}'},
    {"Disable PostFX / Low GFX", '{"FIntFRMMinGrassDistance": 0, "FFlagDebugForceFutureIsBrightPhase3": false}'},
    {"Enable Audio/Voice Fix", '{"FFlagAudioChannelMixerUseVoiceChat": true}'}
}

for _, pInfo in ipairs(FFlagPresets) do
    local pBtn = Instance.new("TextButton", FFlagsSec2)
    pBtn.Size = UDim2.new(1, -4, 0, 26)
    pBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
    pBtn.Text = pInfo[1]
    pBtn.Font = Enum.Font.GothamBold
    pBtn.TextSize = 10
    pBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", pBtn).CornerRadius = UDim.new(0, 6)

    pBtn.MouseButton1Click:Connect(function()
        FFlagInput.Text = pInfo[2]
        pcall(function()
            local data = HttpService:JSONDecode(pInfo[2])
            if setfflag and data then
                for k, v in pairs(data) do
                    pcall(function() setfflag(tostring(k), tostring(v)) end)
                end
            end
        end)
    end)
end

-- Misc Tab
local MiscSec = CreateSection(MiscTab, "Misc Options")
AddToggle(MiscSec, "Anti-AFK Kick", CFG.AntiAFK, function(v) CFG.AntiAFK = v end)

-- Keybinds Tab
local KeySec = CreateSection(KeybindsTab, "Keybindings Config")
AddKeybindPicker(KeySec, "Aimbot Key", "Aimbot")
AddKeybindPicker(KeySec, "Noclip Key", "Noclip")
AddKeybindPicker(KeySec, "Speed Key", "Speed")
AddKeybindPicker(KeySec, "Invisible Key", "Invisible")
AddKeybindPicker(KeySec, "Panic Clear Key", "Panic")
AddKeybindPicker(KeySec, "Combo Macro Key", "Combo")

-- Menu Tab
local MenuSec = CreateSection(MenuTab, "Menu Configuration")
AddSlider(MenuSec, "Menu Scale", 0.5, 2.0, CFG.MenuScale, function(v)
CFG.MenuScale = v
MenuUIScale.Scale = v
end)
AddSlider(MenuSec, "Menu Width", 500, 1000, CFG.MenuWidth, function(v)
CFG.MenuWidth = v
MainFrame.Size = UDim2.new(0, CFG.MenuWidth, 0, CFG.MenuHeight)
end)
AddSlider(MenuSec, "Menu Height", 350, 700, CFG.MenuHeight, function(v)
CFG.MenuHeight = v
MainFrame.Size = UDim2.new(0, CFG.MenuWidth, 0, CFG.MenuHeight)
end)

-- Players Tab
local PlayersSec = CreateSection(PlayersTab, "Server Players Actions", 535)
local PlayerListFrame = Instance.new("Frame", PlayersSec)
PlayerListFrame.Size = UDim2.new(1, 0, 0, 0)
PlayerListFrame.BackgroundTransparency = 1

local pListLayout = Instance.new("UIListLayout", PlayerListFrame)
pListLayout.Padding = UDim.new(0, 6)

pListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    PlayerListFrame.Size = UDim2.new(1, 0, 0, pListLayout.AbsoluteContentSize.Y)
end)

local spectatingPlayer = nil

local function RefreshPlayerList()
    for _, c in ipairs(PlayerListFrame:GetChildren()) do
        if c:IsA("Frame") then c:Destroy() end
    end

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local pRow = Instance.new("Frame", PlayerListFrame)
            pRow.Size = UDim2.new(1, -4, 0, 32)
            pRow.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
            Instance.new("UICorner", pRow).CornerRadius = UDim.new(0, 6)
            local rStroke = Instance.new("UIStroke", pRow)
            rStroke.Color = Color3.fromRGB(30, 30, 40)

            local pLbl = RegisterElement("Texts", Instance.new("TextLabel", pRow))
            pLbl.Size = UDim2.new(1, -160, 1, 0)
            pLbl.Position = UDim2.new(0, 8, 0, 0)
            pLbl.Text = p.DisplayName .. " (@" .. p.Name .. ")"
            pLbl.TextColor3 = CurrentTheme.Text
            pLbl.Font = Enum.Font.GothamMedium
            pLbl.TextSize = 10
            pLbl.BackgroundTransparency = 1
            pLbl.TextXAlignment = Enum.TextXAlignment.Left

            local tpBtn = Instance.new("TextButton", pRow)
            tpBtn.Size = UDim2.new(0, 70, 0, 22)
            tpBtn.Position = UDim2.new(1, -150, 0.5, -11)
            tpBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
            tpBtn.Text = "Teleport"
            tpBtn.Font = Enum.Font.GothamBold
            tpBtn.TextSize = 9
            tpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0, 4)

            tpBtn.MouseButton1Click:Connect(function()
                if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                end
            end)

            local specBtn = Instance.new("TextButton", pRow)
            specBtn.Size = UDim2.new(0, 70, 0, 22)
            specBtn.Position = UDim2.new(1, -74, 0.5, -11)
            specBtn.BackgroundColor3 = (spectatingPlayer == p) and DarkRedColor or Color3.fromRGB(28, 28, 36)
            specBtn.Text = (spectatingPlayer == p) and "Unspectate" or "Spectate"
            specBtn.Font = Enum.Font.GothamBold
            specBtn.TextSize = 9
            specBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Instance.new("UICorner", specBtn).CornerRadius = UDim.new(0, 4)

            specBtn.MouseButton1Click:Connect(function()
                local cam = GetCamera()
                if spectatingPlayer == p then
                    spectatingPlayer = nil
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                        cam.CameraSubject = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                    end
                else
                    spectatingPlayer = p
                    if p.Character and p.Character:FindFirstChildOfClass("Humanoid") then
                        cam.CameraSubject = p.Character:FindFirstChildOfClass("Humanoid")
                    end
                end
                RefreshPlayerList()
            end)
        end
    end
end
RefreshPlayerList()
Players.PlayerAdded:Connect(RefreshPlayerList)
Players.PlayerRemoving:Connect(RefreshPlayerList)

-- Executor Tab
local ExecSec1 = CreateSection(ExecutorTab, "Lua Script Executor", 265)
local ExecSec2 = CreateSection(ExecutorTab, "Process & Bug Log Board", 265)

local CodeInput = Instance.new("TextBox", ExecSec1)
CodeInput.Size = UDim2.new(1, -4, 0, 180)
CodeInput.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
CodeInput.MultiLine = true
CodeInput.ClearTextOnFocus = false
CodeInput.Text = "-- Paste your Lua code here\nprint('Nuclear Executor Ready!')"
CodeInput.Font = Enum.Font.Code
CodeInput.TextSize = 10
CodeInput.TextColor3 = Color3.fromRGB(220, 220, 240)
CodeInput.TextXAlignment = Enum.TextXAlignment.Left
CodeInput.TextYAlignment = Enum.TextYAlignment.Top
Instance.new("UICorner", CodeInput).CornerRadius = UDim.new(0, 6)
local ciStroke = Instance.new("UIStroke", CodeInput) ciStroke.Color = Color3.fromRGB(30, 30, 40)

local ExecBtn = Instance.new("TextButton", ExecSec1)
ExecBtn.Size = UDim2.new(0.48, 0, 0, 28)
ExecBtn.BackgroundColor3 = DarkRedColor
ExecBtn.Text = "Execute"
ExecBtn.Font = Enum.Font.GothamBold
ExecBtn.TextSize = 10
ExecBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", ExecBtn).CornerRadius = UDim.new(0, 6)

local ClearBtn = Instance.new("TextButton", ExecSec1)
ClearBtn.Size = UDim2.new(0.48, 0, 0, 28)
ClearBtn.Position = UDim2.new(0.52, 0, 0, 0)
ClearBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
ClearBtn.Text = "Clear"
ClearBtn.Font = Enum.Font.GothamBold
ClearBtn.TextSize = 10
ClearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", ClearBtn).CornerRadius = UDim.new(0, 6)

local LogContainer = Instance.new("ScrollingFrame", ExecSec2)
LogContainer.Size = UDim2.new(1, -4, 0, 250)
LogContainer.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
LogContainer.ScrollBarThickness = 3
LogContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
Instance.new("UICorner", LogContainer).CornerRadius = UDim.new(0, 6)

local LogLayout = Instance.new("UIListLayout", LogContainer)
LogLayout.Padding = UDim.new(0, 4)
LogLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    LogContainer.CanvasSize = UDim2.new(0, 0, 0, LogLayout.AbsoluteContentSize.Y + 10)
end)

local function AddLog(msg, isError)
    local LogItem = Instance.new("TextLabel", LogContainer)
    LogItem.Size = UDim2.new(1, -8, 0, 0)
    LogItem.AutomaticSize = Enum.AutomaticSize.Y
    LogItem.BackgroundTransparency = 1
    LogItem.Font = Enum.Font.Code
    LogItem.TextSize = 9
    LogItem.TextWrapped = true
    LogItem.TextXAlignment = Enum.TextXAlignment.Left
    
    local timeStr = os.date("[%H:%M:%S] ")
    if isError then
        LogItem.Text = timeStr .. "[BUG/ERROR] " .. tostring(msg)
        LogItem.TextColor3 = Color3.fromRGB(255, 80, 80)
    else
        LogItem.Text = timeStr .. "[SUCCESS] " .. tostring(msg)
        LogItem.TextColor3 = Color3.fromRGB(80, 255, 120)
    end
end

local function RunCustomScript(code)
    if not code or code == "" then return end
    local fn, err = loadstring(code)
    if fn then
        local success, execErr = pcall(fn)
        if success then
            AddLog("Script executed successfully!", false)
        else
            AddLog(execErr, true)
        end
    else
        AddLog(err, true)
    end
end

ExecBtn.MouseButton1Click:Connect(function()
    RunCustomScript(CodeInput.Text)
end)

ClearBtn.MouseButton1Click:Connect(function()
    CodeInput.Text = ""
end)

AddToggle(ExecSec1, "Auto-Run on Script Load", CFG.AutoRunEnabled, function(v) CFG.AutoRunEnabled = v end)
AddTextBox(ExecSec1, "Auto-Run Script Code...", function(txt)
    CFG.AutoRunCode = txt
end)

if CFG.AutoRunEnabled and CFG.AutoRunCode ~= "" then
    task.spawn(function()
        task.wait(1)
        RunCustomScript(CFG.AutoRunCode)
    end)
end

-- Server / Macro / Music Tabs
local ServerSec = CreateSection(ServerTab, "Server Actions")
local RejoinBtn = Instance.new("TextButton", ServerSec)
RejoinBtn.Size = UDim2.new(1, -4, 0, 30)
RejoinBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
RejoinBtn.Text = "Rejoin Server"
RejoinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RejoinBtn.Font = Enum.Font.GothamBold
RejoinBtn.TextSize = 10
Instance.new("UICorner", RejoinBtn).CornerRadius = UDim.new(0, 6)
RejoinBtn.MouseButton1Click:Connect(function()
TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end)

local MacroSec = CreateSection(MacroTab, "Macro Setup")
AddToggle(MacroSec, "Enable Combo Macro", CFG.ComboEnabled, function(v) CFG.ComboEnabled = v end)
AddTextBox(MacroSec, "Keys (e.g. Space, One, E)", function(txt) CFG.ComboKeysText = txt end)

local MusicSec = CreateSection(MusicTab, "Boombox Sound Player")

AddToggle(MusicSec, "Music Playing", LocalBoomboxSound.IsPlaying, function(v)
    if v then
        LocalBoomboxSound:Play()
    else
        LocalBoomboxSound:Pause()
    end
end)

AddSlider(MusicSec, "Music Volume", 0, 100, CFG.MusicVolume * 100, function(v)
    CFG.MusicVolume = v / 100
    LocalBoomboxSound.Volume = CFG.MusicVolume
end)

AddSlider(MusicSec, "Music Pitch", 1, 30, CFG.MusicPitch * 10, function(v)
    CFG.MusicPitch = v / 10
    LocalBoomboxSound.PlaybackSpeed = CFG.MusicPitch
end)

AddTextBox(MusicSec, "Audio ID", function(id)
    local cleanId = id:gsub("%D", "")
    if cleanId ~= "" then
        LocalBoomboxSound.SoundId = "rbxassetid://" .. cleanId
        LocalBoomboxSound:Play()
    end
end)

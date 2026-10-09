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
loca
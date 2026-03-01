-- =============================================
-- Unk Hub | نسخة عربية فخمة ٢٠٢٦
-- Splash Screen → ثم يفتح الـ Hub الرئيسي
-- =============================================

local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local SoundService     = game:GetService("SoundService")
local RunService       = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace        = game:GetService("Workspace")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera = Workspace.CurrentCamera

-- ────────────────────────────────────────────────
-- SPLASH SCREEN SETTINGS
-- ────────────────────────────────────────────────
local IMAGE_ID    = "rbxassetid://85339234010248"
local SOUND_ID    = "rbxassetid://110001365430514"
local DISCORD_INV = "https://discord.gg/VCCMqGFP7q"
local DISCORD_LOGO = "rbxassetid://10709791437"

-- Create splash GUI
local sg = Instance.new("ScreenGui")
sg.Name = "UnkHub_Splash_2026"
sg.IgnoreGuiInset = true
sg.ResetOnSpawn = false
sg.Parent = playerGui

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 400, 0, 560)
main.Position = UDim2.new(0.5, -200, 0.5, -280)
main.BackgroundColor3 = Color3.fromRGB(8, 5, 22)
main.BackgroundTransparency = 0.15
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Parent = sg

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 28)
uiCorner.Parent = main

local uiGradient = Instance.new("UIGradient")
uiGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 20, 60)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(15, 10, 40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 5, 22))
}
uiGradient.Rotation = 45
uiGradient.Parent = main

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(160, 100, 255)
stroke.Thickness = 3.5
stroke.Transparency = 0.3
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
stroke.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.9, 0, 0, 80)
title.Position = UDim2.new(0.05, 0, 0.02, 0)
title.BackgroundTransparency = 1
title.Text = "UNK HUB"
title.TextColor3 = Color3.fromRGB(220, 200, 255)
title.TextSize = 52
title.Font = Enum.Font.FredokaOne
title.TextStrokeTransparency = 0.65
title.TextStrokeColor3 = Color3.fromRGB(120, 80, 220)
title.TextXAlignment = Enum.TextXAlignment.Center
title.Parent = main

local img = Instance.new("ImageLabel")
img.Size = UDim2.new(0.86, 0, 0.50, 0)
img.Position = UDim2.new(0.07, 0, 0.18, 0)
img.BackgroundTransparency = 1
img.Image = IMAGE_ID
img.ScaleType = Enum.ScaleType.Fit
img.ResampleMode = Enum.ResamplerMode.Default
img.Parent = main

local imgCorner = Instance.new("UICorner")
imgCorner.CornerRadius = UDim.new(0, 20)
imgCorner.Parent = img

local imgGlow = Instance.new("UIStroke")
imgGlow.Color = Color3.fromRGB(180, 120, 255)
imgGlow.Thickness = 2.8
imgGlow.Transparency = 0.45
imgGlow.Parent = img

local btn = Instance.new("ImageButton")
btn.Size = UDim2.new(0.78, 0, 0.09, 0)
btn.Position = UDim2.new(0.11, 0, 0.80, 0)
btn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
btn.AutoButtonColor = false
btn.Image = DISCORD_LOGO
btn.ImageColor3 = Color3.new(1,1,1)
btn.ScaleType = Enum.ScaleType.Fit
btn.Parent = main

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 16)
btnCorner.Parent = btn

local btnGrad = Instance.new("UIGradient")
btnGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(110, 130, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(70, 90, 230))
}
btnGrad.Parent = btn

local btnText = Instance.new("TextLabel")
btnText.Size = UDim2.new(0.70, 0, 1, 0)
btnText.Position = UDim2.new(0.22, 0, 0, 0)
btnText.BackgroundTransparency = 1
btnText.Text = "انضم إلى سيرفر ديسكورد أنك"
btnText.TextColor3 = Color3.new(1,1,1)
btnText.TextSize = 22
btnText.Font = Enum.Font.GothamBold
btnText.TextXAlignment = Enum.TextXAlignment.Left
btnText.Parent = btn

local snd = Instance.new("Sound")
snd.SoundId = SOUND_ID
snd.Volume = 0.65
snd.Parent = SoundService
snd:Play()

-- Splash animations
local enterTween = TweenInfo.new(1.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
main.BackgroundTransparency = 1
main.Size = UDim2.new(0, 360, 0, 500)
main.Position = UDim2.new(0.5, -180, 0.5, -220)

TweenService:Create(main, enterTween, {
    BackgroundTransparency = 0.15,
    Size = UDim2.new(0, 400, 0, 560),
    Position = UDim2.new(0.5, -200, 0.5, -280)
}):Play()

local pulseTween = TweenInfo.new(4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
TweenService:Create(img, pulseTween, {ImageTransparency = 0.12}):Play()

btn.MouseEnter:Connect(function()
    TweenService:Create(btn, TweenInfo.new(0.28), {
        Size = UDim2.new(0.82, 0, 0.095, 0),
        BackgroundColor3 = Color3.fromRGB(110, 130, 255)
    }):Play()
end)

btn.MouseLeave:Connect(function()
    TweenService:Create(btn, TweenInfo.new(0.28), {
        Size = UDim2.new(0.78, 0, 0.09, 0),
        BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    }):Play()
end)

btn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(DISCORD_INV)
        btnText.Text = "تم النسخ ✓"
        task.delay(1.8, function()
            if btnText.Parent then btnText.Text = "انضم إلى سيرفر ديسكورد UNK HUB" end
        end)
    else
        btnText.Text = "فشل النسخ :("
    end
end)

-- ────────────────────────────────────────────────
-- MAIN HUB VARIABLES & FUNCTIONS
-- ────────────────────────────────────────────────

local infJumpEnabled     = false
local instantGrabEnabled = false
local isGodmode          = false
local ghostClone         = nil
local godHeartbeat       = nil
local godStepped         = nil

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if not infJumpEnabled then return end
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChildWhichIsA("Humanoid")
    if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
end)

-- Instant Grab
local promptCache = {}

local function makePromptInstant(prompt)
    if not promptCache[prompt] then promptCache[prompt] = prompt.HoldDuration end
    prompt.HoldDuration = 0
    prompt.RequiresLineOfSight = false
end

local function restorePrompt(prompt)
    if promptCache[prompt] then prompt.HoldDuration = promptCache[prompt] end
end

local function updateAllPrompts(enable)
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") then
            if enable then makePromptInstant(obj) else restorePrompt(obj) end
        end
    end
end

Workspace.DescendantAdded:Connect(function(child)
    if instantGrabEnabled and child:IsA("ProximityPrompt") then
        task.wait()
        makePromptInstant(child)
    end
end)

-- Godmode
local function disableGodmode()
    isGodmode = false
    if godHeartbeat then godHeartbeat:Disconnect() godHeartbeat = nil end
    if godStepped   then godStepped:Disconnect()   godStepped   = nil end
    
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildWhichIsA("Humanoid")
    
    for _, p in ipairs(char:GetDescendants()) do
        if p:IsA("BasePart") then p.CanCollide = true p.Velocity = Vector3.zero end
    end
    
    if ghostClone and hrp then
        hrp.CFrame = ghostClone:FindFirstChild("HumanoidRootPart").CFrame * CFrame.new(0, 3, 0)
    end
    
    if hum then
        hum.PlatformStand = false
        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        camera.CameraSubject = hum
    end
    
    if ghostClone then ghostClone:Destroy() ghostClone = nil end
end

-- Speed Farm
local UpgradeSpeedRemote = ReplicatedStorage:WaitForChild("RemoteFunctions"):WaitForChild("UpgradeSpeed", 5)

local autoSpeed1  = false
local autoSpeed10 = false

task.spawn(function()
    while task.wait(0.1) do
        if autoSpeed1  then pcall(function() UpgradeSpeedRemote:InvokeServer(1)  end) end
        if autoSpeed10 then pcall(function() UpgradeSpeedRemote:InvokeServer(10) end) end
    end
end)

-- VIP Delete
local VIPEnabled = false
local VIPBackup = {}
local VIPParent = nil

local function getVIP()
    local map = Workspace:FindFirstChild("DefaultMap_SharedInstances", true)
    if not map then return end
    return map:FindFirstChild("VIPWalls")
end

local function backupAndDestroyVIP()
    local vip = getVIP()
    if not vip then return end
    
    VIPParent = vip
    VIPBackup = {}
    
    for _, child in ipairs(vip:GetChildren()) do
        table.insert(VIPBackup, child:Clone())
    end
    
    vip:ClearAllChildren()
    
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj.Name:lower():find("vip") and (obj:IsA("BasePart") or obj:IsA("Model")) and obj.CanCollide then
            pcall(function() obj:Destroy() end)
        end
    end
end

local function restoreVIP()
    if not VIPParent or #VIPBackup == 0 then return end
    VIPParent:ClearAllChildren()
    for _, cloned in ipairs(VIPBackup) do
        cloned.Parent = VIPParent
    end
    VIPBackup = {}
    VIPParent = nil
end

-- ────────────────────────────────────────────────
-- LOAD MAIN HUB AFTER SPLASH
-- ────────────────────────────────────────────────

local function loadMainHub()
    local success, library = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/liebertsx/Tora-Library/main/src/librarynew"))()
    end)
    
    if not success or not library then
        warn("Failed to load Tora Library")
        return
    end
    
    local window = library:CreateWindow("Unk Hub - 2026")

    -- القفز والإمساك
    local basic = window:AddFolder("القفز والإمساك الأساسي")
    basic:AddToggle({text = "القفز اللامتناهي", state = false, callback = function(v) infJumpEnabled = v end})
    basic:AddToggle({text = "الإمساك الفوري", state = false, callback = function(v) 
        instantGrabEnabled = v 
        updateAllPrompts(v) 
    end})
    basic:AddLabel({text = "---------------------"})

    -- وضع الإله
    local god = window:AddFolder("وضع الإله")
    god:AddToggle({text = "تفعيل وضع الإله", state = false, callback = function(v)
        if v then
            local char = player.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChildWhichIsA("Humanoid")
            if not hrp or not hum then return end
            
            isGodmode = true
            char.Archivable = true
            ghostClone = char:Clone()
            ghostClone.Parent = Workspace
            char.Archivable = false
            
            for _, p in ghostClone:GetDescendants() do
                if p:IsA("BasePart") then 
                    p.Transparency = 0.55 
                    p.CanCollide = true 
                end
            end
            
            hum.PlatformStand = true
            camera.CameraSubject = ghostClone:FindFirstChildWhichIsA("Humanoid")
            
            godStepped = RunService.Stepped:Connect(function()
                if not isGodmode then return end
                for _, p in char:GetDescendants() do 
                    if p:IsA("BasePart") then p.CanCollide = false end 
                end
            end)
            
            godHeartbeat = RunService.Heartbeat:Connect(function()
                if not isGodmode or not ghostClone then disableGodmode() return end
                local gHRP = ghostClone:FindFirstChild("HumanoidRootPart")
                local gHum = ghostClone:FindFirstChildWhichIsA("Humanoid")
                if gHRP and gHum then
                    gHum:Move(hum.MoveDirection)
                    gHum.Jump = hum.Jump
                    hrp.CFrame = gHRP.CFrame * CFrame.new(0, -10, 0)
                    hrp.AssemblyLinearVelocity = Vector3.zero
                end
            end)
        else
            disableGodmode()
        end
    end})
    god:AddLabel({text = "---------------------"})

    -- السرعة
    local speed = window:AddFolder("ترقية السرعة")
    speed:AddToggle({text = "ترقية +1 تلقائي", state = false, callback = function(v) autoSpeed1 = v end})
    speed:AddToggle({text = "ترقية +10 تلقائي", state = false, callback = function(v) autoSpeed10 = v end})
    speed:AddLabel({text = "---------------------"})

    -- VIP
    local vipf = window:AddFolder("VIP / VIP+")
    vipf:AddToggle({text = "حذف جدران VIP نهائياً", state = false, callback = function(v)
        VIPEnabled = v
        if v then backupAndDestroyVIP() else restoreVIP() end
    end})

    library:Init()

    print("┏━━━━━━━━━━━━━━━━━━━━━━┓")
    print("┃   Unk Hub 2026 Loaded   ┃")
    print("┗━━━━━━━━━━━━━━━━━━━━━━┛")
end

-- ────────────────────────────────────────────────
-- SPLASH CLOSE → LOAD HUB
-- ────────────────────────────────────────────────

task.delay(5.5, function()
    if sg and sg.Parent then
        local exitTween = TweenService:Create(main, TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 320, 0, 440),
            Position = UDim2.new(0.5, -160, 0.5, -200)
        })
        exitTween:Play()
        exitTween.Completed:Connect(function()
            sg:Destroy()
            loadMainHub()
        end)
    end
end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        if sg and sg.Parent then
            sg:Destroy()
            loadMainHub()
        end
    end
end)

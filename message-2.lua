--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
local MacLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/bimoraa/Euphoria/refs/heads/main/MacUI/main.luau"))()

local Window = MacLib:Window({
    Title = "Noxius Hub",
    Subtitle = "Noxius Communiy",
    Size = UDim2.fromOffset(580, 420),
    Keybind = Enum.KeyCode.RightShift,
    ShowUserInfo = true,
    DragStyle = 2
})

local tabGroup = Window:TabGroup()

local MainTab = tabGroup:Tab({ Name = "Information", Image = "info" })
local FarmTab = tabGroup:Tab({ Name = "Player", Image = "sprout" })
local TeleportTab = tabGroup:Tab({ Name = "Main", Image = "eye" })
local VisualTab = tabGroup:Tab({ Name = "Teleport", Image = "map-pin" })
local MiscTab = tabGroup:Tab({ Name = "Misc", Image = "settings" })

local DiscordSection = MainTab:Section({
    Name = "Discord",
    Side = "Left",
    Collapsible = true,
    DefaultCollapsed = false
})

DiscordSection:Paragraph({
    Header = "Join Our Discord",
    Body = "Join Us! Dapatkan update terbaru, support, dan komunitas Noxius di sini."
})

DiscordSection:Button({
    Name = "Copy Discord Link",
    Callback = function()
        local link = "https://discord.gg/noxius"
        if setclipboard then
            setclipboard(link)
            Window:Notify({
                Title = "Success",
                Description = "Discord link copied to clipboard!",
                Variant = "success",
                Lifetime = 4
            })
        else
            Window:Notify({
                Title = "Error",
                Description = "Clipboard not supported.",
                Variant = "error"
            })
        end
    end
})


local PlayerSection = FarmTab:Section({
    Name = "Player",
    Side = "Left",
    Collapsible = true,
    DefaultCollapsed = false
})

local P = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
_G.InfiniteJump = false

PlayerSection:Toggle({
    Name = "Infinite Jump",
    Default = false,
    Callback = function(state)
        _G.InfiniteJump = state
    end
})

UIS.JumpRequest:Connect(function()
    if _G.InfiniteJump then
        local h = P.Character and P.Character:FindFirstChildOfClass("Humanoid")
        if h then
            h:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

local Z = {P.CameraMaxZoomDistance, P.CameraMinZoomDistance}

PlayerSection:Toggle({
    Name = "Infinite Zoom",
    Default = false,
    Callback = function(s)
        if s then
            P.CameraMaxZoomDistance = math.huge
            P.CameraMinZoomDistance = 0.5
        else
            P.CameraMaxZoomDistance = Z[1] or 128
            P.CameraMinZoomDistance = Z[2] or 0.5
        end
    end
})

local TeleMainSection = TeleportTab:Section({
    Name = "Main",
    Side = "Left",
    Collapsible = true,
    DefaultCollapsed = false
})

local ProximityPromptService = game:GetService("ProximityPromptService")

local InstantPrompt = false
local cache = {} 

local function applyPrompt(prompt)
    if not cache[prompt] then
        cache[prompt] = prompt.HoldDuration
    end
    prompt.HoldDuration = 0
    prompt.RequiresLineOfSight = false
end

local function restorePrompt(prompt)
    if cache[prompt] then
        prompt.HoldDuration = cache[prompt]
    end
end

TeleMainSection:Toggle({
    Name = "Instant Interact",
    Default = false,
    Callback = function(state)
        InstantPrompt = state
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("ProximityPrompt") then
                if state then
                    applyPrompt(v)
                else
                    restorePrompt(v)
                end
            end
        end
    end
})


workspace.DescendantAdded:Connect(function(v)
    if InstantPrompt and v:IsA("ProximityPrompt") then
        task.wait()
        applyPrompt(v)
    end
end)


-- TeleMainSection:Divider()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = Players.LocalPlayer

local Remote = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net"):WaitForChild("RF/Plot.PlotAction")

local AutoCollect = false
local SlotList = {}
for i = 1, 20 do
    table.insert(SlotList, tostring(i))
end

local function GetMyBaseName()
    local basesFolder = workspace:WaitForChild("Bases")
    local character = Player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end

    local closestBase = nil
    local shortestDistance = math.huge

    for _, base in pairs(basesFolder:GetChildren()) do
        if base:IsA("Model") and base.PrimaryPart then
            local distance = (base.PrimaryPart.Position - root.Position).Magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                closestBase = base
            end
        end
    end

    return closestBase and closestBase.Name or nil
end

task.spawn(function()
    while task.wait(1) do
        if AutoCollect then
            local BaseName = GetMyBaseName()
            if not BaseName then continue end

            for _, slot in ipairs(SlotList) do
                if not AutoCollect then break end
                pcall(function()
                    Remote:InvokeServer("Collect Money", BaseName, slot)
                end)
                task.wait(0.05)
            end
        end
    end
end)

TeleMainSection:Toggle({
    Name = "Auto Collect Cash",
    Default = false,
    Callback = function(state)
        AutoCollect = state
    end
})

-- Divider lagi
-- TeleMainSection:Divider()

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RebirthRemote = ReplicatedStorage:WaitForChild("RemoteFunctions"):WaitForChild("Rebirth")

_G.AutoRebirth = false

task.spawn(function()
    while task.wait(1) do
        if _G.AutoRebirth then
            pcall(function()
                RebirthRemote:InvokeServer()
            end)
        end
    end
end)

TeleMainSection:Toggle({
    Name = "Auto Rebirth",
    Default = false,
    Callback = function(state)
        _G.AutoRebirth = state
    end
})

-- Divider
-- TeleMainSection:Divider()

local AutoSellTool = false
local SellDelay = 1

TeleMainSection:Input({
    Name = "Sell Tool Delay",
    Default = "1",
    Numeric = true,
    Callback = function(val)
        local num = tonumber(val)
        if num then
            SellDelay = num
            Window:Notify({
                Title = "Updated",
                Description = "Sell Tool delay set to " .. num .. " seconds",
                Variant = "info",
                Lifetime = 3
            })
        else
            Window:Notify({
                Title = "Error",
                Description = "Invalid delay input",
                Variant = "error"
            })
        end
    end
})

TeleMainSection:Toggle({
    Name = "Auto Sell Tool",
    Default = false,
    Callback = function(state)
        AutoSellTool = state
        if state then
            Window:Notify({Title = "Auto Sell", Description = "Auto Sell Tool ON", Variant = "success"})
            task.spawn(function()
                while AutoSellTool do
                    pcall(function()
                        game:GetService("ReplicatedStorage")
                            :WaitForChild("RemoteFunctions")
                            :WaitForChild("SellTool")
                            :InvokeServer()
                    end)
                    task.wait(SellDelay)
                end
            end)
        else
            Window:Notify({Title = "Auto Sell", Description = "Auto Sell Tool OFF", Variant = "error"})
        end
    end
})

TeleMainSection:Button({
    Name = "Sell All Inventory",
    Callback = function()
        pcall(function()
            game:GetService("ReplicatedStorage")
                :WaitForChild("RemoteFunctions")
                :WaitForChild("SellAll")
                :InvokeServer()
        end)
        Window:Notify({
            Title = "Success",
            Description = "Successfully Sold All Inventory",
            Variant = "success"
        })
    end
})

local GamepassSection = TeleportTab:Section({
    Name = "Gamepass",
    Side = "Left",
    Collapsible = true,
    DefaultCollapsed = false
})

local RunService = game:GetService("RunService")
local Enabled = false
local Backup = {}
local Connection

local function getVIP()
    local map = workspace:FindFirstChild("DefaultMap_SharedInstances", true)
    if not map then return end
    return map:FindFirstChild("VIPWalls")
end

local function backupVIP(vip)
    Backup = {}
    for _, v in ipairs(vip:GetChildren()) do
        table.insert(Backup, v:Clone())
    end
end

local function restoreVIP(vip)
    vip:ClearAllChildren()
    for _, v in ipairs(Backup) do
        v:Clone().Parent = vip
    end
end

local function enableVIP()
    local vip = getVIP()
    if not vip then return end

    if #Backup == 0 then
        backupVIP(vip)
    end

    Connection = RunService.Heartbeat:Connect(function()
        for _, v in ipairs(vip:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
            if v:IsA("GuiObject") or v:IsA("Decal") or v:IsA("Texture") or v.Name:lower():match("vip") then
                pcall(function()
                    v:Destroy()
                end)
            end
        end
    end)
end

local function disableVIP()
    if Connection then
        Connection:Disconnect()
        Connection = nil
    end

    local vip = getVIP()
    if vip and #Backup > 0 then
        restoreVIP(vip)
    end
end

GamepassSection:Button({
    Name = "Unlock Vip And Vip+",
    Callback = function()
        Enabled = not Enabled
        if Enabled then
            Window:Notify({Title = "VIP Unlock", Description = "VIP Walls Disabled", Variant = "success"})
            enableVIP()
        else
            Window:Notify({Title = "VIP Unlock", Description = "VIP Walls Restored", Variant = "info"})
            disableVIP()
        end
    end
})

local GapsSection = VisualTab:Section({
    Name = "Gaps Teleport",
    Side = "Left",
    Collapsible = true,
    DefaultCollapsed = false
})

GapsSection:Paragraph({
    Header = "Read this!",
    Body = "Pilih gap satu per satu ya bro.\nJangan langsung lompat ke gap jauh, ada anti-teleport.",
})

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- CONFIG default
local Config = {
    duration = 10,   -- default durasi tween
    offsetX = 0,
    offsetZ = 0
}

-- ENGINE
local function teleportTween(targetPos, customDuration, customOffsetY)
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")

    -- LANGKAH 1: pindah ke posisi sekarang + offset Y (per Gap)
    local currentPos = hrp.Position
    local startPos = currentPos + Vector3.new(0, customOffsetY or 0, 0)
    hrp.CFrame = CFrame.new(startPos)
    print("[Teleport] Player dipindah ke posisi sekarang + offset Y:", startPos)

    -- LANGKAH 2: tween ke target + offset X/Z
    local finalPos = targetPos + Vector3.new(Config.offsetX, 0, Config.offsetZ)
    local duration = customDuration or Config.duration
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(hrp, tweenInfo, {CFrame = CFrame.new(finalPos)}):Play()
    print("[Teleport] Tween ke target:", finalPos)
end

-- GAP OPTIONS
local gapsOptions = {
    "Gap 1 (X: 206)",
    "Gap 2 (X: 289)",
    "Gap 3 (X: 399)",
    "Gap 4 (X: 548)",
    "Gap 5 (X: 761)",
    "Gap 6 (X: 1078)",
    "Gap 7 (X: 1574)",
    "Gap 8 (X: 2279)",
    "Gap 9 (X: 2984)",
    "Gap 10 (X: 3339)",
    "Gap 11 (X: 3694)",
    "Gap 12 (X: 4049)"
}

-- Data tiap Gap dengan offset Y berbeda
local gapsData = {
    ["Gap 1 (X: 206)"]   = { pos = Vector3.new(197, -3, -0), duration = 2,  offsetY = -2 },
    ["Gap 2 (X: 289)"]   = { pos = Vector3.new(284, -3, -0), duration = 5,  offsetY = -5 },
    ["Gap 3 (X: 399)"]   = { pos = Vector3.new(397, -3, -0), duration = 5,  offsetY = -8 },
    ["Gap 4 (X: 548)"]   = { pos = Vector3.new(547, -3, -0), duration = 5,  offsetY = -11 },
    ["Gap 5 (X: 761)"]   = { pos = Vector3.new(755, -3, -0), duration = 5,  offsetY = -14 },
    ["Gap 6 (X: 1078)"]  = { pos = Vector3.new(1075, -3, -0), duration = 10, offsetY = -17 },
    ["Gap 7 (X: 1574)"]  = { pos = Vector3.new(1545, -3, -0), duration = 10, offsetY = -17 },
    ["Gap 8 (X: 2279)"]  = { pos = Vector3.new(2263, -3, -0), duration = 10, offsetY = -17 },
    ["Gap 9 (X: 2984)"]  = { pos = Vector3.new(2959, -3, -0), duration = 10, offsetY = -17 },
    ["Gap 10 (X: 3339)"] = { pos = Vector3.new(3329, -3, -0), duration = 10, offsetY = -17 },
    ["Gap 11 (X: 3694)"] = { pos = Vector3.new(3682, -3, -0), duration = 10, offsetY = -17 },
    ["Gap 12 (X: 4049)"] = { pos = Vector3.new(4023, -3, -0), duration = 10, offsetY = -20 }
}

-- DROPDOWN
GapsSection:Dropdown({
    Name = "Pilih Gap untuk Teleport",
    Options = gapsOptions,
    Default = "Gap 1 (X: 206)",   
    Callback = function(selected)
        local data = gapsData[selected]
        if data then
            teleportTween(data.pos, data.duration, data.offsetY)
        else
            Window:Notify({
                Title = "Error",
                Description = "Gap tidak ditemukan!",
                Variant = "error"
            })
        end
    end
})

-- BUTTON
GapsSection:Button({
    Name = "Go Teleport",
    Callback = function()
        local currentSelected = "Gap 1 (X: 206)"
        local data = gapsData[currentSelected]
        if data then
            teleportTween(data.pos, data.duration)
        end
    end
})

local MiscSection = MiscTab:Section({
    Name = "Upgrade Speed",
    Side = "Left",
    Collapsible = true,
    DefaultCollapsed = false
})

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UpgradeSpeedRemote = ReplicatedStorage:WaitForChild("RemoteFunctions"):WaitForChild("UpgradeSpeed")


_G.AutoUpgradeSpeed1 = false

task.spawn(function()
    while task.wait(0.1) do
        if _G.AutoUpgradeSpeed1 then
            pcall(function()
                UpgradeSpeedRemote:InvokeServer(1)
            end)
        end
    end
end)

MiscSection:Toggle({
    Name = "Auto Upgrade Speed +1",
    Default = false,
    Callback = function(state)
        _G.AutoUpgradeSpeed1 = state
        Window:Notify({
            Title = "Auto Upgrade",
            Description = state and "Auto Speed +1 activated!" or "Auto Speed +1 stopped.",
            Variant = state and "success" or "error",
            Lifetime = 3
        })
    end
})

_G.AutoUpgradeSpeed10 = false

task.spawn(function()
    while task.wait(0.1) do
        if _G.AutoUpgradeSpeed10 then
            pcall(function()
                UpgradeSpeedRemote:InvokeServer(10)
            end)
        end
    end
end)

MiscSection:Toggle({
    Name = "Auto Upgrade Speed +10",
    Default = false,
    Callback = function(state)
        _G.AutoUpgradeSpeed10 = state
        Window:Notify({
            Title = "Auto Upgrade",
            Description = state and "Auto Speed +10 activated!" or "Auto Speed +10 stopped.",
            Variant = state and "success" or "error",
            Lifetime = 3
        })
    end
})

MiscSection:Button({
    Name = "Upgrade Speed +1 (One-time)",
    Callback = function()
        pcall(function()
            UpgradeSpeedRemote:InvokeServer(1)
        end)
        Window:Notify({
            Title = "Upgrade",
            Description = "Speed +1 requested!",
            Variant = "info"
        })
    end
})

MiscSection:Button({
    Name = "Upgrade Speed +10 (One-time)",
    Callback = function()
        pcall(function()
            UpgradeSpeedRemote:InvokeServer(10)  
        end)
        Window:Notify({
            Title = "Upgrade",
            Description = "Speed +10 requested!",
            Variant = "info"
        })
    end
})


local CarrySection = MiscTab:Section({
    Name = "Upgrade Carry",
    Side = "Left",
    Collapsible = true,
    DefaultCollapsed = false
})

CarrySection:Button({
    Name = "Upgrade Carry (One-time)",
    Callback = function()
        pcall(function()
            game:GetService("ReplicatedStorage")
                :WaitForChild("RemoteFunctions")
                :WaitForChild("UpgradeCarry")
                :InvokeServer()
        end)
        Window:Notify({
            Title = "Upgrade Carry",
            Description = "Carry upgrade requested!",
            Variant = "success"
        })
    end
})

-- _G.AutoUpgradeCarry = false
-- task.spawn(function()
--     while task.wait(0.5) do
--         if _G.AutoUpgradeCarry then
--             pcall(function()
--                 ReplicatedStorage.RemoteFunctions.UpgradeCarry:InvokeServer()
--             end)
--         end
--     end
-- end)
-- CarrySection:Toggle({
--     Name = "Auto Upgrade Carry",
--     Default = false,
--     Callback = function(state)
--         _G.AutoUpgradeCarry = state
--     end
-- })


local function createGui(parent)
    local screenGui = Instance.new("ScreenGui", parent)
    screenGui.Name = "Ajomok UI"
    screenGui.ResetOnSpawn = false
    screenGui.DisplayOrder = 999999
    screenGui.IgnoreGuiInset = true
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local UserInputService = game:GetService("UserInputService")

    local Frame1 = Instance.new("Frame", screenGui)
    Frame1.AnchorPoint = Vector2.new(0, 0.5)
    Frame1.Name = "main"
    Frame1.Position = UDim2.new(0, 5, 0.5, 0)
    Frame1.Size = UDim2.new(0, 55, 0, 55)
    Frame1.BackgroundColor3 = Color3.new(25, 15, 40)
    Frame1.BorderSizePixel = 0
    Frame1.Active = true
    Frame1.Draggable = false
    
    local dragging = false
    local dragInput
    local dragStart
    local startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        Frame1.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
    
    Frame1.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Frame1.Position
            
            local connection = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    connection:Disconnect()
                end
            end)
        end
    end)
    
    Frame1.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)
    
    local UIGradient2 = Instance.new("UIGradient", Frame1)
    UIGradient2.Rotation = 50
    UIGradient2.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.new(0.66, 0, 1)),
        ColorSequenceKeypoint.new(0.5, Color3.new(0.12, 0.06, 0.2)),
        ColorSequenceKeypoint.new(1, Color3.new(0.66, 0, 1))
    }
    
    local UICorner3 = Instance.new("UICorner", Frame1)
    UICorner3.CornerRadius = UDim.new(0, 15)
    
    local UIStroke4 = Instance.new("UIStroke", Frame1)
    UIStroke4.Color = Color3.new(0.8, 0, 1)
    UIStroke4.Thickness = 2
    
    local UIGradient5 = Instance.new("UIGradient", UIStroke4)
    UIGradient5.Rotation = 90
    UIGradient5.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.new(0.9, 0, 1)),
        ColorSequenceKeypoint.new(1, Color3.new(0.35, 0, 0.5))
    }
    
    local ImageLabel6 = Instance.new("ImageLabel", Frame1)
    ImageLabel6.Size = UDim2.new(0, 35, 0, 35)
    ImageLabel6.Image = "rbxassetid://77194008928196"
    ImageLabel6.BackgroundTransparency = 1
    ImageLabel6.Position = UDim2.new(0.181818187, 0, 0.181818187, 0)
    ImageLabel6.BorderColor3 = Color3.new(0, 0, 0)
    ImageLabel6.Name = "imege"
    ImageLabel6.BorderSizePixel = 0
    ImageLabel6.BackgroundColor3 = Color3.new(1, 1, 1)
    
    local TextButton7 = Instance.new("TextButton", Frame1)
    TextButton7.TextColor3 = Color3.new(0, 0, 0)
    TextButton7.BorderColor3 = Color3.new(0, 0, 0)
    TextButton7.TextTransparency = 1
    TextButton7.Font = Enum.Font.SourceSans
    TextButton7.Name = "togl"
    TextButton7.TextSize = 14
    TextButton7.Size = UDim2.new(0, 55, 0, 50)
    TextButton7.BackgroundTransparency = 1
    TextButton7.BorderSizePixel = 0
    TextButton7.BackgroundColor3 = Color3.new(1, 1, 1)
    TextButton7.ZIndex = 9999999
    
    TextButton7.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Frame1.Position
            
            local connection = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    connection:Disconnect()
                end
            end)
        end
    end)
    
    TextButton7.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)
    
    return screenGui
end

local interface = {}

function interface:is_already_executed()
    if game.CoreGui:FindFirstChild("Ajomok UI") then
        game.CoreGui:FindFirstChild("Ajomok UI"):Destroy()
    end
end

function interface:toggle_position()
    local edan = game.CoreGui:FindFirstChild("Ajomok UI")
    return edan
end

function interface:initial_interface(callback)
    interface:is_already_executed()  -- destroy kalau sudah ada
    
    local ui = createGui(game.CoreGui)
    if callback then
        ui.main.togl.MouseButton1Click:Connect(function()
            pcall(callback)
        end)
    end
    
    return ui
end

interface:initial_interface(function()
    if Window and Window.SetState then
        Window:SetState(not Window:GetState())
    else
        local winFrame = game.CoreGui:FindFirstChildWhichIsA("ScreenGui", true):FindFirstChild("Window", true) -- adjust name kalau perlu
        if winFrame then
            winFrame.Visible = not winFrame.Visible
        end
    end
end)


MainTab:Select()

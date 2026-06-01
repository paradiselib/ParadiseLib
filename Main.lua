local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/"
local DEFAULT_PALETTE = "Slate"
local DEFAULT_RADIUS = 14

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local DebrisService = game:GetService("Debris")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer

local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()

ThemeManager:SetLibrary(Library)
ThemeManager:SetFolder("HeavenlyyySettings")

ThemeManager:SetDefaultTheme({
    FontColor = "#F4F7FB",
    MainColor = "#161A20",
    AccentColor = "#89BCE8",
    BackgroundColor = "#101319",
    OutlineColor = "#1A2028",
    FontFace = Enum.Font.Gotham,
})

Library.ShowCustomCursor = false
Library.CornerRadius = DEFAULT_RADIUS

local function applyPalette(mode)
    if mode == "Slate" then
        Library.Scheme.BackgroundColor = Color3.fromRGB(16, 19, 25)
        Library.Scheme.MainColor = Color3.fromRGB(22, 26, 33)
        Library.Scheme.OutlineColor = Color3.fromRGB(27, 33, 42)
        Library.Scheme.AccentColor = Color3.fromRGB(137, 188, 232)
    elseif mode == "Smoke" then
        Library.Scheme.BackgroundColor = Color3.fromRGB(18, 20, 24)
        Library.Scheme.MainColor = Color3.fromRGB(27, 30, 36)
        Library.Scheme.OutlineColor = Color3.fromRGB(32, 36, 43)
        Library.Scheme.AccentColor = Color3.fromRGB(158, 194, 223)
    elseif mode == "Night" then
        Library.Scheme.BackgroundColor = Color3.fromRGB(13, 15, 20)
        Library.Scheme.MainColor = Color3.fromRGB(18, 21, 28)
        Library.Scheme.OutlineColor = Color3.fromRGB(24, 29, 37)
        Library.Scheme.AccentColor = Color3.fromRGB(113, 163, 214)
    end

    Library:UpdateColorsUsingRegistry()
end

local function hideTopHandle()
    task.wait(0.3)

    if not Library.ScreenGui then
        return
    end

    local topMost
    for _, descendant in ipairs(Library.ScreenGui:GetDescendants()) do
        if descendant:IsA("ImageButton") then
            local size = descendant.AbsoluteSize
            local pos = descendant.AbsolutePosition

            local looksLikeHandle = size.X <= 28
                and size.Y <= 28
                and pos.Y <= 180
                and pos.X >= 900

            if looksLikeHandle then
                topMost = descendant
                break
            end
        end
    end

    if topMost then
        topMost.Visible = false
        topMost.Active = false
    end
end

local Window = Library:CreateWindow({
    Title = "Heavenlyyy",
    Footer = "by cidkagenou",
    Center = true,
    AutoShow = true,
    Resizable = false,
    ShowCustomCursor = false,
    CornerRadius = DEFAULT_RADIUS,
    Font = Enum.Font.Gotham,
    NotifySide = "Right",
    SearchbarSize = UDim2.fromScale(0.92, 1),
})

Library.ToggleKeybind = Enum.KeyCode.LeftAlt

task.spawn(function()
    task.wait(0.3)
    if Library.ScreenGui then
        for _, descendant in ipairs(Library.ScreenGui:GetDescendants()) do
            if descendant:IsA("ImageLabel") and descendant.Name == "Icon" then
                descendant.Visible = false
            end
            if descendant:IsA("TextLabel") and descendant.Name == "Title" then
                descendant.TextXAlignment = Enum.TextXAlignment.Left
            end
        end
    end
end)

local Tabs = {
    Main = Window:AddTab("Main", "swords"),
    Player = Window:AddTab("Player", "user"),
}

local MainBox = Tabs.Main:AddLeftGroupbox("Main Features")
local GrabBox = Tabs.Main:AddRightGroupbox("Grab Features")

local MovementBox = Tabs.Player:AddLeftGroupbox("Movement")
local TeleportBox = Tabs.Player:AddRightGroupbox("Teleport")
local ESPBox = Tabs.Player:AddLeftGroupbox("ESP")
local MiscBox = Tabs.Player:AddRightGroupbox("Misc")

local ESPState = {
    Enabled = false,
    ShowName = true,
    ShowDistance = true,
    ShowHealth = true,
    ESPObjects = {},
}

local function createESP(player)
    if player == LocalPlayer then return end
    
    local espFolder = Instance.new("Folder")
    espFolder.Name = "ESP_" .. player.Name
    espFolder.Parent = game.CoreGui
    
    local function updateESP()
        if not ESPState.Enabled then return end
        
        local character = player.Character
        if not character then return end
        
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not rootPart then return end
        
        local highlight = espFolder:FindFirstChild("Highlight")
        if not highlight then
            highlight = Instance.new("Highlight")
            highlight.Name = "Highlight"
            highlight.Adornee = character
            highlight.FillColor = Color3.fromRGB(255, 0, 0)
            highlight.FillTransparency = 0.5
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.OutlineTransparency = 0
            highlight.Parent = espFolder
        end
        
        local billboardGui = espFolder:FindFirstChild("BillboardGui")
        if not billboardGui then
            billboardGui = Instance.new("BillboardGui")
            billboardGui.Name = "BillboardGui"
            billboardGui.Adornee = rootPart
            billboardGui.Size = UDim2.new(0, 200, 0, 50)
            billboardGui.StudsOffset = Vector3.new(0, 3, 0)
            billboardGui.AlwaysOnTop = true
            billboardGui.Parent = espFolder
            
            local textLabel = Instance.new("TextLabel")
            textLabel.Name = "TextLabel"
            textLabel.Size = UDim2.new(1, 0, 1, 0)
            textLabel.BackgroundTransparency = 1
            textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            textLabel.TextStrokeTransparency = 0
            textLabel.TextSize = 14
            textLabel.Font = Enum.Font.GothamBold
            textLabel.Parent = billboardGui
        end
        
        local textLabel = billboardGui:FindFirstChild("TextLabel")
        if textLabel and ESPState.Enabled then
            local text = ""
            
            if ESPState.ShowName then
                text = player.Name
            end
            
            if ESPState.ShowDistance then
                local myChar = LocalPlayer.Character
                local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
                if myRoot then
                    local distance = math.floor((myRoot.Position - rootPart.Position).Magnitude)
                    text = text .. "\n[" .. distance .. " studs]"
                end
            end
            
            if ESPState.ShowHealth and humanoid then
                text = text .. "\n[" .. math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth) .. " HP]"
            end
            
            textLabel.Text = text
        end
    end
    
    local connection = RunService.RenderStepped:Connect(updateESP)
    
    ESPState.ESPObjects[player.Name] = {
        Folder = espFolder,
        Connection = connection,
        UpdateFunction = updateESP
    }
    
    player.CharacterAdded:Connect(function()
        task.wait(0.5)
        if ESPState.Enabled then
            updateESP()
        end
    end)
end

local function removeESP(player)
    local espData = ESPState.ESPObjects[player.Name]
    if espData then
        if espData.Connection then
            espData.Connection:Disconnect()
        end
        if espData.Folder then
            espData.Folder:Destroy()
        end
        ESPState.ESPObjects[player.Name] = nil
    end
end

ESPBox:AddToggle("ESPToggle", {
    Text = "Enable ESP",
    Default = false,
    Callback = function(value)
        ESPState.Enabled = value
        
        if value then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    createESP(player)
                end
            end
            
            Players.PlayerAdded:Connect(function(player)
                if ESPState.Enabled and player ~= LocalPlayer then
                    task.wait(1)
                    createESP(player)
                end
            end)
            
            Players.PlayerRemoving:Connect(function(player)
                removeESP(player)
            end)
        else
            for playerName, espData in pairs(ESPState.ESPObjects) do
                if espData.Connection then
                    espData.Connection:Disconnect()
                end
                if espData.Folder then
                    espData.Folder:Destroy()
                end
            end
            ESPState.ESPObjects = {}
        end
    end,
})

ESPBox:AddToggle("ShowNameToggle", {
    Text = "Show Name",
    Default = true,
    Callback = function(value)
        ESPState.ShowName = value
    end,
})

ESPBox:AddToggle("ShowDistanceToggle", {
    Text = "Show Distance",
    Default = true,
    Callback = function(value)
        ESPState.ShowDistance = value
    end,
})

ESPBox:AddToggle("ShowHealthToggle", {
    Text = "Show Health",
    Default = true,
    Callback = function(value)
        ESPState.ShowHealth = value
    end,
})

local SpinnerState = {
    Enabled = false,
    Speed = 50,
    BodyAngularVelocity = nil,
}

MiscBox:AddToggle("SpinnerToggle", {
    Text = "Spinner",
    Default = false,
    Callback = function(value)
        SpinnerState.Enabled = value
        
        if value then
            local character = LocalPlayer.Character
            if character then
                local rootPart = character:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    SpinnerState.BodyAngularVelocity = Instance.new("BodyAngularVelocity")
                    SpinnerState.BodyAngularVelocity.MaxTorque = Vector3.new(0, 9e9, 0)
                    SpinnerState.BodyAngularVelocity.AngularVelocity = Vector3.new(0, SpinnerState.Speed, 0)
                    SpinnerState.BodyAngularVelocity.Parent = rootPart
                end
            end
        else
            if SpinnerState.BodyAngularVelocity then
                SpinnerState.BodyAngularVelocity:Destroy()
                SpinnerState.BodyAngularVelocity = nil
            end
        end
    end,
})

MiscBox:AddSlider("SpinSpeedSlider", {
    Text = "Spin Speed",
    Default = 50,
    Min = 10,
    Max = 200,
    Rounding = 1,
    Callback = function(value)
        SpinnerState.Speed = value
        if SpinnerState.BodyAngularVelocity then
            SpinnerState.BodyAngularVelocity.AngularVelocity = Vector3.new(0, value, 0)
        end
    end,
})

MiscBox:AddToggle("AntiLagToggle", {
    Text = "Anti Lag",
    Default = false,
    Callback = function(value)
        local scripts = LocalPlayer:FindFirstChild("PlayerScripts")
        local moveScript = scripts and scripts:FindFirstChild("CharacterAndBeamMove")
        if moveScript then
            moveScript.Disabled = value
            Library:Notify({
                Title = "Anti Lag",
                Content = value and "Disabled grab animations" or "Enabled grab animations",
                Duration = 2
            })
        end
    end,
})

MiscBox:AddButton({
    Text = "Respawn",
    Func = function()
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.Health = 0
                Library:Notify({
                    Title = "Respawn",
                    Content = "Respawning...",
                    Duration = 2
                })
            end
        end
    end,
})

MiscBox:AddButton({
    Text = "Rejoin Server",
    Func = function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end,
})

MiscBox:AddButton({
    Text = "Server Hop",
    Func = function()
        local TeleportService = game:GetService("TeleportService")
        local HttpService = game:GetService("HttpService")
        
        local success, result = pcall(function()
            local servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
            
            for _, server in ipairs(servers.data) do
                if server.id ~= game.JobId and server.playing < server.maxPlayers then
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, LocalPlayer)
                    return
                end
            end
        end)
        
        if not success then
            Library:Notify({
                Title = "Server Hop",
                Content = "Failed to find another server",
                Duration = 2
            })
        end
    end,
})

local ShaderState = {
    Enabled = false,
    OriginalSettings = {},
    AddedEffects = {},
}

MiscBox:AddToggle("ShaderToggle", {
    Text = "Shaders",
    Default = false,
    Callback = function(value)
        ShaderState.Enabled = value
        local Lighting = game:GetService("Lighting")
        
        if value then
            ShaderState.OriginalSettings = {
                Brightness = Lighting.Brightness,
                ColorShift_Bottom = Lighting.ColorShift_Bottom,
                ColorShift_Top = Lighting.ColorShift_Top,
                OutdoorAmbient = Lighting.OutdoorAmbient,
                ClockTime = Lighting.ClockTime,
                FogColor = Lighting.FogColor,
                FogEnd = Lighting.FogEnd,
                FogStart = Lighting.FogStart,
                ExposureCompensation = Lighting.ExposureCompensation,
                ShadowSoftness = Lighting.ShadowSoftness,
                Ambient = Lighting.Ambient,
            }
            
            ShaderState.AddedEffects = {}
            
            Lighting.Brightness = 2.14
            Lighting.ColorShift_Bottom = Color3.fromRGB(11, 0, 20)
            Lighting.ColorShift_Top = Color3.fromRGB(240, 127, 14)
            Lighting.OutdoorAmbient = Color3.fromRGB(34, 0, 49)
            Lighting.ClockTime = 6.7
            Lighting.FogColor = Color3.fromRGB(94, 76, 106)
            Lighting.FogEnd = 1000
            Lighting.FogStart = 0
            Lighting.ExposureCompensation = 0.24
            Lighting.ShadowSoftness = 0
            Lighting.Ambient = Color3.fromRGB(59, 33, 27)
            
            local Bloom = Instance.new("BloomEffect")
            Bloom.Intensity = 0.1
            Bloom.Threshold = 0
            Bloom.Size = 100
            Bloom.Parent = Lighting
            table.insert(ShaderState.AddedEffects, Bloom)
            
            local Blur = Instance.new("BlurEffect")
            Blur.Size = 2
            Blur.Parent = Lighting
            table.insert(ShaderState.AddedEffects, Blur)
            
            local ColorCorrection = Instance.new("ColorCorrectionEffect")
            ColorCorrection.Name = "WarmTint"
            ColorCorrection.Saturation = 0.05
            ColorCorrection.TintColor = Color3.fromRGB(255, 224, 219)
            ColorCorrection.Parent = Lighting
            table.insert(ShaderState.AddedEffects, ColorCorrection)
            
            local SunRays = Instance.new("SunRaysEffect")
            SunRays.Intensity = 0.05
            SunRays.Parent = Lighting
            table.insert(ShaderState.AddedEffects, SunRays)
            
            local Tropic = Instance.new("Sky")
            Tropic.Name = "Tropic"
            Tropic.SkyboxUp = "http://www.roblox.com/asset/?id=169210149"
            Tropic.SkyboxLf = "http://www.roblox.com/asset/?id=169210133"
            Tropic.SkyboxBk = "http://www.roblox.com/asset/?id=169210090"
            Tropic.SkyboxFt = "http://www.roblox.com/asset/?id=169210121"
            Tropic.StarCount = 100
            Tropic.SkyboxDn = "http://www.roblox.com/asset/?id=169210108"
            Tropic.SkyboxRt = "http://www.roblox.com/asset/?id=169210143"
            Tropic.Parent = Lighting
            table.insert(ShaderState.AddedEffects, Tropic)
            
            Library:Notify({
                Title = "Shaders",
                Content = "Tropic shaders enabled!",
                Duration = 2
            })
        else
            for _, effect in ipairs(ShaderState.AddedEffects) do
                if effect and effect.Parent then
                    effect:Destroy()
                end
            end
            ShaderState.AddedEffects = {}
            
            if ShaderState.OriginalSettings.Brightness then
                Lighting.Brightness = ShaderState.OriginalSettings.Brightness
                Lighting.ColorShift_Bottom = ShaderState.OriginalSettings.ColorShift_Bottom
                Lighting.ColorShift_Top = ShaderState.OriginalSettings.ColorShift_Top
                Lighting.OutdoorAmbient = ShaderState.OriginalSettings.OutdoorAmbient
                Lighting.ClockTime = ShaderState.OriginalSettings.ClockTime
                Lighting.FogColor = ShaderState.OriginalSettings.FogColor
                Lighting.FogEnd = ShaderState.OriginalSettings.FogEnd
                Lighting.FogStart = ShaderState.OriginalSettings.FogStart
                Lighting.ExposureCompensation = ShaderState.OriginalSettings.ExposureCompensation
                Lighting.ShadowSoftness = ShaderState.OriginalSettings.ShadowSoftness
                Lighting.Ambient = ShaderState.OriginalSettings.Ambient
            end
            
            Library:Notify({
                Title = "Shaders",
                Content = "Shaders disabled",
                Duration = 2
            })
        end
    end,
})

local StrengthState = {
    Enabled = false,
    Strength = 800,
    GrabbedPart = nil,
}

local AntiGrabState = {
    Enabled = false,
    Connection = nil,
}

local AntiVelocityState = {
    Enabled = false,
    Connection = nil,
}

local DeathGrabState = {
    Enabled = false,
}

local AntiBurnState = {
    Enabled = false,
}

local AntiExplosionState = {
    Enabled = false,
}

local MasslessGrabState = {
    Enabled = false,
}

local NoclipGrabState = {
    Enabled = false,
}

local PlayerState = {
    WalkSpeed = false,
    WalkSpeedValue = 5,
    JumpPower = false,
    JumpPowerValue = 100,
    OriginalJumpPower = nil,
    OriginalJumpHeight = nil,
    InfiniteJump = false,
    InfiniteJumpConnection = nil,
    Noclip = false,
    NoclipConnection = nil,
    TeleportToPlayer = false,
    SelectedPlayer = nil,
}

MainBox:AddToggle("SuperStrengthToggle", {
    Text = "Super Strength",
    Default = false,
    Callback = function(value)
        StrengthState.Enabled = value
    end,
})

MainBox:AddSlider("StrengthSlider", {
    Text = "Strength",
    Default = 800,
    Min = 400,
    Max = 10000,
    Rounding = 0,
    Callback = function(value)
        StrengthState.Strength = value
    end,
})

MainBox:AddToggle("AntiGrabToggle", {
    Text = "Anti Grab",
    Default = false,
    Callback = function(value)
        AntiGrabState.Enabled = value
    end,
})

MainBox:AddToggle("AntiVelocityToggle", {
    Text = "Anti Velocity",
    Default = false,
    Callback = function(value)
        AntiVelocityState.Enabled = value
        
        if value then
            local function protectCharacter(character)
                if not character then return end
                
                for _, part in ipairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        for _, child in ipairs(part:GetChildren()) do
                            if child:IsA("BodyVelocity") or child:IsA("BodyPosition") or child:IsA("BodyGyro") then
                                child:Destroy()
                            end
                        end
                    end
                end
                
                character.DescendantAdded:Connect(function(descendant)
                    if AntiVelocityState.Enabled then
                        if descendant:IsA("BodyVelocity") or descendant:IsA("BodyPosition") or descendant:IsA("BodyGyro") then
                            task.wait()
                            if descendant.Parent and AntiVelocityState.Enabled then
                                descendant:Destroy()
                            end
                        end
                    end
                end)
            end
            
            if LocalPlayer.Character then
                protectCharacter(LocalPlayer.Character)
            end
            
            LocalPlayer.CharacterAdded:Connect(function(character)
                if AntiVelocityState.Enabled then
                    protectCharacter(character)
                end
            end)
        end
    end,
})

MainBox:AddToggle("AntiBurnToggle", {
    Text = "Anti Burn",
    Default = false,
    Callback = function(value)
        AntiBurnState.Enabled = value
    end,
})

MainBox:AddToggle("AntiExplosionToggle", {
    Text = "Anti Explosion",
    Default = false,
    Callback = function(value)
        AntiExplosionState.Enabled = value
    end,
})

MainBox:AddToggle("AutoStruggleToggle", {
    Text = "Auto Struggle",
    Default = false,
    Callback = function(value)
        if value then
            task.spawn(function()
                local CharacterEvents = ReplicatedStorage:WaitForChild("CharacterEvents")
                local StruggleEvent = CharacterEvents:WaitForChild("Struggle")
                
                while MainBox and value do
                    local grabParts = Workspace:FindFirstChild("GrabParts")
                    if grabParts and grabParts:FindFirstChild("GrabPart") then
                        local weld = grabParts.GrabPart:FindFirstChild("WeldConstraint")
                        if weld and weld.Part1 then
                            local char = weld.Part1.Parent
                            if char == LocalPlayer.Character then
                                StruggleEvent:FireServer()
                            end
                        end
                    end
                    task.wait(0.1)
                end
            end)
        end
    end,
})

local FullbrightState = {
    Enabled = false,
    OriginalBrightness = nil,
    OriginalAmbient = nil,
    OriginalOutdoorAmbient = nil,
}

MainBox:AddToggle("FullbrightToggle", {
    Text = "Fullbright",
    Default = false,
    Callback = function(value)
        FullbrightState.Enabled = value
        local Lighting = game:GetService("Lighting")
        
        if value then
            FullbrightState.OriginalBrightness = Lighting.Brightness
            FullbrightState.OriginalAmbient = Lighting.Ambient
            FullbrightState.OriginalOutdoorAmbient = Lighting.OutdoorAmbient
            
            Lighting.Brightness = 2
            Lighting.Ambient = Color3.new(1, 1, 1)
            Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        else
            if FullbrightState.OriginalBrightness then
                Lighting.Brightness = FullbrightState.OriginalBrightness
                Lighting.Ambient = FullbrightState.OriginalAmbient
                Lighting.OutdoorAmbient = FullbrightState.OriginalOutdoorAmbient
            end
        end
    end,
})

local AttackAuraState = {
    Enabled = false,
    Radius = 20,
    Connection = nil,
}

MainBox:AddToggle("AttackAuraToggle", {
    Text = "Attack Aura",
    Default = false,
    Callback = function(value)
        AttackAuraState.Enabled = value
        
        if value then
            AttackAuraState.Connection = RunService.Heartbeat:Connect(function()
                if not AttackAuraState.Enabled then return end
                
                local character = LocalPlayer.Character
                if not character then return end
                
                local rootPart = character:FindFirstChild("HumanoidRootPart")
                if not rootPart then return end
                
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
                        if targetRoot then
                            local distance = (rootPart.Position - targetRoot.Position).Magnitude
                            
                            if distance <= AttackAuraState.Radius then
                                local GrabEvents = ReplicatedStorage:FindFirstChild("GrabEvents")
                                if GrabEvents then
                                    local SetNetworkOwner = GrabEvents:FindFirstChild("SetNetworkOwner")
                                    if SetNetworkOwner then
                                        SetNetworkOwner:FireServer(targetRoot, targetRoot.CFrame)
                                        
                                        task.wait(0.05)
                                        
                                        local velocity = Instance.new("BodyVelocity")
                                        velocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                                        velocity.Velocity = Vector3.new(
                                            math.random(-500, 500),
                                            math.random(5000, 10000),
                                            math.random(-500, 500)
                                        )
                                        velocity.Parent = targetRoot
                                        DebrisService:AddItem(velocity, 0.5)
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        else
            if AttackAuraState.Connection then
                AttackAuraState.Connection:Disconnect()
                AttackAuraState.Connection = nil
            end
        end
    end,
})

MainBox:AddSlider("AttackAuraRadius", {
    Text = "Aura Radius",
    Default = 20,
    Min = 5,
    Max = 50,
    Rounding = 1,
    Callback = function(value)
        AttackAuraState.Radius = value
    end,
})

GrabBox:AddToggle("MasslessGrabToggle", {
    Text = "Massless Grab",
    Default = false,
    Callback = function(value)
        MasslessGrabState.Enabled = value
    end,
})

GrabBox:AddToggle("NoclipGrabToggle", {
    Text = "Noclip Grab",
    Default = false,
    Callback = function(value)
        NoclipGrabState.Enabled = value
    end,
})

local FlingState = {
    Enabled = false,
}

GrabBox:AddToggle("FlingGrabToggle", {
    Text = "Fling Grab",
    Default = false,
    Callback = function(value)
        FlingState.Enabled = value
        
        if value then
            task.spawn(function()
                while FlingState.Enabled do
                    local grabParts = Workspace:FindFirstChild("GrabParts")
                    if grabParts and grabParts:FindFirstChild("GrabPart") then
                        local weld = grabParts.GrabPart:FindFirstChild("WeldConstraint")
                        if weld and weld.Part1 then
                            local char = weld.Part1.Parent
                            if char and char:FindFirstChild("HumanoidRootPart") then
                                local hrp = char.HumanoidRootPart
                                local velocity = Instance.new("BodyVelocity")
                                velocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                                velocity.Velocity = Vector3.new(math.random(-100, 100), math.random(100, 200), math.random(-100, 100))
                                velocity.Parent = hrp
                                DebrisService:AddItem(velocity, 0.1)
                            end
                        end
                    end
                    task.wait(0.1)
                end
            end)
        end
    end,
})

local BringPlayerState = {
    Enabled = false,
}

GrabBox:AddToggle("BringPlayerToggle", {
    Text = "Bring Grabbed Player",
    Default = false,
    Callback = function(value)
        BringPlayerState.Enabled = value
        
        if value then
            task.spawn(function()
                while BringPlayerState.Enabled do
                    local grabParts = Workspace:FindFirstChild("GrabParts")
                    if grabParts and grabParts:FindFirstChild("GrabPart") then
                        local weld = grabParts.GrabPart:FindFirstChild("WeldConstraint")
                        if weld and weld.Part1 then
                            local char = weld.Part1.Parent
                            local myChar = LocalPlayer.Character
                            if char and myChar and char:FindFirstChild("HumanoidRootPart") and myChar:FindFirstChild("HumanoidRootPart") then
                                char.HumanoidRootPart.CFrame = myChar.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
                            end
                        end
                    end
                    task.wait()
                end
            end)
        end
    end,
})

MovementBox:AddToggle("WalkSpeedToggle", {
    Text = "Walk Speed",
    Default = false,
    Callback = function(value)
        PlayerState.WalkSpeed = value
        if value then
            task.spawn(function()
                while PlayerState.WalkSpeed do
                    local character = LocalPlayer.Character
                    if character then
                        local humanoid = character:FindFirstChildOfClass("Humanoid")
                        local rootPart = character:FindFirstChild("HumanoidRootPart")
                        if humanoid and rootPart then
                            rootPart.CFrame = rootPart.CFrame + humanoid.MoveDirection * (16 * PlayerState.WalkSpeedValue / 10)
                        end
                    end
                    task.wait()
                end
            end)
        end
    end,
})

MovementBox:AddSlider("WalkSpeedSlider", {
    Text = "Speed",
    Default = 5,
    Min = 1,
    Max = 20,
    Rounding = 1,
    Callback = function(value)
        PlayerState.WalkSpeedValue = value
    end,
})

MovementBox:AddToggle("JumpPowerToggle", {
    Text = "Jump Power",
    Default = false,
    Callback = function(value)
        PlayerState.JumpPower = value
        
        local character = LocalPlayer.Character
        if not character then return end
        
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end
        
        if value then
            if humanoid.UseJumpPower then
                PlayerState.OriginalJumpPower = humanoid.JumpPower
            else
                PlayerState.OriginalJumpHeight = humanoid.JumpHeight
            end
            
            task.spawn(function()
                while PlayerState.JumpPower do
                    local char = LocalPlayer.Character
                    if char then
                        local hum = char:FindFirstChildOfClass("Humanoid")
                        if hum then
                            if hum.UseJumpPower then
                                hum.JumpPower = PlayerState.JumpPowerValue
                            else
                                hum.JumpHeight = math.clamp(PlayerState.JumpPowerValue / 10, 7.2, 50)
                            end
                        end
                    end
                    task.wait()
                end
            end)
        else
            if humanoid.UseJumpPower and PlayerState.OriginalJumpPower then
                humanoid.JumpPower = PlayerState.OriginalJumpPower
            elseif not humanoid.UseJumpPower and PlayerState.OriginalJumpHeight then
                humanoid.JumpHeight = PlayerState.OriginalJumpHeight
            end
        end
    end,
})

MovementBox:AddSlider("JumpPowerSlider", {
    Text = "Power",
    Default = 100,
    Min = 50,
    Max = 500,
    Rounding = 10,
    Callback = function(value)
        PlayerState.JumpPowerValue = value
    end,
})

MovementBox:AddToggle("InfiniteJumpToggle", {
    Text = "Infinite Jump",
    Default = false,
    Callback = function(value)
        PlayerState.InfiniteJump = value
        if value then
            PlayerState.InfiniteJumpConnection = UserInputService.JumpRequest:Connect(function()
                if PlayerState.InfiniteJump then
                    local character = LocalPlayer.Character
                    if character then
                        local humanoid = character:FindFirstChildOfClass("Humanoid")
                        if humanoid then
                            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                        end
                    end
                end
            end)
        else
            if PlayerState.InfiniteJumpConnection then
                PlayerState.InfiniteJumpConnection:Disconnect()
                PlayerState.InfiniteJumpConnection = nil
            end
        end
    end,
})

MovementBox:AddToggle("NoclipToggle", {
    Text = "Noclip",
    Default = false,
    Callback = function(value)
        PlayerState.Noclip = value
        if value then
            PlayerState.NoclipConnection = RunService.Stepped:Connect(function()
                if PlayerState.Noclip then
                    local character = LocalPlayer.Character
                    if character then
                        for _, part in ipairs(character:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = false
                            end
                        end
                    end
                end
            end)
        else
            if PlayerState.NoclipConnection then
                PlayerState.NoclipConnection:Disconnect()
                PlayerState.NoclipConnection = nil
            end
        end
    end,
})

MovementBox:AddToggle("ThirdPersonToggle", {
    Text = "Third Person",
    Default = false,
    Callback = function(value)
        local player = LocalPlayer
        if value then
            player.CameraMaxZoomDistance = 50
            player.CameraMinZoomDistance = 10
            player.CameraMode = Enum.CameraMode.Classic
        else
            player.CameraMaxZoomDistance = 0.5
            player.CameraMinZoomDistance = 0.5
            player.CameraMode = Enum.CameraMode.LockFirstPerson
        end
    end,
})

MovementBox:AddSlider("ThirdPersonDistance", {
    Text = "Camera Distance",
    Default = 15,
    Min = 5,
    Max = 50,
    Rounding = 1,
    Callback = function(value)
        LocalPlayer.CameraMaxZoomDistance = value
        LocalPlayer.CameraMinZoomDistance = value
    end,
})

local playerListOptions = {}
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        table.insert(playerListOptions, player.Name)
    end
end

local SelectPlayerDropdown = TeleportBox:AddDropdown("SelectPlayerDropdown", {
    Text = "Select Player",
    Values = playerListOptions,
    Default = 1,
    Multi = false,
    Callback = function(value)
        PlayerState.SelectedPlayer = value
    end,
})

Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        table.insert(playerListOptions, player.Name)
        SelectPlayerDropdown:SetValues(playerListOptions)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    for i, name in ipairs(playerListOptions) do
        if name == player.Name then
            table.remove(playerListOptions, i)
            break
        end
    end
    SelectPlayerDropdown:SetValues(playerListOptions)
end)

TeleportBox:AddButton({
    Text = "Teleport to Player",
    Func = function()
        if PlayerState.SelectedPlayer then
            local targetPlayer = Players:FindFirstChild(PlayerState.SelectedPlayer)
            if targetPlayer and targetPlayer.Character then
                local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                local myCharacter = LocalPlayer.Character
                local myRoot = myCharacter and myCharacter:FindFirstChild("HumanoidRootPart")
                
                if targetRoot and myRoot then
                    myRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 3)
                    Library:Notify({
                        Title = "Teleport",
                        Content = "Teleported to " .. PlayerState.SelectedPlayer,
                        Duration = 2
                    })
                end
            end
        end
    end,
})

TeleportBox:AddToggle("LoopTeleportToggle", {
    Text = "Loop Teleport",
    Default = false,
    Callback = function(value)
        PlayerState.TeleportToPlayer = value
        if value then
            task.spawn(function()
                while PlayerState.TeleportToPlayer do
                    if PlayerState.SelectedPlayer then
                        local targetPlayer = Players:FindFirstChild(PlayerState.SelectedPlayer)
                        if targetPlayer and targetPlayer.Character then
                            local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                            local myCharacter = LocalPlayer.Character
                            local myRoot = myCharacter and myCharacter:FindFirstChild("HumanoidRootPart")
                            
                            if targetRoot and myRoot then
                                myRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 3)
                            end
                        end
                    end
                    task.wait(0.1)
                end
            end)
        end
    end,
})

TeleportBox:AddButton({
    Text = "Teleport to Spawn",
    Func = function()
        local myCharacter = LocalPlayer.Character
        local myRoot = myCharacter and myCharacter:FindFirstChild("HumanoidRootPart")
        local spawn = Workspace:FindFirstChild("SpawnLocation")
        
        if myRoot and spawn then
            myRoot.CFrame = spawn.CFrame * CFrame.new(0, 5, 0)
            Library:Notify({
                Title = "Teleport",
                Content = "Teleported to Spawn",
                Duration = 2
            })
        end
    end,
})

applyPalette(DEFAULT_PALETTE)
task.spawn(hideTopHandle)

local CharacterEvents = ReplicatedStorage:WaitForChild("CharacterEvents")
local StruggleEvent = CharacterEvents:WaitForChild("Struggle")

local pressedStrength = false

local isHeldValue = LocalPlayer:FindFirstChild("IsHeld") or LocalPlayer:WaitForChild("IsHeld")
local heldByPlayerName = nil

local GrabEvents = ReplicatedStorage:WaitForChild("GrabEvents")
local SetNetworkOwner = GrabEvents:WaitForChild("SetNetworkOwner")

local Map = Workspace:WaitForChild("Map")
local apagarfogo = Map:WaitForChild("Hole"):WaitForChild("PoisonBigHole"):WaitForChild("ExtinguishPart")
apagarfogo.Size = Vector3.new(0.5, 0.5, 0.5)
apagarfogo.Transparency = 1
if apagarfogo:FindFirstChild("Tex") then
    apagarfogo.Tex.Transparency = 1
end

local antiExplosionVelocity = nil
local explosionConnections = {}

local function setupCharacterProtection(character)
    local humanoid = character:WaitForChild("Humanoid")
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local torso = character:WaitForChild("Torso")
    
    if not antiExplosionVelocity then
        antiExplosionVelocity = Instance.new("BodyVelocity")
        antiExplosionVelocity.MaxForce = Vector3.new(0, 0, 0)
        antiExplosionVelocity.Velocity = Vector3.new()
        antiExplosionVelocity.Parent = torso
    end
    
    for _, conn in ipairs(explosionConnections) do
        conn:Disconnect()
    end
    table.clear(explosionConnections)
    
    local explosionConnection = Workspace.DescendantAdded:Connect(function(descendant)
        if AntiExplosionState.Enabled and descendant:IsA("Explosion") then
            task.spawn(function()
                local distance = (descendant.Position - humanoidRootPart.Position).Magnitude
                if distance < descendant.BlastRadius + 10 then
                    antiExplosionVelocity.MaxForce = Vector3.new(math.huge, -6200, math.huge)
                    antiExplosionVelocity.Velocity = Vector3.new(0, 0, 0)
                    
                    for i = 1, 10 do
                        if character and humanoidRootPart then
                            character.Head.CanCollide = false
                            if character:FindFirstChild("Right Arm") then
                                character["Right Arm"].CanCollide = false
                            end
                            if character:FindFirstChild("Right Leg") then
                                character["Right Leg"].CanCollide = false
                            end
                            if character:FindFirstChild("Left Arm") then
                                character["Left Arm"].CanCollide = false
                            end
                            if character:FindFirstChild("Left Leg") then
                                character["Left Leg"].CanCollide = false
                            end
                            character.Torso.CanCollide = false
                        end
                        task.wait(0.05)
                    end
                    
                    task.wait(0.5)
                    antiExplosionVelocity.MaxForce = Vector3.new(0, 0, 0)
                end
            end)
        end
    end)
    table.insert(explosionConnections, explosionConnection)
    
    local canBurnValue = humanoidRootPart:WaitForChild("FirePlayerPart"):WaitForChild("CanBurn")
    local ragdolledValue = humanoid:WaitForChild("Ragdolled")
    
    canBurnValue.Changed:Connect(function()
        if canBurnValue.Value and AntiBurnState.Enabled then
            task.spawn(function()
                while canBurnValue.Value and AntiBurnState.Enabled do
                    apagarfogo.CFrame = humanoidRootPart.FirePlayerPart.CFrame
                    task.wait(0.05)
                    apagarfogo.Position = Vector3.new(0, -100, 0)
                    task.wait(0.05)
                end
            end)
        end
    end)
    
    ragdolledValue.Changed:Connect(function(isRagdolled)
        if isRagdolled and AntiExplosionState.Enabled then
            antiExplosionVelocity.MaxForce = Vector3.new(math.huge, -6200, math.huge)
            
            while ragdolledValue.Value and AntiExplosionState.Enabled do
                if character:FindFirstChild("Head") then
                    character.Head.CanCollide = false
                    character.Head.Massless = true
                    character.Head.CFrame = humanoidRootPart.CFrame
                end
                if character:FindFirstChild("Right Arm") then
                    character["Right Arm"].CanCollide = false
                    character["Right Arm"].Massless = true
                    character["Right Arm"].CFrame = humanoidRootPart.CFrame
                end
                if character:FindFirstChild("Right Leg") then
                    character["Right Leg"].CanCollide = false
                    character["Right Leg"].Massless = true
                    character["Right Leg"].CFrame = humanoidRootPart.CFrame
                end
                if character:FindFirstChild("Left Arm") then
                    character["Left Arm"].CanCollide = false
                    character["Left Arm"].Massless = true
                    character["Left Arm"].CFrame = humanoidRootPart.CFrame
                end
                if character:FindFirstChild("Left Leg") then
                    character["Left Leg"].CanCollide = false
                    character["Left Leg"].Massless = true
                    character["Left Leg"].CFrame = humanoidRootPart.CFrame
                end
                if character:FindFirstChild("Torso") then
                    character.Torso.CanCollide = false
                end
                
                task.wait()
            end
            
            if character:FindFirstChild("Head") then character.Head.Massless = false end
            if character:FindFirstChild("Right Arm") then character["Right Arm"].Massless = false end
            if character:FindFirstChild("Right Leg") then character["Right Leg"].Massless = false end
            if character:FindFirstChild("Left Arm") then character["Left Arm"].Massless = false end
            if character:FindFirstChild("Left Leg") then character["Left Leg"].Massless = false end
        else
            antiExplosionVelocity.MaxForce = Vector3.new(0, 0, 0)
        end
    end)
end

if LocalPlayer.Character then
    setupCharacterProtection(LocalPlayer.Character)
end

LocalPlayer.CharacterAdded:Connect(function(character)
    antiExplosionVelocity = nil
    setupCharacterProtection(character)
end)

local function setupCharacterListener(character)
    character.DescendantAdded:Connect(function(descendant)
        if descendant.Name == "PartOwner" then
            heldByPlayerName = tostring(descendant.Value)
            
            if AntiGrabState.Enabled then
                local grabberPlayer = Players:FindFirstChild(heldByPlayerName)
                if grabberPlayer and grabberPlayer.Character then
                    local grabberRoot = grabberPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if grabberRoot then
                        SetNetworkOwner:FireServer(grabberRoot, grabberRoot.CFrame)
                        task.wait(0.1)
                        
                        local bodyVelocity = Instance.new("BodyVelocity")
                        bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                        bodyVelocity.Velocity = Vector3.new(0, 2000, 0)
                        bodyVelocity.Parent = grabberRoot
                        DebrisService:AddItem(bodyVelocity, 5)
                    end
                end
            end
        end
    end)
end

if LocalPlayer.Character then
    setupCharacterListener(LocalPlayer.Character)
end

LocalPlayer.CharacterAdded:Connect(function(character)
    setupCharacterListener(character)
end)

isHeldValue.Changed:Connect(function(isHeld)
    if isHeld == true and AntiGrabState.Enabled then
        local character = LocalPlayer.Character
        if not character then return end
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then return end
        
        if AntiGrabState.Connection then
            AntiGrabState.Connection:Disconnect()
        end
        
        AntiGrabState.Connection = RunService.Heartbeat:Connect(function()
            if isHeldValue.Value and AntiGrabState.Enabled then
                humanoidRootPart.Velocity = Vector3.new()
                humanoidRootPart.Anchored = true
                StruggleEvent:FireServer(LocalPlayer)
            else
                humanoidRootPart.Velocity = Vector3.new()
                humanoidRootPart.Anchored = false
                if AntiGrabState.Connection then
                    AntiGrabState.Connection:Disconnect()
                    AntiGrabState.Connection = nil
                end
            end
        end)
    end
end)

Workspace.ChildAdded:Connect(function(grabParts)
    if grabParts.Name == "GrabParts" then
        local grabbedPart = grabParts.GrabPart.WeldConstraint.Part1
        local superStrengthBodyVelocity = nil
        if grabbedPart then
            if StrengthState.Enabled then
                superStrengthBodyVelocity = Instance.new("BodyVelocity", grabbedPart)
                superStrengthBodyVelocity.MaxForce = Vector3.new(0, 0, 0)
                superStrengthBodyVelocity.Velocity = Vector3.new()
                superStrengthBodyVelocity.Name = "SuperStrength"
            end
            
            
            if MasslessGrabState.Enabled then
                task.spawn(function()
                    local dragPartAlignOrientation = grabParts.DragPart.AlignOrientation
                    local dragPartAlignPosition = grabParts.DragPart.AlignPosition
                    while MasslessGrabState.Enabled and grabParts.Parent do
                        dragPartAlignOrientation.MaxTorque = 1e46
                        dragPartAlignOrientation.Responsiveness = 20099
                        dragPartAlignPosition.MaxForce = 1e51
                        dragPartAlignPosition.Responsiveness = 20099
                        task.wait(0.245)
                    end
                    dragPartAlignOrientation.MaxTorque = 600000
                    dragPartAlignOrientation.Responsiveness = 30
                    dragPartAlignPosition.MaxForce = 60000
                    dragPartAlignPosition.Responsiveness = 40
                end)
            end
            
            if NoclipGrabState.Enabled and not grabbedPart.Anchored then
                task.spawn(function()
                    if grabbedPart.Parent and grabbedPart.Parent:IsA("Model") then
                        local descendants = grabbedPart.Parent:GetDescendants()
                        local humanoid = grabbedPart.Parent:FindFirstChildOfClass("Humanoid")
                        local pairsIteratorDescendants, index, descendantIndex = pairs(descendants)
                        local canCollideMap = {}
                        while true do
                            local descendant
                            descendantIndex, descendant = pairsIteratorDescendants(index, descendantIndex)
                            if descendantIndex == nil then
                                break
                            end
                            if descendant:IsA("BasePart") or (descendant:IsA("Part") or descendant:IsA("MeshPart")) then
                                canCollideMap[descendant] = descendant.CanCollide
                            end
                        end
                        while grabParts.Parent do
                            local pairsIteratorDescendants2, descendantIndex2, descendantIndex3 = pairs(descendants)
                            while true do
                                local descendantPart
                                descendantIndex3, descendantPart = pairsIteratorDescendants2(descendantIndex2, descendantIndex3)
                                if descendantIndex3 == nil then
                                    break
                                end
                                if descendantPart:IsA("BasePart") or (descendantPart:IsA("Part") or descendantPart:IsA("MeshPart")) then
                                    descendantPart.CanCollide = false
                                end
                            end
                            wait(0.214)
                        end
                        if humanoid then
                            task.wait(0.5)
                        end
                        local pairsIteratorDescendants3, index2, descendantIndex4 = pairs(descendants)
                        while true do
                            local descendantPart
                            descendantIndex4, descendantPart = pairsIteratorDescendants3(index2, descendantIndex4)
                            if descendantIndex4 == nil then
                                break
                            end
                            if descendantPart:IsA("BasePart") or (descendantPart:IsA("Part") or descendantPart:IsA("MeshPart")) then
                                descendantPart.CanCollide = canCollideMap[descendantPart]
                            end
                        end
                    end
                end)
            end
            
            task.spawn(function()
                if superStrengthBodyVelocity then
                    if not LocalPlayer.PlayerGui:FindFirstChild("ContextActionGui") then
                        return
                    end
                    local contextActionGuiButtonParent = nil
                    local mouseButtonDownConnection = nil
                    local disconnectEvent = nil
                    while contextActionGuiButtonParent == nil and grabParts.Parent do
                        local pairsIterator, index3, pairsIndex = pairs(LocalPlayer.PlayerGui.ContextActionGui:GetDescendants())
                        while true do
                            local descendantImageLabel
                            pairsIndex, descendantImageLabel = pairsIterator(index3, pairsIndex)
                            if pairsIndex == nil then
                                break
                            end
                            if descendantImageLabel:IsA("ImageLabel") and descendantImageLabel.Image == "http://www.roblox.com/asset/?id=9603678090" then
                                contextActionGuiButtonParent = descendantImageLabel.Parent
                            end
                        end
                        task.wait()
                    end
                    contextActionGuiButtonParent.Active = true
                    if contextActionGuiButtonParent then
                        mouseButtonDownConnection = contextActionGuiButtonParent.MouseButton1Down:Connect(function()
                            print("Launched Mobile!")
                            pressedStrength = true
                            superStrengthBodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                            superStrengthBodyVelocity.Velocity = Workspace.CurrentCamera.CFrame.lookVector * StrengthState.Strength
                            
                            for _, player in ipairs(Players:GetPlayers()) do
                                if player ~= LocalPlayer and player.Character then
                                    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                                    if humanoid and humanoid.FloorMaterial ~= Enum.Material.Air then
                                        local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
                                        if rootPart and (rootPart.Position - grabbedPart.Position).Magnitude < 20 then
                                            SetNetworkOwner:FireServer(rootPart, rootPart.CFrame)
                                            task.wait(0.05)
                                            local playerVelocity = Instance.new("BodyVelocity")
                                            playerVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                                            playerVelocity.Velocity = Workspace.CurrentCamera.CFrame.lookVector * StrengthState.Strength
                                            playerVelocity.Parent = rootPart
                                            DebrisService:AddItem(playerVelocity, 1)
                                        end
                                    end
                                end
                            end
                        end)
                    end
                    local _ = grabParts:GetPropertyChangedSignal("Parent"):Connect(function()
                        if not grabParts.Parent then
                            DebrisService:AddItem(superStrengthBodyVelocity, 1)
                            if mouseButtonDownConnection then
                                mouseButtonDownConnection:Disconnect()
                            end
                            disconnectEvent:Disconnect()
                        end
                    end)
                end
            end)
            task.spawn(function()
                if superStrengthBodyVelocity then
                    local parentChangedConnection = nil
                    parentChangedConnection = grabParts:GetPropertyChangedSignal("Parent"):Connect(function()
                        if not grabParts.Parent then
                            if UserInputService:GetLastInputType() ~= Enum.UserInputType.MouseButton2 or not StrengthState.Enabled then
                                if UserInputService:GetLastInputType() == Enum.UserInputType.MouseButton1 then
                                    superStrengthBodyVelocity:Destroy()
                                end
                            else
                                print("Launched!")
                                pressedStrength = true
                                superStrengthBodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                                superStrengthBodyVelocity.Velocity = Workspace.CurrentCamera.CFrame.lookVector * StrengthState.Strength
                                DebrisService:AddItem(superStrengthBodyVelocity, 1)
                                
                                for _, player in ipairs(Players:GetPlayers()) do
                                    if player ~= LocalPlayer and player.Character then
                                        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                                        if humanoid and humanoid.FloorMaterial ~= Enum.Material.Air then
                                            local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
                                            if rootPart and (rootPart.Position - grabbedPart.Position).Magnitude < 20 then
                                                SetNetworkOwner:FireServer(rootPart, rootPart.CFrame)
                                                task.wait(0.05)
                                                local playerVelocity = Instance.new("BodyVelocity")
                                                playerVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                                                playerVelocity.Velocity = Workspace.CurrentCamera.CFrame.lookVector * StrengthState.Strength
                                                playerVelocity.Parent = rootPart
                                                DebrisService:AddItem(playerVelocity, 1)
                                            end
                                        end
                                    end
                                end
                            end
                            parentChangedConnection:Disconnect()
                        end
                    end)
                end
            end)
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if AntiBurnState.Enabled then
        local character = LocalPlayer.Character
        if character then
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                local firePlayerPart = humanoidRootPart:FindFirstChild("FirePlayerPart")
                if firePlayerPart then
                    firePlayerPart:Destroy()
                end
            end
        end
    end
end)

Workspace.DescendantAdded:Connect(function(descendant)
    if AntiExplosionState.Enabled and descendant:IsA("Explosion") then
        descendant:Destroy()
    end
end)

Library:Notify({
    Title = "Heavenlyyy",
    Content = "Script loaded successfully!",
    Duration = 3
})

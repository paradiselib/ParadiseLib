local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local UI = {}
UI.Elements = {}

function UI:Create()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ParadiseGUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.5, -400, 0.5, -300)
    MainFrame.Size = UDim2.new(0, 800, 0, 600)

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 16)
    UICorner.Parent = MainFrame

    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.Parent = MainFrame
    Shadow.BackgroundTransparency = 1
    Shadow.Position = UDim2.new(0, -15, 0, -15)
    Shadow.Size = UDim2.new(1, 30, 1, 30)
    Shadow.ZIndex = 0
    Shadow.Image = "rbxassetid://6014261993"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.5
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(49, 49, 450, 450)

    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Parent = MainFrame
    TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    TopBar.BorderSizePixel = 0
    TopBar.Size = UDim2.new(1, 0, 0, 50)

    local TopBarCorner = Instance.new("UICorner")
    TopBarCorner.CornerRadius = UDim.new(0, 16)
    TopBarCorner.Parent = TopBar

    local TopBarFix = Instance.new("Frame")
    TopBarFix.Parent = TopBar
    TopBarFix.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    TopBarFix.BorderSizePixel = 0
    TopBarFix.Position = UDim2.new(0, 0, 1, -16)
    TopBarFix.Size = UDim2.new(1, 0, 0, 16)

    local Logo = Instance.new("TextLabel")
    Logo.Name = "Logo"
    Logo.Parent = TopBar
    Logo.BackgroundTransparency = 1
    Logo.Position = UDim2.new(0, 20, 0, 0)
    Logo.Size = UDim2.new(0, 200, 1, 0)
    Logo.Font = Enum.Font.GothamBold
    Logo.Text = "PARADISE"
    Logo.TextColor3 = Color3.fromRGB(220, 50, 50)
    Logo.TextSize = 24
    Logo.TextXAlignment = Enum.TextXAlignment.Left

    local Version = Instance.new("TextLabel")
    Version.Name = "Version"
    Version.Parent = TopBar
    Version.BackgroundTransparency = 1
    Version.Position = UDim2.new(0, 130, 0, 0)
    Version.Size = UDim2.new(0, 100, 1, 0)
    Version.Font = Enum.Font.Gotham
    Version.Text = "v1.0"
    Version.TextColor3 = Color3.fromRGB(100, 100, 100)
    Version.TextSize = 12
    Version.TextXAlignment = Enum.TextXAlignment.Left

    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = "MinimizeButton"
    MinimizeButton.Parent = TopBar
    MinimizeButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MinimizeButton.BorderSizePixel = 0
    MinimizeButton.Position = UDim2.new(1, -90, 0.5, -15)
    MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.Text = "_"
    MinimizeButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    MinimizeButton.TextSize = 18

    local MinimizeCorner = Instance.new("UICorner")
    MinimizeCorner.CornerRadius = UDim.new(0, 8)
    MinimizeCorner.Parent = MinimizeButton

    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Parent = TopBar
    CloseButton.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
    CloseButton.BorderSizePixel = 0
    CloseButton.Position = UDim2.new(1, -50, 0.5, -15)
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 16

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 8)
    CloseCorner.Parent = CloseButton

    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Parent = MainFrame
    Sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    Sidebar.BorderSizePixel = 0
    Sidebar.Position = UDim2.new(0, 0, 0, 50)
    Sidebar.Size = UDim2.new(0, 180, 1, -50)

    local SidebarCorner = Instance.new("UICorner")
    SidebarCorner.CornerRadius = UDim.new(0, 16)
    SidebarCorner.Parent = Sidebar

    local SidebarFix = Instance.new("Frame")
    SidebarFix.Parent = Sidebar
    SidebarFix.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    SidebarFix.BorderSizePixel = 0
    SidebarFix.Position = UDim2.new(1, -16, 0, 0)
    SidebarFix.Size = UDim2.new(0, 16, 1, 0)

    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Parent = Sidebar
    TabContainer.BackgroundTransparency = 1
    TabContainer.Position = UDim2.new(0, 10, 0, 20)
    TabContainer.Size = UDim2.new(1, -20, 1, -30)

    local TabLayout = Instance.new("UIListLayout")
    TabLayout.Parent = TabContainer
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Padding = UDim.new(0, 8)

    local function CreateTab(name, icon, order)
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name .. "Tab"
        TabButton.Parent = TabContainer
        TabButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        TabButton.BorderSizePixel = 0
        TabButton.Size = UDim2.new(1, 0, 0, 45)
        TabButton.Font = Enum.Font.GothamSemibold
        TabButton.Text = "  " .. icon .. "  " .. name
        TabButton.TextColor3 = Color3.fromRGB(150, 150, 150)
        TabButton.TextSize = 14
        TabButton.TextXAlignment = Enum.TextXAlignment.Left
        TabButton.LayoutOrder = order

        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 10)
        TabCorner.Parent = TabButton

        local TabPadding = Instance.new("UIPadding")
        TabPadding.Parent = TabButton
        TabPadding.PaddingLeft = UDim.new(0, 15)

        return TabButton
    end

    local DecompilerTab = CreateTab("Decompiler", "🔓", 1)
    local SettingsTab = CreateTab("Settings", "⚙️", 2)
    local AboutTab = CreateTab("About", "ℹ️", 3)

    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Parent = MainFrame
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Position = UDim2.new(0, 190, 0, 60)
    ContentFrame.Size = UDim2.new(1, -200, 1, -70)

    local DecompilerPage = Instance.new("Frame")
    DecompilerPage.Name = "DecompilerPage"
    DecompilerPage.Parent = ContentFrame
    DecompilerPage.BackgroundTransparency = 1
    DecompilerPage.Size = UDim2.new(1, 0, 1, 0)
    DecompilerPage.Visible = true

    local InputSection = Instance.new("Frame")
    InputSection.Name = "InputSection"
    InputSection.Parent = DecompilerPage
    InputSection.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    InputSection.BorderSizePixel = 0
    InputSection.Size = UDim2.new(1, 0, 0, 120)

    local InputSectionCorner = Instance.new("UICorner")
    InputSectionCorner.CornerRadius = UDim.new(0, 12)
    InputSectionCorner.Parent = InputSection

    local InputLabel = Instance.new("TextLabel")
    InputLabel.Name = "InputLabel"
    InputLabel.Parent = InputSection
    InputLabel.BackgroundTransparency = 1
    InputLabel.Position = UDim2.new(0, 20, 0, 15)
    InputLabel.Size = UDim2.new(1, -40, 0, 25)
    InputLabel.Font = Enum.Font.GothamBold
    InputLabel.Text = "Script Name"
    InputLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    InputLabel.TextSize = 16
    InputLabel.TextXAlignment = Enum.TextXAlignment.Left

    local InputBox = Instance.new("TextBox")
    InputBox.Name = "InputBox"
    InputBox.Parent = InputSection
    InputBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    InputBox.BorderSizePixel = 0
    InputBox.Position = UDim2.new(0, 20, 0, 45)
    InputBox.Size = UDim2.new(1, -160, 0, 40)
    InputBox.Font = Enum.Font.Gotham
    InputBox.PlaceholderText = "Enter script name..."
    InputBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
    InputBox.Text = ""
    InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    InputBox.TextSize = 14
    InputBox.TextXAlignment = Enum.TextXAlignment.Left

    local InputBoxCorner = Instance.new("UICorner")
    InputBoxCorner.CornerRadius = UDim.new(0, 10)
    InputBoxCorner.Parent = InputBox

    local InputBoxPadding = Instance.new("UIPadding")
    InputBoxPadding.Parent = InputBox
    InputBoxPadding.PaddingLeft = UDim.new(0, 15)

    local DecompileButton = Instance.new("TextButton")
    DecompileButton.Name = "DecompileButton"
    DecompileButton.Parent = InputSection
    DecompileButton.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
    DecompileButton.BorderSizePixel = 0
    DecompileButton.Position = UDim2.new(1, -120, 0, 45)
    DecompileButton.Size = UDim2.new(0, 100, 0, 40)
    DecompileButton.Font = Enum.Font.GothamBold
    DecompileButton.Text = "DECOMPILE"
    DecompileButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    DecompileButton.TextSize = 13

    local DecompileButtonCorner = Instance.new("UICorner")
    DecompileButtonCorner.CornerRadius = UDim.new(0, 10)
    DecompileButtonCorner.Parent = DecompileButton

    local OutputSection = Instance.new("Frame")
    OutputSection.Name = "OutputSection"
    OutputSection.Parent = DecompilerPage
    OutputSection.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    OutputSection.BorderSizePixel = 0
    OutputSection.Position = UDim2.new(0, 0, 0, 135)
    OutputSection.Size = UDim2.new(1, 0, 1, -135)

    local OutputSectionCorner = Instance.new("UICorner")
    OutputSectionCorner.CornerRadius = UDim.new(0, 12)
    OutputSectionCorner.Parent = OutputSection

    local OutputLabel = Instance.new("TextLabel")
    OutputLabel.Name = "OutputLabel"
    OutputLabel.Parent = OutputSection
    OutputLabel.BackgroundTransparency = 1
    OutputLabel.Position = UDim2.new(0, 20, 0, 15)
    OutputLabel.Size = UDim2.new(1, -40, 0, 25)
    OutputLabel.Font = Enum.Font.GothamBold
    OutputLabel.Text = "Output"
    OutputLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    OutputLabel.TextSize = 16
    OutputLabel.TextXAlignment = Enum.TextXAlignment.Left

    local OutputFrame = Instance.new("ScrollingFrame")
    OutputFrame.Name = "OutputFrame"
    OutputFrame.Parent = OutputSection
    OutputFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    OutputFrame.BorderSizePixel = 0
    OutputFrame.Position = UDim2.new(0, 20, 0, 50)
    OutputFrame.Size = UDim2.new(1, -40, 1, -70)
    OutputFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    OutputFrame.ScrollBarThickness = 8
    OutputFrame.ScrollBarImageColor3 = Color3.fromRGB(180, 30, 30)

    local OutputFrameCorner = Instance.new("UICorner")
    OutputFrameCorner.CornerRadius = UDim.new(0, 10)
    OutputFrameCorner.Parent = OutputFrame

    local OutputText = Instance.new("TextLabel")
    OutputText.Name = "OutputText"
    OutputText.Parent = OutputFrame
    OutputText.BackgroundTransparency = 1
    OutputText.Size = UDim2.new(1, -20, 1, 0)
    OutputText.Position = UDim2.new(0, 10, 0, 10)
    OutputText.Font = Enum.Font.Code
    OutputText.Text = "Waiting for input..."
    OutputText.TextColor3 = Color3.fromRGB(180, 180, 180)
    OutputText.TextSize = 13
    OutputText.TextXAlignment = Enum.TextXAlignment.Left
    OutputText.TextYAlignment = Enum.TextYAlignment.Top
    OutputText.TextWrapped = true

    local SettingsPage = Instance.new("Frame")
    SettingsPage.Name = "SettingsPage"
    SettingsPage.Parent = ContentFrame
    SettingsPage.BackgroundTransparency = 1
    SettingsPage.Size = UDim2.new(1, 0, 1, 0)
    SettingsPage.Visible = false

    local SettingsTitle = Instance.new("TextLabel")
    SettingsTitle.Parent = SettingsPage
    SettingsTitle.BackgroundTransparency = 1
    SettingsTitle.Size = UDim2.new(1, 0, 0, 40)
    SettingsTitle.Font = Enum.Font.GothamBold
    SettingsTitle.Text = "Settings"
    SettingsTitle.TextColor3 = Color3.fromRGB(220, 220, 220)
    SettingsTitle.TextSize = 24
    SettingsTitle.TextXAlignment = Enum.TextXAlignment.Left

    local AboutPage = Instance.new("Frame")
    AboutPage.Name = "AboutPage"
    AboutPage.Parent = ContentFrame
    AboutPage.BackgroundTransparency = 1
    AboutPage.Size = UDim2.new(1, 0, 1, 0)
    AboutPage.Visible = false

    local AboutTitle = Instance.new("TextLabel")
    AboutTitle.Parent = AboutPage
    AboutTitle.BackgroundTransparency = 1
    AboutTitle.Size = UDim2.new(1, 0, 0, 40)
    AboutTitle.Font = Enum.Font.GothamBold
    AboutTitle.Text = "About Paradise"
    AboutTitle.TextColor3 = Color3.fromRGB(220, 220, 220)
    AboutTitle.TextSize = 24
    AboutTitle.TextXAlignment = Enum.TextXAlignment.Left

    local AboutText = Instance.new("TextLabel")
    AboutText.Parent = AboutPage
    AboutText.BackgroundTransparency = 1
    AboutText.Position = UDim2.new(0, 0, 0, 60)
    AboutText.Size = UDim2.new(1, 0, 0, 200)
    AboutText.Font = Enum.Font.Gotham
    AboutText.Text = "Paradise Decompiler v1.0\n\nAutonomous bytecode decompiler for Roblox\n\nFeatures:\n• Automatic script search\n• Multi-location scanning\n• Beautiful modern UI\n• Fast and reliable"
    AboutText.TextColor3 = Color3.fromRGB(180, 180, 180)
    AboutText.TextSize = 14
    AboutText.TextXAlignment = Enum.TextXAlignment.Left
    AboutText.TextYAlignment = Enum.TextYAlignment.Top
    AboutText.TextWrapped = true

    self:SetupDragging(TopBar, MainFrame)
    self:SetupAnimations(DecompileButton, CloseButton, MinimizeButton)
    self:SetupTabs(DecompilerTab, SettingsTab, AboutTab, DecompilerPage, SettingsPage, AboutPage)
    
    if gethui then
        ScreenGui.Parent = gethui()
    elseif syn and syn.protect_gui then
        syn.protect_gui(ScreenGui)
        ScreenGui.Parent = game:GetService("CoreGui")
    else
        ScreenGui.Parent = game:GetService("CoreGui")
    end

    MainFrame.Position = UDim2.new(0.5, -400, -1, 0)
    TweenService:Create(MainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -400, 0.5, -300)}):Play()

    self.Elements.ScreenGui = ScreenGui
    self.Elements.MainFrame = MainFrame
    self.Elements.InputBox = InputBox
    self.Elements.DecompileButton = DecompileButton
    self.Elements.CloseButton = CloseButton
    self.Elements.MinimizeButton = MinimizeButton
    self.Elements.OutputText = OutputText
    self.Elements.OutputFrame = OutputFrame
    
    return self.Elements
end

function UI:SetOutput(text, color)
    self.Elements.OutputText.Text = text
    self.Elements.OutputText.TextColor3 = color or Color3.fromRGB(180, 180, 180)
    self:UpdateOutputSize()
end

function UI:UpdateOutputSize()
    local textSize = game:GetService("TextService"):GetTextSize(
        self.Elements.OutputText.Text,
        self.Elements.OutputText.TextSize,
        self.Elements.OutputText.Font,
        Vector2.new(self.Elements.OutputFrame.AbsoluteSize.X - 20, math.huge)
    )
    self.Elements.OutputText.Size = UDim2.new(1, -20, 0, textSize.Y + 20)
    self.Elements.OutputFrame.CanvasSize = UDim2.new(0, 0, 0, textSize.Y + 40)
end

function UI:SetupTabs(tab1, tab2, tab3, page1, page2, page3)
    local tabs = {tab1, tab2, tab3}
    local pages = {page1, page2, page3}
    
    for i, tab in ipairs(tabs) do
        tab.MouseButton1Click:Connect(function()
            for j, t in ipairs(tabs) do
                if j == i then
                    TweenService:Create(t, TweenInfo.new(0.2), {
                        BackgroundColor3 = Color3.fromRGB(180, 30, 30),
                        TextColor3 = Color3.fromRGB(255, 255, 255)
                    }):Play()
                    pages[j].Visible = true
                else
                    TweenService:Create(t, TweenInfo.new(0.2), {
                        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
                        TextColor3 = Color3.fromRGB(150, 150, 150)
                    }):Play()
                    pages[j].Visible = false
                end
            end
        end)
    end
    
    TweenService:Create(tab1, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(180, 30, 30),
        TextColor3 = Color3.fromRGB(255, 255, 255)
    }):Play()
end

function UI:SetupDragging(topBar, mainFrame)
    local dragging = false
    local dragInput
    local dragStart
    local startPos

    local function update(input)
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    topBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

function UI:SetupAnimations(decompileButton, closeButton, minimizeButton)
    decompileButton.MouseEnter:Connect(function()
        TweenService:Create(decompileButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(220, 40, 40)}):Play()
    end)

    decompileButton.MouseLeave:Connect(function()
        TweenService:Create(decompileButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(180, 30, 30)}):Play()
    end)

    closeButton.MouseEnter:Connect(function()
        TweenService:Create(closeButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(220, 40, 40)}):Play()
    end)

    closeButton.MouseLeave:Connect(function()
        TweenService:Create(closeButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(180, 30, 30)}):Play()
    end)

    minimizeButton.MouseEnter:Connect(function()
        TweenService:Create(minimizeButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
    end)

    minimizeButton.MouseLeave:Connect(function()
        TweenService:Create(minimizeButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
    end)
end

return UI

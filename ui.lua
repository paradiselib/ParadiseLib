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
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -250)
    MainFrame.Size = UDim2.new(0, 600, 0, 500)

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = MainFrame

    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Parent = MainFrame
    TopBar.BackgroundColor3 = Color3.fromRGB(139, 0, 0)
    TopBar.BorderSizePixel = 0
    TopBar.Size = UDim2.new(1, 0, 0, 40)

    local TopBarCorner = Instance.new("UICorner")
    TopBarCorner.CornerRadius = UDim.new(0, 12)
    TopBarCorner.Parent = TopBar

    local TopBarFix = Instance.new("Frame")
    TopBarFix.Parent = TopBar
    TopBarFix.BackgroundColor3 = Color3.fromRGB(139, 0, 0)
    TopBarFix.BorderSizePixel = 0
    TopBarFix.Position = UDim2.new(0, 0, 1, -12)
    TopBarFix.Size = UDim2.new(1, 0, 0, 12)

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Parent = TopBar
    Title.BackgroundTransparency = 1
    Title.Size = UDim2.new(1, -100, 1, 0)
    Title.Font = Enum.Font.GothamBold
    Title.Text = "Paradise Decompiler"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 18
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Position = UDim2.new(0, 15, 0, 0)

    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Parent = TopBar
    CloseButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    CloseButton.BorderSizePixel = 0
    CloseButton.Position = UDim2.new(1, -35, 0.5, -12)
    CloseButton.Size = UDim2.new(0, 24, 0, 24)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 14

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = CloseButton

    local InputLabel = Instance.new("TextLabel")
    InputLabel.Name = "InputLabel"
    InputLabel.Parent = MainFrame
    InputLabel.BackgroundTransparency = 1
    InputLabel.Position = UDim2.new(0, 20, 0, 60)
    InputLabel.Size = UDim2.new(1, -40, 0, 20)
    InputLabel.Font = Enum.Font.Gotham
    InputLabel.Text = "Script Name:"
    InputLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    InputLabel.TextSize = 14
    InputLabel.TextXAlignment = Enum.TextXAlignment.Left

    local InputBox = Instance.new("TextBox")
    InputBox.Name = "InputBox"
    InputBox.Parent = MainFrame
    InputBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    InputBox.BorderSizePixel = 0
    InputBox.Position = UDim2.new(0, 20, 0, 85)
    InputBox.Size = UDim2.new(1, -40, 0, 35)
    InputBox.Font = Enum.Font.Gotham
    InputBox.PlaceholderText = "Enter script name..."
    InputBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
    InputBox.Text = ""
    InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    InputBox.TextSize = 14
    InputBox.TextXAlignment = Enum.TextXAlignment.Left
    InputBox.ClearTextOnFocus = false

    local InputCorner = Instance.new("UICorner")
    InputCorner.CornerRadius = UDim.new(0, 8)
    InputCorner.Parent = InputBox

    local InputPadding = Instance.new("UIPadding")
    InputPadding.Parent = InputBox
    InputPadding.PaddingLeft = UDim.new(0, 10)

    local DecompileButton = Instance.new("TextButton")
    DecompileButton.Name = "DecompileButton"
    DecompileButton.Parent = MainFrame
    DecompileButton.BackgroundColor3 = Color3.fromRGB(139, 0, 0)
    DecompileButton.BorderSizePixel = 0
    DecompileButton.Position = UDim2.new(0, 20, 0, 135)
    DecompileButton.Size = UDim2.new(1, -40, 0, 40)
    DecompileButton.Font = Enum.Font.GothamBold
    DecompileButton.Text = "DECOMPILE"
    DecompileButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    DecompileButton.TextSize = 16

    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 8)
    ButtonCorner.Parent = DecompileButton

    local OutputLabel = Instance.new("TextLabel")
    OutputLabel.Name = "OutputLabel"
    OutputLabel.Parent = MainFrame
    OutputLabel.BackgroundTransparency = 1
    OutputLabel.Position = UDim2.new(0, 20, 0, 190)
    OutputLabel.Size = UDim2.new(1, -40, 0, 20)
    OutputLabel.Font = Enum.Font.Gotham
    OutputLabel.Text = "Output:"
    OutputLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    OutputLabel.TextSize = 14
    OutputLabel.TextXAlignment = Enum.TextXAlignment.Left

    local OutputFrame = Instance.new("ScrollingFrame")
    OutputFrame.Name = "OutputFrame"
    OutputFrame.Parent = MainFrame
    OutputFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    OutputFrame.BorderSizePixel = 0
    OutputFrame.Position = UDim2.new(0, 20, 0, 215)
    OutputFrame.Size = UDim2.new(1, -40, 1, -235)
    OutputFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    OutputFrame.ScrollBarThickness = 6
    OutputFrame.ScrollBarImageColor3 = Color3.fromRGB(139, 0, 0)

    local OutputCorner = Instance.new("UICorner")
    OutputCorner.CornerRadius = UDim.new(0, 8)
    OutputCorner.Parent = OutputFrame

    local OutputText = Instance.new("TextLabel")
    OutputText.Name = "OutputText"
    OutputText.Parent = OutputFrame
    OutputText.BackgroundTransparency = 1
    OutputText.Size = UDim2.new(1, -10, 1, 0)
    OutputText.Position = UDim2.new(0, 5, 0, 5)
    OutputText.Font = Enum.Font.Code
    OutputText.Text = "Waiting for input..."
    OutputText.TextColor3 = Color3.fromRGB(200, 200, 200)
    OutputText.TextSize = 12
    OutputText.TextXAlignment = Enum.TextXAlignment.Left
    OutputText.TextYAlignment = Enum.TextYAlignment.Top
    OutputText.TextWrapped = true

    self:SetupDragging(TopBar, MainFrame)
    self:SetupAnimations(DecompileButton, CloseButton)
    
    if gethui then
        ScreenGui.Parent = gethui()
    elseif syn and syn.protect_gui then
        syn.protect_gui(ScreenGui)
        ScreenGui.Parent = game:GetService("CoreGui")
    else
        ScreenGui.Parent = game:GetService("CoreGui")
    end

    MainFrame.Position = UDim2.new(0.5, -300, -0.5, 0)
    TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -300, 0.5, -250)}):Play()

    self.Elements.ScreenGui = ScreenGui
    self.Elements.InputBox = InputBox
    self.Elements.DecompileButton = DecompileButton
    self.Elements.CloseButton = CloseButton
    self.Elements.OutputText = OutputText
    self.Elements.OutputFrame = OutputFrame
    
    return self.Elements
end

function UI:SetOutput(text, color)
    self.Elements.OutputText.Text = text
    self.Elements.OutputText.TextColor3 = color or Color3.fromRGB(200, 200, 200)
    self:UpdateOutputSize()
end

function UI:UpdateOutputSize()
    local textSize = game:GetService("TextService"):GetTextSize(
        self.Elements.OutputText.Text,
        self.Elements.OutputText.TextSize,
        self.Elements.OutputText.Font,
        Vector2.new(self.Elements.OutputFrame.AbsoluteSize.X - 10, math.huge)
    )
    self.Elements.OutputText.Size = UDim2.new(1, -10, 0, textSize.Y + 10)
    self.Elements.OutputFrame.CanvasSize = UDim2.new(0, 0, 0, textSize.Y + 20)
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

function UI:SetupAnimations(decompileButton, closeButton)
    decompileButton.MouseEnter:Connect(function()
        TweenService:Create(decompileButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(180, 0, 0)}):Play()
    end)

    decompileButton.MouseLeave:Connect(function()
        TweenService:Create(decompileButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(139, 0, 0)}):Play()
    end)

    closeButton.MouseEnter:Connect(function()
        TweenService:Create(closeButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 0, 0)}):Play()
    end)

    closeButton.MouseLeave:Connect(function()
        TweenService:Create(closeButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(200, 0, 0)}):Play()
    end)
end

return UI

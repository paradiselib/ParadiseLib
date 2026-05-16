local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local UI = {}
UI.__index = UI

local Colors = {
    Background = Color3.fromRGB(20, 20, 20),
    Secondary = Color3.fromRGB(35, 35, 35),
    Primary = Color3.fromRGB(139, 0, 0),
    PrimaryHover = Color3.fromRGB(180, 0, 0),
    CloseButton = Color3.fromRGB(200, 0, 0),
    CloseButtonHover = Color3.fromRGB(255, 0, 0),
    Text = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(200, 200, 200),
    TextPlaceholder = Color3.fromRGB(100, 100, 100),
    Error = Color3.fromRGB(255, 100, 100),
    Warning = Color3.fromRGB(255, 200, 100),
    Success = Color3.fromRGB(100, 255, 100)
}

function UI.create()
    local self = setmetatable({}, UI)
    
    self.onDecompile = Instance.new("BindableEvent")
    self.onClose = Instance.new("BindableEvent")
    
    self:createGui()
    self:setupEvents()
    
    return self
end

function UI:createGui()
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "DecompilerGUI"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Parent = self.ScreenGui
    self.MainFrame.BackgroundColor3 = Colors.Background
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.Position = UDim2.new(0.5, -300, 0.5, -250)
    self.MainFrame.Size = UDim2.new(0, 600, 0, 500)
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 12)
    mainCorner.Parent = self.MainFrame
    
    self:createTopBar()
    self:createInputSection()
    self:createOutputSection()
end

function UI:createTopBar()
    local topBar = Instance.new("Frame")
    topBar.Name = "TopBar"
    topBar.Parent = self.MainFrame
    topBar.BackgroundColor3 = Colors.Primary
    topBar.BorderSizePixel = 0
    topBar.Size = UDim2.new(1, 0, 0, 40)
    
    local topBarCorner = Instance.new("UICorner")
    topBarCorner.CornerRadius = UDim.new(0, 12)
    topBarCorner.Parent = topBar
    
    local topBarFix = Instance.new("Frame")
    topBarFix.Parent = topBar
    topBarFix.BackgroundColor3 = Colors.Primary
    topBarFix.BorderSizePixel = 0
    topBarFix.Position = UDim2.new(0, 0, 1, -12)
    topBarFix.Size = UDim2.new(1, 0, 0, 12)
    
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Parent = topBar
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, -100, 1, 0)
    title.Font = Enum.Font.GothamBold
    title.Text = "Bytecode Decompiler"
    title.TextColor3 = Colors.Text
    title.TextSize = 18
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Position = UDim2.new(0, 15, 0, 0)
    
    self.CloseButton = Instance.new("TextButton")
    self.CloseButton.Name = "CloseButton"
    self.CloseButton.Parent = topBar
    self.CloseButton.BackgroundColor3 = Colors.CloseButton
    self.CloseButton.BorderSizePixel = 0
    self.CloseButton.Position = UDim2.new(1, -35, 0.5, -12)
    self.CloseButton.Size = UDim2.new(0, 24, 0, 24)
    self.CloseButton.Font = Enum.Font.GothamBold
    self.CloseButton.Text = "X"
    self.CloseButton.TextColor3 = Colors.Text
    self.CloseButton.TextSize = 14
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 6)
    closeCorner.Parent = self.CloseButton
    
    self.TopBar = topBar
end

function UI:createInputSection()
    local inputLabel = Instance.new("TextLabel")
    inputLabel.Name = "InputLabel"
    inputLabel.Parent = self.MainFrame
    inputLabel.BackgroundTransparency = 1
    inputLabel.Position = UDim2.new(0, 20, 0, 60)
    inputLabel.Size = UDim2.new(1, -40, 0, 20)
    inputLabel.Font = Enum.Font.Gotham
    inputLabel.Text = "Script Name:"
    inputLabel.TextColor3 = Colors.TextSecondary
    inputLabel.TextSize = 14
    inputLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    self.InputBox = Instance.new("TextBox")
    self.InputBox.Name = "InputBox"
    self.InputBox.Parent = self.MainFrame
    self.InputBox.BackgroundColor3 = Colors.Secondary
    self.InputBox.BorderSizePixel = 0
    self.InputBox.Position = UDim2.new(0, 20, 0, 85)
    self.InputBox.Size = UDim2.new(1, -40, 0, 35)
    self.InputBox.Font = Enum.Font.Gotham
    self.InputBox.PlaceholderText = "Enter script name..."
    self.InputBox.PlaceholderColor3 = Colors.TextPlaceholder
    self.InputBox.Text = ""
    self.InputBox.TextColor3 = Colors.Text
    self.InputBox.TextSize = 14
    self.InputBox.TextXAlignment = Enum.TextXAlignment.Left
    self.InputBox.ClearTextOnFocus = false
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 8)
    inputCorner.Parent = self.InputBox
    
    local inputPadding = Instance.new("UIPadding")
    inputPadding.Parent = self.InputBox
    inputPadding.PaddingLeft = UDim.new(0, 10)
    
    self.DecompileButton = Instance.new("TextButton")
    self.DecompileButton.Name = "DecompileButton"
    self.DecompileButton.Parent = self.MainFrame
    self.DecompileButton.BackgroundColor3 = Colors.Primary
    self.DecompileButton.BorderSizePixel = 0
    self.DecompileButton.Position = UDim2.new(0, 20, 0, 135)
    self.DecompileButton.Size = UDim2.new(1, -40, 0, 40)
    self.DecompileButton.Font = Enum.Font.GothamBold
    self.DecompileButton.Text = "DECOMPILE"
    self.DecompileButton.TextColor3 = Colors.Text
    self.DecompileButton.TextSize = 16
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = self.DecompileButton
end

function UI:createOutputSection()
    local outputLabel = Instance.new("TextLabel")
    outputLabel.Name = "OutputLabel"
    outputLabel.Parent = self.MainFrame
    outputLabel.BackgroundTransparency = 1
    outputLabel.Position = UDim2.new(0, 20, 0, 190)
    outputLabel.Size = UDim2.new(1, -40, 0, 20)
    outputLabel.Font = Enum.Font.Gotham
    outputLabel.Text = "Output:"
    outputLabel.TextColor3 = Colors.TextSecondary
    outputLabel.TextSize = 14
    outputLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    self.OutputFrame = Instance.new("ScrollingFrame")
    self.OutputFrame.Name = "OutputFrame"
    self.OutputFrame.Parent = self.MainFrame
    self.OutputFrame.BackgroundColor3 = Colors.Secondary
    self.OutputFrame.BorderSizePixel = 0
    self.OutputFrame.Position = UDim2.new(0, 20, 0, 215)
    self.OutputFrame.Size = UDim2.new(1, -40, 1, -235)
    self.OutputFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.OutputFrame.ScrollBarThickness = 6
    self.OutputFrame.ScrollBarImageColor3 = Colors.Primary
    
    local outputCorner = Instance.new("UICorner")
    outputCorner.CornerRadius = UDim.new(0, 8)
    outputCorner.Parent = self.OutputFrame
    
    self.OutputText = Instance.new("TextLabel")
    self.OutputText.Name = "OutputText"
    self.OutputText.Parent = self.OutputFrame
    self.OutputText.BackgroundTransparency = 1
    self.OutputText.Size = UDim2.new(1, -10, 1, 0)
    self.OutputText.Position = UDim2.new(0, 5, 0, 5)
    self.OutputText.Font = Enum.Font.Code
    self.OutputText.Text = "Waiting for input..."
    self.OutputText.TextColor3 = Colors.TextSecondary
    self.OutputText.TextSize = 12
    self.OutputText.TextXAlignment = Enum.TextXAlignment.Left
    self.OutputText.TextYAlignment = Enum.TextYAlignment.Top
    self.OutputText.TextWrapped = true
end

function UI:setupEvents()
    self:setupDragging()
    self:setupButtons()
end

function UI:setupDragging()
    local dragging = false
    local dragInput
    local dragStart
    local startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        self.MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    self.TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = self.MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    self.TopBar.InputChanged:Connect(function(input)
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

function UI:setupButtons()
    self.DecompileButton.MouseButton1Click:Connect(function()
        self.onDecompile:Fire(self.InputBox.Text)
    end)
    
    self.CloseButton.MouseButton1Click:Connect(function()
        self.onClose:Fire()
    end)
    
    self.DecompileButton.MouseEnter:Connect(function()
        TweenService:Create(self.DecompileButton, TweenInfo.new(0.2), {BackgroundColor3 = Colors.PrimaryHover}):Play()
    end)
    
    self.DecompileButton.MouseLeave:Connect(function()
        TweenService:Create(self.DecompileButton, TweenInfo.new(0.2), {BackgroundColor3 = Colors.Primary}):Play()
    end)
    
    self.CloseButton.MouseEnter:Connect(function()
        TweenService:Create(self.CloseButton, TweenInfo.new(0.2), {BackgroundColor3 = Colors.CloseButtonHover}):Play()
    end)
    
    self.CloseButton.MouseLeave:Connect(function()
        TweenService:Create(self.CloseButton, TweenInfo.new(0.2), {BackgroundColor3 = Colors.CloseButton}):Play()
    end)
end

function UI:updateOutput(text, status)
    local colorMap = {
        error = Colors.Error,
        searching = Colors.Warning,
        found = Colors.Success,
        success = Colors.TextSecondary
    }
    
    self.OutputText.Text = text
    self.OutputText.TextColor3 = colorMap[status] or Colors.TextSecondary
    
    local textSize = game:GetService("TextService"):GetTextSize(
        self.OutputText.Text,
        self.OutputText.TextSize,
        self.OutputText.Font,
        Vector2.new(self.OutputFrame.AbsoluteSize.X - 10, math.huge)
    )
    self.OutputText.Size = UDim2.new(1, -10, 0, textSize.Y + 10)
    self.OutputFrame.CanvasSize = UDim2.new(0, 0, 0, textSize.Y + 20)
end

function UI:show()
    if gethui then
        self.ScreenGui.Parent = gethui()
    elseif syn and syn.protect_gui then
        syn.protect_gui(self.ScreenGui)
        self.ScreenGui.Parent = game:GetService("CoreGui")
    else
        self.ScreenGui.Parent = game:GetService("CoreGui")
    end
    
    self.MainFrame.Position = UDim2.new(0.5, -300, -0.5, 0)
    TweenService:Create(self.MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -300, 0.5, -250)}):Play()
end

function UI:destroy()
    self.ScreenGui:Destroy()
    self.onDecompile:Destroy()
    self.onClose:Destroy()
end

return UI

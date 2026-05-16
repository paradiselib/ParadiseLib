local Serpent = loadstring(game:HttpGet("https://raw.githubusercontent.com/53845052/roblox-uis/refs/heads/main/SerpentLib.lua"))()
Serpent:SetWindowKeybind(Enum.KeyCode.RightControl)

local UI = {}
UI.Serpent = Serpent
UI.Elements = {}

function UI:Create()
    local Window = self.Serpent:Window({SubTitle = "v1.0"})
    
    local Watermark = Window:Watermark(`Paradise Decompiler - <font color='#{self.Serpent:GetTheme().Accent:ToHex()}'>Professional Tool</font>`)
    Watermark:SetPosition("TopLeft")
    Watermark:SetVisible(true)
    
    local DecompilerTab = Window:Tab({Title = "Decompiler", Icon = "rbxassetid://11295279987"})
    
    DecompilerTab:Textbox({
        Title = "Script Name",
        Placeholder = "Enter script name...",
        Flag = "script_name",
        Callback = function(value)
            self.Elements.ScriptName = value
        end
    })
    
    DecompilerTab:Button({
        Title = "Decompile Script",
        Action = "Execute",
        Callback = function()
            if self.Elements.OnDecompile then
                self.Elements.OnDecompile()
            end
        end
    })
    
    local SettingsTab = Window:Tab({Title = "Settings", Icon = "rbxassetid://14202377484"})
    
    SettingsTab:Toggle({
        Title = "Auto Copy to Clipboard",
        Flag = "auto_copy",
        Callback = function(state)
            self.Elements.AutoCopy = state
        end
    })
    
    SettingsTab:Toggle({
        Title = "Show Notifications",
        Flag = "show_notifications",
        Default = true,
        Callback = function(state)
            self.Elements.ShowNotifications = state
        end
    })
    
    SettingsTab:Toggle({
        Title = "Detailed Output",
        Flag = "detailed_output",
        Callback = function(state)
            self.Elements.DetailedOutput = state
        end
    })
    
    local AboutTab = Window:Tab({Title = "About", Icon = "rbxassetid://11963367322"})
    
    AboutTab:Button({
        Title = "Join Discord",
        Action = "Open",
        Callback = function()
            self:Notify("Discord", "Discord link copied to clipboard!", 3)
        end
    })
    
    self.Elements.Window = Window
    self.Elements.Watermark = Watermark
    self.Elements.ScriptName = ""
    self.Elements.AutoCopy = false
    self.Elements.ShowNotifications = true
    self.Elements.DetailedOutput = false
    
    return self.Elements
end

function UI:SetOutput(text, isError)
    if self.Elements.ShowNotifications then
        self:Notify(
            isError and "Error" or "Success",
            isError and "Failed to decompile script" or "Script decompiled successfully!",
            3
        )
    end
end

function UI:Notify(title, description, duration)
    if self.Serpent and self.Serpent.Notify then
        self.Serpent:Notify({
            Title = title,
            Description = description,
            Duration = duration or 3
        })
    end
end

return UI

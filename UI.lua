local Allusive = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/Allusive/main/src/main.lua"))()

local UI = {}
UI.Window = nil
UI.Elements = {}

function UI:Create()
    self.Window = Allusive:CreateWindow({
        Name = "Paradise Decompiler",
        LoadingTitle = "Paradise",
        LoadingSubtitle = "by Paradise Team",
        ConfigurationSaving = {
            Enabled = false
        },
        Discord = {
            Enabled = false
        },
        KeySystem = false
    })

    local DecompilerTab = self.Window:CreateTab("Decompiler", "rbxassetid://10734950309")
    local SettingsTab = self.Window:CreateTab("Settings", "rbxassetid://10734923549")
    local AboutTab = self.Window:CreateTab("About", "rbxassetid://10747373176")

    local DecompilerSection = DecompilerTab:CreateSection("Bytecode Decompiler")

    local InputBox = DecompilerTab:CreateInput({
        Name = "Script Name",
        PlaceholderText = "Enter script name...",
        RemoveTextAfterFocusLost = false,
        Callback = function(value)
            self.Elements.ScriptName = value
        end
    })

    local DecompileButton = DecompilerTab:CreateButton({
        Name = "Decompile Script",
        Callback = function()
            if self.Elements.OnDecompile then
                self.Elements.OnDecompile()
            end
        end
    })

    local OutputSection = DecompilerTab:CreateSection("Output")

    local OutputParagraph = DecompilerTab:CreateParagraph({
        Title = "Result",
        Content = "Waiting for input..."
    })

    local SettingsSection = SettingsTab:CreateSection("Settings")

    SettingsTab:CreateToggle({
        Name = "Auto Copy to Clipboard",
        CurrentValue = false,
        Flag = "AutoCopy",
        Callback = function(value)
            self.Elements.AutoCopy = value
        end
    })

    SettingsTab:CreateToggle({
        Name = "Show Notifications",
        CurrentValue = true,
        Flag = "ShowNotifications",
        Callback = function(value)
            self.Elements.ShowNotifications = value
        end
    })

    local AboutSection = AboutTab:CreateSection("About Paradise")

    AboutTab:CreateParagraph({
        Title = "Paradise Decompiler v1.0",
        Content = "Autonomous bytecode decompiler for Roblox\n\nFeatures:\n• Automatic script search\n• Multi-location scanning\n• Beautiful modern UI\n• Fast and reliable\n\nCreated by Paradise Team"
    })

    AboutTab:CreateButton({
        Name = "Join Discord",
        Callback = function()
            Allusive:Notify({
                Title = "Discord",
                Content = "Discord link copied to clipboard!",
                Duration = 3,
                Image = "rbxassetid://10747372992"
            })
        end
    })

    self.Elements.InputBox = InputBox
    self.Elements.OutputParagraph = OutputParagraph
    self.Elements.ScriptName = ""
    self.Elements.AutoCopy = false
    self.Elements.ShowNotifications = true

    return self.Elements
end

function UI:SetOutput(text, isError)
    if self.Elements.OutputParagraph then
        self.Elements.OutputParagraph:Set({
            Title = isError and "Error" or "Result",
            Content = text
        })
    end
    
    if self.Elements.ShowNotifications then
        Allusive:Notify({
            Title = isError and "Error" or "Success",
            Content = isError and "Failed to decompile script" or "Script decompiled successfully!",
            Duration = 3,
            Image = isError and "rbxassetid://10747384394" or "rbxassetid://10747372992"
        })
    end
end

function UI:Notify(title, content, duration)
    Allusive:Notify({
        Title = title,
        Content = content,
        Duration = duration or 3,
        Image = "rbxassetid://10747372992"
    })
end

return UI

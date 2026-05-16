local Isotopia = loadstring(game:HttpGet("https://raw.githubusercontent.com/azurelw/isotopia/refs/heads/main/loader.lua"))()

local UI = {}
UI.Window = nil
UI.Elements = {}
UI.Isotopia = Isotopia

function UI:Create()
    if not self.Isotopia then
        error("Isotopia library failed to load")
        return nil
    end
    
    self.Window = self.Isotopia:Window({
        Title = "Paradise Decompiler",
        Icon = "rbxassetid://107819132007001",
        Transparent = false,
        Size = UDim2.fromOffset(700, 500),
        MainColor = Color3.fromRGB(180, 30, 30),
        Spinning = true,
        HideSearchBar = true,
        Corner = 15,
        AnimatedTitle = {
            AnimationColor = Color3.fromRGB(220, 50, 50),
            AnimationSide = "Left",
            AnimationSpeed = 2
        }
    })
    
    self.Window:SetToggleKey(Enum.KeyCode.RightControl)

    local DecompilerTab = self.Window:Tab({
        Title = "Decompiler",
        Icon = "lock-open"
    })
    
    local SettingsTab = self.Window:Tab({
        Title = "Settings",
        Icon = "settings"
    })
    
    local AboutTab = self.Window:Tab({
        Title = "About",
        Icon = "info"
    })

    local LeftSection = DecompilerTab:Section({
        Side = "left"
    })
    
    local RightSection = DecompilerTab:Section({
        Side = "right"
    })

    local DecompilerModule = LeftSection:Module({
        Title = "Bytecode Decompiler",
        Desc = "Decompile any script by name",
        Flag = "decompiler_module",
        Locked = false,
        Callback = function(state)
        end
    })

    DecompilerModule:Input({
        Title = "Script Name",
        placeholder = "Enter script name...",
        Flag = "script_name_input",
        Locked = false,
        callback = function(text)
            self.Elements.ScriptName = text
        end
    })

    DecompilerModule:Button({
        Title = "Decompile Script",
        Locked = false,
        Callback = function()
            if self.Elements.OnDecompile then
                self.Elements.OnDecompile()
            end
        end
    })

    local OutputModule = RightSection:Module({
        Title = "Output",
        Desc = "Decompiled code will appear here",
        Flag = "output_module",
        Locked = false,
        Callback = function(state)
        end
    })

    OutputModule:Label({
        Text = "Waiting for input...",
        Title = "Result",
        Description = "Enter a script name and click Decompile",
        Default = true
    })

    local SettingsSection = SettingsTab:Section({
        Side = "left"
    })

    local SettingsModule = SettingsSection:Module({
        Title = "Options",
        Desc = "Configure decompiler settings",
        Flag = "settings_module",
        Locked = false,
        Callback = function(state)
        end
    })

    SettingsModule:Checkbox({
        Title = "Auto Copy to Clipboard",
        Flag = "auto_copy",
        Locked = false,
        Callback = function(state)
            self.Elements.AutoCopy = state
        end
    })

    SettingsModule:Checkbox({
        Title = "Show Notifications",
        Flag = "show_notifications",
        Locked = false,
        Callback = function(state)
            self.Elements.ShowNotifications = state
        end
    })

    SettingsModule:Checkbox({
        Title = "Detailed Output",
        Flag = "detailed_output",
        Locked = false,
        Callback = function(state)
            self.Elements.DetailedOutput = state
        end
    })

    local AboutSection = AboutTab:Section({
        Side = "left"
    })

    AboutSection:Label({
        Text = "Paradise Decompiler v1.0\n\nAutonomous bytecode decompiler for Roblox\n\nFeatures:\n• Automatic script search\n• Multi-location scanning\n• Beautiful modern UI\n• Fast and reliable\n\nCreated by Paradise Team",
        Title = "About Paradise",
        Description = "Professional decompiler tool",
        Default = true
    })

    AboutSection:Button({
        Title = "Join Discord",
        Locked = false,
        Callback = function()
            if self.Isotopia then
                self.Isotopia:Notify({
                    Title = "Discord",
                    Description = "Discord link copied to clipboard!",
                    Duration = 3
                })
            end
        end
    })

    self.Window:load()

    self.Elements.ScriptName = ""
    self.Elements.AutoCopy = false
    self.Elements.ShowNotifications = true
    self.Elements.DetailedOutput = false
    self.Elements.OutputModule = OutputModule

    return self.Elements
end

function UI:SetOutput(text, isError)
    if self.Elements.OutputModule then
        self.Elements.OutputModule:Label({
            Text = text,
            Title = isError and "Error" or "Result",
            Description = isError and "Failed to decompile" or "Successfully decompiled",
            Default = true
        })
    end
    
    if self.Elements.ShowNotifications and self.Isotopia then
        self.Isotopia:Notify({
            Title = isError and "Error" or "Success",
            Description = isError and "Failed to decompile script" or "Script decompiled successfully!",
            Duration = 3
        })
    end
end

function UI:Notify(title, description, duration)
    if self.Isotopia then
        self.Isotopia:Notify({
            Title = title,
            Description = description,
            Duration = duration or 3
        })
    end
end

return UI

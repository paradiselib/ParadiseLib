local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/paradiselib/ParadiseLib/main/UI.lua"))()

local function FindScript(name)
    local function searchInInstance(instance)
        for _, child in ipairs(instance:GetDescendants()) do
            if child:IsA("LuaSourceContainer") and child.Name == name then
                return child
            end
        end
        return nil
    end
    
    local locations = {
        game:GetService("Workspace"),
        game:GetService("ReplicatedStorage"),
        game:GetService("ServerScriptService"),
        game:GetService("StarterPlayer"),
        game:GetService("StarterGui"),
        game:GetService("StarterPack"),
        game:GetService("Players").LocalPlayer
    }
    
    for _, location in ipairs(locations) do
        local found = searchInInstance(location)
        if found then
            return found
        end
    end
    
    return nil
end

local function Decompile(scriptInstance)
    local success, result = pcall(function()
        if not scriptInstance then
            return "Error: Script not found"
        end
        
        local source = ""
        
        if scriptInstance:IsA("LocalScript") or scriptInstance:IsA("Script") or scriptInstance:IsA("ModuleScript") then
            local decompileSuccess, decompiled = pcall(function()
                return decompile(scriptInstance)
            end)
            
            if decompileSuccess and decompiled then
                source = decompiled
            else
                local getScriptSuccess, scriptSource = pcall(function()
                    return scriptInstance.Source
                end)
                
                if getScriptSuccess and scriptSource and scriptSource ~= "" then
                    source = scriptSource
                else
                    source = "-- Bytecode decompilation not available\n-- Script: " .. scriptInstance:GetFullName()
                end
            end
        else
            source = "Error: Not a valid script type"
        end
        
        return source
    end)
    
    if success then
        return result
    else
        return "Error: " .. tostring(result)
    end
end

local elements = UI:Create()

elements.DecompileButton.MouseButton1Click:Connect(function()
    local scriptName = elements.InputBox.Text
    
    if scriptName == "" then
        UI:SetOutput("Error: Please enter a script name", Color3.fromRGB(255, 100, 100))
        return
    end
    
    UI:SetOutput("Searching for script: " .. scriptName .. "...", Color3.fromRGB(255, 200, 100))
    task.wait(0.1)
    
    local scriptInstance = FindScript(scriptName)
    
    if not scriptInstance then
        UI:SetOutput("Error: Script '" .. scriptName .. "' not found in game", Color3.fromRGB(255, 100, 100))
        return
    end
    
    UI:SetOutput("Found script at: " .. scriptInstance:GetFullName() .. "\n\nDecompiling...", Color3.fromRGB(100, 255, 100))
    task.wait(0.2)
    
    local decompiledCode = Decompile(scriptInstance)
    UI:SetOutput("Script: " .. scriptInstance:GetFullName() .. "\n" .. string.rep("-", 50) .. "\n\n" .. decompiledCode, Color3.fromRGB(200, 200, 200))
end)

elements.CloseButton.MouseButton1Click:Connect(function()
    elements.ScreenGui:Destroy()
end)

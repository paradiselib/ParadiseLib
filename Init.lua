local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/paradiselib/ParadiseLib/main/UI.lua?v=" .. tick()))()

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

elements.OnDecompile = function()
    local scriptName = elements.ScriptName
    
    if scriptName == "" then
        UI:SetOutput("Please enter a script name", true)
        return
    end
    
    UI:Notify("Searching", "Looking for script: " .. scriptName, 2)
    
    task.wait(0.1)
    
    local scriptInstance = FindScript(scriptName)
    
    if not scriptInstance then
        UI:SetOutput("Script '" .. scriptName .. "' not found in game", true)
        return
    end
    
    UI:Notify("Found", "Script found at: " .. scriptInstance:GetFullName(), 2)
    
    task.wait(0.2)
    
    local decompiledCode = Decompile(scriptInstance)
    
    UI:SetOutput("Script: " .. scriptInstance:GetFullName() .. "\n" .. string.rep("-", 50) .. "\n\n" .. decompiledCode, false)
    
    if elements.AutoCopy then
        setclipboard(decompiledCode)
        UI:Notify("Copied", "Code copied to clipboard!", 2)
    end
end

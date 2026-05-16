local Core = {}

function Core:FindScript(name)
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

function Core:Decompile(scriptInstance)
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

return Core

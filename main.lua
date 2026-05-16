local GUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/paradiselib/ParadiseLib/main/gui.lua"))()
local Core = loadstring(game:HttpGet("https://raw.githubusercontent.com/paradiselib/ParadiseLib/main/core.lua"))()

local Paradise = {}

function Paradise:Init()
    local screenGui = GUI:CreateInterface()
    
    GUI.DecompileButton.MouseButton1Click:Connect(function()
        local scriptName = GUI.InputBox.Text
        
        if scriptName == "" then
            GUI:SetOutput("Error: Please enter a script name", Color3.fromRGB(255, 100, 100))
            return
        end
        
        GUI:SetOutput("Searching for script: " .. scriptName .. "...", Color3.fromRGB(255, 200, 100))
        task.wait(0.1)
        
        local scriptInstance = Core:FindScript(scriptName)
        
        if not scriptInstance then
            GUI:SetOutput("Error: Script '" .. scriptName .. "' not found in game", Color3.fromRGB(255, 100, 100))
            return
        end
        
        GUI:SetOutput("Found script at: " .. scriptInstance:GetFullName() .. "\n\nDecompiling...", Color3.fromRGB(100, 255, 100))
        task.wait(0.2)
        
        local decompiledCode = Core:Decompile(scriptInstance)
        GUI:SetOutput("Script: " .. scriptInstance:GetFullName() .. "\n" .. string.rep("-", 50) .. "\n\n" .. decompiledCode, Color3.fromRGB(200, 200, 200))
    end)
    
    GUI.CloseButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)
end

Paradise:Init()

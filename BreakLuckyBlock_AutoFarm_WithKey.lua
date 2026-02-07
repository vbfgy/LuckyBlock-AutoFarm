--[[
    Break-a-Lucky-Block Auto Farm v4.0 + Key System
    ✅ Ломает блоки
    ✅ Собирает Brainrot
    ✅ Возвращается на базу
    🔐 Система верификации
]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- Система ключей
local KeySystem = {
    ValidKeys = {"qwerty-poiu-0987"},
    DiscordLink = "https://discord.gg/yeWd226pRE",
    Verified = false
}

-- Проверка ключа
local function CheckKey(inputKey)
    for _, validKey in pairs(KeySystem.ValidKeys) do
        if inputKey == validKey then return true end
    end
    return false
end

-- GUI верификации
local function CreateKeyGUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "KeySystemGUI"
    ScreenGui.ResetOnSpawn = false
    
    local existing = LocalPlayer.PlayerGui:FindFirstChild("KeySystemGUI")
    if existing then existing:Destroy() end
    
    ScreenGui.Parent = LocalPlayer.PlayerGui
    
    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0, 400, 0, 310)
    Main.Position = UDim2.new(0.5, -200, 0.5, -155)
    Main.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    Main.Active = true
    Main.Draggable = true
    Main.Parent = ScreenGui
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -40, 0, 40)
    Title.Position = UDim2.new(0, 20, 0, 15)
    Title.BackgroundTransparency = 1
    Title.Text = "🔐 Система Верификации"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 20
    Title.Font = Enum.Font.GothamBold
    Title.Parent = Main
    
    local Subtitle = Instance.new("TextLabel")
    Subtitle.Size = UDim2.new(1, -40, 0, 30)
    Subtitle.Position = UDim2.new(0, 20, 0, 55)
    Subtitle.BackgroundTransparency = 1
    Subtitle.Text = "Break Lucky Block Auto Farm v4.0"
    Subtitle.TextColor3 = Color3.fromRGB(150, 150, 150)
    Subtitle.TextSize = 14
    Subtitle.Font = Enum.Font.Gotham
    Subtitle.Parent = Main
    
    local DiscordFrame = Instance.new("Frame")
    DiscordFrame.Size = UDim2.new(1, -40, 0, 60)
    DiscordFrame.Position = UDim2.new(0, 20, 0, 95)
    DiscordFrame.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    DiscordFrame.Parent = Main
    Instance.new("UICorner", DiscordFrame).CornerRadius = UDim.new(0, 8)
    
    local DiscordText = Instance.new("TextLabel")
    DiscordText.Size = UDim2.new(1, -20, 1, -20)
    DiscordText.Position = UDim2.new(0, 10, 0, 10)
    DiscordText.BackgroundTransparency = 1
    DiscordText.Text = "📢 Зайдите на наш Discord сервер\nчтобы получить ключ!"
    DiscordText.TextColor3 = Color3.fromRGB(255, 255, 255)
    DiscordText.TextSize = 13
    DiscordText.Font = Enum.Font.GothamBold
    DiscordText.TextWrapped = true
    DiscordText.Parent = DiscordFrame
    
    local CopyDiscord = Instance.new("TextButton")
    CopyDiscord.Size = UDim2.new(1, -40, 0, 35)
    CopyDiscord.Position = UDim2.new(0, 20, 0, 165)
    CopyDiscord.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    CopyDiscord.Text = "📋 Скопировать Discord ссылку"
    CopyDiscord.TextColor3 = Color3.fromRGB(255, 255, 255)
    CopyDiscord.TextSize = 12
    CopyDiscord.Font = Enum.Font.GothamBold
    CopyDiscord.AutoButtonColor = false
    CopyDiscord.Parent = Main
    Instance.new("UICorner", CopyDiscord).CornerRadius = UDim.new(0, 8)
    
    CopyDiscord.MouseButton1Click:Connect(function()
        setclipboard(KeySystem.DiscordLink)
        CopyDiscord.Text = "✅ Ссылка скопирована!"
        task.wait(2)
        CopyDiscord.Text = "📋 Скопировать Discord ссылку"
    end)

    
    local KeyInput = Instance.new("TextBox")
    KeyInput.Size = UDim2.new(1, -40, 0, 40)
    KeyInput.Position = UDim2.new(0, 20, 0, 210)
    KeyInput.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    KeyInput.Text = ""
    KeyInput.PlaceholderText = "Введите ключ..."
    KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyInput.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
    KeyInput.TextSize = 14
    KeyInput.Font = Enum.Font.Gotham
    KeyInput.ClearTextOnFocus = false
    KeyInput.Parent = Main
    Instance.new("UICorner", KeyInput).CornerRadius = UDim.new(0, 8)
    Instance.new("UIPadding", KeyInput).PaddingLeft = UDim.new(0, 15)
    
    local VerifyBtn = Instance.new("TextButton")
    VerifyBtn.Size = UDim2.new(1, -40, 0, 40)
    VerifyBtn.Position = UDim2.new(0, 20, 0, 260)
    VerifyBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 90)
    VerifyBtn.Text = "✅ Проверить ключ"
    VerifyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    VerifyBtn.TextSize = 14
    VerifyBtn.Font = Enum.Font.GothamBold
    VerifyBtn.AutoButtonColor = false
    VerifyBtn.Parent = Main
    Instance.new("UICorner", VerifyBtn).CornerRadius = UDim.new(0, 8)
    
    VerifyBtn.MouseButton1Click:Connect(function()
        local inputKey = KeyInput.Text:gsub("^%s*(.-)%s*$", "%1")
        
        if inputKey == "" then
            VerifyBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
            VerifyBtn.Text = "❌ Введите ключ!"
            task.wait(2)
            VerifyBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 90)
            VerifyBtn.Text = "✅ Проверить ключ"
            return
        end
        
        if CheckKey(inputKey) then
            VerifyBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
            VerifyBtn.Text = "✅ Ключ верный! Загрузка..."
            
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Верификация успешна!";
                Text = "Загрузка скрипта...";
                Duration = 3;
            })
            
            task.wait(1)
            KeySystem.Verified = true
            ScreenGui:Destroy()
            
            -- Загружаем основной скрипт
            loadstring(game:HttpGet('https://raw.githubusercontent.com/vbfgy/BreakLuckyBlock_AutoFarm/refs/heads/main/BreakLuckyBlock_AutoFarm_NoKey.lua'))()
        else
            VerifyBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
            VerifyBtn.Text = "❌ Неверный ключ!"
            task.wait(2)
            VerifyBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 90)
            VerifyBtn.Text = "✅ Проверить ключ"
        end
    end)
    
    Main.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Back), {
        Size = UDim2.new(0, 400, 0, 310)
    }):Play()
end

-- Запуск
CreateKeyGUI()

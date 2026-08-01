-- // =================================================================
-- // RB ZOO SUPER PREMIUM 2026 - ULTIMATE V6.5 (SMART WALL BYPASS EDITION)
-- // COPYRIGHT © 2026 TRẦN LÊ GIA BẢO. ALL RIGHTS RESERVED.
-- // Engineered with Real-Time Hunter AI, Quad-Cache & Anti-Lag Engine.
-- // Integrated with Secure Key System & Admin Bypass Code.
-- // =================================================================

local Engine = {
    Services = {},
    Modules = {},
    Cache = { Animals = {}, Zookeepers = {}, Oofs = {}, Prompts = {}, LastScan = 0, TotalKills = 0 },
    State = { CurrentRole = "NEUTRAL", CurrentTarget = nil, TargetModel = nil, FarmConnections = {} },
    Status = "Booting",
    Author = "Trần Lê Gia Bảo"
}

-- ==========================================
-- [1] SERVICES & GLOBALS
-- ==========================================
Engine.Services = {
    Players = game:GetService("Players"),
    RunService = game:GetService("RunService"),
    UIS = game:GetService("UserInputService"),
    Workspace = game:GetService("Workspace"),
    HttpService = game:GetService("HttpService"),
    TweenService = game:GetService("TweenService"),
    VirtualUser = game:GetService("VirtualUser"),
    VirtualInputManager = game:GetService("VirtualInputManager"),
    ReplicatedStorage = game:GetService("ReplicatedStorage")
}

local LocalPlayer = Engine.Services.Players.LocalPlayer
local Camera = Engine.Services.Workspace.CurrentCamera

-- ==========================================
-- [2] CONFIG MANAGER
-- ==========================================
Engine.Modules.ConfigManager = {
    Settings = {
        Aimbot = false, AimbotSmooth = 0.2, AimbotFOV = 250, WallCheck = true, Prediction = false, PredictionAmount = 0.13,
        Fly = false, FlySpeed = 120, Speed = false, SpeedValue = 20, Noclip = false, InfJump = false, HitboxSize = 4,
        AutoAttack = true, AutoSkill = true, AutoMoney = true, AntiAFK = true, ShowHUD = true, FPSBooster = true,
        AutoFarm = false, AutoFarmHeight = 700, AutoFarmSpeed = 75, SmartMovement = true, AntiStuck = true,
        ForceZookeeper = true, SmartWallBypass = true
    },
    File = "RBZoo_Smart_Config_V6_5.json",
    
    Load = function(self)
        if isfile and readfile and isfile(self.File) then
            pcall(function()
                local decoded = Engine.Services.HttpService:JSONDecode(readfile(self.File))
                for k, v in pairs(decoded) do
                    if self.Settings[k] ~= nil then self.Settings[k] = v end
                end
            end)
        end
    end,
    
    Save = function(self)
        pcall(function()
            if writefile then
                writefile(self.File, Engine.Services.HttpService:JSONEncode(self.Settings))
            end
        end)
    end
}

-- ==========================================
-- [3] FPS & PERFORMANCE BOOSTER ENGINE
-- ==========================================
Engine.Modules.PerformanceBooster = {
    Init = function(self)
        if not Engine.Modules.ConfigManager.Settings.FPSBooster then return end
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            Engine.Services.Workspace.GlobalShadows = false
            for _, v in ipairs(Engine.Services.Workspace:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CastShadow = false
                elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") then
                    v.Enabled = false
                end
            end
        end)
    end
}

-- ==========================================
-- [4] LOADING SCREEN ENGINE (5 SECONDS)
-- ==========================================
Engine.Modules.LoadingScreen = {
    Show = function(self)
        local coreGui = LocalPlayer:WaitForChild("PlayerGui")
        local sg = Instance.new("ScreenGui")
        sg.Name = "RBZoo_V6_LoadingScreen"
        sg.ResetOnSpawn = false
        sg.Parent = coreGui

        local bg = Instance.new("Frame")
        bg.Size = UDim2.new(1, 0, 1, 0)
        bg.BackgroundColor3 = Color3.fromRGB(8, 10, 16)
        bg.BackgroundTransparency = 0.05
        bg.Parent = sg

        local card = Instance.new("Frame")
        card.Size = UDim2.new(0, 440, 0, 220)
        card.Position = UDim2.new(0.5, -220, 0.5, -110)
        card.BackgroundColor3 = Color3.fromRGB(15, 20, 32)
        card.BackgroundTransparency = 0.15
        card.Parent = bg
        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 16)

        local stroke = Instance.new("UIStroke")
        stroke.Thickness = 2
        stroke.Color = Color3.fromRGB(0, 255, 180)
        stroke.Parent = card

        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, 0, 0, 40)
        title.Position = UDim2.new(0, 0, 0, 18)
        title.BackgroundTransparency = 1
        title.Text = "⚡ RB ZOO ULTIMATE V6.5"
        title.Font = Enum.Font.GothamBlack
        title.TextSize = 18
        title.TextColor3 = Color3.fromRGB(0, 255, 180)
        title.Parent = card

        local sub = Instance.new("TextLabel")
        sub.Size = UDim2.new(1, 0, 0, 20)
        sub.Position = UDim2.new(0, 0, 0, 56)
        sub.BackgroundTransparency = 1
        sub.Text = "Bản quyền thuộc về: " .. Engine.Author .. " • Fix Lag & Smart Wall Bypass"
        sub.Font = Enum.Font.GothamBold
        sub.TextSize = 10
        sub.TextColor3 = Color3.fromRGB(190, 205, 225)
        sub.Parent = card

        local barBg = Instance.new("Frame")
        barBg.Size = UDim2.new(0.85, 0, 0, 10)
        barBg.Position = UDim2.new(0.075, 0, 0, 110)
        barBg.BackgroundColor3 = Color3.fromRGB(30, 38, 55)
        barBg.Parent = card
        Instance.new("UICorner", barBg).CornerRadius = UDim.new(1, 0)

        local barFill = Instance.new("Frame")
        barFill.Size = UDim2.new(0, 0, 1, 0)
        barFill.BackgroundColor3 = Color3.fromRGB(0, 255, 180)
        barFill.Parent = barBg
        Instance.new("UICorner", barFill).CornerRadius = UDim.new(1, 0)

        local percentLabel = Instance.new("TextLabel")
        percentLabel.Size = UDim2.new(1, 0, 0, 20)
        percentLabel.Position = UDim2.new(0, 0, 0, 130)
        percentLabel.BackgroundTransparency = 1
        percentLabel.Text = "0%"
        percentLabel.Font = Enum.Font.GothamBlack
        percentLabel.TextSize = 13
        percentLabel.TextColor3 = Color3.fromRGB(0, 255, 180)
        percentLabel.Parent = card

        local statusLabel = Instance.new("TextLabel")
        statusLabel.Size = UDim2.new(1, 0, 0, 20)
        statusLabel.Position = UDim2.new(0, 0, 0, 160)
        statusLabel.BackgroundTransparency = 1
        statusLabel.Text = "Khởi động hệ thống..."
        statusLabel.Font = Enum.Font.GothamMedium
        statusLabel.TextSize = 10
        statusLabel.TextColor3 = Color3.fromRGB(150, 165, 185)
        statusLabel.Parent = card

        local steps = {
            {time = 1.0, text = "[1/5] Nạp Service & Cấu hình Config..."},
            {time = 2.0, text = "[2/5] Kích hoạt Engine Tối ưu hóa FPS..."},
            {time = 3.0, text = "[3/5] Khắc phục góc bắn dính tường (Smart Wall Bypass)..."},
            {time = 4.0, text = "[4/5] Kết nối Hunter AI & Kiểm tra Key xác thực..."},
            {time = 5.0, text = "[5/5] Tải hoàn tất!"}
        }

        local startTime = tick()
        while tick() - startTime < 5.0 do
            local elapsed = tick() - startTime
            local progress = math.clamp(elapsed / 5.0, 0, 1)

            barFill.Size = UDim2.new(progress, 0, 1, 0)
            percentLabel.Text = math.floor(progress * 100) .. "%"

            if elapsed < 1.0 then statusLabel.Text = steps[1].text
            elseif elapsed < 2.0 then statusLabel.Text = steps[2].text
            elseif elapsed < 3.0 then statusLabel.Text = steps[3].text
            elseif elapsed < 4.0 then statusLabel.Text = steps[4].text
            else statusLabel.Text = steps[5].text
            end

            Engine.Services.RunService.RenderStepped:Wait()
        end

        barFill.Size = UDim2.new(1, 0, 1, 0)
        percentLabel.Text = "100%"
        task.wait(0.2)

        Engine.Services.TweenService:Create(bg, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
        Engine.Services.TweenService:Create(card, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
        Engine.Services.TweenService:Create(stroke, TweenInfo.new(0.4), {Transparency = 1}):Play()
        task.wait(0.4)
        sg:Destroy()
    end
}

-- ==========================================
-- [4.5] KEY SYSTEM & ADMIN BYPASS MODULE (ONLINE CHECK)
-- ==========================================
Engine.Modules.KeySystem = {
    KeyURL = "https://tlgbgetkey.netlify.app/",
    OnlineKeyListURL = "https://raw.githubusercontent.com/giabaotranle04112011/getkey/main/keys.json",
    KeySaveFile = "RBZoo_SavedKey_V6.json",
    AdminKey = "14142022",
    CurrentKey = nil,
    CurrentKeyType = nil,

    ValidateKeyFormat = function(self, inputKey)
        if not inputKey or typeof(inputKey) ~= "string" then return false, "EMPTY" end
        inputKey = inputKey:gsub("%s+", "") -- Bỏ khoảng trắng
        
        -- Kiểm tra mã Admin
        if inputKey == self.AdminKey then
            return true, "ADMIN"
        end

        -- Kiểm tra định dạng Key từ Web: TLGB-XXXX-XXXX
        local b1, b2 = inputKey:match("^TLGB%-([A-Z0-9]+)%-([A-Z0-9]+)$")
        if b1 and b2 and #b1 == 4 and #b2 == 4 then
            return true, "USER"
        end

        return false, "INVALID"
    end,

    VerifyKeyOnline = function(self, inputKey)
        local isValidFormat, keyType = self:ValidateKeyFormat(inputKey)
        if not isValidFormat then
            return false, "Cú pháp Key không đúng!"
        end
        
        if keyType == "ADMIN" then
            return true, "ADMIN"
        end

        -- Tải danh sách Key từ GitHub (có query nocache để cập nhật ngay lập tức)
        local success, response = pcall(function()
            return game:HttpGet(self.OnlineKeyListURL .. "?nocache=" .. tostring(tick()))
        end)

        if not success or not response then
            return false, "Lỗi kết nối Server xác minh Key!"
        end

        local decodeSuccess, validKeys = pcall(function()
            return Engine.Services.HttpService:JSONDecode(response)
        end)

        if not decodeSuccess or typeof(validKeys) ~= "table" then
            return false, "Dữ liệu Server Key bị lỗi!"
        end

        -- Đối chiếu xem Key nhập có nằm trong danh sách GitHub không
        for _, validKey in ipairs(validKeys) do
            if validKey == inputKey then
                return true, "USER"
            end
        end

        return false, "Key không tồn tại trên hệ thống!"
    end,

    CheckSavedKey = function(self)
        if isfile and readfile and isfile(self.KeySaveFile) then
            local success, result = pcall(function()
                return Engine.Services.HttpService:JSONDecode(readfile(self.KeySaveFile))
            end)
            if success and result and result.Key and result.Timestamp then
                local isValidOnline, keyType = self:VerifyKeyOnline(result.Key)
                if isValidOnline then
                    if keyType == "ADMIN" or (os.time() - result.Timestamp < 86400) then
                        self.CurrentKey = result.Key
                        self.CurrentKeyType = keyType
                        return true, result.Key, keyType
                    end
                end
            end
        end
        return false, nil, nil
    end,

    SaveKeyLocally = function(self, key, keyType)
        if writefile then
            pcall(function()
                local data = { Key = key, Timestamp = os.time() }
                writefile(self.KeySaveFile, Engine.Services.HttpService:JSONEncode(data))
                self.CurrentKey = key
                self.CurrentKeyType = keyType
            end)
        end
    end,

    GetRemainingTime = function(self)
        if not self.CurrentKey then
            self:CheckSavedKey()
        end
        if self.CurrentKeyType == "ADMIN" then
            return "Vĩnh viễn (Admin)"
        end
        if isfile and readfile and isfile(self.KeySaveFile) then
            local success, result = pcall(function()
                return Engine.Services.HttpService:JSONDecode(readfile(self.KeySaveFile))
            end)
            if success and result and result.Timestamp then
                local elapsed = os.time() - result.Timestamp
                local remaining = 86400 - elapsed
                if remaining <= 0 then
                    return "Đã hết hạn!"
                end
                local hours = math.floor(remaining / 3600)
                local mins = math.floor((remaining % 3600) / 60)
                local secs = remaining % 60
                return string.format("%02dh %02dm %02ds", hours, mins, secs)
            end
        end
        return "N/A"
    end,

    Logout = function(self)
        pcall(function()
            if delfile and isfile and isfile(self.KeySaveFile) then
                delfile(self.KeySaveFile)
            elseif writefile then
                writefile(self.KeySaveFile, "")
            end
        end)
        
        self.CurrentKey = nil
        self.CurrentKeyType = nil
        Engine.Modules.FarmManager:Stop()
        
        local coreGui = LocalPlayer:WaitForChild("PlayerGui")
        for _, guiName in ipairs({"RBZoo_V6_UI_LiquidGlass", "RBZoo_Hunter_HUD_V6", "RBZoo_V6_Notifications"}) do
            local g = coreGui:FindFirstChild(guiName)
            if g then g:Destroy() end
        end
        
        table.clear(Engine.Modules.UIController.ChromaObjects)
        
        task.spawn(function()
            local keyVerified = self:PromptKeyUI()
            if keyVerified then
                Engine:BootAfterKey()
            end
        end)
    end,

    PromptKeyUI = function(self)
        local isAlreadyValid, savedKey, keyType = self:CheckSavedKey()
        if isAlreadyValid then
            return true
        end

        local verified = false
        local coreGui = LocalPlayer:WaitForChild("PlayerGui")
        
        local sg = Instance.new("ScreenGui")
        sg.Name = "RBZoo_KeySystem_UI"
        sg.ResetOnSpawn = false
        sg.Parent = coreGui

        local bg = Instance.new("Frame")
        bg.Size = UDim2.new(1, 0, 1, 0)
        bg.BackgroundColor3 = Color3.fromRGB(8, 10, 16)
        bg.BackgroundTransparency = 0.2
        bg.Parent = sg

        local card = Instance.new("Frame")
        card.Size = UDim2.new(0, 420, 0, 260)
        card.Position = UDim2.new(0.5, -210, 0.5, -130)
        card.BackgroundColor3 = Color3.fromRGB(15, 20, 32)
        card.Parent = bg
        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 16)

        local stroke = Instance.new("UIStroke")
        stroke.Thickness = 2
        stroke.Color = Color3.fromRGB(0, 210, 255)
        stroke.Parent = card

        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, 0, 0, 35)
        title.Position = UDim2.new(0, 0, 0, 15)
        title.BackgroundTransparency = 1
        title.Text = "🔐 HỆ THỐNG XÁC THỰC KEY"
        title.Font = Enum.Font.GothamBlack
        title.TextSize = 16
        title.TextColor3 = Color3.fromRGB(0, 210, 255)
        title.Parent = card

        local desc = Instance.new("TextLabel")
        desc.Size = UDim2.new(1, -40, 0, 30)
        desc.Position = UDim2.new(0, 20, 0, 48)
        desc.BackgroundTransparency = 1
        desc.Text = "Vui lòng lấy Key tại trang web hoặc nhập Mã Admin để tiếp tục sử dụng Script."
        desc.Font = Enum.Font.GothamMedium
        desc.TextSize = 11
        desc.TextColor3 = Color3.fromRGB(180, 195, 215)
        desc.TextWrapped = true
        desc.Parent = card

        local textBoxBg = Instance.new("Frame")
        textBoxBg.Size = UDim2.new(0.85, 0, 0, 42)
        textBoxBg.Position = UDim2.new(0.075, 0, 0, 90)
        textBoxBg.BackgroundColor3 = Color3.fromRGB(25, 32, 48)
        textBoxBg.Parent = card
        Instance.new("UICorner", textBoxBg).CornerRadius = UDim.new(0, 10)

        local tbStroke = Instance.new("UIStroke")
        tbStroke.Thickness = 1
        tbStroke.Color = Color3.fromRGB(0, 210, 255)
        tbStroke.Transparency = 0.5
        tbStroke.Parent = textBoxBg

        local keyBox = Instance.new("TextBox")
        keyBox.Size = UDim2.new(1, -20, 1, 0)
        keyBox.Position = UDim2.new(0, 10, 0, 0)
        keyBox.BackgroundTransparency = 1
        keyBox.PlaceholderText = "Nhập Key (TLGB-XXXX-XXXX) hoặc Mã Admin..."
        keyBox.PlaceholderColor3 = Color3.fromRGB(110, 125, 145)
        keyBox.Text = ""
        keyBox.Font = Enum.Font.GothamBold
        keyBox.TextSize = 12
        keyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        keyBox.Parent = textBoxBg

        local statusLabel = Instance.new("TextLabel")
        statusLabel.Size = UDim2.new(1, 0, 0, 20)
        statusLabel.Position = UDim2.new(0, 0, 0, 138)
        statusLabel.BackgroundTransparency = 1
        statusLabel.Text = ""
        statusLabel.Font = Enum.Font.GothamBold
        statusLabel.TextSize = 11
        statusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        statusLabel.Parent = card

        local btnGetKey = Instance.new("TextButton")
        btnGetKey.Size = UDim2.new(0.4, 0, 0, 40)
        btnGetKey.Position = UDim2.new(0.075, 0, 0, 168)
        btnGetKey.BackgroundColor3 = Color3.fromRGB(30, 40, 60)
        btnGetKey.Text = "🌐 LẤY KEY"
        btnGetKey.Font = Enum.Font.GothamBlack
        btnGetKey.TextSize = 12
        btnGetKey.TextColor3 = Color3.fromRGB(0, 210, 255)
        btnGetKey.Parent = card
        Instance.new("UICorner", btnGetKey).CornerRadius = UDim.new(0, 10)

        local btnVerify = Instance.new("TextButton")
        btnVerify.Size = UDim2.new(0.4, 0, 0, 40)
        btnVerify.Position = UDim2.new(0.525, 0, 0, 168)
        btnVerify.BackgroundColor3 = Color3.fromRGB(0, 210, 255)
        btnVerify.Text = "✔️ XÁC NHẬN KEY"
        btnVerify.Font = Enum.Font.GothamBlack
        btnVerify.TextSize = 12
        btnVerify.TextColor3 = Color3.fromRGB(10, 15, 25)
        btnVerify.Parent = card
        Instance.new("UICorner", btnVerify).CornerRadius = UDim.new(0, 10)

        local authorSub = Instance.new("TextLabel")
        authorSub.Size = UDim2.new(1, 0, 0, 20)
        authorSub.Position = UDim2.new(0, 0, 0, 222)
        authorSub.BackgroundTransparency = 1
        authorSub.Text = "Bản quyền: " .. Engine.Author .. " • Key có hiệu lực 24h"
        authorSub.Font = Enum.Font.GothamMedium
        authorSub.TextSize = 9
        authorSub.TextColor3 = Color3.fromRGB(100, 115, 135)
        authorSub.Parent = card

        btnGetKey.MouseButton1Click:Connect(function()
            if setclipboard or toclipboard then
                (setclipboard or toclipboard)(self.KeyURL)
                statusLabel.TextColor3 = Color3.fromRGB(0, 255, 170)
                statusLabel.Text = "✓ Đã sao chép Link Get Key vào bộ nhớ tạm!"
            else
                statusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
                statusLabel.Text = "Link: " .. self.KeyURL
            end
        end)

        btnVerify.MouseButton1Click:Connect(function()
            local input = keyBox.Text
            statusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
            statusLabel.Text = "⏳ Đang kết nối Server kiểm tra Key..."

            task.spawn(function()
                local isValidOnline, resultMessage = self:VerifyKeyOnline(input)

                if isValidOnline then
                    self:SaveKeyLocally(input, resultMessage)
                    statusLabel.TextColor3 = Color3.fromRGB(0, 255, 170)
                    if resultMessage == "ADMIN" then
                        statusLabel.Text = "👑 Đã kích hoạt CHẾ ĐỘ ADMIN BYPASS!"
                    else
                        statusLabel.Text = "✓ Key hợp lệ! Đang mở Script..."
                    end
                    task.wait(0.8)
                    verified = true
                    sg:Destroy()
                else
                    statusLabel.TextColor3 = Color3.fromRGB(255, 70, 70)
                    statusLabel.Text = "❌ " .. tostring(resultMessage)
                end
            end)
        end)

        repeat task.wait(0.1) until verified
        return true
    end
}

-- ==========================================
-- [5] FORCE ZOOKEEPER ENGINE (100% ZOO MODE)
-- ==========================================
Engine.Modules.TeamForce = {
    Init = function(self)
        task.spawn(function()
            while task.wait(1.5) do
                if Engine.Modules.ConfigManager.Settings.ForceZookeeper then
                    self:TryForceZoo()
                end
            end
        end)
    end,

    TryForceZoo = function(self)
        pcall(function()
            for _, v in ipairs(Engine.Services.ReplicatedStorage:GetDescendants()) do
                if v:IsA("RemoteEvent") then
                    local name = v.Name:lower()
                    if name:find("team") or name:find("role") or name:find("select") or name:find("zoo") then
                        v:FireServer("Zookeeper")
                        v:FireServer("Zoo")
                        v:FireServer(1)
                    end
                elseif v:IsA("RemoteFunction") then
                    local name = v.Name:lower()
                    if name:find("team") or name:find("role") or name:find("select") or name:find("zoo") then
                        v:InvokeServer("Zookeeper")
                        v:InvokeServer("Zoo")
                        v:InvokeServer(1)
                    end
                end
            end

            for _, prompt in ipairs(Engine.Cache.Prompts) do
                if prompt.Prompt and prompt.Prompt.Parent then
                    local pName = prompt.Prompt.Parent.Name:lower()
                    if pName:find("zoo") or pName:find("keeper") then
                        if fireproximityprompt then fireproximityprompt(prompt.Prompt) end
                    end
                end
            end
        end)
    end
}

-- ==========================================
-- [6] NOTIFICATION MANAGER (LIQUID GLASS)
-- ==========================================
Engine.Modules.NotificationManager = {
    Container = nil,
    Init = function(self)
        local coreGui = LocalPlayer:WaitForChild("PlayerGui")
        local sg = Instance.new("ScreenGui")
        sg.Name = "RBZoo_V6_Notifications"
        sg.ResetOnSpawn = false
        sg.Parent = coreGui
        
        self.Container = Instance.new("Frame")
        self.Container.Size = UDim2.new(0, 320, 1, -20)
        self.Container.Position = UDim2.new(1, -340, 0, 10)
        self.Container.BackgroundTransparency = 1
        self.Container.Parent = sg
        
        local layout = Instance.new("UIListLayout")
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
        layout.Padding = UDim.new(0, 10)
        layout.Parent = self.Container
    end,
    
    Notify = function(self, title, text, duration)
        duration = duration or 3.5
        if not self.Container then self:Init() end
        
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 65)
        frame.BackgroundColor3 = Color3.fromRGB(15, 20, 32)
        frame.BackgroundTransparency = 1
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)
        
        local stroke = Instance.new("UIStroke")
        stroke.Thickness = 1.5
        stroke.Transparency = 1
        stroke.Color = Color3.fromRGB(0, 255, 200)
        stroke.Parent = frame
        
        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(1, -15, 0, 25)
        titleLabel.Position = UDim2.new(0, 15, 0, 5)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = title
        titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        titleLabel.TextTransparency = 1
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.TextSize = 13
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Parent = frame
        
        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1, -15, 0, 25)
        textLabel.Position = UDim2.new(0, 15, 0, 30)
        textLabel.BackgroundTransparency = 1
        textLabel.Text = text
        textLabel.TextColor3 = Color3.fromRGB(210, 220, 235)
        textLabel.TextTransparency = 1
        textLabel.Font = Enum.Font.GothamMedium
        textLabel.TextSize = 11
        textLabel.TextXAlignment = Enum.TextXAlignment.Left
        textLabel.Parent = frame
        
        frame.Parent = self.Container
        
        local TweenInfoIn = TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        Engine.Services.TweenService:Create(frame, TweenInfoIn, {BackgroundTransparency = 0.3}):Play()
        Engine.Services.TweenService:Create(stroke, TweenInfoIn, {Transparency = 0.4}):Play()
        Engine.Services.TweenService:Create(titleLabel, TweenInfoIn, {TextTransparency = 0}):Play()
        Engine.Services.TweenService:Create(textLabel, TweenInfoIn, {TextTransparency = 0}):Play()
        
        task.delay(duration, function()
            if frame and frame.Parent then
                Engine.Services.TweenService:Create(frame, TweenInfoIn, {BackgroundTransparency = 1}):Play()
                Engine.Services.TweenService:Create(stroke, TweenInfoIn, {Transparency = 1}):Play()
                Engine.Services.TweenService:Create(titleLabel, TweenInfoIn, {TextTransparency = 1}):Play()
                Engine.Services.TweenService:Create(textLabel, TweenInfoIn, {TextTransparency = 1}):Play()
                task.wait(0.4)
                frame:Destroy()
            end
        end)
    end
}

-- ==========================================
-- [7] HUNTER HUD MODULE
-- ==========================================
Engine.Modules.HunterHUD = {
    Gui = nil,
    Labels = {},
    
    Init = function(self)
        local coreGui = LocalPlayer:WaitForChild("PlayerGui")
        local sg = Instance.new("ScreenGui")
        sg.Name = "RBZoo_Hunter_HUD_V6"
        sg.ResetOnSpawn = false
        sg.Parent = coreGui
        self.Gui = sg
        
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0, 240, 0, 175)
        frame.Position = UDim2.new(0, 15, 0.3, 0)
        frame.BackgroundColor3 = Color3.fromRGB(12, 16, 26)
        frame.BackgroundTransparency = 0.32
        frame.Active = true
        frame.Draggable = true
        frame.Parent = sg
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 14)
        
        local stroke = Instance.new("UIStroke")
        stroke.Thickness = 1.5
        stroke.Color = Color3.fromRGB(0, 255, 170)
        stroke.Transparency = 0.3
        stroke.Parent = frame
        
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, 0, 0, 26)
        title.BackgroundTransparency = 1
        title.Text = "⚡ ZOOKEEPER HUNTER V6.5"
        title.Font = Enum.Font.GothamBlack
        title.TextSize = 11
        title.TextColor3 = Color3.fromRGB(0, 255, 170)
        title.Parent = frame
        
        local list = Instance.new("UIListLayout")
        list.Padding = UDim.new(0, 2)
        list.SortOrder = Enum.SortOrder.LayoutOrder
        list.Parent = frame
        
        title.LayoutOrder = 0
        
        local function addLabel(key, defaultText)
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -20, 0, 18)
            lbl.Position = UDim2.new(0, 10, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = defaultText
            lbl.Font = Enum.Font.GothamBold
            lbl.TextSize = 10
            lbl.TextColor3 = Color3.fromRGB(220, 230, 245)
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = frame
            self.Labels[key] = lbl
            return lbl
        end
        
        addLabel("Target", "Target: None").LayoutOrder = 1
        addLabel("Distance", "Distance: N/A").LayoutOrder = 2
        addLabel("Status", "Status: Idle").LayoutOrder = 3
        addLabel("OofAlive", "OOF Alive: 0").LayoutOrder = 4
        addLabel("Kills", "Total Kills: 0").LayoutOrder = 5
        addLabel("KeyTime", "⏳ Key Hạn: N/A").LayoutOrder = 6
        addLabel("Author", "Owner: " .. Engine.Author).LayoutOrder = 7
        
        Engine.Services.RunService.RenderStepped:Connect(function()
            if not Engine.Modules.ConfigManager.Settings.ShowHUD then
                frame.Visible = false
                return
            end
            frame.Visible = true
            
            stroke.Color = Color3.fromHSV(tick() % 5 / 5, 0.75, 1)
            
            local targetName = "None"
            local distStr = "N/A"
            local statusStr = Engine.Modules.ConfigManager.Settings.AutoFarm and "Hunting" or "Idle"
            
            if Engine.State.CurrentTarget and Engine.State.CurrentTarget.Parent then
                targetName = Engine.State.CurrentTarget.Parent.Name
                local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local d = math.floor((Engine.State.CurrentTarget.Position - hrp.Position).Magnitude)
                    distStr = tostring(d) .. " studs"
                end
                statusStr = "LOCKED & FIRING"
            end
            
            self.Labels.Target.Text = "Target: " .. targetName
            self.Labels.Distance.Text = "Distance: " .. distStr
            self.Labels.Status.Text = "Status: " .. statusStr
            self.Labels.OofAlive.Text = "OOF Alive: " .. tostring(#Engine.Cache.Oofs)
            self.Labels.Kills.Text = "Total Kills: " .. tostring(Engine.Cache.TotalKills)
            self.Labels.KeyTime.Text = "⏳ Key Hạn: " .. Engine.Modules.KeySystem:GetRemainingTime()
            self.Labels.Author.Text = "👑 Author: " .. Engine.Author
        end)
    end
}

-- ==========================================
-- [8] FAST & OPTIMIZED CACHE SCANNER
-- ==========================================
local function PressKey(keyCode)
    pcall(function()
        Engine.Services.VirtualInputManager:SendKeyEvent(true, keyCode, false, game)
        task.wait(0.03)
        Engine.Services.VirtualInputManager:SendKeyEvent(false, keyCode, false, game)
    end)
end

local function TriggerMouseClick()
    pcall(function()
        local mousePos = Engine.Services.UIS:GetMouseLocation()
        Engine.Services.VirtualInputManager:SendMouseButtonEvent(mousePos.X, mousePos.Y, 0, true, game, 1)
        task.wait(0.01)
        Engine.Services.VirtualInputManager:SendMouseButtonEvent(mousePos.X, mousePos.Y, 0, false, game, 1)
    end)
end

local function CheckIsProtectedOrNeutral(plr)
    if not plr or not plr.Character then return true end
    local char = plr.Character
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or hum.Health <= 0 or not hrp then return true end
    
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("ForceField") or child.Name:lower():find("shield") or child.Name:lower():find("protection") then return true end
    end
    return false
end

local function DeterminePlayerRole(plr)
    plr = plr or LocalPlayer
    if not plr or not plr.Character then return "NEUTRAL" end
    if CheckIsProtectedOrNeutral(plr) then
        if plr ~= LocalPlayer then return "NEUTRAL" end
    end
    
    local isZoo, isOof = false, false
    if plr.Team then
        local tName = plr.Team.Name:lower()
        if tName:find("zoo") or tName:find("keeper") then isZoo = true
        elseif tName:find("oof") or tName:find("animal") then isOof = true end
    end
    
    if not isZoo and not isOof then
        local attrRole = plr:GetAttribute("Role") or plr:GetAttribute("Team")
        if attrRole then
            local rStr = tostring(attrRole):lower()
            if rStr:find("zoo") then isZoo = true
            elseif rStr:find("oof") then isOof = true end
        end
    end
    
    local char = plr.Character
    if char then
        for _, v in ipairs(char:GetChildren()) do
            if v:IsA("Tool") then
                local n = v.Name:lower()
                if n:find("gun") or n:find("tranq") or n:find("taser") then isZoo = true
                elseif n:find("claw") or n:find("bite") then isOof = true end
            end
        end
    end
    
    if isZoo then return "ZOOKEEPER" end
    if isOof then return "OOF" end
    return "NEUTRAL"
end

local function FastScanPlayers()
    table.clear(Engine.Cache.Oofs)
    table.clear(Engine.Cache.Animals)
    table.clear(Engine.Cache.Zookeepers)
    
    for _, plr in ipairs(Engine.Services.Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local role = DeterminePlayerRole(plr)
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart") or plr.Character:FindFirstChild("Head")
            
            if hum and hum.Health > 0 and hrp then
                if role == "OOF" then
                    table.insert(Engine.Cache.Oofs, {Model = plr.Character, Root = hrp, Humanoid = hum, Player = plr})
                elseif role == "ZOOKEEPER" then
                    table.insert(Engine.Cache.Zookeepers, {Model = plr.Character, Root = hrp, Humanoid = hum, Player = plr})
                end
            end
        end
    end
    
    local animalFolder = Engine.Services.Workspace:FindFirstChild("Gameplay") and Engine.Services.Workspace.Gameplay:FindFirstChild("Dynamic") and Engine.Services.Workspace.Gameplay.Dynamic:FindFirstChild("Animals")
    if animalFolder then
        for _, animal in ipairs(animalFolder:GetChildren()) do
            local hum = animal:FindFirstChildOfClass("Humanoid")
            local hrp = animal:FindFirstChild("HumanoidRootPart") or animal:FindFirstChild("Head")
            if hum and hum.Health > 0 and hrp then
                table.insert(Engine.Cache.Oofs, {Model = animal, Root = hrp, Humanoid = hum})
                table.insert(Engine.Cache.Animals, {Model = animal, Root = hrp, Humanoid = hum})
            end
        end
    end
end

local function SlowScanPrompts()
    table.clear(Engine.Cache.Prompts)
    for _, prompt in ipairs(Engine.Services.Workspace:GetDescendants()) do
        if prompt:IsA("ProximityPrompt") and prompt.Enabled then
            local pPart = prompt.Parent
            if pPart and pPart:IsA("BasePart") then
                table.insert(Engine.Cache.Prompts, {Prompt = prompt, Part = pPart, Distance = prompt.MaxActivationDistance})
            end
        end
    end
end

task.spawn(function()
    while task.wait(3) do
        SlowScanPrompts()
    end
end)

local function GetBestTarget()
    FastScanPlayers()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local myPos = hrp.Position
    
    local bestTargetRoot = nil
    local bestModel = nil
    local minScore = math.huge
    
    local pool = (Engine.State.CurrentRole == "ZOOKEEPER") and Engine.Cache.Oofs or Engine.Cache.Zookeepers
    if Engine.State.CurrentRole == "NEUTRAL" then pool = Engine.Cache.Oofs end
    
    for _, item in ipairs(pool) do
        if item.Humanoid and item.Humanoid.Health > 0 and item.Root then
            local dist = (item.Root.Position - myPos).Magnitude
            local hpFactor = (item.Humanoid.Health / item.Humanoid.MaxHealth) * 30
            local score = dist + hpFactor
            
            if score < minScore then
                minScore = score
                bestTargetRoot = item.Root
                bestModel = item.Model
            end
        end
    end
    
    Engine.State.TargetModel = bestModel
    return bestTargetRoot
end

local function IsTargetValid(target)
    if not target or not target.Parent then return false end
    local hum = target.Parent:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return false end
    
    local plr = Engine.Services.Players:GetPlayerFromCharacter(target.Parent)
    if plr and CheckIsProtectedOrNeutral(plr) then return false end
    
    return true
end

local function CheckLineOfSight(originPos, targetPos, ignoreModel)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    
    local ignoreList = {LocalPlayer.Character}
    if ignoreModel then table.insert(ignoreList, ignoreModel) end
    raycastParams.FilterDescendantsInstances = ignoreList
    raycastParams.IgnoreWater = true

    local dir = targetPos - originPos
    local result = Engine.Services.Workspace:Raycast(originPos, dir, raycastParams)

    if result then
        if ignoreModel and result.Instance:IsDescendantOf(ignoreModel) then
            return true
        end
        return false
    end
    return true
end

-- ==========================================
-- [9] FARM & COMBAT ENGINE (SMART WALL BYPASS)
-- ==========================================
Engine.Modules.FarmManager = {
    StuckTracker = { LastPos = Vector3.zero, StuckTime = 0, OffsetVector = Vector3.zero },
    LastActions = { Attack = 0, Skill = 0, Prompt = 0 },
    
    Start = function(self)
        self:Stop()
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        self.StuckTracker.LastPos = hrp.Position
        
        local farmBV = Instance.new("BodyVelocity")
        farmBV.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        farmBV.Velocity = Vector3.zero
        farmBV.Parent = hrp
        table.insert(Engine.State.FarmConnections, function() if farmBV then farmBV:Destroy() end end)
        
        local scanThread = task.spawn(function()
            while Engine.Modules.ConfigManager.Settings.AutoFarm do
                Engine.State.CurrentRole = DeterminePlayerRole(LocalPlayer)
                
                if not IsTargetValid(Engine.State.CurrentTarget) then
                    if Engine.State.CurrentTarget ~= nil then
                        Engine.Cache.TotalKills = Engine.Cache.TotalKills + 1
                    end
                    Engine.State.CurrentTarget = GetBestTarget()
                end
                task.wait(0.1)
            end
        end)
        table.insert(Engine.State.FarmConnections, scanThread)
        
        local actionThread = task.spawn(function()
            while Engine.Modules.ConfigManager.Settings.AutoFarm do
                if Engine.State.CurrentRole == "OOF" and Engine.State.CurrentTarget and IsTargetValid(Engine.State.CurrentTarget) then
                    if Engine.Modules.ConfigManager.Settings.AutoSkill and tick() - self.LastActions.Skill > 3.2 then
                        self.LastActions.Skill = tick()
                        PressKey(Enum.KeyCode.E)
                    end
                end
                
                if Engine.State.CurrentRole == "ZOOKEEPER" and Engine.State.CurrentTarget and IsTargetValid(Engine.State.CurrentTarget) then
                    if Engine.Modules.ConfigManager.Settings.AutoSkill and tick() - self.LastActions.Skill > 2.5 then
                        self.LastActions.Skill = tick()
                        PressKey(Enum.KeyCode.Q)
                    end
                end
                
                if Engine.State.CurrentRole == "ZOOKEEPER" and Engine.Modules.ConfigManager.Settings.AutoMoney and tick() - self.LastActions.Prompt > 1.5 then
                    self.LastActions.Prompt = tick()
                    for _, item in ipairs(Engine.Cache.Prompts) do
                        if fireproximityprompt and item.Prompt and item.Prompt.Parent then
                            pcall(function() fireproximityprompt(item.Prompt) end)
                            break
                        end
                    end
                end
                task.wait(0.15)
            end
        end)
        table.insert(Engine.State.FarmConnections, actionThread)
        
        local farmLoop = Engine.Services.RunService.Heartbeat:Connect(function(dt)
            if not Engine.Modules.ConfigManager.Settings.AutoFarm then return end
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            
            if hum then hum.PlatformStand = true end
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
            
            for _, part in ipairs(char:GetChildren()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
            
            if Engine.Modules.ConfigManager.Settings.AntiStuck then
                if (hrp.Position - self.StuckTracker.LastPos).Magnitude < 0.4 then
                    self.StuckTracker.StuckTime = self.StuckTracker.StuckTime + dt
                    if self.StuckTracker.StuckTime > 1.5 then
                        self.StuckTracker.OffsetVector = Vector3.new(math.random(-15, 15), 10, math.random(-15, 15))
                        self.StuckTracker.StuckTime = 0
                    end
                else
                    self.StuckTracker.StuckTime = 0
                    self.StuckTracker.LastPos = hrp.Position
                    self.StuckTracker.OffsetVector = self.StuckTracker.OffsetVector:Lerp(Vector3.zero, 0.08)
                end
            end
            
            if Engine.State.CurrentTarget and IsTargetValid(Engine.State.CurrentTarget) then
                local targetPos = Engine.State.CurrentTarget.Position
                local destination
                
                if Engine.State.CurrentRole == "ZOOKEEPER" or Engine.State.CurrentRole == "NEUTRAL" then
                    local targetCFrame = Engine.State.CurrentTarget.CFrame
                    local defaultPos = targetCFrame.Position + (targetCFrame.LookVector * 12) + Vector3.new(0, 3, 0) + self.StuckTracker.OffsetVector
                    
                    if Engine.Modules.ConfigManager.Settings.SmartWallBypass then
                        local hasLOS = CheckLineOfSight(defaultPos, targetPos, Engine.State.TargetModel)
                        if not hasLOS then
                            destination = targetPos + Vector3.new(0, 14, 0) + self.StuckTracker.OffsetVector
                        else
                            destination = defaultPos
                        end
                    else
                        destination = defaultPos
                    end
                else
                    destination = Vector3.new(targetPos.X, targetPos.Y + Engine.Modules.ConfigManager.Settings.AutoFarmHeight, targetPos.Z) + self.StuckTracker.OffsetVector
                end
                
                local currentPos = hrp.Position
                local dist = (destination - currentPos).Magnitude
                
                if dist > 0.5 then
                    local moveDir = (destination - currentPos).Unit
                    local moveSpeed = Engine.Modules.ConfigManager.Settings.AutoFarmSpeed
                    local step = moveDir * math.min(dist, moveSpeed * dt)
                    hrp.CFrame = CFrame.lookAt(currentPos + step, targetPos)
                else
                    hrp.CFrame = CFrame.lookAt(currentPos, targetPos)
                end
                
                Camera.CFrame = Camera.CFrame:Lerp(CFrame.lookAt(Camera.CFrame.Position, targetPos), 0.25)
                
                if (Engine.State.CurrentRole == "ZOOKEEPER" or Engine.State.CurrentRole == "NEUTRAL") and Engine.Modules.ConfigManager.Settings.AutoAttack and tick() - self.LastActions.Attack > 0.08 then
                    self.LastActions.Attack = tick()
                    
                    local tool = char:FindFirstChildOfClass("Tool")
                    if not tool then
                        local backpack = LocalPlayer:FindFirstChild("Backpack")
                        if backpack then
                            local gTool = backpack:FindFirstChildOfClass("Tool")
                            if gTool and hum then hum:EquipTool(gTool) tool = gTool end
                        end
                    end
                    
                    if tool then tool:Activate() end
                    TriggerMouseClick()
                end
            end
        end)
        table.insert(Engine.State.FarmConnections, farmLoop)
        
        Engine.Modules.NotificationManager:Notify("Zookeeper Hunter V6.5", "AI Auto Farm & Smart Wall Bypass Active!", 3)
    end,
    
    Stop = function(self)
        for _, conn in ipairs(Engine.State.FarmConnections) do
            if typeof(conn) == "RBXScriptConnection" then conn:Disconnect() end
            if typeof(conn) == "thread" then task.cancel(conn) end
            if typeof(conn) == "function" then conn() end
        end
        table.clear(Engine.State.FarmConnections)
        Engine.State.CurrentTarget = nil
        
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum.PlatformStand = false end
    end
}

-- ==========================================
-- [10] EXPLOITS (AIMBOT, FLY, HITBOX OPTIMIZED)
-- ==========================================
local fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 1.5
fovCircle.Color = Color3.fromRGB(0, 255, 120)
fovCircle.Transparency = 0.8
fovCircle.Filled = false
fovCircle.NumSides = 64

Engine.Services.RunService.RenderStepped:Connect(function()
    local mousePos = Engine.Services.UIS:GetMouseLocation()
    fovCircle.Radius = Engine.Modules.ConfigManager.Settings.AimbotFOV
    fovCircle.Position = mousePos
    fovCircle.Visible = Engine.Modules.ConfigManager.Settings.Aimbot
    
    if Engine.Modules.ConfigManager.Settings.Aimbot and Engine.State.CurrentTarget and IsTargetValid(Engine.State.CurrentTarget) then
        local targetPos = Engine.State.CurrentTarget.Position
        if Engine.Modules.ConfigManager.Settings.Prediction and Engine.State.CurrentRole ~= "ZOOKEEPER" then
            local vel = Engine.State.CurrentTarget:IsA("BasePart") and Engine.State.CurrentTarget.AssemblyLinearVelocity or Vector3.zero
            targetPos = targetPos + (vel * Engine.Modules.ConfigManager.Settings.PredictionAmount)
        end
        Camera.CFrame = Camera.CFrame:Lerp(CFrame.lookAt(Camera.CFrame.Position, targetPos), Engine.Modules.ConfigManager.Settings.AimbotSmooth)
    end
end)

local bv, bg = nil, nil
Engine.Services.RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    
    if Engine.Modules.ConfigManager.Settings.Speed and hum then
        hum.WalkSpeed = Engine.Modules.ConfigManager.Settings.SpeedValue
    end
    
    if Engine.Modules.ConfigManager.Settings.Fly and hrp and hum then
        hum.PlatformStand = true
        if not bv then
            bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
            bv.Parent = hrp
        end
        if not bg then
            bg = Instance.new("BodyGyro")
            bg.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
            bg.P = 15000
            bg.Parent = hrp
        end
        
        local cam = Camera.CFrame
        local move = Vector3.new()
        if Engine.Services.UIS:IsKeyDown(Enum.KeyCode.W) then move += cam.LookVector end
        if Engine.Services.UIS:IsKeyDown(Enum.KeyCode.S) then move -= cam.LookVector end
        if Engine.Services.UIS:IsKeyDown(Enum.KeyCode.A) then move -= cam.RightVector end
        if Engine.Services.UIS:IsKeyDown(Enum.KeyCode.D) then move += cam.RightVector end
        if Engine.Services.UIS:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0,1,0) end
        if Engine.Services.UIS:IsKeyDown(Enum.KeyCode.LeftControl) then move -= Vector3.new(0,1,0) end
        
        bv.Velocity = move.Magnitude > 0 and move.Unit * Engine.Modules.ConfigManager.Settings.FlySpeed or Vector3.zero
        bg.CFrame = CFrame.lookAt(hrp.Position, hrp.Position + cam.LookVector)
    elseif bv or bg then
        if bv then bv:Destroy(); bv = nil end
        if bg then bg:Destroy(); bg = nil end
        if hum then hum.PlatformStand = false end
    end
end)

Engine.Services.RunService.Stepped:Connect(function()
    if Engine.Modules.ConfigManager.Settings.Noclip and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)

task.spawn(function()
    while task.wait(0.2) do
        if Engine.Modules.ConfigManager.Settings.HitboxSize > 2 then
            for _, plr in ipairs(Engine.Services.Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character then
                    if DeterminePlayerRole(plr) ~= "NEUTRAL" then
                        local root = plr.Character:FindFirstChild("HumanoidRootPart")
                        if root then
                            root.Size = Vector3.new(Engine.Modules.ConfigManager.Settings.HitboxSize, Engine.Modules.ConfigManager.Settings.HitboxSize, Engine.Modules.ConfigManager.Settings.HitboxSize)
                            root.Transparency = 0.75
                            root.CanCollide = false
                        end
                    end
                end
            end
        end
    end
end)

Engine.Services.UIS.JumpRequest:Connect(function()
    if Engine.Modules.ConfigManager.Settings.InfJump then
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

LocalPlayer.Idled:Connect(function()
    if Engine.Modules.ConfigManager.Settings.AntiAFK then
        Engine.Services.VirtualUser:CaptureController()
        Engine.Services.VirtualUser:ClickButton2(Vector2.new())
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    Engine.Modules.FarmManager:Stop()
    task.wait(1.5)
    Engine.State.CurrentRole = DeterminePlayerRole(LocalPlayer)
    if Engine.Modules.ConfigManager.Settings.AutoFarm then
        Engine.Modules.FarmManager:Start()
    end
end)

-- ==========================================
-- [11] UI CONTROLLER (LIQUID GLASS EDITION)
-- ==========================================
Engine.Modules.UIController = {
    ChromaObjects = {},
    MainFrame = nil,
    LogoButton = nil,
    
    Init = function(self)
        local coreGui = LocalPlayer:WaitForChild("PlayerGui")
        local sg = Instance.new("ScreenGui")
        sg.Name = "RBZoo_V6_UI_LiquidGlass"
        sg.ResetOnSpawn = false
        sg.Parent = coreGui
        
        self.LogoButton = Instance.new("TextButton")
        self.LogoButton.Size = UDim2.new(0, 54, 0, 54)
        self.LogoButton.Position = UDim2.new(0, 20, 0.5, -27)
        self.LogoButton.BackgroundColor3 = Color3.fromRGB(15, 20, 32)
        self.LogoButton.BackgroundTransparency = 0.25
        self.LogoButton.Text = "ZOO\nV6.5"
        self.LogoButton.Font = Enum.Font.GothamBlack
        self.LogoButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        self.LogoButton.TextSize = 12
        self.LogoButton.Active = true
        self.LogoButton.Draggable = true
        self.LogoButton.Parent = sg
        Instance.new("UICorner", self.LogoButton).CornerRadius = UDim.new(1, 0)
        
        local logoStroke = Instance.new("UIStroke")
        logoStroke.Thickness = 2
        logoStroke.Transparency = 0.2
        logoStroke.Parent = self.LogoButton
        table.insert(self.ChromaObjects, logoStroke)
        table.insert(self.ChromaObjects, self.LogoButton)
        
        self.LogoButton.MouseButton1Click:Connect(function()
            self.MainFrame.Visible = not self.MainFrame.Visible
        end)
        
        self.MainFrame = Instance.new("Frame")
        self.MainFrame.Size = UDim2.new(0, 560, 0, 390)
        self.MainFrame.Position = UDim2.new(0.5, -280, 0.5, -195)
        self.MainFrame.BackgroundColor3 = Color3.fromRGB(12, 16, 26)
        self.MainFrame.BackgroundTransparency = 0.32
        self.MainFrame.Active = true
        self.MainFrame.Draggable = true
        self.MainFrame.ClipsDescendants = true
        self.MainFrame.Parent = sg
        Instance.new("UICorner", self.MainFrame).CornerRadius = UDim.new(0, 16)
        
        local mainStroke = Instance.new("UIStroke")
        mainStroke.Thickness = 1.8
        mainStroke.Transparency = 0.25
        mainStroke.Parent = self.MainFrame
        table.insert(self.ChromaObjects, mainStroke)
        
        local topBar = Instance.new("Frame")
        topBar.Size = UDim2.new(1, 0, 0, 50)
        topBar.BackgroundTransparency = 1
        topBar.Parent = self.MainFrame
        
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, -20, 0, 26)
        title.Position = UDim2.new(0, 15, 0, 4)
        title.BackgroundTransparency = 1
        title.Text = "RB ZOO V6.5 • FIX LAG & WALL BYPASS EDITION"
        title.Font = Enum.Font.GothamBlack
        title.TextSize = 13
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Parent = topBar
        table.insert(self.ChromaObjects, title)
        
        local authorLabel = Instance.new("TextLabel")
        authorLabel.Size = UDim2.new(1, -20, 0, 16)
        authorLabel.Position = UDim2.new(0, 15, 0, 26)
        authorLabel.BackgroundTransparency = 1
        authorLabel.Text = "Bản quyền thuộc về: " .. Engine.Author .. "  |  100% Zookeeper Mode"
        authorLabel.Font = Enum.Font.GothamBold
        authorLabel.TextSize = 10
        authorLabel.TextColor3 = Color3.fromRGB(0, 255, 180)
        authorLabel.TextXAlignment = Enum.TextXAlignment.Left
        authorLabel.Parent = topBar
        
        local line = Instance.new("Frame")
        line.Size = UDim2.new(1, -30, 0, 1)
        line.Position = UDim2.new(0, 15, 1, -1)
        line.BorderSizePixel = 0
        line.BackgroundTransparency = 0.5
        line.Parent = topBar
        table.insert(self.ChromaObjects, line)
        
        local contentArea = Instance.new("Frame")
        contentArea.Size = UDim2.new(1, 0, 1, -50)
        contentArea.Position = UDim2.new(0, 0, 0, 50)
        contentArea.BackgroundTransparency = 1
        contentArea.Parent = self.MainFrame
        
        self:BuildTabs(contentArea)
        
        Engine.Services.RunService.RenderStepped:Connect(function()
            local hue = tick() % 6 / 6
            local color = Color3.fromHSV(hue, 0.75, 1)
            for _, obj in ipairs(self.ChromaObjects) do
                if obj and obj.Parent then
                    if obj:IsA("UIStroke") then obj.Color = color
                    elseif obj:IsA("TextLabel") or obj:IsA("TextButton") then obj.TextColor3 = color
                    elseif obj:IsA("Frame") and (obj.Size.Y.Offset == 1 or obj.Name == "ToggledBG") then obj.BackgroundColor3 = color end
                end
            end
        end)
        
        Engine.Services.UIS.InputBegan:Connect(function(input, gp)
            if gp then return end
            if input.KeyCode == Enum.KeyCode.RightShift then
                self.MainFrame.Visible = not self.MainFrame.Visible
            elseif input.KeyCode == Enum.KeyCode.P then
                Engine.Modules.ConfigManager.Settings.AutoFarm = not Engine.Modules.ConfigManager.Settings.AutoFarm
                Engine.Modules.ConfigManager:Save()
                if Engine.Modules.ConfigManager.Settings.AutoFarm then Engine.Modules.FarmManager:Start() else Engine.Modules.FarmManager:Stop() end
                Engine.Modules.NotificationManager:Notify("Hotkey Triggered", "Hunter AI: " .. tostring(Engine.Modules.ConfigManager.Settings.AutoFarm), 2)
            end
        end)
    end,
    
    BuildTabs = function(self, parent)
        local tabContainer = Instance.new("Frame")
        tabContainer.Size = UDim2.new(0, 145, 1, -20)
        tabContainer.Position = UDim2.new(0, 12, 0, 10)
        tabContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        tabContainer.BackgroundTransparency = 0.94
        tabContainer.Parent = parent
        Instance.new("UICorner", tabContainer).CornerRadius = UDim.new(0, 12)
        
        local tabList = Instance.new("UIListLayout")
        tabList.SortOrder = Enum.SortOrder.LayoutOrder
        tabList.Padding = UDim.new(0, 6)
        tabList.Parent = tabContainer
        
        local pageContainer = Instance.new("Frame")
        pageContainer.Size = UDim2.new(1, -175, 1, -20)
        pageContainer.Position = UDim2.new(0, 165, 0, 10)
        pageContainer.BackgroundTransparency = 1
        pageContainer.Parent = parent
        
        local pages = {}
        local tabButtons = {}
        
        local function createTab(name, first)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 36)
            btn.BackgroundTransparency = 1
            btn.Text = "    " .. name
            btn.TextColor3 = Color3.fromRGB(180, 195, 215)
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = 12
            btn.TextXAlignment = Enum.TextXAlignment.Left
            btn.Parent = tabContainer
            
            local page = Instance.new("ScrollingFrame")
            page.Size = UDim2.new(1, 0, 1, 0)
            page.BackgroundTransparency = 1
            page.ScrollBarThickness = 3
            page.ScrollBarImageTransparency = 0.7
            page.Visible = first
            page.Parent = pageContainer
            
            local pageLayout = Instance.new("UIListLayout")
            pageLayout.Padding = UDim.new(0, 8)
            pageLayout.Parent = page
            
            if first then
                btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                table.insert(self.ChromaObjects, btn)
            end
            
            btn.MouseButton1Click:Connect(function()
                for _, p in pairs(pages) do p.Visible = false end
                for _, b in pairs(tabButtons) do b.TextColor3 = Color3.fromRGB(180, 195, 215) end
                page.Visible = true
                btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                table.insert(self.ChromaObjects, btn)
            end)
            
            table.insert(pages, page)
            table.insert(tabButtons, btn)
            return page
        end
        
        local pageForce = createTab("🎯 Team Force", true)
        local pageCombat = createTab("⚡ Combat AI", false)
        local pageFarm = createTab("🤖 Automation", false)
        local pageMovement = createTab("🚀 Movement", false)
        local pageKey = createTab("🔑 Key System", false)
        
        -- Tab Team Force
        self:CreateToggle(pageForce, "Ép phe Zookeeper 100%", "ForceZookeeper", function(v)
            if v then Engine.Modules.TeamForce:TryForceZoo() end
        end)
        self:CreateToggle(pageForce, "Hiển thị HUD Hunter", "ShowHUD")
        self:CreateToggle(pageForce, "Tối ưu FPS (Fix Lag)", "FPSBooster", function(v)
            if v then Engine.Modules.PerformanceBooster:Init() end
        end)
        
        -- Tab Combat AI
        self:CreateToggle(pageCombat, "Smart Aimbot [M]", "Aimbot")
        self:CreateSlider(pageCombat, "Aimbot FOV", 50, 600, "AimbotFOV")
        self:CreateSlider(pageCombat, "Aimbot Smooth", 0.05, 1, "AimbotSmooth")
        self:CreateToggle(pageCombat, "Auto Attack", "AutoAttack")
        self:CreateToggle(pageCombat, "Auto Skill (Q / E)", "AutoSkill")
        self:CreateSlider(pageCombat, "Expand Hitbox", 2, 25, "HitboxSize")
        
        -- Tab Automation
        self:CreateToggle(pageFarm, "Hunter AI Auto Farm [P]", "AutoFarm", function(v)
            if v then Engine.Modules.FarmManager:Start() else Engine.Modules.FarmManager:Stop() end
        end)
        self:CreateToggle(pageFarm, "Fix Dính Tường (Smart Bypass)", "SmartWallBypass")
        self:CreateSlider(pageFarm, "Hunter Speed", 30, 250, "AutoFarmSpeed")
        self:CreateSlider(pageFarm, "Flight Height (OOF)", 50, 1500, "AutoFarmHeight")
        self:CreateToggle(pageFarm, "Anti-Stuck Protection", "AntiStuck")
        self:CreateToggle(pageFarm, "Auto Money", "AutoMoney")
        self:CreateToggle(pageFarm, "Anti-AFK (24/7)", "AntiAFK")
        
        -- Tab Movement
        self:CreateToggle(pageMovement, "Fly", "Fly")
        self:CreateSlider(pageMovement, "Fly Speed", 50, 350, "FlySpeed")
        self:CreateToggle(pageMovement, "WalkSpeed", "Speed")
        self:CreateSlider(pageMovement, "Speed Value", 16, 100, "SpeedValue")
        self:CreateToggle(pageMovement, "Noclip", "Noclip")
        self:CreateToggle(pageMovement, "Infinite Jump", "InfJump")
        
        -- Tab Key System
        local keyCard = Instance.new("Frame")
        keyCard.Size = UDim2.new(1, -10, 0, 140)
        keyCard.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        keyCard.BackgroundTransparency = 0.94
        keyCard.Parent = pageKey
        Instance.new("UICorner", keyCard).CornerRadius = UDim.new(0, 12)
        
        local keyTitle = Instance.new("TextLabel")
        keyTitle.Size = UDim2.new(1, -20, 0, 24)
        keyTitle.Position = UDim2.new(0, 12, 0, 8)
        keyTitle.BackgroundTransparency = 1
        keyTitle.Text = "🔑 THÔNG TIN KEY SỬ DỤNG"
        keyTitle.Font = Enum.Font.GothamBlack
        keyTitle.TextSize = 13
        keyTitle.TextColor3 = Color3.fromRGB(0, 210, 255)
        keyTitle.TextXAlignment = Enum.TextXAlignment.Left
        keyTitle.Parent = keyCard
        
        local keyValLabel = Instance.new("TextLabel")
        keyValLabel.Size = UDim2.new(1, -20, 0, 20)
        keyValLabel.Position = UDim2.new(0, 12, 0, 36)
        keyValLabel.BackgroundTransparency = 1
        keyValLabel.Text = "Mã Key: " .. (Engine.Modules.KeySystem.CurrentKey or "N/A")
        keyValLabel.Font = Enum.Font.GothamBold
        keyValLabel.TextSize = 11
        keyValLabel.TextColor3 = Color3.fromRGB(220, 230, 245)
        keyValLabel.TextXAlignment = Enum.TextXAlignment.Left
        keyValLabel.Parent = keyCard
        
        local keyTimeLabel = Instance.new("TextLabel")
        keyTimeLabel.Size = UDim2.new(1, -20, 0, 20)
        keyTimeLabel.Position = UDim2.new(0, 12, 0, 60)
        keyTimeLabel.BackgroundTransparency = 1
        keyTimeLabel.Text = "Thời gian còn lại: Đang tính..."
        keyTimeLabel.Font = Enum.Font.GothamBold
        keyTimeLabel.TextSize = 11
        keyTimeLabel.TextColor3 = Color3.fromRGB(0, 255, 170)
        keyTimeLabel.TextXAlignment = Enum.TextXAlignment.Left
        keyTimeLabel.Parent = keyCard
        
        Engine.Services.RunService.RenderStepped:Connect(function()
            if pageKey.Visible then
                keyTimeLabel.Text = "Thời gian còn lại: " .. Engine.Modules.KeySystem:GetRemainingTime()
            end
        end)
        
        -- Nút Logout / Đăng xuất Key
        local btnLogout = Instance.new("TextButton")
        btnLogout.Size = UDim2.new(1, -24, 0, 36)
        btnLogout.Position = UDim2.new(0, 12, 0, 92)
        btnLogout.BackgroundColor3 = Color3.fromRGB(220, 50, 60)
        btnLogout.Text = "🔓 ĐĂNG XUẤT KEY"
        btnLogout.Font = Enum.Font.GothamBlack
        btnLogout.TextSize = 11
        btnLogout.TextColor3 = Color3.fromRGB(255, 255, 255)
        btnLogout.Parent = keyCard
        Instance.new("UICorner", btnLogout).CornerRadius = UDim.new(0, 8)
        
        btnLogout.MouseButton1Click:Connect(function()
            Engine.Modules.KeySystem:Logout()
        end)
        
        for _, p in pairs(pages) do p.CanvasSize = UDim2.new(0, 0, 0, #p:GetChildren() * 52) end
    end,
    
    CreateToggle = function(self, parent, text, configKey, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -10, 0, 40)
        frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        frame.BackgroundTransparency = 0.94
        frame.Parent = parent
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -65, 1, 0)
        label.Position = UDim2.new(0, 12, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Color3.fromRGB(225, 235, 248)
        label.Font = Enum.Font.GothamMedium
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = frame
        
        local toggleBtn = Instance.new("TextButton")
        toggleBtn.Name = Engine.Modules.ConfigManager.Settings[configKey] and "ToggledBG" or "OffBG"
        toggleBtn.Size = UDim2.new(0, 42, 0, 22)
        toggleBtn.Position = UDim2.new(1, -52, 0.5, -11)
        toggleBtn.BackgroundColor3 = Engine.Modules.ConfigManager.Settings[configKey] and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(45, 52, 68)
        toggleBtn.BackgroundTransparency = Engine.Modules.ConfigManager.Settings[configKey] and 0.2 or 0.4
        toggleBtn.Text = ""
        toggleBtn.Parent = frame
        Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)
        
        local circle = Instance.new("Frame")
        circle.Size = UDim2.new(0, 18, 0, 18)
        circle.Position = Engine.Modules.ConfigManager.Settings[configKey] and UDim2.new(1, -20, 0, 2) or UDim2.new(0, 2, 0, 2)
        circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        circle.Parent = toggleBtn
        Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)
        
        if Engine.Modules.ConfigManager.Settings[configKey] then table.insert(self.ChromaObjects, toggleBtn) end
        
        toggleBtn.MouseButton1Click:Connect(function()
            local newState = not Engine.Modules.ConfigManager.Settings[configKey]
            Engine.Modules.ConfigManager.Settings[configKey] = newState
            Engine.Modules.ConfigManager:Save()
            
            toggleBtn.Name = newState and "ToggledBG" or "OffBG"
            local goalPos = newState and UDim2.new(1, -20, 0, 2) or UDim2.new(0, 2, 0, 2)
            local goalColor = newState and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(45, 52, 68)
            
            Engine.Services.TweenService:Create(circle, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = goalPos}):Play()
            Engine.Services.TweenService:Create(toggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = goalColor}):Play()
            
            if newState then table.insert(self.ChromaObjects, toggleBtn) else
                for i, obj in ipairs(self.ChromaObjects) do if obj == toggleBtn then table.remove(self.ChromaObjects, i) break end end
            end
            if callback then callback(newState) end
        end)
    end,
    
    CreateSlider = function(self, parent, text, min, max, configKey)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -10, 0, 56)
        frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        frame.BackgroundTransparency = 0.94
        frame.Parent = parent
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)
        
        local default = Engine.Modules.ConfigManager.Settings[configKey]
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -12, 0, 24)
        label.Position = UDim2.new(0, 12, 0, 4)
        label.BackgroundTransparency = 1
        label.Text = text .. ": " .. string.format("%.2f", default)
        label.TextColor3 = Color3.fromRGB(225, 235, 248)
        label.Font = Enum.Font.GothamMedium
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = frame
        
        local bar = Instance.new("Frame")
        bar.Size = UDim2.new(1, -24, 0, 6)
        bar.Position = UDim2.new(0, 12, 0, 36)
        bar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        bar.BackgroundTransparency = 0.85
        bar.Parent = frame
        Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)
        
        local fill = Instance.new("Frame")
        fill.Name = "ToggledBG"
        fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        fill.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
        fill.Parent = bar
        Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
        table.insert(self.ChromaObjects, fill)
        
        local knob = Instance.new("TextButton")
        knob.Size = UDim2.new(0, 14, 0, 14)
        knob.Position = UDim2.new((default - min) / (max - min), -7, 0.5, -7)
        knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        knob.Text = ""
        knob.Parent = bar
        Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
        
        local dragging = false
        knob.MouseButton1Down:Connect(function() dragging = true end)
        Engine.Services.UIS.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 and dragging then
                dragging = false
                Engine.Modules.ConfigManager:Save()
            end
        end)
        
        Engine.Services.RunService.RenderStepped:Connect(function()
            if dragging then
                local mouseX = Engine.Services.UIS:GetMouseLocation().X
                local barX = bar.AbsolutePosition.X
                local barW = bar.AbsoluteSize.X
                local percent = math.clamp((mouseX - barX) / barW, 0, 1)
                local val = min + (max - min) * percent
                fill.Size = UDim2.new(percent, 0, 1, 0)
                knob.Position = UDim2.new(percent, -7, 0.5, -7)
                label.Text = text .. ": " .. string.format("%.2f", val)
                Engine.Modules.ConfigManager.Settings[configKey] = val
            end
        end)
    end
}

-- ==========================================
-- [12] BOOTSTRAPPER (WITH LOADING & KEY CHECK)
-- ==========================================
Engine.BootAfterKey = function(self)
    self.Modules.NotificationManager:Init()
    self.Modules.HunterHUD:Init()
    self.Modules.UIController:Init()
    self.Modules.TeamForce:Init()
    self.Status = "Running"
    
    self.Modules.NotificationManager:Notify("RB ZOO HUNTER V6.5", "Khởi động thành công! Bản quyền: " .. Engine.Author, 5)
    
    if self.Modules.ConfigManager.Settings.AutoFarm then
        self.Modules.FarmManager:Start()
    end
end

Engine.Boot = function(self)
    self.Modules.ConfigManager:Load()
    self.Modules.PerformanceBooster:Init()
    
    -- [1] Chạy Loading Screen 5s
    self.Modules.LoadingScreen:Show()
    
    -- [2] Kiểm tra Key / Yêu cầu nhập Key
    local keyVerified = self.Modules.KeySystem:PromptKeyUI()
    if not keyVerified then return end
    
    -- [3] Khởi động giao diện Script chính khi đã có Key
    self:BootAfterKey()
end

-- Launch Engine
Engine:Boot()

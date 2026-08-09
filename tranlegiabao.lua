-- // =================================================================
-- // RB ZOO SUPER PREMIUM 2026 - ULTIMATE V8.0 (INSTANT KEY BYPASS)
-- // COPYRIGHT © 2026 TRẦN LÊ GIA BẢO. ALL RIGHTS RESERVED.
-- // Engineered with Real-Time Hunter AI, Quad-Cache & Anti-Lag Engine.
-- // Integrated with GitHub Commit SHA Live Fetching (0s Cache Delay).
-- // =================================================================

local Engine = {
    Services = {},
    Modules = {},
    Cache = { Animals = {}, Zookeepers = {}, Oofs = {}, Prompts = {}, LastScan = 0, TotalKills = 0 },
    State = { CurrentRole = "NEUTRAL", CurrentTarget = nil, TargetModel = nil, FarmConnections = {} },
    Status = "Booting",
    Author = "Trần Lê Gia Bảo",
    
    CustomLogoID = "https://github.com/giabaotranle04112011/zoo-or-oof-by-giabaotranle04112011/blob/main/bun.jpg", -- Điền "rbxassetid://ID" tại đây nếu muốn dùng Roblox Decal ID trực tiếp
    
    CachedLogoAsset = nil,
    IsFetchingLogo = false,
    
    GetLogoAsset = function(self)
        if self.CachedLogoAsset then
            return self.CachedLogoAsset
        end

        local rawUrl = "https://raw.githubusercontent.com/giabaotranle04112011/zoo-or-oof-by-giabaotranle04112011/main/bun.jpg"
        local getasset = getcustomasset or getsynasset or custom_asset
        
        -- Kiểm tra file bun.jpg trong local storage (tải nhanh 0ms)
        if isfile and isfile("bun.jpg") and getasset then
            local ok, asset = pcall(function() return getasset("bun.jpg") end)
            if ok and asset then 
                self.CachedLogoAsset = asset
                return asset 
            end
        end

        -- Nếu chưa có file, tiến hành tải ngầm không gây khựng/lag game
        if not self.IsFetchingLogo then
            self.IsFetchingLogo = true
            task.spawn(function()
                local httpRequest = (syn and syn.request) or (http and http.request) or request or http_request
                local imageBytes = nil

                if httpRequest then
                    pcall(function()
                        local res = httpRequest({ Url = rawUrl, Method = "GET" })
                        if res and res.Body and #res.Body > 100 then imageBytes = res.Body end
                    end)
                end
                if not imageBytes then
                    pcall(function()
                        local b = game:HttpGet(rawUrl)
                        if b and #b > 100 then imageBytes = b end
                    end)
                end

                if imageBytes and writefile and getasset then
                    pcall(function() writefile("bun.jpg", imageBytes) end)
                    pcall(function() self.CachedLogoAsset = getasset("bun.jpg") end)
                end

                if not self.CachedLogoAsset then
                    self.CachedLogoAsset = rawUrl
                end
                self.IsFetchingLogo = false
            end)
        end

        return rawUrl
    end
}

-- Hàm chuẩn hóa chuỗi
local function CleanStr(str)
    if not str or typeof(str) ~= "string" then return "" end
    str = str:gsub("%s+", ""):gsub("[%r%n]", "")
    return str:upper()
end

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

-- Services & Globals Initialization


-- ==========================================
-- [2] CONFIG MANAGER
-- ==========================================
Engine.Modules.ConfigManager = {
    Settings = {
        Aimbot = false, AimbotSmooth = 0.2, AimbotFOV = 250, WallCheck = true, Prediction = false, PredictionAmount = 0.13,
        Fly = false, FlySpeed = 120, Speed = false, SpeedValue = 20, Noclip = false, InfJump = false, HitboxSize = 4,
        AutoAttack = true, AutoSkill = true, AutoMoney = true, AntiAFK = true, ShowHUD = true, FPSBooster = true,
        AutoFarm = false, AutoFarmHeight = 700, AutoFarmSpeed = 75, SmartMovement = true, AntiStuck = true,
        AutoDodge = true, DodgeRadius = 15, DodgeSpeed = 1.4,
        ForceZookeeper = true, SmartWallBypass = true, Language = "VN",
        ESP_Enabled = true, ESP_Box2D = true, ESP_Name = true, ESP_Distance = true,
        ESP_HealthBar = true, ESP_Skeleton = false, ESP_Tracer = false, ESP_TracerMode = "Bottom",
        ESP_OffscreenArrow = true, ESP_TargetHighlight = true, ESP_Filter = "All", ESP_MaxDistance = 1500
    },
    File = "RBZoo_Smart_Config_V8_0.json",
    
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
-- [3.5] INTERNATIONALIZATION (I18N) LANGUAGE ENGINE (VN / EN)
-- ==========================================
Engine.Modules.I18n = {
    Current = "VN",
    
    Translations = {
        VN = {
            Title = "RB ZOO V8.5 • CLASS QUID VIP",
            SubTitle = "Owner: Trần Lê Gia Bảo  |  Class Quid Premium Engine",
            LoadingTitle = "⚡ CLASS QUID VIP V8.5",
            LoadingStatus = "🚀 Khởi động Class Quid VIP Engine...",
            Step1 = "⚡ [1/5] Nạp Service & Cấu hình Class Quid Config...",
            Step2 = "🚀 [2/5] Kích hoạt Engine Tối ưu hóa FPS & Fix Lag...",
            Step3 = "🛡️ [3/5] Kích hoạt Smart Wall Bypass & Auto Hunter...",
            Step4 = "🔑 [4/5] Kết nối Server Key getkeyfree24h.netlify.app...",
            Step5 = "✨ [5/5] Nạp hoàn tất! Đang khởi chạy giao diện...",
            
            KeySystemTitle = "🔐 CLASS QUID KEY SYSTEM V8.5",
            KeySystemDesc = "Lấy Key miễn phí tại: getkeyfree24h.netlify.app hoặc tham gia Discord chính thức.",
            PlaceholderKey = "Nhập Key (FREE-XXXX-XXXX) hoặc Mã Admin...",
            BtnGetKey = "🌐 LẤY KEY",
            BtnDiscord = "💬 DISCORD",
            BtnVerify = "✔️ XÁC NHẬN",
            BtnLogout = "🔓 ĐĂNG XUẤT KEY",
            CopyKeySuccess = "✓ Đã sao chép Link Get Key: ",
            CopyDiscordSuccess = "✓ Đã sao chép Link Discord: ",
            Verifying = "⏳ Đang kết nối Server kiểm tra Key...",
            KeyValid = "✓ Key hợp lệ! Đang mở Script Class Quid...",
            AdminBypass = "👑 Đã kích hoạt CHẾ ĐỘ ADMIN BYPASS!",
            KeyRemaining = "Thời gian còn lại: ",
            
            TabTeamForce = "🎯 Phe & Cấu Hình",
            TabCombat = "⚡ Auto Bắn & Skill",
            TabFarm = "🤖 Auto Farm AI",
            TabMovement = "🚀 Tốc Độ & Di Chuyển",
            TabESP = "👁️ ESP Visuals",
            TabKey = "🔑 Hệ Thống Key",
            TabLanguage = "🌐 Ngôn Ngữ (Language)",
            
            SecTeam = "🎯 CẤU HÌNH PHE & HỆ THỐNG",
            SecCombat = "⚡ COMBAT & SMART AIMBOT",
            SecFarm = "🤖 AUTO FARM & OOF MATRIX DODGE",
            SecMovement = "🚀 FLIGHT & MOVEMENT ENGINE",
            SecESP = "👁️ VISUAL ESP ENGINE",
            SecKey = "🔑 HỆ THỐNG KEY & ACC",
            SecLang = "🌐 CÀI ĐẶT NGÔN NGỮ",
            
            ForceZoo = "Ép phe Zookeeper 100%",
            ShowHUD = "Hiển thị HUD Hunter",
            FPSBooster = "Tối ưu FPS (Fix Lag)",
            
            SmartAimbot = "Smart Aimbot [M]",
            AimbotFOV = "Aimbot FOV",
            AimbotSmooth = "Mượt Aimbot",
            AutoAttack = "Tự động tấn công",
            AutoSkill = "Tự dùng Skill (Q / E)",
            HitboxSize = "Mở rộng Hitbox",
            
            AutoFarm = "Hunter AI Auto Farm [P]",
            AutoDodge = "Skill Né Đạn Tự Động (OOF Matrix Dodge)",
            DodgeRadius = "Bán Kính Né Đạn (Dodge Radius)",
            SmartWallBypass = "Fix Dính Tường (Smart Bypass)",
            AutoFarmSpeed = "Tốc độ di chuyển Hunter",
            AutoFarmHeight = "Độ cao bay (Phe OOF)",
            AntiStuck = "Bảo vệ chống kẹt (Anti-Stuck)",
            AutoMoney = "Tự nhặt tiền (Auto Money)",
            AntiAFK = "Chống văng AFK (24/7)",
            
            Fly = "Bay (Fly)",
            FlySpeed = "Tốc độ bay",
            WalkSpeed = "Tốc độ chạy",
            SpeedValue = "Giá trị tốc độ",
            Noclip = "Đi xuyên tường (Noclip)",
            InfJump = "Nhảy vô tận (Inf Jump)",

            ESP_Enabled = "Kích hoạt ESP Engine",
            ESP_Box2D = "ESP Khung 2D (Box)",
            ESP_Name = "ESP Tên & Role",
            ESP_Distance = "ESP Khoảng cách",
            ESP_HealthBar = "ESP Thanh Máu (HP Bar)",
            ESP_Skeleton = "ESP Khung Xương (Skeleton)",
            ESP_Tracer = "ESP Đường dẫn (Tracer)",
            ESP_OffscreenArrow = "Mũi tên chỉ hướng (Off-screen)",
            ESP_TargetHighlight = "Vòng sáng Khóa Target",
            ESP_MaxDistance = "Khoảng cách ESP tối đa",
            
            KeyInfoTitle = "🔑 THÔNG TIN KEY & CỘNG ĐỒNG",
            KeyVal = "Mã Key: ",
            KeyWebBtn = "🌐 Trang Get Key 24h: getkeyfree24h.netlify.app",
            KeyDiscordBtn = "💬 Tham Gia Server Discord: discord.gg/rMJAhJwgW",
            SwitchLangBtn = "🌐 Chuyển Ngôn Ngữ / Switch Language (VN ➔ EN)"
        },
        EN = {
            Title = "RB ZOO V8.5 • CLASS QUID VIP",
            SubTitle = "Owner: Trần Lê Gia Bảo  |  Class Quid Premium Engine",
            LoadingTitle = "⚡ CLASS QUID VIP V8.5",
            LoadingStatus = "🚀 Booting Class Quid VIP Engine...",
            Step1 = "⚡ [1/5] Loading Services & Class Quid Config...",
            Step2 = "🚀 [2/5] Enabling FPS Booster & Anti-Lag Engine...",
            Step3 = "🛡️ [3/5] Activating Smart Wall Bypass & Auto Hunter...",
            Step4 = "🔑 [4/5] Connecting Key Server getkeyfree24h.netlify.app...",
            Step5 = "✨ [5/5] Loading Complete! Launching Interface...",
            
            KeySystemTitle = "🔐 CLASS QUID KEY SYSTEM V8.5",
            KeySystemDesc = "Get free key at getkeyfree24h.netlify.app or join official Discord.",
            PlaceholderKey = "Enter Key (FREE-XXXX-XXXX) or Admin Code...",
            BtnGetKey = "🌐 GET KEY",
            BtnDiscord = "💬 DISCORD",
            BtnVerify = "✔️ VERIFY",
            BtnLogout = "🔓 LOGOUT KEY",
            CopyKeySuccess = "✓ Copied Get Key Link: ",
            CopyDiscordSuccess = "✓ Copied Discord Link: ",
            Verifying = "⏳ Connecting to Key Verification Server...",
            KeyValid = "✓ Key Valid! Launching Class Quid Script...",
            AdminBypass = "👑 ADMIN BYPASS MODE ACTIVATED!",
            KeyRemaining = "Remaining Time: ",
            
            TabTeamForce = "🎯 Team & Setup",
            TabCombat = "⚡ Combat AI",
            TabFarm = "🤖 Auto Farm AI",
            TabMovement = "🚀 Movement & Fly",
            TabESP = "👁️ ESP Visuals",
            TabKey = "🔑 Key System",
            TabLanguage = "🌐 Language (Ngôn Ngữ)",
            
            SecTeam = "🎯 TEAM & SYSTEM SETUP",
            SecCombat = "⚡ COMBAT & SMART AIMBOT",
            SecFarm = "🤖 AUTO FARM & OOF MATRIX DODGE",
            SecMovement = "🚀 FLIGHT & MOVEMENT ENGINE",
            SecESP = "👁️ VISUAL ESP ENGINE",
            SecKey = "🔑 ACCOUNT & KEY SYSTEM",
            SecLang = "🌐 LANGUAGE SETTINGS",
            
            ForceZoo = "Force Zookeeper 100%",
            ShowHUD = "Show Hunter HUD",
            FPSBooster = "FPS Booster (Fix Lag)",
            
            SmartAimbot = "Smart Aimbot [M]",
            AimbotFOV = "Aimbot FOV",
            AimbotSmooth = "Aimbot Smoothness",
            AutoAttack = "Auto Attack",
            AutoSkill = "Auto Skill (Q / E)",
            HitboxSize = "Expand Hitbox",
            
            AutoFarm = "Hunter AI Auto Farm [P]",
            AutoDodge = "Auto Dodge Bullets (OOF Matrix Dodge)",
            DodgeRadius = "Dodge Radius",
            SmartWallBypass = "Fix Wall Stuck (Smart Bypass)",
            AutoFarmSpeed = "Hunter Movement Speed",
            AutoFarmHeight = "Flight Height (OOF Role)",
            AntiStuck = "Anti-Stuck Protection",
            AutoMoney = "Auto Money Collector",
            AntiAFK = "Anti-AFK Protection (24/7)",
            
            Fly = "Fly Mode",
            FlySpeed = "Flight Speed",
            WalkSpeed = "WalkSpeed",
            SpeedValue = "Speed Value",
            Noclip = "Noclip (Walk Through Walls)",
            InfJump = "Infinite Jump",

            ESP_Enabled = "Enable ESP Engine",
            ESP_Box2D = "ESP 2D Box",
            ESP_Name = "ESP Name & Role",
            ESP_Distance = "ESP Distance",
            ESP_HealthBar = "ESP Health Bar",
            ESP_Skeleton = "ESP Skeleton",
            ESP_Tracer = "ESP Tracer Line",
            ESP_OffscreenArrow = "Off-screen Direction Arrow",
            ESP_TargetHighlight = "Target Lock Highlight",
            ESP_MaxDistance = "ESP Max Distance",
            
            KeyInfoTitle = "🔑 KEY INFO & COMMUNITY",
            KeyVal = "Current Key: ",
            KeyWebBtn = "🌐 Get Key 24h Web: getkeyfree24h.netlify.app",
            KeyDiscordBtn = "💬 Join Discord Server: discord.gg/rMJAhJwgW",
            SwitchLangBtn = "🌐 Switch Language / Chuyển Ngôn Ngữ (EN ➔ VN)"
        }
    },

    Get = function(self, key)
        local lang = Engine.Modules.ConfigManager.Settings.Language or self.Current or "VN"
        local dict = self.Translations[lang] or self.Translations["VN"]
        return dict[key] or key
    end,

    ToggleLang = function(self)
        local curr = Engine.Modules.ConfigManager.Settings.Language or "VN"
        local newLang = (curr == "VN") and "EN" or "VN"
        Engine.Modules.ConfigManager.Settings.Language = newLang
        self.Current = newLang
        Engine.Modules.ConfigManager:Save()
        return newLang
    end
}

-- ==========================================
-- [4] VIP ANIMATED LOADING SCREEN ENGINE
-- ==========================================
Engine.Modules.LoadingScreen = {
    Show = function(self)
        local coreGui = LocalPlayer:WaitForChild("PlayerGui")
        local sg = Instance.new("ScreenGui")
        sg.Name = "RBZoo_V8_LoadingScreen"
        sg.ResetOnSpawn = false
        sg.Parent = coreGui

        local bg = Instance.new("Frame")
        bg.Size = UDim2.new(1, 0, 1, 0)
        bg.BackgroundColor3 = Color3.fromRGB(6, 8, 14)
        bg.BackgroundTransparency = 0.05
        bg.Parent = sg

        local glowRing = Instance.new("Frame")
        glowRing.Size = UDim2.new(0, 480, 0, 280)
        glowRing.Position = UDim2.new(0.5, -240, 0.5, -140)
        glowRing.BackgroundColor3 = Color3.fromRGB(0, 240, 255)
        glowRing.BackgroundTransparency = 0.92
        glowRing.Parent = bg
        Instance.new("UICorner", glowRing).CornerRadius = UDim.new(0, 24)

        local card = Instance.new("Frame")
        card.Size = UDim2.new(0, 460, 0, 260)
        card.Position = UDim2.new(0.5, -230, 0.5, -130)
        card.BackgroundColor3 = Color3.fromRGB(12, 16, 26)
        card.BackgroundTransparency = 0.1
        card.Parent = bg
        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 20)

        local stroke = Instance.new("UIStroke")
        stroke.Thickness = 2.5
        stroke.Color = Color3.fromRGB(0, 240, 255)
        stroke.Parent = card

        -- Hiển thị Logo bun.jpg trong Màn hình Loading
        local logoAsset = Engine:GetLogoAsset()
        local titleXOffset = 20
        if logoAsset then
            local logoFrame = Instance.new("Frame")
            logoFrame.Size = UDim2.new(0, 52, 0, 52)
            logoFrame.Position = UDim2.new(0, 25, 0, 18)
            logoFrame.BackgroundColor3 = Color3.fromRGB(20, 28, 45)
            logoFrame.Parent = card
            Instance.new("UICorner", logoFrame).CornerRadius = UDim.new(0, 12)

            local logoImg = Instance.new("ImageLabel")
            logoImg.Size = UDim2.new(1, 0, 1, 0)
            logoImg.BackgroundTransparency = 1
            logoImg.Image = logoAsset
            logoImg.ScaleType = Enum.ScaleType.Crop
            logoImg.Parent = logoFrame
            Instance.new("UICorner", logoImg).CornerRadius = UDim.new(0, 12)

            local logoStroke = Instance.new("UIStroke")
            logoStroke.Thickness = 1.5
            logoStroke.Color = Color3.fromRGB(0, 240, 255)
            logoStroke.Parent = logoFrame
            
            titleXOffset = 90
        end

        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, - (titleXOffset + 20), 0, 30)
        title.Position = UDim2.new(0, titleXOffset, 0, 18)
        title.BackgroundTransparency = 1
        title.Text = "⚡ CLASS QUID VIP V8.5"
        title.Font = Enum.Font.GothamBlack
        title.TextSize = 17
        title.TextColor3 = Color3.fromRGB(0, 240, 255)
        title.TextXAlignment = (titleXOffset > 20) and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center
        title.Parent = card

        local sub = Instance.new("TextLabel")
        sub.Size = UDim2.new(1, - (titleXOffset + 20), 0, 20)
        sub.Position = UDim2.new(0, titleXOffset, 0, 48)
        sub.BackgroundTransparency = 1
        sub.Text = "Owner: " .. Engine.Author .. " • Discord: discord.gg/rMJAhJwgW"
        sub.Font = Enum.Font.GothamBold
        sub.TextSize = 10
        sub.TextColor3 = Color3.fromRGB(0, 255, 180)
        sub.TextXAlignment = (titleXOffset > 20) and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center
        sub.Parent = card

        local barBg = Instance.new("Frame")
        barBg.Size = UDim2.new(0.88, 0, 0, 12)
        barBg.Position = UDim2.new(0.06, 0, 0, 125)
        barBg.BackgroundColor3 = Color3.fromRGB(22, 30, 48)
        barBg.Parent = card
        Instance.new("UICorner", barBg).CornerRadius = UDim.new(1, 0)

        local barFill = Instance.new("Frame")
        barFill.Size = UDim2.new(0, 0, 1, 0)
        barFill.BackgroundColor3 = Color3.fromRGB(0, 240, 255)
        barFill.Parent = barBg
        Instance.new("UICorner", barFill).CornerRadius = UDim.new(1, 0)

        local barGlow = Instance.new("UIStroke")
        barGlow.Thickness = 1.5
        barGlow.Color = Color3.fromRGB(0, 255, 180)
        barGlow.Transparency = 0.5
        barGlow.Parent = barFill

        local percentLabel = Instance.new("TextLabel")
        percentLabel.Size = UDim2.new(1, 0, 0, 22)
        percentLabel.Position = UDim2.new(0, 0, 0, 148)
        percentLabel.BackgroundTransparency = 1
        percentLabel.Text = "0%"
        percentLabel.Font = Enum.Font.GothamBlack
        percentLabel.TextSize = 14
        percentLabel.TextColor3 = Color3.fromRGB(0, 240, 255)
        percentLabel.Parent = card

        local statusLabel = Instance.new("TextLabel")
        statusLabel.Size = UDim2.new(1, 0, 0, 22)
        statusLabel.Position = UDim2.new(0, 0, 0, 182)
        statusLabel.BackgroundTransparency = 1
        statusLabel.Text = "🚀 Khởi động Class Quid VIP Engine..."
        statusLabel.Font = Enum.Font.GothamMedium
        statusLabel.TextSize = 11
        statusLabel.TextColor3 = Color3.fromRGB(170, 190, 220)
        statusLabel.Parent = card

        local steps = {
            {time = 0.1, text = "⚡ [1/5] Nạp Service & Cấu hình Class Quid Config..."},
            {time = 0.25, text = "🚀 [2/5] Kích hoạt Engine Tối ưu hóa FPS & Fix Lag..."},
            {time = 0.4, text = "🛡️ [3/5] Kích hoạt Smart Wall Bypass & Auto Hunter..."},
            {time = 0.5, text = "🔑 [4/5] Kết nối Server Key getkeyfree24h.netlify.app..."},
            {time = 0.6, text = "✨ [5/5] Nạp hoàn tất! Đang khởi chạy giao diện..."}
        }

        local totalDuration = 0.6
        local startTime = tick()
        Engine.Services.TweenService:Create(barFill, TweenInfo.new(totalDuration, Enum.EasingStyle.Linear), {Size = UDim2.new(1, 0, 1, 0)}):Play()

        while tick() - startTime < totalDuration do
            local elapsed = tick() - startTime
            local progress = math.clamp(elapsed / totalDuration, 0, 1)

            percentLabel.Text = math.floor(progress * 100) .. "%"
            stroke.Color = Color3.fromHSV((tick() * 2) % 1, 0.8, 1)

            if elapsed < 0.15 then statusLabel.Text = steps[1].text
            elseif elapsed < 0.3 then statusLabel.Text = steps[2].text
            elseif elapsed < 0.45 then statusLabel.Text = steps[3].text
            elseif elapsed < 0.55 then statusLabel.Text = steps[4].text
            else statusLabel.Text = steps[5].text
            end

            task.wait(0.05)
        end

        barFill.Size = UDim2.new(1, 0, 1, 0)
        percentLabel.Text = "100%"
        task.wait(0.1)

        Engine.Services.TweenService:Create(bg, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
        Engine.Services.TweenService:Create(card, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
        Engine.Services.TweenService:Create(glowRing, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
        Engine.Services.TweenService:Create(stroke, TweenInfo.new(0.4), {Transparency = 1}):Play()
        task.wait(0.4)
        sg:Destroy()
    end
}

-- ==========================================
-- [4.5] KEY SYSTEM & INSTANT LIVE FETCH MODULE (FIXED FLEXIBLE FORMAT)
-- ==========================================
Engine.Modules.KeySystem = {
    KeyURL = "https://getkeyfree24h.netlify.app/",
    DiscordURL = "https://discord.gg/rMJAhJwgW",
    DiscordCode = "rMJAhJwgW",
    RepoOwner = "giabaotranle04112011",
    RepoName = "getkey",
    FilePath = "keys.json",
    KeySaveFile = "RBZoo_SavedKey_V8.json",
    AdminKey = "14142022",
    CurrentKey = nil,
    CurrentKeyType = nil,

    JoinDiscord = function(self)
        if setclipboard or toclipboard then
            pcall(function() (setclipboard or toclipboard)(self.DiscordURL) end)
        end
        local httpRequest = (syn and syn.request) or (http and http.request) or request or http_request
        if httpRequest then
            pcall(function()
                httpRequest({
                    Url = "http://127.0.0.1:6463/rpc?v=1",
                    Method = "POST",
                    Headers = {
                        ["Content-Type"] = "application/json",
                        ["Origin"] = "https://discord.com"
                    },
                    Body = Engine.Services.HttpService:JSONEncode({
                        cmd = "INVITE_BROWSER",
                        args = { code = self.DiscordCode },
                        nonce = Engine.Services.HttpService:GenerateGUID(false)
                    })
                })
            end)
        end
        if Engine.Modules.NotificationManager and Engine.Modules.NotificationManager.Notify then
            Engine.Modules.NotificationManager:Notify("Discord Community", "✓ Đã sao chép Link Discord: " .. self.DiscordURL, 4)
        end
    end,

    FetchLatestKeysJSON = function(self)
        local httpRequest = (syn and syn.request) or (http and http.request) or request or http_request
        
        local function httpGetRaw(targetUrl)
            if httpRequest then
                local success, res = pcall(function()
                    return httpRequest({
                        Url = targetUrl,
                        Method = "GET",
                        Headers = {
                            ["Cache-Control"] = "no-cache, no-store, must-revalidate",
                            ["Pragma"] = "no-cache"
                        }
                    })
                end)
                if success and res and res.Body then return res.Body end
            end
            local ok, body = pcall(function() return game:HttpGet(targetUrl) end)
            if ok then return body end
            return nil
        end

        local timestamp = os.time()
        local repoList = { self.RepoName, "zoo-or-oof-by-giabaotranle04112011" }
        for _, repo in ipairs(repoList) do
            local directUrl = string.format("https://raw.githubusercontent.com/%s/%s/main/%s?nocache=%d", self.RepoOwner, repo, self.FilePath, timestamp)
            local res = httpGetRaw(directUrl)
            if res and #res > 5 then return res end
        end

        return nil
    end,

    -- SỬA LỖI: Hỗ trợ mọi tiền tố Key (FREE-, TLGB-, VIP7-, VIP30-...)
    ValidateKeyFormat = function(self, inputKey)
        local cleaned = CleanStr(inputKey)
        if cleaned == "" then return false, "EMPTY", "" end
        
        if cleaned == CleanStr(self.AdminKey) then
            return true, "ADMIN", cleaned
        end

        -- Định dạng linh hoạt: [TIỀN TỐ]-[4 KÝ TỰ]-[4 KÝ TỰ]
        local prefix, b1, b2 = cleaned:match("^([A-Z0-9]+)%-([A-Z0-9]+)%-([A-Z0-9]+)$")
        if prefix and b1 and b2 and #b1 == 4 and #b2 == 4 then
            return true, "USER", cleaned
        end

        return false, "INVALID", cleaned
    end,

    VerifyKeyOnline = function(self, inputKey)
        local isValidFormat, keyType, cleanedInput = self:ValidateKeyFormat(inputKey)
        if not isValidFormat then
            return false, "Cú pháp Key không đúng!"
        end
        
        if keyType == "ADMIN" then
            return true, "ADMIN"
        end

        local response = self:FetchLatestKeysJSON()

        if not response then
            return false, "Lỗi kết nối Server xác minh Key!"
        end

        local decodeSuccess, validKeys = pcall(function()
            return Engine.Services.HttpService:JSONDecode(response)
        end)

        if not decodeSuccess or typeof(validKeys) ~= "table" then
            return false, "Dữ liệu Server Key bị lỗi!"
        end

        local currentTime = os.time()

        -- Kiểm tra mã Key nằm trong JSON
        for keyName, expireTimestamp in pairs(validKeys) do
            local keyToCheck = (typeof(expireTimestamp) == "string") and expireTimestamp or keyName

            if CleanStr(keyToCheck) == cleanedInput then
                if typeof(expireTimestamp) == "number" then
                    if currentTime > expireTimestamp then
                        return false, "Key này đã hết hạn sử dụng (24h)!"
                    end
                end
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
            if success and result and result.Key then
                local isValidOnline, keyType = self:VerifyKeyOnline(result.Key)
                if isValidOnline then
                    self.CurrentKey = CleanStr(result.Key)
                    self.CurrentKeyType = keyType
                    return true, result.Key, keyType
                end
            end
        end
        return false, nil, nil
    end,

    SaveKeyLocally = function(self, key, keyType)
        if writefile then
            pcall(function()
                local cleanedKey = CleanStr(key)
                local data = { Key = cleanedKey, Timestamp = os.time() }
                writefile(self.KeySaveFile, Engine.Services.HttpService:JSONEncode(data))
                self.CurrentKey = cleanedKey
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
        for _, guiName in ipairs({"RBZoo_V8_UI_LiquidGlass", "RBZoo_Hunter_HUD_V8", "RBZoo_V8_Notifications"}) do
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
        card.Size = UDim2.new(0, 480, 0, 285)
        card.Position = UDim2.new(0.5, -240, 0.5, -142)
        card.BackgroundColor3 = Color3.fromRGB(15, 20, 32)
        card.Parent = bg
        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 16)

        local stroke = Instance.new("UIStroke")
        stroke.Thickness = 2
        stroke.Color = Color3.fromRGB(0, 240, 255)
        stroke.Parent = card

        -- Nút chuyển đổi ngôn ngữ trên cửa sổ Key System (VN / EN)
        local btnPromptLang = Instance.new("TextButton")
        btnPromptLang.Size = UDim2.new(0, 68, 0, 26)
        btnPromptLang.Position = UDim2.new(1, -80, 0, 12)
        btnPromptLang.BackgroundColor3 = Color3.fromRGB(24, 34, 52)
        btnPromptLang.Text = "🌐 " .. (Engine.Modules.ConfigManager.Settings.Language or "VN")
        btnPromptLang.Font = Enum.Font.GothamBold
        btnPromptLang.TextSize = 11
        btnPromptLang.TextColor3 = Color3.fromRGB(0, 255, 180)
        btnPromptLang.Parent = card
        Instance.new("UICorner", btnPromptLang).CornerRadius = UDim.new(0, 8)

        -- Tự động hiển thị Logo bun.jpg nếu có
        local logoAsset = Engine:GetLogoAsset()
        local headerOffset = 0
        if logoAsset then
            local logoImg = Instance.new("ImageLabel")
            logoImg.Size = UDim2.new(0, 42, 0, 42)
            logoImg.Position = UDim2.new(0, 20, 0, 12)
            logoImg.BackgroundTransparency = 1
            logoImg.Image = logoAsset
            logoImg.Parent = card
            Instance.new("UICorner", logoImg).CornerRadius = UDim.new(0, 10)
            headerOffset = 50
        end

        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, - (headerOffset + 110), 0, 35)
        title.Position = UDim2.new(0, headerOffset + 20, 0, 15)
        title.BackgroundTransparency = 1
        title.Text = Engine.Modules.I18n:Get("KeySystemTitle")
        title.Font = Enum.Font.GothamBlack
        title.TextSize = 14
        title.TextColor3 = Color3.fromRGB(0, 240, 255)
        title.TextXAlignment = (headerOffset > 0) and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center
        title.Parent = card

        local desc = Instance.new("TextLabel")
        desc.Size = UDim2.new(1, -40, 0, 32)
        desc.Position = UDim2.new(0, 20, 0, 52)
        desc.BackgroundTransparency = 1
        desc.Text = Engine.Modules.I18n:Get("KeySystemDesc")
        desc.Font = Enum.Font.GothamMedium
        desc.TextSize = 11
        desc.TextColor3 = Color3.fromRGB(180, 195, 215)
        desc.TextWrapped = true
        desc.Parent = card

        local textBoxBg = Instance.new("Frame")
        textBoxBg.Size = UDim2.new(0.9, 0, 0, 42)
        textBoxBg.Position = UDim2.new(0.05, 0, 0, 95)
        textBoxBg.BackgroundColor3 = Color3.fromRGB(25, 32, 48)
        textBoxBg.Parent = card
        Instance.new("UICorner", textBoxBg).CornerRadius = UDim.new(0, 10)

        local tbStroke = Instance.new("UIStroke")
        tbStroke.Thickness = 1
        tbStroke.Color = Color3.fromRGB(0, 240, 255)
        tbStroke.Transparency = 0.5
        tbStroke.Parent = textBoxBg

        local keyBox = Instance.new("TextBox")
        keyBox.Size = UDim2.new(1, -20, 1, 0)
        keyBox.Position = UDim2.new(0, 10, 0, 0)
        keyBox.BackgroundTransparency = 1
        keyBox.PlaceholderText = Engine.Modules.I18n:Get("PlaceholderKey")
        keyBox.PlaceholderColor3 = Color3.fromRGB(110, 125, 145)
        keyBox.Text = ""
        keyBox.Font = Enum.Font.GothamBold
        keyBox.TextSize = 12
        keyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        keyBox.Parent = textBoxBg

        local statusLabel = Instance.new("TextLabel")
        statusLabel.Size = UDim2.new(1, -20, 0, 20)
        statusLabel.Position = UDim2.new(0, 10, 0, 144)
        statusLabel.BackgroundTransparency = 1
        statusLabel.Text = ""
        statusLabel.Font = Enum.Font.GothamBold
        statusLabel.TextSize = 11
        statusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        statusLabel.Parent = card

        local btnGetKey = Instance.new("TextButton")
        btnGetKey.Size = UDim2.new(0.28, 0, 0, 40)
        btnGetKey.Position = UDim2.new(0.05, 0, 0, 175)
        btnGetKey.BackgroundColor3 = Color3.fromRGB(30, 42, 65)
        btnGetKey.Text = Engine.Modules.I18n:Get("BtnGetKey")
        btnGetKey.Font = Enum.Font.GothamBlack
        btnGetKey.TextSize = 11
        btnGetKey.TextColor3 = Color3.fromRGB(0, 240, 255)
        btnGetKey.Parent = card
        Instance.new("UICorner", btnGetKey).CornerRadius = UDim.new(0, 10)

        local btnDiscord = Instance.new("TextButton")
        btnDiscord.Size = UDim2.new(0.3, 0, 0, 40)
        btnDiscord.Position = UDim2.new(0.35, 0, 0, 175)
        btnDiscord.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
        btnDiscord.Text = Engine.Modules.I18n:Get("BtnDiscord")
        btnDiscord.Font = Enum.Font.GothamBlack
        btnDiscord.TextSize = 11
        btnDiscord.TextColor3 = Color3.fromRGB(255, 255, 255)
        btnDiscord.Parent = card
        Instance.new("UICorner", btnDiscord).CornerRadius = UDim.new(0, 10)

        local btnVerify = Instance.new("TextButton")
        btnVerify.Size = UDim2.new(0.28, 0, 0, 40)
        btnVerify.Position = UDim2.new(0.67, 0, 0, 175)
        btnVerify.BackgroundColor3 = Color3.fromRGB(0, 240, 255)
        btnVerify.Text = Engine.Modules.I18n:Get("BtnVerify")
        btnVerify.Font = Enum.Font.GothamBlack
        btnVerify.TextSize = 11
        btnVerify.TextColor3 = Color3.fromRGB(10, 15, 25)
        btnVerify.Parent = card
        Instance.new("UICorner", btnVerify).CornerRadius = UDim.new(0, 10)

        local authorSub = Instance.new("TextLabel")
        authorSub.Size = UDim2.new(1, 0, 0, 20)
        authorSub.Position = UDim2.new(0, 0, 0, 238)
        authorSub.BackgroundTransparency = 1
        authorSub.Text = "Class Quid Edition • Owner: " .. Engine.Author .. " • 24h Key"
        authorSub.Font = Enum.Font.GothamMedium
        authorSub.TextSize = 9
        authorSub.TextColor3 = Color3.fromRGB(100, 115, 135)
        authorSub.Parent = card

        local function refreshPromptLanguage()
            title.Text = Engine.Modules.I18n:Get("KeySystemTitle")
            desc.Text = Engine.Modules.I18n:Get("KeySystemDesc")
            keyBox.PlaceholderText = Engine.Modules.I18n:Get("PlaceholderKey")
            btnGetKey.Text = Engine.Modules.I18n:Get("BtnGetKey")
            btnDiscord.Text = Engine.Modules.I18n:Get("BtnDiscord")
            btnVerify.Text = Engine.Modules.I18n:Get("BtnVerify")
            btnPromptLang.Text = "🌐 " .. (Engine.Modules.ConfigManager.Settings.Language or "VN")
        end

        btnPromptLang.MouseButton1Click:Connect(function()
            Engine.Modules.I18n:ToggleLang()
            refreshPromptLanguage()
        end)

        btnGetKey.MouseButton1Click:Connect(function()
            if setclipboard or toclipboard then
                pcall(function() (setclipboard or toclipboard)(self.KeyURL) end)
                statusLabel.TextColor3 = Color3.fromRGB(0, 255, 170)
                statusLabel.Text = Engine.Modules.I18n:Get("CopyKeySuccess") .. self.KeyURL
            else
                statusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
                statusLabel.Text = "Link: " .. self.KeyURL
            end
        end)

        btnDiscord.MouseButton1Click:Connect(function()
            self:JoinDiscord()
            statusLabel.TextColor3 = Color3.fromRGB(0, 255, 170)
            statusLabel.Text = Engine.Modules.I18n:Get("CopyDiscordSuccess") .. self.DiscordURL
        end)

        btnVerify.MouseButton1Click:Connect(function()
            local input = keyBox.Text
            statusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
            statusLabel.Text = Engine.Modules.I18n:Get("Verifying")

            task.spawn(function()
                local isValidOnline, resultMessage = self:VerifyKeyOnline(input)

                if isValidOnline then
                    self:SaveKeyLocally(input, resultMessage)
                    statusLabel.TextColor3 = Color3.fromRGB(0, 255, 170)
                    if resultMessage == "ADMIN" then
                        statusLabel.Text = Engine.Modules.I18n:Get("AdminBypass")
                    else
                        statusLabel.Text = Engine.Modules.I18n:Get("KeyValid")
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
-- [5] FORCE ZOOKEEPER ENGINE
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
                        pcall(function() v:FireServer("Zookeeper") end)
                        pcall(function() v:FireServer("Zoo") end)
                        pcall(function() v:FireServer(1) end)
                    end
                elseif v:IsA("RemoteFunction") then
                    local name = v.Name:lower()
                    if name:find("team") or name:find("role") or name:find("select") or name:find("zoo") then
                        task.spawn(function()
                            pcall(function() v:InvokeServer("Zookeeper") end)
                            pcall(function() v:InvokeServer("Zoo") end)
                            pcall(function() v:InvokeServer(1) end)
                        end)
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
-- [6] NOTIFICATION MANAGER
-- ==========================================
Engine.Modules.NotificationManager = {
    Container = nil,
    Init = function(self)
        local coreGui = LocalPlayer:WaitForChild("PlayerGui")
        local sg = Instance.new("ScreenGui")
        sg.Name = "RBZoo_V8_Notifications"
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
        layout.Padding = UDim.new(0, 8)
        layout.Parent = self.Container
    end,
    
    Notify = function(self, title, text, duration)
        duration = duration or 3.5
        if not self.Container then self:Init() end
        
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 68)
        frame.BackgroundColor3 = Color3.fromRGB(10, 14, 22)
        frame.BackgroundTransparency = 1
        frame.ClipsDescendants = true
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)
        
        local stroke = Instance.new("UIStroke")
        stroke.Thickness = 1.4
        stroke.Transparency = 1
        stroke.Color = Color3.fromRGB(0, 240, 255)
        stroke.Parent = frame
        
        local accentBar = Instance.new("Frame")
        accentBar.Size = UDim2.new(0, 4, 1, 0)
        accentBar.BackgroundColor3 = Color3.fromRGB(0, 240, 255)
        accentBar.BackgroundTransparency = 1
        accentBar.Parent = frame
        Instance.new("UICorner", accentBar).CornerRadius = UDim.new(0, 4)
        
        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(1, -24, 0, 22)
        titleLabel.Position = UDim2.new(0, 16, 0, 8)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = title
        titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        titleLabel.TextTransparency = 1
        titleLabel.Font = Enum.Font.GothamBlack
        titleLabel.TextSize = 12
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Parent = frame
        
        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1, -24, 0, 26)
        textLabel.Position = UDim2.new(0, 16, 0, 30)
        textLabel.BackgroundTransparency = 1
        textLabel.Text = text
        textLabel.TextColor3 = Color3.fromRGB(190, 205, 225)
        textLabel.TextTransparency = 1
        textLabel.Font = Enum.Font.GothamMedium
        textLabel.TextSize = 10.5
        textLabel.TextWrapped = true
        textLabel.TextXAlignment = Enum.TextXAlignment.Left
        textLabel.Parent = frame

        local timerBar = Instance.new("Frame")
        timerBar.Size = UDim2.new(1, 0, 0, 3)
        timerBar.Position = UDim2.new(0, 0, 1, -3)
        timerBar.BackgroundColor3 = Color3.fromRGB(0, 240, 255)
        timerBar.BackgroundTransparency = 1
        timerBar.Parent = frame
        
        frame.Parent = self.Container
        
        local TweenInfoIn = TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        Engine.Services.TweenService:Create(frame, TweenInfoIn, {BackgroundTransparency = 0.22}):Play()
        Engine.Services.TweenService:Create(stroke, TweenInfoIn, {Transparency = 0.35}):Play()
        Engine.Services.TweenService:Create(accentBar, TweenInfoIn, {BackgroundTransparency = 0}):Play()
        Engine.Services.TweenService:Create(titleLabel, TweenInfoIn, {TextTransparency = 0}):Play()
        Engine.Services.TweenService:Create(textLabel, TweenInfoIn, {TextTransparency = 0}):Play()
        Engine.Services.TweenService:Create(timerBar, TweenInfoIn, {BackgroundTransparency = 0.2}):Play()
        Engine.Services.TweenService:Create(timerBar, TweenInfo.new(duration, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 0, 3)}):Play()
        
        task.delay(duration, function()
            if frame and frame.Parent then
                Engine.Services.TweenService:Create(frame, TweenInfoIn, {BackgroundTransparency = 1}):Play()
                Engine.Services.TweenService:Create(stroke, TweenInfoIn, {Transparency = 1}):Play()
                Engine.Services.TweenService:Create(accentBar, TweenInfoIn, {BackgroundTransparency = 1}):Play()
                Engine.Services.TweenService:Create(titleLabel, TweenInfoIn, {TextTransparency = 1}):Play()
                Engine.Services.TweenService:Create(textLabel, TweenInfoIn, {TextTransparency = 1}):Play()
                Engine.Services.TweenService:Create(timerBar, TweenInfoIn, {BackgroundTransparency = 1}):Play()
                task.wait(0.4)
                frame:Destroy()
            end
        end)
    end
}

-- ==========================================
-- [6.5] HELPER FUNCTIONS & ROLE DETERMINATION
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
            elseif rStr:find("oof") or rStr:find("animal") then isOof = true end
        end
    end
    
    if isZoo then return "ZOOKEEPER" end
    if isOof then return "OOF" end
    return "NEUTRAL"
end

Engine.Modules.HunterHUD = {
    Gui = nil,
    Labels = {},
    Init = function(self)
        local coreGui = LocalPlayer:WaitForChild("PlayerGui")
        local sg = Instance.new("ScreenGui")
        sg.Name = "RBZoo_Hunter_HUD_V8"
        sg.ResetOnSpawn = false
        sg.Parent = coreGui
        self.Gui = sg
        
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0, 260, 0, 245)
        frame.Position = UDim2.new(0, 16, 0.22, 0) -- Đặt bên trái màn hình dưới nút game để KHÔNG CHỒNG NHIỆM VỤ!
        frame.BackgroundColor3 = Color3.fromRGB(252, 254, 255)
        frame.BackgroundTransparency = 0.52
        frame.Active = true
        frame.Draggable = true
        frame.ClipsDescendants = true
        frame.Parent = sg
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 16)
        
        local stroke = Instance.new("UIStroke")
        stroke.Thickness = 1.8
        stroke.Color = Color3.fromRGB(0, 180, 255)
        stroke.Transparency = 0.2
        stroke.Parent = frame
        
        -- Header Bar Đen Bóng Bẩy
        local headerBar = Instance.new("Frame")
        headerBar.Size = UDim2.new(1, 0, 0, 32)
        headerBar.BackgroundColor3 = Color3.fromRGB(15, 22, 36)
        headerBar.Parent = frame
        Instance.new("UICorner", headerBar).CornerRadius = UDim.new(0, 16)
        
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, -38, 1, 0)
        title.Position = UDim2.new(0, 12, 0, 0)
        title.BackgroundTransparency = 1
        title.Text = "⚡ CLASS QUID HUNTER V8.5"
        title.Font = Enum.Font.GothamBlack
        title.TextSize = 11
        title.TextColor3 = Color3.fromRGB(0, 240, 255)
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Parent = headerBar
        
        -- Nút Tải Thu Gọn HUD (- / +)
        local btnCollapse = Instance.new("TextButton")
        btnCollapse.Size = UDim2.new(0, 24, 0, 24)
        btnCollapse.Position = UDim2.new(1, -28, 0, 4)
        btnCollapse.BackgroundColor3 = Color3.fromRGB(28, 40, 62)
        btnCollapse.Text = "-"
        btnCollapse.Font = Enum.Font.GothamBlack
        btnCollapse.TextSize = 14
        btnCollapse.TextColor3 = Color3.fromRGB(0, 255, 180)
        btnCollapse.Parent = headerBar
        Instance.new("UICorner", btnCollapse).CornerRadius = UDim.new(0, 6)
        
        local isCollapsed = false
        btnCollapse.MouseButton1Click:Connect(function()
            isCollapsed = not isCollapsed
            btnCollapse.Text = isCollapsed and "+" or "-"
            Engine.Services.TweenService:Create(frame, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = isCollapsed and UDim2.new(0, 260, 0, 32) or UDim2.new(0, 260, 0, 245)
            }):Play()
        end)
        
        local contentContainer = Instance.new("Frame")
        contentContainer.Size = UDim2.new(1, -16, 1, -40)
        contentContainer.Position = UDim2.new(0, 8, 0, 36)
        contentContainer.BackgroundTransparency = 1
        contentContainer.Parent = frame

        local list = Instance.new("UIListLayout")
        list.Padding = UDim.new(0, 3)
        list.SortOrder = Enum.SortOrder.LayoutOrder
        list.Parent = contentContainer
        
        local function addLabel(key, defaultText)
            local lblFrame = Instance.new("Frame")
            lblFrame.Size = UDim2.new(1, 0, 0, 18)
            lblFrame.BackgroundColor3 = Color3.fromRGB(238, 244, 254)
            lblFrame.BackgroundTransparency = 0.65
            lblFrame.Parent = contentContainer
            Instance.new("UICorner", lblFrame).CornerRadius = UDim.new(0, 6)
            
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -12, 1, 0)
            lbl.Position = UDim2.new(0, 6, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = defaultText
            lbl.Font = Enum.Font.GothamBold
            lbl.TextSize = 10
            lbl.TextColor3 = Color3.fromRGB(15, 28, 48) -- Chữ màu tối tương phản 100% trên nền kính trắng!
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = lblFrame
            self.Labels[key] = lbl
            return lblFrame
        end
        
        addLabel("Role", "👤 Role: Loading...").LayoutOrder = 1
        addLabel("Target", "🎯 Target: None").LayoutOrder = 2
        addLabel("Distance", "📏 Distance: N/A").LayoutOrder = 3
        addLabel("Status", "⚡ Status: Idle").LayoutOrder = 4
        addLabel("Hotkeys", "⌨️ [P]Farm:OFF | [M]Aim:OFF").LayoutOrder = 5
        addLabel("Hotkeys2", "⌨️ [F]Fly:OFF  | [Q/E]Skill:AUTO").LayoutOrder = 6
        addLabel("OofAlive", "🐾 OOF Alive: 0").LayoutOrder = 7
        addLabel("Kills", "⚔️ Total Kills: 0").LayoutOrder = 8
        addLabel("KeyTime", "⏳ Key Hạn: N/A").LayoutOrder = 9
        addLabel("Author", "👑 Author: " .. Engine.Author).LayoutOrder = 10
        
        task.spawn(function()
            local ticks = 0
            while task.wait(0.1) do
                ticks = ticks + 1
                if not Engine.Modules.ConfigManager.Settings.ShowHUD then
                    frame.Visible = false
                else
                    frame.Visible = true
                    
                    stroke.Color = Color3.fromHSV((tick() * 0.15) % 1, 0.7, 1)
                    
                    if ticks % 2 == 0 then
                        local role = DeterminePlayerRole(LocalPlayer)
                        Engine.State.CurrentRole = role
                        
                        local roleStr = "🟢 NEUTRAL (Human)"
                        local roleColor = Color3.fromRGB(0, 160, 80)
                        if role == "ZOOKEEPER" then
                            roleStr = "🔴 ZOOKEEPER (Zoo)"
                            roleColor = Color3.fromRGB(220, 30, 30)
                        elseif role == "OOF" then
                            roleStr = "🔵 OOF (Animal)"
                            roleColor = Color3.fromRGB(0, 120, 240)
                        end
                        self.Labels.Role.Text = "👤 Role: " .. roleStr
                        self.Labels.Role.TextColor3 = roleColor
                        
                        local targetName = "None"
                        local distStr = "N/A"
                        local statusStr = Engine.Modules.ConfigManager.Settings.AutoFarm and "HUNTING" or "IDLE"
                        
                        if Engine.State.CurrentTarget and Engine.State.CurrentTarget.Parent then
                            targetName = Engine.State.CurrentTarget.Parent.Name
                            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                            if hrp then
                                local d = math.floor((Engine.State.CurrentTarget.Position - hrp.Position).Magnitude)
                                distStr = tostring(d) .. " studs"
                            end
                            statusStr = "FIRING & DODGING"
                        end
                        
                        self.Labels.Target.Text = "🎯 Target: " .. targetName
                        self.Labels.Distance.Text = "📏 Distance: " .. distStr
                        self.Labels.Status.Text = "⚡ Status: " .. statusStr
                        
                        local farmTxt = Engine.Modules.ConfigManager.Settings.AutoFarm and "ON" or "OFF"
                        local aimTxt = Engine.Modules.ConfigManager.Settings.Aimbot and "ON" or "OFF"
                        local flyTxt = Engine.Modules.ConfigManager.Settings.Fly and "ON" or "OFF"
                        self.Labels.Hotkeys.Text = string.format("⌨️ [P]Farm:%s | [M]Aim:%s", farmTxt, aimTxt)
                        self.Labels.Hotkeys2.Text = string.format("⌨️ [F]Fly:%s | [Q/E]Skill:AUTO", flyTxt)
                    end

                    if ticks % 5 == 0 then
                        self.Labels.OofAlive.Text = "🐾 OOF Alive: " .. tostring(#Engine.Cache.Oofs)
                        self.Labels.Kills.Text = "⚔️ Total Kills: " .. tostring(Engine.Cache.TotalKills)
                    end

                    if ticks % 10 == 0 then
                        self.Labels.KeyTime.Text = "⏳ Key Hạn: " .. Engine.Modules.KeySystem:GetRemainingTime()
                        self.Labels.Author.Text = "👑 Author: " .. Engine.Author
                    end
                end
            end
        end)
    end
}
-- ==========================================
-- [8] FAST SCANNER & TARGETING
-- ==========================================

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
    
    -- NEUTRAL (Human) không được phép tự động tìm target AutoFarm
    if Engine.State.CurrentRole == "NEUTRAL" then return nil end
    
    local pool = (Engine.State.CurrentRole == "ZOOKEEPER") and Engine.Cache.Oofs or Engine.Cache.Zookeepers
    local blacklist = Engine.Modules.FarmManager and Engine.Modules.FarmManager.StuckTracker and Engine.Modules.FarmManager.StuckTracker.Blacklist or {}
    
    for _, item in ipairs(pool) do
        if item.Humanoid and item.Humanoid.Health > 0 and item.Root then
            if not (blacklist[item.Root] and tick() < blacklist[item.Root]) then
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

local sharedRaycastParams = RaycastParams.new()
sharedRaycastParams.FilterType = Enum.RaycastFilterType.Exclude
sharedRaycastParams.IgnoreWater = true

local function CheckLineOfSight(originPos, targetPos, ignoreModel)
    local ignoreList = {LocalPlayer.Character}
    if ignoreModel then table.insert(ignoreList, ignoreModel) end
    sharedRaycastParams.FilterDescendantsInstances = ignoreList

    local dir = targetPos - originPos
    local result = Engine.Services.Workspace:Raycast(originPos, dir, sharedRaycastParams)

    if result then
        if ignoreModel and result.Instance:IsDescendantOf(ignoreModel) then
            return true
        end
        return false
    end
    return true
end

-- ==========================================
-- [9] FARM & COMBAT ENGINE (SMART WALL BYPASS & ANTI-LAG)
-- ==========================================
Engine.Modules.FarmManager = {
    StuckTracker = { LastPos = Vector3.zero, StuckTime = 0, OffsetVector = Vector3.zero, Blacklist = {} },
    DodgeOffset = Vector3.zero,
    CachedDodgeVector = Vector3.zero,
    LastActions = { Attack = 0, Skill = 0, Prompt = 0, Dodge = 0 },
    DodgeAIState = {
        ActiveVector = Vector3.zero,
        LastDirectionTime = 0,
        CurrentThreatScore = 0,
        HysteresisCooldown = 0.28,
        LastDodgeDir = Vector3.zero
    },
    
    -- Smart Dodge AI Engine (GOD-MODE HYPER-REFLEXES & INSTANT TELEPORT EVASION)
    ScanIncomingProjectiles = function(self, myPos)
        if not Engine.Modules.ConfigManager.Settings.AutoDodge then 
            self.DodgeAIState.ActiveVector = Vector3.zero
            return Vector3.zero 
        end
        if Engine.State.CurrentRole ~= "OOF" then 
            self.DodgeAIState.ActiveVector = Vector3.zero
            return Vector3.zero 
        end
        
        local dodgeRadius = Engine.Modules.ConfigManager.Settings.DodgeRadius or 65
        local now = tick()
        local projectiles = {}
        local totalThreat = 0
        local highestThreatTimeToImpact = 999
        
        -- 1. HYPER-WIDE THREAT ANALYSIS & PROJECTION SCANNING (Bán kính 65 studs, Tần số siêu tốc)
        pcall(function()
            local folder = Engine.Services.Workspace:FindFirstChild("Gameplay") or Engine.Services.Workspace
            local targetsToCheck = {folder, Engine.Services.Workspace}
            
            for _, parentObj in ipairs(targetsToCheck) do
                for _, child in ipairs(parentObj:GetChildren()) do
                    if child:IsA("BasePart") or child:IsA("Model") then
                        local name = child.Name:lower()
                        if name:find("bullet") or name:find("proj") or name:find("tranq") or name:find("dart") or name:find("laser") or name:find("ammo") or name:find("net") or name:find("trap") or name:find("shot") or name:find("ball") or name:find("rocket") or name:find("part") or name:find("hitbox") or name:find("arrow") or name:find("ray") then
                            local projPos = child:IsA("Model") and (child.PrimaryPart and child.PrimaryPart.Position or child:GetPivot().Position) or child.Position
                            local dist = (projPos - myPos).Magnitude
                            
                            if dist <= dodgeRadius then
                                local projVel = Vector3.zero
                                if child:IsA("BasePart") then
                                    projVel = child.AssemblyLinearVelocity
                                elseif child:IsA("Model") and child.PrimaryPart then
                                    projVel = child.PrimaryPart.AssemblyLinearVelocity
                                end
                                
                                local projSpeed = projVel.Magnitude
                                local toPlayer = (myPos - projPos).Unit
                                local isHeadingToMe = false
                                local timeToImpact = 999
                                local closestApproachDist = dist
                                
                                if projSpeed > 1 then
                                    local projDir = projVel.Unit
                                    local dotProduct = projDir:Dot(toPlayer)
                                    if dotProduct > -0.2 then
                                        local projToPlayer = myPos - projPos
                                        local projProjection = projDir * projToPlayer:Dot(projDir)
                                        closestApproachDist = (projToPlayer - projProjection).Magnitude
                                        timeToImpact = projProjection.Magnitude / projSpeed
                                        if closestApproachDist <= 18 and timeToImpact >= 0 and timeToImpact <= 3.8 then
                                            isHeadingToMe = true
                                        end
                                    end
                                elseif dist <= 28 then
                                    isHeadingToMe = true
                                    timeToImpact = dist / 25
                                    closestApproachDist = dist
                                end
                                
                                if isHeadingToMe then
                                    local ThreatScore = math.clamp((3.8 - timeToImpact) * 60 + (18 - closestApproachDist) * 20, 20, 200)
                                    table.insert(projectiles, {
                                        Pos = projPos,
                                        Vel = projVel,
                                        Speed = projSpeed,
                                        Dist = dist,
                                        TTI = timeToImpact,
                                        ClosestDist = closestApproachDist,
                                        Score = ThreatScore
                                    })
                                    totalThreat = totalThreat + ThreatScore
                                    if timeToImpact < highestThreatTimeToImpact then
                                        highestThreatTimeToImpact = timeToImpact
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end)
        
        self.DodgeAIState.CurrentThreatScore = totalThreat
        
        -- 2. PHANTOM 3D OMNI-WEAVE (Đổi Độ Cao Thần Tốc 5m ➔ 45m, Khoảng Cách Xa/Gần 8m ➔ 55m)
        local targetPos = Engine.State.CurrentTarget and Engine.State.CurrentTarget.Position or myPos
        local targetDir = (targetPos - myPos).Magnitude > 0.5 and (targetPos - myPos).Unit or Vector3.new(1, 0, 0)
        local perpDir = targetDir:Cross(Vector3.new(0, 1, 0)).Unit
        
        -- A. Dynamic Radius Oscillations (8 studs ➔ 55 studs)
        local rangeWave = (math.sin(now * 3.1) * 0.5 + 0.5)
        local dynamicDistance = 8 + (rangeWave * 47)
        
        -- B. Ultra Altitude Fluctuation (5 studs ➔ 42 studs)
        local heightWave = math.sin(now * 6.2) * 18 + math.cos(now * 10.4) * 12
        local altitudeOffset = Vector3.new(0, 15 + heightWave, 0)
        
        -- C. Multi-Axis Weaving & Diagonal Shifts
        local leftRightStrafe = perpDir * (math.sin(now * 9.2) * dynamicDistance)
        local foreAftPulsing = targetDir * (math.cos(now * 6.8) * (dynamicDistance * 0.85))
        
        -- D. Sudden Unpredictable Quantum Micro-Blinks (Mỗi 0.25s)
        local randomBlink = Vector3.zero
        if math.floor(now * 4.0) % 2 == 0 then
            randomBlink = Vector3.new(
                math.sin(now * 29.5) * (dynamicDistance * 0.65),
                math.cos(now * 21.3) * 14,
                math.cos(now * 33.1) * (dynamicDistance * 0.65)
            )
        end
        
        local continuousOmniShift = leftRightStrafe + foreAftPulsing + altitudeOffset + randomBlink
        
        -- 3. GOD-MODE INSTANT TELEPORT DODGE (Né Tức Thời 40m - 90m Khi Đạn Bay Vào Tầm)
        if #projectiles > 0 and totalThreat >= 10 then
            local primaryProj = projectiles[1]
            local projDir = primaryProj.Vel.Magnitude > 1 and primaryProj.Vel.Unit or (myPos - primaryProj.Pos).Unit
            local sideSign = (math.sin(now * 20) >= 0) and 1 or -1
            local perpEvade = projDir:Cross(Vector3.new(0, 1, 0)).Unit * sideSign
            
            -- Lực né nhảy tức thì cực đại (40 studs ➔ 90 studs)
            local evadeMagnitude = math.clamp((3.8 - primaryProj.TTI) * 65, 40, 90)
            local verticalEvade = Vector3.new(0, (highestThreatTimeToImpact < 0.8) and 28 or 14, 0)
            
            local impulseVector = (perpEvade * evadeMagnitude) + verticalEvade + continuousOmniShift
            
            -- Kiểm tra địa hình 360 độ
            local testPos = myPos + impulseVector
            if not CheckLineOfSight(myPos, testPos) then
                impulseVector = (-perpEvade * evadeMagnitude) + verticalEvade + continuousOmniShift
            end
            
            self.DodgeAIState.ActiveVector = impulseVector
            self.DodgeAIState.LastDodgeDir = perpEvade
            self.DodgeAIState.LastDirectionTime = now
            
            if highestThreatTimeToImpact < 1.2 and (now - self.LastActions.Dodge > 1.4) then
                self.LastActions.Dodge = now
                if Engine.Modules.NotificationManager and Engine.Modules.NotificationManager.Notify then
                    Engine.Modules.NotificationManager:Notify("GOD-MODE DODGE ULTRA", string.format("🔥 [GOD DODGE] Né bứt tốc %.1fm - Đạn trượt 100%% (TTI: %.2fs)!", evadeMagnitude, primaryProj.TTI), 1.2)
                end
            end
            
            return self.DodgeAIState.ActiveVector
        end
        
        self.DodgeAIState.ActiveVector = continuousOmniShift
        return self.DodgeAIState.ActiveVector
    end,
    
    Start = function(self)
        self:Stop()
        Engine.State.CurrentRole = DeterminePlayerRole(LocalPlayer)
        
        -- QUAN TRỌNG: Chỉ bật Auto Farm khi role là ZOOKEEPER hoặc OOF
        if Engine.State.CurrentRole == "NEUTRAL" then
            Engine.Modules.NotificationManager:Notify("Auto Farm Guard", "⚠️ Bỏ qua Farm! Role hiện tại là NEUTRAL (Human). Chỉ farm khi vào Zoo/OOF.", 4)
            return
        end

        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hrp = char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart", 3)
        if not hrp then return end
        self.StuckTracker.LastPos = hrp.Position
        self.StuckTracker.StuckTime = 0
        
        local farmBV = Instance.new("BodyVelocity")
        farmBV.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        farmBV.Velocity = Vector3.zero
        farmBV.Parent = hrp
        table.insert(Engine.State.FarmConnections, function() if farmBV then farmBV:Destroy() end end)
        
        -- Tắt va chạm 1 lần duy nhất khi bật farm
        for _, part in ipairs(char:GetChildren()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end

        local scanThread = task.spawn(function()
            while Engine.Modules.ConfigManager.Settings.AutoFarm do
                Engine.State.CurrentRole = DeterminePlayerRole(LocalPlayer)
                
                if Engine.State.CurrentRole == "NEUTRAL" then
                    Engine.State.CurrentTarget = nil
                else
                    if not IsTargetValid(Engine.State.CurrentTarget) then
                        if Engine.State.CurrentTarget ~= nil then
                            Engine.Cache.TotalKills = Engine.Cache.TotalKills + 1
                        end
                        Engine.State.CurrentTarget = GetBestTarget()
                    end
                end
                task.wait(0.1)
            end
        end)
        table.insert(Engine.State.FarmConnections, scanThread)

        -- Quét né đạn chạy siêu tốc 0.04s / lần (GOD-MODE REFLEX 25 FPS)
        local dodgeThread = task.spawn(function()
            while Engine.Modules.ConfigManager.Settings.AutoFarm do
                if Engine.Modules.ConfigManager.Settings.AutoDodge then
                    local c = LocalPlayer.Character
                    local root = c and c:FindFirstChild("HumanoidRootPart")
                    if root then
                        self.CachedDodgeVector = self:ScanIncomingProjectiles(root.Position)
                    end
                else
                    self.CachedDodgeVector = Vector3.zero
                end
                task.wait(0.04)
            end
        end)
        table.insert(Engine.State.FarmConnections, dodgeThread)
        
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
            
            Engine.State.CurrentRole = DeterminePlayerRole(LocalPlayer)
            if Engine.State.CurrentRole == "NEUTRAL" then return end

            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            
            if hum then hum.PlatformStand = true end
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
            
            -- HỆ THỐNG ANTI-STUCK & RECOVERY HOÀN CHỈNH (Multi-Stage Recovery)
            if Engine.Modules.ConfigManager.Settings.AntiStuck then
                local movedDist = (hrp.Position - self.StuckTracker.LastPos).Magnitude
                if movedDist < 0.5 then
                    self.StuckTracker.StuckTime = self.StuckTracker.StuckTime + dt
                    
                    if self.StuckTracker.StuckTime > 5.0 then
                        -- Giai đoạn 5: Bỏ Target hiện tại & Đổi Target mới
                        if Engine.State.CurrentTarget then
                            self.StuckTracker.Blacklist[Engine.State.CurrentTarget] = tick() + 10
                            Engine.State.CurrentTarget = nil
                            Engine.State.TargetModel = nil
                        end
                        self.StuckTracker.StuckTime = 0
                        self.StuckTracker.OffsetVector = Vector3.new(math.random(-25, 25), 15, math.random(-25, 25))
                        Engine.Modules.NotificationManager:Notify("Anti-Stuck Recovery", "🔄 Kẹt lâu > 5s! Đã bỏ Target và chuyển mục tiêu mới...", 2.5)
                    elseif self.StuckTracker.StuckTime > 3.8 then
                        -- Giai đoạn 4: Reset Movement & Un-platformstand
                        if hum then hum.PlatformStand = false end
                        hrp.AssemblyLinearVelocity = Vector3.new(math.random(-20, 20), 35, math.random(-20, 20))
                    elseif self.StuckTracker.StuckTime > 2.6 then
                        -- Giai đoạn 3: Đổi hướng ngẫu nhiên (Change Direction)
                        local angle = math.rad(math.random(60, 180))
                        self.StuckTracker.OffsetVector = Vector3.new(math.cos(angle) * 18, 12, math.sin(angle) * 18)
                    elseif self.StuckTracker.StuckTime > 1.4 then
                        -- Giai đoạn 2: Nhảy (Jump)
                        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
                        PressKey(Enum.KeyCode.Space)
                    elseif self.StuckTracker.StuckTime > 0.6 then
                        -- Giai đoạn 1: Repath Offset
                        self.StuckTracker.OffsetVector = Vector3.new(math.random(-12, 12), 8, math.random(-12, 12))
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
                
                -- Smart Dodge AI Output Integration (Chỉ áp dụng khi bật AutoDodge & Role OOF)
                local dodgeVec = Vector3.zero
                if Engine.Modules.ConfigManager.Settings.AutoDodge and Engine.State.CurrentRole == "OOF" then
                    dodgeVec = self.CachedDodgeVector or Vector3.zero
                end
                
                if Engine.State.CurrentRole == "ZOOKEEPER" then
                    local targetCFrame = Engine.State.CurrentTarget.CFrame
                    local defaultPos = targetCFrame.Position + (targetCFrame.LookVector * 12) + Vector3.new(0, 3, 0) + self.StuckTracker.OffsetVector + dodgeVec
                    
                    if Engine.Modules.ConfigManager.Settings.SmartWallBypass then
                        local hasLOS = CheckLineOfSight(defaultPos, targetPos, Engine.State.TargetModel)
                        if not hasLOS then
                            destination = targetPos + Vector3.new(0, 14, 0) + self.StuckTracker.OffsetVector + dodgeVec
                        else
                            destination = defaultPos
                        end
                    else
                        destination = defaultPos
                    end
                else
                    destination = Vector3.new(targetPos.X, targetPos.Y + Engine.Modules.ConfigManager.Settings.AutoFarmHeight, targetPos.Z) + self.StuckTracker.OffsetVector + dodgeVec
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
        
        Engine.Modules.NotificationManager:Notify("Zookeeper Hunter V8.0", "AI Auto Farm & Smart Wall Bypass Active!", 3)
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
-- [9.5] HIGH-PERFORMANCE ESP ENGINE (SAFE DRAWING WRAPPER)
-- ==========================================
local function SafeDrawing(dType, props)
    local obj = nil
    pcall(function()
        obj = Drawing.new(dType)
        if props then
            for k, v in pairs(props) do
                pcall(function() obj[k] = v end)
            end
        end
    end)
    if obj and (typeof(obj) == "userdata" or typeof(obj) == "table") then
        return obj
    end
    local proxy = {}
    setmetatable(proxy, {
        __index = function(t, k)
            return function() end
        end,
        __newindex = function(t, k, v) end
    })
    return proxy
end

Engine.Modules.ESPManager = {
    Cache = {},
    TargetDrawings = nil,
    CachedAnimals = {},
    
    GetRoleColor = function(self, role, isAnimal)
        if isAnimal then return Color3.fromRGB(255, 200, 0) end
        if role == "ZOOKEEPER" then
            return Color3.fromRGB(255, 50, 50)
        elseif role == "OOF" then
            return Color3.fromRGB(0, 150, 255)
        end
        return Color3.fromRGB(0, 255, 120)
    end,

    CreateDrawings = function(self)
        return {
            BoxOutline = SafeDrawing("Square", {Thickness = 3, Color = Color3.fromRGB(0, 0, 0), Filled = false}),
            Box = SafeDrawing("Square", {Thickness = 1.5, Filled = false}),
            Name = SafeDrawing("Text", {Size = 12, Center = true, Outline = true, OutlineColor = Color3.fromRGB(0, 0, 0), Font = 2}),
            Distance = SafeDrawing("Text", {Size = 11, Center = true, Outline = true, OutlineColor = Color3.fromRGB(0, 0, 0), Font = 2}),
            HealthOutline = SafeDrawing("Square", {Thickness = 1, Color = Color3.fromRGB(0, 0, 0), Filled = true}),
            HealthFill = SafeDrawing("Square", {Thickness = 1, Filled = true}),
            Tracer = SafeDrawing("Line", {Thickness = 1.2}),
            ArrowText = SafeDrawing("Text", {Size = 12, Center = true, Outline = true, OutlineColor = Color3.fromRGB(0, 0, 0)})
        }
    end,

    Init = function(self)
        self.TargetDrawings = {
            Ring = SafeDrawing("Circle", {Thickness = 2.5, NumSides = 32, Color = Color3.fromRGB(255, 215, 0), Filled = false}),
            Label = SafeDrawing("Text", {Size = 13, Center = true, Outline = true, Color = Color3.fromRGB(255, 215, 0)})
        }

        -- Quét ngầm danh sách Động vật 1.5s một lần (KHÔNG gây lag FPS)
        task.spawn(function()
            while task.wait(1.5) do
                local list = {}
                local animalFolder = Engine.Services.Workspace:FindFirstChild("Gameplay") 
                    and Engine.Services.Workspace.Gameplay:FindFirstChild("Dynamic") 
                    and Engine.Services.Workspace.Gameplay.Dynamic:FindFirstChild("Animals")
                if not animalFolder then
                    animalFolder = Engine.Services.Workspace:FindFirstChild("Animals") or Engine.Services.Workspace:FindFirstChild("Mobs")
                end

                if animalFolder then
                    for _, animal in ipairs(animalFolder:GetChildren()) do
                        table.insert(list, animal)
                    end
                else
                    for _, child in ipairs(Engine.Services.Workspace:GetChildren()) do
                        if child:IsA("Model") and child:FindFirstChildOfClass("Humanoid") and not Engine.Services.Players:GetPlayerFromCharacter(child) then
                            table.insert(list, child)
                        end
                    end
                end
                self.CachedAnimals = list
            end
        end)

        Engine.Services.RunService.RenderStepped:Connect(function()
            self:Update()
        end)
    end,

    RemoveDrawings = function(self, drawings)
        for _, d in pairs(drawings) do
            pcall(function() if d and d.Remove then d:Remove() end end)
        end
    end,

    Update = function(self)
        local settings = Engine.Modules.ConfigManager.Settings
        if not settings.ESP_Enabled then
            for objKey, drawings in pairs(self.Cache) do
                for _, d in pairs(drawings) do pcall(function() d.Visible = false end) end
            end
            if self.TargetDrawings then
                pcall(function() self.TargetDrawings.Ring.Visible = false end)
                pcall(function() self.TargetDrawings.Label.Visible = false end)
            end
            return
        end

        local myChar = LocalPlayer.Character
        local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if not myHRP then return end
        local myPos = myHRP.Position

        local activeKeys = {}

        local function processModel(model, name, role, isAnimal)
            if not model or not model.Parent then return end
            local hum = model:FindFirstChildOfClass("Humanoid")
            local hrp = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Head")
            if not hum or hum.Health <= 0 or not hrp then return end

            local dist = (hrp.Position - myPos).Magnitude
            if dist > (settings.ESP_MaxDistance or 1500) then return end

            local filter = settings.ESP_Filter or "All"
            if filter == "OOF Only" and role ~= "OOF" and not isAnimal then return end
            if filter == "Zookeeper Only" and role ~= "ZOOKEEPER" then return end
            if filter == "Animals Only" and not isAnimal then return end
            if filter == "Target Only" and Engine.State.CurrentTarget ~= hrp then return end

            local key = tostring(model)
            pcall(function() key = model:GetDebugId() end)
            activeKeys[key] = true

            local drawings = self.Cache[key]
            if not drawings then
                drawings = self:CreateDrawings()
                self.Cache[key] = drawings
            end

            local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            local roleColor = self:GetRoleColor(role, isAnimal)

            if onScreen then
                pcall(function() drawings.ArrowText.Visible = false end)

                local head = model:FindFirstChild("Head")
                local topPos = head and (head.Position + Vector3.new(0, 1.2, 0)) or (hrp.Position + Vector3.new(0, 3, 0))
                local bottomPos = hrp.Position - Vector3.new(0, 3, 0)
                
                local topScreen = Camera:WorldToViewportPoint(topPos)
                local bottomScreen = Camera:WorldToViewportPoint(bottomPos)
                
                local boxHeight = math.abs(bottomScreen.Y - topScreen.Y)
                local boxWidth = boxHeight * 0.65
                local boxPos = Vector2.new(screenPos.X - boxWidth / 2, topScreen.Y)

                if settings.ESP_Box2D then
                    pcall(function()
                        drawings.BoxOutline.Size = Vector2.new(boxWidth, boxHeight)
                        drawings.BoxOutline.Position = boxPos
                        drawings.BoxOutline.Color = Color3.fromRGB(0, 0, 0)
                        drawings.BoxOutline.Thickness = 3
                        drawings.BoxOutline.Filled = false
                        drawings.BoxOutline.Visible = true

                        drawings.Box.Size = Vector2.new(boxWidth, boxHeight)
                        drawings.Box.Position = boxPos
                        drawings.Box.Color = roleColor
                        drawings.Box.Thickness = 1.5
                        drawings.Box.Filled = false
                        drawings.Box.Visible = true
                    end)
                else
                    pcall(function()
                        drawings.BoxOutline.Visible = false
                        drawings.Box.Visible = false
                    end)
                end

                if settings.ESP_Name then
                    pcall(function()
                        drawings.Name.Text = string.format("[%s] %s", isAnimal and "ANIMAL" or role, name)
                        drawings.Name.Position = Vector2.new(screenPos.X, boxPos.Y - 16)
                        drawings.Name.Color = roleColor
                        drawings.Name.Size = 12
                        drawings.Name.Center = true
                        drawings.Name.Outline = true
                        drawings.Name.Visible = true
                    end)
                else
                    pcall(function() drawings.Name.Visible = false end)
                end

                if settings.ESP_Distance then
                    pcall(function()
                        drawings.Distance.Text = string.format("%d studs", math.floor(dist))
                        drawings.Distance.Position = Vector2.new(screenPos.X, boxPos.Y + boxHeight + 2)
                        drawings.Distance.Color = Color3.fromRGB(220, 220, 220)
                        drawings.Distance.Size = 11
                        drawings.Distance.Center = true
                        drawings.Distance.Outline = true
                        drawings.Distance.Visible = true
                    end)
                else
                    pcall(function() drawings.Distance.Visible = false end)
                end

                if settings.ESP_HealthBar then
                    pcall(function()
                        local hpPercent = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                        local barWidth = 4
                        local barPos = Vector2.new(boxPos.X - barWidth - 4, boxPos.Y)
                        
                        drawings.HealthOutline.Size = Vector2.new(barWidth, boxHeight)
                        drawings.HealthOutline.Position = barPos
                        drawings.HealthOutline.Color = Color3.fromRGB(0, 0, 0)
                        drawings.HealthOutline.Thickness = 1
                        drawings.HealthOutline.Filled = true
                        drawings.HealthOutline.Visible = true

                        local fillHeight = boxHeight * hpPercent
                        drawings.HealthFill.Size = Vector2.new(barWidth - 2, fillHeight)
                        drawings.HealthFill.Position = Vector2.new(barPos.X + 1, barPos.Y + (boxHeight - fillHeight))
                        drawings.HealthFill.Color = Color3.fromRGB(255, 0, 0):Lerp(Color3.fromRGB(0, 255, 100), hpPercent)
                        drawings.HealthFill.Thickness = 1
                        drawings.HealthFill.Filled = true
                        drawings.HealthFill.Visible = true
                    end)
                else
                    pcall(function()
                        drawings.HealthOutline.Visible = false
                        drawings.HealthFill.Visible = false
                    end)
                end

                if settings.ESP_Tracer then
                    pcall(function()
                        local viewportSize = Camera.ViewportSize
                        local startPos = Vector2.new(viewportSize.X / 2, viewportSize.Y)
                        if settings.ESP_TracerMode == "Center" then
                            startPos = Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)
                        elseif settings.ESP_TracerMode == "Top" then
                            startPos = Vector2.new(viewportSize.X / 2, 0)
                        end
                        drawings.Tracer.From = startPos
                        drawings.Tracer.To = Vector2.new(screenPos.X, boxPos.Y + boxHeight)
                        drawings.Tracer.Color = roleColor
                        drawings.Tracer.Thickness = 1.2
                        drawings.Tracer.Visible = true
                    end)
                else
                    pcall(function() drawings.Tracer.Visible = false end)
                end
            else
                pcall(function()
                    drawings.BoxOutline.Visible = false
                    drawings.Box.Visible = false
                    drawings.Name.Visible = false
                    drawings.Distance.Visible = false
                    drawings.HealthOutline.Visible = false
                    drawings.HealthFill.Visible = false
                    drawings.Tracer.Visible = false
                end)

                if settings.ESP_OffscreenArrow then
                    pcall(function()
                        local screenCenter = Camera.ViewportSize / 2
                        local objectSpace = Camera.CFrame:PointToObjectSpace(hrp.Position)
                        local dir = Vector2.new(-objectSpace.X, objectSpace.Z).Unit
                        
                        local margin = 60
                        local arrowPos = screenCenter + dir * (math.min(screenCenter.X, screenCenter.Y) - margin)

                        drawings.ArrowText.Text = string.format("▲ %d m", math.floor(dist))
                        drawings.ArrowText.Position = arrowPos
                        drawings.ArrowText.Color = roleColor
                        drawings.ArrowText.Size = 12
                        drawings.ArrowText.Center = true
                        drawings.ArrowText.Outline = true
                        drawings.ArrowText.Visible = true
                    end)
                else
                    pcall(function() drawings.ArrowText.Visible = false end)
                end
            end
        end

        for _, plr in ipairs(Engine.Services.Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local role = DeterminePlayerRole(plr)
                processModel(plr.Character, plr.Name, role, false)
            end
        end

        for _, animal in ipairs(self.CachedAnimals or {}) do
            if animal and animal.Parent then
                processModel(animal, animal.Name, "OOF", true)
            end
        end

        if settings.ESP_TargetHighlight and Engine.State.CurrentTarget and Engine.State.CurrentTarget.Parent then
            pcall(function()
                local tPos = Engine.State.CurrentTarget.Position
                local screenPos, onScreen = Camera:WorldToViewportPoint(tPos)
                if onScreen then
                    self.TargetDrawings.Ring.Position = Vector2.new(screenPos.X, screenPos.Y)
                    self.TargetDrawings.Ring.Radius = math.clamp(3500 / screenPos.Z, 15, 60)
                    self.TargetDrawings.Ring.Visible = true

                    self.TargetDrawings.Label.Text = "🎯 TARGET"
                    self.TargetDrawings.Label.Position = Vector2.new(screenPos.X, screenPos.Y - self.TargetDrawings.Ring.Radius - 16)
                    self.TargetDrawings.Label.Visible = true
                else
                    self.TargetDrawings.Ring.Visible = false
                    self.TargetDrawings.Label.Visible = false
                end
            end)
        else
            if self.TargetDrawings then
                pcall(function()
                    self.TargetDrawings.Ring.Visible = false
                    self.TargetDrawings.Label.Visible = false
                end)
            end
        end

        for key, drawings in pairs(self.Cache) do
            if not activeKeys[key] then
                self:RemoveDrawings(drawings)
                self.Cache[key] = nil
            end
        end
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
    while task.wait(0.25) do
        if Engine.Modules.ConfigManager.Settings.HitboxSize > 2 then
            for _, plr in ipairs(Engine.Services.Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character then
                    if DeterminePlayerRole(plr) ~= "NEUTRAL" then
                        local root = plr.Character:FindFirstChild("HumanoidRootPart")
                        if root then
                            pcall(function()
                                root.Size = Vector3.new(Engine.Modules.ConfigManager.Settings.HitboxSize, Engine.Modules.ConfigManager.Settings.HitboxSize, Engine.Modules.ConfigManager.Settings.HitboxSize)
                                root.Transparency = 0.75
                                root.CanCollide = false
                            end)
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
    if Engine.Modules.ConfigManager.Settings.AutoFarm and (Engine.State.CurrentRole == "ZOOKEEPER" or Engine.State.CurrentRole == "OOF") then
        Engine.Modules.FarmManager:Start()
    end
end)

local lastDetectedRole = DeterminePlayerRole(LocalPlayer)
Engine.Services.RunService.Heartbeat:Connect(function()
    local currentRole = DeterminePlayerRole(LocalPlayer)
    if currentRole ~= lastDetectedRole then
        local oldRole = lastDetectedRole
        lastDetectedRole = currentRole
        Engine.State.CurrentRole = currentRole
        Engine.Modules.NotificationManager:Notify("Role Changed!", string.format("🔄 Role vừa đổi: %s ➔ %s", oldRole, currentRole), 3.5)
        
        if Engine.Modules.ConfigManager.Settings.AutoFarm then
            if currentRole == "ZOOKEEPER" or currentRole == "OOF" then
                Engine.Modules.FarmManager:Start()
            else
                Engine.Modules.FarmManager:Stop()
                Engine.Modules.NotificationManager:Notify("Auto Farm Guard", "⚠️ Tự động dừng Auto Farm vì đã thành NEUTRAL (Human)!", 3.5)
            end
        end
    end
end)

-- ==========================================
-- [11] UI CONTROLLER
-- ==========================================
Engine.Modules.UIController = {
    ChromaObjects = {},
    Toggles = {},
    RegisteredLabels = {},
    MainFrame = nil,
    LogoButton = nil,
    BtnTopLang = nil,
    BtnSwitchLang = nil,
    
    AddHoverAnim = function(self, btn, defaultColor, hoverColor)
        local origSize = btn.Size
        btn.MouseEnter:Connect(function()
            Engine.Services.TweenService:Create(btn, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                BackgroundColor3 = hoverColor or (defaultColor and defaultColor:Lerp(Color3.fromRGB(255, 255, 255), 0.15) or Color3.fromRGB(40, 55, 80)),
                BackgroundTransparency = math.max(0, btn.BackgroundTransparency - 0.1)
            }):Play()
        end)
        btn.MouseLeave:Connect(function()
            Engine.Services.TweenService:Create(btn, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                BackgroundColor3 = defaultColor or btn.BackgroundColor3,
                BackgroundTransparency = btn.BackgroundTransparency
            }):Play()
        end)
        btn.MouseButton1Down:Connect(function()
            Engine.Services.TweenService:Create(btn, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(origSize.X.Scale, origSize.X.Offset - 2, origSize.Y.Scale, origSize.Y.Offset - 2)
            }):Play()
        end)
        btn.MouseButton1Up:Connect(function()
            Engine.Services.TweenService:Create(btn, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = origSize
            }):Play()
        end)
    end,

    RegisterLabel = function(self, obj, key, prefix, suffix, isSlider, configKey)
        table.insert(self.RegisteredLabels, {
            Obj = obj,
            Key = key,
            Prefix = prefix or "",
            Suffix = suffix or "",
            IsSlider = isSlider or false,
            ConfigKey = configKey
        })
    end,

    RefreshLanguage = function(self)
        for _, item in ipairs(self.RegisteredLabels) do
            if item.Obj and item.Obj.Parent then
                local txt = Engine.Modules.I18n:Get(item.Key)
                if item.IsSlider and item.ConfigKey then
                    local val = Engine.Modules.ConfigManager.Settings[item.ConfigKey] or 0
                    item.Obj.Text = item.Prefix .. txt .. ": " .. string.format("%.2f", val) .. item.Suffix
                else
                    item.Obj.Text = item.Prefix .. txt .. item.Suffix
                end
            end
        end
        if self.BtnTopLang then
            self.BtnTopLang.Text = "🌐 " .. (Engine.Modules.ConfigManager.Settings.Language or "VN")
        end
        if self.BtnSwitchLang then
            local curr = Engine.Modules.ConfigManager.Settings.Language or "VN"
            self.BtnSwitchLang.Text = (curr == "VN") and "🌐 Switch Language / Chuyển Ngôn Ngữ (VN ➔ EN)" or "🌐 Switch Language / Chuyển Ngôn Ngữ (EN ➔ VN)"
        end
    end,

    Init = function(self)
        local coreGui = LocalPlayer:WaitForChild("PlayerGui")
        local sg = Instance.new("ScreenGui")
        sg.Name = "RBZoo_V8_UI_LiquidGlass"
        sg.ResetOnSpawn = false
        sg.Parent = coreGui
        
        -- Floating Ultra-Cyber Crystal Orb Logo Holder (Draggable Container)
        local logoHolder = Instance.new("Frame")
        logoHolder.Name = "RBZoo_LogoHolder"
        logoHolder.Size = UDim2.new(0, 68, 0, 68)
        logoHolder.Position = UDim2.new(0, 24, 0.5, -34)
        logoHolder.BackgroundTransparency = 1
        logoHolder.Active = true
        logoHolder.Parent = sg

        self.LogoButton = Instance.new("TextButton")
        self.LogoButton.Size = UDim2.new(1, 0, 1, 0)
        self.LogoButton.Position = UDim2.new(0, 0, 0, 0)
        self.LogoButton.BackgroundColor3 = Color3.fromRGB(252, 254, 255)
        self.LogoButton.BackgroundTransparency = 0.15
        self.LogoButton.Text = ""
        self.LogoButton.Active = true
        self.LogoButton.Parent = logoHolder
        Instance.new("UICorner", self.LogoButton).CornerRadius = UDim.new(1, 0)

        -- Outer Hologram Glow Halo Ring (Pulsing)
        local outerGlowHalo = Instance.new("Frame")
        outerGlowHalo.Size = UDim2.new(1, 20, 1, 20)
        outerGlowHalo.Position = UDim2.new(0, -10, 0, -10)
        outerGlowHalo.BackgroundColor3 = Color3.fromRGB(0, 220, 255)
        outerGlowHalo.BackgroundTransparency = 0.8
        outerGlowHalo.Parent = self.LogoButton
        Instance.new("UICorner", outerGlowHalo).CornerRadius = UDim.new(1, 0)
        table.insert(self.ChromaObjects, outerGlowHalo)

        -- Inner Rotating Rainbow Stroke Ring
        local logoStroke = Instance.new("UIStroke")
        logoStroke.Thickness = 3
        logoStroke.Transparency = 0.1
        logoStroke.Parent = self.LogoButton
        table.insert(self.ChromaObjects, logoStroke)
        table.insert(self.ChromaObjects, self.LogoButton)
        
        local logoAsset = Engine:GetLogoAsset()
        local logoImg = Instance.new("ImageLabel")
        logoImg.Size = UDim2.new(1, -8, 1, -8)
        logoImg.Position = UDim2.new(0, 4, 0, 4)
        logoImg.BackgroundTransparency = 1
        if logoAsset then logoImg.Image = logoAsset end
        logoImg.ScaleType = Enum.ScaleType.Crop
        logoImg.Parent = self.LogoButton
        Instance.new("UICorner", logoImg).CornerRadius = UDim.new(1, 0)

        -- Pulsing Radar Waves on Online Status Dot
        local radarWave = Instance.new("Frame")
        radarWave.Size = UDim2.new(0, 14, 0, 14)
        radarWave.Position = UDim2.new(1, -13, 1, -13)
        radarWave.BackgroundColor3 = Color3.fromRGB(0, 255, 160)
        radarWave.BackgroundTransparency = 0.5
        radarWave.Parent = self.LogoButton
        Instance.new("UICorner", radarWave).CornerRadius = UDim.new(1, 0)

        local onlineDot = Instance.new("Frame")
        onlineDot.Size = UDim2.new(0, 12, 0, 12)
        onlineDot.Position = UDim2.new(1, -12, 1, -12)
        onlineDot.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
        onlineDot.Parent = self.LogoButton
        Instance.new("UICorner", onlineDot).CornerRadius = UDim.new(1, 0)

        local onlineDotStroke = Instance.new("UIStroke")
        onlineDotStroke.Thickness = 1.5
        onlineDotStroke.Color = Color3.fromRGB(15, 22, 36)
        onlineDotStroke.Parent = onlineDot

        -- Mini VIP Hologram Label Badge attached to Logo
        local logoBadge = Instance.new("Frame")
        logoBadge.Size = UDim2.new(0, 80, 0, 18)
        logoBadge.Position = UDim2.new(0.5, -40, 1, 4)
        logoBadge.BackgroundColor3 = Color3.fromRGB(250, 252, 255)
        logoBadge.BackgroundTransparency = 0.2
        logoBadge.Parent = self.LogoButton
        Instance.new("UICorner", logoBadge).CornerRadius = UDim.new(0, 9)

        local badgeStroke = Instance.new("UIStroke")
        badgeStroke.Thickness = 1.2
        badgeStroke.Color = Color3.fromRGB(0, 200, 255)
        badgeStroke.Parent = logoBadge
        table.insert(self.ChromaObjects, badgeStroke)

        local badgeText = Instance.new("TextLabel")
        badgeText.Size = UDim2.new(1, 0, 1, 0)
        badgeText.BackgroundTransparency = 1
        badgeText.Text = "⚡ CLASS QUID"
        badgeText.Font = Enum.Font.GothamBlack
        badgeText.TextSize = 8.5
        badgeText.TextColor3 = Color3.fromRGB(15, 25, 45)
        badgeText.Parent = logoBadge

        -- Continuous 60 FPS Levitation (Up & Down Floating) & Vibrant Rainbow Chroma Cycling
        task.spawn(function()
            local tickCounter = 0
            
            Engine.Services.RunService.RenderStepped:Connect(function(dt)
                tickCounter = tickCounter + dt
                
                -- 1. Smooth Floating Up and Down inside Draggable logoHolder (10px amplitude)
                local hoverY = math.sin(tickCounter * 2.2) * 10
                self.LogoButton.Position = UDim2.new(0, 0, 0, hoverY)
                
                -- 2. Dynamic Rainbow Chroma Cycling (Color3.fromHSV)
                local chromaColor = Color3.fromHSV((tickCounter * 0.35) % 1, 0.85, 1)
                local chromaColor2 = Color3.fromHSV(((tickCounter * 0.35) + 0.25) % 1, 0.85, 1)
                
                logoStroke.Color = chromaColor
                outerGlowHalo.BackgroundColor3 = chromaColor
                badgeStroke.Color = chromaColor2
                
                -- 3. Outer Halo Pulsing & Breathing
                local pulseScale = 22 + math.sin(tickCounter * 3.5) * 8
                local pulseTrans = 0.7 + math.sin(tickCounter * 3.5) * 0.18
                outerGlowHalo.Size = UDim2.new(1, pulseScale, 1, pulseScale)
                outerGlowHalo.Position = UDim2.new(0, -pulseScale/2, 0, -pulseScale/2)
                outerGlowHalo.BackgroundTransparency = pulseTrans
                
                -- 4. Radar Wave Ping Animation
                local waveSize = 12 + ((tickCounter * 22) % 16)
                local waveAlpha = (16 - (waveSize - 12)) / 16 * 0.75
                radarWave.Size = UDim2.new(0, waveSize, 0, waveSize)
                radarWave.Position = UDim2.new(1, -6 - (waveSize/2), 1, -6 - (waveSize/2))
                radarWave.BackgroundTransparency = math.clamp(1 - waveAlpha, 0.25, 1)
                radarWave.BackgroundColor3 = Color3.fromRGB(0, 255, 160)

                -- Retry logo asset if needed
                local retryAsset = Engine:GetLogoAsset()
                if retryAsset and logoImg.Image ~= retryAsset then
                    logoImg.Image = retryAsset
                end
            end)
        end)

        -- Micro-Animations: Hover Scale & Elastic Bounce
        self.LogoButton.MouseEnter:Connect(function()
            Engine.Services.TweenService:Create(self.LogoButton, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 76, 0, 76),
                BackgroundTransparency = 0.05
            }):Play()
            Engine.Services.TweenService:Create(logoImg, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Rotation = 12
            }):Play()
        end)

        self.LogoButton.MouseLeave:Connect(function()
            Engine.Services.TweenService:Create(self.LogoButton, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 68, 0, 68),
                BackgroundTransparency = 0.15
            }):Play()
            Engine.Services.TweenService:Create(logoImg, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Rotation = 0
            }):Play()
        end)

        -- Custom Touch & Mouse Dragging Engine for Logo & Avatar Image
        local isDraggingLogo = false
        local dragStartPos = nil
        local startHolderPos = nil
        local dragDistance = 0

        local function handleInputBegan(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                isDraggingLogo = true
                dragStartPos = input.Position
                startHolderPos = logoHolder.Position
                dragDistance = 0
                
                local connChanged, connEnded
                connChanged = Engine.Services.UIS.InputChanged:Connect(function(inp)
                    if (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) and isDraggingLogo then
                        local delta = inp.Position - dragStartPos
                        dragDistance = dragDistance + math.abs(delta.X) + math.abs(delta.Y)
                        logoHolder.Position = UDim2.new(
                            startHolderPos.X.Scale, startHolderPos.X.Offset + delta.X,
                            startHolderPos.Y.Scale, startHolderPos.Y.Offset + delta.Y
                        )
                    end
                end)
                
                connEnded = Engine.Services.UIS.InputEnded:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                        isDraggingLogo = false
                        if connChanged then connChanged:Disconnect() end
                        if connEnded then connEnded:Disconnect() end
                        
                        -- If user tapped without dragging, toggle Main Menu
                        if dragDistance < 8 then
                            Engine.Services.TweenService:Create(self.LogoButton, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                                Size = UDim2.new(1, -8, 1, -8)
                            }):Play()
                            task.delay(0.1, function()
                                Engine.Services.TweenService:Create(self.LogoButton, TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                                    Size = UDim2.new(1, 0, 1, 0)
                                }):Play()
                            end)
                            self.MainFrame.Visible = not self.MainFrame.Visible
                        end
                    end
                end)
            end
        end

        self.LogoButton.InputBegan:Connect(handleInputBegan)
        logoHolder.InputBegan:Connect(handleInputBegan)
        
        -- Main Cyberpunk Liquid Glass Frame
        self.MainFrame = Instance.new("Frame")
        self.MainFrame.Size = UDim2.new(0, 580, 0, 400)
        self.MainFrame.Position = UDim2.new(0.5, -290, 0.5, -200)
        self.MainFrame.BackgroundColor3 = Color3.fromRGB(246, 250, 255)
        self.MainFrame.BackgroundTransparency = 0.42
        self.MainFrame.Active = true
        self.MainFrame.Draggable = true
        self.MainFrame.ClipsDescendants = true
        self.MainFrame.Parent = sg
        Instance.new("UICorner", self.MainFrame).CornerRadius = UDim.new(0, 20)
        
        local mainStroke = Instance.new("UIStroke")
        mainStroke.Thickness = 1.8
        mainStroke.Transparency = 0.25
        mainStroke.Parent = self.MainFrame
        table.insert(self.ChromaObjects, mainStroke)
        
        local topBar = Instance.new("Frame")
        topBar.Size = UDim2.new(1, 0, 0, 58)
        topBar.BackgroundTransparency = 1
        topBar.Parent = self.MainFrame

        local headerLogoAsset = Engine:GetLogoAsset()
        local titleLeftPos = 68

        local headerLogoFrame = Instance.new("Frame")
        headerLogoFrame.Size = UDim2.new(0, 42, 0, 42)
        headerLogoFrame.Position = UDim2.new(0, 14, 0, 8)
        headerLogoFrame.BackgroundColor3 = Color3.fromRGB(16, 22, 36)
        headerLogoFrame.Parent = topBar
        Instance.new("UICorner", headerLogoFrame).CornerRadius = UDim.new(0, 12)

        local headerLogoImg = Instance.new("ImageLabel")
        headerLogoImg.Size = UDim2.new(1, -4, 1, -4)
        headerLogoImg.Position = UDim2.new(0, 2, 0, 2)
        headerLogoImg.BackgroundTransparency = 1
        if headerLogoAsset then headerLogoImg.Image = headerLogoAsset end
        headerLogoImg.ScaleType = Enum.ScaleType.Crop
        headerLogoImg.Parent = headerLogoFrame
        Instance.new("UICorner", headerLogoImg).CornerRadius = UDim.new(0, 10)

        local headerLogoStroke = Instance.new("UIStroke")
        headerLogoStroke.Thickness = 1.8
        headerLogoStroke.Color = Color3.fromRGB(0, 240, 255)
        headerLogoStroke.Parent = headerLogoFrame
        table.insert(self.ChromaObjects, headerLogoStroke)

        task.spawn(function()
            task.wait(0.5)
            local retryAsset = Engine:GetLogoAsset()
            if retryAsset and headerLogoImg.Image ~= retryAsset then
                headerLogoImg.Image = retryAsset
            end
        end)

        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, -(titleLeftPos + 275), 0, 26)
        title.Position = UDim2.new(0, titleLeftPos, 0, 8)
        title.BackgroundTransparency = 1
        title.Text = "⚡ CLASS QUID VIP • V8.5"
        title.Font = Enum.Font.GothamBlack
        title.TextSize = 14
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Parent = topBar
        table.insert(self.ChromaObjects, title)

        local authorLabel = Instance.new("TextLabel")
        authorLabel.Size = UDim2.new(1, -(titleLeftPos + 275), 0, 16)
        authorLabel.Position = UDim2.new(0, titleLeftPos, 0, 32)
        authorLabel.BackgroundTransparency = 1
        authorLabel.Text = "👑 Owner: " .. Engine.Author .. "  |  VIP ENGINE 2026"
        authorLabel.Font = Enum.Font.GothamBold
        authorLabel.TextSize = 9.5
        authorLabel.TextColor3 = Color3.fromRGB(0, 150, 220)
        authorLabel.TextXAlignment = Enum.TextXAlignment.Left
        authorLabel.Parent = topBar

        self.BtnTopLang = Instance.new("TextButton")
        self.BtnTopLang.Size = UDim2.new(0, 72, 0, 28)
        self.BtnTopLang.Position = UDim2.new(1, -262, 0, 15)
        self.BtnTopLang.BackgroundColor3 = Color3.fromRGB(230, 238, 252)
        self.BtnTopLang.Text = "🌐 " .. (Engine.Modules.ConfigManager.Settings.Language or "VN")
        self.BtnTopLang.Font = Enum.Font.GothamBold
        self.BtnTopLang.TextSize = 11
        self.BtnTopLang.TextColor3 = Color3.fromRGB(0, 140, 220)
        self.BtnTopLang.Parent = topBar
        Instance.new("UICorner", self.BtnTopLang).CornerRadius = UDim.new(0, 8)
        self:AddHoverAnim(self.BtnTopLang, Color3.fromRGB(18, 26, 42), Color3.fromRGB(28, 40, 64))
        
        self.BtnTopLang.MouseButton1Click:Connect(function()
            local newLang = Engine.Modules.I18n:ToggleLang()
            self:RefreshLanguage()
            if Engine.Modules.NotificationManager and Engine.Modules.NotificationManager.Notify then
                Engine.Modules.NotificationManager:Notify("Language / Ngôn Ngữ", (newLang == "VN") and "✓ Đã chuyển sang Tiếng Việt!" or "✓ Switched language to English!", 3)
            end
        end)

        local btnTopDiscord = Instance.new("TextButton")
        btnTopDiscord.Size = UDim2.new(0, 85, 0, 28)
        btnTopDiscord.Position = UDim2.new(1, -185, 0, 15)
        btnTopDiscord.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
        btnTopDiscord.Text = "💬 Discord"
        btnTopDiscord.Font = Enum.Font.GothamBold
        btnTopDiscord.TextSize = 11
        btnTopDiscord.TextColor3 = Color3.fromRGB(255, 255, 255)
        btnTopDiscord.Parent = topBar
        Instance.new("UICorner", btnTopDiscord).CornerRadius = UDim.new(0, 8)
        self:AddHoverAnim(btnTopDiscord, Color3.fromRGB(88, 101, 242), Color3.fromRGB(105, 118, 255))
        btnTopDiscord.MouseButton1Click:Connect(function()
            Engine.Modules.KeySystem:JoinDiscord()
        end)

        local btnTopGetKey = Instance.new("TextButton")
        btnTopGetKey.Size = UDim2.new(0, 85, 0, 28)
        btnTopGetKey.Position = UDim2.new(1, -95, 0, 15)
        btnTopGetKey.BackgroundColor3 = Color3.fromRGB(22, 35, 56)
        btnTopGetKey.Text = "🌐 Get Key"
        btnTopGetKey.Font = Enum.Font.GothamBold
        btnTopGetKey.TextSize = 11
        btnTopGetKey.TextColor3 = Color3.fromRGB(0, 240, 255)
        btnTopGetKey.Parent = topBar
        Instance.new("UICorner", btnTopGetKey).CornerRadius = UDim.new(0, 8)
        self:AddHoverAnim(btnTopGetKey, Color3.fromRGB(22, 35, 56), Color3.fromRGB(34, 52, 82))
        btnTopGetKey.MouseButton1Click:Connect(function()
            if setclipboard or toclipboard then
                pcall(function() (setclipboard or toclipboard)(Engine.Modules.KeySystem.KeyURL) end)
            end
            if Engine.Modules.NotificationManager and Engine.Modules.NotificationManager.Notify then
                Engine.Modules.NotificationManager:Notify("Get Key", "✓ Đã sao chép Link Get Key 24h!", 3)
            end
        end)

        local line = Instance.new("Frame")
        line.Size = UDim2.new(1, -30, 0, 1)
        line.Position = UDim2.new(0, 15, 1, -1)
        line.BorderSizePixel = 0
        line.BackgroundTransparency = 0.5
        line.Parent = topBar
        table.insert(self.ChromaObjects, line)
        
        local contentArea = Instance.new("Frame")
        contentArea.Size = UDim2.new(1, 0, 1, -58)
        contentArea.Position = UDim2.new(0, 0, 0, 58)
        contentArea.BackgroundTransparency = 1
        contentArea.Parent = self.MainFrame
        
        self:BuildTabs(contentArea)
        
        task.spawn(function()
            while task.wait(0.08) do
                if self.MainFrame and self.MainFrame.Visible then
                    local hue = (tick() % 6) / 6
                    local color = Color3.fromHSV(hue, 0.75, 1)
                    for _, obj in ipairs(self.ChromaObjects) do
                        if obj and obj.Parent then
                            if obj:IsA("UIStroke") then obj.Color = color
                            elseif obj:IsA("TextLabel") or obj:IsA("TextButton") then obj.TextColor3 = color
                            elseif obj:IsA("Frame") and (obj.Size.Y.Offset == 1 or obj.Name == "ToggledBG") then obj.BackgroundColor3 = color end
                        end
                    end
                end
            end
        end)
        
        -- HOTKEYS QUICK CONTROLS: P (Farm), M (Aimbot), F (Fly), Q/E (Skill), RightShift (UI)
        Engine.Services.UIS.InputBegan:Connect(function(input)
            if Engine.Services.UIS:GetFocusedTextBox() then return end
            if input.UserInputType ~= Enum.UserInputType.Keyboard then return end

            if input.KeyCode == Enum.KeyCode.RightShift then
                if self.MainFrame then
                    self.MainFrame.Visible = not self.MainFrame.Visible
                end
            elseif input.KeyCode == Enum.KeyCode.P then
                local newState = not Engine.Modules.ConfigManager.Settings.AutoFarm
                Engine.Modules.ConfigManager.Settings.AutoFarm = newState
                Engine.Modules.ConfigManager:Save()
                
                if newState then 
                    Engine.Modules.FarmManager:Start() 
                else 
                    Engine.Modules.FarmManager:Stop() 
                end

                if self.Toggles["AutoFarm"] then
                    self.Toggles["AutoFarm"](newState)
                end

                Engine.Modules.NotificationManager:Notify("Hotkey [P]", "Hunter AI Auto Farm: " .. (newState and "BẬT [ON]" or "TẮT [OFF]"), 2)
            elseif input.KeyCode == Enum.KeyCode.M then
                local newState = not Engine.Modules.ConfigManager.Settings.Aimbot
                Engine.Modules.ConfigManager.Settings.Aimbot = newState
                Engine.Modules.ConfigManager:Save()
                if self.Toggles["Aimbot"] then self.Toggles["Aimbot"](newState) end
                Engine.Modules.NotificationManager:Notify("Hotkey [M]", "Smart Aimbot: " .. (newState and "BẬT [ON]" or "TẮT [OFF]"), 2)
            elseif input.KeyCode == Enum.KeyCode.F then
                local newState = not Engine.Modules.ConfigManager.Settings.Fly
                Engine.Modules.ConfigManager.Settings.Fly = newState
                Engine.Modules.ConfigManager:Save()
                if self.Toggles["Fly"] then self.Toggles["Fly"](newState) end
                Engine.Modules.NotificationManager:Notify("Hotkey [F]", "Fly Mode: " .. (newState and "BẬT [ON]" or "TẮT [OFF]"), 2)
            elseif input.KeyCode == Enum.KeyCode.Q or input.KeyCode == Enum.KeyCode.E then
                if Engine.Modules.ConfigManager.Settings.AutoSkill then
                    Engine.Modules.NotificationManager:Notify("Skill Hotkey", "Skill Activated! [" .. input.KeyCode.Name .. "]", 1.5)
                end
            end
        end)
    end,
    
    CreateSectionHeader = function(self, parent, translationKey)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -10, 0, 30)
        frame.BackgroundColor3 = Color3.fromRGB(228, 238, 252)
        frame.BackgroundTransparency = 0.52
        frame.Parent = parent
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

        local lineLeft = Instance.new("Frame")
        lineLeft.Size = UDim2.new(0, 4, 1, -8)
        lineLeft.Position = UDim2.new(0, 4, 0, 4)
        lineLeft.BackgroundColor3 = Color3.fromRGB(0, 240, 255)
        lineLeft.Parent = frame
        Instance.new("UICorner", lineLeft).CornerRadius = UDim.new(1, 0)
        table.insert(self.ChromaObjects, lineLeft)

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -20, 1, 0)
        label.Position = UDim2.new(0, 14, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = Engine.Modules.I18n:Get(translationKey)
        label.TextColor3 = Color3.fromRGB(15, 25, 45)
        label.Font = Enum.Font.GothamBlack
        label.TextSize = 11
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = frame
        
        self:RegisterLabel(label, translationKey)
        table.insert(self.ChromaObjects, label)
    end,

    BuildTabs = function(self, parent)
        local tabContainer = Instance.new("Frame")
        tabContainer.Size = UDim2.new(0, 150, 1, -20)
        tabContainer.Position = UDim2.new(0, 12, 0, 10)
        tabContainer.BackgroundColor3 = Color3.fromRGB(232, 240, 252)
        tabContainer.BackgroundTransparency = 0.55
        tabContainer.Parent = parent
        Instance.new("UICorner", tabContainer).CornerRadius = UDim.new(0, 14)

        local tabStroke = Instance.new("UIStroke")
        tabStroke.Thickness = 1.2
        tabStroke.Color = Color3.fromRGB(0, 240, 255)
        tabStroke.Transparency = 0.8
        tabStroke.Parent = tabContainer

        local tabList = Instance.new("UIListLayout")
        tabList.SortOrder = Enum.SortOrder.LayoutOrder
        tabList.Padding = UDim.new(0, 6)
        tabList.Parent = tabContainer

        local pad = Instance.new("UIPadding")
        pad.PaddingTop = UDim.new(0, 8)
        pad.PaddingLeft = UDim.new(0, 6)
        pad.PaddingRight = UDim.new(0, 6)
        pad.Parent = tabContainer
        
        local pageContainer = Instance.new("Frame")
        pageContainer.Size = UDim2.new(1, -180, 1, -20)
        pageContainer.Position = UDim2.new(0, 170, 0, 10)
        pageContainer.BackgroundTransparency = 1
        pageContainer.Parent = parent
        
        local pages = {}
        local tabButtons = {}
        
        local function createTab(translationKey, first)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 36)
            btn.BackgroundColor3 = first and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(240, 246, 255)
            btn.BackgroundTransparency = first and 0.85 or 1
            btn.Text = "  " .. Engine.Modules.I18n:Get(translationKey)
            btn.TextColor3 = first and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(45, 62, 88)
            btn.Font = Enum.Font.GothamBlack
            btn.TextSize = 11.5
            btn.TextXAlignment = Enum.TextXAlignment.Left
            btn.Parent = tabContainer
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

            self:RegisterLabel(btn, translationKey, "  ")
            
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
                table.insert(self.ChromaObjects, btn)
            end
            
            btn.MouseButton1Click:Connect(function()
                for _, p in pairs(pages) do 
                    if p.Visible then p.Visible = false end 
                end
                for _, b in pairs(tabButtons) do 
                    Engine.Services.TweenService:Create(b, TweenInfo.new(0.2), {
                        TextColor3 = Color3.fromRGB(45, 62, 88),
                        BackgroundTransparency = 1
                    }):Play() 
                end
                page.Visible = true
                page.CanvasPosition = Vector2.new(0, 0)
                Engine.Services.TweenService:Create(btn, TweenInfo.new(0.2), {
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundColor3 = Color3.fromRGB(0, 180, 255),
                    BackgroundTransparency = 0
                }):Play()
                table.insert(self.ChromaObjects, btn)
            end)
            
            table.insert(pages, page)
            table.insert(tabButtons, btn)
            return page
        end
        
        local pageForce = createTab("TabTeamForce", true)
        local pageCombat = createTab("TabCombat", false)
        local pageFarm = createTab("TabFarm", false)
        local pageMovement = createTab("TabMovement", false)
        local pageESP = createTab("TabESP", false)
        local pageKey = createTab("TabKey", false)
        local pageLang = createTab("TabLanguage", false)
        
        self:CreateSectionHeader(pageForce, "SecTeam")
        self:CreateToggle(pageForce, "ForceZoo", "ForceZookeeper", function(v)
            if v then Engine.Modules.TeamForce:TryForceZoo() end
        end)
        self:CreateToggle(pageForce, "ShowHUD", "ShowHUD")
        self:CreateToggle(pageForce, "FPSBooster", "FPSBooster", function(v)
            if v then Engine.Modules.PerformanceBooster:Init() end
        end)
        
        self:CreateSectionHeader(pageCombat, "SecCombat")
        self:CreateToggle(pageCombat, "SmartAimbot", "Aimbot")
        self:CreateSlider(pageCombat, "AimbotFOV", 50, 600, "AimbotFOV")
        self:CreateSlider(pageCombat, "AimbotSmooth", 0.05, 1, "AimbotSmooth")
        self:CreateToggle(pageCombat, "AutoAttack", "AutoAttack")
        self:CreateToggle(pageCombat, "AutoSkill", "AutoSkill")
        self:CreateSlider(pageCombat, "HitboxSize", 2, 25, "HitboxSize")
        
        self:CreateSectionHeader(pageFarm, "SecFarm")
        self:CreateToggle(pageFarm, "AutoFarm", "AutoFarm", function(v)
            if v then Engine.Modules.FarmManager:Start() else Engine.Modules.FarmManager:Stop() end
        end)
        self:CreateToggle(pageFarm, "AutoDodge", "AutoDodge")
        self:CreateSlider(pageFarm, "DodgeRadius", 5, 50, "DodgeRadius")
        self:CreateToggle(pageFarm, "SmartWallBypass", "SmartWallBypass")
        self:CreateSlider(pageFarm, "AutoFarmSpeed", 30, 250, "AutoFarmSpeed")
        self:CreateSlider(pageFarm, "AutoFarmHeight", 50, 1500, "AutoFarmHeight")
        self:CreateToggle(pageFarm, "AntiStuck", "AntiStuck")
        self:CreateToggle(pageFarm, "AutoMoney", "AutoMoney")
        self:CreateToggle(pageFarm, "AntiAFK", "AntiAFK")
        
        self:CreateSectionHeader(pageMovement, "SecMovement")
        self:CreateToggle(pageMovement, "Fly", "Fly")
        self:CreateSlider(pageMovement, "FlySpeed", 50, 350, "FlySpeed")
        self:CreateToggle(pageMovement, "WalkSpeed", "Speed")
        self:CreateSlider(pageMovement, "SpeedValue", 16, 100, "SpeedValue")
        self:CreateToggle(pageMovement, "Noclip", "Noclip")
        self:CreateToggle(pageMovement, "InfJump", "InfJump")
        
        self:CreateSectionHeader(pageESP, "SecESP")
        self:CreateToggle(pageESP, "ESP_Enabled", "ESP_Enabled")
        self:CreateToggle(pageESP, "ESP_Box2D", "ESP_Box2D")
        self:CreateToggle(pageESP, "ESP_Name", "ESP_Name")
        self:CreateToggle(pageESP, "ESP_Distance", "ESP_Distance")
        self:CreateToggle(pageESP, "ESP_HealthBar", "ESP_HealthBar")
        self:CreateToggle(pageESP, "ESP_Tracer", "ESP_Tracer")
        self:CreateToggle(pageESP, "ESP_OffscreenArrow", "ESP_OffscreenArrow")
        self:CreateToggle(pageESP, "ESP_TargetHighlight", "ESP_TargetHighlight")
        self:CreateSlider(pageESP, "ESP_MaxDistance", 100, 3000, "ESP_MaxDistance")
        
        self:CreateSectionHeader(pageLang, "SecLang")
        self.BtnSwitchLang = Instance.new("TextButton")
        self.BtnSwitchLang.Size = UDim2.new(1, -10, 0, 44)
        self.BtnSwitchLang.BackgroundColor3 = Color3.fromRGB(22, 32, 52)
        local currLang = Engine.Modules.ConfigManager.Settings.Language or "VN"
        self.BtnSwitchLang.Text = (currLang == "VN") and "🌐 Switch Language / Chuyển Ngôn Ngữ (VN ➔ EN)" or "🌐 Switch Language / Chuyển Ngôn Ngữ (EN ➔ VN)"
        self.BtnSwitchLang.Font = Enum.Font.GothamBold
        self.BtnSwitchLang.TextSize = 11
        self.BtnSwitchLang.TextColor3 = Color3.fromRGB(0, 255, 180)
        self.BtnSwitchLang.Parent = pageLang
        Instance.new("UICorner", self.BtnSwitchLang).CornerRadius = UDim.new(0, 10)
        self:AddHoverAnim(self.BtnSwitchLang, Color3.fromRGB(22, 32, 52), Color3.fromRGB(34, 48, 76))
        
        self.BtnSwitchLang.MouseButton1Click:Connect(function()
            local newLang = Engine.Modules.I18n:ToggleLang()
            self:RefreshLanguage()
            if Engine.Modules.NotificationManager and Engine.Modules.NotificationManager.Notify then
                Engine.Modules.NotificationManager:Notify("Language / Ngôn Ngữ", (newLang == "VN") and "✓ Đã chuyển sang Tiếng Việt!" or "✓ Switched language to English!", 3)
            end
        end)

        self:CreateSectionHeader(pageKey, "SecKey")
        local keyCard = Instance.new("Frame")
        keyCard.Size = UDim2.new(1, -10, 0, 210)
        keyCard.BackgroundColor3 = Color3.fromRGB(16, 22, 35)
        keyCard.BackgroundTransparency = 0.45
        keyCard.Parent = pageKey
        Instance.new("UICorner", keyCard).CornerRadius = UDim.new(0, 12)

        local cardStroke = Instance.new("UIStroke")
        cardStroke.Thickness = 1
        cardStroke.Color = Color3.fromRGB(0, 240, 255)
        cardStroke.Transparency = 0.85
        cardStroke.Parent = keyCard
        
        local keyTitle = Instance.new("TextLabel")
        keyTitle.Size = UDim2.new(1, -20, 0, 24)
        keyTitle.Position = UDim2.new(0, 12, 0, 8)
        keyTitle.BackgroundTransparency = 1
        keyTitle.Text = Engine.Modules.I18n:Get("KeyInfoTitle")
        keyTitle.Font = Enum.Font.GothamBlack
        keyTitle.TextSize = 12.5
        keyTitle.TextColor3 = Color3.fromRGB(0, 240, 255)
        keyTitle.TextXAlignment = Enum.TextXAlignment.Left
        keyTitle.Parent = keyCard
        self:RegisterLabel(keyTitle, "KeyInfoTitle")
        
        local keyValLabel = Instance.new("TextLabel")
        keyValLabel.Size = UDim2.new(1, -24, 0, 20)
        keyValLabel.Position = UDim2.new(0, 12, 0, 36)
        keyValLabel.BackgroundTransparency = 1
        keyValLabel.Text = Engine.Modules.I18n:Get("KeyVal") .. (Engine.Modules.KeySystem.SavedKey ~= "" and Engine.Modules.KeySystem.SavedKey or "N/A")
        keyValLabel.Font = Enum.Font.GothamMedium
        keyValLabel.TextSize = 11
        keyValLabel.TextColor3 = Color3.fromRGB(220, 230, 245)
        keyValLabel.TextXAlignment = Enum.TextXAlignment.Left
        keyValLabel.Parent = keyCard
        self:RegisterLabel(keyValLabel, "KeyVal", "", (Engine.Modules.KeySystem.SavedKey ~= "" and Engine.Modules.KeySystem.SavedKey or "N/A"))

        local keyTimeLabel = Instance.new("TextLabel")
        keyTimeLabel.Size = UDim2.new(1, -24, 0, 20)
        keyTimeLabel.Position = UDim2.new(0, 12, 0, 58)
        keyTimeLabel.BackgroundTransparency = 1
        keyTimeLabel.Text = Engine.Modules.I18n:Get("KeyRemaining") .. Engine.Modules.KeySystem:GetRemainingTime()
        keyTimeLabel.Font = Enum.Font.GothamMedium
        keyTimeLabel.TextSize = 11
        keyTimeLabel.TextColor3 = Color3.fromRGB(0, 255, 180)
        keyTimeLabel.TextXAlignment = Enum.TextXAlignment.Left
        keyTimeLabel.Parent = keyCard
        self:RegisterLabel(keyTimeLabel, "KeyRemaining")
        
        task.spawn(function()
            while task.wait(1) do
                if pageKey and pageKey.Visible then
                    keyTimeLabel.Text = Engine.Modules.I18n:Get("KeyRemaining") .. Engine.Modules.KeySystem:GetRemainingTime()
                end
            end
        end)

        local btnCardGetKey = Instance.new("TextButton")
        btnCardGetKey.Size = UDim2.new(1, -24, 0, 32)
        btnCardGetKey.Position = UDim2.new(0, 12, 0, 88)
        btnCardGetKey.BackgroundColor3 = Color3.fromRGB(22, 35, 56)
        btnCardGetKey.Text = Engine.Modules.I18n:Get("KeyWebBtn")
        btnCardGetKey.Font = Enum.Font.GothamBold
        btnCardGetKey.TextSize = 10
        btnCardGetKey.TextColor3 = Color3.fromRGB(0, 240, 255)
        btnCardGetKey.Parent = keyCard
        Instance.new("UICorner", btnCardGetKey).CornerRadius = UDim.new(0, 8)
        self:AddHoverAnim(btnCardGetKey, Color3.fromRGB(22, 35, 56), Color3.fromRGB(34, 52, 82))
        self:RegisterLabel(btnCardGetKey, "KeyWebBtn")
        btnCardGetKey.MouseButton1Click:Connect(function()
            if setclipboard or toclipboard then
                pcall(function() (setclipboard or toclipboard)(Engine.Modules.KeySystem.KeyURL) end)
            end
            if Engine.Modules.NotificationManager and Engine.Modules.NotificationManager.Notify then
                Engine.Modules.NotificationManager:Notify("Get Key", "✓ Đã sao chép Link Get Key 24h!", 3)
            end
        end)

        local btnCardDiscord = Instance.new("TextButton")
        btnCardDiscord.Size = UDim2.new(1, -24, 0, 32)
        btnCardDiscord.Position = UDim2.new(0, 12, 0, 126)
        btnCardDiscord.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
        btnCardDiscord.Text = Engine.Modules.I18n:Get("KeyDiscordBtn")
        btnCardDiscord.Font = Enum.Font.GothamBold
        btnCardDiscord.TextSize = 10
        btnCardDiscord.TextColor3 = Color3.fromRGB(255, 255, 255)
        btnCardDiscord.Parent = keyCard
        Instance.new("UICorner", btnCardDiscord).CornerRadius = UDim.new(0, 8)
        self:AddHoverAnim(btnCardDiscord, Color3.fromRGB(88, 101, 242), Color3.fromRGB(105, 118, 255))
        self:RegisterLabel(btnCardDiscord, "KeyDiscordBtn")
        btnCardDiscord.MouseButton1Click:Connect(function()
            Engine.Modules.KeySystem:JoinDiscord()
        end)
        
        local btnLogout = Instance.new("TextButton")
        btnLogout.Size = UDim2.new(1, -24, 0, 32)
        btnLogout.Position = UDim2.new(0, 12, 0, 164)
        btnLogout.BackgroundColor3 = Color3.fromRGB(210, 45, 55)
        btnLogout.Text = Engine.Modules.I18n:Get("BtnLogout")
        btnLogout.Font = Enum.Font.GothamBlack
        btnLogout.TextSize = 11
        btnLogout.TextColor3 = Color3.fromRGB(255, 255, 255)
        btnLogout.Parent = keyCard
        Instance.new("UICorner", btnLogout).CornerRadius = UDim.new(0, 8)
        self:AddHoverAnim(btnLogout, Color3.fromRGB(210, 45, 55), Color3.fromRGB(235, 65, 75))
        self:RegisterLabel(btnLogout, "BtnLogout")
        
        btnLogout.MouseButton1Click:Connect(function()
            Engine.Modules.KeySystem:Logout()
        end)
        
        for _, p in pairs(pages) do p.CanvasSize = UDim2.new(0, 0, 0, #p:GetChildren() * 52) end
    end,
    
    CreateToggle = function(self, parent, translationKey, configKey, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -10, 0, 44)
        frame.BackgroundColor3 = Color3.fromRGB(238, 244, 254)
        frame.BackgroundTransparency = 0.52
        frame.Parent = parent
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

        local frameStroke = Instance.new("UIStroke")
        frameStroke.Thickness = 1
        frameStroke.Color = Color3.fromRGB(205, 220, 242)
        frameStroke.Transparency = 0.85
        frameStroke.Parent = frame
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -72, 1, 0)
        label.Position = UDim2.new(0, 14, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = Engine.Modules.I18n:Get(translationKey)
        label.TextColor3 = Color3.fromRGB(18, 28, 48)
        label.Font = Enum.Font.GothamBold
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = frame
        
        self:RegisterLabel(label, translationKey)
        
        local toggleBtn = Instance.new("TextButton")
        local isON = Engine.Modules.ConfigManager.Settings[configKey]
        toggleBtn.Name = isON and "ToggledBG" or "OffBG"
        toggleBtn.Size = UDim2.new(0, 46, 0, 24)
        toggleBtn.Position = UDim2.new(1, -56, 0.5, -12)
        toggleBtn.BackgroundColor3 = isON and Color3.fromRGB(0, 220, 255) or Color3.fromRGB(28, 36, 52)
        toggleBtn.BackgroundTransparency = isON and 0.15 or 0.4
        toggleBtn.Text = ""
        toggleBtn.Parent = frame
        Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)

        local toggleStroke = Instance.new("UIStroke")
        toggleStroke.Thickness = 1.2
        toggleStroke.Color = isON and Color3.fromRGB(0, 240, 255) or Color3.fromRGB(60, 70, 90)
        toggleStroke.Transparency = 0.3
        toggleStroke.Parent = toggleBtn
        
        local circle = Instance.new("Frame")
        circle.Size = UDim2.new(0, 20, 0, 20)
        circle.Position = isON and UDim2.new(1, -22, 0, 2) or UDim2.new(0, 2, 0, 2)
        circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        circle.Parent = toggleBtn
        Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

        local dot = Instance.new("Frame")
        dot.Size = UDim2.new(0, 6, 0, 6)
        dot.Position = UDim2.new(0.5, -3, 0.5, -3)
        dot.BackgroundColor3 = isON and Color3.fromRGB(0, 240, 255) or Color3.fromRGB(150, 160, 180)
        dot.Parent = circle
        Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
        
        if isON then table.insert(self.ChromaObjects, toggleBtn) end
        
        local function updateVisual(newState)
            toggleBtn.Name = newState and "ToggledBG" or "OffBG"
            local goalPos = newState and UDim2.new(1, -22, 0, 2) or UDim2.new(0, 2, 0, 2)
            local goalColor = newState and Color3.fromRGB(0, 220, 255) or Color3.fromRGB(28, 36, 52)
            local goalStroke = newState and Color3.fromRGB(0, 240, 255) or Color3.fromRGB(60, 70, 90)
            local dotColor = newState and Color3.fromRGB(0, 240, 255) or Color3.fromRGB(150, 160, 180)
            
            Engine.Services.TweenService:Create(circle, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = goalPos}):Play()
            Engine.Services.TweenService:Create(toggleBtn, TweenInfo.new(0.22), {BackgroundColor3 = goalColor}):Play()
            Engine.Services.TweenService:Create(toggleStroke, TweenInfo.new(0.22), {Color = goalStroke}):Play()
            Engine.Services.TweenService:Create(dot, TweenInfo.new(0.22), {BackgroundColor3 = dotColor}):Play()
            
            if newState then 
                table.insert(self.ChromaObjects, toggleBtn) 
            else
                for i, obj in ipairs(self.ChromaObjects) do 
                    if obj == toggleBtn then table.remove(self.ChromaObjects, i) break end 
                end
            end
        end

        self.Toggles[configKey] = updateVisual

        toggleBtn.MouseButton1Click:Connect(function()
            local newState = not Engine.Modules.ConfigManager.Settings[configKey]
            Engine.Modules.ConfigManager.Settings[configKey] = newState
            Engine.Modules.ConfigManager:Save()
            updateVisual(newState)
            if callback then callback(newState) end
        end)
    end,
    
    CreateSlider = function(self, parent, translationKey, min, max, configKey)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -10, 0, 60)
        frame.BackgroundColor3 = Color3.fromRGB(238, 244, 254)
        frame.BackgroundTransparency = 0.52
        frame.Parent = parent
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

        local frameStroke = Instance.new("UIStroke")
        frameStroke.Thickness = 1
        frameStroke.Color = Color3.fromRGB(205, 220, 242)
        frameStroke.Transparency = 0.85
        frameStroke.Parent = frame
        
        local default = Engine.Modules.ConfigManager.Settings[configKey]
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -14, 0, 24)
        label.Position = UDim2.new(0, 14, 0, 4)
        label.BackgroundTransparency = 1
        label.Text = Engine.Modules.I18n:Get(translationKey) .. ": " .. string.format("%.2f", default)
        label.TextColor3 = Color3.fromRGB(18, 28, 48)
        label.Font = Enum.Font.GothamBold
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = frame
        
        self:RegisterLabel(label, translationKey, "", "", true, configKey)
        
        local bar = Instance.new("Frame")
        bar.Size = UDim2.new(1, -28, 0, 7)
        bar.Position = UDim2.new(0, 14, 0, 39)
        bar.BackgroundColor3 = Color3.fromRGB(28, 36, 52)
        bar.BackgroundTransparency = 0.3
        bar.Parent = frame
        Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)
        
        local fill = Instance.new("Frame")
        fill.Name = "ToggledBG"
        fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        fill.BackgroundColor3 = Color3.fromRGB(0, 230, 255)
        fill.Parent = bar
        Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
        table.insert(self.ChromaObjects, fill)
        
        local knob = Instance.new("TextButton")
        knob.Size = UDim2.new(0, 17, 0, 17)
        knob.Position = UDim2.new((default - min) / (max - min), -8.5, 0.5, -8.5)
        knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        knob.Text = ""
        knob.Parent = bar
        Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

        local knobStroke = Instance.new("UIStroke")
        knobStroke.Thickness = 1.6
        knobStroke.Color = Color3.fromRGB(0, 240, 255)
        knobStroke.Parent = knob
        
        local dragging = false
        knob.MouseButton1Down:Connect(function() 
            dragging = true 
            Engine.Services.TweenService:Create(knob, TweenInfo.new(0.15), {Size = UDim2.new(0, 21, 0, 21)}):Play()
        end)
        Engine.Services.UIS.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 and dragging then
                dragging = false
                Engine.Services.TweenService:Create(knob, TweenInfo.new(0.15), {Size = UDim2.new(0, 17, 0, 17)}):Play()
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
                knob.Position = UDim2.new(percent, -8.5, 0.5, -8.5)
                label.Text = Engine.Modules.I18n:Get(translationKey) .. ": " .. string.format("%.2f", val)
                Engine.Modules.ConfigManager.Settings[configKey] = val
            end
        end)
    end
}

-- ==========================================
-- [12] BOOTSTRAPPER
-- ==========================================
Engine.BootAfterKey = function(self)
    self.Modules.NotificationManager:Init()
    self.Modules.HunterHUD:Init()
    self.Modules.UIController:Init()
    self.Modules.TeamForce:Init()
    self.Modules.ESPManager:Init()
    self.Status = "Running"
    
    self.Modules.NotificationManager:Notify("RB ZOO CLASS QUID V8.5", "Khởi động thành công! Bản quyền: " .. Engine.Author, 5)
    
    if self.Modules.ConfigManager.Settings.AutoFarm then
        self.Modules.FarmManager:Start()
    end
end

Engine.Boot = function(self)
    self.Modules.ConfigManager:Load()
    self.Modules.PerformanceBooster:Init()
    
    self.Modules.LoadingScreen:Show()
    
    local keyVerified = self.Modules.KeySystem:PromptKeyUI()
    if not keyVerified then return end
    
    self:BootAfterKey()
end

-- Khởi chạy Engine
Engine:Boot()

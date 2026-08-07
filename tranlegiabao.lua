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
    
    GetLogoAsset = function(self)
        local getasset = getcustomasset or getsynasset or custom_asset
        if getasset and isfile then
            if isfile("bun.jpg") then
                local ok, asset = pcall(function() return getasset("bun.jpg") end)
                if ok and asset then return asset end
            end
        end
        return nil
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

-- ==========================================
-- [2] CONFIG MANAGER
-- ==========================================
Engine.Modules.ConfigManager = {
    Settings = {
        Aimbot = false, AimbotSmooth = 0.2, AimbotFOV = 250, WallCheck = true, Prediction = false, PredictionAmount = 0.13,
        Fly = false, FlySpeed = 120, Speed = false, SpeedValue = 20, Noclip = false, InfJump = false, HitboxSize = 4,
        AutoAttack = true, AutoSkill = true, AutoMoney = true, AntiAFK = true, ShowHUD = true, FPSBooster = true,
        AutoFarm = false, AutoFarmHeight = 700, AutoFarmSpeed = 75, SmartMovement = true, AntiStuck = true,
        ForceZookeeper = true, SmartWallBypass = true, Language = "VN"
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
            TabKey = "🔑 Hệ Thống Key",
            TabLanguage = "🌐 Ngôn Ngữ (Language)",
            
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
            TabKey = "🔑 Key System",
            TabLanguage = "🌐 Language (Ngôn Ngữ)",
            
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
            {time = 0.9, text = "⚡ [1/5] Nạp Service & Cấu hình Class Quid Config..."},
            {time = 1.8, text = "🚀 [2/5] Kích hoạt Engine Tối ưu hóa FPS & Fix Lag..."},
            {time = 2.7, text = "🛡️ [3/5] Kích hoạt Smart Wall Bypass & Auto Hunter..."},
            {time = 3.6, text = "🔑 [4/5] Kết nối Server Key getkeyfree24h.netlify.app..."},
            {time = 4.5, text = "✨ [5/5] Nạp hoàn tất! Đang khởi chạy giao diện..."}
        }

        local startTime = tick()
        while tick() - startTime < 4.5 do
            local elapsed = tick() - startTime
            local progress = math.clamp(elapsed / 4.5, 0, 1)

            Engine.Services.TweenService:Create(barFill, TweenInfo.new(0.1), {Size = UDim2.new(progress, 0, 1, 0)}):Play()
            percentLabel.Text = math.floor(progress * 100) .. "%"
            stroke.Color = Color3.fromHSV(tick() % 4 / 4, 0.8, 1)

            if elapsed < 0.9 then statusLabel.Text = steps[1].text
            elseif elapsed < 1.8 then statusLabel.Text = steps[2].text
            elseif elapsed < 2.7 then statusLabel.Text = steps[3].text
            elseif elapsed < 3.6 then statusLabel.Text = steps[4].text
            else statusLabel.Text = steps[5].text
            end

            Engine.Services.RunService.RenderStepped:Wait()
        end

        barFill.Size = UDim2.new(1, 0, 1, 0)
        percentLabel.Text = "100%"
        task.wait(0.25)

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

        -- Lấy Commit SHA mới nhất để tránh Cache Fastly của GitHub
        local commitApiUrl = string.format("https://api.github.com/repos/%s/%s/commits/main", self.RepoOwner, self.RepoName)
        local apiResponse = httpGetRaw(commitApiUrl)
        
        if apiResponse then
            local ok, commitData = pcall(function() return Engine.Services.HttpService:JSONDecode(apiResponse) end)
            if ok and commitData and commitData.sha then
                local shaUrl = string.format("https://raw.githubusercontent.com/%s/%s/%s/%s", self.RepoOwner, self.RepoName, commitData.sha, self.FilePath)
                local shaRawContent = httpGetRaw(shaUrl)
                if shaRawContent then
                    return shaRawContent
                end
            end
        end

        local directUrl = string.format("https://raw.githubusercontent.com/%s/%s/main/%s?nocache=%d", self.RepoOwner, self.RepoName, self.FilePath, os.time())
        return httpGetRaw(directUrl)
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
        sg.Name = "RBZoo_Hunter_HUD_V8"
        sg.ResetOnSpawn = false
        sg.Parent = coreGui
        self.Gui = sg
        
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0, 245, 0, 195)
        frame.Position = UDim2.new(0, 15, 0.3, 0)
        frame.BackgroundColor3 = Color3.fromRGB(12, 16, 26)
        frame.BackgroundTransparency = 0.32
        frame.Active = true
        frame.Draggable = true
        frame.Parent = sg
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 14)
        
        local stroke = Instance.new("UIStroke")
        stroke.Thickness = 1.5
        stroke.Color = Color3.fromRGB(0, 240, 255)
        stroke.Transparency = 0.3
        stroke.Parent = frame
        
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, 0, 0, 26)
        title.BackgroundTransparency = 1
        title.Text = "⚡ CLASS QUID HUNTER V8.5"
        title.Font = Enum.Font.GothamBlack
        title.TextSize = 11
        title.TextColor3 = Color3.fromRGB(0, 240, 255)
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
        addLabel("Author", "👑 Author: " .. Engine.Author).LayoutOrder = 7
        addLabel("Discord", "💬 Discord: rMJAhJwgW").LayoutOrder = 8
        
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
-- [8] FAST SCANNER & TARGETING
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
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hrp = char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart", 3)
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
-- [11] UI CONTROLLER
-- ==========================================
Engine.Modules.UIController = {
    ChromaObjects = {},
    Toggles = {},
    MainFrame = nil,
    LogoButton = nil,
    
    Init = function(self)
        local coreGui = LocalPlayer:WaitForChild("PlayerGui")
        local sg = Instance.new("ScreenGui")
        sg.Name = "RBZoo_V8_UI_LiquidGlass"
        sg.ResetOnSpawn = false
        sg.Parent = coreGui
        
        self.LogoButton = Instance.new("TextButton")
        self.LogoButton.Size = UDim2.new(0, 58, 0, 58)
        self.LogoButton.Position = UDim2.new(0, 20, 0.5, -29)
        self.LogoButton.BackgroundColor3 = Color3.fromRGB(15, 20, 32)
        self.LogoButton.BackgroundTransparency = 0.15
        self.LogoButton.Text = ""
        self.LogoButton.Active = true
        self.LogoButton.Draggable = true
        self.LogoButton.Parent = sg
        Instance.new("UICorner", self.LogoButton).CornerRadius = UDim.new(1, 0)
        
        local logoAsset = Engine:GetLogoAsset()
        if logoAsset then
            local logoImg = Instance.new("ImageLabel")
            logoImg.Size = UDim2.new(1, 0, 1, 0)
            logoImg.BackgroundTransparency = 1
            logoImg.Image = logoAsset
            logoImg.ScaleType = Enum.ScaleType.Crop
            logoImg.Parent = self.LogoButton
            Instance.new("UICorner", logoImg).CornerRadius = UDim.new(1, 0)
        else
            local logoText = Instance.new("TextLabel")
            logoText.Size = UDim2.new(1, 0, 1, 0)
            logoText.BackgroundTransparency = 1
            logoText.Text = "CLASS\nQUID"
            logoText.Font = Enum.Font.GothamBlack
            logoText.TextColor3 = Color3.fromRGB(0, 240, 255)
            logoText.TextSize = 11
            logoText.Parent = self.LogoButton
            table.insert(self.ChromaObjects, logoText)
        end
        
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
        topBar.Size = UDim2.new(1, 0, 0, 54)
        topBar.BackgroundTransparency = 1
        topBar.Parent = self.MainFrame

        local headerLogoAsset = Engine:GetLogoAsset()
        local titleLeftPos = 15
        if headerLogoAsset then
            local headerLogoFrame = Instance.new("Frame")
            headerLogoFrame.Size = UDim2.new(0, 36, 0, 36)
            headerLogoFrame.Position = UDim2.new(0, 15, 0, 9)
            headerLogoFrame.BackgroundColor3 = Color3.fromRGB(20, 28, 45)
            headerLogoFrame.Parent = topBar
            Instance.new("UICorner", headerLogoFrame).CornerRadius = UDim.new(0, 10)

            local headerLogoImg = Instance.new("ImageLabel")
            headerLogoImg.Size = UDim2.new(1, 0, 1, 0)
            headerLogoImg.BackgroundTransparency = 1
            headerLogoImg.Image = headerLogoAsset
            headerLogoImg.ScaleType = Enum.ScaleType.Crop
            headerLogoImg.Parent = headerLogoFrame
            Instance.new("UICorner", headerLogoImg).CornerRadius = UDim.new(0, 10)

            local headerLogoStroke = Instance.new("UIStroke")
            headerLogoStroke.Thickness = 1.5
            headerLogoStroke.Color = Color3.fromRGB(0, 240, 255)
            headerLogoStroke.Parent = headerLogoFrame
            table.insert(self.ChromaObjects, headerLogoStroke)

            titleLeftPos = 60
        end

        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, -(titleLeftPos + 275), 0, 26)
        title.Position = UDim2.new(0, titleLeftPos, 0, 6)
        title.BackgroundTransparency = 1
        title.Text = "RB ZOO V8.5 • CLASS QUID VIP"
        title.Font = Enum.Font.GothamBlack
        title.TextSize = 13
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Parent = topBar
        table.insert(self.ChromaObjects, title)

        local authorLabel = Instance.new("TextLabel")
        authorLabel.Size = UDim2.new(1, -(titleLeftPos + 275), 0, 16)
        authorLabel.Position = UDim2.new(0, titleLeftPos, 0, 28)
        authorLabel.BackgroundTransparency = 1
        authorLabel.Text = "Owner: " .. Engine.Author .. "  |  Class Quid Premium Engine"
        authorLabel.Font = Enum.Font.GothamBold
        authorLabel.TextSize = 9
        authorLabel.TextColor3 = Color3.fromRGB(0, 255, 180)
        authorLabel.TextXAlignment = Enum.TextXAlignment.Left
        authorLabel.Parent = topBar

        local btnTopLang = Instance.new("TextButton")
        btnTopLang.Size = UDim2.new(0, 72, 0, 28)
        btnTopLang.Position = UDim2.new(1, -262, 0, 13)
        btnTopLang.BackgroundColor3 = Color3.fromRGB(25, 36, 56)
        btnTopLang.Text = "🌐 " .. (Engine.Modules.ConfigManager.Settings.Language or "VN")
        btnTopLang.Font = Enum.Font.GothamBold
        btnTopLang.TextSize = 11
        btnTopLang.TextColor3 = Color3.fromRGB(0, 255, 180)
        btnTopLang.Parent = topBar
        Instance.new("UICorner", btnTopLang).CornerRadius = UDim.new(0, 8)
        
        btnTopLang.MouseButton1Click:Connect(function()
            local newLang = Engine.Modules.I18n:ToggleLang()
            btnTopLang.Text = "🌐 " .. newLang
            if Engine.Modules.NotificationManager and Engine.Modules.NotificationManager.Notify then
                Engine.Modules.NotificationManager:Notify("Language / Ngôn Ngữ", (newLang == "VN") and "✓ Đã chuyển sang Tiếng Việt!" or "✓ Switched language to English!", 3)
            end
        end)

        local btnTopDiscord = Instance.new("TextButton")
        btnTopDiscord.Size = UDim2.new(0, 85, 0, 28)
        btnTopDiscord.Position = UDim2.new(1, -185, 0, 13)
        btnTopDiscord.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
        btnTopDiscord.Text = "💬 Discord"
        btnTopDiscord.Font = Enum.Font.GothamBold
        btnTopDiscord.TextSize = 11
        btnTopDiscord.TextColor3 = Color3.fromRGB(255, 255, 255)
        btnTopDiscord.Parent = topBar
        Instance.new("UICorner", btnTopDiscord).CornerRadius = UDim.new(0, 8)
        btnTopDiscord.MouseButton1Click:Connect(function()
            Engine.Modules.KeySystem:JoinDiscord()
        end)

        local btnTopGetKey = Instance.new("TextButton")
        btnTopGetKey.Size = UDim2.new(0, 85, 0, 28)
        btnTopGetKey.Position = UDim2.new(1, -95, 0, 13)
        btnTopGetKey.BackgroundColor3 = Color3.fromRGB(30, 45, 70)
        btnTopGetKey.Text = "🌐 Get Key"
        btnTopGetKey.Font = Enum.Font.GothamBold
        btnTopGetKey.TextSize = 11
        btnTopGetKey.TextColor3 = Color3.fromRGB(0, 240, 255)
        btnTopGetKey.Parent = topBar
        Instance.new("UICorner", btnTopGetKey).CornerRadius = UDim.new(0, 8)
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

                Engine.Modules.NotificationManager:Notify("Hotkey Triggered", "Hunter AI Auto Farm: " .. (newState and "BẬT [ON]" or "TẮT [OFF]"), 2)
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
        local pageLang = createTab("🌐 Language", false)
        
        self:CreateToggle(pageForce, "Ép phe Zookeeper 100%", "ForceZookeeper", function(v)
            if v then Engine.Modules.TeamForce:TryForceZoo() end
        end)
        self:CreateToggle(pageForce, "Hiển thị HUD Hunter", "ShowHUD")
        self:CreateToggle(pageForce, "Tối ưu FPS (Fix Lag)", "FPSBooster", function(v)
            if v then Engine.Modules.PerformanceBooster:Init() end
        end)
        
        self:CreateToggle(pageCombat, "Smart Aimbot [M]", "Aimbot")
        self:CreateSlider(pageCombat, "Aimbot FOV", 50, 600, "AimbotFOV")
        self:CreateSlider(pageCombat, "Aimbot Smooth", 0.05, 1, "AimbotSmooth")
        self:CreateToggle(pageCombat, "Auto Attack", "AutoAttack")
        self:CreateToggle(pageCombat, "Auto Skill (Q / E)", "AutoSkill")
        self:CreateSlider(pageCombat, "Expand Hitbox", 2, 25, "HitboxSize")
        
        self:CreateToggle(pageFarm, "Hunter AI Auto Farm [P]", "AutoFarm", function(v)
            if v then Engine.Modules.FarmManager:Start() else Engine.Modules.FarmManager:Stop() end
        end)
        self:CreateToggle(pageFarm, "Fix Dính Tường (Smart Bypass)", "SmartWallBypass")
        self:CreateSlider(pageFarm, "Hunter Speed", 30, 250, "AutoFarmSpeed")
        self:CreateSlider(pageFarm, "Flight Height (OOF)", 50, 1500, "AutoFarmHeight")
        self:CreateToggle(pageFarm, "Anti-Stuck Protection", "AntiStuck")
        self:CreateToggle(pageFarm, "Auto Money", "AutoMoney")
        self:CreateToggle(pageFarm, "Anti-AFK (24/7)", "AntiAFK")
        
        self:CreateToggle(pageMovement, "Fly", "Fly")
        self:CreateSlider(pageMovement, "Fly Speed", 50, 350, "FlySpeed")
        self:CreateToggle(pageMovement, "WalkSpeed", "Speed")
        self:CreateSlider(pageMovement, "Speed Value", 16, 100, "SpeedValue")
        self:CreateToggle(pageMovement, "Noclip", "Noclip")
        self:CreateToggle(pageMovement, "Infinite Jump", "InfJump")
        
        local btnSwitchLang = Instance.new("TextButton")
        btnSwitchLang.Size = UDim2.new(1, -10, 0, 48)
        btnSwitchLang.BackgroundColor3 = Color3.fromRGB(25, 36, 56)
        btnSwitchLang.Text = "🌐 Switch Language / Chuyển Ngôn Ngữ (VN ➔ EN)"
        btnSwitchLang.Font = Enum.Font.GothamBold
        btnSwitchLang.TextSize = 11
        btnSwitchLang.TextColor3 = Color3.fromRGB(0, 255, 180)
        btnSwitchLang.Parent = pageLang
        Instance.new("UICorner", btnSwitchLang).CornerRadius = UDim.new(0, 10)
        
        btnSwitchLang.MouseButton1Click:Connect(function()
            local newLang = Engine.Modules.I18n:ToggleLang()
            btnSwitchLang.Text = (newLang == "VN") and "🌐 Switch Language / Chuyển Ngôn Ngữ (VN ➔ EN)" or "🌐 Switch Language / Chuyển Ngôn Ngữ (EN ➔ VN)"
            if Engine.Modules.NotificationManager and Engine.Modules.NotificationManager.Notify then
                Engine.Modules.NotificationManager:Notify("Language / Ngôn Ngữ", (newLang == "VN") and "✓ Đã chuyển sang Tiếng Việt!" or "✓ Switched language to English!", 3)
            end
        end)

        local keyCard = Instance.new("Frame")
        keyCard.Size = UDim2.new(1, -10, 0, 210)
        keyCard.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        keyCard.BackgroundTransparency = 0.94
        keyCard.Parent = pageKey
        Instance.new("UICorner", keyCard).CornerRadius = UDim.new(0, 12)
        
        local keyTitle = Instance.new("TextLabel")
        keyTitle.Size = UDim2.new(1, -20, 0, 24)
        keyTitle.Position = UDim2.new(0, 12, 0, 8)
        keyTitle.BackgroundTransparency = 1
        keyTitle.Text = "🔑 THÔNG TIN KEY & CỘNG ĐỒNG"
        keyTitle.Font = Enum.Font.GothamBlack
        keyTitle.TextSize = 13
        keyTitle.TextColor3 = Color3.fromRGB(0, 240, 255)
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

        local btnCardGetKey = Instance.new("TextButton")
        btnCardGetKey.Size = UDim2.new(1, -24, 0, 32)
        btnCardGetKey.Position = UDim2.new(0, 12, 0, 88)
        btnCardGetKey.BackgroundColor3 = Color3.fromRGB(30, 42, 65)
        btnCardGetKey.Text = "🌐 Trang Get Key 24h: getkeyfree24h.netlify.app"
        btnCardGetKey.Font = Enum.Font.GothamBold
        btnCardGetKey.TextSize = 10
        btnCardGetKey.TextColor3 = Color3.fromRGB(0, 240, 255)
        btnCardGetKey.Parent = keyCard
        Instance.new("UICorner", btnCardGetKey).CornerRadius = UDim.new(0, 8)
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
        btnCardDiscord.Text = "💬 Tham Gia Server Discord: discord.gg/rMJAhJwgW"
        btnCardDiscord.Font = Enum.Font.GothamBold
        btnCardDiscord.TextSize = 10
        btnCardDiscord.TextColor3 = Color3.fromRGB(255, 255, 255)
        btnCardDiscord.Parent = keyCard
        Instance.new("UICorner", btnCardDiscord).CornerRadius = UDim.new(0, 8)
        btnCardDiscord.MouseButton1Click:Connect(function()
            Engine.Modules.KeySystem:JoinDiscord()
        end)
        
        local btnLogout = Instance.new("TextButton")
        btnLogout.Size = UDim2.new(1, -24, 0, 32)
        btnLogout.Position = UDim2.new(0, 12, 0, 164)
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
        
        local function updateVisual(newState)
            toggleBtn.Name = newState and "ToggledBG" or "OffBG"
            local goalPos = newState and UDim2.new(1, -20, 0, 2) or UDim2.new(0, 2, 0, 2)
            local goalColor = newState and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(45, 52, 68)
            
            Engine.Services.TweenService:Create(circle, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = goalPos}):Play()
            Engine.Services.TweenService:Create(toggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = goalColor}):Play()
            
            if newState then table.insert(self.ChromaObjects, toggleBtn) else
                for i, obj in ipairs(self.ChromaObjects) do if obj == toggleBtn then table.remove(self.ChromaObjects, i) break end end
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
-- [12] BOOTSTRAPPER
-- ==========================================
Engine.BootAfterKey = function(self)
    self.Modules.NotificationManager:Init()
    self.Modules.HunterHUD:Init()
    self.Modules.UIController:Init()
    self.Modules.TeamForce:Init()
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

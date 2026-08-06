-- // =================================================================
-- // RB ZOO SUPER PREMIUM 2026 - CYBERPUNK VIP V10.5 (SUPER VIP EDITION)
-- // COPYRIGHT © 2026 TRẦN LÊ GIA BẢO. ALL RIGHTS RESERVED.
-- // Creator: Trần Lê Gia Bảo (Roblox: giabaotranle04)
-- // Built on Solid V10.0 Base with Super VIP Enhancements:
-- // Real-Time Hunter AI 2.0, Independent ESP Pro (Box, Name, Dist, HP, Tracers, Chams, Skeleton, Offscreen Arrows),
-- // Mini Corner Radar, Role-Based Auto Attack & Skill (Zoo: Auto Q + Auto Firing; OOF: Auto E),
-- // 3-Color Hitbox (Zoo=Red, OOF=Blue, Neutral=Green), Keybind [F] Fly Toggle,
-- // Theme Engine (5 VIP Themes), Bilingual Switcher (VN/EN) & Self-Cleaning Core.
-- // =================================================================

-- Tự động dọn dẹp tất cả UI & Thread cũ khi thực thi lại Script để tránh trùng lặp và giật lag
local CoreGuiService = game:GetService("CoreGui") or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
for _, name in ipairs({"RBZoo_V9_UI_LiquidGlass", "RBZoo_Hunter_HUD_V9", "RBZoo_V9_Notifications", "RBZoo_MiniRadar_V10", "RBZoo_KeySystem_UI", "RBZoo_V9_LoadingScreen"}) do
    local old = CoreGuiService:FindFirstChild(name)
    if old then pcall(function() old:Destroy() end) end
end

local Engine = {
    Services = {},
    Modules = {},
    Cache = { Animals = {}, Zookeepers = {}, Oofs = {}, Prompts = {}, LastScan = 0, TotalKills = 0 },
    State = { 
        CurrentRole = "NEUTRAL", 
        CurrentTarget = nil, 
        TargetModel = nil, 
        FarmConnections = {}, 
        ESPObjects = {}, 
        StartTime = os.time(),
        FPS = 60,
        Ping = 0,
        CreatorUserId = 3240833295,
        AvatarUrl = "",
        LogoAssetId = "",
        LogoUrl = "https://pngup.com/XftU/bun.jpg",
        CurrentTheme = "Cyberpunk"
    },
    Status = "Booting",
    Author = "Trần Lê Gia Bảo",
    AuthorRoblox = "giabaotranle04",
    Version = "V10.5 Super VIP"
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
    ReplicatedStorage = game:GetService("ReplicatedStorage"),
    CoreGui = CoreGuiService,
    Lighting = game:GetService("Lighting"),
    Stats = game:GetService("Stats"),
    SoundService = game:GetService("SoundService")
}

local LocalPlayer = Engine.Services.Players.LocalPlayer
local Camera = Engine.Services.Workspace.CurrentCamera

-- Helper Hàm Nhấn Phím Ảo (PressKey VirtualInputManager)
local function PressKey(keyCode)
    pcall(function()
        Engine.Services.VirtualInputManager:SendKeyEvent(true, keyCode, false, game)
        task.wait(0.04)
        Engine.Services.VirtualInputManager:SendKeyEvent(false, keyCode, false, game)
    end)
end

-- Helper Mô Phỏng Nhấp Chuột Trái (TriggerMouseClick)
local function TriggerMouseClick()
    pcall(function()
        local vp = Camera.ViewportSize
        Engine.Services.VirtualInputManager:SendMouseButtonEvent(vp.X / 2, vp.Y / 2, 0, true, game, 1)
        task.wait(0.01)
        Engine.Services.VirtualInputManager:SendMouseButtonEvent(vp.X / 2, vp.Y / 2, 0, false, game, 1)
    end)
end

-- Tải Custom Logo Image (https://pngup.com/XftU/bun.jpg) & Roblox Avatar
task.spawn(function()
    pcall(function()
        local getAsset = getcustomasset or getsynasset
        local httpRequest = (syn and syn.request) or (http and http.request) or request or http_request
        local imgBytes = nil
        
        if httpRequest then
            local res = httpRequest({Url = Engine.State.LogoUrl, Method = "GET"})
            if res and res.Body then imgBytes = res.Body end
        end
        if not imgBytes then
            local ok, body = pcall(function() return game:HttpGet(Engine.State.LogoUrl) end)
            if ok then imgBytes = body end
        end
        
        if imgBytes and writefile and getAsset then
            writefile("RBZoo_CustomLogo_V9.jpg", imgBytes)
            Engine.State.LogoAssetId = getAsset("RBZoo_CustomLogo_V9.jpg")
        end
    end)
    
    pcall(function()
        local userId = Engine.Services.Players:GetUserIdFromNameAsync(Engine.AuthorRoblox)
        if userId then
            Engine.State.CreatorUserId = userId
            local content, isReady = Engine.Services.Players:GetUserThumbnailAsync(userId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
            if content and isReady then
                Engine.State.AvatarUrl = content
            end
        end
    end)
end)

-- Sound Effects Helper
Engine.Modules.AudioFX = {
    Play = function(self, soundId, pitch)
        if not Engine.Modules.ConfigManager.Settings.AudioFX then return end
        pcall(function()
            local sound = Instance.new("Sound")
            sound.SoundId = "rbxassetid://" .. tostring(soundId)
            sound.Volume = 0.5
            sound.Pitch = pitch or 1
            sound.Parent = Engine.Services.SoundService
            sound:Play()
            sound.Ended:Connect(function() sound:Destroy() end)
        end)
    end,
    Click = function(self) self:Play(6895079853, 1.2) end,
    Toggle = function(self) self:Play(6895079853, 1.5) end,
    Notify = function(self) self:Play(4590662766, 1.0) end
}

-- ==========================================
-- [2] CONFIG MANAGER & BILINGUAL DICTIONARY
-- ==========================================
Engine.Modules.ConfigManager = {
    Settings = {
        Language = "VN",
        Theme = "Cyberpunk",
        -- Aimbot & Combat
        Aimbot = false, AimbotSmooth = 0.2, AimbotFOV = 250, SilentAim = false, WallCheck = true, Prediction = true, PredictionAmount = 0.13,
        HitboxSize = 4, HitboxTransparency = 0.65, AutoAttack = true, AutoSkill = true, AutoWeapon = true,
        -- ESP Visuals (Độc lập 100%)
        ESP = true, ESPBox = true, ESPName = true, ESPDistance = true, ESPHealth = true, ESPTracers = false, ESPChams = true, ESPSkeleton = true, ESPArrows = true,
        -- Movement & Character
        Fly = false, FlySpeed = 120, Speed = false, SpeedValue = 20, Noclip = false, InfJump = false, AntiAFK = true,
        -- Automation & Farm
        AutoFarm = false, AutoFarmHeight = 45, AutoFarmSpeed = 85, SmartMovement = true, AntiStuck = true,
        SmartWallBypass = true, AutoMoney = true,
        -- System & Visuals
        ShowHUD = true, ShowRadar = true, FPSBooster = true, AudioFX = true
    },
    File = "RBZoo_Smart_Config_V10_5.json",
    
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

-- Từ điển Song Ngữ (Bilingual Dictionary)
local L = {
    VN = {
        ESP_TAB = "👁️ ESP Visuals",
        COMBAT_TAB = "⚡ Combat AI",
        FARM_TAB = "🤖 Automation",
        MOVEMENT_TAB = "🚀 Movement",
        KEY_TAB = "🔑 Key & Creator",
        
        MASTER_ESP = "Master ESP Engine (Tự động bật)",
        BOX_ESP = "ESP Bounding Box",
        NAME_ESP = "ESP Tên Người Chơi",
        DIST_ESP = "ESP Khoảng Cách (Studs)",
        HP_ESP = "ESP Thanh Máu (HP Bar)",
        TRACER_ESP = "ESP Đường Dẫn Tracer",
        CHAMS_ESP = "ESP Chams Highlight Xuyên Tường",
        SKELETON_ESP = "ESP Skeleton Khung Xương",
        ARROW_ESP = "ESP Mũi Tên V Chỉ Hướng Kẻ Thù (Offscreen V-Arrow)",
        
        AIMBOT = "Smart Aimbot AI [M]",
        SILENT_AIM = "Silent Aim (Bắn Không Cần Nhắm)",
        AIM_FOV = "Aimbot FOV Radius",
        AIM_SMOOTH = "Aimbot Smooth",
        AUTO_ATTACK = "Auto Attack (Zoo: Súng/Chuột Trái)",
        AUTO_SKILL = "Auto Skill (Zoo: Q, OOF: E)",
        AUTO_WEAPON = "Auto Trang Bị Vũ Khí Tốt Nhất",
        HITBOX_SIZE = "Hitbox (Zoo=Đỏ, OOF=Xanh, Thường=Lá)",
        
        AUTO_FARM = "Hunter AI Auto Farm [P]",
        WALL_BYPASS = "Fix Dính Tường (Smart Bypass 2.0)",
        FARM_SPEED = "Tốc Độ Hunter Speed",
        FARM_HEIGHT = "Độ Cao Bay Flight Height (OOF)",
        ANTI_STUCK = "Chống Kẹt Anti-Stuck Protection",
        AUTO_MONEY = "Auto Nhặt Money / Prompts",
        ANTI_AFK = "Anti-AFK Chống Disconnect (24/7)",
        SHOW_HUD = "Hiển thị HUD Hunter",
        SHOW_RADAR = "Hiển thị Mini Radar góc màn hình",
        AUDIO_FX = "Âm Thanh UI (Audio FX)",
        FPS_BOOSTER = "Tối ưu FPS (Fix Lag)",
        
        FLY = "Fly Bay Tự Do (Nhấn [F] để Bật/Tắt)",
        FLY_SPEED = "Tốc Độ Bay Fly Speed",
        SPEED = "Tăng Tốc Chạy WalkSpeed",
        SPEED_VAL = "Tốc Độ Chạy Speed Value",
        NOCLIP = "Noclip (Đi Xuyên Tường)",
        INF_JUMP = "Infinite Jump (Nhảy Không Giới Hạn)",
        
        LANG_SWITCH = "Chuyển Sang Tiếng Anh (English)",
        LOGOUT = "🔓 ĐĂNG XUẤT KEY"
    },
    EN = {
        ESP_TAB = "👁️ ESP Visuals",
        COMBAT_TAB = "⚡ Combat AI",
        FARM_TAB = "🤖 Automation",
        MOVEMENT_TAB = "🚀 Movement",
        KEY_TAB = "🔑 Key & Creator",
        
        MASTER_ESP = "Master ESP Engine (Auto On)",
        BOX_ESP = "ESP Bounding Box",
        NAME_ESP = "ESP Player Name",
        DIST_ESP = "ESP Distance (Studs)",
        HP_ESP = "ESP Health Bar",
        TRACER_ESP = "ESP Snaplines / Tracers",
        CHAMS_ESP = "ESP Wall Chams Highlight",
        SKELETON_ESP = "ESP Bone Skeleton",
        
        AIMBOT = "Smart Aimbot AI [M]",
        SILENT_AIM = "Silent Aim (Raycast Target)",
        AIM_FOV = "Aimbot FOV Radius",
        AIM_SMOOTH = "Aimbot Smoothness",
        AUTO_ATTACK = "Auto Attack (Zoo: Shoot/Left-Click)",
        AUTO_SKILL = "Auto Skill (Zoo: Q, OOF: E)",
        AUTO_WEAPON = "Auto Equip Best Weapon",
        HITBOX_SIZE = "Hitbox Expander (Zoo=Red, OOF=Blue, Civ=Green)",
        
        AUTO_FARM = "Hunter AI Auto Farm [P]",
        WALL_BYPASS = "Smart Wall Bypass 2.0",
        FARM_SPEED = "Auto Farm Speed",
        FARM_HEIGHT = "Auto Farm Flight Height",
        ANTI_STUCK = "Anti-Stuck Protection",
        AUTO_MONEY = "Auto Collect Money / Prompts",
        ANTI_AFK = "Anti-AFK Guard (24/7)",
        SHOW_HUD = "Show Hunter HUD Panel",
        SHOW_RADAR = "Show Corner Mini Radar",
        AUDIO_FX = "UI Audio Sound FX",
        FPS_BOOSTER = "FPS Performance Booster",
        
        FLY = "Fly Mode (Press [F] to Toggle)",
        FLY_SPEED = "Fly Flight Speed",
        SPEED = "Enable WalkSpeed",
        SPEED_VAL = "WalkSpeed Value",
        NOCLIP = "Noclip Wallpass",
        INF_JUMP = "Infinite Jump",
        
        LANG_SWITCH = "Switch to Vietnamese (Tiếng Việt)",
        LOGOUT = "🔓 LOGOUT KEY"
    }
}

-- ==========================================
-- [3] FPS & PERFORMANCE BOOSTER
-- ==========================================
Engine.Modules.PerformanceBooster = {
    Init = function(self)
        if not Engine.Modules.ConfigManager.Settings.FPSBooster then return end
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            Engine.Services.Workspace.GlobalShadows = false
            Engine.Services.Lighting.GlobalShadows = false
            Engine.Services.Lighting.FogEnd = 9e9
            
            for _, v in ipairs(Engine.Services.Workspace:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CastShadow = false
                elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") then
                    v.Enabled = false
                end
            end
        end)
    end,
    
    StartGC = function(self)
        task.spawn(function()
            while task.wait(30) do
                pcall(function()
                    if gcinfo then gcinfo() end
                    if collectgarbage then collectgarbage("collect") end
                end)
            end
        end)
    end
}

-- ==========================================
-- [4] CYBERPUNK LOADING SCREEN V10.5 ULTRA VIP
-- ==========================================
Engine.Modules.LoadingScreen = {
    Show = function(self)
        local coreGui = LocalPlayer:WaitForChild("PlayerGui")
        local sg = Instance.new("ScreenGui")
        sg.Name = "RBZoo_V9_LoadingScreen"
        sg.ResetOnSpawn = false
        sg.Parent = coreGui

        local bg = Instance.new("Frame")
        bg.Size = UDim2.new(1, 0, 1, 0)
        bg.BackgroundColor3 = Color3.fromRGB(4, 6, 12)
        bg.BackgroundTransparency = 0.05
        bg.Parent = sg

        local card = Instance.new("Frame")
        card.Size = UDim2.new(0, 500, 0, 280)
        card.Position = UDim2.new(0.5, -250, 0.5, -140)
        card.BackgroundColor3 = Color3.fromRGB(10, 13, 24)
        card.BackgroundTransparency = 0.1
        card.Parent = bg
        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 22)

        local stroke = Instance.new("UIStroke")
        stroke.Thickness = 2.5
        stroke.Color = Color3.fromRGB(0, 240, 255)
        stroke.Parent = card

        -- Rotating Holographic Outer Ring around Avatar
        local ringFrame = Instance.new("Frame")
        ringFrame.Size = UDim2.new(0, 80, 0, 80)
        ringFrame.Position = UDim2.new(0.5, -40, 0, 12)
        ringFrame.BackgroundTransparency = 1
        ringFrame.Parent = card

        local ringStroke = Instance.new("UIStroke")
        ringStroke.Thickness = 2
        ringStroke.Color = Color3.fromRGB(255, 0, 140)
        ringStroke.Parent = ringFrame
        Instance.new("UICorner", ringFrame).CornerRadius = UDim.new(1, 0)

        local avatarImg = Instance.new("ImageLabel")
        avatarImg.Size = UDim2.new(0, 68, 0, 68)
        avatarImg.Position = UDim2.new(0.5, -34, 0, 18)
        avatarImg.BackgroundColor3 = Color3.fromRGB(20, 25, 40)
        avatarImg.Image = "rbxassetid://0"
        avatarImg.Parent = card
        Instance.new("UICorner", avatarImg).CornerRadius = UDim.new(1, 0)

        task.spawn(function()
            while avatarImg and avatarImg.Parent do
                if Engine.State.LogoAssetId ~= "" then
                    avatarImg.Image = Engine.State.LogoAssetId
                    break
                elseif Engine.State.AvatarUrl ~= "" then
                    avatarImg.Image = Engine.State.AvatarUrl
                    break
                end
                task.wait(0.2)
            end
        end)

        -- Spin Holographic Ring Animation
        task.spawn(function()
            local rot = 0
            while ringFrame and ringFrame.Parent do
                rot = (rot + 4) % 360
                ringFrame.Rotation = rot
                ringStroke.Color = Color3.fromHSV(rot / 360, 0.85, 1)
                task.wait(0.02)
            end
        end)

        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, 0, 0, 30)
        title.Position = UDim2.new(0, 0, 0, 96)
        title.BackgroundTransparency = 1
        title.Text = "⚡ RB ZOO CYBERPUNK SUPER VIP V10.5"
        title.Font = Enum.Font.GothamBlack
        title.TextSize = 17
        title.TextColor3 = Color3.fromRGB(0, 240, 255)
        title.Parent = card

        local sub = Instance.new("TextLabel")
        sub.Size = UDim2.new(1, 0, 0, 20)
        sub.Position = UDim2.new(0, 0, 0, 126)
        sub.BackgroundTransparency = 1
        sub.Text = "👑 Sáng tạo bởi: " .. Engine.Author .. " (@" .. Engine.AuthorRoblox .. ")"
        sub.Font = Enum.Font.GothamBold
        sub.TextSize = 11
        sub.TextColor3 = Color3.fromRGB(255, 0, 140)
        sub.Parent = card

        local barBg = Instance.new("Frame")
        barBg.Size = UDim2.new(0.86, 0, 0, 14)
        barBg.Position = UDim2.new(0.07, 0, 0, 158)
        barBg.BackgroundColor3 = Color3.fromRGB(20, 26, 44)
        barBg.Parent = card
        Instance.new("UICorner", barBg).CornerRadius = UDim.new(1, 0)

        local barStroke = Instance.new("UIStroke")
        barStroke.Thickness = 1
        barStroke.Color = Color3.fromRGB(0, 240, 255)
        barStroke.Transparency = 0.5
        barStroke.Parent = barBg

        local barFill = Instance.new("Frame")
        barFill.Size = UDim2.new(0, 0, 1, 0)
        barFill.BackgroundColor3 = Color3.fromRGB(0, 240, 255)
        barFill.Parent = barBg
        Instance.new("UICorner", barFill).CornerRadius = UDim.new(1, 0)

        local percentLabel = Instance.new("TextLabel")
        percentLabel.Size = UDim2.new(1, 0, 0, 20)
        percentLabel.Position = UDim2.new(0, 0, 0, 178)
        percentLabel.BackgroundTransparency = 1
        percentLabel.Text = "0%"
        percentLabel.Font = Enum.Font.GothamBlack
        percentLabel.TextSize = 14
        percentLabel.TextColor3 = Color3.fromRGB(0, 240, 255)
        percentLabel.Parent = card

        local statusLabel = Instance.new("TextLabel")
        statusLabel.Size = UDim2.new(1, 0, 0, 22)
        statusLabel.Position = UDim2.new(0, 0, 0, 210)
        statusLabel.BackgroundTransparency = 1
        statusLabel.Text = "⚡ Khởi động Cyberpunk Ultra Engine..."
        statusLabel.Font = Enum.Font.GothamMedium
        statusLabel.TextSize = 11
        statusLabel.TextColor3 = Color3.fromRGB(160, 185, 215)
        statusLabel.Parent = card

        local badgeTag = Instance.new("TextLabel")
        badgeTag.Size = UDim2.new(1, 0, 0, 18)
        badgeTag.Position = UDim2.new(0, 0, 0, 240)
        badgeTag.BackgroundTransparency = 1
        badgeTag.Text = "💎 EXCLUSIVE PREMIUM EDITION 2026"
        badgeTag.Font = Enum.Font.GothamBold
        badgeTag.TextSize = 9
        badgeTag.TextColor3 = Color3.fromRGB(255, 200, 0)
        badgeTag.Parent = card

        local steps = {
            {time = 0.5, text = "[1/5] Nạp Service & Khởi động Hunter AI 3.0..."},
            {time = 1.0, text = "[2/5] Kích hoạt Standalone Auto Skill (Zoo: Q, OOF: E)..."},
            {time = 3.0, text = "[3/5] Nạp 3-Color Hitbox (Zoo=Red, OOF=Blue, Civ=Green)..."},
            {time = 2.0, text = "[4/5] Kết nối Tactical Mini Radar & Hotkey [F] Fly Mode..."},
            {time = 2.5, text = "[5/5] Hoàn tất 100%! Đang mở Cyberpunk Master VIP UI..."}
        }

        local startTime = tick()
        while tick() - startTime < 2.5 do
            local elapsed = tick() - startTime
            local progress = math.clamp(elapsed / 2.5, 0, 1)

            barFill.Size = UDim2.new(progress, 0, 1, 0)
            barFill.BackgroundColor3 = Color3.fromHSV(progress * 0.5, 0.9, 1)
            percentLabel.Text = math.floor(progress * 100) .. "%"

            if elapsed < 0.5 then statusLabel.Text = steps[1].text
            elseif elapsed < 1.0 then statusLabel.Text = steps[2].text
            elseif elapsed < 1.5 then statusLabel.Text = steps[3].text
            elseif elapsed < 2.0 then statusLabel.Text = steps[4].text
            else statusLabel.Text = steps[5].text
            end

            Engine.Services.RunService.RenderStepped:Wait()
        end

        barFill.Size = UDim2.new(1, 0, 1, 0)
        percentLabel.Text = "100%"
        statusLabel.Text = steps[5].text
        Engine.Modules.AudioFX:Notify()
        task.wait(0.2)

        Engine.Services.TweenService:Create(bg, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
        Engine.Services.TweenService:Create(card, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
        Engine.Services.TweenService:Create(stroke, TweenInfo.new(0.4), {Transparency = 1}):Play()
        task.wait(0.4)
        sg:Destroy()
    end
}

-- ==========================================
-- [5] KEY SYSTEM MODULE V10.5
-- ==========================================
Engine.Modules.KeySystem = {
    KeyURL = "https://discord.gg/6Nfc7jGKP",
    RepoOwner = "giabaotranle04112011",
    RepoName = "getkey",
    FilePath = "keys.json",
    KeySaveFile = "RBZoo_SavedKey_V9.json",
    AdminKey = "14142022",
    CurrentKey = nil,
    CurrentKeyType = nil,

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

        local commitApiUrl = string.format("https://api.github.com/repos/%s/%s/commits/main", self.RepoOwner, self.RepoName)
        local apiResponse = httpGetRaw(commitApiUrl)
        
        if apiResponse then
            local ok, commitData = pcall(function() return Engine.Services.HttpService:JSONDecode(apiResponse) end)
            if ok and commitData and commitData.sha then
                local shaUrl = string.format("https://raw.githubusercontent.com/%s/%s/%s/%s", self.RepoOwner, self.RepoName, commitData.sha, self.FilePath)
                local shaRawContent = httpGetRaw(shaUrl)
                if shaRawContent then return shaRawContent end
            end
        end

        local directUrl = string.format("https://raw.githubusercontent.com/%s/%s/main/%s?nocache=%d", self.RepoOwner, self.RepoName, self.FilePath, os.time())
        return httpGetRaw(directUrl)
    end,

    ValidateKeyFormat = function(self, inputKey)
        local cleaned = CleanStr(inputKey)
        if cleaned == "" then return false, "EMPTY", "" end
        
        if cleaned == CleanStr(self.AdminKey) then
            return true, "ADMIN", cleaned
        end

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
        Engine.Modules.ESPEngine:Clear()
        
        local coreGui = LocalPlayer:WaitForChild("PlayerGui")
        for _, guiName in ipairs({"RBZoo_V9_UI_LiquidGlass", "RBZoo_Hunter_HUD_V9", "RBZoo_V9_Notifications", "RBZoo_MiniRadar_V10"}) do
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
        bg.BackgroundColor3 = Color3.fromRGB(5, 7, 12)
        bg.BackgroundTransparency = 0.2
        bg.Parent = sg

        local card = Instance.new("Frame")
        card.Size = UDim2.new(0, 440, 0, 270)
        card.Position = UDim2.new(0.5, -220, 0.5, -135)
        card.BackgroundColor3 = Color3.fromRGB(11, 14, 25)
        card.Parent = bg
        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 18)

        local stroke = Instance.new("UIStroke")
        stroke.Thickness = 2
        stroke.Color = Color3.fromRGB(0, 240, 255)
        stroke.Parent = card

        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, 0, 0, 35)
        title.Position = UDim2.new(0, 0, 0, 15)
        title.BackgroundTransparency = 1
        title.Text = "🔐 CYBERPUNK KEY SYSTEM V10.5"
        title.Font = Enum.Font.GothamBlack
        title.TextSize = 17
        title.TextColor3 = Color3.fromRGB(0, 240, 255)
        title.Parent = card

        local desc = Instance.new("TextLabel")
        desc.Size = UDim2.new(1, -40, 0, 32)
        desc.Position = UDim2.new(0, 20, 0, 46)
        desc.BackgroundTransparency = 1
        desc.Text = "Hãy vô Server Discord: https://discord.gg/6Nfc7jGKP để lấy Key của Bot dùng lệnh /help"
        desc.Font = Enum.Font.GothamMedium
        desc.TextSize = 10
        desc.TextColor3 = Color3.fromRGB(180, 195, 215)
        desc.TextWrapped = true
        desc.Parent = card

        local textBoxBg = Instance.new("Frame")
        textBoxBg.Size = UDim2.new(0.85, 0, 0, 44)
        textBoxBg.Position = UDim2.new(0.075, 0, 0, 92)
        textBoxBg.BackgroundColor3 = Color3.fromRGB(22, 28, 45)
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
        keyBox.PlaceholderText = "Nhập Key (FREE-XXXX-XXXX) hoặc Mã Admin..."
        keyBox.PlaceholderColor3 = Color3.fromRGB(110, 125, 145)
        keyBox.Text = ""
        keyBox.Font = Enum.Font.GothamBold
        keyBox.TextSize = 12
        keyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        keyBox.Parent = textBoxBg

        local statusLabel = Instance.new("TextLabel")
        statusLabel.Size = UDim2.new(1, 0, 0, 20)
        statusLabel.Position = UDim2.new(0, 0, 0, 142)
        statusLabel.BackgroundTransparency = 1
        statusLabel.Text = ""
        statusLabel.Font = Enum.Font.GothamBold
        statusLabel.TextSize = 11
        statusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        statusLabel.Parent = card

        local btnGetKey = Instance.new("TextButton")
        btnGetKey.Size = UDim2.new(0.42, 0, 0, 44)
        btnGetKey.Position = UDim2.new(0.06, 0, 0, 172)
        btnGetKey.BackgroundColor3 = Color3.fromRGB(15, 22, 38)
        btnGetKey.Text = "🌐 LẤY KEY"
        btnGetKey.Font = Enum.Font.GothamBlack
        btnGetKey.TextSize = 13
        btnGetKey.TextColor3 = Color3.fromRGB(0, 240, 255)
        btnGetKey.Parent = card
        Instance.new("UICorner", btnGetKey).CornerRadius = UDim.new(0, 12)

        local btnGetKeyStroke = Instance.new("UIStroke")
        btnGetKeyStroke.Thickness = 1.5
        btnGetKeyStroke.Color = Color3.fromRGB(0, 240, 255)
        btnGetKeyStroke.Transparency = 0.6
        btnGetKeyStroke.Parent = btnGetKey

        local btnVerify = Instance.new("TextButton")
        btnVerify.Size = UDim2.new(0.42, 0, 0, 44)
        btnVerify.Position = UDim2.new(0.52, 0, 0, 172)
        btnVerify.BackgroundColor3 = Color3.fromRGB(0, 240, 255)
        btnVerify.Text = "✔️ XÁC NHẬN"
        btnVerify.Font = Enum.Font.GothamBlack
        btnVerify.TextSize = 13
        btnVerify.TextColor3 = Color3.fromRGB(10, 15, 25)
        btnVerify.Parent = card
        Instance.new("UICorner", btnVerify).CornerRadius = UDim.new(0, 12)

        local authorSub = Instance.new("TextLabel")
        authorSub.Size = UDim2.new(1, 0, 0, 20)
        authorSub.Position = UDim2.new(0, 0, 0, 230)
        authorSub.BackgroundTransparency = 1
        authorSub.Text = "Sáng tạo bởi: " .. Engine.Author .. " (@" .. Engine.AuthorRoblox .. ") • Key có hiệu lực 24h"
        authorSub.Font = Enum.Font.GothamMedium
        authorSub.TextSize = 9
        authorSub.TextColor3 = Color3.fromRGB(120, 140, 165)
        authorSub.Parent = card

        btnGetKey.MouseButton1Click:Connect(function()
            Engine.Modules.AudioFX:Click()
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
            Engine.Modules.AudioFX:Click()
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
                    Engine.Modules.AudioFX:Notify()
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
-- [6] NOTIFICATION MANAGER V10.5
-- ==========================================
Engine.Modules.NotificationManager = {
    Container = nil,
    Init = function(self)
        local coreGui = LocalPlayer:WaitForChild("PlayerGui")
        local sg = Instance.new("ScreenGui")
        sg.Name = "RBZoo_V9_Notifications"
        sg.ResetOnSpawn = false
        sg.Parent = coreGui
        
        self.Container = Instance.new("Frame")
        self.Container.Size = UDim2.new(0, 330, 1, -20)
        self.Container.Position = UDim2.new(1, -350, 0, 10)
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
        Engine.Modules.AudioFX:Notify()
        
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 68)
        frame.BackgroundColor3 = Color3.fromRGB(11, 15, 26)
        frame.BackgroundTransparency = 1
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 14)
        
        local stroke = Instance.new("UIStroke")
        stroke.Thickness = 1.5
        stroke.Transparency = 1
        stroke.Color = Color3.fromRGB(0, 240, 255)
        stroke.Parent = frame
        
        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(1, -15, 0, 26)
        titleLabel.Position = UDim2.new(0, 15, 0, 6)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = title
        titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        titleLabel.TextTransparency = 1
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.TextSize = 13
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Parent = frame
        
        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1, -15, 0, 26)
        textLabel.Position = UDim2.new(0, 15, 0, 32)
        textLabel.BackgroundTransparency = 1
        textLabel.Text = text
        textLabel.TextColor3 = Color3.fromRGB(210, 225, 240)
        textLabel.TextTransparency = 1
        textLabel.Font = Enum.Font.GothamMedium
        textLabel.TextSize = 11
        textLabel.TextXAlignment = Enum.TextXAlignment.Left
        textLabel.Parent = frame
        
        frame.Parent = self.Container
        
        local TweenInfoIn = TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        Engine.Services.TweenService:Create(frame, TweenInfoIn, {BackgroundTransparency = 0.2}):Play()
        Engine.Services.TweenService:Create(stroke, TweenInfoIn, {Transparency = 0.25}):Play()
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
-- [7] PERFECT ROLE RECOGNITION (ZOO / OOF / NEUTRAL)
-- ==========================================
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
    if not plr then return "NEUTRAL" end
    
    if typeof(plr) == "Instance" and plr:IsA("Model") then
        local p = Engine.Services.Players:GetPlayerFromCharacter(plr)
        if p then plr = p else return "OOF" end
    end
    
    if typeof(plr) ~= "Instance" or not plr:IsA("Player") then
        return "OOF"
    end
    
    if CheckIsProtectedOrNeutral(plr) then
        if plr ~= LocalPlayer then return "NEUTRAL" end
    end
    
    local char = plr.Character
    local isZoo, isOof = false, false
    
    -- 1. Kiểm tra Tên Team
    if plr.Team then
        local tName = plr.Team.Name:lower()
        if tName:find("zoo") or tName:find("keeper") or tName:find("human") or tName:find("guard") or tName:find("hunter") then
            isZoo = true
        elseif tName:find("oof") or tName:find("animal") or tName:find("beast") then
            isOof = true
        end
    end
    
    -- 2. Kiểm tra Attributes
    if not isZoo and not isOof then
        local attrRole = plr:GetAttribute("Role") or plr:GetAttribute("Team")
        if attrRole then
            local rStr = tostring(attrRole):lower()
            if rStr:find("zoo") or rStr:find("keeper") then isZoo = true
            elseif rStr:find("oof") or rStr:find("animal") then isOof = true end
        end
    end
    
    -- 3. Kiểm tra Vũ khí trên tay (Equipped Tools) & Ba lô (Backpack)
    if char then
        for _, tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") then
                local n = tool.Name:lower()
                if n:find("gun") or n:find("tranq") or n:find("taser") or n:find("rifle") or n:find("shotgun") or n:find("pistol") or n:find("weapon") or n:find("baton") or n:find("spear") or n:find("laser") then
                    isZoo = true
                elseif n:find("claw") or n:find("bite") or n:find("paw") or n:find("oof") then
                    isOof = true
                end
            end
        end
    end
    
    local backpack = plr:FindFirstChild("Backpack")
    if backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                local n = tool.Name:lower()
                if n:find("gun") or n:find("tranq") or n:find("taser") or n:find("rifle") or n:find("shotgun") or n:find("pistol") or n:find("weapon") or n:find("baton") or n:find("spear") then
                    isZoo = true
                elseif n:find("claw") or n:find("bite") or n:find("paw") or n:find("oof") then
                    isOof = true
                end
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
                    table.insert(Engine.Cache.Oofs, {Model = plr.Character, Root = hrp, Humanoid = hum, Player = plr, Role = "OOF"})
                elseif role == "ZOOKEEPER" then
                    table.insert(Engine.Cache.Zookeepers, {Model = plr.Character, Root = hrp, Humanoid = hum, Player = plr, Role = "ZOOKEEPER"})
                else
                    table.insert(Engine.Cache.Oofs, {Model = plr.Character, Root = hrp, Humanoid = hum, Player = plr, Role = "NEUTRAL"})
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
                table.insert(Engine.Cache.Oofs, {Model = animal, Root = hrp, Humanoid = hum, Role = "OOF"})
                table.insert(Engine.Cache.Animals, {Model = animal, Root = hrp, Humanoid = hum, Role = "OOF"})
            end
        end
    end
end

-- BẬT SCANNER TỰ ĐỘNG CHẠY LIÊN TỤC ĐỂ ESP HOẠT ĐỘNG NGAY LẬP TỨC
task.spawn(function()
    while task.wait(0.1) do
        pcall(FastScanPlayers)
    end
end)

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
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local myPos = hrp.Position
    
    local myRole = DeterminePlayerRole(LocalPlayer)
    -- NẾU LÀ NEUTRAL (NGƯỜI THƯỜNG / DÂN THƯỜNG): KHÔNG CHỌN MỤC TIÊU (ĐỨNG YÊN 1 CHỖ!)
    if myRole == "NEUTRAL" then
        Engine.State.TargetModel = nil
        return nil
    end
    
    local bestTargetRoot = nil
    local bestModel = nil
    local minScore = math.huge
    
    local pool = (myRole == "ZOOKEEPER") and Engine.Cache.Oofs or Engine.Cache.Zookeepers
    
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
    if not target:IsDescendantOf(workspace) then return false end
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
-- [8] ESP ENGINE 2.0 (ZOOKEEPER = RED, OOF = BLUE, NEUTRAL = GREEN)
-- ==========================================
local function isDrawingValid(obj)
    local t = typeof(obj)
    if t == "table" or t == "userdata" then
        local success, val = pcall(function() return obj.Visible end)
        return success
    end
    return false
end

local function safeSet(obj, prop, val)
    local t = typeof(obj)
    if t == "table" or t == "userdata" then
        pcall(function() obj[prop] = val end)
    end
end

Engine.Modules.ESPEngine = {
    Drawings = {},
    Highlights = {},

    Init = function(self)
        Engine.Services.RunService.RenderStepped:Connect(function()
            if Engine.Modules.ConfigManager.Settings.ESP then
                self:UpdateESP()
            else
                self:Clear()
            end
        end)
    end,

    Clear = function(self)
        for _, drawTable in pairs(self.Drawings) do
            for _, drawObj in pairs(drawTable) do
                if isDrawingValid(drawObj) and drawObj.Remove then 
                    pcall(function() drawObj:Remove() end) 
                end
            end
        end
        table.clear(self.Drawings)

        for _, hl in pairs(self.Highlights) do
            if hl and hl.Destroy then pcall(function() hl:Destroy() end) end
        end
        table.clear(self.Highlights)
    end,

    GetRoleColor = function(self, role)
        if role == "ZOOKEEPER" then return Color3.fromRGB(255, 50, 80) end -- ĐỎ (RED)
        if role == "OOF" then return Color3.fromRGB(0, 170, 255) end -- XANH BIỂN (BLUE)
        return Color3.fromRGB(50, 255, 140) -- XANH LÁ (GREEN FOR NEUTRAL/PEOPLE)
    end,

    UpdateESP = function(self)
        local myChar = LocalPlayer.Character
        local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if not myHrp then return end

        local scannedModels = {}
        local centerScreen = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        local closestModel = nil
        local minCrosshairDist = math.huge

        -- 1. Tìm mục tiêu gần tâm màn hình nhất để làm mục tiêu Active locked
        for _, pool in ipairs({Engine.Cache.Oofs, Engine.Cache.Zookeepers, Engine.Cache.Animals}) do
            for _, targetData in ipairs(pool) do
                local model = targetData.Model
                local root = targetData.Root
                local hum = targetData.Humanoid

                if model and root and hum and hum.Health > 0 and model ~= myChar then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(root.Position)
                    if onScreen then
                        local screenPos2D = Vector2.new(screenPos.X, screenPos.Y)
                        local distToCenter = (screenPos2D - centerScreen).Magnitude
                        if distToCenter < minCrosshairDist then
                            minCrosshairDist = distToCenter
                            closestModel = model
                        end
                    end
                end
            end
        end

        for _, pool in ipairs({Engine.Cache.Oofs, Engine.Cache.Zookeepers, Engine.Cache.Animals}) do
            for _, targetData in ipairs(pool) do
                local model = targetData.Model
                local root = targetData.Root
                local hum = targetData.Humanoid

                if model and root and hum and hum.Health > 0 and model ~= myChar then
                    scannedModels[model] = true
                    
                    local role = targetData.Role or (targetData.Player and DeterminePlayerRole(targetData.Player) or "OOF")
                    local color = self:GetRoleColor(role)
                    local dist = math.floor((root.Position - myHrp.Position).Magnitude)

                    -- Chams Highlight
                    if Engine.Modules.ConfigManager.Settings.ESPChams then
                        if not self.Highlights[model] then
                            local hl = Instance.new("Highlight")
                            hl.Name = "RBZoo_Highlight"
                            hl.Adornee = model
                            hl.FillColor = color
                            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                            hl.FillTransparency = 0.5
                            hl.OutlineTransparency = 0.25
                            hl.Parent = model
                            self.Highlights[model] = hl
                        else
                            self.Highlights[model].FillColor = color
                        end
                    elseif self.Highlights[model] then
                        pcall(function() self.Highlights[model]:Destroy() end)
                        self.Highlights[model] = nil
                    end

                    -- Drawing 2D ESP & Upgraded Tracer
                    if not self.Drawings[model] then
                        local box = pcall(function() return Drawing.new("Square") end) and Drawing.new("Square") or nil
                        local name = pcall(function() return Drawing.new("Text") end) and Drawing.new("Text") or nil
                        local distance = pcall(function() return Drawing.new("Text") end) and Drawing.new("Text") or nil
                        local tracer = pcall(function() return Drawing.new("Line") end) and Drawing.new("Line") or nil
                        local healthBar = pcall(function() return Drawing.new("Square") end) and Drawing.new("Square") or nil

                        self.Drawings[model] = {
                            Box = isDrawingValid(box) and box or nil,
                            Name = isDrawingValid(name) and name or nil,
                            Distance = isDrawingValid(distance) and distance or nil,
                            Tracer = isDrawingValid(tracer) and tracer or nil,
                            HealthBar = isDrawingValid(healthBar) and healthBar or nil
                        }
                    end

                    local drawObj = self.Drawings[model]
                    local screenPos, onScreen = Camera:WorldToViewportPoint(root.Position)

                    if onScreen then
                        local head = model:FindFirstChild("Head") or root
                        local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 1.5, 0))
                        local legPos = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))

                        local height = math.abs(headPos.Y - legPos.Y)
                        local width = height / 1.6

                        -- Box
                        safeSet(drawObj.Box, "Visible", Engine.Modules.ConfigManager.Settings.ESPBox)
                        safeSet(drawObj.Box, "Size", Vector2.new(width, height))
                        safeSet(drawObj.Box, "Position", Vector2.new(screenPos.X - width / 2, screenPos.Y - height / 2))
                        safeSet(drawObj.Box, "Color", color)
                        safeSet(drawObj.Box, "Thickness", 1.5)
                        safeSet(drawObj.Box, "Filled", false)

                        -- Name
                        safeSet(drawObj.Name, "Visible", Engine.Modules.ConfigManager.Settings.ESPName)
                        safeSet(drawObj.Name, "Text", model.Name .. " [" .. role .. "]")
                        safeSet(drawObj.Name, "Size", 12)
                        safeSet(drawObj.Name, "Center", true)
                        safeSet(drawObj.Name, "Outline", true)
                        safeSet(drawObj.Name, "Position", Vector2.new(screenPos.X, screenPos.Y - height / 2 - 15))
                        safeSet(drawObj.Name, "Color", Color3.fromRGB(255, 255, 255))

                        -- Distance
                        safeSet(drawObj.Distance, "Visible", Engine.Modules.ConfigManager.Settings.ESPDistance)
                        safeSet(drawObj.Distance, "Text", tostring(dist) .. " studs")
                        safeSet(drawObj.Distance, "Size", 11)
                        safeSet(drawObj.Distance, "Center", true)
                        safeSet(drawObj.Distance, "Outline", true)
                        safeSet(drawObj.Distance, "Position", Vector2.new(screenPos.X, screenPos.Y + height / 2 + 3))
                        safeSet(drawObj.Distance, "Color", Color3.fromRGB(200, 220, 255))

                        -- Upgraded Tracer
                        if Engine.Modules.ConfigManager.Settings.ESPTracers then
                            safeSet(drawObj.Tracer, "Visible", true)
                            if model == closestModel then
                                -- Tracer cho mục tiêu Active (Gần tâm ngắm nhất): Dày hơn, vẽ từ tâm màn hình
                                safeSet(drawObj.Tracer, "From", centerScreen)
                                safeSet(drawObj.Tracer, "To", Vector2.new(screenPos.X, screenPos.Y))
                                safeSet(drawObj.Tracer, "Color", Color3.fromRGB(0, 240, 255)) -- Neon Cyan chỉ định hướng chính
                                safeSet(drawObj.Tracer, "Thickness", 2.2)
                                safeSet(drawObj.Tracer, "Transparency", 0.95)
                            else
                                -- Tracer cho các người chơi khác: Mỏng, vẽ từ dưới lên, mờ dần theo khoảng cách
                                safeSet(drawObj.Tracer, "From", Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y))
                                safeSet(drawObj.Tracer, "To", Vector2.new(screenPos.X, screenPos.Y))
                                safeSet(drawObj.Tracer, "Color", color)
                                safeSet(drawObj.Tracer, "Thickness", 1)
                                
                                -- Mờ dần khi ở xa để tránh rối màn hình
                                local fadeTransparency = math.clamp(1 - (dist / 400), 0.15, 0.45)
                                safeSet(drawObj.Tracer, "Transparency", fadeTransparency)
                            end
                        else
                            safeSet(drawObj.Tracer, "Visible", false)
                        end

                        -- Health Bar
                        local hpPercent = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                        safeSet(drawObj.HealthBar, "Visible", Engine.Modules.ConfigManager.Settings.ESPHealth)
                        safeSet(drawObj.HealthBar, "Size", Vector2.new(3, height * hpPercent))
                        safeSet(drawObj.HealthBar, "Position", Vector2.new(screenPos.X - width / 2 - 6, screenPos.Y + height / 2 - (height * hpPercent)))
                        safeSet(drawObj.HealthBar, "Color", Color3.fromRGB(255 * (1 - hpPercent), 255 * hpPercent, 50))
                        safeSet(drawObj.HealthBar, "Filled", true)
                    else
                        -- Ẩn các ESP 2D thông thường khi ngoài màn hình
                        safeSet(drawObj.Box, "Visible", false)
                        safeSet(drawObj.Name, "Visible", false)
                        safeSet(drawObj.Distance, "Visible", false)
                        safeSet(drawObj.Tracer, "Visible", false)
                        safeSet(drawObj.HealthBar, "Visible", false)
                    end
                end
            end
        end

        -- Clean stale drawings
        for model, drawTable in pairs(self.Drawings) do
            if not scannedModels[model] then
                for _, obj in pairs(drawTable) do
                    if isDrawingValid(obj) and obj.Remove then
                        pcall(function() obj:Remove() end)
                    end
                end
                self.Drawings[model] = nil
            end
        end

        for model, hl in pairs(self.Highlights) do
            if not scannedModels[model] then
                hl:Destroy()
                self.Highlights[model] = nil
            end
        end
    end
}

-- ==========================================
-- [9] MINI RADAR MODULE VIP (CYBERPUNK MILITARY RADAR 3.0)
-- ==========================================
Engine.Modules.MiniRadar = {
    Gui = nil,
    Card = nil,
    Dots = {},
    Init = function(self)
        local coreGui = LocalPlayer:WaitForChild("PlayerGui")
        local sg = Instance.new("ScreenGui")
        sg.Name = "RBZoo_MiniRadar_V10"
        sg.ResetOnSpawn = false
        sg.Parent = coreGui
        self.Gui = sg

        local card = Instance.new("Frame")
        card.Size = UDim2.new(0, 150, 0, 150)
        card.Position = UDim2.new(1, -165, 0, 85)
        card.BackgroundColor3 = Color3.fromRGB(6, 10, 18)
        card.BackgroundTransparency = 0.15
        card.Active = true
        card.Draggable = true
        card.ClipsDescendants = true
        card.Parent = sg
        Instance.new("UICorner", card).CornerRadius = UDim.new(1, 0)
        
        local stroke = Instance.new("UIStroke")
        stroke.Thickness = 2.2
        stroke.Color = Color3.fromRGB(0, 240, 255)
        stroke.Parent = card

        -- Inner Concentric Distance Ring
        local innerRing = Instance.new("Frame")
        innerRing.Size = UDim2.new(0, 75, 0, 75)
        innerRing.Position = UDim2.new(0.5, -37.5, 0.5, -37.5)
        innerRing.BackgroundTransparency = 1
        innerRing.ZIndex = 2
        innerRing.Parent = card
        Instance.new("UICorner", innerRing).CornerRadius = UDim.new(1, 0)
        local innerStroke = Instance.new("UIStroke")
        innerStroke.Thickness = 1
        innerStroke.Color = Color3.fromRGB(0, 240, 255)
        innerStroke.Transparency = 0.75
        innerStroke.Parent = innerRing

        -- Radar Header Label
        local radarHeader = Instance.new("TextLabel")
        radarHeader.Size = UDim2.new(1, 0, 0, 18)
        radarHeader.Position = UDim2.new(0, 0, 0, 8)
        radarHeader.BackgroundTransparency = 1
        radarHeader.Text = "📡 RADAR 3.0"
        radarHeader.Font = Enum.Font.GothamBlack
        radarHeader.TextSize = 9
        radarHeader.TextColor3 = Color3.fromRGB(0, 240, 255)
        radarHeader.ZIndex = 6
        radarHeader.Parent = card

        -- Target Counter Footer
        local targetCountLabel = Instance.new("TextLabel")
        targetCountLabel.Size = UDim2.new(1, 0, 0, 16)
        targetCountLabel.Position = UDim2.new(0, 0, 1, -22)
        targetCountLabel.BackgroundTransparency = 1
        targetCountLabel.Text = "0 TARGETS"
        targetCountLabel.Font = Enum.Font.GothamBold
        targetCountLabel.TextSize = 8
        targetCountLabel.TextColor3 = Color3.fromRGB(0, 255, 170)
        targetCountLabel.ZIndex = 6
        targetCountLabel.Parent = card

        -- Crosshair Grid Lines Inside Radar
        local lineH = Instance.new("Frame")
        lineH.Size = UDim2.new(1, 0, 0, 1)
        lineH.Position = UDim2.new(0, 0, 0.5, 0)
        lineH.BackgroundColor3 = Color3.fromRGB(0, 240, 255)
        lineH.BackgroundTransparency = 0.75
        lineH.ZIndex = 2
        lineH.Parent = card

        local lineV = Instance.new("Frame")
        lineV.Size = UDim2.new(0, 1, 1, 0)
        lineV.Position = UDim2.new(0.5, 0, 0, 0)
        lineV.BackgroundColor3 = Color3.fromRGB(0, 240, 255)
        lineV.BackgroundTransparency = 0.75
        lineV.ZIndex = 2
        lineV.Parent = card

        -- Rotating Radar Sweep Line Beam
        local sweepPivot = Instance.new("Frame")
        sweepPivot.Size = UDim2.new(0, 0, 0, 0)
        sweepPivot.Position = UDim2.new(0.5, 0, 0.5, 0)
        sweepPivot.BackgroundTransparency = 1
        sweepPivot.ZIndex = 3
        sweepPivot.Parent = card

        local sweepLine = Instance.new("Frame")
        sweepLine.Size = UDim2.new(0, 2, 0, 70)
        sweepLine.Position = UDim2.new(0, -1, 0, -70)
        sweepLine.BackgroundColor3 = Color3.fromRGB(0, 240, 255)
        sweepLine.BackgroundTransparency = 0.4
        sweepLine.BorderSizePixel = 0
        sweepLine.ZIndex = 3
        sweepLine.Parent = sweepPivot

        task.spawn(function()
            local deg = 0
            while card and card.Parent do
                deg = (deg + 3) % 360
                sweepPivot.Rotation = deg
                task.wait(0.02)
            end
        end)

        -- Center Self Dot & Procedural V-Shaped Vision Cone ("Góc Định Hướng V")
        local visionConeContainer = Instance.new("Frame")
        visionConeContainer.Size = UDim2.new(0, 70, 0, 70)
        visionConeContainer.Position = UDim2.new(0.5, -35, 0.5, -35)
        visionConeContainer.BackgroundTransparency = 1
        visionConeContainer.ZIndex = 6
        visionConeContainer.Parent = card

        -- Cánh trái V (Left V Line)
        local leftVArm = Instance.new("Frame")
        leftVArm.Size = UDim2.new(0, 2, 0, 48)
        leftVArm.AnchorPoint = Vector2.new(0.5, 1)
        leftVArm.Position = UDim2.new(0.5, 0, 0.5, 0)
        leftVArm.Rotation = -30
        leftVArm.BackgroundColor3 = Color3.fromRGB(0, 240, 255)
        leftVArm.BackgroundTransparency = 0.25
        leftVArm.BorderSizePixel = 0
        leftVArm.ZIndex = 6
        leftVArm.Parent = visionConeContainer

        -- Cánh phải V (Right V Line)
        local rightVArm = Instance.new("Frame")
        rightVArm.Size = UDim2.new(0, 2, 0, 48)
        rightVArm.AnchorPoint = Vector2.new(0.5, 1)
        rightVArm.Position = UDim2.new(0.5, 0, 0.5, 0)
        rightVArm.Rotation = 30
        rightVArm.BackgroundColor3 = Color3.fromRGB(0, 240, 255)
        rightVArm.BackgroundTransparency = 0.25
        rightVArm.BorderSizePixel = 0
        rightVArm.ZIndex = 6
        rightVArm.Parent = visionConeContainer

        -- Mũi tên chỉ hướng trước mặt ▲
        local vArrowTag = Instance.new("TextLabel")
        vArrowTag.Size = UDim2.new(0, 20, 0, 14)
        vArrowTag.Position = UDim2.new(0.5, -10, 0.5, -50)
        vArrowTag.BackgroundTransparency = 1
        vArrowTag.Text = "▲"
        vArrowTag.Font = Enum.Font.GothamBlack
        vArrowTag.TextSize = 11
        vArrowTag.TextColor3 = Color3.fromRGB(0, 240, 255)
        vArrowTag.ZIndex = 7
        vArrowTag.Parent = visionConeContainer

        local selfDot = Instance.new("Frame")
        selfDot.Size = UDim2.new(0, 8, 0, 8)
        selfDot.Position = UDim2.new(0.5, -4, 0.5, -4)
        selfDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        selfDot.ZIndex = 8
        selfDot.Parent = card
        Instance.new("UICorner", selfDot).CornerRadius = UDim.new(1, 0)

        local selfStroke = Instance.new("UIStroke")
        selfStroke.Thickness = 1.5
        selfStroke.Color = Color3.fromRGB(0, 255, 170)
        selfStroke.Parent = selfDot
        
        self.Card = card

        Engine.Services.RunService.RenderStepped:Connect(function()
            if not Engine.Modules.ConfigManager.Settings.ShowRadar then
                card.Visible = false
                return
            end
            card.Visible = true

            for _, dot in pairs(self.Dots) do dot:Destroy() end
            table.clear(self.Dots)

            local myChar = LocalPlayer.Character
            local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if not myHrp then return end

            local camCFrame = Camera.CFrame
            local targetCount = 0

            -- Quét thời gian thực tất cả Người chơi theo góc quay Camera (Object Space Rotation)
            for _, plr in ipairs(Engine.Services.Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character then
                    local hrp = plr.Character:FindFirstChild("HumanoidRootPart") or plr.Character:FindFirstChild("Head")
                    local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                    if hrp and hum and hum.Health > 0 then
                        targetCount = targetCount + 1
                        local role = DeterminePlayerRole(plr)
                        local relVector = camCFrame:VectorToObjectSpace(hrp.Position - myHrp.Position)
                        
                        -- relVector.X (phải/trái), relVector.Z (trước/sau)
                        local rx = math.clamp(relVector.X / 3.5, -62, 62)
                        local rz = math.clamp(relVector.Z / 3.5, -62, 62)

                        local dot = Instance.new("Frame")
                        dot.Size = UDim2.new(0, 7, 0, 7)
                        dot.Position = UDim2.new(0.5, rx - 3.5, 0.5, rz - 3.5)
                        dot.BackgroundColor3 = Engine.Modules.ESPEngine:GetRoleColor(role)
                        dot.ZIndex = 5
                        dot.Parent = card
                        Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

                        local dotStroke = Instance.new("UIStroke")
                        dotStroke.Thickness = 1
                        dotStroke.Color = Color3.fromRGB(255, 255, 255)
                        dotStroke.Transparency = 0.3
                        dotStroke.Parent = dot

                        table.insert(self.Dots, dot)
                    end
                end
            end

            -- Quét thêm folder Animals trong map nếu có
            local animalFolder = Engine.Services.Workspace:FindFirstChild("Gameplay") and Engine.Services.Workspace.Gameplay:FindFirstChild("Dynamic") and Engine.Services.Workspace.Gameplay.Dynamic:FindFirstChild("Animals")
            if animalFolder then
                for _, animal in ipairs(animalFolder:GetChildren()) do
                    local hrp = animal:FindFirstChild("HumanoidRootPart") or animal:FindFirstChild("Head")
                    local hum = animal:FindFirstChildOfClass("Humanoid")
                    if hrp and hum and hum.Health > 0 then
                        targetCount = targetCount + 1
                        local relVector = camCFrame:VectorToObjectSpace(hrp.Position - myHrp.Position)
                        local rx = math.clamp(relVector.X / 3.5, -62, 62)
                        local rz = math.clamp(relVector.Z / 3.5, -62, 62)

                        local dot = Instance.new("Frame")
                        dot.Size = UDim2.new(0, 7, 0, 7)
                        dot.Position = UDim2.new(0.5, rx - 3.5, 0.5, rz - 3.5)
                        dot.BackgroundColor3 = Color3.fromRGB(0, 170, 255) -- Blue OOF
                        dot.ZIndex = 5
                        dot.Parent = card
                        Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
                        table.insert(self.Dots, dot)
                    end
                end
            end

            targetCountLabel.Text = tostring(targetCount) .. " TARGETS"
        end)
    end
}

-- ==========================================
-- [10] HUNTER HUD MODULE V10.5
-- ==========================================
Engine.Modules.HunterHUD = {
    Gui = nil,
    Labels = {},
    
    Init = function(self)
        local coreGui = LocalPlayer:WaitForChild("PlayerGui")
        local sg = Instance.new("ScreenGui")
        sg.Name = "RBZoo_Hunter_HUD_V9"
        sg.ResetOnSpawn = false
        sg.Parent = coreGui
        self.Gui = sg
        
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0, 250, 0, 210)
        frame.Position = UDim2.new(0, 15, 0.25, 0)
        frame.BackgroundColor3 = Color3.fromRGB(10, 14, 24)
        frame.BackgroundTransparency = 0.28
        frame.Active = true
        frame.Draggable = true
        frame.Parent = sg
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 14)
        
        local stroke = Instance.new("UIStroke")
        stroke.Thickness = 1.8
        stroke.Color = Color3.fromRGB(0, 240, 255)
        stroke.Transparency = 0.3
        stroke.Parent = frame
        
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, 0, 0, 28)
        title.BackgroundTransparency = 1
        title.Text = "⚡ CYBERPUNK HUD V10.5 VIP"
        title.Font = Enum.Font.GothamBlack
        title.TextSize = 12
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
        addLabel("FPSPing", "FPS: 60  |  Ping: 0 ms").LayoutOrder = 6
        addLabel("KeyTime", "⏳ Key Hạn: N/A").LayoutOrder = 7
        addLabel("Author", "👑 Creator: " .. Engine.Author).LayoutOrder = 8
        
        local lastTime = tick()
        local frameCount = 0
        
        Engine.Services.RunService.RenderStepped:Connect(function()
            frameCount = frameCount + 1
            if tick() - lastTime >= 1 then
                Engine.State.FPS = frameCount
                frameCount = 0
                lastTime = tick()
            end

            pcall(function()
                Engine.State.Ping = math.floor(Engine.Services.Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            end)

            if not Engine.Modules.ConfigManager.Settings.ShowHUD then
                frame.Visible = false
                return
            end
            frame.Visible = true
            
            stroke.Color = Color3.fromHSV(tick() % 5 / 5, 0.75, 1)
            
            local targetName = "None"
            local distStr = "N/A"
            local statusStr = Engine.Modules.ConfigManager.Settings.AutoFarm and "Hunting AI 2.0" or "Idle"
            
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
            self.Labels.FPSPing.Text = string.format("FPS: %d  |  Ping: %d ms", Engine.State.FPS, Engine.State.Ping)
            self.Labels.KeyTime.Text = "⏳ Key Hạn: " .. Engine.Modules.KeySystem:GetRemainingTime()
            self.Labels.Author.Text = "👑 Creator: " .. Engine.Author
        end)
    end
}

-- ==========================================
-- [11] STANDALONE AUTO ATTACK ENGINE (CHỈ XẢ ĐẠN/CLICK KHI LÀ ZOOKEEPER HOẶC CÓ SÚNG)
-- ==========================================
task.spawn(function()
    while task.wait(0.05) do
        pcall(function()
            if Engine.Modules.ConfigManager.Settings.AutoAttack then
                local role = DeterminePlayerRole(LocalPlayer)
                -- Auto Attack (Xả đạn súng/chuột trái) chỉ chạy khi là Zookeeper
                if role == "ZOOKEEPER" then
                    -- Nếu đang bật AutoFarm, chỉ click/bắn khi có mục tiêu thực sự hợp lệ
                    if Engine.Modules.ConfigManager.Settings.AutoFarm and (not Engine.State.CurrentTarget or not IsTargetValid(Engine.State.CurrentTarget)) then
                        return
                    end

                    local char = LocalPlayer.Character
                    if char then
                        local tool = char:FindFirstChildOfClass("Tool")
                        if not tool then
                            local backpack = LocalPlayer:FindFirstChild("Backpack")
                            if backpack then
                                local gTool = backpack:FindFirstChildOfClass("Tool")
                                local hum = char:FindFirstChildOfClass("Humanoid")
                                if gTool and hum then
                                    hum:EquipTool(gTool)
                                    tool = gTool
                                end
                            end
                        end
                        
                        if tool then
                            -- 1. Kích hoạt Tool trực tiếp
                            tool:Activate()
                            
                            -- 2. Gửi RemoteEvent bắn súng bên trong Tool nếu có
                            for _, v in ipairs(tool:GetDescendants()) do
                                if v:IsA("RemoteEvent") then
                                    local n = v.Name:lower()
                                    if n:find("fire") or n:find("shoot") or n:find("use") or n:find("attack") or n:find("action") then
                                        if Engine.State.CurrentTarget then
                                            v:FireServer(Engine.State.CurrentTarget.Position)
                                            v:FireServer(Engine.State.CurrentTarget)
                                        else
                                            v:FireServer()
                                        end
                                    end
                                end
                            end
                            
                            -- 3. Mô phỏng Click Chuột Trái thật liên tục
                            TriggerMouseClick()
                        end
                    end
                end
            end
        end)
    end
end)

-- ==========================================
-- [12] STANDALONE AUTO SKILL ENGINE (CHẨN ĐOÁN CHÍNH XÁC: ZOO CHỈ NHẤN Q, OOF CHỈ NHẤN E)
-- ==========================================
task.spawn(function()
    while task.wait(0.3) do
        pcall(function()
            if Engine.Modules.ConfigManager.Settings.AutoSkill then
                local char = LocalPlayer.Character
                if char and char:FindFirstChildOfClass("Humanoid") then
                    local role = DeterminePlayerRole(LocalPlayer)
                    Engine.State.CurrentRole = role

                    -- CHỈ NHẤN PHÍM TƯƠNG ỨNG VỚI VAI TRÒ (STRICT ROLE LOCKing):
                    if role == "ZOOKEEPER" then
                        -- Khi là Zookeeper: CHỈ BẤM PHÍM Q
                        PressKey(Enum.KeyCode.Q)
                    elseif role == "OOF" then
                        -- Khi là OOF: CHỈ BẤM PHÍM E
                        PressKey(Enum.KeyCode.E)
                    else
                        -- Trường hợp Neutral: Kiểm tra tên vũ khí đang cầm để quyết định phím bấm
                        local tool = char:FindFirstChildOfClass("Tool") or (LocalPlayer:FindFirstChild("Backpack") and LocalPlayer.Backpack:FindFirstChildOfClass("Tool"))
                        if tool then
                            local tName = tool.Name:lower()
                            if tName:find("oof") or tName:find("claw") or tName:find("e") then
                                PressKey(Enum.KeyCode.E)
                            else
                                PressKey(Enum.KeyCode.Q)
                            end
                        else
                            PressKey(Enum.KeyCode.Q)
                        end
                    end
                    
                    -- Kích hoạt thêm RemoteEvent kỹ năng riêng của nhân vật
                    for _, v in ipairs(char:GetDescendants()) do
                        if v:IsA("RemoteEvent") then
                            local n = v.Name:lower()
                            if role == "ZOOKEEPER" and (n:find("q") or n:find("zoo") or n:find("skill")) then
                                v:FireServer()
                            elseif role == "OOF" and (n:find("e") or n:find("oof") or n:find("ability")) then
                                v:FireServer()
                            end
                        end
                    end
                end
            end
        end)
    end
end)

-- ==========================================
-- [13] FARM ENGINE 2.0
-- ==========================================
Engine.Modules.FarmManager = {
    StuckTracker = { LastPos = Vector3.zero, StuckTime = 0, OffsetVector = Vector3.zero },
    LastActions = { Attack = 0, Skill = 0, Prompt = 0, Weapon = 0 },
    
    AutoEquipBestTool = function(self)
        if not Engine.Modules.ConfigManager.Settings.AutoWeapon then return end
        if tick() - self.LastActions.Weapon < 1.0 then return end
        self.LastActions.Weapon = tick()

        pcall(function()
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if not hum then return end

            local currentTool = char:FindFirstChildOfClass("Tool")
            if not currentTool then
                local backpack = LocalPlayer:FindFirstChild("Backpack")
                if backpack then
                    local tools = backpack:GetChildren()
                    if #tools > 0 then
                        hum:EquipTool(tools[1])
                    end
                end
            end
        end)
    end,

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
                self:AutoEquipBestTool()
                
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
                if Engine.Modules.ConfigManager.Settings.AutoMoney and tick() - self.LastActions.Prompt > 1.2 then
                    self.LastActions.Prompt = tick()
                    for _, item in ipairs(Engine.Cache.Prompts) do
                        if fireproximityprompt and item.Prompt and item.Prompt.Parent then
                            pcall(function() fireproximityprompt(item.Prompt) end)
                            break
                        end
                    end
                end
                task.wait(0.12)
            end
        end)
        table.insert(Engine.State.FarmConnections, actionThread)
        
        local farmLoop = Engine.Services.RunService.Heartbeat:Connect(function(dt)
            if not Engine.Modules.ConfigManager.Settings.AutoFarm then return end
            local myRole = DeterminePlayerRole(LocalPlayer)
            if myRole == "NEUTRAL" then return end -- NẾU LÀ NGƯỜI THƯỜNG: ĐỨNG YÊN TẠI CHỖ, KHÔNG TỰ BAY HAY BAY ĐẾN QUÁI!

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
                        self.StuckTracker.OffsetVector = Vector3.new(math.random(-15, 15), 12, math.random(-15, 15))
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
                    local defaultPos = targetCFrame.Position + (targetCFrame.LookVector * 11) + Vector3.new(0, 3, 0) + self.StuckTracker.OffsetVector
                    
                    if Engine.Modules.ConfigManager.Settings.SmartWallBypass then
                        local hasLOS = CheckLineOfSight(defaultPos, targetPos, Engine.State.TargetModel)
                        if not hasLOS then
                            destination = targetPos + Vector3.new(0, 15, 0) + self.StuckTracker.OffsetVector
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
                
                Camera.CFrame = Camera.CFrame:Lerp(CFrame.lookAt(Camera.CFrame.Position, targetPos), 0.3)
            end
        end)
        table.insert(Engine.State.FarmConnections, farmLoop)
        
        Engine.Modules.NotificationManager:Notify("Cyberpunk Hunter V10.5", "AI Auto Farm 2.0 VIP Active!", 3)
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
-- [14] EXPLOITS (AIMBOT, SILENT AIM, FLY, 3-COLOR HITBOX)
-- ==========================================
local fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 1.8
fovCircle.Color = Color3.fromRGB(0, 240, 255)
fovCircle.Transparency = 0.85
fovCircle.Filled = false
fovCircle.NumSides = 64

Engine.Services.RunService.RenderStepped:Connect(function()
    local mousePos = Engine.Services.UIS:GetMouseLocation()
    fovCircle.Radius = Engine.Modules.ConfigManager.Settings.AimbotFOV
    fovCircle.Position = mousePos
    fovCircle.Visible = Engine.Modules.ConfigManager.Settings.Aimbot or Engine.Modules.ConfigManager.Settings.SilentAim
    
    if (Engine.Modules.ConfigManager.Settings.Aimbot or Engine.Modules.ConfigManager.Settings.SilentAim) and Engine.State.CurrentTarget and IsTargetValid(Engine.State.CurrentTarget) then
        local targetPos = Engine.State.CurrentTarget.Position
        if Engine.Modules.ConfigManager.Settings.Prediction and Engine.State.CurrentRole ~= "ZOOKEEPER" then
            local vel = Engine.State.CurrentTarget:IsA("BasePart") and Engine.State.CurrentTarget.AssemblyLinearVelocity or Vector3.zero
            targetPos = targetPos + (vel * Engine.Modules.ConfigManager.Settings.PredictionAmount)
        end

        if Engine.Modules.ConfigManager.Settings.Aimbot then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.lookAt(Camera.CFrame.Position, targetPos), Engine.Modules.ConfigManager.Settings.AimbotSmooth)
        end
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

-- HITBOX EXPANDER CHUẨN 3 MÀU: ZOO = ĐỎ, OOF = XANH BIỂN, NGƯỜI THƯỜNG = XANH LÁ
task.spawn(function()
    while task.wait(0.2) do
        if Engine.Modules.ConfigManager.Settings.HitboxSize > 2 then
            for _, plr in ipairs(Engine.Services.Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character then
                    local role = DeterminePlayerRole(plr)
                    local root = plr.Character:FindFirstChild("HumanoidRootPart")
                    if root then
                        root.Size = Vector3.new(Engine.Modules.ConfigManager.Settings.HitboxSize, Engine.Modules.ConfigManager.Settings.HitboxSize, Engine.Modules.ConfigManager.Settings.HitboxSize)
                        root.Transparency = Engine.Modules.ConfigManager.Settings.HitboxTransparency
                        root.CanCollide = false
                        
                        if role == "ZOOKEEPER" then
                            root.Color = Color3.fromRGB(255, 50, 80) -- ĐỎ (RED)
                            root.Material = Enum.Material.ForceField
                        elseif role == "OOF" then
                            root.Color = Color3.fromRGB(0, 170, 255) -- XANH BIỂN (BLUE)
                            root.Material = Enum.Material.ForceField
                        else
                            root.Color = Color3.fromRGB(50, 255, 140) -- XANH LÁ (GREEN FOR NEUTRAL/PEOPLE)
                            root.Material = Enum.Material.ForceField
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
-- [15] CYBERPUNK VIP UI CONTROLLER V10.5 (BILINGUAL & FLY HOTKEY [F])
-- ==========================================
Engine.Modules.UIController = {
    ChromaObjects = {},
    Toggles = {},
    MainFrame = nil,
    LogoButton = nil,
    
    Init = function(self)
        local coreGui = LocalPlayer:WaitForChild("PlayerGui")
        local sg = Instance.new("ScreenGui")
        sg.Name = "RBZoo_V9_UI_LiquidGlass"
        sg.ResetOnSpawn = false
        sg.Parent = coreGui
        
        -- Floating Logo Button với Custom Logo (https://pngup.com/XftU/bun.jpg)
        self.LogoButton = Instance.new("ImageButton")
        self.LogoButton.Size = UDim2.new(0, 60, 0, 60)
        self.LogoButton.Position = UDim2.new(0, 20, 0.5, -30)
        self.LogoButton.BackgroundColor3 = Color3.fromRGB(11, 15, 26)
        self.LogoButton.BackgroundTransparency = 0.15
        self.LogoButton.Image = "rbxassetid://0"
        self.LogoButton.Active = true
        self.LogoButton.Draggable = true
        self.LogoButton.Parent = sg
        Instance.new("UICorner", self.LogoButton).CornerRadius = UDim.new(1, 0)

        local logoStroke = Instance.new("UIStroke")
        logoStroke.Thickness = 2.5
        logoStroke.Color = Color3.fromRGB(0, 240, 255)
        logoStroke.Parent = self.LogoButton
        table.insert(self.ChromaObjects, logoStroke)
        
        self.LogoButton.MouseButton1Click:Connect(function()
            Engine.Modules.AudioFX:Click()
            self.MainFrame.Visible = not self.MainFrame.Visible
        end)
        
        -- Main Cyberpunk Container Frame
        self.MainFrame = Instance.new("Frame")
        self.MainFrame.Size = UDim2.new(0, 640, 0, 430)
        self.MainFrame.Position = UDim2.new(0.5, -320, 0.5, -215)
        self.MainFrame.BackgroundColor3 = Color3.fromRGB(9, 12, 22)
        self.MainFrame.BackgroundTransparency = 0.2
        self.MainFrame.Active = true
        self.MainFrame.Draggable = true
        self.MainFrame.ClipsDescendants = true
        self.MainFrame.Parent = sg
        Instance.new("UICorner", self.MainFrame).CornerRadius = UDim.new(0, 20)
        
        local mainStroke = Instance.new("UIStroke")
        mainStroke.Thickness = 2.2
        mainStroke.Transparency = 0.15
        mainStroke.Color = Color3.fromRGB(0, 240, 255)
        mainStroke.Parent = self.MainFrame
        table.insert(self.ChromaObjects, mainStroke)
        
        -- Header Bar
        local topBar = Instance.new("Frame")
        topBar.Size = UDim2.new(1, 0, 0, 58)
        topBar.BackgroundTransparency = 1
        topBar.Parent = self.MainFrame
        
        -- Creator Avatar Profile Frame
        local creatorAvatar = Instance.new("ImageLabel")
        creatorAvatar.Size = UDim2.new(0, 44, 0, 44)
        creatorAvatar.Position = UDim2.new(0, 14, 0, 7)
        creatorAvatar.BackgroundColor3 = Color3.fromRGB(20, 26, 42)
        creatorAvatar.Image = "rbxassetid://0"
        creatorAvatar.Parent = topBar
        Instance.new("UICorner", creatorAvatar).CornerRadius = UDim.new(1, 0)
        
        local avatarStroke = Instance.new("UIStroke")
        avatarStroke.Thickness = 1.8
        avatarStroke.Color = Color3.fromRGB(0, 240, 255)
        avatarStroke.Parent = creatorAvatar

        task.spawn(function()
            while creatorAvatar and creatorAvatar.Parent do
                if Engine.State.LogoAssetId ~= "" then
                    creatorAvatar.Image = Engine.State.LogoAssetId
                    self.LogoButton.Image = Engine.State.LogoAssetId
                    break
                elseif Engine.State.AvatarUrl ~= "" then
                    creatorAvatar.Image = Engine.State.AvatarUrl
                    self.LogoButton.Image = Engine.State.AvatarUrl
                    break
                end
                task.wait(0.2)
            end
        end)

        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, -75, 0, 26)
        title.Position = UDim2.new(0, 68, 0, 6)
        title.BackgroundTransparency = 1
        title.Text = "⚡ RB ZOO CYBERPUNK VIP V10.5"
        title.Font = Enum.Font.GothamBlack
        title.TextSize = 14
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Parent = topBar
        table.insert(self.ChromaObjects, title)
        
        local authorLabel = Instance.new("TextLabel")
        authorLabel.Size = UDim2.new(1, -75, 0, 18)
        authorLabel.Position = UDim2.new(0, 68, 0, 30)
        authorLabel.BackgroundTransparency = 1
        authorLabel.Text = "👑 Sáng tạo bởi: " .. Engine.Author .. "  |  Roblox: @" .. Engine.AuthorRoblox
        authorLabel.Font = Enum.Font.GothamBold
        authorLabel.TextSize = 11
        authorLabel.TextColor3 = Color3.fromRGB(255, 0, 140)
        authorLabel.TextXAlignment = Enum.TextXAlignment.Left
        authorLabel.Parent = topBar
        
        local line = Instance.new("Frame")
        line.Size = UDim2.new(1, -32, 0, 1)
        line.Position = UDim2.new(0, 16, 1, -1)
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
        
        -- HOTKEYS: RightShift (Ẩn/Hiện Menu), P (Toggle AutoFarm), F (Toggle Fly)
        local lastKeyTimes = { P = 0, F = 0, RightShift = 0 }
        Engine.Services.UIS.InputBegan:Connect(function(input)
            if Engine.Services.UIS:GetFocusedTextBox() then return end
            if input.UserInputType ~= Enum.UserInputType.Keyboard then return end

            local now = tick()
            if input.KeyCode == Enum.KeyCode.RightShift then
                if now - lastKeyTimes.RightShift < 0.25 then return end
                lastKeyTimes.RightShift = now
                Engine.Modules.AudioFX:Click()
                if self.MainFrame then
                    self.MainFrame.Visible = not self.MainFrame.Visible
                end
            elseif input.KeyCode == Enum.KeyCode.P then
                if now - lastKeyTimes.P < 0.35 then return end
                lastKeyTimes.P = now
                
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
            elseif input.KeyCode == Enum.KeyCode.F then
                if now - lastKeyTimes.F < 0.35 then return end
                lastKeyTimes.F = now
                
                local newState = not Engine.Modules.ConfigManager.Settings.Fly
                Engine.Modules.ConfigManager.Settings.Fly = newState
                Engine.Modules.ConfigManager:Save()
                
                if self.Toggles["Fly"] then
                    self.Toggles["Fly"](newState)
                end

                local lang = Engine.Modules.ConfigManager.Settings.Language
                local msg = (lang == "VN") and ("Chế độ Bay Fly: " .. (newState and "BẬT [ON]" or "TẮT [OFF]")) or ("Fly Mode: " .. (newState and "ON" or "OFF"))
                Engine.Modules.NotificationManager:Notify("Hotkey [F]", msg, 2)
            end
        end)
    end,
    
    BuildTabs = function(self, parent)
        local lang = Engine.Modules.ConfigManager.Settings.Language
        local dict = L[lang] or L.VN
        
        local tabContainer = Instance.new("Frame")
        tabContainer.Size = UDim2.new(0, 160, 1, -20)
        tabContainer.Position = UDim2.new(0, 14, 0, 10)
        tabContainer.BackgroundColor3 = Color3.fromRGB(15, 20, 34)
        tabContainer.BackgroundTransparency = 0.4
        tabContainer.Parent = parent
        Instance.new("UICorner", tabContainer).CornerRadius = UDim.new(0, 14)
        
        local tabList = Instance.new("UIListLayout")
        tabList.SortOrder = Enum.SortOrder.LayoutOrder
        tabList.Padding = UDim.new(0, 6)
        tabList.Parent = tabContainer
        
        local pageContainer = Instance.new("Frame")
        pageContainer.Size = UDim2.new(1, -195, 1, -20)
        pageContainer.Position = UDim2.new(0, 184, 0, 10)
        pageContainer.BackgroundTransparency = 1
        pageContainer.ZIndex = 2
        pageContainer.Parent = parent
        
        local pages = {}
        local tabButtons = {}
        
        local function createTab(name, first)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 40)
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
            page.BorderSizePixel = 0
            page.ScrollBarThickness = 4
            page.ScrollBarImageTransparency = 0.5
            page.ScrollBarImageColor3 = Color3.fromRGB(0, 240, 255)
            page.Visible = first
            page.ZIndex = 2
            page.AutomaticCanvasSize = Enum.AutomaticSize.Y
            page.CanvasSize = UDim2.new(0, 0, 0, 0)
            page.Parent = pageContainer
            
            local pageLayout = Instance.new("UIListLayout")
            pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
            pageLayout.Padding = UDim.new(0, 8)
            pageLayout.Parent = page
            
            pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                page.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y + 20)
            end)
            
            if first then
                btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                table.insert(self.ChromaObjects, btn)
            end
            
            btn.MouseButton1Click:Connect(function()
                Engine.Modules.AudioFX:Click()
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
        
        local pageESP = createTab(dict.ESP_TAB, true)
        local pageCombat = createTab(dict.COMBAT_TAB, false)
        local pageFarm = createTab(dict.FARM_TAB, false)
        local pageMovement = createTab(dict.MOVEMENT_TAB, false)
        local pageKey = createTab(dict.KEY_TAB, false)

        -- ESP Visuals Tab
        self:CreateToggle(pageESP, dict.MASTER_ESP, "ESP", function(v)
            if not v then Engine.Modules.ESPEngine:Clear() end
        end)
        self:CreateToggle(pageESP, dict.BOX_ESP, "ESPBox")
        self:CreateToggle(pageESP, dict.NAME_ESP, "ESPName")
        self:CreateToggle(pageESP, dict.DIST_ESP, "ESPDistance")
        self:CreateToggle(pageESP, dict.HP_ESP, "ESPHealth")
        self:CreateToggle(pageESP, dict.TRACER_ESP, "ESPTracers")
        self:CreateToggle(pageESP, dict.CHAMS_ESP, "ESPChams")
        
        -- Combat AI Tab
        self:CreateToggle(pageCombat, dict.AIMBOT, "Aimbot")
        self:CreateToggle(pageCombat, dict.SILENT_AIM, "SilentAim")
        self:CreateSlider(pageCombat, dict.AIM_FOV, 50, 600, "AimbotFOV")
        self:CreateSlider(pageCombat, dict.AIM_SMOOTH, 0.05, 1, "AimbotSmooth")
        self:CreateToggle(pageCombat, dict.AUTO_ATTACK, "AutoAttack")
        self:CreateToggle(pageCombat, dict.AUTO_SKILL, "AutoSkill")
        self:CreateToggle(pageCombat, dict.AUTO_WEAPON, "AutoWeapon")
        self:CreateSlider(pageCombat, dict.HITBOX_SIZE, 2, 25, "HitboxSize")
        
        -- Automation Tab
        self:CreateToggle(pageFarm, dict.AUTO_FARM, "AutoFarm", function(v)
            if v then Engine.Modules.FarmManager:Start() else Engine.Modules.FarmManager:Stop() end
        end)
        self:CreateToggle(pageFarm, dict.WALL_BYPASS, "SmartWallBypass")
        self:CreateSlider(pageFarm, dict.FARM_SPEED, 30, 250, "AutoFarmSpeed")
        self:CreateSlider(pageFarm, dict.FARM_HEIGHT, 50, 1500, "AutoFarmHeight")
        self:CreateToggle(pageFarm, dict.ANTI_STUCK, "AntiStuck")
        self:CreateToggle(pageFarm, dict.AUTO_MONEY, "AutoMoney")
        self:CreateToggle(pageFarm, dict.ANTI_AFK, "AntiAFK")
        self:CreateToggle(pageFarm, dict.SHOW_HUD, "ShowHUD")
        self:CreateToggle(pageFarm, dict.SHOW_RADAR, "ShowRadar")
        self:CreateToggle(pageFarm, dict.AUDIO_FX, "AudioFX")
        self:CreateToggle(pageFarm, dict.FPS_BOOSTER, "FPSBooster", function(v)
            if v then Engine.Modules.PerformanceBooster:Init() end
        end)
        
        -- Movement Tab
        self:CreateToggle(pageMovement, dict.FLY, "Fly")
        self:CreateSlider(pageMovement, dict.FLY_SPEED, 50, 350, "FlySpeed")
        self:CreateToggle(pageMovement, dict.SPEED, "Speed")
        self:CreateSlider(pageMovement, dict.SPEED_VAL, 16, 100, "SpeedValue")
        self:CreateToggle(pageMovement, dict.NOCLIP, "Noclip")
        self:CreateToggle(pageMovement, dict.INF_JUMP, "InfJump")
        
        -- Discord Server & Language Switcher
        local btnDiscord = Instance.new("TextButton")
        btnDiscord.Size = UDim2.new(1, -10, 0, 44)
        btnDiscord.BackgroundColor3 = Color3.fromRGB(15, 22, 38)
        btnDiscord.Text = "🌐  LẤY KEY DISCORD"
        btnDiscord.Font = Enum.Font.GothamBlack
        btnDiscord.TextSize = 13
        btnDiscord.TextColor3 = Color3.fromRGB(0, 240, 255)
        btnDiscord.ZIndex = 3
        btnDiscord.Parent = pageKey
        Instance.new("UICorner", btnDiscord).CornerRadius = UDim.new(0, 12)

        local btnDiscordStroke = Instance.new("UIStroke")
        btnDiscordStroke.Thickness = 1.5
        btnDiscordStroke.Color = Color3.fromRGB(0, 240, 255)
        btnDiscordStroke.Transparency = 0.5
        btnDiscordStroke.Parent = btnDiscord

        btnDiscord.MouseButton1Click:Connect(function()
            Engine.Modules.AudioFX:Click()
            if setclipboard or toclipboard then
                (setclipboard or toclipboard)(Engine.Modules.KeySystem.KeyURL)
                Engine.Modules.NotificationManager:Notify("Discord Key Server", "✓ Đã sao chép Link Discord: https://discord.gg/6Nfc7jGKP", 3)
            else
                Engine.Modules.NotificationManager:Notify("Discord Key Server", "Link: https://discord.gg/6Nfc7jGKP", 4)
            end
        end)

        local langBtn = Instance.new("TextButton")
        langBtn.Size = UDim2.new(1, -10, 0, 38)
        langBtn.BackgroundColor3 = Color3.fromRGB(24, 32, 52)
        langBtn.Text = "🌐 " .. dict.LANG_SWITCH
        langBtn.Font = Enum.Font.GothamBlack
        langBtn.TextSize = 11
        langBtn.TextColor3 = Color3.fromRGB(0, 240, 255)
        langBtn.ZIndex = 3
        langBtn.Parent = pageKey
        Instance.new("UICorner", langBtn).CornerRadius = UDim.new(0, 10)

        langBtn.MouseButton1Click:Connect(function()
            Engine.Modules.AudioFX:Click()
            local newLang = (Engine.Modules.ConfigManager.Settings.Language == "VN") and "EN" or "VN"
            Engine.Modules.ConfigManager.Settings.Language = newLang
            Engine.Modules.ConfigManager:Save()
            
            -- Reload UI
            local coreGui = LocalPlayer:WaitForChild("PlayerGui")
            local ui = coreGui:FindFirstChild("RBZoo_V9_UI_LiquidGlass")
            if ui then ui:Destroy() end
            table.clear(self.ChromaObjects)
            self:Init()
            Engine.Modules.NotificationManager:Notify("Language / Ngôn Ngữ", "Language set to: " .. newLang, 2)
        end)

        local creatorCard = Instance.new("Frame")
        creatorCard.Size = UDim2.new(1, -10, 0, 100)
        creatorCard.BackgroundColor3 = Color3.fromRGB(18, 24, 40)
        creatorCard.BackgroundTransparency = 0.3
        creatorCard.ZIndex = 3
        creatorCard.Parent = pageKey
        Instance.new("UICorner", creatorCard).CornerRadius = UDim.new(0, 12)

        local cAvatar = Instance.new("ImageLabel")
        cAvatar.Size = UDim2.new(0, 54, 0, 54)
        cAvatar.Position = UDim2.new(0, 12, 0, 12)
        cAvatar.BackgroundColor3 = Color3.fromRGB(25, 32, 50)
        cAvatar.Image = "rbxassetid://0"
        cAvatar.ZIndex = 4
        cAvatar.Parent = creatorCard
        Instance.new("UICorner", cAvatar).CornerRadius = UDim.new(1, 0)

        task.spawn(function()
            while cAvatar and cAvatar.Parent do
                if Engine.State.LogoAssetId ~= "" then
                    cAvatar.Image = Engine.State.LogoAssetId
                    break
                elseif Engine.State.AvatarUrl ~= "" then
                    cAvatar.Image = Engine.State.AvatarUrl
                    break
                end
                task.wait(0.2)
            end
        end)

        local cTitle = Instance.new("TextLabel")
        cTitle.Size = UDim2.new(1, -80, 0, 22)
        cTitle.Position = UDim2.new(0, 75, 0, 10)
        cTitle.BackgroundTransparency = 1
        cTitle.Text = "👑 " .. Engine.Author
        cTitle.Font = Enum.Font.GothamBlack
        cTitle.TextSize = 14
        cTitle.TextColor3 = Color3.fromRGB(0, 240, 255)
        cTitle.TextXAlignment = Enum.TextXAlignment.Left
        cTitle.ZIndex = 4
        cTitle.Parent = creatorCard

        local cSub = Instance.new("TextLabel")
        cSub.Size = UDim2.new(1, -80, 0, 18)
        cSub.Position = UDim2.new(0, 75, 0, 34)
        cSub.BackgroundTransparency = 1
        cSub.Text = "Roblox Username: @" .. Engine.AuthorRoblox
        cSub.Font = Enum.Font.GothamBold
        cSub.TextSize = 11
        cSub.TextColor3 = Color3.fromRGB(255, 0, 140)
        cSub.TextXAlignment = Enum.TextXAlignment.Left
        cSub.ZIndex = 4
        cSub.Parent = creatorCard

        local cDesc = Instance.new("TextLabel")
        cDesc.Size = UDim2.new(1, -80, 0, 18)
        cDesc.Position = UDim2.new(0, 75, 0, 56)
        cDesc.BackgroundTransparency = 1
        cDesc.Text = "Cyberpunk VIP Edition 2026 • Exclusive Script"
        cDesc.Font = Enum.Font.GothamMedium
        cDesc.TextSize = 10
        cDesc.TextColor3 = Color3.fromRGB(180, 195, 215)
        cDesc.TextXAlignment = Enum.TextXAlignment.Left
        cDesc.ZIndex = 4
        cDesc.Parent = creatorCard

        local keyCard = Instance.new("Frame")
        keyCard.Size = UDim2.new(1, -10, 0, 145)
        keyCard.BackgroundColor3 = Color3.fromRGB(18, 24, 40)
        keyCard.BackgroundTransparency = 0.3
        keyCard.ZIndex = 3
        keyCard.Parent = pageKey
        Instance.new("UICorner", keyCard).CornerRadius = UDim.new(0, 12)
        
        local keyTitle = Instance.new("TextLabel")
        keyTitle.Size = UDim2.new(1, -20, 0, 24)
        keyTitle.Position = UDim2.new(0, 12, 0, 8)
        keyTitle.BackgroundTransparency = 1
        keyTitle.Text = "🔑 THÔNG TIN KEY SỬ DỤNG V10.5"
        keyTitle.Font = Enum.Font.GothamBlack
        keyTitle.TextSize = 13
        keyTitle.TextColor3 = Color3.fromRGB(0, 210, 255)
        keyTitle.TextXAlignment = Enum.TextXAlignment.Left
        keyTitle.ZIndex = 4
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
        keyValLabel.ZIndex = 4
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
        keyTimeLabel.ZIndex = 4
        keyTimeLabel.Parent = keyCard
        
        Engine.Services.RunService.RenderStepped:Connect(function()
            if pageKey.Visible then
                keyTimeLabel.Text = "Thời gian còn lại: " .. Engine.Modules.KeySystem:GetRemainingTime()
            end
        end)
        
        local btnLogout = Instance.new("TextButton")
        btnLogout.Size = UDim2.new(1, -24, 0, 38)
        btnLogout.Position = UDim2.new(0, 12, 0, 94)
        btnLogout.BackgroundColor3 = Color3.fromRGB(220, 50, 60)
        btnLogout.Text = dict.LOGOUT
        btnLogout.Font = Enum.Font.GothamBlack
        btnLogout.TextSize = 11
        btnLogout.TextColor3 = Color3.fromRGB(255, 255, 255)
        btnLogout.ZIndex = 4
        btnLogout.Parent = keyCard
        Instance.new("UICorner", btnLogout).CornerRadius = UDim.new(0, 8)
        
        btnLogout.MouseButton1Click:Connect(function()
            Engine.Modules.AudioFX:Click()
            Engine.Modules.KeySystem:Logout()
        end)
    end,
    
    CreateToggle = function(self, parent, text, configKey, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -10, 0, 44)
        frame.BackgroundColor3 = Color3.fromRGB(18, 24, 40)
        frame.BackgroundTransparency = 0.3
        frame.ZIndex = 3
        frame.Parent = parent
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -65, 1, 0)
        label.Position = UDim2.new(0, 12, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Color3.fromRGB(230, 240, 255)
        label.Font = Enum.Font.GothamBold
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.ZIndex = 4
        label.Parent = frame
        
        local toggleBtn = Instance.new("TextButton")
        toggleBtn.Name = Engine.Modules.ConfigManager.Settings[configKey] and "ToggledBG" or "OffBG"
        toggleBtn.Size = UDim2.new(0, 44, 0, 22)
        toggleBtn.Position = UDim2.new(1, -54, 0.5, -11)
        toggleBtn.BackgroundColor3 = Engine.Modules.ConfigManager.Settings[configKey] and Color3.fromRGB(0, 240, 255) or Color3.fromRGB(45, 52, 68)
        toggleBtn.BackgroundTransparency = Engine.Modules.ConfigManager.Settings[configKey] and 0.2 or 0.4
        toggleBtn.Text = ""
        toggleBtn.ZIndex = 4
        toggleBtn.Parent = frame
        Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)
        
        local circle = Instance.new("Frame")
        circle.Size = UDim2.new(0, 18, 0, 18)
        circle.Position = Engine.Modules.ConfigManager.Settings[configKey] and UDim2.new(1, -20, 0, 2) or UDim2.new(0, 2, 0, 2)
        circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        circle.ZIndex = 5
        circle.Parent = toggleBtn
        Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)
        
        if Engine.Modules.ConfigManager.Settings[configKey] then table.insert(self.ChromaObjects, toggleBtn) end
        
        local function updateVisual(newState)
            toggleBtn.Name = newState and "ToggledBG" or "OffBG"
            local goalPos = newState and UDim2.new(1, -20, 0, 2) or UDim2.new(0, 2, 0, 2)
            local goalColor = newState and Color3.fromRGB(0, 240, 255) or Color3.fromRGB(45, 52, 68)
            
            Engine.Services.TweenService:Create(circle, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = goalPos}):Play()
            Engine.Services.TweenService:Create(toggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = goalColor}):Play()
            
            if newState then table.insert(self.ChromaObjects, toggleBtn) else
                for i, obj in ipairs(self.ChromaObjects) do if obj == toggleBtn then table.remove(self.ChromaObjects, i) break end end
            end
        end

        self.Toggles[configKey] = updateVisual

        toggleBtn.MouseButton1Click:Connect(function()
            Engine.Modules.AudioFX:Toggle()
            local newState = not Engine.Modules.ConfigManager.Settings[configKey]
            Engine.Modules.ConfigManager.Settings[configKey] = newState
            Engine.Modules.ConfigManager:Save()
            updateVisual(newState)
            if callback then callback(newState) end
        end)
    end,
    
    CreateSlider = function(self, parent, text, min, max, configKey)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -10, 0, 60)
        frame.BackgroundColor3 = Color3.fromRGB(18, 24, 40)
        frame.BackgroundTransparency = 0.3
        frame.ZIndex = 3
        frame.Parent = parent
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)
        
        local default = Engine.Modules.ConfigManager.Settings[configKey]
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -12, 0, 24)
        label.Position = UDim2.new(0, 12, 0, 4)
        label.BackgroundTransparency = 1
        label.Text = text .. ": " .. string.format("%.2f", default)
        label.TextColor3 = Color3.fromRGB(230, 240, 255)
        label.Font = Enum.Font.GothamBold
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.ZIndex = 4
        label.Parent = frame
        
        local bar = Instance.new("Frame")
        bar.Size = UDim2.new(1, -24, 0, 8)
        bar.Position = UDim2.new(0, 12, 0, 38)
        bar.BackgroundColor3 = Color3.fromRGB(35, 45, 68)
        bar.BackgroundTransparency = 0.2
        bar.ZIndex = 4
        bar.Parent = frame
        Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)
        
        local fill = Instance.new("Frame")
        fill.Name = "ToggledBG"
        fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        fill.BackgroundColor3 = Color3.fromRGB(0, 240, 255)
        fill.ZIndex = 4
        fill.Parent = bar
        Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
        table.insert(self.ChromaObjects, fill)
        
        local knob = Instance.new("TextButton")
        knob.Size = UDim2.new(0, 16, 0, 16)
        knob.Position = UDim2.new((default - min) / (max - min), -8, 0.5, -8)
        knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        knob.Text = ""
        knob.ZIndex = 5
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
                knob.Position = UDim2.new(percent, -8, 0.5, -8)
                label.Text = text .. ": " .. string.format("%.2f", val)
                Engine.Modules.ConfigManager.Settings[configKey] = val
            end
        end)
    end
}

-- ==========================================
-- [16] BOOTSTRAPPER V10.5 SUPER VIP
-- ==========================================
Engine.BootAfterKey = function(self)
    self.Modules.NotificationManager:Init()
    self.Modules.ESPEngine:Init()
    self.Modules.MiniRadar:Init()
    self.Modules.HunterHUD:Init()
    self.Modules.UIController:Init()
    self.Modules.PerformanceBooster:StartGC()
    self.Status = "Running"
    
    self.Modules.NotificationManager:Notify("RB ZOO CYBERPUNK VIP V10.5", "Khởi động Super VIP thành công! Sáng tạo bởi: " .. Engine.Author, 5)
    
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

-- Khởi chạy Cyberpunk VIP Engine V10.5
Engine:Boot()

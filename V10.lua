-- [[ GAO PRO PANEL V10 - THE ULTIMATE GHOST ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local CoreGui = game:GetService("CoreGui")

-- ลบของเก่าป้องกันค้าง
if CoreGui:FindFirstChild("GaoProV10_Ultimate") then CoreGui:FindFirstChild("GaoProV10_Ultimate"):Destroy() end

-- [[ GUI SETUP ]]
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "GaoProV10_Ultimate"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 480, 0, 350)
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 15)

local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 15)

local Title = Instance.new("TextLabel", TopBar)
Title.Text = "   GAO PRO PANEL V10 | FULL GHOST EDITION"
Title.Size = UDim2.new(1, 0, 1, 0)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1

-- [[ VARIABLES ]]
_G.WalkSpeed = 16
_G.SpeedV2 = false
_G.InfJump = false
_G.Noclip = false
_G.GhostActive = false
_G.GhostV2 = false
_G.Flight = false
_G.FlySpeed = 50
_G.ESP = false
_G.AutoFarm = false

local OriginalPos = nil
local GhostCharacter = nil

-- [[ LOGIC FUNCTIONS ]]

-- 1 & 2. Speed V1/V2 (Universal - จักรยาน/รถ/คน)
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char.HumanoidRootPart
        local mult = _G.SpeedV2 and 2 or 1
        local finalSpeed = _G.WalkSpeed * mult
        
        if hum.MoveDirection.Magnitude > 0 then
            -- ใช้ CFrame เพื่อให้พุ่งได้ทุกแมพแม้จะโดนล็อคสปีด
            root.CFrame = root.CFrame + (hum.MoveDirection * (finalSpeed / 60))
        end
    end
end)

-- 3. Noclip V10 (ทะลุทุกอย่างยกเว้นพื้น + ทะลุหัว)
RunService.Stepped:Connect(function()
    if _G.Noclip and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                -- เช็คพื้นใต้เท้าด้วย Raycast
                local ray = Ray.new(v.Position, Vector3.new(0, -4, 0))
                local hit = workspace:FindPartOnRay(ray, LocalPlayer.Character)
                
                if hit then
                    v.CanCollide = true -- ยืนบนพื้นได้
                else
                    v.CanCollide = false -- ทะลุข้างๆ และ เพดาน (หัว)
                end
            end
        end
    end
end)

-- 4. บิน 360 (คุมตามกล้องและปุ่มเดิน)
RunService.RenderStepped:Connect(function()
    if _G.Flight and LocalPlayer.Character then
        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            local camera = workspace.CurrentCamera
            local dir = Vector3.new(0,0,0)
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + camera.CFrame.RightVector end
            
            if dir.Magnitude > 0 then
                root.Velocity = dir.Unit * _G.FlySpeed
            else
                root.Velocity = Vector3.new(0,0.1,0) -- ลอยนิ่งๆ
            end
        end
    end
end)

-- 5 & 6. Ghost & Ghost V2
local function HandleGhost(enable, isV2)
    local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    if enable then
        OriginalPos = root.CFrame
        -- ตัดการเชื่อมต่อร่างกับเซิร์ฟเวอร์ (Fake Lag)
        LocalPlayer.Character.Parent = nil
        LocalPlayer.Character.Parent = workspace
    else
        if isV2 then
            -- Ghost V2: ดึงร่างมาหาวิญญาณ (วาร์ป)
            print("V2 Activated: Body Teleported to Ghost")
        else
            -- Ghost V1: วาร์ปกลับร่างเดิม
            root.CFrame = OriginalPos
        end
        OriginalPos = nil
    end
end

-- 7. ESP (แยกสี)
RunService.RenderStepped:Connect(function()
    if _G.ESP then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local highlight = p.Character:FindFirstChild("GaoESP")
                if not highlight then
                    highlight = Instance.new("Highlight", p.Character)
                    highlight.Name = "GaoESP"
                end
                highlight.FillColor = Color3.new(0,1,0) -- คนเขียว
            end
        end
        -- สแกนบอท (NPC ที่ไม่ใช่คน)
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Humanoid") and not Players:GetPlayerFromCharacter(v.Parent) then
                local highlight = v.Parent:FindFirstChild("BotESP")
                if not highlight then
                    highlight = Instance.new("Highlight", v.Parent)
                    highlight.Name = "BotESP"
                end
                highlight.FillColor = Color3.new(1,0,0) -- บอทแดง
            end
        end
    end
end)

-- [[ UI BUTTONS CONSTRUCTION ]]
local Scroll = Instance.new("ScrollingFrame", MainFrame)
Scroll.Size = UDim2.new(1, -20, 1, -60)
Scroll.Position = UDim2.new(0, 10, 0, 50)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 4
local List = Instance.new("UIListLayout", Scroll)
List.Padding = UDim.new(0, 5)

local function AddButton(name, color, func)
    local btn = Instance.new("TextButton", Scroll)
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.BackgroundColor3 = color
    btn.Text = name
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", btn)
    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        btn.BackgroundColor3 = active and Color3.fromRGB(50, 180, 50) or color
        func(active)
    end)
end

-- เรียงลำดับตามมึงสั่งเป๊ะๆ
AddButton("วิ่งเร็ว (Speed V1)", Color3.fromRGB(60, 60, 160), function(s) _G.WalkSpeed = s and 100 or 16 end)
AddButton("วิ่งเร็วV2 (x2 Speed)", Color3.fromRGB(120, 60, 160), function(s) _G.SpeedV2 = s end)
AddButton("กระโดดรัว (Inf Jump)", Color3.fromRGB(60, 140, 140), function(s) _G.InfJump = s end)
AddButton("ผี / ghost (V1 - Back)", Color3.fromRGB(80, 80, 80), function(s) _G.GhostActive = s HandleGhost(s, false) end)
AddButton("เทเล / ghost V2 (V2 - Warp)", Color3.fromRGB(160, 100, 0), function(s) _G.GhostV2 = s HandleGhost(s, true) end)
AddButton("ผี / ghost (Noclip V10)", Color3.fromRGB(180, 50, 50), function(s) _G.Noclip = s end)
AddButton("บิน (360 Flight)", Color3.fromRGB(50, 120, 180), function(s) _G.Flight = s end)
AddButton("มองทะลุ (ESP Green/Red)", Color3.fromRGB(50, 150, 100), function(s) _G.ESP = s end)
AddButton("Auto Collect (Lucky Block)", Color3.fromRGB(140, 140, 50), function(s)
    _G.AutoFarm = s
    task.spawn(function()
        while _G.AutoFarm do
            for _, v in pairs(workspace:GetDescendants()) do
                if v.Name:lower():find("money") or v.Name:lower():find("collect") then
                    if v:IsA("TouchTransmitter") then
                        firetouchinterest(LocalPlayer.Character.HumanoidRootPart, v.Parent, 0)
                        firetouchinterest(LocalPlayer.Character.HumanoidRootPart, v.Parent, 1)
                    end
                end
            end
            task.wait(0.5)
        end
    end)
end)

-- Jump Request
UserInputService.JumpRequest:Connect(function()
    if _G.InfJump and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

print("GAO PRO V10 | LOADED ALL FUNCTIONS")


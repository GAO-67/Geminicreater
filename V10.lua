-- [[ KAO PRO PANEL V10 - ULTIMATE GHOST EDITION ]]
local CoreGui = game:GetService("CoreGui")
if CoreGui:FindFirstChild("KaoProV10") then
    CoreGui:FindFirstChild("KaoProV10"):Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KaoProV10"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- [[ UI Setup ]]
local MainFrame = Instance.new("Frame")
local LeftSideBar = Instance.new("Frame")
local RightContent = Instance.new("Frame")
local UICornerMain = Instance.new("UICorner")
local TopBar = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local OpenBtn = Instance.new("TextButton")

MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -150)
MainFrame.Size = UDim2.new(0, 450, 0, 320) -- ปรับขนาดนิดนึงให้พอดีปุ่มใหม่
MainFrame.Active = true
MainFrame.Draggable = true 
UICornerMain.CornerRadius = UDim.new(0, 15)
UICornerMain.Parent = MainFrame

TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TopBar.Size = UDim2.new(1, 0, 0, 35)
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 15)

Title.Parent = TopBar
Title.Text = "   KAO PRO PANEL V10 | GHOST MODE"
Title.Size = UDim2.new(1, 0, 1, 0)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1

local MinimizeBtn = Instance.new("TextButton", TopBar)
MinimizeBtn.Size = UDim2.new(0, 30, 0, 25)
MinimizeBtn.Position = UDim2.new(1, -40, 0, 5)
MinimizeBtn.Text = "-"
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
MinimizeBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", MinimizeBtn)

OpenBtn.Parent = ScreenGui
OpenBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
OpenBtn.Position = UDim2.new(0, 10, 0.5, 0)
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Text = "OPEN"
OpenBtn.Visible = false 
OpenBtn.Draggable = true
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)

MinimizeBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false OpenBtn.Visible = true end)
OpenBtn.MouseButton1Click:Connect(function() MainFrame.Visible = true OpenBtn.Visible = false end)

-- Navigation Setup
LeftSideBar.Parent = MainFrame
LeftSideBar.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
LeftSideBar.Position = UDim2.new(0, 0, 0, 35)
LeftSideBar.Size = UDim2.new(0, 120, 1, -35)
Instance.new("UIListLayout", LeftSideBar).Padding = UDim.new(0, 5)

RightContent.Parent = MainFrame
RightContent.Position = UDim2.new(0, 125, 0, 45)
RightContent.Size = UDim2.new(0, 315, 0, 260)
RightContent.BackgroundTransparency = 1

local Pages = {}
local function CreatePage(name)
    local P = Instance.new("ScrollingFrame", RightContent)
    P.Size = UDim2.new(1, 0, 1, 0)
    P.BackgroundTransparency = 1
    P.Visible = false
    P.ScrollBarThickness = 3
    P.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Instance.new("UIListLayout", P).Padding = UDim.new(0, 8)
    Pages[name] = P
    return P
end

local MainMenu = CreatePage("Main")
local Teleport = CreatePage("TP")
local InfoPage = CreatePage("Info")
local ESPPage = CreatePage("ESP")

local function Tab(txt, target)
    local B = Instance.new("TextButton", LeftSideBar)
    B.Size = UDim2.new(0, 110, 0, 35)
    B.Text = txt
    B.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    B.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", B)
    B.MouseButton1Click:Connect(function() for i, v in pairs(Pages) do v.Visible = (i == target) end end)
end

Tab("1.เมนูหลัก", "Main")
Tab("2.เทเลพอร์ต", "TP")
Tab("3.ผู้ใช้(info)", "Info")
Tab("4.มองทะลุ", "ESP")

local function AddToggle(parent, text, func)
    local T = Instance.new("TextButton", parent)
    T.Size = UDim2.new(0, 280, 0, 35)
    T.Text = text .. " : OFF"
    T.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
    T.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", T)
    local state = false
    T.MouseButton1Click:Connect(function()
        state = not state
        T.Text = text .. (state and " : ON" or " : OFF")
        T.BackgroundColor3 = state and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(150, 50, 50)
        func(state)
    end)
end

-- [[ 1. เมนูหลัก & ฟังชั่นใหม่ ]]
_G.Speed = 16
_G.SpeedV2 = false
AddToggle(MainMenu, "วิ่งเร็ว", function(s) _G.Speed = s and 100 or 16 end)
AddToggle(MainMenu, "วิ่งเร็วV2 (x2)", function(s) _G.SpeedV2 = s end)

local infJump = false
AddToggle(MainMenu, "กระโดดไม่จำกัด", function(s) infJump = s end)

-- ฟังชั่น Ghost V1/V2 (ผีถอดร่าง)
local ghostActive = false
local ghostV2 = false
local originalPos = nil
AddToggle(MainMenu, "ผี/ghost", function(s) 
    ghostActive = s 
    local root = LocalPlayer.Character.HumanoidRootPart
    if ghostActive then
        originalPos = root.CFrame
        LocalPlayer.Character.Parent = nil
        LocalPlayer.Character.Parent = workspace
    else
        if not ghostV2 then root.CFrame = originalPos end
        originalPos = nil
    end
end)
AddToggle(MainMenu, "เทเล/ghost V2", function(s) ghostV2 = s end)

-- Noclip V10 (ทะลุหัว/เพดาน)
local noclip = false
AddToggle(MainMenu, "เดินทะลุ/ghost (V10)", function(s) noclip = s end)

-- บิน 360 (คุมอิสระ)
local flying = false
AddToggle(MainMenu, "บิน (360)", function(s)
    flying = s
    if flying then
        local bv = Instance.new("BodyVelocity", LocalPlayer.Character.HumanoidRootPart)
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        task.spawn(function()
            while flying do
                local cam = workspace.CurrentCamera
                local dir = Vector3.new(0,0,0)
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
                bv.Velocity = dir * (_G.Speed * 1.5)
                task.wait()
            end
            bv:Destroy()
        end)
    end
end)

AddToggle(MainMenu, "สั่งตายบอท(2ม.)", function(s)
    _G.KillBot = s
    task.spawn(function()
        while _G.KillBot do
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("Humanoid") and not Players:GetPlayerFromCharacter(v.Parent) then
                    local root = v.Parent:FindFirstChild("HumanoidRootPart")
                    if root and (root.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 7 then
                        v.Health = 0
                    end
                end
            end
            task.wait(0.2)
        end
    end)
end)

-- [[ Loops Logic ]]
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local root = char.HumanoidRootPart
        local hum = char:FindFirstChildOfClass("Humanoid")
        local mult = _G.SpeedV2 and 2 or 1
        
        -- วิ่งเร็ว Universal (ใช้ได้ทุกแมพ)
        if hum.MoveDirection.Magnitude > 0 then
            root.CFrame = root.CFrame + (hum.MoveDirection * ((_G.Speed * mult) / 60))
        end
        
        -- Noclip V10 (ทะลุทุกอย่างยกเว้นพื้น)
        if noclip then
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then
                    local ray = Ray.new(v.Position, Vector3.new(0, -4, 0))
                    local hit = workspace:FindPartOnRay(ray, char)
                    v.CanCollide = hit and true or false
                end
            end
        end
    end
end)

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if infJump and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState("Jumping")
    end
end)

-- [[ ESP & TP (ของเดิม 100%) ]]
RunService.RenderStepped:Connect(function()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Humanoid") and v.Parent ~= LocalPlayer.Character then
            local char = v.Parent
            local isPlayer = Players:GetPlayerFromCharacter(char)
            local espColor = isPlayer and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
            local highlight = char:FindFirstChild("GaoHighlight")
            if _G.Chams then
                if not highlight then highlight = Instance.new("Highlight", char); highlight.Name = "GaoHighlight" end
                highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                highlight.FillColor = espColor
            elseif highlight then highlight:Destroy() end
            local espRoot = char:FindFirstChild("GaoESP")
            if (_G.Box or _G.Line) then
                if not espRoot then
                    espRoot = Instance.new("Folder", char); espRoot.Name = "GaoESP"
                    local box = Instance.new("SelectionBox", espRoot); box.Name = "B"; box.Adornee = char
                    box.Color3 = espColor
                    local a0 = Instance.new("Attachment", LocalPlayer.Character.HumanoidRootPart)
                    local a1 = Instance.new("Attachment", char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Head"))
                    local line = Instance.new("Beam", espRoot); line.Name = "L"
                    line.Attachment0 = a0; line.Attachment1 = a1; line.Width0 = 0.1; line.Width1 = 0.1
                    line.Color = ColorSequence.new(espColor); line.FaceCamera = true
                end
                espRoot.B.Visible = _G.Box; espRoot.L.Enabled = _G.Line
            elseif espRoot then espRoot:Destroy() end
        end
    end
end)

local function UpdateList()
    for _, v in pairs(Teleport:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local B = Instance.new("TextButton", Teleport)
            B.Size = UDim2.new(0, 280, 0, 30); B.Text = "ไปหา: "..p.Name; B.BackgroundColor3 = Color3.fromRGB(50,50,50); B.TextColor3 = Color3.new(1,1,1)
            Instance.new("UICorner", B)
            B.MouseButton1Click:Connect(function() LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame end)
        end
    end
end
UpdateList(); Players.PlayerAdded:Connect(UpdateList); Players.PlayerRemoving:Connect(UpdateList)

-- Info
local function AddInfo(t, c)
    local L = Instance.new("TextLabel", InfoPage)
    L.Size = UDim2.new(1, 0, 0, 45); L.RichText = true; L.Text = t; L.TextSize = 20; L.TextColor3 = c or Color3.new(1,1,1); L.BackgroundTransparency = 1
end
AddInfo('Status: <font color="rgb(0,255,0)">ONLINE V10</font>')
AddInfo('ผู้ใช้ : ไอเก้า , ไอโจ้')
AddInfo('GHOST EDITION ACTIVATED', Color3.fromRGB(255, 200, 50))

-- ESP Buttons
AddToggle(ESPPage, "กล่อง (Box)", function(s) _G.Box = s end)
AddToggle(ESPPage, "เส้น (Line)", function(s) _G.Line = s end)
AddToggle(ESPPage, "สีทั้งตัว (Chams)", function(s) _G.Chams = s end)

Pages.Main.Visible = true

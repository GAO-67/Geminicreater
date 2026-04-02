-- [[ PRO PANEL V5 - ULTIMATE EDITION ]]
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local LeftSideBar = Instance.new("Frame")
local RightContent = Instance.new("Frame")
local UICornerMain = Instance.new("UICorner")
local TopBar = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local OpenBtn = Instance.new("TextButton")

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Setup UI (โครงสร้างเดิม 100%)
ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "GaoProV5"
ScreenGui.ResetOnSpawn = false

MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -150)
MainFrame.Size = UDim2.new(0, 450, 0, 300)
MainFrame.Active = true
MainFrame.Draggable = true 
UICornerMain.CornerRadius = UDim.new(0, 15)
UICornerMain.Parent = MainFrame

TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TopBar.Size = UDim2.new(1, 0, 0, 35)
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 15)

Title.Parent = TopBar
Title.Text = "   GAO PRO PANEL V5"
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

-- Navigation System
LeftSideBar.Parent = MainFrame
LeftSideBar.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
LeftSideBar.Position = UDim2.new(0, 0, 0, 35)
LeftSideBar.Size = UDim2.new(0, 120, 1, -35)
Instance.new("UIListLayout", LeftSideBar).Padding = UDim.new(0, 5)

RightContent.Parent = MainFrame
RightContent.Position = UDim2.new(0, 125, 0, 45)
RightContent.Size = UDim2.new(0, 315, 0, 245)
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
    B.MouseButton1Click:Connect(function() 
        for i, v in pairs(Pages) do v.Visible = (i == target) end
    end)
end

Tab("1.เมนูหลัก", "Main")
Tab("2.เทเลพอร์ต", "TP")
Tab("3.ผู้ใช้(info)", "Info")
Tab("4.มองทะลุ", "ESP")

-- [[ ฟังก์ชันเสริม ]]
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

-- [[ 1. เมนูหลัก - UPDATE ]]

-- เดินทะลุ & กันตก (ใต้แมพเท่านั้น)
local noclip = false
local antiFall = nil
RunService.Stepped:Connect(function()
    if noclip and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
        if not antiFall then
            antiFall = Instance.new("Part", workspace)
            antiFall.Size = Vector3.new(10000, 1, 10000)
            antiFall.Position = Vector3.new(0, -50, 0) -- ไว้ใต้พื้นแมพ
            antiFall.Anchored = true
            antiFall.Transparency = 0.7
            antiFall.Color = Color3.new(1, 0, 0)
        end
    else
        if antiFall then antiFall:Destroy() antiFall = nil end
    end
end)
AddToggle(MainMenu, "เดินทะลุ", function(s) noclip = s end)

-- เดินทะลุ/Ghost (ทิ้งร่าง)
local ghostActive = false
local ghostPos = nil
AddToggle(MainMenu, "เดินทะลุ/ghost", function(s)
    ghostActive = s
    local char = LocalPlayer.Character
    if ghostActive then
        ghostPos = char.HumanoidRootPart.CFrame
        -- ตัดการเชื่อมต่อตำแหน่งกับเซิร์ฟเวอร์
        char.Archivable = true
        local clone = char:Clone()
        clone.Parent = workspace
        clone.Name = "GhostBody"
        for _, v in pairs(char:GetChildren()) do
            if v:IsA("BasePart") then v.Transparency = 0.5 end
        end
    else
        if ghostPos then
            char.HumanoidRootPart.CFrame = ghostPos
            if workspace:FindFirstChild("GhostBody") then workspace.GhostBody:Destroy() end
            for _, v in pairs(char:GetChildren()) do
                if v:IsA("BasePart") then v.Transparency = 0 end
            end
        end
    end
end)

-- บิน (360)
local flying = false
AddToggle(MainMenu, "บิน", function(s)
    flying = s
    if flying then
        local bv = Instance.new("BodyVelocity", LocalPlayer.Character.HumanoidRootPart)
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        while flying do
            bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * (LocalPlayer.Character.Humanoid.WalkSpeed * 1.5)
            task.wait()
        end
        bv:Destroy()
    end
end)

-- ฆ่าบอท (2ม.)
AddToggle(MainMenu, "สั่งตายบอท(2ม.)", function(s)
    _G.KillBot = s
    while _G.KillBot do
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Humanoid") and not Players:GetPlayerFromCharacter(v.Parent) then
                local root = v.Parent:FindFirstChild("HumanoidRootPart")
                if root and (root.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 7 then
                    v.Health = 0
                end
            end
        end
        task.wait(0.1)
    end
end)

-- ก๊อปชุด (ApplyDescription)
local CopyFrame = Instance.new("Frame", MainMenu)
CopyFrame.Size = UDim2.new(0, 280, 0, 40)
CopyFrame.BackgroundTransparency = 1
local NameBox = Instance.new("TextBox", CopyFrame)
NameBox.Size = UDim2.new(0, 180, 0, 35)
NameBox.PlaceholderText = "Username (ไอดีจริง)"
NameBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
NameBox.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", NameBox)
local CopyBtn = Instance.new("TextButton", CopyFrame)
CopyBtn.Position = UDim2.new(0, 190, 0, 0)
CopyBtn.Size = UDim2.new(0, 90, 0, 35)
CopyBtn.Text = "COPY"
CopyBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 200)
CopyBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", CopyBtn)

CopyBtn.MouseButton1Click:Connect(function()
    local target = Players:FindFirstChild(NameBox.Text)
    if target then
        local desc = Players:GetHumanoidDescriptionFromUserId(target.UserId)
        LocalPlayer.Character.Humanoid:ApplyDescription(desc)
    end
end)

-- [[ 2. เทเลพอร์ต (Scrollable) ]]
local function UpdateList()
    for _, v in pairs(Teleport:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local B = Instance.new("TextButton", Teleport)
            B.Size = UDim2.new(0, 280, 0, 30)
            B.Text = "ไปหา: " .. p.Name
            B.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            B.TextColor3 = Color3.new(1,1,1)
            Instance.new("UICorner", B)
            B.MouseButton1Click:Connect(function() 
                LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame 
            end)
        end
    end
end
UpdateList()

-- [[ 3. ผู้ใช้ (Info - Bigger) ]]
local function AddInfo(txt, color)
    local L = Instance.new("TextLabel", InfoPage)
    L.Size = UDim2.new(1, 0, 0, 45)
    L.RichText = true
    L.Text = txt
    L.TextSize = 20
    L.TextColor3 = color or Color3.new(1,1,1)
    L.BackgroundTransparency = 1
end
AddInfo('Status: <font color="rgb(0,255,0)">ONLINE V5</font>')
AddInfo('ผู้ใช้ : ไอเก้า , ไอโจ้')
AddInfo(' ')
AddInfo('FUCK YOU BITCH', Color3.fromRGB(255, 50, 50))

-- [[ 4. มองทะลุ (ESP/Box/Line) ]]
AddToggle(ESPPage, "กล่อง (Box)", function(s) _G.Box = s end)
AddToggle(ESPPage, "เส้น (Line)", function(s) _G.Line = s end)
AddToggle(ESPPage, "สีทั้งตัว (Chams)", function(s) _G.Chams = s end)

RunService.RenderStepped:Connect(function()
    for _, p in pairs(workspace:GetDescendants()) do
        if p:IsA("Humanoid") and p.Parent ~= LocalPlayer.Character then
            local char = p.Parent
            -- Chams Always on Top
            local highlight = char:FindFirstChild("GaoHighlight")
            if _G.Chams then
                if not highlight then highlight = Instance.new("Highlight", char) highlight.Name = "GaoHighlight" end
                highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                highlight.FillColor = Players:GetPlayerFromCharacter(char) and Color3.new(0,1,0) or Color3.new(1,0,0)
            elseif highlight then highlight:Destroy() end
            
            -- Box & Line Logic
            local espRoot = char:FindFirstChild("GaoESP")
            if (_G.Box or _G.Line) then
                if not espRoot then
                    espRoot = Instance.new("Folder", char); espRoot.Name = "GaoESP"
                    local box = Instance.new("SelectionBox", espRoot); box.Name = "B"; box.Adornee = char
                    box.Color3 = Players:GetPlayerFromCharacter(char) and Color3.new(0,1,0) or Color3.new(1,0,0)
                    local line = Instance.new("Beam", espRoot); line.Name = "L"
                    local a0 = Instance.new("Attachment", LocalPlayer.Character.HumanoidRootPart)
                    local a1 = Instance.new("Attachment", char.HumanoidRootPart)
                    line.Attachment0 = a0; line.Attachment1 = a1; line.Width0 = 0.1; line.Width1 = 0.1
                    line.Color = ColorSequence.new(box.Color3)
                end
                espRoot.B.Visible = _G.Box
                espRoot.L.Enabled = _G.Line
            elseif espRoot then espRoot:Destroy() end
        end
    end
end)

ShowPage("Main")


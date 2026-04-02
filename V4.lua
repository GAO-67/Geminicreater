-- [[ PRO PANEL V4 - COMPLETE EDITION ]]
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
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Setup
ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "GaoProV4"
ScreenGui.ResetOnSpawn = false

-- [[ 1. Main Frame (Structure 100%) ]]
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -150)
MainFrame.Size = UDim2.new(0, 450, 0, 300)
MainFrame.Active = true
MainFrame.Draggable = true 
UICornerMain.CornerRadius = UDim.new(0, 15)
UICornerMain.Parent = MainFrame

-- Top Bar & Minimize
TopBar.Name = "TopBar"
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TopBar.Size = UDim2.new(1, 0, 0, 35)
local TopCorner = Instance.new("UICorner", TopBar)
TopCorner.CornerRadius = UDim.new(0, 15)

Title.Parent = TopBar
Title.Text = "   GAO PRO PANEL V4"
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
Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0, 5)

-- Open Button
OpenBtn.Name = "OpenBtn"
OpenBtn.Parent = ScreenGui
OpenBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
OpenBtn.Position = UDim2.new(0, 10, 0.5, 0)
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Text = "OPEN"
OpenBtn.TextColor3 = Color3.new(1, 1, 1)
OpenBtn.Visible = false 
OpenBtn.Draggable = true
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)

MinimizeBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false OpenBtn.Visible = true end)
OpenBtn.MouseButton1Click:Connect(function() MainFrame.Visible = true OpenBtn.Visible = false end)

-- [[ 2. SideBar & Navigation ]]
LeftSideBar.Name = "SideBar"
LeftSideBar.Parent = MainFrame
LeftSideBar.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
LeftSideBar.Position = UDim2.new(0, 0, 0, 35)
LeftSideBar.Size = UDim2.new(0, 120, 1, -35)
Instance.new("UIListLayout", LeftSideBar).Padding = UDim.new(0, 5)

RightContent.Name = "Content"
RightContent.Parent = MainFrame
RightContent.Position = UDim2.new(0, 125, 0, 45)
RightContent.Size = UDim2.new(0, 315, 0, 245)
RightContent.BackgroundTransparency = 1

local Pages = {}
local function CreatePage(name)
    local P = Instance.new("ScrollingFrame", RightContent)
    P.Name = name
    P.Size = UDim2.new(1, 0, 1, 0)
    P.BackgroundTransparency = 1
    P.Visible = false
    P.ScrollBarThickness = 3
    P.CanvasSize = UDim2.new(0, 0, 0, 0)
    P.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Instance.new("UIListLayout", P).Padding = UDim.new(0, 8)
    Pages[name] = P
    return P
end

local MainMenu = CreatePage("Main")
local Teleport = CreatePage("TP")
local InfoPage = CreatePage("Info")
local ESPPage = CreatePage("ESP")

local function ShowPage(name)
    for i, v in pairs(Pages) do v.Visible = (i == name) end
end

local function Tab(txt, target)
    local B = Instance.new("TextButton", LeftSideBar)
    B.Size = UDim2.new(0, 110, 0, 35)
    B.Text = txt
    B.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    B.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", B).CornerRadius = UDim.new(0, 8)
    B.MouseButton1Click:Connect(function() ShowPage(target) end)
end

Tab("1.เมนูหลัก", "Main")
Tab("2.เทเลพอร์ต", "TP")
Tab("3.ผู้ใช้(info)", "Info")
Tab("4.มองทะลุ", "ESP")

-- [[ 3. ฟังก์ชันหน้า เมนูหลัก ]]
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

-- เดินทะลุ (ไม่จมพื้น + กันตกแมพ)
local noclip = false
local antiFall = nil
RunService.Stepped:Connect(function()
    if noclip and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then 
                v.CanCollide = false 
            end
        end
        if not antiFall then
            antiFall = Instance.new("Part", workspace)
            antiFall.Size = Vector3.new(10, 1, 10)
            antiFall.Transparency = 1
            antiFall.Anchored = true
        end
        antiFall.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, -3.5, 0)
    else
        if antiFall then antiFall:Destroy() antiFall = nil end
    end
end)
AddToggle(MainMenu, "เดินทะลุ", function(s) noclip = s end)

-- วิ่งไว
_G.Speed = 16
AddToggle(MainMenu, "วิ่งไว", function(s)
    _G.Speed = s and 100 or 16
    LocalPlayer.Character.Humanoid.WalkSpeed = _G.Speed
end)

-- บิน (360 องศา + ใช้คู่กับวิ่งเร็ว)
local flying = false
AddToggle(MainMenu, "บิน", function(s)
    flying = s
    if flying then
        local bv = Instance.new("BodyVelocity", LocalPlayer.Character.HumanoidRootPart)
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        while flying do
            bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * (_G.Speed * 1.5)
            task.wait()
        end
        bv:Destroy()
    end
end)

-- ฆ่าบอท (2 เมตร)
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

-- ก๊อปปี้ชุด (คนอื่นเห็น 100%)
local CopyFrame = Instance.new("Frame", MainMenu)
CopyFrame.Size = UDim2.new(0, 280, 0, 40)
CopyFrame.BackgroundTransparency = 1
local NameBox = Instance.new("TextBox", CopyFrame)
NameBox.Size = UDim2.new(0, 180, 0, 35)
NameBox.PlaceholderText = "ชื่อคนที่จะก๊อป"
NameBox.Text = ""
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
    if target and target.Character then
        LocalPlayer.Character:BreakJoints() -- Reset to apply clothing
        LocalPlayer.CharacterAppearanceLoaded:Wait()
        for _, v in pairs(LocalPlayer.Character:GetChildren()) do
            if v:IsA("Shirt") or v.IsA("Pants") or v:IsA("Accessory") then v:Destroy() end
        end
        for _, v in pairs(target.Character:GetChildren()) do
            if v:IsA("Shirt") or v:IsA("Pants") or v:IsA("Accessory") then
                v:Clone().Parent = LocalPlayer.Character
            end
        end
    end
end)

-- [[ 4. หน้าเทเลพอร์ต (Scrolling List) ]]
local function UpdateList()
    for _, v in pairs(Teleport:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local B = Instance.new("TextButton", Teleport)
            B.Size = UDim2.new(0, 280, 0, 30)
            B.Text = "วาร์ปไปหา: " .. p.Name
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
Players.PlayerAdded:Connect(UpdateList)
Players.PlayerRemoving:Connect(UpdateList)

-- [[ 5. หน้าผู้ใช้ (Info - Bigger Text) ]]
local function AddInfo(txt, color)
    local L = Instance.new("TextLabel", InfoPage)
    L.Size = UDim2.new(1, 0, 0, 40)
    L.RichText = true
    L.Text = txt
    L.TextSize = 18 -- ปรับให้ใหญ่ขึ้นตามสั่ง
    L.TextColor3 = color or Color3.new(1,1,1)
    L.BackgroundTransparency = 1
end
AddInfo('Status: <font color="rgb(0,255,0)">online</font>')
AddInfo('ผู้ใช้ : ไอเก้า , ไอโจ้')
AddInfo(' ')
AddInfo('FUCK YOU BITCH', Color3.fromRGB(255, 50, 50))

-- [[ 6. หน้ามองทะลุ (ESP) ]]
AddToggle(ESPPage, "กล่อง (Box)", function(s) _G.Box = s end)
AddToggle(ESPPage, "เส้น (Line)", function(s) _G.Line = s end)
AddToggle(ESPPage, "สีทั้งตัว (Chams)", function(s) _G.Chams = s end)

RunService.RenderStepped:Connect(function()
    for _, p in pairs(workspace:GetDescendants()) do
        if p:IsA("Humanoid") and p.Parent ~= LocalPlayer.Character then
            local char = p.Parent
            -- Chams logic
            local highlight = char:FindFirstChild("GaoHighlight")
            if _G.Chams then
                if not highlight then
                    highlight = Instance.new("Highlight", char)
                    highlight.Name = "GaoHighlight"
                end
                highlight.FillColor = Players:GetPlayerFromCharacter(char) and Color3.new(0,1,0) or Color3.new(1,0,0)
            elseif highlight then highlight:Destroy() end
        end
    end
end)

ShowPage("Main")

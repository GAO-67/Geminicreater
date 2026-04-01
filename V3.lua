-- [[ PRO PANEL V2 - FULL FUNCTIONAL (NO CHANGES TO STRUCTURE) ]]
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

-- Setup
ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "GaoProV2"
ScreenGui.ResetOnSpawn = false

-- [[ 1. Main Frame ]]
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
Title.Text = "   GAO PRO PANEL V2"
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

-- Open Button (Circle)
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
    Instance.new("UIListLayout", P).Padding = UDim.new(0, 8)
    Pages[name] = P
    return P
end

local MainMenu = CreatePage("Main")
local Teleport = CreatePage("TP")
local InfoPage = CreatePage("Info")

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

-- [[ 3. หน้าเมนูหลัก (ไส้ในฟังก์ชัน) ]]
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

-- 1. เดินทะลุ
local noclip = false
RunService.Stepped:Connect(function()
    if noclip and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)
AddToggle(MainMenu, "เดินทะลุ", function(s) noclip = s end)

-- 2. วิ่งไว (ปรับค่าได้ในโค้ด)
AddToggle(MainMenu, "วิ่งไว", function(s)
    LocalPlayer.Character.Humanoid.WalkSpeed = s and 100 or 16
end)

-- 3. กระโดดบิน (Inf Jump)
local infJump = false
game:GetService("UserInputService").JumpRequest:Connect(function()
    if infJump then LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping") end
end)
AddToggle(MainMenu, "กระโดดบิน", function(s) infJump = s end)

-- 4. เสกของ (Universal Dex Explorer Lite)
AddToggle(MainMenu, "เสกของในแมพ", function(s) 
    if s then loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))() end
end)

-- 5. บิน (Fly)
local flying = false
AddToggle(MainMenu, "บิน", function(s)
    flying = s
    if flying then
        local bvg = Instance.new("BodyVelocity", LocalPlayer.Character.HumanoidRootPart)
        bvg.Velocity = Vector3.new(0,0,0)
        bvg.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        while flying do
            task.wait()
            bvg.Velocity = LocalPlayer.Character.Humanoid.MoveDirection * 100
        end
        bvg:Destroy()
    end
end)

-- 6. สั่งตาย (Kill Aura)
AddToggle(MainMenu, "สั่งตาย(ระยะ 1ม.)", function(s)
    _G.KillLoop = s
    while _G.KillLoop do
        task.wait(0.2)
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local d = (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                if d < 10 then p.Character.Humanoid.Health = 0 end
            end
        end
    end
end)

-- [[ 4. หน้าเทเลพอร์ต (รายชื่อ Real-time) ]]
local function GetTP(target)
    if target and target.Character then
        LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
    end
end

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
            B.MouseButton1Click:Connect(function() GetTP(p) end)
        end
    end
end
UpdateList()
Players.PlayerAdded:Connect(UpdateList)
Players.PlayerRemoving:Connect(UpdateList)

-- [[ 5. หน้าผู้ใช้ (Info) ]]
local function AddInfo(txt, color)
    local L = Instance.new("TextLabel", InfoPage)
    L.Size = UDim2.new(1, 0, 0, 30)
    L.RichText = true
    L.Text = txt
    L.TextColor3 = color or Color3.new(1,1,1)
    L.BackgroundTransparency = 1
end

AddInfo('Status: <font color="rgb(0,255,0)">online</font>')
AddInfo('ผู้ใช้ : ไอเก้า , ไอโจ้')
AddInfo(' ')
AddInfo('FUCK YOU BITCH', Color3.fromRGB(255, 50, 50))

ShowPage("Main")


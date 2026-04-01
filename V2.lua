-- [[ PRO PANEL V1 - FULL INTEGRATED SCRIPT ]]
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local LeftSideBar = Instance.new("Frame")
local RightContent = Instance.new("Frame")
local UICornerMain = Instance.new("UICorner")
local TopBar = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local OpenBtn = Instance.new("TextButton") -- ปุ่มวงกลมตอนย่อ

-- Setup Parent & Properties
ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "GaoProPanelV1"
ScreenGui.ResetOnSpawn = false

-- [[ 1. Main Frame (แผงหลัก) ]]
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -150)
MainFrame.Size = UDim2.new(0, 450, 0, 300)
MainFrame.Active = true
MainFrame.Draggable = true -- ลากได้

UICornerMain.CornerRadius = UDim.new(0, 15)
UICornerMain.Parent = MainFrame

-- [[ 2. Top Bar (แถบบนสุด) ]]
TopBar.Name = "TopBar"
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TopBar.Size = UDim2.new(1, 0, 0, 35)
local TopCorner = Instance.new("UICorner", TopBar)
TopCorner.CornerRadius = UDim.new(0, 15)

Title.Parent = TopBar
Title.Text = "   GAO PRO PANEL V1"
Title.Size = UDim2.new(1, 0, 1, 0)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1

-- [[ 3. ปุ่มย่อหน้าจอ (Minimize) ]]
local MinimizeBtn = Instance.new("TextButton", TopBar)
MinimizeBtn.Size = UDim2.new(0, 30, 0, 25)
MinimizeBtn.Position = UDim2.new(1, -40, 0, 5)
MinimizeBtn.Text = "-"
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
MinimizeBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0, 5)

-- [[ 4. ปุ่มเปิดเมนูคืน (Open Button วงกลม) ]]
OpenBtn.Name = "OpenBtn"
OpenBtn.Parent = ScreenGui
OpenBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
OpenBtn.Position = UDim2.new(0, 10, 0.5, 0)
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Text = "OPEN"
OpenBtn.TextColor3 = Color3.new(1, 1, 1)
OpenBtn.Visible = false -- เริ่มต้นซ่อนไว้
OpenBtn.Draggable = true
local Circle = Instance.new("UICorner", OpenBtn)
Circle.CornerRadius = UDim.new(1, 0)

-- ระบบสลับ เปิด/ปิด
MinimizeBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    OpenBtn.Visible = true
end)
OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    OpenBtn.Visible = false
end)

-- [[ 5. SideBar (แถบข้าง) ]]
LeftSideBar.Name = "SideBar"
LeftSideBar.Parent = MainFrame
LeftSideBar.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
LeftSideBar.Position = UDim2.new(0, 0, 0, 35)
LeftSideBar.Size = UDim2.new(0, 120, 1, -35)
local SideList = Instance.new("UIListLayout", LeftSideBar)
SideList.Padding = UDim.new(0, 5)
SideList.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- [[ 6. Content (พื้นที่แสดงผล) ]]
RightContent.Name = "Content"
RightContent.Parent = MainFrame
RightContent.Position = UDim2.new(0, 125, 0, 45)
RightContent.Size = UDim2.new(0, 315, 0, 245)
RightContent.BackgroundTransparency = 1

local Pages = {}
local function CreatePage(name)
    local Page = Instance.new("ScrollingFrame", RightContent)
    Page.Name = name
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 3
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 8)
    Pages[name] = Page
    return Page
end

local MainMenu = CreatePage("Main")
local Teleport = CreatePage("TP")
local InfoPage = CreatePage("Info")

local function ShowPage(name)
    for i, v in pairs(Pages) do v.Visible = (i == name) end
end

local function CreateTab(text, target)
    local B = Instance.new("TextButton", LeftSideBar)
    B.Size = UDim2.new(0, 110, 0, 35)
    B.Text = text
    B.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    B.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", B).CornerRadius = UDim.new(0, 8)
    B.MouseButton1Click:Connect(function() ShowPage(target) end)
end

CreateTab("1.เมนูหลัก", "Main")
CreateTab("2.เทเลพอร์ต", "TP")
CreateTab("3.ผู้ใช้(info)", "Info")

-- [[ 7. เนื้อหาหน้า เมนูหลัก ]]
local function AddToggle(parent, text)
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
    end)
end

AddToggle(MainMenu, "เดินทะลุ")
AddToggle(MainMenu, "วิ่งไว") -- (ส่วน Slider ต้องเขียนเพิ่มใน V2)
AddToggle(MainMenu, "กระโดดบิน")
AddToggle(MainMenu, "เสกของในแมพ")
AddToggle(MainMenu, "บิน")
AddToggle(MainMenu, "สั่งตาย(ระยะ 1ม.)")

-- [[ 8. เนื้อหาหน้า เทเลพอร์ต ]]
local TpDesc = Instance.new("TextLabel", Teleport)
TpDesc.Text = "--- เลือกคนในเซิร์ฟเวอร์ ---"
TpDesc.Size = UDim2.new(1,0,0,30)
TpDesc.BackgroundTransparency = 1
TpDesc.TextColor3 = Color3.new(1,1,1)

local WinBtn = Instance.new("TextButton", Teleport)
WinBtn.Size = UDim2.new(0, 280, 0, 35)
WinBtn.Text = "วาร์ปไปเส้นชัย"
WinBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
WinBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", WinBtn)

-- [[ 9. เนื้อหาหน้า ผู้ใช้(info) ]]
local function AddInfo(txt, color)
    local L = Instance.new("TextLabel", InfoPage)
    L.Size = UDim2.new(1, 0, 0, 30)
    L.RichText = true
    L.Text = txt
    L.TextColor3 = color or Color3.new(1,1,1)
    L.BackgroundTransparency = 1
    L.Font = Enum.Font.Gotham
end

AddInfo('Status: <font color="rgb(0,255,0)">online</font>')
AddInfo('ผู้ใช้ : ไอเก้า , ไอโจ้')
AddInfo(' ')
AddInfo('FUCK YOU BITCH', Color3.fromRGB(255, 50, 50))

ShowPage("Main") -- เริ่มที่หน้าแรก


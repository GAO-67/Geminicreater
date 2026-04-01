-- [[ Modern UI Panel for Delta ]]
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local LeftSideBar = Instance.new("Frame")
local RightContent = Instance.new("Frame")
local UICornerMain = Instance.new("UICorner")

-- Setup Parent
ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "CustomProPanel"

-- Main Frame (แผงหลัก)
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Position = UDim2.new(0.2, 0, 0.2, 0)
MainFrame.Size = UDim2.new(0, 450, 0, 300)
MainFrame.Active = true
MainFrame.Draggable = true -- ลากได้

UICornerMain.CornerRadius = UDim.new(0, 15)
UICornerMain.Parent = MainFrame

-- [[ Left SideBar (แถบข้าง) ]]
LeftSideBar.Name = "SideBar"
LeftSideBar.Parent = MainFrame
LeftSideBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
LeftSideBar.Size = UDim2.new(0, 130, 1, 0)

local UICornerSide = Instance.new("UICorner")
UICornerSide.CornerRadius = UDim.new(0, 15)
UICornerSide.Parent = LeftSideBar

local TabList = Instance.new("UIListLayout")
TabList.Parent = LeftSideBar
TabList.Padding = UDim.new(0, 5)
TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- [[ Right Content (พื้นที่แสดงผล) ]]
RightContent.Name = "Content"
RightContent.Parent = MainFrame
RightContent.Position = UDim2.new(0, 135, 0, 10)
RightContent.Size = UDim2.new(0, 305, 0, 280)
RightContent.BackgroundTransparency = 1

local Pages = {} -- เก็บหน้าต่างๆ ไว้สลับ

local function CreatePage(name)
    local Page = Instance.new("ScrollingFrame")
    Page.Name = name
    Page.Parent = RightContent
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 2
    
    local List = Instance.new("UIListLayout")
    List.Parent = Page
    List.Padding = UDim.new(0, 8)
    List.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    Pages[name] = Page
    return Page
end

-- สร้าง 3 หน้าหลัก
local MainMenuPage = CreatePage("MainMenu")
local TeleportPage = CreatePage("Teleport")
local InfoPage = CreatePage("Info")

-- ฟังก์ชันสลับหน้า
local function ShowPage(name)
    for i, v in pairs(Pages) do
        v.Visible = (i == name)
    end
end

-- [[ ปุ่มแถบข้าง ]]
local function CreateTabBtn(text, pageName)
    local Btn = Instance.new("TextButton")
    Btn.Parent = LeftSideBar
    Btn.Size = UDim2.new(0, 110, 0, 40)
    Btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 12
    
    local Corner = Instance.new("UICorner")
    Corner.Parent = Btn
    
    Btn.MouseButton1Click:Connect(function()
        ShowPage(pageName)
    end)
end

CreateTabBtn("1.เมนูหลัก", "MainMenu")
CreateTabBtn("2.เทเลพอร์ต", "Teleport")
CreateTabBtn("3.ผู้ใช้(info)", "Info")

-- [[ หน้าที่ 1: เมนูหลัก (ใส่ฟังก์ชันที่คุณสั่ง) ]]
local function AddToggle(parent, text, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 260, 0, 35)
    Btn.Parent = parent
    Btn.Text = text .. ": OFF"
    Btn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
    Btn.TextColor3 = Color3.new(1,1,1)
    
    local Corner = Instance.new("UICorner")
    Corner.Parent = Btn
    
    local state = false
    Btn.MouseButton1Click:Connect(function()
        state = not state
        Btn.Text = text .. (state and ": ON" or ": OFF")
        Btn.BackgroundColor3 = state and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(150, 50, 50)
        callback(state)
    end)
end

AddToggle(MainMenuPage, "เดินทะลุ", function(s) end)
AddToggle(MainMenuPage, "วิ่งไว", function(s) end)

-- Slider วิ่งไว
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Parent = MainMenuPage
SpeedLabel.Text = "ปรับความเร็ว: 16"
SpeedLabel.Size = UDim2.new(0, 260, 0, 20)
SpeedLabel.TextColor3 = Color3.new(1,1,1)
SpeedLabel.BackgroundTransparency = 1

AddToggle(MainMenuPage, "กระโดดบิน", function(s) end)
AddToggle(MainMenuPage, "เสกของในแมพ", function(s) end)
AddToggle(MainMenuPage, "บิน", function(s) end)
AddToggle(MainMenuPage, "สั่งตาย(1ม.)", function(s) end)

-- [[ หน้าที่ 2: เทเลพอร์ต ]]
local TpTitle1 = Instance.new("TextLabel", TeleportPage)
TpTitle1.Text = "--- เลือกคนในเซิร์ฟ ---"
TpTitle1.Size = UDim2.new(0, 260, 0, 30)
TpTitle1.TextColor3 = Color3.new(1,1,1)
TpTitle1.BackgroundTransparency = 1

-- ปุ่มวาร์ปไปเส้นชัย
local WinBtn = Instance.new("TextButton", TeleportPage)
WinBtn.Size = UDim2.new(0, 260, 0, 35)
WinBtn.Text = "วาร์ปไปเส้นชัย"
WinBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
WinBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", WinBtn)

-- [[ หน้าที่ 3: ผู้ใช้ (Info) ]]
local function CreateInfoLabel(text, color)
    local Lbl = Instance.new("TextLabel")
    Lbl.Parent = InfoPage
    Lbl.Size = UDim2.new(0, 260, 0, 30)
    Lbl.RichText = true
    Lbl.Text = text
    Lbl.TextColor3 = color or Color3.new(1,1,1)
    Lbl.BackgroundTransparency = 1
    Lbl.Font = Enum.Font.Gotham
    Lbl.TextSize = 14
end

CreateInfoLabel('Status: <font color="rgb(0,255,0)">online</font>')
CreateInfoLabel('ผู้ใช้ : ไอเก้า , ไอโจ้')
CreateInfoLabel(' ') -- เว้นวรรค
CreateInfoLabel('FUCK YOU BITCH', Color3.fromRGB(255, 50, 50))

-- เริ่มต้นที่หน้าแรก
ShowPage("MainMenu")


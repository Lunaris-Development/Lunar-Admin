local qot = queue_on_teleport or queueonteleport
if qot then
	qot('loadstring(game:HttpGet("https://raw.githubusercontent.com/Lunaris-Development/Lunar-Admin/main/Key.lua"))()')
end

if game.CoreGui:FindFirstChild("LunarAdmin") then
	game.CoreGui:FindFirstChild("LunarAdmin"):Destroy()
end

local Junkie = loadstring(game:HttpGet("https://jnkie.com/sdk/library.lua"))()
Junkie.service = "Lunar"
Junkie.identifier = "1093800"
Junkie.provider = "Lunar"

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LunarAdmin"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = game.CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 180)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -90)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BackgroundTransparency = 0.2
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(255, 255, 255)
UIStroke.Transparency = 0.85
UIStroke.Thickness = 1.2
UIStroke.Parent = MainFrame

local Glow = Instance.new("ImageLabel")
Glow.Name = "Glow"
Glow.Size = UDim2.new(1.15, 0, 1.3, 0)
Glow.Position = UDim2.new(-0.075, 0, -0.15, 0)
Glow.BackgroundTransparency = 1
Glow.Image = "rbxassetid://6015667101"
Glow.ImageColor3 = Color3.fromRGB(255, 255, 255)
Glow.ImageTransparency = 0.9
Glow.ZIndex = 0
Glow.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(0.8, 0, 0, 35)
Title.Position = UDim2.new(0.1, 0, 0, 10)
Title.BackgroundTransparency = 1
Title.Text = "Lunar Admin"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextScaled = true
Title.Parent = MainFrame

local TitleConstraint = Instance.new("UITextSizeConstraint")
TitleConstraint.MaxTextSize = 18
TitleConstraint.MinTextSize = 10
TitleConstraint.Parent = Title

local Status = Instance.new("TextLabel")
Status.Name = "Status"
Status.Size = UDim2.new(0.9, 0, 0, 20)
Status.Position = UDim2.new(0.05, 0, 0, 32)
Status.BackgroundTransparency = 1
Status.Text = "AUTHENTICATION REQUIRED"
Status.TextColor3 = Color3.fromRGB(120, 120, 120)
Status.Font = Enum.Font.Gotham
Status.TextSize = 10
Status.TextScaled = true
Status.Parent = MainFrame

local StatusConstraint = Instance.new("UITextSizeConstraint")
StatusConstraint.MaxTextSize = 10
StatusConstraint.MinTextSize = 8
StatusConstraint.Parent = Status

local KeyInput = Instance.new("TextBox")
KeyInput.Name = "KeyInput"
KeyInput.Size = UDim2.new(0.85, 0, 0, 40)
KeyInput.Position = UDim2.new(0.075, 0, 0.38, 0)
KeyInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
KeyInput.BackgroundTransparency = 0.4
KeyInput.Text = ""
KeyInput.PlaceholderText = "Enter License Key..."
KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyInput.Font = Enum.Font.Gotham
KeyInput.TextSize = 13
KeyInput.Parent = MainFrame

local InputCorner = Instance.new("UICorner")
InputCorner.CornerRadius = UDim.new(0, 6)
InputCorner.Parent = KeyInput

local InputStroke = Instance.new("UIStroke")
InputStroke.Color = Color3.fromRGB(255, 255, 255)
InputStroke.Transparency = 0.92
InputStroke.Parent = KeyInput

local CheckBtn = Instance.new("TextButton")
CheckBtn.Name = "CheckBtn"
CheckBtn.Size = UDim2.new(0.41, 0, 0, 35)
CheckBtn.Position = UDim2.new(0.075, 0, 0.7, 0)
CheckBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
CheckBtn.BackgroundTransparency = 0.2
CheckBtn.Text = "CHECK KEY"
CheckBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CheckBtn.Font = Enum.Font.GothamBold
CheckBtn.TextSize = 11
CheckBtn.AutoButtonColor = false
CheckBtn.Parent = MainFrame

local GetBtn = Instance.new("TextButton")
GetBtn.Name = "GetBtn"
GetBtn.Size = UDim2.new(0.41, 0, 0, 35)
GetBtn.Position = UDim2.new(0.515, 0, 0.7, 0)
GetBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
GetBtn.BackgroundTransparency = 0.5
GetBtn.Text = "GET KEY"
GetBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
GetBtn.Font = Enum.Font.GothamBold
GetBtn.TextSize = 11
GetBtn.AutoButtonColor = false
GetBtn.Parent = MainFrame

local function StyleButton(btn)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = btn
	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(255, 255, 255)
	stroke.Transparency = 0.9
	stroke.Parent = btn
	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
		TweenService:Create(stroke, TweenInfo.new(0.2), {Transparency = 0.7}):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = btn == CheckBtn and 0.2 or 0.5}):Play()
		TweenService:Create(stroke, TweenInfo.new(0.2), {Transparency = 0.9}):Play()
	end)
end

StyleButton(CheckBtn)
StyleButton(GetBtn)

local function CloseUI()
	TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Position = UDim2.new(0.5, -160, 1.2, 0)}):Play()
	task.wait(0.4)
	ScreenGui:Destroy()
end

local dragging, dragInput, dragStart, startPos
local function update(input)
	local delta = input.Position - dragStart
	MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
MainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = MainFrame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then dragging = false end
		end)
	end
end)
MainFrame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then update(input) end
end)

MainFrame.Position = UDim2.new(0.5, -160, 1.2, 0)
TweenService:Create(MainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -160, 0.5, -90)}):Play()

local function grantAccess(key)
	Status.Text = "ACCESS GRANTED"
	getgenv().SCRIPT_KEY = key
	if writefile then writefile("LunarKey.txt", key) end
	task.wait(1)
	CloseUI()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Lunaris-Development/Lunar-Admin/main/Main.lua"))()
end

CheckBtn.MouseButton1Click:Connect(function()
	local input = KeyInput.Text
	Status.Text = "VALIDATING..."
	local result = Junkie.check_key(input)
	if result and result.valid then
		grantAccess(input)
	else
		Status.Text = "INVALID LICENSE KEY"
		task.wait(2)
		Status.Text = "AUTHENTICATION REQUIRED"
	end
end)

GetBtn.MouseButton1Click:Connect(function()
	setclipboard(Junkie.get_key_link())
	Status.Text = "LINK COPIED TO CLIPBOARD"
	task.wait(2)
	Status.Text = "AUTHENTICATION REQUIRED"
end)

if isfile and isfile("LunarKey.txt") then
	local saved = readfile("LunarKey.txt")
	local result = Junkie.check_key(saved)
	if result and result.valid then
		grantAccess(saved)
	end
end
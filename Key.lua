local qot = queue_on_teleport or queueonteleport
if qot then
	qot('loadstring(game:HttpGet("https://raw.githubusercontent.com/Lunaris-Development/Lunar-Admin/main/Key.lua"))()')
end

local Junkie = loadstring(game:HttpGet("https://jnkie.com/sdk/library.lua"))()
Junkie.service = "Lunar"
Junkie.identifier = "1093800"
Junkie.provider = "Lunar"

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local function GetFont()
	if getcustomasset and isfile and isfile("Minecraft.ttf") then
		return Font.new(getcustomasset("Minecraft.ttf"))
	end
	return Font.fromEnum(Enum.Font.GothamBold)
end

local function SaveKey(key)
	if writefile then
		writefile("LunarKey.txt", key)
	end
end

local function GetSavedKey()
	if isfile and isfile("LunarKey.txt") then
		return readfile("LunarKey.txt")
	end
	return nil
end

local function StartMain()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Lunaris-Development/Lunar-Admin/main/Main.lua"))()
end

local function ValidateAndStart(key)
	local result = Junkie.check_key(key)
	if result and result.valid then
		SaveKey(key)
		StartMain()
		return true
	end
	return false
end

local saved = GetSavedKey()
if saved and ValidateAndStart(saved) then
	return
end

if game.CoreGui:FindFirstChild("LunarKeyUI") then
	game.CoreGui:FindFirstChild("LunarKeyUI"):Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LunarKeyUI"
ScreenGui.Parent = game.CoreGui

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 650, 0, 400)
Main.Position = UDim2.new(0.5, -325, 0.5, -200)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 15)
MainCorner.Parent = Main

local Branding = Instance.new("Frame")
Branding.Name = "Branding"
Branding.Size = UDim2.new(0.4, 0, 1, 0)
Branding.BackgroundColor3 = Color3.fromRGB(40, 20, 80)
Branding.BorderSizePixel = 0
Branding.Parent = Main

local BrandingCorner = Instance.new("UICorner")
BrandingCorner.CornerRadius = UDim.new(0, 15)
BrandingCorner.Parent = Branding

local BrandingGradient = Instance.new("UIGradient")
BrandingGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 20, 90)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 10, 40))
})
BrandingGradient.Rotation = 45
BrandingGradient.Parent = Branding

local Logo = Instance.new("ImageLabel")
Logo.Size = UDim2.new(0, 60, 0, 60)
Logo.Position = UDim2.new(0.5, -30, 0.2, 0)
Logo.BackgroundTransparency = 1
Logo.Image = "rbxthumb://type=Asset&id=73819038719454&w=420&h=420"
Logo.ScaleType = Enum.ScaleType.Fit
Logo.Parent = Branding

local LogoGlow = Instance.new("ImageLabel")
LogoGlow.Size = UDim2.new(2, 0, 2, 0)
LogoGlow.Position = UDim2.new(-0.5, 0, -0.5, 0)
LogoGlow.BackgroundTransparency = 1
LogoGlow.Image = "rbxassetid://6015538162"
LogoGlow.ImageColor3 = Color3.fromRGB(255, 255, 255)
LogoGlow.ImageTransparency = 0.8
LogoGlow.Parent = Logo

local BrandTitle = Instance.new("TextLabel")
BrandTitle.Size = UDim2.new(1, 0, 0, 40)
BrandTitle.Position = UDim2.new(0, 0, 0.4, 0)
BrandTitle.BackgroundTransparency = 1
BrandTitle.Text = "Lunar Admin"
BrandTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
BrandTitle.FontFace = GetFont()
BrandTitle.TextSize = 24
BrandTitle.Parent = Branding

local BrandSub = Instance.new("TextLabel")
BrandSub.Size = UDim2.new(0.8, 0, 0, 60)
BrandSub.Position = UDim2.new(0.1, 0, 0.5, 0)
BrandSub.BackgroundTransparency = 1
BrandSub.Text = "The most powerful administration suite for Roblox."
BrandSub.TextColor3 = Color3.fromRGB(200, 200, 200)
BrandSub.FontFace = GetFont()
BrandSub.TextSize = 12
BrandSub.TextWrapped = true
BrandSub.Parent = Branding

local Login = Instance.new("Frame")
Login.Name = "Login"
Login.Size = UDim2.new(0.6, 0, 1, 0)
Login.Position = UDim2.new(0.4, 0, 0, 0)
Login.BackgroundTransparency = 1
Login.Parent = Main

local Welcome = Instance.new("TextLabel")
Welcome.Size = UDim2.new(1, -60, 0, 40)
Welcome.Position = UDim2.new(0, 30, 0.15, 0)
Welcome.BackgroundTransparency = 1
Welcome.Text = "Welcome back"
Welcome.TextColor3 = Color3.fromRGB(255, 255, 255)
Welcome.FontFace = GetFont()
Welcome.TextSize = 28
Welcome.TextXAlignment = Enum.TextXAlignment.Left
Welcome.Parent = Login

local SubWelcome = Instance.new("TextLabel")
SubWelcome.Size = UDim2.new(1, -60, 0, 20)
SubWelcome.Position = UDim2.new(0, 30, 0.23, 0)
SubWelcome.BackgroundTransparency = 1
SubWelcome.Text = "Enter your license key to access your dashboard."
SubWelcome.TextColor3 = Color3.fromRGB(150, 150, 150)
SubWelcome.FontFace = GetFont()
SubWelcome.TextSize = 12
SubWelcome.TextXAlignment = Enum.TextXAlignment.Left
SubWelcome.Parent = Login

local KeyContainer = Instance.new("Frame")
KeyContainer.Size = UDim2.new(1, -60, 0, 45)
KeyContainer.Position = UDim2.new(0, 30, 0.38, 0)
KeyContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
KeyContainer.Parent = Login
Instance.new("UICorner", KeyContainer).CornerRadius = UDim.new(0, 8)

local KeyInput = Instance.new("TextBox")
KeyInput.Size = UDim2.new(1, -20, 1, 0)
KeyInput.Position = UDim2.new(0, 10, 0, 0)
KeyInput.BackgroundTransparency = 1
KeyInput.Text = ""
KeyInput.PlaceholderText = "License Key"
KeyInput.PlaceholderColor3 = Color3.fromRGB(80, 80, 80)
KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyInput.FontFace = GetFont()
KeyInput.TextSize = 14
KeyInput.TextXAlignment = Enum.TextXAlignment.Left
KeyInput.Parent = KeyContainer

local CheckBtn = Instance.new("TextButton")
CheckBtn.Size = UDim2.new(1, -60, 0, 45)
CheckBtn.Position = UDim2.new(0, 30, 0.55, 0)
CheckBtn.BackgroundColor3 = Color3.fromRGB(80, 50, 200)
CheckBtn.Text = "Sign In  →"
CheckBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CheckBtn.FontFace = GetFont()
CheckBtn.TextSize = 14
CheckBtn.AutoButtonColor = false
CheckBtn.Parent = Login
Instance.new("UICorner", CheckBtn).CornerRadius = UDim.new(0, 8)

local GetBtn = Instance.new("TextButton")
GetBtn.Size = UDim2.new(1, -60, 0, 45)
GetBtn.Position = UDim2.new(0, 30, 0.75, 0)
GetBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
GetBtn.Text = "Get Access Key"
GetBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
GetBtn.FontFace = GetFont()
GetBtn.TextSize = 14
GetBtn.AutoButtonColor = false
GetBtn.Parent = Login
Instance.new("UICorner", GetBtn).CornerRadius = UDim.new(0, 8)

local function StyleBtn(btn, primary)
	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = primary and Color3.fromRGB(100, 70, 220) or Color3.fromRGB(45, 45, 65)}):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = primary and Color3.fromRGB(80, 50, 200) or Color3.fromRGB(35, 35, 50)}):Play()
	end)
end

StyleBtn(CheckBtn, true)
StyleBtn(GetBtn, false)

CheckBtn.MouseButton1Click:Connect(function()
	local key = KeyInput.Text
	Welcome.Text = "Validating..."
	if ValidateAndStart(key) then
		Welcome.Text = "Access Granted"
		task.wait(1)
		ScreenGui:Destroy()
	else
		Welcome.Text = "Invalid Key"
		task.wait(2)
		Welcome.Text = "Welcome back"
	end
end)

GetBtn.MouseButton1Click:Connect(function()
	setclipboard(Junkie.get_key_link())
	GetBtn.Text = "Link Copied!"
	task.wait(2)
	GetBtn.Text = "Get Access Key"
end)

local function CloseUI()
	TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Position = UDim2.new(0.5, -325, 1.2, 0)}):Play()
	task.wait(0.4)
	ScreenGui:Destroy()
end

Main.Position = UDim2.new(0.5, -325, 1.2, 0)
TweenService:Create(Main, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -325, 0.5, -200)}):Play()
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local LogoID = "rbxthumb://type=Asset&id=73819038719454&w=420&h=420"
local Executor = (identifyexecutor and identifyexecutor()) or (getexecutorname and getexecutorname()) or "Unknown"

local function GetFont()
	if getcustomasset and isfile and isfile("Minecraft.ttf") then
		return Font.new(getcustomasset("Minecraft.ttf"))
	end
	return Font.fromEnum(Enum.Font.GothamBold)
end

local UI = {}

function UI.Init()
	if game.CoreGui:FindFirstChild("LunarDynamicIsland") then
		game.CoreGui:FindFirstChild("LunarDynamicIsland"):Destroy()
	end

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "LunarDynamicIsland"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.Parent = game.CoreGui

	local Island = Instance.new("Frame")
	Island.Name = "Island"
	Island.Size = UDim2.new(0, 50, 0, 50)
	Island.Position = UDim2.new(0.5, -25, 0, 15)
	Island.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	Island.BackgroundTransparency = 0.1
	Island.BorderSizePixel = 0
	Island.ClipsDescendants = true
	Island.Parent = ScreenGui

	local IslandCorner = Instance.new("UICorner")
	IslandCorner.CornerRadius = UDim.new(0, 25)
	IslandCorner.Parent = Island

	local IslandStroke = Instance.new("UIStroke")
	IslandStroke.Color = Color3.fromRGB(255, 255, 255)
	IslandStroke.Transparency = 0.8
	IslandStroke.Thickness = 1.5
	IslandStroke.Parent = Island

	local LogoImg = Instance.new("ImageLabel")
	LogoImg.Size = UDim2.new(0, 30, 0, 30)
	LogoImg.Position = UDim2.new(0, 10, 0, 10)
	LogoImg.BackgroundTransparency = 1
	LogoImg.Image = LogoID
	LogoImg.ScaleType = Enum.ScaleType.Fit
	LogoImg.Parent = Island

	local Content = Instance.new("Frame")
	Content.Name = "Content"
	Content.Size = UDim2.new(1, -60, 1, 0)
	Content.Position = UDim2.new(0, 60, 0, 0)
	Content.BackgroundTransparency = 1
	Content.Visible = false
	Content.Parent = Island

	local Info = Instance.new("Frame")
	Info.Size = UDim2.new(0, 150, 1, 0)
	Info.BackgroundTransparency = 1
	Info.Parent = Content

	local Title = Instance.new("TextLabel")
	Title.Size = UDim2.new(1, 0, 0.5, 0)
	Title.Position = UDim2.new(0, 0, 0, 8)
	Title.BackgroundTransparency = 1
	Title.Text = "Lunar Admin"
	Title.TextColor3 = Color3.fromRGB(255, 255, 255)
	Title.FontFace = GetFont()
	Title.TextSize = 14
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.Parent = Info

	local ExecLabel = Instance.new("TextLabel")
	ExecLabel.Size = UDim2.new(1, 0, 0.5, 0)
	ExecLabel.Position = UDim2.new(0, 0, 0.5, -4)
	ExecLabel.BackgroundTransparency = 1
	ExecLabel.Text = Executor
	ExecLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
	ExecLabel.FontFace = GetFont()
	ExecLabel.TextSize = 10
	ExecLabel.TextXAlignment = Enum.TextXAlignment.Left
	ExecLabel.Parent = Info

	local Stats = Instance.new("Frame")
	Stats.Size = UDim2.new(0, 120, 1, 0)
	Stats.Position = UDim2.new(0, 160, 0, 0)
	Stats.BackgroundTransparency = 1
	Stats.Parent = Content

	local FPSLabel = Instance.new("TextLabel")
	FPSLabel.Size = UDim2.new(1, 0, 0.5, 0)
	FPSLabel.Position = UDim2.new(0, 0, 0, 8)
	FPSLabel.BackgroundTransparency = 1
	FPSLabel.Text = "FPS: 0"
	FPSLabel.TextColor3 = Color3.fromRGB(150, 255, 150)
	FPSLabel.FontFace = GetFont()
	FPSLabel.TextSize = 10
	FPSLabel.TextXAlignment = Enum.TextXAlignment.Left
	FPSLabel.Parent = Stats

	local PingLabel = Instance.new("TextLabel")
	PingLabel.Size = UDim2.new(1, 0, 0.5, 0)
	PingLabel.Position = UDim2.new(0, 0, 0.5, -4)
	PingLabel.BackgroundTransparency = 1
	PingLabel.Text = "PING: 0ms"
	PingLabel.TextColor3 = Color3.fromRGB(150, 200, 255)
	PingLabel.FontFace = GetFont()
	PingLabel.TextSize = 10
	PingLabel.TextXAlignment = Enum.TextXAlignment.Left
	PingLabel.Parent = Stats

	local Icons = Instance.new("Frame")
	Icons.Size = UDim2.new(1, -290, 1, 0)
	Icons.Position = UDim2.new(0, 290, 0, 0)
	Icons.BackgroundTransparency = 1
	Icons.Parent = Content

	local UIList = Instance.new("UIListLayout")
	UIList.FillDirection = Enum.FillDirection.Horizontal
	UIList.HorizontalAlignment = Enum.HorizontalAlignment.Right
	UIList.VerticalAlignment = Enum.VerticalAlignment.Center
	UIList.Padding = UDim.new(0, 15)
	UIList.Parent = Icons

	local CmdMenu = Instance.new("Frame")
	CmdMenu.Name = "CmdMenu"
	CmdMenu.Size = UDim2.new(0, 250, 0, 0)
	CmdMenu.Position = UDim2.new(0.5, -125, 0, 75)
	CmdMenu.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	CmdMenu.BackgroundTransparency = 0.15
	CmdMenu.BorderSizePixel = 0
	CmdMenu.ClipsDescendants = true
	CmdMenu.Visible = false
	CmdMenu.Parent = ScreenGui

	local MenuCorner = Instance.new("UICorner")
	MenuCorner.CornerRadius = UDim.new(0, 12)
	MenuCorner.Parent = CmdMenu

	local MenuStroke = Instance.new("UIStroke")
	MenuStroke.Color = Color3.fromRGB(255, 255, 255)
	MenuStroke.Transparency = 0.85
	MenuStroke.Thickness = 1.2
	MenuStroke.Parent = CmdMenu

	local MenuList = Instance.new("UIListLayout")
	MenuList.SortOrder = Enum.SortOrder.LayoutOrder
	MenuList.Padding = UDim.new(0, 5)
	MenuList.Parent = CmdMenu

	local MenuPadding = Instance.new("UIPadding")
	MenuPadding.PaddingTop = UDim.new(0, 10)
	MenuPadding.PaddingBottom = UDim.new(0, 10)
	MenuPadding.PaddingLeft = UDim.new(0, 10)
	MenuPadding.PaddingRight = UDim.new(0, 10)
	MenuPadding.Parent = CmdMenu

	local function CreateMenuBtn(name, callback)
		local Btn = Instance.new("TextButton")
		Btn.Name = name
		Btn.Size = UDim2.new(1, 0, 0, 35)
		Btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Btn.BackgroundTransparency = 0.95
		Btn.Text = "  " .. name
		Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
		Btn.FontFace = GetFont()
		Btn.TextSize = 12
		Btn.TextXAlignment = Enum.TextXAlignment.Left
		Btn.AutoButtonColor = false
		Btn.Parent = CmdMenu

		local BtnCorner = Instance.new("UICorner")
		BtnCorner.CornerRadius = UDim.new(0, 6)
		BtnCorner.Parent = Btn

		Btn.MouseEnter:Connect(function()
			TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.85, TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
		end)
		Btn.MouseLeave:Connect(function()
			TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.95, TextColor3 = Color3.fromRGB(200, 200, 200)}):Play()
		end)
		Btn.MouseButton1Click:Connect(callback)
	end

	CreateMenuBtn("WalkSpeed (50)", function() Player.Character.Humanoid.WalkSpeed = 50 end)
	CreateMenuBtn("JumpPower (100)", function() Player.Character.Humanoid.JumpPower = 100 end)
	CreateMenuBtn("Fly", function() print("Fly toggled") end)
	CreateMenuBtn("ESP", function() print("ESP toggled") end)

	local function CreateIcon(id, callback)
		local Icon = Instance.new("ImageButton")
		Icon.Size = UDim2.new(0, 22, 0, 22)
		Icon.BackgroundTransparency = 1
		Icon.Image = id
		Icon.ImageColor3 = Color3.fromRGB(180, 180, 180)
		Icon.Parent = Icons
		Icon.MouseEnter:Connect(function()
			TweenService:Create(Icon, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(255, 255, 255)}):Play()
		end)
		Icon.MouseLeave:Connect(function()
			TweenService:Create(Icon, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(180, 180, 180)}):Play()
		end)
		if callback then Icon.MouseButton1Click:Connect(callback) end
		return Icon
	end

	local MenuVisible = false
	local function ToggleMenu()
		MenuVisible = not MenuVisible
		if MenuVisible then
			CmdMenu.Visible = true
			TweenService:Create(CmdMenu, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, 250, 0, 180)}):Play()
		else
			TweenService:Create(CmdMenu, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, 250, 0, 0)}):Play()
			task.wait(0.4)
			if not MenuVisible then CmdMenu.Visible = false end
		end
	end

	CreateIcon("rbxassetid://10734898156", ToggleMenu)
	CreateIcon("rbxassetid://10734913301")
	CreateIcon("rbxassetid://10734950309")

	local Expanded = false
	local function ToggleIsland(state)
		Expanded = state
		if state then
			Content.Visible = true
			TweenService:Create(Island, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
				Size = UDim2.new(0, 480, 0, 50),
				Position = UDim2.new(0.5, -240, 0, 15)
			}):Play()
			TweenService:Create(IslandCorner, TweenInfo.new(0.6), {CornerRadius = UDim.new(0, 15)}):Play()
		else
			TweenService:Create(Island, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
				Size = UDim2.new(0, 50, 0, 50),
				Position = UDim2.new(0.5, -25, 0, 15)
			}):Play()
			TweenService:Create(IslandCorner, TweenInfo.new(0.6), {CornerRadius = UDim.new(0, 25)}):Play()
			task.wait(0.6)
			if not Expanded then Content.Visible = false end
		end
	end

	Island.MouseEnter:Connect(function() ToggleIsland(true) end)
	Island.MouseLeave:Connect(function() ToggleIsland(false) end)

	local NotifyFrame = Instance.new("Frame")
	NotifyFrame.Name = "NotifyFrame"
	NotifyFrame.Size = UDim2.new(0, 280, 0, 70)
	NotifyFrame.Position = UDim2.new(0.5, -140, 0, -200)
	NotifyFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	NotifyFrame.BackgroundTransparency = 0.1
	NotifyFrame.BorderSizePixel = 0
	NotifyFrame.Parent = ScreenGui

	local NotifyCorner = Instance.new("UICorner")
	NotifyCorner.CornerRadius = UDim.new(0, 12)
	NotifyCorner.Parent = NotifyFrame

	local NotifyStroke = Instance.new("UIStroke")
	NotifyStroke.Color = Color3.fromRGB(255, 255, 255)
	NotifyStroke.Transparency = 0.9
	NotifyStroke.Parent = NotifyFrame

	local WelcomeText = Instance.new("TextLabel")
	WelcomeText.Size = UDim2.new(1, 0, 1, 0)
	WelcomeText.BackgroundTransparency = 1
	WelcomeText.Text = "Welcome to Lunar Admin"
	WelcomeText.TextColor3 = Color3.fromRGB(255, 255, 255)
	WelcomeText.FontFace = GetFont()
	WelcomeText.TextSize = 14
	WelcomeText.Parent = NotifyFrame

	task.spawn(function()
		task.wait(1.5)
		TweenService:Create(NotifyFrame, TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -140, 0, 85)}):Play()
		task.wait(4)
		TweenService:Create(NotifyFrame, TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Position = UDim2.new(0.5, -140, 0, -200)}):Play()
	end)

	RunService.RenderStepped:Connect(function()
		FPSLabel.Text = "FPS: " .. math.floor(1/RunService.RenderStepped:Wait())
		PingLabel.Text = "PING: " .. math.floor(Player:GetNetworkPing() * 1000) .. "ms"
	end)
end

return UI

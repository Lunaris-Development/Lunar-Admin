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
	LogoImg.Size = UDim2.new(0, 36, 0, 36)
	LogoImg.Position = UDim2.new(0, 7, 0, 7)
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
	Info.Size = UDim2.new(0, 160, 1, 0)
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
	Stats.Size = UDim2.new(0, 130, 1, 0)
	Stats.Position = UDim2.new(0, 170, 0, 0)
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
	Icons.Size = UDim2.new(1, -310, 1, 0)
	Icons.Position = UDim2.new(0, 310, 0, 0)
	Icons.BackgroundTransparency = 1
	Icons.Parent = Content

	local UIList = Instance.new("UIListLayout")
	UIList.FillDirection = Enum.FillDirection.Horizontal
	UIList.HorizontalAlignment = Enum.HorizontalAlignment.Right
	UIList.VerticalAlignment = Enum.VerticalAlignment.Center
	UIList.Padding = UDim.new(0, 20)
	UIList.Parent = Icons
	
	local UIPadding = Instance.new("UIPadding")
	UIPadding.PaddingRight = UDim.new(0, 15)
	UIPadding.Parent = Icons

	local function CreateMenu(name, size)
		local Menu = Instance.new("Frame")
		Menu.Name = name
		Menu.Size = UDim2.new(0, size.X, 0, 0)
		Menu.Position = UDim2.new(0.5, -size.X/2, 0, 75)
		Menu.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
		Menu.BackgroundTransparency = 0.15
		Menu.BorderSizePixel = 0
		Menu.ClipsDescendants = true
		Menu.Visible = false
		Menu.Parent = ScreenGui
		Instance.new("UICorner", Menu).CornerRadius = UDim.new(0, 12)
		local Stroke = Instance.new("UIStroke", Menu)
		Stroke.Color = Color3.fromRGB(255, 255, 255)
		Stroke.Transparency = 0.85
		Stroke.Thickness = 1.2
		local List = Instance.new("UIListLayout", Menu)
		List.Padding = UDim.new(0, 5)
		local Padding = Instance.new("UIPadding", Menu)
		Padding.PaddingTop = UDim.new(0, 10)
		Padding.PaddingBottom = UDim.new(0, 10)
		Padding.PaddingLeft = UDim.new(0, 10)
		Padding.PaddingRight = UDim.new(0, 10)
		return Menu
	end

	local CmdMenu = CreateMenu("CmdMenu", Vector2.new(250, 0))
	local SettingsMenu = CreateMenu("SettingsMenu", Vector2.new(250, 0))

	local function CreateBtn(parent, name, callback)
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
		Btn.Parent = parent
		Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
		Btn.MouseEnter:Connect(function() TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.85, TextColor3 = Color3.fromRGB(255, 255, 255)}):Play() end)
		Btn.MouseLeave:Connect(function() TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.95, TextColor3 = Color3.fromRGB(200, 200, 200)}):Play() end)
		Btn.MouseButton1Click:Connect(callback)
	end

	CreateBtn(CmdMenu, "WalkSpeed (50)", function() Player.Character.Humanoid.WalkSpeed = 50 end)
	CreateBtn(CmdMenu, "JumpPower (100)", function() Player.Character.Humanoid.JumpPower = 100 end)
	
	CreateBtn(SettingsMenu, "Toggle Tags", function() print("Tags toggled") end)
	CreateBtn(SettingsMenu, "Unload Script", function() ScreenGui:Destroy() end)

	local ConsoleFrame = Instance.new("Frame")
	ConsoleFrame.Name = "ConsoleFrame"
	ConsoleFrame.Size = UDim2.new(0, 400, 0, 0)
	ConsoleFrame.Position = UDim2.new(0.5, -200, 0, 75)
	ConsoleFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	ConsoleFrame.BackgroundTransparency = 0.15
	ConsoleFrame.BorderSizePixel = 0
	ConsoleFrame.ClipsDescendants = true
	ConsoleFrame.Visible = false
	ConsoleFrame.Parent = ScreenGui
	Instance.new("UICorner", ConsoleFrame).CornerRadius = UDim.new(0, 10)
	local ConsoleStroke = Instance.new("UIStroke", ConsoleFrame)
	ConsoleStroke.Color = Color3.fromRGB(255, 255, 255)
	ConsoleStroke.Transparency = 0.85
	ConsoleStroke.Thickness = 1.2
	local ConsoleInput = Instance.new("TextBox")
	ConsoleInput.Name = "ConsoleInput"
	ConsoleInput.Size = UDim2.new(1, -20, 1, -20)
	ConsoleInput.Position = UDim2.new(0, 10, 0, 10)
	ConsoleInput.BackgroundTransparency = 1
	ConsoleInput.Text = ""
	ConsoleInput.PlaceholderText = "Enter command..."
	ConsoleInput.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
	ConsoleInput.TextColor3 = Color3.fromRGB(255, 255, 255)
	ConsoleInput.FontFace = GetFont()
	ConsoleInput.TextSize = 14
	ConsoleInput.TextXAlignment = Enum.TextXAlignment.Left
	ConsoleInput.Parent = ConsoleFrame

	local function CreateIcon(id, callback)
		local Icon = Instance.new("ImageButton")
		Icon.Size = UDim2.new(0, 24, 0, 24)
		Icon.BackgroundTransparency = 1
		Icon.Image = id
		Icon.ImageColor3 = Color3.fromRGB(200, 200, 200)
		Icon.Parent = Icons
		Icon.MouseEnter:Connect(function() TweenService:Create(Icon, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(255, 255, 255)}):Play() end)
		Icon.MouseLeave:Connect(function() TweenService:Create(Icon, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(200, 200, 200)}):Play() end)
		if callback then Icon.MouseButton1Click:Connect(callback) end
		return Icon
	end

	local function AnimateMenu(menu, targetHeight)
		if menu.Size.Y.Offset == 0 then
			menu.Visible = true
			TweenService:Create(menu, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, menu.Size.X.Offset, 0, targetHeight)}):Play()
		else
			TweenService:Create(menu, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, menu.Size.X.Offset, 0, 0)}):Play()
			task.wait(0.4)
			if menu.Size.Y.Offset == 0 then menu.Visible = false end
		end
	end

	CreateIcon("rbxassetid://10734898156", function() AnimateMenu(CmdMenu, 120) end)
	CreateIcon("rbxassetid://10734913301", function() 
		if ConsoleFrame.Size.Y.Offset == 0 then
			ConsoleFrame.Visible = true
			TweenService:Create(ConsoleFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, 400, 0, 45)}):Play()
			task.wait(0.4)
			ConsoleInput:CaptureFocus()
		else
			ConsoleInput:ReleaseFocus()
			TweenService:Create(ConsoleFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, 400, 0, 0)}):Play()
			task.wait(0.4)
			ConsoleFrame.Visible = false
		end
	end)
	CreateIcon("rbxassetid://10734950309", function() AnimateMenu(SettingsMenu, 120) end)

	ConsoleInput.FocusLost:Connect(function(enter)
		if enter then
			ConsoleInput.Text = ""
			TweenService:Create(ConsoleFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, 400, 0, 0)}):Play()
			task.wait(0.4)
			ConsoleFrame.Visible = false
		end
	end)

	local Expanded = false
	local function ToggleIsland(state)
		Expanded = state
		if state then
			Content.Visible = true
			TweenService:Create(Island, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
				Size = UDim2.new(0, 520, 0, 50),
				Position = UDim2.new(0.5, -260, 0, 15)
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
	NotifyCorner.CornerRadius = UDim.new(0, 10)
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

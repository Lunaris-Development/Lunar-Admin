local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local LogoID = "rbxassetid://95343151225680"

local UI = {}

function UI.Init()
	if game.CoreGui:FindFirstChild("LunarAdminTopBar") then
		game.CoreGui:FindFirstChild("LunarAdminTopBar"):Destroy()
	end

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "LunarAdminTopBar"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.Parent = game.CoreGui

	local TopBar = Instance.new("Frame")
	TopBar.Name = "TopBar"
	TopBar.Size = UDim2.new(0, 500, 0, 45)
	TopBar.Position = UDim2.new(0.5, -250, 0, 10)
	TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	TopBar.BackgroundTransparency = 0.2
	TopBar.BorderSizePixel = 0
	TopBar.Parent = ScreenGui

	local BarCorner = Instance.new("UICorner")
	BarCorner.CornerRadius = UDim.new(0, 8)
	BarCorner.Parent = TopBar

	local BarStroke = Instance.new("UIStroke")
	BarStroke.Color = Color3.fromRGB(255, 255, 255)
	BarStroke.Transparency = 0.9
	BarStroke.Thickness = 1
	BarStroke.Parent = TopBar

	local LogoContainer = Instance.new("Frame")
	LogoContainer.Name = "LogoContainer"
	LogoContainer.Size = UDim2.new(0, 45, 0, 45)
	LogoContainer.Position = UDim2.new(0, -55, 0, 0)
	LogoContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	LogoContainer.BackgroundTransparency = 0.2
	LogoContainer.Parent = TopBar

	local LogoCorner = Instance.new("UICorner")
	LogoCorner.CornerRadius = UDim.new(0, 8)
	LogoCorner.Parent = LogoContainer

	local LogoImg = Instance.new("ImageLabel")
	LogoImg.Size = UDim2.new(0.7, 0, 0.7, 0)
	LogoImg.Position = UDim2.new(0.15, 0, 0.15, 0)
	LogoImg.BackgroundTransparency = 1
	LogoImg.Image = LogoID
	LogoImg.Parent = LogoContainer

	local StatsFrame = Instance.new("Frame")
	StatsFrame.Size = UDim2.new(0, 120, 1, 0)
	StatsFrame.BackgroundTransparency = 1
	StatsFrame.Parent = TopBar

	local FPSLabel = Instance.new("TextLabel")
	FPSLabel.Size = UDim2.new(1, 0, 0.5, 0)
	FPSLabel.Position = UDim2.new(0, 15, 0, 5)
	FPSLabel.BackgroundTransparency = 1
	FPSLabel.Text = "FPS: 0"
	FPSLabel.TextColor3 = Color3.fromRGB(150, 255, 150)
	FPSLabel.Font = Enum.Font.GothamBold
	FPSLabel.TextSize = 10
	FPSLabel.TextXAlignment = Enum.TextXAlignment.Left
	FPSLabel.Parent = StatsFrame

	local PingLabel = Instance.new("TextLabel")
	PingLabel.Size = UDim2.new(1, 0, 0.5, 0)
	PingLabel.Position = UDim2.new(0, 15, 0.5, -5)
	PingLabel.BackgroundTransparency = 1
	PingLabel.Text = "PING: 0ms"
	PingLabel.TextColor3 = Color3.fromRGB(150, 200, 255)
	PingLabel.Font = Enum.Font.GothamBold
	PingLabel.TextSize = 10
	PingLabel.TextXAlignment = Enum.TextXAlignment.Left
	PingLabel.Parent = StatsFrame

	local IconsContainer = Instance.new("Frame")
	IconsContainer.Size = UDim2.new(1, -130, 1, 0)
	IconsContainer.Position = UDim2.new(0, 130, 0, 0)
	IconsContainer.BackgroundTransparency = 1
	IconsContainer.Parent = TopBar

	local UIList = Instance.new("UIListLayout")
	UIList.FillDirection = Enum.FillDirection.Horizontal
	UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIList.VerticalAlignment = Enum.VerticalAlignment.Center
	UIList.Padding = UDim.new(0, 20)
	UIList.Parent = IconsContainer

	local function CreateIcon(id)
		local Icon = Instance.new("ImageButton")
		Icon.Size = UDim2.new(0, 22, 0, 22)
		Icon.BackgroundTransparency = 1
		Icon.Image = id
		Icon.ImageColor3 = Color3.fromRGB(200, 200, 200)
		Icon.Parent = IconsContainer
		Icon.MouseEnter:Connect(function()
			TweenService:Create(Icon, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(255, 255, 255)}):Play()
		end)
		Icon.MouseLeave:Connect(function()
			TweenService:Create(Icon, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(200, 200, 200)}):Play()
		end)
		return Icon
	end

	CreateIcon("rbxassetid://10734898156")
	CreateIcon("rbxassetid://10734913301")
	CreateIcon("rbxassetid://10734924531")
	CreateIcon("rbxassetid://10734950309")

	local NotifyFrame = Instance.new("Frame")
	NotifyFrame.Name = "NotifyFrame"
	NotifyFrame.Size = UDim2.new(0, 300, 0, 80)
	NotifyFrame.Position = UDim2.new(0.5, -150, 0, -100)
	NotifyFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	NotifyFrame.BackgroundTransparency = 0.2
	NotifyFrame.BorderSizePixel = 0
	NotifyFrame.Parent = ScreenGui

	local NotifyCorner = Instance.new("UICorner")
	NotifyCorner.CornerRadius = UDim.new(0, 12)
	NotifyCorner.Parent = NotifyFrame

	local NotifyStroke = Instance.new("UIStroke")
	NotifyStroke.Color = Color3.fromRGB(255, 255, 255)
	NotifyStroke.Transparency = 0.9
	NotifyStroke.Parent = NotifyFrame

	local NotifyTitle = Instance.new("TextLabel")
	NotifyTitle.Size = UDim2.new(1, -20, 0, 30)
	NotifyTitle.Position = UDim2.new(0, 15, 0, 10)
	NotifyTitle.BackgroundTransparency = 1
	NotifyTitle.Text = "LUNAR ADMIN"
	NotifyTitle.TextColor3 = Color3.fromRGB(150, 150, 150)
	NotifyTitle.Font = Enum.Font.GothamBold
	NotifyTitle.TextSize = 10
	NotifyTitle.TextXAlignment = Enum.TextXAlignment.Left
	NotifyTitle.Parent = NotifyFrame

	local WelcomeText = Instance.new("TextLabel")
	WelcomeText.Size = UDim2.new(1, -20, 0, 30)
	WelcomeText.Position = UDim2.new(0, 15, 0, 25)
	WelcomeText.BackgroundTransparency = 1
	WelcomeText.Text = "Welcome to LUNAR ADMIN"
	WelcomeText.TextColor3 = Color3.fromRGB(255, 255, 255)
	WelcomeText.Font = Enum.Font.GothamBold
	WelcomeText.TextSize = 16
	WelcomeText.TextXAlignment = Enum.TextXAlignment.Left
	WelcomeText.Parent = NotifyFrame

	task.spawn(function()
		NotifyFrame.Position = UDim2.new(0.5, -150, 0, -100)
		TweenService:Create(NotifyFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -150, 0, 70)}):Play()
		task.wait(4)
		TweenService:Create(NotifyFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Position = UDim2.new(0.5, -150, 0, -100)}):Play()
	end)

	RunService.RenderStepped:Connect(function()
		FPSLabel.Text = "FPS: " .. math.floor(1/RunService.RenderStepped:Wait())
		PingLabel.Text = "PING: " .. Player:GetNetworkPing() * 1000 .. "ms"
	end)
end

return UI

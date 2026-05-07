local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local LogoID = "rbxthumb://type=Asset&id=73819038719454&w=420&h=420"
local Executor = (identifyexecutor and identifyexecutor()) or (getexecutorname and getexecutorname()) or "Unknown"

local function GetFont() return Font.fromEnum(Enum.Font.GothamMedium) end
local function GetFontBold() return Font.fromEnum(Enum.Font.GothamBold) end

local UI = {}

function UI.Init(Nametags, Commands, ESP)
	local isMobile = UserInputService.TouchEnabled

	if game.CoreGui:FindFirstChild("LunarDynamicIsland") then
		game.CoreGui:FindFirstChild("LunarDynamicIsland"):Destroy()
	end

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "LunarDynamicIsland"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.Parent = game.CoreGui

	local function CreateWindow(title, w, contentH)
		local Win = Instance.new("TextButton")
		Win.Size = UDim2.new(0, w, 0, contentH + 40)
		Win.Position = UDim2.new(0.5, -w / 2, 0, 80)
		Win.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
		Win.BackgroundTransparency = 0.04
		Win.BorderSizePixel = 0
		Win.Visible = false
		Win.ZIndex = 20
		Win.Text = ""
		Win.AutoButtonColor = false
		Win.SelectionImageObject = Instance.new("Frame")
		Win.Parent = ScreenGui
		Instance.new("UICorner", Win).CornerRadius = UDim.new(0, 12)
		local WinStroke = Instance.new("UIStroke", Win)
		WinStroke.Color = Color3.fromRGB(255, 255, 255)
		WinStroke.Transparency = 0.87
		WinStroke.Thickness = 1

		local TBar = Instance.new("Frame", Win)
		TBar.Size = UDim2.new(1, 0, 0, 40)
		TBar.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
		TBar.BackgroundTransparency = 0
		TBar.BorderSizePixel = 0
		TBar.ZIndex = 21
		Instance.new("UICorner", TBar).CornerRadius = UDim.new(0, 12)
		local TBarFill = Instance.new("Frame", TBar)
		TBarFill.Size = UDim2.new(1, 0, 0, 12)
		TBarFill.Position = UDim2.new(0, 0, 1, -12)
		TBarFill.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
		TBarFill.BorderSizePixel = 0

		local TBarLine = Instance.new("Frame", Win)
		TBarLine.Size = UDim2.new(1, -24, 0, 1)
		TBarLine.Position = UDim2.new(0, 12, 0, 40)
		TBarLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TBarLine.BackgroundTransparency = 0.9
		TBarLine.BorderSizePixel = 0
		TBarLine.ZIndex = 21

		local TitleLbl = Instance.new("TextLabel", TBar)
		TitleLbl.Size = UDim2.new(1, -80, 1, 0)
		TitleLbl.Position = UDim2.new(0, 14, 0, 0)
		TitleLbl.BackgroundTransparency = 1
		TitleLbl.Text = title
		TitleLbl.TextColor3 = Color3.fromRGB(210, 210, 210)
		TitleLbl.FontFace = GetFontBold()
		TitleLbl.TextSize = 12
		TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
		TitleLbl.ZIndex = 22

		local Lights = Instance.new("Frame", TBar)
		Lights.Size = UDim2.new(0, 38, 0, 14)
		Lights.Position = UDim2.new(1, -50, 0.5, -7)
		Lights.BackgroundTransparency = 1
		Lights.ZIndex = 22
		local LightsLayout = Instance.new("UIListLayout", Lights)
		LightsLayout.FillDirection = Enum.FillDirection.Horizontal
		LightsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
		LightsLayout.Padding = UDim.new(0, 8)

		local function MakeLight(color)
			local L = Instance.new("TextButton", Lights)
			L.Size = UDim2.new(0, 13, 0, 13)
			L.BackgroundColor3 = color
			L.Text = ""
			L.AutoButtonColor = false
			L.ZIndex = 23
			Instance.new("UICorner", L).CornerRadius = UDim.new(1, 0)
			return L
		end

		local MinBtn = MakeLight(Color3.fromRGB(255, 189, 68))
		local CloseBtn = MakeLight(Color3.fromRGB(255, 95, 87))

		local Content = Instance.new("Frame", Win)
		Content.Size = UDim2.new(1, 0, 1, -41)
		Content.Position = UDim2.new(0, 0, 0, 41)
		Content.BackgroundTransparency = 1
		Content.ClipsDescendants = true
		Content.ZIndex = 20
		local ContentList = Instance.new("UIListLayout", Content)
		ContentList.Padding = UDim.new(0, 6)
		local ContentPad = Instance.new("UIPadding", Content)
		ContentPad.PaddingTop = UDim.new(0, 10)
		ContentPad.PaddingBottom = UDim.new(0, 10)
		ContentPad.PaddingLeft = UDim.new(0, 10)
		ContentPad.PaddingRight = UDim.new(0, 10)

		local minimized = false
		MinBtn.MouseButton1Click:Connect(function()
			minimized = not minimized
			Content.Visible = not minimized
			TweenService:Create(Win, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
				Size = UDim2.new(0, w, 0, minimized and 40 or contentH + 40)
			}):Play()
		end)
		CloseBtn.MouseButton1Click:Connect(function()
			Win.Visible = false
			minimized = false
			Content.Visible = true
			Win.Size = UDim2.new(0, w, 0, contentH + 40)
		end)

		local dragging, dragInput, dragStart, startPos = false, nil, nil, nil
		TBar.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				dragStart = input.Position
				startPos = Win.Position
				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then dragging = false end
				end)
			end
		end)
		TBar.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				dragInput = input
			end
		end)
		UserInputService.InputChanged:Connect(function(input)
			if input == dragInput and dragging then
				local d = input.Position - dragStart
				Win.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
			end
		end)

		local function Toggle()
			Win.Visible = not Win.Visible
		end

		return Win, Content, Toggle
	end

	local Island = Instance.new("Frame")
	Island.Name = "Island"
	Island.Size = UDim2.new(0, 50, 0, 50)
	Island.Position = UDim2.new(0.5, -25, 0, 15)
	Island.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
	Island.BackgroundTransparency = 0.35
	Island.BorderSizePixel = 0
	Island.ClipsDescendants = true
	Island.Parent = ScreenGui
	local IslandCorner = Instance.new("UICorner", Island)
	IslandCorner.CornerRadius = UDim.new(0, 25)
	local IslandStroke = Instance.new("UIStroke", Island)
	IslandStroke.Color = Color3.fromRGB(255, 255, 255)
	IslandStroke.Transparency = 0.82
	IslandStroke.Thickness = 1.5

	local LogoImg = Instance.new("ImageLabel", Island)
	LogoImg.Size = UDim2.new(0, 36, 0, 36)
	LogoImg.Position = UDim2.new(0, 7, 0, 7)
	LogoImg.BackgroundTransparency = 1
	LogoImg.Image = LogoID
	LogoImg.ScaleType = Enum.ScaleType.Fit
	local LogoGlow = Instance.new("ImageLabel", LogoImg)
	LogoGlow.Size = UDim2.new(1.5, 0, 1.5, 0)
	LogoGlow.Position = UDim2.new(-0.25, 0, -0.25, 0)
	LogoGlow.BackgroundTransparency = 1
	LogoGlow.Image = "rbxassetid://6015538162"
	LogoGlow.ImageColor3 = Color3.fromRGB(255, 255, 255)
	LogoGlow.ImageTransparency = 0.85
	task.spawn(function()
		while ScreenGui.Parent do
			TweenService:Create(LogoGlow, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {ImageTransparency = 0.6}):Play()
			task.wait(1.5)
			TweenService:Create(LogoGlow, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {ImageTransparency = 0.85}):Play()
			task.wait(1.5)
		end
	end)

	local Content = Instance.new("Frame", Island)
	Content.Size = UDim2.new(1, -55, 1, 0)
	Content.Position = UDim2.new(0, 55, 0, 0)
	Content.BackgroundTransparency = 1
	Content.Visible = false

	local Info = Instance.new("Frame", Content)
	Info.Size = UDim2.new(0, 105, 1, 0)
	Info.BackgroundTransparency = 1
	local TitleLbl = Instance.new("TextLabel", Info)
	TitleLbl.Size = UDim2.new(1, 0, 0, 28)
	TitleLbl.Position = UDim2.new(0, 0, 0, 7)
	TitleLbl.BackgroundTransparency = 1
	TitleLbl.Text = "Lunar Admin"
	TitleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
	TitleLbl.FontFace = GetFontBold()
	TitleLbl.TextSize = 14
	TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
	local ExecLbl = Instance.new("TextLabel", Info)
	ExecLbl.Size = UDim2.new(1, 0, 0, 14)
	ExecLbl.Position = UDim2.new(0, 0, 0, 27)
	ExecLbl.BackgroundTransparency = 1
	ExecLbl.Text = Executor
	ExecLbl.TextColor3 = Color3.fromRGB(130, 130, 130)
	ExecLbl.FontFace = GetFont()
	ExecLbl.TextSize = 10
	ExecLbl.TextXAlignment = Enum.TextXAlignment.Left

	local Stats = Instance.new("Frame", Content)
	Stats.Size = UDim2.new(0, 90, 1, 0)
	Stats.Position = UDim2.new(0, 112, 0, 0)
	Stats.BackgroundTransparency = 1
	local FPSLabel = Instance.new("TextLabel", Stats)
	FPSLabel.Size = UDim2.new(1, 0, 0.5, 0)
	FPSLabel.Position = UDim2.new(0, 0, 0, 6)
	FPSLabel.BackgroundTransparency = 1
	FPSLabel.Text = "FPS: 0"
	FPSLabel.TextColor3 = Color3.fromRGB(120, 255, 140)
	FPSLabel.FontFace = GetFont()
	FPSLabel.TextSize = 10
	FPSLabel.TextXAlignment = Enum.TextXAlignment.Left
	local PingLabel = Instance.new("TextLabel", Stats)
	PingLabel.Size = UDim2.new(1, 0, 0.5, 0)
	PingLabel.Position = UDim2.new(0, 0, 0.5, -2)
	PingLabel.BackgroundTransparency = 1
	PingLabel.Text = "PING: 0ms"
	PingLabel.TextColor3 = Color3.fromRGB(100, 180, 255)
	PingLabel.FontFace = GetFont()
	PingLabel.TextSize = 10
	PingLabel.TextXAlignment = Enum.TextXAlignment.Left

	local Icons = Instance.new("Frame", Content)
	Icons.Size = UDim2.new(1, -210, 1, 0)
	Icons.Position = UDim2.new(0, 210, 0, 0)
	Icons.BackgroundTransparency = 1
	local UIList = Instance.new("UIListLayout", Icons)
	UIList.FillDirection = Enum.FillDirection.Horizontal
	UIList.HorizontalAlignment = Enum.HorizontalAlignment.Right
	UIList.VerticalAlignment = Enum.VerticalAlignment.Center
	UIList.Padding = UDim.new(0, 8)
	local IconsPad = Instance.new("UIPadding", Icons)
	IconsPad.PaddingRight = UDim.new(0, 14)

	local Console = Instance.new("Frame", ScreenGui)
	Console.Size = UDim2.new(0, 500, 0, 40)
	Console.Position = UDim2.new(0.5, -250, 1, 50)
	Console.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
	Console.BackgroundTransparency = 0.15
	Console.BorderSizePixel = 0
	Instance.new("UICorner", Console).CornerRadius = UDim.new(0, 8)
	local ConsoleStroke = Instance.new("UIStroke", Console)
	ConsoleStroke.Color = Color3.fromRGB(150, 255, 150)
	ConsoleStroke.Transparency = 0.75
	local ConsoleLayout = Instance.new("UIListLayout", Console)
	ConsoleLayout.FillDirection = Enum.FillDirection.Horizontal
	ConsoleLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	ConsoleLayout.Padding = UDim.new(0, 4)
	local ConsolePad = Instance.new("UIPadding", Console)
	ConsolePad.PaddingLeft = UDim.new(0, 12)
	local Prompt = Instance.new("TextLabel", Console)
	Prompt.Size = UDim2.new(0, 0, 1, 0)
	Prompt.BackgroundTransparency = 1
	Prompt.Text = Player.Name .. " ❯"
	Prompt.TextColor3 = Color3.fromRGB(120, 255, 140)
	Prompt.FontFace = GetFont()
	Prompt.TextSize = 12
	Prompt.TextXAlignment = Enum.TextXAlignment.Left
	Prompt.AutomaticSize = Enum.AutomaticSize.X
	local ConsoleInput = Instance.new("TextBox", Console)
	ConsoleInput.Size = UDim2.new(1, -150, 1, 0)
	ConsoleInput.BackgroundTransparency = 1
	ConsoleInput.Text = ""
	ConsoleInput.PlaceholderText = "command..."
	ConsoleInput.PlaceholderColor3 = Color3.fromRGB(80, 80, 80)
	ConsoleInput.TextColor3 = Color3.fromRGB(255, 255, 255)
	ConsoleInput.FontFace = GetFont()
	ConsoleInput.TextSize = 12
	ConsoleInput.TextXAlignment = Enum.TextXAlignment.Left

	local function ToggleConsole()
		local t = Console.Position.Y.Offset == -60 and 50 or -60
		TweenService:Create(Console, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -250, 1, t)}):Play()
		if t == -60 then task.wait(0.1) ConsoleInput:CaptureFocus() end
	end
	UserInputService.InputBegan:Connect(function(input, gpe)
		if not gpe and input.KeyCode == Enum.KeyCode.F2 then ToggleConsole() end
	end)
	ConsoleInput.FocusLost:Connect(function(enter)
		if enter then
			local msg = ConsoleInput.Text; ConsoleInput.Text = ""
			if Commands then Commands.HandleChat(msg, UI, ESP) end
		end
		ToggleConsole()
	end)

	local function CreateBtn(parent, label, callback)
		local Btn = Instance.new("TextButton", parent)
		Btn.Name = label
		Btn.Size = UDim2.new(1, 0, 0, 36)
		Btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Btn.BackgroundTransparency = 0.94
		Btn.Text = "  " .. label
		Btn.TextColor3 = Color3.fromRGB(195, 195, 195)
		Btn.FontFace = GetFont()
		Btn.TextSize = 12
		Btn.TextXAlignment = Enum.TextXAlignment.Left
		Btn.AutoButtonColor = false
		Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 7)
		Btn.MouseEnter:Connect(function() TweenService:Create(Btn, TweenInfo.new(0.15), {BackgroundTransparency = 0.84, TextColor3 = Color3.fromRGB(255, 255, 255)}):Play() end)
		Btn.MouseLeave:Connect(function() TweenService:Create(Btn, TweenInfo.new(0.15), {BackgroundTransparency = 0.94, TextColor3 = Color3.fromRGB(195, 195, 195)}):Play() end)
		if callback then Btn.MouseButton1Click:Connect(callback) end
		return Btn
	end

	local CmdWin, CmdContent, ToggleCmdWin = CreateWindow("Commands", 290, 300)
	local EspWin, EspContent, ToggleEspWin = CreateWindow("ESP Settings", 240, 280)
	local SpeedWin, SpeedContent, ToggleSpeedWin = CreateWindow("Speed Control", 268, 228)
	local SettingsWin, SettingsContent, ToggleSettingsWin = CreateWindow("Settings", 230, 90)
	local TPWin, TPContent, ToggleTPWin = CreateWindow("Teleport", 268, 320)

	local SearchBox = Instance.new("TextBox", CmdContent)
	SearchBox.Size = UDim2.new(1, 0, 0, 34)
	SearchBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	SearchBox.BackgroundTransparency = 0.3
	SearchBox.PlaceholderText = "  Search..."
	SearchBox.Text = ""
	SearchBox.TextColor3 = Color3.fromRGB(220, 220, 220)
	SearchBox.PlaceholderColor3 = Color3.fromRGB(90, 90, 90)
	SearchBox.FontFace = GetFont()
	SearchBox.TextSize = 12
	Instance.new("UICorner", SearchBox).CornerRadius = UDim.new(0, 7)
	local SBPad = Instance.new("UIPadding", SearchBox)
	SBPad.PaddingLeft = UDim.new(0, 8)

	local CmdScroll = Instance.new("ScrollingFrame", CmdContent)
	CmdScroll.Size = UDim2.new(1, 0, 0, 240)
	CmdScroll.BackgroundTransparency = 1
	CmdScroll.BorderSizePixel = 0
	CmdScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	CmdScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
	CmdScroll.ScrollBarThickness = 2
	CmdScroll.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
	local CmdList = Instance.new("UIListLayout", CmdScroll)
	CmdList.Padding = UDim.new(0, 4)

	local btns = {}
	local cmdDefs = {
		{"Fly Toggle", "fly"}, {"Freecam Toggle", "fc"}, {"ESP Toggle", "esp"},
		{"Noclip", "noclip"}, {"Inf Jump", "infjump"}, {"God Mode", "god"},
		{"Anti AFK", "antiafk"}, {"Touch Fling", "touchfling"}, {"Lag Spoof", "lag"},
		{"Loop Speed", "loopspeed 50"}, {"Server Info", "serverinfo"}, {"Server List", "serverh"},
		{"Show Low HP", "shlow"}, {"Show Most HP", "shmost"}, {"Click TP", "ftpmobile"},
		{"User Spoofer", "userspoofer player"}, {"Speed (50)", "ws 50"}, {"Reset Speed", "ws 16"},
	}
	for _, def in ipairs(cmdDefs) do
		local b = CreateBtn(CmdScroll, def[1], function()
			if Commands then Commands.HandleChat(def[2], UI, ESP) end
		end)
		table.insert(btns, b)
	end
	CreateBtn(CmdScroll, "Teleport to Player", function() ToggleTPWin() end)

	SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
		local q = SearchBox.Text:lower()
		for _, b in pairs(btns) do b.Visible = b.Name:lower():find(q) ~= nil end
	end)

	local function CreateToggleRow(parent, label, feature)
		local Row = Instance.new("TextButton", parent)
		Row.Size = UDim2.new(1, 0, 0, 38)
		Row.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Row.BackgroundTransparency = 0.94
		Row.Text = ""
		Row.AutoButtonColor = false
		Instance.new("UICorner", Row).CornerRadius = UDim.new(0, 7)
		local Dot = Instance.new("Frame", Row)
		Dot.Size = UDim2.new(0, 8, 0, 8)
		Dot.Position = UDim2.new(0, 12, 0.5, -4)
		Dot.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
		Dot.BorderSizePixel = 0
		Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)
		local Lbl = Instance.new("TextLabel", Row)
		Lbl.Size = UDim2.new(1, -28, 1, 0)
		Lbl.Position = UDim2.new(0, 28, 0, 0)
		Lbl.BackgroundTransparency = 1
		Lbl.Text = label
		Lbl.TextColor3 = Color3.fromRGB(155, 155, 155)
		Lbl.FontFace = GetFont()
		Lbl.TextSize = 12
		Lbl.TextXAlignment = Enum.TextXAlignment.Left
		local function refresh(on)
			Dot.BackgroundColor3 = on and Color3.fromRGB(0, 220, 130) or Color3.fromRGB(70, 70, 70)
			Lbl.TextColor3 = on and Color3.fromRGB(230, 230, 230) or Color3.fromRGB(155, 155, 155)
			TweenService:Create(Row, TweenInfo.new(0.15), {BackgroundTransparency = on and 0.87 or 0.94}):Play()
		end
		refresh(ESP and ESP.Settings and ESP.Settings[feature] or false)
		Row.MouseButton1Click:Connect(function()
			if not ESP then return end
			local s = not (ESP.Settings and ESP.Settings[feature])
			ESP.ToggleFeature(feature, s); refresh(s)
		end)
		Row.MouseEnter:Connect(function() TweenService:Create(Row, TweenInfo.new(0.12), {BackgroundTransparency = 0.86}):Play() end)
		Row.MouseLeave:Connect(function()
			local s = ESP and ESP.Settings and ESP.Settings[feature]
			TweenService:Create(Row, TweenInfo.new(0.12), {BackgroundTransparency = s and 0.87 or 0.94}):Play()
		end)
	end

	CreateBtn(EspContent, "Enable / Disable ESP", function()
		if not ESP then return end
		ESP.Toggle(not ESP.Enabled)
		UI.Notify("ESP " .. (ESP.Enabled and "ON" or "OFF"), ESP.Enabled and "Success" or "Warn")
	end)
	local espDivFrame = Instance.new("Frame", EspContent)
	espDivFrame.Size = UDim2.new(1, 0, 0, 1)
	espDivFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	espDivFrame.BackgroundTransparency = 0.88
	espDivFrame.BorderSizePixel = 0
	CreateToggleRow(EspContent, "Highlights", "Highlights")
	CreateToggleRow(EspContent, "Box ESP", "Box")
	CreateToggleRow(EspContent, "HP Bars", "HP")
	CreateToggleRow(EspContent, "Skeleton", "Skeleton")
	CreateToggleRow(EspContent, "Names", "Names")

	local speedOn = false
	local speedVal = 50

	local SPToggle = Instance.new("TextButton", SpeedContent)
	SPToggle.Size = UDim2.new(1, 0, 0, 38)
	SPToggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	SPToggle.BackgroundTransparency = 0.94
	SPToggle.Text = "  ○  Speed Boost — OFF"
	SPToggle.TextColor3 = Color3.fromRGB(155, 155, 155)
	SPToggle.FontFace = GetFont()
	SPToggle.TextSize = 12
	SPToggle.TextXAlignment = Enum.TextXAlignment.Left
	SPToggle.AutoButtonColor = false
	Instance.new("UICorner", SPToggle).CornerRadius = UDim.new(0, 7)

	local spDivFrame = Instance.new("Frame", SpeedContent)
	spDivFrame.Size = UDim2.new(1, 0, 0, 1)
	spDivFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	spDivFrame.BackgroundTransparency = 0.88
	spDivFrame.BorderSizePixel = 0

	local SPValRow = Instance.new("Frame", SpeedContent)
	SPValRow.Size = UDim2.new(1, 0, 0, 22)
	SPValRow.BackgroundTransparency = 1
	local SPLabel = Instance.new("TextLabel", SPValRow)
	SPLabel.Size = UDim2.new(0.5, 0, 1, 0)
	SPLabel.BackgroundTransparency = 1
	SPLabel.Text = "Walk Speed"
	SPLabel.TextColor3 = Color3.fromRGB(110, 110, 110)
	SPLabel.FontFace = GetFont()
	SPLabel.TextSize = 11
	SPLabel.TextXAlignment = Enum.TextXAlignment.Left
	local SPValLbl = Instance.new("TextLabel", SPValRow)
	SPValLbl.Size = UDim2.new(0.5, 0, 1, 0)
	SPValLbl.Position = UDim2.new(0.5, 0, 0, 0)
	SPValLbl.BackgroundTransparency = 1
	SPValLbl.Text = "50"
	SPValLbl.TextColor3 = Color3.fromRGB(100, 170, 255)
	SPValLbl.FontFace = GetFontBold()
	SPValLbl.TextSize = 11
	SPValLbl.TextXAlignment = Enum.TextXAlignment.Right

	local SPSliderBack = Instance.new("Frame", SpeedContent)
	SPSliderBack.Size = UDim2.new(1, 0, 0, 10)
	SPSliderBack.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
	SPSliderBack.BorderSizePixel = 0
	Instance.new("UICorner", SPSliderBack).CornerRadius = UDim.new(0, 5)
	local SPFill = Instance.new("Frame", SPSliderBack)
	SPFill.Size = UDim2.new(speedVal / 300, 0, 1, 0)
	SPFill.BackgroundColor3 = Color3.fromRGB(100, 170, 255)
	SPFill.BorderSizePixel = 0
	Instance.new("UICorner", SPFill).CornerRadius = UDim.new(0, 5)
	local SPKnob = Instance.new("TextButton", SPSliderBack)
	SPKnob.Size = UDim2.new(0, 18, 0, 18)
	SPKnob.Position = UDim2.new(speedVal / 300, -9, 0.5, -9)
	SPKnob.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
	SPKnob.Text = ""
	SPKnob.AutoButtonColor = false
	Instance.new("UICorner", SPKnob).CornerRadius = UDim.new(1, 0)

	local SPPresetsFrame = Instance.new("Frame", SpeedContent)
	SPPresetsFrame.Size = UDim2.new(1, 0, 0, 30)
	SPPresetsFrame.BackgroundTransparency = 1
	local SPPresetList = Instance.new("UIListLayout", SPPresetsFrame)
	SPPresetList.FillDirection = Enum.FillDirection.Horizontal
	SPPresetList.Padding = UDim.new(0, 5)
	for _, v in ipairs({16, 50, 100, 200, 300}) do
		local pb = Instance.new("TextButton", SPPresetsFrame)
		pb.Size = UDim2.new(0, 42, 1, 0)
		pb.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
		pb.BackgroundTransparency = 0.3
		pb.Text = tostring(v)
		pb.TextColor3 = Color3.fromRGB(170, 170, 170)
		pb.FontFace = GetFont()
		pb.TextSize = 11
		pb.AutoButtonColor = false
		Instance.new("UICorner", pb).CornerRadius = UDim.new(0, 6)
		pb.MouseEnter:Connect(function() TweenService:Create(pb, TweenInfo.new(0.12), {BackgroundTransparency = 0, TextColor3 = Color3.fromRGB(255,255,255)}):Play() end)
		pb.MouseLeave:Connect(function() TweenService:Create(pb, TweenInfo.new(0.12), {BackgroundTransparency = 0.3, TextColor3 = Color3.fromRGB(170,170,170)}):Play() end)
		pb.MouseButton1Click:Connect(function()
			speedVal = v; SPValLbl.Text = tostring(v)
			local r = v / 300; SPFill.Size = UDim2.new(r, 0, 1, 0); SPKnob.Position = UDim2.new(r, -9, 0.5, -9)
			if speedOn and Commands then Commands.HandleChat("ws " .. v, UI, nil, true) end
		end)
	end

	local SPCustomRow = Instance.new("Frame", SpeedContent)
	SPCustomRow.Size = UDim2.new(1, 0, 0, 34)
	SPCustomRow.BackgroundTransparency = 1
	local SPInput = Instance.new("TextBox", SPCustomRow)
	SPInput.Size = UDim2.new(1, -52, 1, 0)
	SPInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	SPInput.BackgroundTransparency = 0.3
	SPInput.PlaceholderText = "Custom speed..."
	SPInput.Text = ""
	SPInput.TextColor3 = Color3.fromRGB(220, 220, 220)
	SPInput.PlaceholderColor3 = Color3.fromRGB(80, 80, 80)
	SPInput.FontFace = GetFont()
	SPInput.TextSize = 11
	Instance.new("UICorner", SPInput).CornerRadius = UDim.new(0, 7)
	local SPInputPad = Instance.new("UIPadding", SPInput); SPInputPad.PaddingLeft = UDim.new(0, 8)
	local SPSetBtn = Instance.new("TextButton", SPCustomRow)
	SPSetBtn.Size = UDim2.new(0, 44, 1, 0)
	SPSetBtn.Position = UDim2.new(1, -44, 0, 0)
	SPSetBtn.BackgroundColor3 = Color3.fromRGB(100, 170, 255)
	SPSetBtn.BackgroundTransparency = 0.25
	SPSetBtn.Text = "SET"
	SPSetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	SPSetBtn.FontFace = GetFontBold()
	SPSetBtn.TextSize = 11
	SPSetBtn.AutoButtonColor = false
	Instance.new("UICorner", SPSetBtn).CornerRadius = UDim.new(0, 7)
	SPSetBtn.MouseButton1Click:Connect(function()
		local n = tonumber(SPInput.Text)
		if not n then return end
		speedVal = math.clamp(math.floor(n), 1, 9999)
		SPValLbl.Text = tostring(speedVal)
		local r = math.min(speedVal / 300, 1); SPFill.Size = UDim2.new(r, 0, 1, 0); SPKnob.Position = UDim2.new(r, -9, 0.5, -9)
		if speedOn and Commands then Commands.HandleChat("ws " .. speedVal, UI, nil, true) end
		SPInput.Text = ""
	end)

	local function refreshSPToggle()
		if speedOn then
			SPToggle.Text = "  ●  Speed Boost — ON"
			SPToggle.TextColor3 = Color3.fromRGB(100, 170, 255)
			TweenService:Create(SPToggle, TweenInfo.new(0.15), {BackgroundTransparency = 0.84}):Play()
			if Commands then Commands.HandleChat("ws " .. speedVal, UI, nil, true) end
		else
			SPToggle.Text = "  ○  Speed Boost — OFF"
			SPToggle.TextColor3 = Color3.fromRGB(155, 155, 155)
			TweenService:Create(SPToggle, TweenInfo.new(0.15), {BackgroundTransparency = 0.94}):Play()
			if Commands then Commands.HandleChat("ws 16", UI, nil, true) end
		end
	end
	SPToggle.MouseButton1Click:Connect(function() speedOn = not speedOn refreshSPToggle() end)
	SPToggle.MouseEnter:Connect(function() TweenService:Create(SPToggle, TweenInfo.new(0.12), {BackgroundTransparency = speedOn and 0.76 or 0.86}):Play() end)
	SPToggle.MouseLeave:Connect(function() TweenService:Create(SPToggle, TweenInfo.new(0.12), {BackgroundTransparency = speedOn and 0.84 or 0.94}):Play() end)

	local spDrag = false
	SPKnob.MouseButton1Down:Connect(function() spDrag = true end)
	SPKnob.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch then spDrag = true end end)
	UserInputService.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then spDrag = false end
	end)
	RunService.RenderStepped:Connect(function()
		if spDrag then
			local px = UserInputService:GetMouseLocation().X
			local r = math.clamp((px - SPSliderBack.AbsolutePosition.X) / SPSliderBack.AbsoluteSize.X, 0, 1)
			SPFill.Size = UDim2.new(r, 0, 1, 0); SPKnob.Position = UDim2.new(r, -9, 0.5, -9)
			speedVal = math.max(1, math.floor(r * 300)); SPValLbl.Text = tostring(speedVal)
			if speedOn and Commands then Commands.HandleChat("ws " .. speedVal, UI, nil, true) end
		end
	end)

	CreateBtn(SettingsContent, "Toggle Nametags", function() if Nametags then Nametags.Unload() end end)
	CreateBtn(SettingsContent, "Unload Script", function()
		getgenv().LunarLoaded = false
		ScreenGui:Destroy()
	end)

	local TPSearchBox = Instance.new("TextBox", TPContent)
	TPSearchBox.Size = UDim2.new(1, 0, 0, 34)
	TPSearchBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	TPSearchBox.BackgroundTransparency = 0.3
	TPSearchBox.PlaceholderText = "  Search players..."
	TPSearchBox.Text = ""
	TPSearchBox.TextColor3 = Color3.fromRGB(220, 220, 220)
	TPSearchBox.PlaceholderColor3 = Color3.fromRGB(90, 90, 90)
	TPSearchBox.FontFace = GetFont()
	TPSearchBox.TextSize = 12
	Instance.new("UICorner", TPSearchBox).CornerRadius = UDim.new(0, 7)
	local TPSBPad = Instance.new("UIPadding", TPSearchBox); TPSBPad.PaddingLeft = UDim.new(0, 8)

	local TPScroll = Instance.new("ScrollingFrame", TPContent)
	TPScroll.Size = UDim2.new(1, 0, 0, 256)
	TPScroll.BackgroundTransparency = 1
	TPScroll.BorderSizePixel = 0
	TPScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	TPScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
	TPScroll.ScrollBarThickness = 2
	TPScroll.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
	local TPList = Instance.new("UIListLayout", TPScroll)
	TPList.Padding = UDim.new(0, 5)

	local function BuildPlayerList(filter)
		for _, c in pairs(TPScroll:GetChildren()) do
			if not c:IsA("UIListLayout") then c:Destroy() end
		end
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= Player and (not filter or filter == "" or p.Name:lower():find(filter:lower(), 1, true)) then
				local Row = Instance.new("TextButton", TPScroll)
				Row.Size = UDim2.new(1, 0, 0, 50)
				Row.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Row.BackgroundTransparency = 0.94
				Row.Text = ""
				Row.AutoButtonColor = false
				Instance.new("UICorner", Row).CornerRadius = UDim.new(0, 8)

				local Avatar = Instance.new("ImageLabel", Row)
				Avatar.Size = UDim2.new(0, 36, 0, 36)
				Avatar.Position = UDim2.new(0, 7, 0.5, -18)
				Avatar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
				Avatar.BackgroundTransparency = 0
				Avatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. p.UserId .. "&w=150&h=150"
				Avatar.ScaleType = Enum.ScaleType.Fit
				Instance.new("UICorner", Avatar).CornerRadius = UDim.new(1, 0)

				local NameLbl = Instance.new("TextLabel", Row)
				NameLbl.Size = UDim2.new(1, -110, 1, 0)
				NameLbl.Position = UDim2.new(0, 50, 0, 0)
				NameLbl.BackgroundTransparency = 1
				NameLbl.Text = p.Name
				NameLbl.TextColor3 = Color3.fromRGB(215, 215, 215)
				NameLbl.FontFace = GetFont()
				NameLbl.TextSize = 13
				NameLbl.TextXAlignment = Enum.TextXAlignment.Left

				local TPBtn = Instance.new("TextButton", Row)
				TPBtn.Size = UDim2.new(0, 44, 0, 28)
				TPBtn.Position = UDim2.new(1, -50, 0.5, -14)
				TPBtn.BackgroundColor3 = Color3.fromRGB(100, 170, 255)
				TPBtn.BackgroundTransparency = 0.25
				TPBtn.Text = "TP"
				TPBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
				TPBtn.FontFace = GetFontBold()
				TPBtn.TextSize = 11
				TPBtn.AutoButtonColor = false
				Instance.new("UICorner", TPBtn).CornerRadius = UDim.new(0, 6)
				TPBtn.MouseEnter:Connect(function() TweenService:Create(TPBtn, TweenInfo.new(0.12), {BackgroundTransparency = 0}):Play() end)
				TPBtn.MouseLeave:Connect(function() TweenService:Create(TPBtn, TweenInfo.new(0.12), {BackgroundTransparency = 0.25}):Play() end)

				local function doTP()
					if Commands then Commands.HandleChat("tp " .. p.Name, UI, nil, true) end
					UI.Notify("TP → " .. p.Name, "Success")
				end
				TPBtn.MouseButton1Click:Connect(doTP)
				Row.MouseButton1Click:Connect(doTP)
				Row.MouseEnter:Connect(function() TweenService:Create(Row, TweenInfo.new(0.12), {BackgroundTransparency = 0.86}):Play() end)
				Row.MouseLeave:Connect(function() TweenService:Create(Row, TweenInfo.new(0.12), {BackgroundTransparency = 0.94}):Play() end)
			end
		end
	end

	local origToggleTP = ToggleTPWin
	ToggleTPWin = function()
		BuildPlayerList(TPSearchBox.Text)
		origToggleTP()
	end
	TPSearchBox:GetPropertyChangedSignal("Text"):Connect(function() BuildPlayerList(TPSearchBox.Text) end)
	Players.PlayerAdded:Connect(function() if TPWin.Visible then BuildPlayerList(TPSearchBox.Text) end end)
	Players.PlayerRemoving:Connect(function() task.wait(0.1) if TPWin.Visible then BuildPlayerList(TPSearchBox.Text) end end)

	local NotifyFrame = Instance.new("Frame", ScreenGui)
	NotifyFrame.Size = UDim2.new(0, 295, 0, 58)
	NotifyFrame.Position = UDim2.new(1, 320, 1, -80)
	NotifyFrame.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
	NotifyFrame.BackgroundTransparency = 0.06
	NotifyFrame.BorderSizePixel = 0
	NotifyFrame.ZIndex = 100
	Instance.new("UICorner", NotifyFrame).CornerRadius = UDim.new(0, 9)
	local NStroke = Instance.new("UIStroke", NotifyFrame)
	NStroke.Color = Color3.fromRGB(255, 255, 255)
	NStroke.Transparency = 0.84
	NStroke.Thickness = 1
	local NAccent = Instance.new("Frame", NotifyFrame)
	NAccent.Size = UDim2.new(0, 3, 1, -20)
	NAccent.Position = UDim2.new(0, 10, 0.5, 0)
	NAccent.AnchorPoint = Vector2.new(0, 0.5)
	NAccent.BackgroundColor3 = Color3.fromRGB(0, 220, 130)
	NAccent.BorderSizePixel = 0
	NAccent.ZIndex = 101
	Instance.new("UICorner", NAccent).CornerRadius = UDim.new(1, 0)
	local NLabel = Instance.new("TextLabel", NotifyFrame)
	NLabel.Size = UDim2.new(1, -26, 1, 0)
	NLabel.Position = UDim2.new(0, 22, 0, 0)
	NLabel.BackgroundTransparency = 1
	NLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
	NLabel.FontFace = GetFont()
	NLabel.TextSize = 13
	NLabel.TextXAlignment = Enum.TextXAlignment.Left
	NLabel.TextYAlignment = Enum.TextYAlignment.Center
	NLabel.ZIndex = 102

	UI.Notify = function(text, nType)
		local color = Color3.fromRGB(190, 190, 190)
		if nType == "Success" then color = Color3.fromRGB(0, 220, 130)
		elseif nType == "Warn" then color = Color3.fromRGB(255, 170, 50)
		elseif nType == "Error" then color = Color3.fromRGB(255, 65, 65)
		end
		NLabel.Text = text
		NAccent.BackgroundColor3 = color
		NStroke.Color = color
		NStroke.Transparency = 0.62
		TweenService:Create(NotifyFrame, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(1, -315, 1, -80)}):Play()
		task.delay(2.8, function()
			TweenService:Create(NStroke, TweenInfo.new(0.3), {Transparency = 0.84}):Play()
			TweenService:Create(NotifyFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Position = UDim2.new(1, 320, 1, -80)}):Play()
		end)
	end

	local FlightStatus = Instance.new("Frame", ScreenGui)
	FlightStatus.Size = UDim2.new(0, 185, 0, 76)
	FlightStatus.Position = UDim2.new(0, 15, 1, 110)
	FlightStatus.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
	FlightStatus.BackgroundTransparency = 0.28
	FlightStatus.BorderSizePixel = 0
	Instance.new("UICorner", FlightStatus).CornerRadius = UDim.new(0, 10)
	local FStroke = Instance.new("UIStroke", FlightStatus)
	FStroke.Color = Color3.fromRGB(0, 220, 130)
	FStroke.Transparency = 0.45
	local FLabel = Instance.new("TextLabel", FlightStatus)
	FLabel.Size = UDim2.new(1, -12, 0, 24)
	FLabel.Position = UDim2.new(0, 12, 0, 6)
	FLabel.BackgroundTransparency = 1
	FLabel.Text = "FLIGHT ACTIVE"
	FLabel.TextColor3 = Color3.fromRGB(0, 220, 130)
	FLabel.FontFace = GetFontBold()
	FLabel.TextSize = 12
	FLabel.TextXAlignment = Enum.TextXAlignment.Left
	local FSliderBack = Instance.new("Frame", FlightStatus)
	FSliderBack.Size = UDim2.new(1, -24, 0, 7)
	FSliderBack.Position = UDim2.new(0, 12, 0, 44)
	FSliderBack.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
	FSliderBack.BorderSizePixel = 0
	Instance.new("UICorner", FSliderBack).CornerRadius = UDim.new(0, 4)
	local FSliderFill = Instance.new("Frame", FSliderBack)
	FSliderFill.Size = UDim2.new(0.5, 0, 1, 0)
	FSliderFill.BackgroundColor3 = Color3.fromRGB(0, 220, 130)
	FSliderFill.BorderSizePixel = 0
	Instance.new("UICorner", FSliderFill).CornerRadius = UDim.new(0, 4)
	local FSliderKnob = Instance.new("TextButton", FSliderBack)
	FSliderKnob.Size = UDim2.new(0, 14, 0, 14)
	FSliderKnob.Position = UDim2.new(0.5, -7, 0.5, -7)
	FSliderKnob.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
	FSliderKnob.Text = ""
	FSliderKnob.AutoButtonColor = false
	Instance.new("UICorner", FSliderKnob).CornerRadius = UDim.new(1, 0)
	local FSpeedLbl = Instance.new("TextLabel", FlightStatus)
	FSpeedLbl.Size = UDim2.new(1, -12, 0, 14)
	FSpeedLbl.Position = UDim2.new(0, 12, 0, 56)
	FSpeedLbl.BackgroundTransparency = 1
	FSpeedLbl.Text = "SPEED: 32"
	FSpeedLbl.TextColor3 = Color3.fromRGB(160, 160, 160)
	FSpeedLbl.FontFace = GetFont()
	FSpeedLbl.TextSize = 10
	FSpeedLbl.TextXAlignment = Enum.TextXAlignment.Left

	local fDrag = false
	FSliderKnob.MouseButton1Down:Connect(function() fDrag = true end)
	FSliderKnob.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch then fDrag = true end end)
	UserInputService.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then fDrag = false end
	end)
	RunService.RenderStepped:Connect(function()
		if fDrag then
			local r = math.clamp((UserInputService:GetMouseLocation().X - FSliderBack.AbsolutePosition.X) / FSliderBack.AbsoluteSize.X, 0, 1)
			FSliderFill.Size = UDim2.new(r, 0, 1, 0); FSliderKnob.Position = UDim2.new(r, -7, 0.5, -7)
			local v = math.floor(r * 200)
			if Commands then Commands.HandleChat("ws " .. v, nil, nil, true) end
		end
	end)

	UI.UpdateFlightStatus = function(active, speed)
		TweenService:Create(FlightStatus, TweenInfo.new(0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, 15, 1, active and -90 or 110)}):Play()
		if speed then
			FSpeedLbl.Text = "SPEED: " .. math.floor(speed)
			local r = math.clamp(speed / 200, 0, 1)
			FSliderFill.Size = UDim2.new(r, 0, 1, 0); FSliderKnob.Position = UDim2.new(r, -7, 0.5, -7)
		end
	end

	local ServerInfoPanel = Instance.new("Frame", ScreenGui)
	ServerInfoPanel.Size = UDim2.new(0, 225, 0, 158)
	ServerInfoPanel.Position = UDim2.new(1, 20, 0.5, -79)
	ServerInfoPanel.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
	ServerInfoPanel.BackgroundTransparency = 0.06
	ServerInfoPanel.BorderSizePixel = 0
	Instance.new("UICorner", ServerInfoPanel).CornerRadius = UDim.new(0, 11)
	local SIPStroke = Instance.new("UIStroke", ServerInfoPanel)
	SIPStroke.Color = Color3.fromRGB(100, 180, 255)
	SIPStroke.Transparency = 0.55
	SIPStroke.Thickness = 1
	local SIPTitle = Instance.new("TextLabel", ServerInfoPanel)
	SIPTitle.Size = UDim2.new(1, -20, 0, 30)
	SIPTitle.Position = UDim2.new(0, 14, 0, 7)
	SIPTitle.BackgroundTransparency = 1
	SIPTitle.Text = "SERVER INFO"
	SIPTitle.TextColor3 = Color3.fromRGB(100, 180, 255)
	SIPTitle.FontFace = GetFontBold()
	SIPTitle.TextSize = 12
	SIPTitle.TextXAlignment = Enum.TextXAlignment.Left
	local SIPDiv = Instance.new("Frame", ServerInfoPanel)
	SIPDiv.Size = UDim2.new(1, -28, 0, 1)
	SIPDiv.Position = UDim2.new(0, 14, 0, 37)
	SIPDiv.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	SIPDiv.BackgroundTransparency = 0.88
	SIPDiv.BorderSizePixel = 0
	local siRows = {}
	for i, label in ipairs({"Players", "Ping", "FPS", "Server Age", "Job ID"}) do
		local row = Instance.new("Frame", ServerInfoPanel)
		row.Size = UDim2.new(1, -28, 0, 18)
		row.Position = UDim2.new(0, 14, 0, 37 + i * 21)
		row.BackgroundTransparency = 1
		local ll = Instance.new("TextLabel", row)
		ll.Size = UDim2.new(0.5, 0, 1, 0); ll.BackgroundTransparency = 1
		ll.Text = label; ll.TextColor3 = Color3.fromRGB(110, 110, 110)
		ll.FontFace = GetFont(); ll.TextSize = 11; ll.TextXAlignment = Enum.TextXAlignment.Left
		local rv = Instance.new("TextLabel", row)
		rv.Size = UDim2.new(0.5, 0, 1, 0); rv.Position = UDim2.new(0.5, 0, 0, 0)
		rv.BackgroundTransparency = 1; rv.Text = "—"
		rv.TextColor3 = Color3.fromRGB(220, 220, 220); rv.FontFace = GetFont()
		rv.TextSize = 11; rv.TextXAlignment = Enum.TextXAlignment.Right
		siRows[label] = rv
	end
	local siOpen, siConn = false, nil
	UI.ToggleServerInfo = function()
		siOpen = not siOpen
		if siOpen then
			TweenService:Create(ServerInfoPanel, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(1, -240, 0.5, -79)}):Play()
			local fa, ff = 0, 0
			siConn = RunService.RenderStepped:Connect(function(dt)
				fa += dt; ff += 1
				if fa >= 0.5 then
					siRows["Players"].Text = #Players:GetPlayers() .. "/" .. game.Players.MaxPlayers
					siRows["Ping"].Text = math.floor(Player:GetNetworkPing() * 1000) .. "ms"
					siRows["FPS"].Text = tostring(math.floor(ff / fa))
					siRows["Server Age"].Text = math.floor(workspace.DistributedGameTime / 60) .. "m"
					siRows["Job ID"].Text = game.JobId:sub(1, 11) .. "..."
					fa = 0; ff = 0
				end
			end)
		else
			TweenService:Create(ServerInfoPanel, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Position = UDim2.new(1, 20, 0.5, -79)}):Play()
			if siConn then siConn:Disconnect() siConn = nil end
		end
	end

	if Commands then Commands._UI = UI end

	local function CreatePill(label, accent, callback)
		local Btn = Instance.new("TextButton", Icons)
		Btn.Size = UDim2.new(0, 0, 0, 30)
		Btn.AutomaticSize = Enum.AutomaticSize.X
		Btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
		Btn.BackgroundTransparency = 0.3
		Btn.Text = "  " .. label .. "  "
		Btn.TextColor3 = accent
		Btn.FontFace = GetFontBold()
		Btn.TextSize = 10
		Btn.AutoButtonColor = false
		Instance.new("UICorner", Btn).CornerRadius = UDim.new(1, 0)
		local s = Instance.new("UIStroke", Btn)
		s.Color = accent; s.Transparency = 0.6; s.Thickness = 1
		Btn.MouseEnter:Connect(function()
			TweenService:Create(Btn, TweenInfo.new(0.12), {BackgroundTransparency = 0.02, TextColor3 = Color3.fromRGB(255,255,255)}):Play()
			TweenService:Create(s, TweenInfo.new(0.12), {Transparency = 0.1}):Play()
		end)
		Btn.MouseLeave:Connect(function()
			TweenService:Create(Btn, TweenInfo.new(0.12), {BackgroundTransparency = 0.3, TextColor3 = accent}):Play()
			TweenService:Create(s, TweenInfo.new(0.12), {Transparency = 0.6}):Play()
		end)
		if callback then Btn.MouseButton1Click:Connect(callback) end
		return Btn
	end

	CreatePill("CMDS", Color3.fromRGB(215, 215, 215), function() ToggleCmdWin() end)
	CreatePill(">_", Color3.fromRGB(100, 230, 130), ToggleConsole)
	CreatePill("ESP", Color3.fromRGB(170, 120, 255), function() ToggleEspWin() end)
	CreatePill("SPEED", Color3.fromRGB(90, 165, 255), function() ToggleSpeedWin() end)
	CreatePill("⚙", Color3.fromRGB(190, 190, 190), function() ToggleSettingsWin() end)

	local Expanded = false
	local function ToggleIsland(state)
		Expanded = state
		if state then
			Content.Visible = true
			TweenService:Create(Island, TweenInfo.new(0.55, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
				Size = UDim2.new(0, 660, 0, 50),
				Position = UDim2.new(0.5, -330, 0, 15)
			}):Play()
			TweenService:Create(IslandCorner, TweenInfo.new(0.55), {CornerRadius = UDim.new(0, 15)}):Play()
		else
			TweenService:Create(Island, TweenInfo.new(0.55, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
				Size = UDim2.new(0, 50, 0, 50),
				Position = UDim2.new(0.5, -25, 0, 15)
			}):Play()
			TweenService:Create(IslandCorner, TweenInfo.new(0.55), {CornerRadius = UDim.new(0, 25)}):Play()
			task.wait(0.55)
			if not Expanded then Content.Visible = false end
		end
	end

	if isMobile then
		local MTap = Instance.new("TextButton", Island)
		MTap.Size = UDim2.new(0, 50, 0, 50)
		MTap.BackgroundTransparency = 1
		MTap.Text = ""
		MTap.ZIndex = 10
		MTap.MouseButton1Click:Connect(function() ToggleIsland(not Expanded) end)
	else
		Island.MouseEnter:Connect(function() ToggleIsland(true) end)
		Island.MouseLeave:Connect(function() ToggleIsland(false) end)
	end

	local _fa, _ff = 0, 0
	RunService.RenderStepped:Connect(function(dt)
		_fa += dt; _ff += 1
		if _fa >= 0.5 then
			FPSLabel.Text = "FPS: " .. math.floor(_ff / _fa)
			PingLabel.Text = "PING: " .. math.floor(Player:GetNetworkPing() * 1000) .. "ms"
			_fa = 0; _ff = 0
		end
	end)
end

return UI

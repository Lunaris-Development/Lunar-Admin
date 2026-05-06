local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local LogoID = "rbxthumb://type=Asset&id=73819038719454&w=420&h=420"
local Executor = (identifyexecutor and identifyexecutor()) or (getexecutorname and getexecutorname()) or "Unknown"

local function GetFont()
	if getcustomasset and isfile and isfile("Minecraft.ttf") then
		local s, f = pcall(function() return Font.new(getcustomasset("Minecraft.ttf")) end)
		if s then return f end
	end
	return Font.fromEnum(Enum.Font.GothamBold)
end

local UI = {}

function UI.Init(Nametags, Commands, ESP)
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
	Island.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
	Island.BackgroundTransparency = 0.4
	Island.BorderSizePixel = 0
	Island.ClipsDescendants = true
	Island.Parent = ScreenGui

	local IslandCorner = Instance.new("UICorner")
	IslandCorner.CornerRadius = UDim.new(0, 25)
	IslandCorner.Parent = Island

	local IslandStroke = Instance.new("UIStroke")
	IslandStroke.Color = Color3.fromRGB(255, 255, 255)
	IslandStroke.Transparency = 0.8
	IslandStroke.Thickness = 1.8
	IslandStroke.Parent = Island

	local LogoImg = Instance.new("ImageLabel")
	LogoImg.Size = UDim2.new(0, 38, 0, 38)
	LogoImg.Position = UDim2.new(0, 6, 0, 6)
	LogoImg.BackgroundTransparency = 1
	LogoImg.Image = LogoID
	LogoImg.ImageColor3 = Color3.fromRGB(255, 255, 255)
	LogoImg.ScaleType = Enum.ScaleType.Fit
	LogoImg.Parent = Island

	local LogoGlow = Instance.new("ImageLabel")
	LogoGlow.Size = UDim2.new(1.5, 0, 1.5, 0)
	LogoGlow.Position = UDim2.new(-0.25, 0, -0.25, 0)
	LogoGlow.BackgroundTransparency = 1
	LogoGlow.Image = "rbxassetid://6015538162"
	LogoGlow.ImageColor3 = Color3.fromRGB(255, 255, 255)
	LogoGlow.ImageTransparency = 0.85
	LogoGlow.Parent = LogoImg

	task.spawn(function()
		while ScreenGui.Parent do
			TweenService:Create(LogoGlow, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {ImageTransparency = 0.6}):Play()
			task.wait(1.5)
			TweenService:Create(LogoGlow, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {ImageTransparency = 0.85}):Play()
			task.wait(1.5)
		end
	end)

	local Content = Instance.new("Frame")
	Content.Name = "Content"
	Content.Size = UDim2.new(1, -60, 1, 0)
	Content.Position = UDim2.new(0, 60, 0, 0)
	Content.BackgroundTransparency = 1
	Content.Visible = false
	Content.Parent = Island

	local Info = Instance.new("Frame")
	Info.Size = UDim2.new(0, 130, 1, 0)
	Info.BackgroundTransparency = 1
	Info.Parent = Content

	local Title = Instance.new("TextLabel")
	Title.Size = UDim2.new(1, 0, 0, 30)
	Title.Position = UDim2.new(0, 0, 0, 8)
	Title.BackgroundTransparency = 1
	Title.Text = "Lunar Admin"
	Title.TextColor3 = Color3.fromRGB(255, 255, 255)
	Title.FontFace = GetFont()
	Title.TextSize = 14
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.Parent = Info

	local ExecLabel = Instance.new("TextLabel")
	ExecLabel.Size = UDim2.new(1, 0, 0, 15)
	ExecLabel.Position = UDim2.new(0, 0, 0, 26)
	ExecLabel.BackgroundTransparency = 1
	ExecLabel.Text = Executor
	ExecLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
	ExecLabel.FontFace = GetFont()
	ExecLabel.TextSize = 10
	ExecLabel.TextXAlignment = Enum.TextXAlignment.Left
	ExecLabel.Parent = Info

	local Stats = Instance.new("Frame")
	Stats.Size = UDim2.new(0, 110, 1, 0)
	Stats.Position = UDim2.new(0, 140, 0, 0)
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
	Icons.Size = UDim2.new(1, -260, 1, 0)
	Icons.Position = UDim2.new(0, 260, 0, 0)
	Icons.BackgroundTransparency = 1
	Icons.Parent = Content

	local UIList = Instance.new("UIListLayout")
	UIList.FillDirection = Enum.FillDirection.Horizontal
	UIList.HorizontalAlignment = Enum.HorizontalAlignment.Right
	UIList.VerticalAlignment = Enum.VerticalAlignment.Center
	UIList.Padding = UDim.new(0, 15)
	UIList.Parent = Icons

	local UIPadding = Instance.new("UIPadding")
	UIPadding.PaddingRight = UDim.new(0, 15)
	UIPadding.Parent = Icons

	local function CreateMenu(name, size)
		local Menu = Instance.new("Frame")
		Menu.Name = name
		Menu.Size = UDim2.new(0, size.X, 0, 0)
		Menu.Position = UDim2.new(0.5, -size.X/2, 0, 75)
		Menu.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
		Menu.BackgroundTransparency = 0.3
		Menu.BorderSizePixel = 0
		Menu.ClipsDescendants = true
		Menu.Visible = false
		Menu.Parent = ScreenGui
		Instance.new("UICorner", Menu).CornerRadius = UDim.new(0, 12)
		local Stroke = Instance.new("UIStroke", Menu)
		Stroke.Color = Color3.fromRGB(255, 255, 255)
		Stroke.Transparency = 0.8
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

	local CmdMenu = CreateMenu("CmdMenu", Vector2.new(280, 0))
	local SettingsMenu = CreateMenu("SettingsMenu", Vector2.new(250, 0))
	local EspMenu = CreateMenu("EspMenu", Vector2.new(230, 0))

	local Console = Instance.new("Frame")
	Console.Name = "Console"
	Console.Size = UDim2.new(0, 500, 0, 40)
	Console.Position = UDim2.new(0.5, -250, 1, 50)
	Console.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
	Console.BackgroundTransparency = 0.2
	Console.BorderSizePixel = 0
	Console.Parent = ScreenGui
	Instance.new("UICorner", Console).CornerRadius = UDim.new(0, 6)
	local ConsoleStroke = Instance.new("UIStroke", Console)
	ConsoleStroke.Color = Color3.fromRGB(255, 255, 255)
	ConsoleStroke.Transparency = 0.8

	local ConsoleLayout = Instance.new("UIListLayout", Console)
	ConsoleLayout.FillDirection = Enum.FillDirection.Horizontal
	ConsoleLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
	ConsoleLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	ConsoleLayout.SortOrder = Enum.SortOrder.LayoutOrder
	ConsoleLayout.Padding = UDim.new(0, 4)

	local ConsolePadding = Instance.new("UIPadding", Console)
	ConsolePadding.PaddingLeft = UDim.new(0, 12)

	local ConsoleIcon = Instance.new("ImageLabel")
	ConsoleIcon.Size = UDim2.new(0, 18, 0, 18)
	ConsoleIcon.BackgroundTransparency = 1
	ConsoleIcon.Image = "rbxassetid://85860329666484"
	ConsoleIcon.ImageColor3 = Color3.fromRGB(150, 255, 150)
	ConsoleIcon.LayoutOrder = 1
	ConsoleIcon.Parent = Console

	local Prompt = Instance.new("TextLabel")
	Prompt.Name = "Prompt"
	Prompt.Size = UDim2.new(0, 0, 1, 0)
	Prompt.BackgroundTransparency = 1
	Prompt.Text = Player.Name .. "@Lunar: ~/"
	Prompt.TextColor3 = Color3.fromRGB(150, 255, 150)
	Prompt.FontFace = GetFont()
	Prompt.TextSize = 13
	Prompt.TextXAlignment = Enum.TextXAlignment.Left
	Prompt.AutomaticSize = Enum.AutomaticSize.X
	Prompt.LayoutOrder = 2
	Prompt.Parent = Console

	local ConsoleInput = Instance.new("TextBox")
	ConsoleInput.Name = "Input"
	ConsoleInput.Size = UDim2.new(1, -180, 1, 0)
	ConsoleInput.BackgroundTransparency = 1
	ConsoleInput.Text = ""
	ConsoleInput.PlaceholderText = "enter command..."
	ConsoleInput.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
	ConsoleInput.TextColor3 = Color3.fromRGB(255, 255, 255)
	ConsoleInput.FontFace = GetFont()
	ConsoleInput.TextSize = 13
	ConsoleInput.TextXAlignment = Enum.TextXAlignment.Left
	ConsoleInput.LayoutOrder = 3
	ConsoleInput.Parent = Console

	local function ToggleConsole()
		local Target = Console.Position.Y.Offset == -60 and 50 or -60
		TweenService:Create(Console, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -250, 1, Target)}):Play()
		if Target == -60 then task.wait(0.1) ConsoleInput:CaptureFocus() end
	end

	UserInputService.InputBegan:Connect(function(input, gpe)
		if not gpe and input.KeyCode == Enum.KeyCode.F2 then ToggleConsole() end
	end)

	ConsoleInput.FocusLost:Connect(function(enter)
		if enter then
			local msg = ConsoleInput.Text
			ConsoleInput.Text = ""
			if Commands then Commands.HandleChat(msg, UI, ESP) end
		end
		ToggleConsole()
	end)

	local SearchBox = Instance.new("TextBox")
	SearchBox.Size = UDim2.new(1, 0, 0, 35)
	SearchBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	SearchBox.BackgroundTransparency = 0.5
	SearchBox.PlaceholderText = "Search for commands..."
	SearchBox.Text = ""
	SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	SearchBox.FontFace = GetFont()
	SearchBox.TextSize = 12
	SearchBox.Parent = CmdMenu
	Instance.new("UICorner", SearchBox).CornerRadius = UDim.new(0, 6)
	local SearchPadding = Instance.new("UIPadding", SearchBox)
	SearchPadding.PaddingLeft = UDim.new(0, 10)

	local CmdScroll = Instance.new("ScrollingFrame")
	CmdScroll.Size = UDim2.new(1, 0, 0, 240)
	CmdScroll.BackgroundTransparency = 1
	CmdScroll.BorderSizePixel = 0
	CmdScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	CmdScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
	CmdScroll.ScrollBarThickness = 2
	CmdScroll.Parent = CmdMenu
	local CmdList = Instance.new("UIListLayout", CmdScroll)
	CmdList.Padding = UDim.new(0, 5)

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
		return Btn
	end

	local btns = {}
	table.insert(btns, CreateBtn(CmdScroll, "Fly Toggle", function() if Commands then Commands.HandleChat("fly", UI, ESP) end end))
	table.insert(btns, CreateBtn(CmdScroll, "Freecam Toggle", function() if Commands then Commands.HandleChat("fc", UI, ESP) end end))
	table.insert(btns, CreateBtn(CmdScroll, "ESP Toggle", function() if Commands then Commands.HandleChat("esp", UI, ESP) end end))
	table.insert(btns, CreateBtn(CmdScroll, "Speed (50)", function() if Commands then Commands.HandleChat("ws 50", UI, ESP) end end))
	table.insert(btns, CreateBtn(CmdScroll, "Reset Speed", function() if Commands then Commands.HandleChat("ws 16", UI, ESP) end end))
	table.insert(btns, CreateBtn(CmdScroll, "Anti AFK", function() if Commands then Commands.HandleChat("antiafk", UI, ESP) end end))
	table.insert(btns, CreateBtn(CmdScroll, "Click TP", function() if Commands then Commands.HandleChat("ftpmobile", UI, ESP) end end))
	table.insert(btns, CreateBtn(CmdScroll, "Lag Spoof", function() if Commands then Commands.HandleChat("lag", UI, ESP) end end))
	table.insert(btns, CreateBtn(CmdScroll, "User Spoofer", function() if Commands then Commands.HandleChat("userspoofer player", UI, ESP) end end))
	table.insert(btns, CreateBtn(CmdScroll, "Server Info", function() if Commands then Commands.HandleChat("serverinfo", UI, ESP) end end))
	table.insert(btns, CreateBtn(CmdScroll, "Server List", function() if Commands then Commands.HandleChat("serverh", UI, ESP) end end))
	table.insert(btns, CreateBtn(CmdScroll, "Loop Speed", function() if Commands then Commands.HandleChat("loopspeed 50", UI, ESP) end end))
	table.insert(btns, CreateBtn(CmdScroll, "Touch Fling", function() if Commands then Commands.HandleChat("touchfling", UI, ESP) end end))
	table.insert(btns, CreateBtn(CmdScroll, "Show Low HP", function() if Commands then Commands.HandleChat("shlow", UI, ESP) end end))
	table.insert(btns, CreateBtn(CmdScroll, "Show Most HP", function() if Commands then Commands.HandleChat("shmost", UI, ESP) end end))
	table.insert(btns, CreateBtn(CmdScroll, "Noclip", function() if Commands then Commands.HandleChat("noclip", UI, ESP) end end))
	table.insert(btns, CreateBtn(CmdScroll, "Inf Jump", function() if Commands then Commands.HandleChat("infjump", UI, ESP) end end))
	table.insert(btns, CreateBtn(CmdScroll, "God Mode", function() if Commands then Commands.HandleChat("god", UI, ESP) end end))
	table.insert(btns, CreateBtn(CmdScroll, "Teleport to Player", function() if Commands then Commands.HandleChat("tp ", UI, ESP) end end))

	SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
		local query = SearchBox.Text:lower()
		for _, btn in pairs(btns) do
			btn.Visible = btn.Name:lower():find(query) ~= nil
		end
	end)

	local NotifyFrame = Instance.new("Frame")
	NotifyFrame.Name = "NotifyFrame"
	NotifyFrame.Size = UDim2.new(0, 290, 0, 58)
	NotifyFrame.Position = UDim2.new(1, 320, 1, -80)
	NotifyFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
	NotifyFrame.BackgroundTransparency = 0.08
	NotifyFrame.BorderSizePixel = 0
	NotifyFrame.ZIndex = 100
	NotifyFrame.Parent = ScreenGui
	Instance.new("UICorner", NotifyFrame).CornerRadius = UDim.new(0, 8)

	local NotifyStroke = Instance.new("UIStroke", NotifyFrame)
	NotifyStroke.Color = Color3.fromRGB(255, 255, 255)
	NotifyStroke.Transparency = 0.82
	NotifyStroke.Thickness = 1.2

	local NotifyAccent = Instance.new("Frame")
	NotifyAccent.Size = UDim2.new(0, 3, 1, -20)
	NotifyAccent.Position = UDim2.new(0, 10, 0.5, 0)
	NotifyAccent.AnchorPoint = Vector2.new(0, 0.5)
	NotifyAccent.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
	NotifyAccent.BorderSizePixel = 0
	NotifyAccent.ZIndex = 101
	NotifyAccent.Parent = NotifyFrame
	Instance.new("UICorner", NotifyAccent).CornerRadius = UDim.new(1, 0)

	local NotifyLabel = Instance.new("TextLabel")
	NotifyLabel.Size = UDim2.new(1, -26, 1, 0)
	NotifyLabel.Position = UDim2.new(0, 22, 0, 0)
	NotifyLabel.BackgroundTransparency = 1
	NotifyLabel.TextColor3 = Color3.fromRGB(235, 235, 235)
	NotifyLabel.FontFace = GetFont()
	NotifyLabel.TextSize = 13
	NotifyLabel.TextXAlignment = Enum.TextXAlignment.Left
	NotifyLabel.TextYAlignment = Enum.TextYAlignment.Center
	NotifyLabel.ZIndex = 102
	NotifyLabel.Parent = NotifyFrame

	UI.Notify = function(text, nType)
		local color = Color3.fromRGB(200, 200, 200)
		if nType == "Success" then color = Color3.fromRGB(0, 255, 150)
		elseif nType == "Warn" then color = Color3.fromRGB(255, 170, 0)
		elseif nType == "Error" then color = Color3.fromRGB(255, 60, 60)
		end
		NotifyLabel.Text = text
		NotifyAccent.BackgroundColor3 = color
		NotifyStroke.Color = color
		NotifyStroke.Transparency = 0.65
		TweenService:Create(NotifyFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(1, -310, 1, -80)}):Play()
		task.delay(2.5, function()
			TweenService:Create(NotifyStroke, TweenInfo.new(0.3), {Transparency = 0.82}):Play()
			TweenService:Create(NotifyFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Position = UDim2.new(1, 320, 1, -80)}):Play()
		end)
	end

	local FlightStatus = Instance.new("Frame")
	FlightStatus.Name = "FlightStatus"
	FlightStatus.Size = UDim2.new(0, 180, 0, 75)
	FlightStatus.Position = UDim2.new(0, 15, 1, 100)
	FlightStatus.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
	FlightStatus.BackgroundTransparency = 0.3
	FlightStatus.BorderSizePixel = 0
	FlightStatus.Parent = ScreenGui
	Instance.new("UICorner", FlightStatus).CornerRadius = UDim.new(0, 8)
	local FlightStroke = Instance.new("UIStroke", FlightStatus)
	FlightStroke.Color = Color3.fromRGB(0, 255, 150)
	FlightStroke.Transparency = 0.5

	local FlightLabel = Instance.new("TextLabel")
	FlightLabel.Size = UDim2.new(1, 0, 0, 25)
	FlightLabel.Position = UDim2.new(0, 12, 0, 5)
	FlightLabel.BackgroundTransparency = 1
	FlightLabel.Text = "FLIGHT ACTIVE"
	FlightLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
	FlightLabel.FontFace = GetFont()
	FlightLabel.TextSize = 13
	FlightLabel.TextXAlignment = Enum.TextXAlignment.Left
	FlightLabel.Parent = FlightStatus

	local SliderBack = Instance.new("Frame")
	SliderBack.Name = "SliderBack"
	SliderBack.Size = UDim2.new(1, -24, 0, 6)
	SliderBack.Position = UDim2.new(0, 12, 0, 45)
	SliderBack.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	SliderBack.BorderSizePixel = 0
	SliderBack.Parent = FlightStatus
	Instance.new("UICorner", SliderBack).CornerRadius = UDim.new(0, 3)

	local SliderFill = Instance.new("Frame")
	SliderFill.Name = "SliderFill"
	SliderFill.Size = UDim2.new(0.5, 0, 1, 0)
	SliderFill.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
	SliderFill.BorderSizePixel = 0
	SliderFill.Parent = SliderBack
	Instance.new("UICorner", SliderFill).CornerRadius = UDim.new(0, 3)

	local SliderBtn = Instance.new("TextButton")
	SliderBtn.Name = "SliderBtn"
	SliderBtn.Size = UDim2.new(0, 12, 0, 12)
	SliderBtn.Position = UDim2.new(0.5, -6, 0.5, -6)
	SliderBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	SliderBtn.Text = ""
	SliderBtn.Parent = SliderBack
	Instance.new("UICorner", SliderBtn).CornerRadius = UDim.new(1, 0)

	local FlightSpeed = Instance.new("TextLabel")
	FlightSpeed.Size = UDim2.new(1, 0, 0, 15)
	FlightSpeed.Position = UDim2.new(0, 12, 0, 55)
	FlightSpeed.BackgroundTransparency = 1
	FlightSpeed.Text = "SPEED: 32"
	FlightSpeed.TextColor3 = Color3.fromRGB(200, 200, 200)
	FlightSpeed.FontFace = GetFont()
	FlightSpeed.TextSize = 10
	FlightSpeed.TextXAlignment = Enum.TextXAlignment.Left
	FlightSpeed.Parent = FlightStatus

	local flightDragging = false
	SliderBtn.MouseButton1Down:Connect(function() flightDragging = true end)
	UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then flightDragging = false end end)

	RunService.RenderStepped:Connect(function()
		if flightDragging then
			local mousePos = UserInputService:GetMouseLocation().X
			local relPos = math.clamp((mousePos - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1)
			SliderFill.Size = UDim2.new(relPos, 0, 1, 0)
			SliderBtn.Position = UDim2.new(relPos, -6, 0.5, -6)
			local val = math.floor(relPos * 200)
			if Commands and Commands.HandleChat then
				Commands.HandleChat("ws " .. val, nil, nil, true)
			end
		end
	end)

	UI.UpdateFlightStatus = function(active, speed)
		local Target = active and -85 or 100
		TweenService:Create(FlightStatus, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, 15, 1, Target)}):Play()
		if speed then
			FlightSpeed.Text = "SPEED: " .. math.floor(speed)
			local rel = math.clamp(speed / 200, 0, 1)
			SliderFill.Size = UDim2.new(rel, 0, 1, 0)
			SliderBtn.Position = UDim2.new(rel, -6, 0.5, -6)
		end
	end

	local SpeedPanel = Instance.new("Frame")
	SpeedPanel.Name = "SpeedPanel"
	SpeedPanel.Size = UDim2.new(0, 180, 0, 65)
	SpeedPanel.Position = UDim2.new(0, 15, 1, 100)
	SpeedPanel.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
	SpeedPanel.BackgroundTransparency = 0.3
	SpeedPanel.BorderSizePixel = 0
	SpeedPanel.Parent = ScreenGui
	Instance.new("UICorner", SpeedPanel).CornerRadius = UDim.new(0, 8)
	local SpeedPanelStroke = Instance.new("UIStroke", SpeedPanel)
	SpeedPanelStroke.Color = Color3.fromRGB(100, 180, 255)
	SpeedPanelStroke.Transparency = 0.5

	local SpeedPanelLabel = Instance.new("TextLabel")
	SpeedPanelLabel.Size = UDim2.new(1, 0, 0, 22)
	SpeedPanelLabel.Position = UDim2.new(0, 12, 0, 4)
	SpeedPanelLabel.BackgroundTransparency = 1
	SpeedPanelLabel.Text = "WALK SPEED"
	SpeedPanelLabel.TextColor3 = Color3.fromRGB(100, 180, 255)
	SpeedPanelLabel.FontFace = GetFont()
	SpeedPanelLabel.TextSize = 11
	SpeedPanelLabel.TextXAlignment = Enum.TextXAlignment.Left
	SpeedPanelLabel.Parent = SpeedPanel

	local SpeedValueLabel = Instance.new("TextLabel")
	SpeedValueLabel.Size = UDim2.new(0, 50, 0, 22)
	SpeedValueLabel.Position = UDim2.new(1, -62, 0, 4)
	SpeedValueLabel.BackgroundTransparency = 1
	SpeedValueLabel.Text = "16"
	SpeedValueLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
	SpeedValueLabel.FontFace = GetFont()
	SpeedValueLabel.TextSize = 11
	SpeedValueLabel.TextXAlignment = Enum.TextXAlignment.Right
	SpeedValueLabel.Parent = SpeedPanel

	local SpeedSliderBack = Instance.new("Frame")
	SpeedSliderBack.Size = UDim2.new(1, -24, 0, 6)
	SpeedSliderBack.Position = UDim2.new(0, 12, 0, 34)
	SpeedSliderBack.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	SpeedSliderBack.BorderSizePixel = 0
	SpeedSliderBack.Parent = SpeedPanel
	Instance.new("UICorner", SpeedSliderBack).CornerRadius = UDim.new(0, 3)

	local SpeedSliderFill = Instance.new("Frame")
	SpeedSliderFill.Size = UDim2.new(0.08, 0, 1, 0)
	SpeedSliderFill.BackgroundColor3 = Color3.fromRGB(100, 180, 255)
	SpeedSliderFill.BorderSizePixel = 0
	SpeedSliderFill.Parent = SpeedSliderBack
	Instance.new("UICorner", SpeedSliderFill).CornerRadius = UDim.new(0, 3)

	local SpeedSliderBtn = Instance.new("TextButton")
	SpeedSliderBtn.Size = UDim2.new(0, 12, 0, 12)
	SpeedSliderBtn.Position = UDim2.new(0.08, -6, 0.5, -6)
	SpeedSliderBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	SpeedSliderBtn.Text = ""
	SpeedSliderBtn.Parent = SpeedSliderBack
	Instance.new("UICorner", SpeedSliderBtn).CornerRadius = UDim.new(1, 0)

	local speedDragging = false
	SpeedSliderBtn.MouseButton1Down:Connect(function() speedDragging = true end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then speedDragging = false end
	end)

	RunService.RenderStepped:Connect(function()
		if speedDragging then
			local mousePos = UserInputService:GetMouseLocation().X
			local relPos = math.clamp((mousePos - SpeedSliderBack.AbsolutePosition.X) / SpeedSliderBack.AbsoluteSize.X, 0, 1)
			SpeedSliderFill.Size = UDim2.new(relPos, 0, 1, 0)
			SpeedSliderBtn.Position = UDim2.new(relPos, -6, 0.5, -6)
			local val = math.max(1, math.floor(relPos * 200))
			SpeedValueLabel.Text = tostring(val)
			if Commands and Commands.HandleChat then
				Commands.HandleChat("ws " .. val, nil, nil, true)
			end
		end
	end)

	local speedPanelVisible = false
	UI.ToggleSpeedPanel = function()
		speedPanelVisible = not speedPanelVisible
		local target = speedPanelVisible and -80 or 100
		TweenService:Create(SpeedPanel, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, 15, 1, target)}):Play()
	end

	local ServerInfoPanel = Instance.new("Frame")
	ServerInfoPanel.Name = "ServerInfoPanel"
	ServerInfoPanel.Size = UDim2.new(0, 220, 0, 155)
	ServerInfoPanel.Position = UDim2.new(1, 20, 0.5, -77)
	ServerInfoPanel.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
	ServerInfoPanel.BackgroundTransparency = 0.2
	ServerInfoPanel.BorderSizePixel = 0
	ServerInfoPanel.Parent = ScreenGui
	Instance.new("UICorner", ServerInfoPanel).CornerRadius = UDim.new(0, 10)
	local SIPanelStroke = Instance.new("UIStroke", ServerInfoPanel)
	SIPanelStroke.Color = Color3.fromRGB(150, 200, 255)
	SIPanelStroke.Transparency = 0.6
	SIPanelStroke.Thickness = 1.2

	local SIPanelTitle = Instance.new("TextLabel")
	SIPanelTitle.Size = UDim2.new(1, -20, 0, 30)
	SIPanelTitle.Position = UDim2.new(0, 14, 0, 8)
	SIPanelTitle.BackgroundTransparency = 1
	SIPanelTitle.Text = "SERVER INFO"
	SIPanelTitle.TextColor3 = Color3.fromRGB(150, 200, 255)
	SIPanelTitle.FontFace = GetFont()
	SIPanelTitle.TextSize = 13
	SIPanelTitle.TextXAlignment = Enum.TextXAlignment.Left
	SIPanelTitle.Parent = ServerInfoPanel

	local siDivider = Instance.new("Frame")
	siDivider.Size = UDim2.new(1, -28, 0, 1)
	siDivider.Position = UDim2.new(0, 14, 0, 38)
	siDivider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	siDivider.BackgroundTransparency = 0.88
	siDivider.BorderSizePixel = 0
	siDivider.Parent = ServerInfoPanel

	local siRows = {}
	local siLabels = {"Players", "Ping", "FPS", "Server Age", "Job ID"}
	for i, label in ipairs(siLabels) do
		local row = Instance.new("Frame")
		row.Size = UDim2.new(1, -28, 0, 18)
		row.Position = UDim2.new(0, 14, 0, 38 + i * 20)
		row.BackgroundTransparency = 1
		row.Parent = ServerInfoPanel

		local lbl = Instance.new("TextLabel", row)
		lbl.Size = UDim2.new(0.5, 0, 1, 0)
		lbl.BackgroundTransparency = 1
		lbl.Text = label
		lbl.TextColor3 = Color3.fromRGB(120, 120, 120)
		lbl.FontFace = GetFont()
		lbl.TextSize = 11
		lbl.TextXAlignment = Enum.TextXAlignment.Left

		local val = Instance.new("TextLabel", row)
		val.Size = UDim2.new(0.5, 0, 1, 0)
		val.Position = UDim2.new(0.5, 0, 0, 0)
		val.BackgroundTransparency = 1
		val.Text = "—"
		val.TextColor3 = Color3.fromRGB(230, 230, 230)
		val.FontFace = GetFont()
		val.TextSize = 11
		val.TextXAlignment = Enum.TextXAlignment.Right
		siRows[label] = val
	end

	local siPanelOpen = false
	local siUpdateConn = nil

	UI.ToggleServerInfo = function()
		siPanelOpen = not siPanelOpen
		if siPanelOpen then
			TweenService:Create(ServerInfoPanel, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(1, -235, 0.5, -77)}):Play()
			local _fpsAcc, _fpsF = 0, 0
			siUpdateConn = RunService.RenderStepped:Connect(function(dt)
				_fpsAcc += dt
				_fpsF += 1
				if _fpsAcc >= 0.5 then
					local fps = math.floor(_fpsF / _fpsAcc)
					local ping = math.floor(Player:GetNetworkPing() * 1000)
					local count = #Players:GetPlayers()
					local age = math.floor(workspace.DistributedGameTime / 60)
					local jobId = game.JobId:sub(1, 12) .. "..."
					siRows["Players"].Text = count .. "/" .. game.Players.MaxPlayers
					siRows["Ping"].Text = ping .. "ms"
					siRows["FPS"].Text = tostring(fps)
					siRows["Server Age"].Text = age .. "m"
					siRows["Job ID"].Text = jobId
					_fpsAcc = 0
					_fpsF = 0
				end
			end)
		else
			TweenService:Create(ServerInfoPanel, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Position = UDim2.new(1, 20, 0.5, -77)}):Play()
			if siUpdateConn then siUpdateConn:Disconnect() siUpdateConn = nil end
		end
	end

	local function CreateToggleRow(parent, label, feature)
		local Row = Instance.new("TextButton")
		Row.Size = UDim2.new(1, 0, 0, 38)
		Row.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Row.BackgroundTransparency = 0.95
		Row.AutoButtonColor = false
		Row.Parent = parent
		Instance.new("UICorner", Row).CornerRadius = UDim.new(0, 6)

		local Dot = Instance.new("Frame")
		Dot.Size = UDim2.new(0, 8, 0, 8)
		Dot.Position = UDim2.new(0, 12, 0.5, -4)
		Dot.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
		Dot.BorderSizePixel = 0
		Dot.Parent = Row
		Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)

		local Lbl = Instance.new("TextLabel", Row)
		Lbl.Size = UDim2.new(1, -30, 1, 0)
		Lbl.Position = UDim2.new(0, 28, 0, 0)
		Lbl.BackgroundTransparency = 1
		Lbl.Text = label
		Lbl.TextColor3 = Color3.fromRGB(160, 160, 160)
		Lbl.FontFace = GetFont()
		Lbl.TextSize = 12
		Lbl.TextXAlignment = Enum.TextXAlignment.Left

		local isOn = ESP and ESP.Settings and ESP.Settings[feature] or false

		local function refresh(state)
			if state then
				Dot.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
				Lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
				TweenService:Create(Row, TweenInfo.new(0.2), {BackgroundTransparency = 0.88}):Play()
			else
				Dot.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
				Lbl.TextColor3 = Color3.fromRGB(160, 160, 160)
				TweenService:Create(Row, TweenInfo.new(0.2), {BackgroundTransparency = 0.95}):Play()
			end
		end

		refresh(isOn)

		Row.MouseButton1Click:Connect(function()
			if not ESP then return end
			local newState = not (ESP.Settings and ESP.Settings[feature])
			ESP.ToggleFeature(feature, newState)
			refresh(newState)
		end)

		Row.MouseEnter:Connect(function()
			TweenService:Create(Row, TweenInfo.new(0.15), {BackgroundTransparency = 0.88}):Play()
		end)
		Row.MouseLeave:Connect(function()
			local state = ESP and ESP.Settings and ESP.Settings[feature]
			TweenService:Create(Row, TweenInfo.new(0.15), {BackgroundTransparency = state and 0.88 or 0.95}):Play()
		end)
	end

	local espMasterBtn = CreateBtn(EspMenu, "Enable / Disable ESP", function()
		if ESP then
			ESP.Toggle(not ESP.Enabled)
			if UI then UI.Notify("ESP " .. (ESP.Enabled and "ON" or "OFF"), ESP.Enabled and "Success" or "Warn") end
		end
	end)

	local espDivider = Instance.new("Frame")
	espDivider.Size = UDim2.new(1, 0, 0, 1)
	espDivider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	espDivider.BackgroundTransparency = 0.88
	espDivider.BorderSizePixel = 0
	espDivider.Parent = EspMenu

	CreateToggleRow(EspMenu, "Highlights", "Highlights")
	CreateToggleRow(EspMenu, "Box ESP", "Box")
	CreateToggleRow(EspMenu, "HP Bars", "HP")
	CreateToggleRow(EspMenu, "Skeleton", "Skeleton")
	CreateToggleRow(EspMenu, "Names", "Names")

	CreateBtn(SettingsMenu, "Speed Panel", function() UI.ToggleSpeedPanel() end)
	CreateBtn(SettingsMenu, "Toggle Tags", function() print("Tags toggled") end)
	CreateBtn(SettingsMenu, "Unload Script", function()
		if Nametags then Nametags.Unload() end
		if Commands and Commands.ToggleFreecam and Commands.freecamEnabled then Commands.ToggleFreecam(UI) end
		getgenv().LunarLoaded = false
		ScreenGui:Destroy()
	end)

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

	UI.ToggleMenu = function() AnimateMenu(CmdMenu, 380) end

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

	CreateIcon("rbxassetid://85860329666484", UI.ToggleMenu)
	CreateIcon("rbxassetid://10734913301", ToggleConsole)
	CreateIcon("rbxassetid://10734950309", function() AnimateMenu(SettingsMenu, 160) end)
	CreateIcon("rbxassetid://10734952017", function() AnimateMenu(EspMenu, 280) end)

	if Commands then Commands._UI = UI end

	local Expanded = false
	local function ToggleIsland(state)
		Expanded = state
		if state then
			Content.Visible = true
			TweenService:Create(Island, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
				Size = UDim2.new(0, 560, 0, 50),
				Position = UDim2.new(0.5, -280, 0, 15)
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

	local _fpsAccum, _fpsFrames = 0, 0
	RunService.RenderStepped:Connect(function(dt)
		_fpsAccum += dt
		_fpsFrames += 1
		if _fpsAccum >= 0.5 then
			FPSLabel.Text = "FPS: " .. math.floor(_fpsFrames / _fpsAccum)
			PingLabel.Text = "PING: " .. math.floor(Player:GetNetworkPing() * 1000) .. "ms"
			_fpsAccum = 0
			_fpsFrames = 0
		end
	end)
end

return UI

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local MarketplaceService = game:GetService("MarketplaceService")
local UserInputService = game:GetService("UserInputService")

local GAMEPASS_ID = 9339207514
local lp = Players.LocalPlayer

local NametageGUI = {}

local Config = {
	text = "LUNAR USER",
	font = Enum.Font.GothamBold,
	effect = "Typewriter",
	decalId = "",
	bgColor = Color3.fromRGB(10, 10, 10),
	bgTransparency = 0.2,
	textColor = Color3.fromRGB(150, 255, 150),
}

local Fonts = {
	{n = "Gotham Bold",  e = Enum.Font.GothamBold},
	{n = "Gotham",       e = Enum.Font.GothamMedium},
	{n = "Arial",        e = Enum.Font.Arial},
	{n = "Code",         e = Enum.Font.Code},
	{n = "Arcade",       e = Enum.Font.Fantasy},
	{n = "Mono",         e = Enum.Font.RobotoMono},
}

local BGPresets = {
	Color3.fromRGB(10, 10, 10),
	Color3.fromRGB(10, 15, 35),
	Color3.fromRGB(20, 5, 30),
	Color3.fromRGB(5, 25, 20),
}

local TextColors = {
	Color3.fromRGB(150, 255, 150),
	Color3.fromRGB(100, 180, 255),
	Color3.fromRGB(255, 100, 200),
	Color3.fromRGB(255, 200, 80),
	Color3.fromRGB(200, 130, 255),
	Color3.fromRGB(255, 255, 255),
}

local Effects = {"None", "Typewriter", "Glitch"}

local customActive = false
local customCharConn = nil
local guiBuilt = false
local Win = nil

local function ApplyTag(UI)
	if customCharConn then customCharConn:Disconnect() end
	customActive = true
	local function build()
		local char = lp.Character
		if not char or not char:FindFirstChild("Head") then return end
		local Head = char.Head
		if Head:FindFirstChild("LunarTag") then Head.LunarTag:Destroy() end

		local Tag = Instance.new("BillboardGui")
		Tag.Name = "LunarTag"
		Tag.Size = UDim2.new(0, 170, 0, 54)
		Tag.StudsOffset = Vector3.new(0, 3.5, 0)
		Tag.AlwaysOnTop = false
		Tag.MaxDistance = 150
		Tag.Parent = Head

		local TagFrame = Instance.new("Frame")
		TagFrame.Size = UDim2.new(1, 0, 1, 0)
		TagFrame.BackgroundColor3 = Config.bgColor
		TagFrame.BackgroundTransparency = Config.bgTransparency
		TagFrame.BorderSizePixel = 0
		TagFrame.Parent = Tag
		Instance.new("UICorner", TagFrame).CornerRadius = UDim.new(0, 12)
		local Stroke = Instance.new("UIStroke", TagFrame)
		Stroke.Color = Config.textColor
		Stroke.Transparency = 0.65
		Stroke.Thickness = 1.5

		local Img = Instance.new("ImageLabel")
		Img.Size = UDim2.new(0, 28, 0, 28)
		Img.Position = UDim2.new(0, 10, 0.5, -14)
		Img.BackgroundTransparency = 1
		Img.ScaleType = Enum.ScaleType.Fit
		Img.Image = Config.decalId ~= "" and ("rbxassetid://" .. Config.decalId) or "rbxthumb://type=Asset&id=73819038719454&w=420&h=420"
		Img.Parent = TagFrame

		local TL = Instance.new("TextLabel")
		TL.Size = UDim2.new(1, -48, 0.5, 0)
		TL.Position = UDim2.new(0, 44, 0, 8)
		TL.BackgroundTransparency = 1
		TL.Text = Config.text
		TL.TextColor3 = Config.textColor
		TL.FontFace = Font.fromEnum(Config.font)
		TL.TextSize = 11
		TL.TextXAlignment = Enum.TextXAlignment.Left
		TL.Parent = TagFrame

		local SL = Instance.new("TextLabel")
		SL.Size = UDim2.new(1, -48, 0.5, 0)
		SL.Position = UDim2.new(0, 44, 0.5, -3)
		SL.BackgroundTransparency = 1
		SL.Text = "@" .. lp.Name
		SL.TextColor3 = Color3.fromRGB(200, 200, 200)
		SL.FontFace = Font.fromEnum(Config.font)
		SL.TextSize = 9
		SL.TextXAlignment = Enum.TextXAlignment.Left
		SL.Parent = TagFrame

		if Config.effect == "Typewriter" then
			task.spawn(function()
				while Tag.Parent do
					TL.Text = ""
					for i = 1, #Config.text do
						if not Tag.Parent then return end
						TL.Text = Config.text:sub(1, i)
						task.wait(0.12)
					end
					task.wait(2)
					for i = #Config.text, 0, -1 do
						if not Tag.Parent then return end
						TL.Text = Config.text:sub(1, i)
						task.wait(0.07)
					end
					task.wait(0.4)
				end
			end)
		elseif Config.effect == "Glitch" then
			local gc = "!@#$%^&*<>?{}~"
			task.spawn(function()
				while Tag.Parent do
					for _ = 1, 5 do
						if not Tag.Parent then return end
						local g = ""
						for i = 1, #Config.text do
							g = g .. (math.random() < 0.3 and gc:sub(math.random(1, #gc), math.random(1, #gc)) or Config.text:sub(i, i))
						end
						TL.Text = g
						task.wait(0.06)
					end
					TL.Text = Config.text
					task.wait(2 + math.random())
				end
			end)
		end
	end
	build()
	customCharConn = lp.CharacterAdded:Connect(function()
		task.wait(1)
		if customActive then build() end
	end)
	if UI then UI.Notify("Nametag applied!", "Success") end
end

local function BuildGUI(UI)
	if guiBuilt and Win and Win.Parent then
		Win.Visible = not Win.Visible
		return
	end

	if game.CoreGui:FindFirstChild("LunarNametage") then
		game.CoreGui.LunarNametage:Destroy()
	end
	local SG = Instance.new("ScreenGui")
	SG.Name = "LunarNametage"
	SG.ResetOnSpawn = false
	SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	SG.Parent = game.CoreGui

	local W, H = 500, 420

	Win = Instance.new("TextButton")
	Win.Size = UDim2.new(0, W, 0, H)
	Win.Position = UDim2.new(0.5, -W / 2, 0.5, -H / 2)
	Win.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
	Win.BackgroundTransparency = 0.04
	Win.BorderSizePixel = 0
	Win.ZIndex = 30
	Win.Text = ""
	Win.AutoButtonColor = false
	Win.SelectionImageObject = Instance.new("Frame")
	Win.Parent = SG
	Instance.new("UICorner", Win).CornerRadius = UDim.new(0, 14)
	local WStroke = Instance.new("UIStroke", Win)
	WStroke.Color = Color3.fromRGB(255, 255, 255)
	WStroke.Transparency = 0.87
	WStroke.Thickness = 1

	local TBar = Instance.new("Frame", Win)
	TBar.Size = UDim2.new(1, 0, 0, 40)
	TBar.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
	TBar.BackgroundTransparency = 0
	TBar.BorderSizePixel = 0
	TBar.ZIndex = 31
	Instance.new("UICorner", TBar).CornerRadius = UDim.new(0, 14)
	local TBarFill = Instance.new("Frame", TBar)
	TBarFill.Size = UDim2.new(1, 0, 0, 14)
	TBarFill.Position = UDim2.new(0, 0, 1, -14)
	TBarFill.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
	TBarFill.BorderSizePixel = 0
	local TBarLine = Instance.new("Frame", Win)
	TBarLine.Size = UDim2.new(1, -24, 0, 1)
	TBarLine.Position = UDim2.new(0, 12, 0, 40)
	TBarLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TBarLine.BackgroundTransparency = 0.9
	TBarLine.BorderSizePixel = 0
	TBarLine.ZIndex = 31

	local TitleLbl = Instance.new("TextLabel", TBar)
	TitleLbl.Size = UDim2.new(1, -90, 1, 0)
	TitleLbl.Position = UDim2.new(0, 16, 0, 0)
	TitleLbl.BackgroundTransparency = 1
	TitleLbl.Text = "Nametag Customizer"
	TitleLbl.TextColor3 = Color3.fromRGB(220, 220, 220)
	TitleLbl.FontFace = Font.fromEnum(Enum.Font.GothamBold)
	TitleLbl.TextSize = 13
	TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
	TitleLbl.ZIndex = 32

	local PassBadge = Instance.new("TextLabel", TBar)
	PassBadge.Size = UDim2.new(0, 72, 0, 20)
	PassBadge.Position = UDim2.new(0, 188, 0.5, -10)
	PassBadge.BackgroundColor3 = Color3.fromRGB(255, 200, 80)
	PassBadge.BackgroundTransparency = 0.3
	PassBadge.Text = "GAMEPASS"
	PassBadge.TextColor3 = Color3.fromRGB(255, 230, 150)
	PassBadge.FontFace = Font.fromEnum(Enum.Font.GothamBold)
	PassBadge.TextSize = 9
	PassBadge.ZIndex = 32
	Instance.new("UICorner", PassBadge).CornerRadius = UDim.new(0, 5)

	local Lights = Instance.new("Frame", TBar)
	Lights.Size = UDim2.new(0, 38, 0, 14)
	Lights.Position = UDim2.new(1, -52, 0.5, -7)
	Lights.BackgroundTransparency = 1
	Lights.ZIndex = 32
	local LL = Instance.new("UIListLayout", Lights)
	LL.FillDirection = Enum.FillDirection.Horizontal
	LL.VerticalAlignment = Enum.VerticalAlignment.Center
	LL.Padding = UDim.new(0, 8)

	local function MakeLight(col)
		local L = Instance.new("TextButton", Lights)
		L.Size = UDim2.new(0, 13, 0, 13)
		L.BackgroundColor3 = col
		L.Text = ""
		L.AutoButtonColor = false
		L.ZIndex = 33
		Instance.new("UICorner", L).CornerRadius = UDim.new(1, 0)
		return L
	end
	MakeLight(Color3.fromRGB(255, 189, 68))
	MakeLight(Color3.fromRGB(255, 95, 87)).MouseButton1Click:Connect(function() Win.Visible = false end)

	local dragging, dragStart, startPos = false, nil, nil
	TBar.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = i.Position
			startPos = Win.Position
			i.Changed:Connect(function()
				if i.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	UserInputService.InputChanged:Connect(function(i)
		if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
			local d = i.Position - dragStart
			Win.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
		end
	end)

	local CA = Instance.new("Frame", Win)
	CA.Size = UDim2.new(1, 0, 1, -48)
	CA.Position = UDim2.new(0, 0, 0, 48)
	CA.BackgroundTransparency = 1
	CA.ZIndex = 31

	local leftW   = 150
	local centerW = 200
	local rightW  = W - leftW - centerW

	local function Sect(x, w)
		local F = Instance.new("Frame", CA)
		F.Position = UDim2.new(0, x, 0, 0)
		F.Size = UDim2.new(0, w, 1, 0)
		F.BackgroundTransparency = 1
		F.ZIndex = 31
		return F
	end

	local LeftP   = Sect(0, leftW)
	local CenterP = Sect(leftW, centerW)
	local RightP  = Sect(leftW + centerW, rightW)

	local function VDiv(x)
		local D = Instance.new("Frame", CA)
		D.Size = UDim2.new(0, 1, 1, -20)
		D.Position = UDim2.new(0, x, 0, 10)
		D.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		D.BackgroundTransparency = 0.9
		D.BorderSizePixel = 0
		D.ZIndex = 31
	end
	VDiv(leftW)
	VDiv(leftW + centerW)

	local function SLabel(p, t, y)
		local L = Instance.new("TextLabel", p)
		L.Size = UDim2.new(1, -20, 0, 16)
		L.Position = UDim2.new(0, 10, 0, y)
		L.BackgroundTransparency = 1
		L.Text = t
		L.TextColor3 = Color3.fromRGB(90, 90, 90)
		L.FontFace = Font.fromEnum(Enum.Font.GothamBold)
		L.TextSize = 10
		L.TextXAlignment = Enum.TextXAlignment.Left
		L.ZIndex = 32
		return L
	end

	local lp2 = 10

	SLabel(LeftP, "DECAL ID", 12)
	local DecalBox = Instance.new("TextBox", LeftP)
	DecalBox.Size = UDim2.new(1, -lp2 * 2, 0, 30)
	DecalBox.Position = UDim2.new(0, lp2, 0, 30)
	DecalBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	DecalBox.BackgroundTransparency = 0.2
	DecalBox.Text = ""
	DecalBox.PlaceholderText = "Asset ID..."
	DecalBox.TextColor3 = Color3.fromRGB(220, 220, 220)
	DecalBox.PlaceholderColor3 = Color3.fromRGB(70, 70, 70)
	DecalBox.FontFace = Font.fromEnum(Enum.Font.Gotham)
	DecalBox.TextSize = 11
	DecalBox.ZIndex = 33
	DecalBox.BorderSizePixel = 0
	Instance.new("UICorner", DecalBox).CornerRadius = UDim.new(0, 7)
	Instance.new("UIPadding", DecalBox).PaddingLeft = UDim.new(0, 8)

	SLabel(LeftP, "BACKGROUND", 72)
	local BGGrid = Instance.new("Frame", LeftP)
	BGGrid.Size = UDim2.new(1, -lp2 * 2, 0, 28)
	BGGrid.Position = UDim2.new(0, lp2, 0, 90)
	BGGrid.BackgroundTransparency = 1
	BGGrid.ZIndex = 32
	local BGList = Instance.new("UIListLayout", BGGrid)
	BGList.FillDirection = Enum.FillDirection.Horizontal
	BGList.Padding = UDim.new(0, 6)
	BGList.VerticalAlignment = Enum.VerticalAlignment.Center

	local selBGDot = nil
	local BGDots = {}
	for i, c in ipairs(BGPresets) do
		local D = Instance.new("TextButton", BGGrid)
		D.Size = UDim2.new(0, 24, 0, 24)
		D.BackgroundColor3 = c
		D.Text = ""
		D.AutoButtonColor = false
		D.ZIndex = 33
		D.BorderSizePixel = 0
		D.BorderColor3 = Color3.fromRGB(255, 255, 255)
		Instance.new("UICorner", D).CornerRadius = UDim.new(0, 6)
		local stroke = Instance.new("UIStroke", D)
		stroke.Color = Color3.fromRGB(255, 255, 255)
		stroke.Transparency = 1
		stroke.Thickness = 2
		BGDots[i] = {btn = D, stroke = stroke, color = c}
		if i == 1 then
			Config.bgColor = c
			stroke.Transparency = 0.3
			selBGDot = i
		end
		D.MouseButton1Click:Connect(function()
			if selBGDot then BGDots[selBGDot].stroke.Transparency = 1 end
			Config.bgColor = c
			stroke.Transparency = 0.3
			selBGDot = i
		end)
	end

	SLabel(LeftP, "BG OPACITY", 128)
	local BGSliderBack = Instance.new("Frame", LeftP)
	BGSliderBack.Size = UDim2.new(1, -lp2 * 2, 0, 8)
	BGSliderBack.Position = UDim2.new(0, lp2, 0, 146)
	BGSliderBack.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
	BGSliderBack.BorderSizePixel = 0
	BGSliderBack.ZIndex = 32
	Instance.new("UICorner", BGSliderBack).CornerRadius = UDim.new(0, 4)
	local BGFill = Instance.new("Frame", BGSliderBack)
	BGFill.Size = UDim2.new(0.8, 0, 1, 0)
	BGFill.BackgroundColor3 = Color3.fromRGB(100, 180, 255)
	BGFill.BorderSizePixel = 0
	BGFill.ZIndex = 33
	Instance.new("UICorner", BGFill).CornerRadius = UDim.new(0, 4)
	local BGKnob = Instance.new("TextButton", BGSliderBack)
	BGKnob.Size = UDim2.new(0, 16, 0, 16)
	BGKnob.Position = UDim2.new(0.8, -8, 0.5, -8)
	BGKnob.BackgroundColor3 = Color3.fromRGB(235, 235, 235)
	BGKnob.Text = ""
	BGKnob.AutoButtonColor = false
	BGKnob.ZIndex = 34
	Instance.new("UICorner", BGKnob).CornerRadius = UDim.new(1, 0)

	local bgDragging = false
	BGKnob.MouseButton1Down:Connect(function() bgDragging = true end)
	BGKnob.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch then bgDragging = true end end)
	UserInputService.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then bgDragging = false end
	end)

	SLabel(LeftP, "TEXT COLOR", 170)
	local TCGrid = Instance.new("Frame", LeftP)
	TCGrid.Size = UDim2.new(1, -lp2 * 2, 0, 56)
	TCGrid.Position = UDim2.new(0, lp2, 0, 188)
	TCGrid.BackgroundTransparency = 1
	TCGrid.ZIndex = 32
	local TCList = Instance.new("UIListLayout", TCGrid)
	TCList.FillDirection = Enum.FillDirection.Horizontal
	TCList.Padding = UDim.new(0, 5)
	TCList.Wraps = true

	local selTCDot = nil
	local TCDots = {}
	for i, c in ipairs(TextColors) do
		local D = Instance.new("TextButton", TCGrid)
		D.Size = UDim2.new(0, 22, 0, 22)
		D.BackgroundColor3 = c
		D.Text = ""
		D.AutoButtonColor = false
		D.ZIndex = 33
		D.BorderSizePixel = 0
		D.BorderColor3 = Color3.fromRGB(255, 255, 255)
		Instance.new("UICorner", D).CornerRadius = UDim.new(0, 5)
		local stroke = Instance.new("UIStroke", D)
		stroke.Color = Color3.fromRGB(255, 255, 255)
		stroke.Transparency = 1
		stroke.Thickness = 2
		TCDots[i] = {btn = D, stroke = stroke, color = c}
		if i == 1 then
			Config.textColor = c
			stroke.Transparency = 0.3
			selTCDot = i
		end
		D.MouseButton1Click:Connect(function()
			if selTCDot then TCDots[selTCDot].stroke.Transparency = 1 end
			Config.textColor = c
			stroke.Transparency = 0.3
			selTCDot = i
		end)
	end

	SLabel(CenterP, "PREVIEW", 12)
	local PreviewContainer = Instance.new("Frame", CenterP)
	PreviewContainer.Size = UDim2.new(1, -20, 0, 70)
	PreviewContainer.Position = UDim2.new(0, 10, 0, 32)
	PreviewContainer.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
	PreviewContainer.BackgroundTransparency = 0.4
	PreviewContainer.BorderSizePixel = 0
	PreviewContainer.ZIndex = 32
	Instance.new("UICorner", PreviewContainer).CornerRadius = UDim.new(0, 10)

	local PTagFrame = Instance.new("Frame", PreviewContainer)
	PTagFrame.Size = UDim2.new(0, 168, 0, 50)
	PTagFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	PTagFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	PTagFrame.BackgroundColor3 = Config.bgColor
	PTagFrame.BackgroundTransparency = Config.bgTransparency
	PTagFrame.BorderSizePixel = 0
	PTagFrame.ZIndex = 33
	Instance.new("UICorner", PTagFrame).CornerRadius = UDim.new(0, 12)
	local PStroke = Instance.new("UIStroke", PTagFrame)
	PStroke.Color = Config.textColor
	PStroke.Transparency = 0.65
	PStroke.Thickness = 1.5

	local PImg = Instance.new("ImageLabel", PTagFrame)
	PImg.Size = UDim2.new(0, 26, 0, 26)
	PImg.Position = UDim2.new(0, 8, 0.5, -13)
	PImg.BackgroundTransparency = 1
	PImg.ScaleType = Enum.ScaleType.Fit
	PImg.ZIndex = 34
	PImg.Image = "rbxthumb://type=Asset&id=73819038719454&w=420&h=420"

	local PTL = Instance.new("TextLabel", PTagFrame)
	PTL.Size = UDim2.new(1, -44, 0.5, 0)
	PTL.Position = UDim2.new(0, 40, 0, 6)
	PTL.BackgroundTransparency = 1
	PTL.Text = Config.text
	PTL.TextColor3 = Config.textColor
	PTL.FontFace = Font.fromEnum(Config.font)
	PTL.TextSize = 10
	PTL.TextXAlignment = Enum.TextXAlignment.Left
	PTL.TextTruncate = Enum.TextTruncate.AtEnd
	PTL.ZIndex = 34

	local PSL = Instance.new("TextLabel", PTagFrame)
	PSL.Size = UDim2.new(1, -44, 0.5, 0)
	PSL.Position = UDim2.new(0, 40, 0.5, -2)
	PSL.BackgroundTransparency = 1
	PSL.Text = "@" .. lp.Name
	PSL.TextColor3 = Color3.fromRGB(180, 180, 180)
	PSL.FontFace = Font.fromEnum(Enum.Font.Gotham)
	PSL.TextSize = 8
	PSL.TextXAlignment = Enum.TextXAlignment.Left
	PSL.ZIndex = 34

	local function RefreshPreview()
		PTagFrame.BackgroundColor3 = Config.bgColor
		PTagFrame.BackgroundTransparency = Config.bgTransparency
		PStroke.Color = Config.textColor
		PTL.TextColor3 = Config.textColor
		PTL.FontFace = Font.fromEnum(Config.font)
		PTL.Text = Config.text ~= "" and Config.text or "LUNAR USER"
		PImg.Image = Config.decalId ~= "" and ("rbxassetid://" .. Config.decalId) or "rbxthumb://type=Asset&id=73819038719454&w=420&h=420"
		PSL.FontFace = Font.fromEnum(Config.font)
	end

	task.spawn(function()
		while Win and Win.Parent do
			local t = Config.text ~= "" and Config.text or "LUNAR USER"
			if Config.effect == "Typewriter" then
				PTL.Text = ""
				for i = 1, #t do
					if not (Win and Win.Parent and Win.Visible) then task.wait(0.2) break end
					PTL.Text = t:sub(1, i)
					task.wait(0.1)
				end
				task.wait(1.5)
				for i = #t, 0, -1 do
					if not (Win and Win.Parent and Win.Visible) then break end
					PTL.Text = t:sub(1, i)
					task.wait(0.06)
				end
				task.wait(0.3)
			elseif Config.effect == "Glitch" then
				local gc = "!@#$%^&*<>?{}~"
				for _ = 1, 5 do
					if not (Win and Win.Parent) then return end
					local g = ""
					for i = 1, #t do
						g = g .. (math.random() < 0.35 and gc:sub(math.random(1, #gc), math.random(1, #gc)) or t:sub(i, i))
					end
					PTL.Text = g
					task.wait(0.07)
				end
				PTL.Text = t
				task.wait(2 + math.random())
			else
				PTL.Text = t
				task.wait(0.5)
			end
		end
	end)

	UserInputService.InputChanged:Connect(function(i)
		if bgDragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
			local r = math.clamp((i.Position.X - BGSliderBack.AbsolutePosition.X) / BGSliderBack.AbsoluteSize.X, 0, 1)
			BGFill.Size = UDim2.new(r, 0, 1, 0)
			BGKnob.Position = UDim2.new(r, -8, 0.5, -8)
			Config.bgTransparency = 1 - r
			RefreshPreview()
		end
	end)

	SLabel(CenterP, "YOUR TEXT", 114)
	local TextInput = Instance.new("TextBox", CenterP)
	TextInput.Size = UDim2.new(1, -20, 0, 32)
	TextInput.Position = UDim2.new(0, 10, 0, 132)
	TextInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	TextInput.BackgroundTransparency = 0.2
	TextInput.Text = "LUNAR USER"
	TextInput.PlaceholderText = "Nametag text..."
	TextInput.TextColor3 = Color3.fromRGB(220, 220, 220)
	TextInput.PlaceholderColor3 = Color3.fromRGB(70, 70, 70)
	TextInput.FontFace = Font.fromEnum(Enum.Font.Gotham)
	TextInput.TextSize = 12
	TextInput.ZIndex = 33
	TextInput.BorderSizePixel = 0
	Instance.new("UICorner", TextInput).CornerRadius = UDim.new(0, 8)
	Instance.new("UIPadding", TextInput).PaddingLeft = UDim.new(0, 10)

	local EffectBadge = Instance.new("TextLabel", CenterP)
	EffectBadge.Size = UDim2.new(1, -20, 0, 20)
	EffectBadge.Position = UDim2.new(0, 10, 0, 174)
	EffectBadge.BackgroundTransparency = 1
	EffectBadge.Text = "Effect: " .. Config.effect
	EffectBadge.TextColor3 = Color3.fromRGB(100, 180, 255)
	EffectBadge.FontFace = Font.fromEnum(Enum.Font.Gotham)
	EffectBadge.TextSize = 10
	EffectBadge.TextXAlignment = Enum.TextXAlignment.Center
	EffectBadge.ZIndex = 32

	local ApplyBtn = Instance.new("TextButton", CenterP)
	ApplyBtn.Size = UDim2.new(1, -20, 0, 40)
	ApplyBtn.Position = UDim2.new(0, 10, 1, -52)
	ApplyBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 120)
	ApplyBtn.BackgroundTransparency = 0.2
	ApplyBtn.Text = "Apply Nametag"
	ApplyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	ApplyBtn.FontFace = Font.fromEnum(Enum.Font.GothamBold)
	ApplyBtn.TextSize = 13
	ApplyBtn.AutoButtonColor = false
	ApplyBtn.ZIndex = 33
	Instance.new("UICorner", ApplyBtn).CornerRadius = UDim.new(0, 10)
	ApplyBtn.MouseEnter:Connect(function() TweenService:Create(ApplyBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0}):Play() end)
	ApplyBtn.MouseLeave:Connect(function() TweenService:Create(ApplyBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.2}):Play() end)
	ApplyBtn.MouseButton1Click:Connect(function() ApplyTag(UI) end)

	TextInput:GetPropertyChangedSignal("Text"):Connect(function()
		Config.text = TextInput.Text
		RefreshPreview()
	end)
	DecalBox:GetPropertyChangedSignal("Text"):Connect(function()
		Config.decalId = DecalBox.Text
		RefreshPreview()
	end)

	for _, d in ipairs(BGDots) do
		d.btn.MouseButton1Click:Connect(RefreshPreview)
	end
	for _, d in ipairs(TCDots) do
		d.btn.MouseButton1Click:Connect(RefreshPreview)
	end

	SLabel(RightP, "FONT", 12)
	local FontScroll = Instance.new("ScrollingFrame", RightP)
	FontScroll.Size = UDim2.new(1, -10, 0, 162)
	FontScroll.Position = UDim2.new(0, 5, 0, 30)
	FontScroll.BackgroundTransparency = 1
	FontScroll.BorderSizePixel = 0
	FontScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	FontScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
	FontScroll.ScrollBarThickness = 2
	FontScroll.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
	FontScroll.ZIndex = 32
	Instance.new("UIListLayout", FontScroll).Padding = UDim.new(0, 4)

	local selFontBtn = nil
	for _, f in ipairs(Fonts) do
		local FB = Instance.new("TextButton", FontScroll)
		FB.Size = UDim2.new(1, 0, 0, 30)
		FB.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		FB.BackgroundTransparency = 0.94
		FB.Text = f.n
		FB.TextColor3 = Color3.fromRGB(180, 180, 180)
		FB.FontFace = Font.fromEnum(f.e)
		FB.TextSize = 11
		FB.AutoButtonColor = false
		FB.ZIndex = 33
		Instance.new("UICorner", FB).CornerRadius = UDim.new(0, 7)
		if f.e == Config.font then
			FB.BackgroundTransparency = 0.82
			FB.TextColor3 = Color3.fromRGB(255, 255, 255)
			selFontBtn = FB
		end
		FB.MouseButton1Click:Connect(function()
			Config.font = f.e
			if selFontBtn then
				TweenService:Create(selFontBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.94, TextColor3 = Color3.fromRGB(180, 180, 180)}):Play()
			end
			selFontBtn = FB
			TweenService:Create(FB, TweenInfo.new(0.15), {BackgroundTransparency = 0.82, TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
			RefreshPreview()
		end)
		FB.MouseEnter:Connect(function()
			if FB ~= selFontBtn then TweenService:Create(FB, TweenInfo.new(0.12), {BackgroundTransparency = 0.87}):Play() end
		end)
		FB.MouseLeave:Connect(function()
			if FB ~= selFontBtn then TweenService:Create(FB, TweenInfo.new(0.12), {BackgroundTransparency = 0.94}):Play() end
		end)
	end

	SLabel(RightP, "EFFECT", 204)
	local EffectFrame = Instance.new("Frame", RightP)
	EffectFrame.Size = UDim2.new(1, -10, 0, 106)
	EffectFrame.Position = UDim2.new(0, 5, 0, 222)
	EffectFrame.BackgroundTransparency = 1
	EffectFrame.ZIndex = 32
	Instance.new("UIListLayout", EffectFrame).Padding = UDim.new(0, 4)

	local selEffBtn = nil
	for _, ef in ipairs(Effects) do
		local EB = Instance.new("TextButton", EffectFrame)
		EB.Size = UDim2.new(1, 0, 0, 30)
		EB.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		EB.BackgroundTransparency = 0.94
		EB.Text = ef
		EB.TextColor3 = Color3.fromRGB(180, 180, 180)
		EB.FontFace = Font.fromEnum(Enum.Font.Gotham)
		EB.TextSize = 11
		EB.AutoButtonColor = false
		EB.ZIndex = 33
		Instance.new("UICorner", EB).CornerRadius = UDim.new(0, 7)
		if ef == Config.effect then
			EB.BackgroundTransparency = 0.82
			EB.TextColor3 = Color3.fromRGB(100, 180, 255)
			selEffBtn = EB
		end
		EB.MouseButton1Click:Connect(function()
			Config.effect = ef
			EffectBadge.Text = "Effect: " .. ef
			if selEffBtn then
				TweenService:Create(selEffBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.94, TextColor3 = Color3.fromRGB(180, 180, 180)}):Play()
			end
			selEffBtn = EB
			TweenService:Create(EB, TweenInfo.new(0.15), {BackgroundTransparency = 0.82, TextColor3 = Color3.fromRGB(100, 180, 255)}):Play()
		end)
		EB.MouseEnter:Connect(function()
			if EB ~= selEffBtn then TweenService:Create(EB, TweenInfo.new(0.12), {BackgroundTransparency = 0.87}):Play() end
		end)
		EB.MouseLeave:Connect(function()
			if EB ~= selEffBtn then TweenService:Create(EB, TweenInfo.new(0.12), {BackgroundTransparency = 0.94}):Play() end
		end)
	end

	guiBuilt = true
end

function NametageGUI.HandleChat(msg, UI)
	local cmd = msg:lower():split(" ")[1]
	if cmd ~= "nametag" then return end

	local hasAccess = lp.Name == "lnrs_dev"
	if not hasAccess then
		local ok, owns = pcall(function()
			return MarketplaceService:UserOwnsGamePassAsync(lp.UserId, GAMEPASS_ID)
		end)
		hasAccess = ok and owns
	end

	if not hasAccess then
		if UI then UI.Notify("Nametag requires the Gamepass!", "Error") end
		task.spawn(function()
			pcall(function() MarketplaceService:PromptGamePassPurchase(lp, GAMEPASS_ID) end)
		end)
		return
	end

	BuildGUI(UI)
	if Win then Win.Visible = true end
end

return NametageGUI

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local lp = Players.LocalPlayer
local GlobalChat = {}

local HISTORY_FILE = "LunarChat.json"
local MAX_HISTORY = 150

local history = {}
local guiBuilt = false
local Win, MsgScroll, MsgLayout = nil, nil, nil

local ClickSnd = Instance.new("Sound")
ClickSnd.SoundId = "rbxassetid://7545317681"
ClickSnd.Volume = 0.18
ClickSnd.Parent = game:GetService("CoreGui")
local function Click() pcall(function() ClickSnd:Play() end) end

local function LoadHistory()
	if not (readfile and isfile) then return end
	pcall(function()
		if not isfile(HISTORY_FILE) then return end
		local d = HttpService:JSONDecode(readfile(HISTORY_FILE))
		if d and d.messages then history = d.messages end
	end)
end

local function SaveHistory()
	if not writefile then return end
	pcall(function()
		while #history > MAX_HISTORY do table.remove(history, 1) end
		writefile(HISTORY_FILE, HttpService:JSONEncode({messages = history}))
	end)
end

local function GetFont() return Font.fromEnum(Enum.Font.GothamBold) end

local function TimeStamp()
	local t = os.time()
	return string.format("%02d:%02d", math.floor(t/3600)%24, math.floor(t/60)%60)
end

local function UserColor(name)
	if name == "lnrs_dev" then return Color3.fromRGB(255, 90, 90) end
	if name == lp.Name then return Color3.fromRGB(120, 255, 165) end
	local h = 0
	for i = 1, #name do h = (h * 31 + name:byte(i)) % 360 end
	return Color3.fromHSV(h/360, 0.7, 1)
end

local function AppendRow(scroll, entry)
	if not scroll then return end
	local color = Color3.fromRGB(entry.r or 120, entry.g or 255, entry.b or 165)
	local Row = Instance.new("Frame", scroll)
	Row.Size = UDim2.new(1, 0, 0, 0)
	Row.AutomaticSize = Enum.AutomaticSize.Y
	Row.BackgroundTransparency = 1
	Row.BorderSizePixel = 0

	local TimeLbl = Instance.new("TextLabel", Row)
	TimeLbl.Size = UDim2.new(0, 36, 0, 16)
	TimeLbl.Position = UDim2.new(0, 0, 0, 0)
	TimeLbl.BackgroundTransparency = 1
	TimeLbl.Text = entry.time or ""
	TimeLbl.TextColor3 = Color3.fromRGB(75, 75, 75)
	TimeLbl.FontFace = GetFont()
	TimeLbl.TextSize = 9
	TimeLbl.TextXAlignment = Enum.TextXAlignment.Left

	local NameLbl = Instance.new("TextLabel", Row)
	NameLbl.Size = UDim2.new(0, 0, 0, 16)
	NameLbl.Position = UDim2.new(0, 40, 0, 0)
	NameLbl.AutomaticSize = Enum.AutomaticSize.X
	NameLbl.BackgroundTransparency = 1
	NameLbl.Text = (entry.user or "?") .. ":"
	NameLbl.TextColor3 = color
	NameLbl.FontFace = GetFont()
	NameLbl.TextSize = 12
	NameLbl.TextXAlignment = Enum.TextXAlignment.Left

	local MsgLbl = Instance.new("TextLabel", Row)
	MsgLbl.Size = UDim2.new(1, 0, 0, 0)
	MsgLbl.Position = UDim2.new(0, 0, 0, 19)
	MsgLbl.AutomaticSize = Enum.AutomaticSize.Y
	MsgLbl.BackgroundTransparency = 1
	MsgLbl.Text = entry.text or ""
	MsgLbl.TextColor3 = Color3.fromRGB(210, 210, 210)
	MsgLbl.FontFace = GetFont()
	MsgLbl.TextSize = 12
	MsgLbl.TextXAlignment = Enum.TextXAlignment.Left
	MsgLbl.TextWrapped = true
end

local function AddMessage(username, text, r, g, b)
	local entry = {time = TimeStamp(), user = username, text = text, r = r, g = g, b = b}
	table.insert(history, entry)
	SaveHistory()
	AppendRow(MsgScroll, entry)
	if MsgScroll and MsgLayout then
		task.wait()
		MsgScroll.CanvasPosition = Vector2.new(0, MsgLayout.AbsoluteContentSize.Y)
	end
end

local function SendUnfiltered(text)
	local sent = false
	pcall(function()
		lp:Chat(text)
		sent = true
	end)
	if not sent then
		pcall(function()
			local tcs = game:GetService("TextChatService")
			local ch = tcs:FindFirstChild("TextChannels")
			if ch then
				local gen = ch:FindFirstChild("RBXGeneral")
				if gen then gen:SendAsync(text); sent = true end
			end
		end)
	end
end

local function BuildGUI()
	if guiBuilt and Win and Win.Parent then
		Win.Visible = not Win.Visible
		return
	end

	if game.CoreGui:FindFirstChild("LunarGlobalChat") then
		game.CoreGui.LunarGlobalChat:Destroy()
	end

	local SG = Instance.new("ScreenGui")
	SG.Name = "LunarGlobalChat"
	SG.ResetOnSpawn = false
	SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	SG.Parent = game.CoreGui

	local W, H = 340, 390
	Win = Instance.new("TextButton")
	Win.Size = UDim2.new(0, W, 0, H)
	Win.Position = UDim2.new(0, 20, 0.5, -H/2)
	Win.BackgroundColor3 = Color3.fromRGB(13, 13, 13)
	Win.BackgroundTransparency = 0.05
	Win.BorderSizePixel = 0
	Win.ZIndex = 30
	Win.Text = ""
	Win.AutoButtonColor = false
	Win.SelectionImageObject = Instance.new("Frame")
	Win.Parent = SG
	Instance.new("UICorner", Win).CornerRadius = UDim.new(0, 13)
	local WStroke = Instance.new("UIStroke", Win)
	WStroke.Color = Color3.fromRGB(255,255,255); WStroke.Transparency = 0.87; WStroke.Thickness = 1

	local TBar = Instance.new("Frame", Win)
	TBar.Size = UDim2.new(1,0,0,40); TBar.BackgroundColor3 = Color3.fromRGB(20,20,20)
	TBar.BackgroundTransparency = 0; TBar.BorderSizePixel = 0; TBar.ZIndex = 31
	Instance.new("UICorner", TBar).CornerRadius = UDim.new(0,13)
	local TFill = Instance.new("Frame", TBar)
	TFill.Size = UDim2.new(1,0,0,13); TFill.Position = UDim2.new(0,0,1,-13)
	TFill.BackgroundColor3 = Color3.fromRGB(20,20,20); TFill.BorderSizePixel = 0

	local TitleLbl = Instance.new("TextLabel", TBar)
	TitleLbl.Size = UDim2.new(1,-60,1,0); TitleLbl.Position = UDim2.new(0,14,0,0)
	TitleLbl.BackgroundTransparency = 1; TitleLbl.Text = "Lunar Chat"
	TitleLbl.TextColor3 = Color3.fromRGB(220,220,220); TitleLbl.FontFace = GetFont()
	TitleLbl.TextSize = 13; TitleLbl.TextXAlignment = Enum.TextXAlignment.Left; TitleLbl.ZIndex = 32

	local LiveDot = Instance.new("Frame", TBar)
	LiveDot.Size = UDim2.new(0,7,0,7); LiveDot.Position = UDim2.new(0,102,0.5,-3.5)
	LiveDot.BackgroundColor3 = Color3.fromRGB(0,220,130); LiveDot.BorderSizePixel = 0; LiveDot.ZIndex = 32
	Instance.new("UICorner", LiveDot).CornerRadius = UDim.new(1,0)

	local CloseBtn = Instance.new("TextButton", TBar)
	CloseBtn.Size = UDim2.new(0,13,0,13); CloseBtn.Position = UDim2.new(1,-26,0.5,-6.5)
	CloseBtn.BackgroundColor3 = Color3.fromRGB(255,95,87); CloseBtn.Text = ""
	CloseBtn.AutoButtonColor = false; CloseBtn.ZIndex = 33
	Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1,0)
	CloseBtn.MouseButton1Click:Connect(function() Click(); Win.Visible = false end)

	local dragging, dragStart, startPos = false, nil, nil
	TBar.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			dragging = true; dragStart = i.Position; startPos = Win.Position
			i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then dragging = false end end)
		end
	end)
	UserInputService.InputChanged:Connect(function(i)
		if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
			local d = i.Position - dragStart
			Win.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
		end
	end)

	local Div = Instance.new("Frame", Win)
	Div.Size = UDim2.new(1,-24,0,1); Div.Position = UDim2.new(0,12,0,40)
	Div.BackgroundColor3 = Color3.fromRGB(255,255,255); Div.BackgroundTransparency = 0.9; Div.BorderSizePixel = 0; Div.ZIndex = 31

	MsgScroll = Instance.new("ScrollingFrame", Win)
	MsgScroll.Size = UDim2.new(1,-10,1,-90); MsgScroll.Position = UDim2.new(0,5,0,46)
	MsgScroll.BackgroundTransparency = 1; MsgScroll.BorderSizePixel = 0
	MsgScroll.CanvasSize = UDim2.new(0,0,0,0); MsgScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
	MsgScroll.ScrollBarThickness = 2; MsgScroll.ScrollBarImageColor3 = Color3.fromRGB(80,80,80)
	MsgScroll.ScrollingDirection = Enum.ScrollingDirection.Y; MsgScroll.ZIndex = 31
	MsgLayout = Instance.new("UIListLayout", MsgScroll)
	MsgLayout.Padding = UDim.new(0,5); MsgLayout.SortOrder = Enum.SortOrder.LayoutOrder
	local MP = Instance.new("UIPadding", MsgScroll)
	MP.PaddingLeft = UDim.new(0,8); MP.PaddingRight = UDim.new(0,8)
	MP.PaddingTop = UDim.new(0,6); MP.PaddingBottom = UDim.new(0,6)

	for _, entry in ipairs(history) do
		AppendRow(MsgScroll, entry)
	end

	local InputDiv = Instance.new("Frame", Win)
	InputDiv.Size = UDim2.new(1,-24,0,1); InputDiv.Position = UDim2.new(0,12,1,-44)
	InputDiv.BackgroundColor3 = Color3.fromRGB(255,255,255); InputDiv.BackgroundTransparency = 0.9; InputDiv.BorderSizePixel = 0; InputDiv.ZIndex = 31

	local InputRow = Instance.new("Frame", Win)
	InputRow.Size = UDim2.new(1,-12,0,34); InputRow.Position = UDim2.new(0,6,1,-42)
	InputRow.BackgroundTransparency = 1; InputRow.ZIndex = 32

	local ChatInput = Instance.new("TextBox", InputRow)
	ChatInput.Size = UDim2.new(1,-42,1,0); ChatInput.BackgroundColor3 = Color3.fromRGB(26,26,26)
	ChatInput.BackgroundTransparency = 0.15; ChatInput.Text = ""
	ChatInput.PlaceholderText = "Message..."; ChatInput.PlaceholderColor3 = Color3.fromRGB(65,65,65)
	ChatInput.TextColor3 = Color3.fromRGB(225,225,225); ChatInput.FontFace = GetFont()
	ChatInput.TextSize = 12; ChatInput.BorderSizePixel = 0; ChatInput.ZIndex = 33
	Instance.new("UICorner", ChatInput).CornerRadius = UDim.new(0,8)
	Instance.new("UIPadding", ChatInput).PaddingLeft = UDim.new(0,10)

	local SendBtn = Instance.new("TextButton", InputRow)
	SendBtn.Size = UDim2.new(0,36,1,0); SendBtn.Position = UDim2.new(1,-38,0,0)
	SendBtn.BackgroundColor3 = Color3.fromRGB(0,200,120); SendBtn.BackgroundTransparency = 0.2
	SendBtn.Text = "▶"; SendBtn.TextColor3 = Color3.fromRGB(255,255,255)
	SendBtn.FontFace = GetFont(); SendBtn.TextSize = 15; SendBtn.AutoButtonColor = false; SendBtn.ZIndex = 33
	Instance.new("UICorner", SendBtn).CornerRadius = UDim.new(0,8)
	SendBtn.MouseEnter:Connect(function() TweenService:Create(SendBtn, TweenInfo.new(0.12), {BackgroundTransparency = 0}):Play() end)
	SendBtn.MouseLeave:Connect(function() TweenService:Create(SendBtn, TweenInfo.new(0.12), {BackgroundTransparency = 0.2}):Play() end)

	local function DoSend()
		local txt = ChatInput.Text:match("^%s*(.-)%s*$")
		if txt == "" then return end
		Click()
		ChatInput.Text = ""
		local uc = UserColor(lp.Name)
		AddMessage(lp.Name, txt, math.floor(uc.R*255), math.floor(uc.G*255), math.floor(uc.B*255))
		SendUnfiltered(txt)
	end

	SendBtn.MouseButton1Click:Connect(DoSend)
	ChatInput.FocusLost:Connect(function(enter) if enter then DoSend() end end)

	for _, p in pairs(Players:GetPlayers()) do
		if p ~= lp then
			p.Chatted:Connect(function(msg)
				local uc = UserColor(p.Name)
				AddMessage(p.Name, msg, math.floor(uc.R*255), math.floor(uc.G*255), math.floor(uc.B*255))
			end)
		end
	end
	Players.PlayerAdded:Connect(function(p)
		p.Chatted:Connect(function(msg)
			local uc = UserColor(p.Name)
			AddMessage(p.Name, msg, math.floor(uc.R*255), math.floor(uc.G*255), math.floor(uc.B*255))
		end)
	end)

	MsgLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		MsgScroll.CanvasPosition = Vector2.new(0, MsgLayout.AbsoluteContentSize.Y)
	end)

	guiBuilt = true
end

function GlobalChat.HandleChat(msg, UI)
	local cmd = msg:lower():split(" ")[1]
	if cmd == ".chat" or cmd == "chat" or cmd == "globalchat" then
		BuildGUI()
		if Win then Win.Visible = true end
	end
end

LoadHistory()

return GlobalChat

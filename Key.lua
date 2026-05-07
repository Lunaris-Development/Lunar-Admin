if getgenv().LunarKeyLoaded then return end
getgenv().LunarKeyLoaded = true

local qot = queue_on_teleport or queueonteleport
if qot then
	qot('loadstring(game:HttpGet("https://raw.githubusercontent.com/Lunaris-Development/Lunar-Admin/main/Key.lua"))()')
end

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local Player = Players.LocalPlayer

local setclipboard = setclipboard or function() end
local HttpService = game:GetService("HttpService")

local function checkKey(inputKey)
	local trimmed = (inputKey or ""):match("^%s*(.-)%s*$")
	if trimmed == "" then return false end
	local ok, raw = pcall(function()
		return game:HttpGet("https://raw.githubusercontent.com/Lunaris-Development/Lunar-Admin/main/key.json")
	end)
	if ok and raw then
		local ok2, data = pcall(function() return HttpService:JSONDecode(raw) end)
		if ok2 and data and data.keys then
			for _, k in ipairs(data.keys) do
				if tostring(k) == trimmed then return true end
			end
			return false
		end
	end
	local ok3, result = pcall(function() return Junkie.check_key(trimmed) end)
	return ok3 and result and result.valid == true
end

local function getSavedKey()
	if not (isfile and readfile) then return nil end
	local ok, v = pcall(function()
		if isfile("LunarKey.txt") then
			local s = readfile("LunarKey.txt"):match("^%s*(.-)%s*$")
			return s ~= "" and s or nil
		end
	end)
	return ok and v or nil
end

local function tw(inst, props, t)
	TweenService:Create(inst, TweenInfo.new(t or 0.5, Enum.EasingStyle.Quart), props):Play()
end

local function new(class, props, parent)
	local inst = Instance.new(class)
	for k, v in pairs(props) do inst[k] = v end
	if parent then inst.Parent = parent end
	return inst
end

local function makeSound(id, vol)
	return new("Sound", {SoundId = "rbxassetid://" .. id, Volume = vol or 0.5}, CoreGui)
end

local sounds = {
	slideDown  = makeSound("12222200",   0.15),
	success    = makeSound("2027986581", 0.25),
	failure    = makeSound("7356986865", 0.25),
	slideUp    = makeSound("12222200",   0.15),
	click      = makeSound("7545317681", 0.2),
}

local Junkie = loadstring(game:HttpGet("https://jnkie.com/sdk/library.lua"))()
Junkie.service    = "Lunar"
Junkie.identifier = "1093800"
Junkie.provider   = "Lunar"

for _, v in pairs(CoreGui:GetChildren()) do
	if v.Name == "LunarKeyGui" then v:Destroy() end
end

local gui = new("ScreenGui", {
	Name             = "LunarKeyGui",
	IgnoreGuiInset   = true,
	DisplayOrder     = 999,
	ResetOnSpawn     = false,
}, CoreGui)

local main = new("Frame", {
	Size             = UDim2.new(0, 420, 0, 100),
	Position         = UDim2.new(0.5, 0, -0.25, 0),
	AnchorPoint      = Vector2.new(0.5, 0),
	BackgroundColor3 = Color3.fromRGB(15, 15, 20),
	BorderSizePixel  = 0,
}, gui)
new("UICorner", {CornerRadius = UDim.new(0, 14)}, main)

local shadow = new("Frame", {
	Size             = UDim2.new(1, 10, 1, 10),
	Position         = UDim2.new(0.5, 0, 0.5, 0),
	AnchorPoint      = Vector2.new(0.5, 0.5),
	BackgroundColor3 = Color3.fromRGB(0, 0, 0),
	BackgroundTransparency = 0.65,
	ZIndex           = -1,
}, main)
new("UICorner", {CornerRadius = UDim.new(0, 18)}, shadow)

local border = new("Frame", {
	Size        = UDim2.new(1, 2, 1, 2),
	Position    = UDim2.new(0.5, 0, 0.5, 0),
	AnchorPoint = Vector2.new(0.5, 0.5),
	ZIndex      = -1,
}, main)
new("UICorner", {CornerRadius = UDim.new(0, 15)}, border)
new("UIGradient", {
	Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0,   Color3.fromRGB(138, 43, 226)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(30, 144, 255)),
		ColorSequenceKeypoint.new(1,   Color3.fromRGB(0, 191, 255)),
	},
	Rotation = 45,
}, border)

local userId = Player and Player.UserId or 1

local pic = new("ImageLabel", {
	Size                 = UDim2.new(0, 40, 0, 40),
	Position             = UDim2.new(0, 18, 0, 18),
	AnchorPoint          = Vector2.new(0, 0),
	BackgroundTransparency = 1,
	Image                = ("rbxthumb://type=AvatarHeadShot&id=%d&w=48&h=48"):format(userId),
}, main)
new("UICorner", {CornerRadius = UDim.new(1, 0)}, pic)

local picBorder = new("Frame", {
	Size        = UDim2.new(1, 3, 1, 3),
	Position    = UDim2.new(0.5, 0, 0.5, 0),
	AnchorPoint = Vector2.new(0.5, 0.5),
	ZIndex      = -1,
}, pic)
new("UICorner", {CornerRadius = UDim.new(1, 0)}, picBorder)
new("UIGradient", {
	Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(138, 43, 226)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 144, 255)),
	},
	Rotation = 90,
}, picBorder)

local titleLbl = new("TextLabel", {
	Size                 = UDim2.new(1, -80, 0, 22),
	Position             = UDim2.new(0, 68, 0, 14),
	AnchorPoint          = Vector2.new(0, 0),
	BackgroundTransparency = 1,
	TextColor3           = Color3.fromRGB(255, 255, 255),
	TextSize             = 18,
	Font                 = Enum.Font.GothamBold,
	Text                 = "LUNAR ADMIN",
	TextTransparency     = 1,
	TextXAlignment       = Enum.TextXAlignment.Left,
}, main)

local statusLbl = new("TextLabel", {
	Size                 = UDim2.new(1, -80, 0, 16),
	Position             = UDim2.new(0, 68, 0, 40),
	AnchorPoint          = Vector2.new(0, 0),
	BackgroundTransparency = 1,
	TextColor3           = Color3.fromRGB(160, 160, 170),
	TextSize             = 13,
	Font                 = Enum.Font.Gotham,
	Text                 = "Initializing...",
	TextTransparency     = 1,
	TextXAlignment       = Enum.TextXAlignment.Left,
}, main)

local progressBg = new("Frame", {
	Size             = UDim2.new(1, -32, 0, 4),
	Position         = UDim2.new(0, 16, 1, -12),
	AnchorPoint      = Vector2.new(0, 1),
	BackgroundColor3 = Color3.fromRGB(32, 32, 42),
}, main)
new("UICorner", {CornerRadius = UDim.new(1, 0)}, progressBg)

local progressBar = new("Frame", {
	Size = UDim2.new(0, 0, 1, 0),
}, progressBg)
new("UICorner", {CornerRadius = UDim.new(1, 0)}, progressBar)
new("UIGradient", {
	Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(186, 85, 211)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 130, 255)),
	},
}, progressBar)

local keyContainer = new("Frame", {
	Size                 = UDim2.new(1, -32, 0, 120),
	Position             = UDim2.new(0.5, 0, 0, 108),
	AnchorPoint          = Vector2.new(0.5, 0),
	BackgroundTransparency = 1,
	Visible              = false,
}, main)

local keyInput = new("TextBox", {
	Size                = UDim2.new(1, 0, 0, 36),
	Position            = UDim2.new(0.5, 0, 0, 14),
	AnchorPoint         = Vector2.new(0.5, 0),
	BackgroundColor3    = Color3.fromRGB(26, 26, 34),
	PlaceholderText     = "Enter license key...",
	PlaceholderColor3   = Color3.fromRGB(100, 100, 115),
	Text                = "",
	TextColor3          = Color3.fromRGB(255, 255, 255),
	TextSize            = 13,
	Font                = Enum.Font.Gotham,
	ClearTextOnFocus    = false,
}, keyContainer)
new("UICorner", {CornerRadius = UDim.new(0, 10)}, keyInput)
new("UIPadding", {PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12)}, keyInput)
new("UIStroke", {Color = Color3.fromRGB(50, 50, 65), Thickness = 1}, keyInput)

local submitBtn = new("TextButton", {
	Size            = UDim2.new(0.48, 0, 0, 34),
	Position        = UDim2.new(0.25, 0, 0, 64),
	AnchorPoint     = Vector2.new(0.5, 0),
	Text            = "Authenticate",
	TextColor3      = Color3.fromRGB(255, 255, 255),
	TextSize        = 13,
	Font            = Enum.Font.GothamBold,
	AutoButtonColor = false,
}, keyContainer)
new("UICorner", {CornerRadius = UDim.new(0, 10)}, submitBtn)
new("UIGradient", {
	Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(138, 43, 226)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 144, 255)),
	},
	Rotation = 45,
}, submitBtn)

local getBtn = new("TextButton", {
	Size             = UDim2.new(0.48, 0, 0, 34),
	Position         = UDim2.new(0.75, 0, 0, 64),
	AnchorPoint      = Vector2.new(0.5, 0),
	BackgroundColor3 = Color3.fromRGB(42, 42, 54),
	Text             = "Get Key",
	TextColor3       = Color3.fromRGB(200, 200, 210),
	TextSize         = 13,
	Font             = Enum.Font.GothamBold,
	AutoButtonColor  = false,
}, keyContainer)
new("UICorner", {CornerRadius = UDim.new(0, 10)}, getBtn)
new("UIStroke", {Color = Color3.fromRGB(60, 60, 75), Thickness = 1}, getBtn)

local function closeUI()
	sounds.slideUp:Play()
	tw(main, {Position = UDim2.new(0.5, 0, -0.25, 0)}, 0.9)
	task.wait(1)
	gui:Destroy()
end

local function grantAccess(key)
	statusLbl.Text = "Welcome, " .. (Player and Player.Name or "User") .. "!"
	tw(statusLbl, {TextColor3 = Color3.fromRGB(0, 220, 130)}, 0.4)
	tw(progressBar, {Size = UDim2.new(0.6, 0, 1, 0)}, 0.5)
	getgenv().SCRIPT_KEY = key
	if writefile then writefile("LunarKey.txt", key) end

	task.wait(0.5)
	statusLbl.Text = "Loading Lunar Admin..."
	getgenv().LunarReady = false

	task.spawn(function()
		pcall(function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/Lunaris-Development/Lunar-Admin/main/Main.lua"))()
		end)
	end)

	local RunService = game:GetService("RunService")
	local creep = 0.6
	local conn = RunService.Heartbeat:Connect(function(dt)
		creep = math.min(creep + dt * 0.035, 0.97)
		progressBar.Size = UDim2.new(creep, 0, 1, 0)
	end)

	local elapsed = 0
	while not getgenv().LunarReady and elapsed < 20 do
		task.wait(0.1)
		elapsed += 0.1
	end

	conn:Disconnect()
	sounds.success:Play()
	tw(progressBar, {Size = UDim2.new(1, 0, 1, 0)}, 0.25)
	statusLbl.Text = "Ready!"
	task.wait(0.6)
	closeUI()
end

local function showKeyUI()
	sounds.slideDown:Play()
	tw(main, {Size = UDim2.new(0, 420, 0, 245)}, 0.7)
	task.wait(0.7)
	keyContainer.Visible = true
end

sounds.slideDown:Play()
tw(main, {Position = UDim2.new(0.5, 0, 0, 18)}, 1.1)
task.wait(0.35)
tw(titleLbl, {TextTransparency = 0}, 0.4)
task.wait(0.15)
tw(statusLbl, {TextTransparency = 0}, 0.4)
tw(progressBar, {Size = UDim2.new(0.45, 0, 1, 0)}, 0.8)

local savedKey = getSavedKey()
if savedKey then
	statusLbl.Text = "Validating saved key..."
	tw(progressBar, {Size = UDim2.new(0.55, 0, 1, 0)}, 0.4)
	if checkKey(savedKey) then
		tw(progressBar, {Size = UDim2.new(0.85, 0, 1, 0)}, 0.5)
		statusLbl.Text = "Loading Lunar Admin..."
		tw(statusLbl, {TextColor3 = Color3.fromRGB(0, 220, 130)}, 0.4)
		task.wait(0.6)
		grantAccess(savedKey)
	else
		statusLbl.Text = "Saved key expired"
		tw(statusLbl, {TextColor3 = Color3.fromRGB(255, 100, 100)}, 0.3)
		task.wait(1)
		statusLbl.Text = "Authentication required"
		tw(statusLbl, {TextColor3 = Color3.fromRGB(160, 160, 170)}, 0.3)
		showKeyUI()
	end
else
	statusLbl.Text = "Authentication required"
	task.wait(0.5)
	showKeyUI()
end

getBtn.MouseButton1Click:Connect(function()
	sounds.click:Play()
	setclipboard(Junkie.get_key_link())
	getBtn.Text = "Copied!"
	tw(getBtn, {BackgroundColor3 = Color3.fromRGB(0, 130, 80)}, 0.2)
	task.wait(2)
	getBtn.Text = "Get Key"
	tw(getBtn, {BackgroundColor3 = Color3.fromRGB(42, 42, 54)}, 0.2)
end)

submitBtn.MouseButton1Click:Connect(function()
	sounds.click:Play()
	local key = keyInput.Text
	if key == "" then
		statusLbl.Text = "Enter your license key"
		tw(statusLbl, {TextColor3 = Color3.fromRGB(255, 170, 50)}, 0.2)
		task.wait(1.5)
		statusLbl.Text = "Authentication required"
		tw(statusLbl, {TextColor3 = Color3.fromRGB(160, 160, 170)}, 0.2)
		return
	end
	statusLbl.Text = "Validating..."
	tw(statusLbl, {TextColor3 = Color3.fromRGB(160, 160, 170)}, 0.2)
	tw(progressBar, {Size = UDim2.new(0.7, 0, 1, 0)}, 0.5)
	task.wait(0.8)
	local valid = checkKey(key)
	if valid then
		tw(progressBar, {Size = UDim2.new(0.9, 0, 1, 0)}, 0.4)
		keyContainer.Visible = false
		tw(main, {Size = UDim2.new(0, 420, 0, 100)}, 0.6)
		task.wait(0.3)
		grantAccess(key)
	else
		sounds.failure:Play()
		statusLbl.Text = "Invalid key"
		tw(statusLbl, {TextColor3 = Color3.fromRGB(255, 80, 80)}, 0.2)
		tw(progressBar, {Size = UDim2.new(0.45, 0, 1, 0)}, 0.4)
		task.wait(2)
		statusLbl.Text = "Authentication required"
		tw(statusLbl, {TextColor3 = Color3.fromRGB(160, 160, 170)}, 0.2)
	end
end)

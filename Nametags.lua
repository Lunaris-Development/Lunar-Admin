local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LogoID = "rbxassetid://85404031245554"

local function GetFont() return Font.fromEnum(Enum.Font.GothamBold) end
local function GetFontSub() return Font.fromEnum(Enum.Font.Gotham) end

local Nametags = {}
local Connections = {}
local Active = true

local Roles = {
	["lnrs_dev"] = {
		label  = "LUNAR OWNER",
		color  = Color3.fromRGB(255, 90, 90),
		accent = ColorSequence.new{
			ColorSequenceKeypoint.new(0,   Color3.fromRGB(255, 60, 60)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 130, 40)),
			ColorSequenceKeypoint.new(1,   Color3.fromRGB(255, 210, 60)),
		},
		glitch = true,
	},
	["__default"] = {
		label  = "LUNAR USER",
		color  = Color3.fromRGB(120, 255, 165),
		accent = ColorSequence.new{
			ColorSequenceKeypoint.new(0,   Color3.fromRGB(40, 180, 110)),
			ColorSequenceKeypoint.new(1,   Color3.fromRGB(100, 255, 200)),
		},
		glitch = false,
	},
}

local function spawnParticles(Tag, tagFrame, rank)
	local c1 = rank.accent.Keypoints[1].Value
	local c2 = rank.accent.Keypoints[#rank.accent.Keypoints].Value
	for _ = 1, 6 do
		task.spawn(function()
			task.wait(math.random() * 1.2)
			while Tag and Tag.Parent do
				local sz = math.random(4, 9)
				local p = Instance.new("Frame")
				p.Size = UDim2.new(0, sz, 0, sz)
				p.Position = UDim2.new(math.random() * 0.75 + 0.1, 0, math.random() * 0.3 + 0.65, 0)
				p.BackgroundColor3 = math.random() > 0.5 and c1 or c2
				p.BackgroundTransparency = 0
				p.BorderSizePixel = 0
				p.ZIndex = 10
				p.Parent = Tag
				Instance.new("UICorner", p).CornerRadius = UDim.new(1, 0)
				local g = Instance.new("UIGradient", p)
				g.Color = rank.accent
				g.Rotation = math.random(0, 360)

				local dur = math.random(9, 18) / 10
				local drift = (math.random() - 0.5) * 0.35
				TweenService:Create(p, TweenInfo.new(dur, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					Position = UDim2.new(p.Position.X.Scale + drift, 0, -0.55, 0),
					BackgroundTransparency = 1,
					Size = UDim2.new(0, 0, 0, 0),
				}):Play()

				task.wait(dur)
				if p and p.Parent then p:Destroy() end
				task.wait(math.random(5, 18) / 100)
			end
		end)
	end
end

local function runGlitch(label, text)
	local gc = "!@#$%^&*<>?{}~█▓░▒"
	task.spawn(function()
		while label and label.Parent do
			task.wait(2.2 + math.random())
			for _ = 1, 6 do
				if not label.Parent then return end
				local g = ""
				for i = 1, #text do
					g = g .. (math.random() < 0.35 and gc:sub(math.random(1, #gc), math.random(1, #gc)) or text:sub(i, i))
				end
				label.Text = g
				task.wait(0.055)
			end
			label.Text = text
		end
	end)
end

local function runTypewriter(label, text)
	task.spawn(function()
		while label and label.Parent and Active do
			label.Text = ""
			for i = 1, #text do
				if not (label.Parent and Active) then return end
				label.Text = text:sub(1, i)
				task.wait(0.11)
			end
			task.wait(2)
			for i = #text, 0, -1 do
				if not (label.Parent and Active) then return end
				label.Text = text:sub(1, i)
				task.wait(0.065)
			end
			task.wait(0.4)
		end
	end)
end

function Nametags.Create(player)
	if not (player.Character and player.Character:FindFirstChild("Head")) then return end
	local Head = player.Character.Head
	if Head:FindFirstChild("LunarTag") then Head.LunarTag:Destroy() end

	local rank = Roles[player.Name] or Roles["__default"]

	local Tag = Instance.new("BillboardGui")
	Tag.Name = "LunarTag"
	Tag.Size = UDim2.new(0, 170, 0, 38)
	Tag.StudsOffset = Vector3.new(0, 3.2, 0)
	Tag.AlwaysOnTop = false
	Tag.MaxDistance = 150
	Tag.Parent = Head

	local BorderFrame = Instance.new("Frame", Tag)
	BorderFrame.Size = UDim2.new(1, 0, 1, 0)
	BorderFrame.BackgroundColor3 = Color3.new(1, 1, 1)
	BorderFrame.BorderSizePixel = 0
	BorderFrame.ZIndex = 1
	Instance.new("UICorner", BorderFrame).CornerRadius = UDim.new(0, 10)
	local BorderGrad = Instance.new("UIGradient", BorderFrame)
	BorderGrad.Color = rank.accent
	BorderGrad.Rotation = 45

	local TagFrame = Instance.new("Frame", Tag)
	TagFrame.Name = "TagContainer"
	TagFrame.Size = UDim2.new(1, -2, 1, -2)
	TagFrame.Position = UDim2.new(0, 1, 0, 1)
	TagFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 13)
	TagFrame.BackgroundTransparency = 0.08
	TagFrame.BorderSizePixel = 0
	TagFrame.ZIndex = 2
	Instance.new("UICorner", TagFrame).CornerRadius = UDim.new(0, 9)

	local Glow = Instance.new("ImageLabel", TagFrame)
	Glow.Size = UDim2.new(1.2, 0, 1.6, 0)
	Glow.Position = UDim2.new(-0.1, 0, -0.3, 0)
	Glow.BackgroundTransparency = 1
	Glow.Image = "rbxassetid://6015538162"
	Glow.ImageColor3 = rank.accent.Keypoints[1].Value
	Glow.ImageTransparency = 0.88
	Glow.ZIndex = 2

	local TagText = Instance.new("TextLabel", TagFrame)
	TagText.Size = UDim2.new(1, -14, 0, 18)
	TagText.Position = UDim2.new(0, 8, 0, 4)
	TagText.BackgroundTransparency = 1
	TagText.Text = rank.label
	TagText.TextColor3 = rank.color
	TagText.FontFace = GetFont()
	TagText.TextSize = 10
	TagText.TextXAlignment = Enum.TextXAlignment.Left
	TagText.TextTruncate = Enum.TextTruncate.AtEnd
	TagText.ZIndex = 4

	local SubText = Instance.new("TextLabel", TagFrame)
	SubText.Size = UDim2.new(1, -14, 0, 13)
	SubText.Position = UDim2.new(0, 8, 1, -16)
	SubText.BackgroundTransparency = 1
	SubText.Text = "@" .. player.Name
	SubText.TextColor3 = Color3.fromRGB(130, 130, 130)
	SubText.FontFace = GetFontSub()
	SubText.TextSize = 9
	SubText.TextXAlignment = Enum.TextXAlignment.Left
	SubText.TextTruncate = Enum.TextTruncate.AtEnd
	SubText.ZIndex = 4

	spawnParticles(Tag, TagFrame, rank)

	if rank.glitch then
		runGlitch(TagText, rank.label)
	else
		runTypewriter(TagText, rank.label)
	end

	task.spawn(function()
		while Tag.Parent do
			TweenService:Create(Glow, TweenInfo.new(1.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {ImageTransparency = 0.72}):Play()
			task.wait(1.8)
			TweenService:Create(Glow, TweenInfo.new(1.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {ImageTransparency = 0.92}):Play()
			task.wait(1.8)
		end
	end)

	if player ~= Players.LocalPlayer then
		local Ind = Instance.new("BillboardGui")
		Ind.Name = "LunarIndicator"
		Ind.StudsOffset = Vector3.new(0, 7, 0)
		Ind.AlwaysOnTop = true
		Ind.MaxDistance = math.huge
		Ind.LightInfluence = 0
		Ind.ResetOnSpawn = false
		Ind.Active = true
		Ind.Enabled = false
		Ind.Parent = Head

		local IndBtn = Instance.new("ImageButton", Ind)
		IndBtn.Size = UDim2.new(1, 0, 1, 0)
		IndBtn.BackgroundColor3 = rank.accent.Keypoints[1].Value
		IndBtn.BackgroundTransparency = 0.1
		IndBtn.Image = LogoID
		IndBtn.ImageTransparency = 0.15
		IndBtn.ScaleType = Enum.ScaleType.Fit
		IndBtn.AutoButtonColor = false
		Instance.new("UICorner", IndBtn).CornerRadius = UDim.new(1, 0)
		local IndGrad = Instance.new("UIGradient", IndBtn)
		IndGrad.Color = rank.accent
		IndGrad.Rotation = 135

		IndBtn.MouseButton1Click:Connect(function()
			local myHrp = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
			local theirHrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
			if myHrp and theirHrp then
				myHrp.CFrame = theirHrp.CFrame + Vector3.new(3, 0, 3)
			end
		end)

		local cam = workspace.CurrentCamera
		local rConn = RunService.RenderStepped:Connect(function()
			if not Head.Parent then rConn:Disconnect() return end
			local dist = (cam.CFrame.Position - Head.Position).Magnitude
			local show = dist > 300
			if Ind.Enabled ~= show then Ind.Enabled = show end
			if show then
				local fov = math.rad(cam.FieldOfView)
				local studsPerPixel = 2 * dist * math.tan(fov * 0.5) / cam.ViewportSize.Y
				local sz = math.clamp(46 * studsPerPixel, 0.3, 8)
				Ind.Size = UDim2.new(sz, 0, sz, 0)
			end
		end)

		Tag.AncestryChanged:Connect(function()
			if not Tag.Parent then rConn:Disconnect() end
		end)
	end
end

function Nametags.Unload()
	Active = false
	for _, v in pairs(Connections) do v:Disconnect() end
	for _, p in pairs(Players:GetPlayers()) do
		if p.Character and p.Character:FindFirstChild("Head") and p.Character.Head:FindFirstChild("LunarTag") then
			p.Character.Head.LunarTag:Destroy()
		end
	end
end

function Nametags.Init()
	Active = true
	local function IsUser(p)
		if p.Name == "lnrs_dev" then return true end
		if p.Character and p.Character:FindFirstChild("__LunarUser") then return true end
		if p:GetAttribute("LunarUser") then return true end
		return false
	end

	local function Mark(char)
		if not char:FindFirstChild("__LunarUser") then
			local v = Instance.new("StringValue")
			v.Name = "__LunarUser"
			v.Parent = char
		end
	end

	table.insert(Connections, Players.LocalPlayer.CharacterAdded:Connect(Mark))
	if Players.LocalPlayer.Character then Mark(Players.LocalPlayer.Character) end
	Players.LocalPlayer:SetAttribute("LunarUser", true)

	task.spawn(function()
		while task.wait(3) and Active do
			for _, p in pairs(Players:GetPlayers()) do
				if IsUser(p) then
					if p.Character and p.Character:FindFirstChild("Head") and not p.Character.Head:FindFirstChild("LunarTag") then
						Nametags.Create(p)
					end
				else
					if p.Character and p.Character:FindFirstChild("Head") and p.Character.Head:FindFirstChild("LunarTag") then
						p.Character.Head.LunarTag:Destroy()
					end
				end
			end
		end
	end)
end

return Nametags

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LogoID = "rbxthumb://type=Asset&id=73819038719454&w=420&h=420"

local function GetFont() return Font.fromEnum(Enum.Font.GothamBold) end
local function GetFontSub() return Font.fromEnum(Enum.Font.Gotham) end

local Nametags = {}
local Connections = {}
local Active = true

local function HumanType(label, text)
	label.Text = ""
	for i = 1, #text do
		if not Active then return end
		label.Text = string.sub(text, 1, i)
		task.wait(0.15)
	end
	task.wait(2)
	for i = #text, 0, -1 do
		if not Active then return end
		label.Text = string.sub(text, 1, i)
		task.wait(0.08)
	end
	task.wait(0.5)
end

function Nametags.Create(player)
	if player.Character and player.Character:FindFirstChild("Head") then
		local Head = player.Character.Head
		if Head:FindFirstChild("LunarTag") then Head.LunarTag:Destroy() end
		
		local Tag = Instance.new("BillboardGui")
		Tag.Name = "LunarTag"
		Tag.Size = UDim2.new(0, 190, 0, 52)
		Tag.StudsOffset = Vector3.new(0, 3.8, 0)
		Tag.AlwaysOnTop = false
		Tag.MaxDistance = 150
		Tag.Parent = Head

		local TagFrame = Instance.new("Frame")
		TagFrame.Size = UDim2.new(1, 0, 1, 0)
		TagFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
		TagFrame.BackgroundTransparency = 0.15
		TagFrame.BorderSizePixel = 0
		TagFrame.Parent = Tag
		Instance.new("UICorner", TagFrame).CornerRadius = UDim.new(0, 14)

		local TagStroke = Instance.new("UIStroke")
		TagStroke.Color = Color3.fromRGB(255, 255, 255)
		TagStroke.Transparency = 0.88
		TagStroke.Thickness = 1.2
		TagStroke.Parent = TagFrame

		local TagLogo = Instance.new("ImageLabel")
		TagLogo.Size = UDim2.new(0, 30, 0, 30)
		TagLogo.Position = UDim2.new(0, 11, 0.5, -15)
		TagLogo.BackgroundTransparency = 1
		TagLogo.Image = LogoID
		TagLogo.ScaleType = Enum.ScaleType.Fit
		TagLogo.Parent = TagFrame

		local Role = "LUNAR USER"
		local RoleColor = Color3.fromRGB(120, 255, 160)

		if player.Name == "lnrs_dev" then
			Role = "LUNAR OWNER"
			RoleColor = Color3.fromRGB(255, 90, 90)
			TagStroke.Color = RoleColor
			TagStroke.Transparency = 0.6
		end

		local TagText = Instance.new("TextLabel")
		TagText.Size = UDim2.new(1, -50, 0, 22)
		TagText.Position = UDim2.new(0, 46, 0, 7)
		TagText.BackgroundTransparency = 1
		TagText.Text = ""
		TagText.TextColor3 = RoleColor
		TagText.FontFace = GetFont()
		TagText.TextSize = 12
		TagText.TextXAlignment = Enum.TextXAlignment.Left
		TagText.TextTruncate = Enum.TextTruncate.None
		TagText.Parent = TagFrame

		local SubText = Instance.new("TextLabel")
		SubText.Size = UDim2.new(1, -50, 0, 16)
		SubText.Position = UDim2.new(0, 46, 0, 29)
		SubText.BackgroundTransparency = 1
		SubText.Text = "@" .. player.Name
		SubText.TextColor3 = Color3.fromRGB(160, 160, 160)
		SubText.FontFace = GetFontSub()
		SubText.TextSize = 9
		SubText.TextXAlignment = Enum.TextXAlignment.Left
		SubText.Parent = TagFrame
		
		task.spawn(function()
			while Tag.Parent and Active do
				HumanType(TagText, Role)
			end
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

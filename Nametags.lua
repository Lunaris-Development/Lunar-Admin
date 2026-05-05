local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LogoID = "rbxassetid://73819038719454"

local Nametags = {}

local function HumanType(label, text)
	for i = 1, #text do
		label.Text = string.sub(text, 1, i)
		task.wait(0.15)
	end
	task.wait(2)
	for i = #text, 0, -1 do
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
		Tag.Size = UDim2.new(0, 160, 0, 50)
		Tag.StudsOffset = Vector3.new(0, 3.5, 0)
		Tag.AlwaysOnTop = true
		Tag.Parent = Head
		
		local TagFrame = Instance.new("Frame")
		TagFrame.Size = UDim2.new(1, 0, 1, 0)
		TagFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
		TagFrame.BackgroundTransparency = 0.2
		TagFrame.Parent = Tag
		
		local TagCorner = Instance.new("UICorner")
		TagCorner.CornerRadius = UDim.new(0, 12)
		TagCorner.Parent = TagFrame
		
		local TagStroke = Instance.new("UIStroke")
		TagStroke.Color = Color3.fromRGB(255, 255, 255)
		TagStroke.Transparency = 0.85
		TagStroke.Thickness = 1.5
		TagStroke.Parent = TagFrame
		
		local TagLogo = Instance.new("ImageLabel")
		TagLogo.Size = UDim2.new(0, 28, 0, 28)
		TagLogo.Position = UDim2.new(0, 10, 0.5, -14)
		TagLogo.BackgroundTransparency = 1
		TagLogo.Image = LogoID
		TagLogo.Parent = TagFrame
		
		local Role = "LUNAR USER"
		local RoleColor = Color3.fromRGB(150, 255, 150)
		
		if player.Name == "lnrs_dev" then
			Role = "LUNAR OWNER"
			RoleColor = Color3.fromRGB(255, 100, 100)
			TagStroke.Color = RoleColor
		end
		
		local TagText = Instance.new("TextLabel")
		TagText.Size = UDim2.new(1, -45, 0.5, 0)
		TagText.Position = UDim2.new(0, 42, 0, 10)
		TagText.BackgroundTransparency = 1
		TagText.Text = ""
		TagText.TextColor3 = RoleColor
		TagText.Font = Enum.Font.GothamBold
		TagText.TextSize = 11
		TagText.TextXAlignment = Enum.TextXAlignment.Left
		TagText.Parent = TagFrame
		
		local SubText = Instance.new("TextLabel")
		SubText.Size = UDim2.new(1, -45, 0.5, 0)
		SubText.Position = UDim2.new(0, 42, 0.5, -4)
		SubText.BackgroundTransparency = 1
		SubText.Text = "@" .. player.Name
		SubText.TextColor3 = Color3.fromRGB(200, 200, 200)
		SubText.Font = Enum.Font.Gotham
		SubText.TextSize = 9
		SubText.TextXAlignment = Enum.TextXAlignment.Left
		SubText.Parent = TagFrame
		
		task.spawn(function()
			while Tag.Parent do
				HumanType(TagText, Role)
			end
		end)
	end
end

function Nametags.Init()
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

	Players.LocalPlayer.CharacterAdded:Connect(Mark)
	if Players.LocalPlayer.Character then Mark(Players.LocalPlayer.Character) end
	Players.LocalPlayer:SetAttribute("LunarUser", true)

	task.spawn(function()
		while task.wait(3) do
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

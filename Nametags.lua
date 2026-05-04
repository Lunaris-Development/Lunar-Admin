local Players = game:GetService("Players")
local LogoID = "rbxassetid://95343151225680"

local Nametags = {}

function Nametags.Create(player)
	if player.Character and player.Character:FindFirstChild("Head") then
		local Head = player.Character.Head
		if Head:FindFirstChild("LunarTag") then Head.LunarTag:Destroy() end
		
		local Tag = Instance.new("BillboardGui")
		Tag.Name = "LunarTag"
		Tag.Size = UDim2.new(0, 120, 0, 40)
		Tag.StudsOffset = Vector3.new(0, 2.5, 0)
		Tag.AlwaysOnTop = true
		Tag.Parent = Head
		
		local TagFrame = Instance.new("Frame")
		TagFrame.Size = UDim2.new(1, 0, 1, 0)
		TagFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
		TagFrame.BackgroundTransparency = 0.3
		TagFrame.Parent = Tag
		
		local TagCorner = Instance.new("UICorner")
		TagCorner.CornerRadius = UDim.new(0, 8)
		TagCorner.Parent = TagFrame
		
		local TagStroke = Instance.new("UIStroke")
		TagStroke.Color = Color3.fromRGB(150, 255, 150)
		TagStroke.Transparency = 0.5
		TagStroke.Thickness = 1
		TagStroke.Parent = TagFrame
		
		local TagLogo = Instance.new("ImageLabel")
		TagLogo.Size = UDim2.new(0, 20, 0, 20)
		TagLogo.Position = UDim2.new(0, 8, 0.5, -10)
		TagLogo.BackgroundTransparency = 1
		TagLogo.Image = LogoID
		TagLogo.Parent = TagFrame
		
		local TagText = Instance.new("TextLabel")
		TagText.Size = UDim2.new(1, -35, 0.5, 0)
		TagText.Position = UDim2.new(0, 32, 0, 5)
		TagText.BackgroundTransparency = 1
		TagText.Text = "LUNAR USER"
		TagText.TextColor3 = Color3.fromRGB(150, 255, 150)
		TagText.Font = Enum.Font.GothamBold
		TagText.TextSize = 10
		TagText.TextXAlignment = Enum.TextXAlignment.Left
		TagText.Parent = TagFrame
		
		local SubText = Instance.new("TextLabel")
		SubText.Size = UDim2.new(1, -35, 0.5, 0)
		SubText.Position = UDim2.new(0, 32, 0.5, -5)
		SubText.BackgroundTransparency = 1
		SubText.Text = "@" .. player.Name
		SubText.TextColor3 = Color3.fromRGB(200, 200, 200)
		SubText.Font = Enum.Font.Gotham
		SubText.TextSize = 8
		SubText.TextXAlignment = Enum.TextXAlignment.Left
		SubText.Parent = TagFrame
	end
end

function Nametags.Init()
	for _, p in pairs(Players:GetPlayers()) do
		if p.Character then Nametags.Create(p) end
		p.CharacterAdded:Connect(function()
			task.wait(1)
			Nametags.Create(p)
		end)
	end
	
	Players.PlayerAdded:Connect(function(p)
		p.CharacterAdded:Connect(function()
			task.wait(1)
			Nametags.Create(p)
		end)
	end)
end

return Nametags

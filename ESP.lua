local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local ESP = {}
local Enabled = false
local Connections = {}
local Highlights = {}

local function CreateHighlight(player)
	if player == Players.LocalPlayer then return end
	if Highlights[player] then return end
	
	local highlight = Instance.new("Highlight")
	highlight.Name = "LunarESP"
	highlight.FillColor = Color3.fromRGB(150, 100, 250)
	highlight.FillTransparency = 0.5
	highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
	highlight.OutlineTransparency = 0
	highlight.Adornee = player.Character
	highlight.Parent = player.Character
	
	Highlights[player] = highlight
end

function ESP.Toggle(state)
	Enabled = state
	if state then
		for _, p in pairs(Players:GetPlayers()) do
			if p.Character then CreateHighlight(p) end
			table.insert(Connections, p.CharacterAdded:Connect(function(char)
				task.wait(0.5)
				if Enabled then CreateHighlight(p) end
			end))
		end
		table.insert(Connections, Players.PlayerAdded:Connect(function(p)
			table.insert(Connections, p.CharacterAdded:Connect(function()
				task.wait(0.5)
				if Enabled then CreateHighlight(p) end
			end))
		end))
	else
		for _, c in pairs(Connections) do c:Disconnect() end
		for _, h in pairs(Highlights) do h:Destroy() end
		Connections = {}
		Highlights = {}
	end
end

return ESP

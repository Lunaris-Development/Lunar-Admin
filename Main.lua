local BaseURL = "https://raw.githubusercontent.com/Lunaris-Development/Lunar-Admin/main/"
local function GetBust() return "?t=" .. tostring(math.random(1, 100000)) end

if writefile and isfile and not isfile("Minecraft.ttf") then
	pcall(function()
		writefile("Minecraft.ttf", game:HttpGet(BaseURL .. "Minecraft.ttf"))
	end)
end

local function Load(file)
	local content = game:HttpGet(BaseURL .. file .. GetBust())
	return loadstring(content)()
end

local UI = Load("UI.lua")
local Nametags = Load("Nametags.lua")
local Commands = Load("Commands.lua")

UI.Init(Nametags, Commands)
Nametags.Init()

game:GetService("Players").LocalPlayer.Chatted:Connect(function(msg)
	pcall(function()
		Commands.HandleChat(msg, UI)
	end)
end)

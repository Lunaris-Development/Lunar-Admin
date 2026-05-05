if getgenv().LunarLoaded and game:GetService("CoreGui"):FindFirstChild("LunarDynamicIsland") then 
	warn("Lunar Admin is already running!")
	return 
end
getgenv().LunarLoaded = true

local BaseURL = "https://raw.githubusercontent.com/Lunaris-Development/Lunar-Admin/main/"
local function GetBust() return "?t=" .. tostring(math.random(1, 100000)) end

local function SetupFont()
	if writefile and isfile then
		if not isfile("Minecraft.ttf") then
			local success, result = pcall(function()
				return game:HttpGet(BaseURL .. "Minecraft.ttf")
			end)
			if success and result then
				writefile("Minecraft.ttf", result)
			end
		end
	end
end

SetupFont()

local function Load(file)
	local content = game:HttpGet(BaseURL .. file .. GetBust())
	return loadstring(content)()
end

local UI = Load("UI.lua")
local Nametags = Load("Nametags.lua")
local ESP = Load("ESP.lua")
local Commands = Load("Commands.lua")

UI.Init(Nametags, Commands, ESP)
Nametags.Init()

game:GetService("Players").LocalPlayer.Chatted:Connect(function(msg)
	pcall(function()
		Commands.HandleChat(msg, UI, ESP)
	end)
end)

if getgenv().LunarLoaded and game:GetService("CoreGui"):FindFirstChild("LunarDynamicIsland") then 
	warn("Lunar Admin is already running!")
	return 
end
getgenv().LunarLoaded = true

local BaseURL = "https://raw.githubusercontent.com/Lunaris-Development/Lunar-Admin/main/"
local function GetBust() return "?t=" .. tostring(tick()) end

local function SetupFont()
	if not (writefile and isfile and getcustomasset) then return end
	if isfile("Minecraft.ttf") then return end
	local ok, data
	if request then
		ok, data = pcall(function()
			local res = request({ Url = BaseURL .. "Minecraft.ttf", Method = "GET" })
			return res and res.Body
		end)
	end
	if not (ok and data and #data > 1000) then
		ok, data = pcall(game.HttpGet, game, BaseURL .. "Minecraft.ttf")
	end
	if ok and data and #data > 1000 then
		pcall(writefile, "Minecraft.ttf", data)
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

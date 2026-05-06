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
local Freecam = Load("Freecam.lua")
local AntiAFK = Load("AntiAFK.lua")
local ClickTP = Load("ClickTP.lua")
local LagSpoof = Load("LagSpoof.lua")
local UserSpoofer = Load("UserSpoofer.lua")
local ServerInfo = Load("ServerInfo.lua")
local ServerList = Load("ServerList.lua")
local LoopSpeed = Load("LoopSpeed.lua")
local TouchFling = Load("TouchFling.lua")
local ShLow = Load("ShLow.lua")
local ShMost = Load("ShMost.lua")
local Noclip = Load("Noclip.lua")
local InfJump = Load("InfJump.lua")
local GodMode = Load("GodMode.lua")
local PlayerTP = Load("PlayerTP.lua")

local allModules = {
	Freecam, AntiAFK, ClickTP, LagSpoof, UserSpoofer,
	ServerInfo, ServerList, LoopSpeed, TouchFling,
	ShLow, ShMost, Noclip, InfJump, GodMode, PlayerTP
}

local Commands = {}
setmetatable(Commands, {
	__newindex = function(t, k, v)
		rawset(t, k, v)
		if k == "_UI" then Freecam._UI = v end
	end
})

function Commands.HandleChat(msg, UI_ref, ESP_ref, silent)
	for _, mod in ipairs(allModules) do
		if mod.HandleChat then
			pcall(mod.HandleChat, msg, UI_ref or Commands._UI, ESP_ref, silent)
		end
	end
end

Commands.ToggleFreecam = function(UI_ref)
	if Freecam.ToggleFreecam then Freecam.ToggleFreecam(UI_ref) end
end

UI.Init(Nametags, Commands, ESP)
Nametags.Init()

game:GetService("Players").LocalPlayer.Chatted:Connect(function(msg)
	pcall(function()
		Commands.HandleChat(msg, UI, ESP)
	end)
end)

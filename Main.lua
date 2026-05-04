local BaseURL = "https://raw.githubusercontent.com/Lunaris-Development/Lunar-Admin/main/"

local function Load(file)
	return loadstring(game:HttpGet(BaseURL .. file))()
end

local UI = Load("UI.lua")
local Nametags = Load("Nametags.lua")

UI.Init()
Nametags.Init()

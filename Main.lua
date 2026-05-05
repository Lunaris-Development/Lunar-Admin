local BaseURL = "https://raw.githubusercontent.com/Lunaris-Development/Lunar-Admin/main/"
local CacheBuster = "?t=" .. os.time()

local function Load(file)
	local content = game:HttpGet(BaseURL .. file .. CacheBuster)
	return loadstring(content)()
end

local UI = Load("UI.lua")
local Nametags = Load("Nametags.lua")

UI.Init()
Nametags.Init()

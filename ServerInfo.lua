local Players = game:GetService("Players")

local lp = Players.LocalPlayer
local ServerInfo = {}

local function show(UI)
	local count = #Players:GetPlayers()
	local ping = math.floor(lp:GetNetworkPing() * 1000)
	local age = math.floor(workspace.DistributedGameTime / 60)
	local id = game.JobId:sub(1, 8)
	print("[Lunar] Players: " .. count .. " | Ping: " .. ping .. "ms | Age: " .. age .. "m | ID: " .. id)
	if UI then UI.Notify("P:" .. count .. " | " .. ping .. "ms | " .. age .. "m", "Success") end
end

function ServerInfo.HandleChat(msg, UI)
	local cmd = msg:lower():split(" ")[1]
	if cmd == "serverinfo" or cmd == "sinfo" then show(UI) end
end

return ServerInfo

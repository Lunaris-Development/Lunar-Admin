local Players = game:GetService("Players")

local lp = Players.LocalPlayer
local LagSpoof = {}
local active = false

local function toggle(UI)
	active = not active
	local char = lp.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not hrp then active = false return end
	hrp.Anchored = active
	if UI then UI.Notify("Lag Spoof: " .. (active and "ON" or "OFF"), active and "Success" or "Warn") end
end

function LagSpoof.HandleChat(msg, UI)
	local cmd = msg:lower():split(" ")[1]
	if cmd == "lag" or cmd == "lagspoof" then toggle(UI) end
end

return LagSpoof

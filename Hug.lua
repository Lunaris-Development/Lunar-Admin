local Players = game:GetService("Players")

local lp = Players.LocalPlayer
local Hug = {}

local function hugNearest(UI)
	local myHrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
	if not myHrp then return end
	local closest, closestDist = nil, math.huge
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= lp and p.Character then
			local hrp = p.Character:FindFirstChild("HumanoidRootPart")
			if hrp then
				local d = (hrp.Position - myHrp.Position).Magnitude
				if d < closestDist then closestDist = d closest = p end
			end
		end
	end
	if closest and closest.Character then
		local tHrp = closest.Character:FindFirstChild("HumanoidRootPart")
		if tHrp then
			myHrp.CFrame = tHrp.CFrame * CFrame.new(2, 0, 0)
			if UI then UI.Notify("Hugged " .. closest.Name .. " 🤗", "Success") end
		end
	else
		if UI then UI.Notify("No players nearby", "Error") end
	end
end

local function hugPlayer(name, UI)
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= lp and p.Name:lower():find(name:lower(), 1, true) and p.Character then
			local myHrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
			local tHrp = p.Character:FindFirstChild("HumanoidRootPart")
			if myHrp and tHrp then
				myHrp.CFrame = tHrp.CFrame * CFrame.new(2, 0, 0)
				if UI then UI.Notify("Hugged " .. p.Name, "Success") end
			end
			return
		end
	end
	if UI then UI.Notify("Player not found", "Error") end
end

function Hug.HandleChat(msg, UI)
	local parts = msg:lower():split(" ")
	if parts[1] == "hug" then
		if parts[2] then hugPlayer(parts[2], UI) else hugNearest(UI) end
	end
end

return Hug

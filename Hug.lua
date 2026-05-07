local Players = game:GetService("Players")

local lp = Players.LocalPlayer
local Hug = {}

local HUG_ANIM_IDS = {3696902348, 3838500271, 5915965836}
local FALLBACK_ID = 507770239

local function tryAnim(hum, id)
	local ok, track = pcall(function()
		local anim = Instance.new("Animation")
		anim.AnimationId = "rbxassetid://" .. tostring(id)
		local t = hum.Animator:LoadAnimation(anim)
		t.Priority = Enum.AnimationPriority.Action
		t:Play()
		return t
	end)
	return ok and track or nil
end

local function playHugAnim(hum)
	for _, id in ipairs(HUG_ANIM_IDS) do
		local t = tryAnim(hum, id)
		if t then return t end
	end
	return tryAnim(hum, FALLBACK_ID)
end

local function hugTarget(target, UI)
	local myHrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
	local myHum = lp.Character and lp.Character:FindFirstChild("Humanoid")
	local tHrp = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
	if not myHrp or not myHum or not tHrp then return end
	myHrp.CFrame = tHrp.CFrame * CFrame.new(1.8, 0, 0)
	playHugAnim(myHum)
	if UI then UI.Notify("Hugged " .. target.Name, "Success") end
end

local function nearest()
	local myHrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
	if not myHrp then return end
	local best, bestD = nil, math.huge
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= lp and p.Character then
			local h = p.Character:FindFirstChild("HumanoidRootPart")
			if h then
				local d = (h.Position - myHrp.Position).Magnitude
				if d < bestD then bestD = d best = p end
			end
		end
	end
	return best
end

function Hug.HandleChat(msg, UI)
	local parts = msg:lower():split(" ")
	if parts[1] ~= "hug" then return end
	if parts[2] then
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= lp and p.Name:lower():find(parts[2], 1, true) then
				hugTarget(p, UI); return
			end
		end
		if UI then UI.Notify("Player not found", "Error") end
	else
		local t = nearest()
		if t then hugTarget(t, UI)
		else if UI then UI.Notify("No players nearby", "Error") end
		end
	end
end

return Hug

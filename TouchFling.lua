local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")

local lp = Players.LocalPlayer
local TouchFling = {}
local active = false
local conn = nil

local function fling(target)
	local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
	local tHrp = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
	if not hrp or not tHrp then return end
	local bv = Instance.new("BodyVelocity")
	bv.Velocity = (tHrp.Position - hrp.Position).Unit * 500 + Vector3.new(0, 200, 0)
	bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
	bv.Parent = tHrp
	Debris:AddItem(bv, 0.1)
end

local function toggle(UI)
	active = not active
	if active then
		conn = RunService.Heartbeat:Connect(function()
			local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
			if not hrp then return end
			for _, p in ipairs(Players:GetPlayers()) do
				if p ~= lp and p.Character then
					local tHrp = p.Character:FindFirstChild("HumanoidRootPart")
					if tHrp and (tHrp.Position - hrp.Position).Magnitude < 10 then
						fling(p)
					end
				end
			end
		end)
		if UI then UI.Notify("TouchFling: ON", "Success") end
	else
		if conn then conn:Disconnect() conn = nil end
		if UI then UI.Notify("TouchFling: OFF", "Warn") end
	end
end

function TouchFling.HandleChat(msg, UI)
	local cmd = msg:lower():split(" ")[1]
	if cmd == "touchfling" or cmd == "tfling" then toggle(UI) end
end

return TouchFling

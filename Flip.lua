local Players = game:GetService("Players")
local Debris = game:GetService("Debris")

local lp = Players.LocalPlayer
local Flip = {}

local function doFlip(forward, UI)
	local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
	local hum = lp.Character and lp.Character:FindFirstChild("Humanoid")
	if not hrp or not hum then return end

	local bv = Instance.new("BodyVelocity")
	bv.Velocity = Vector3.new(0, 70, 0)
	bv.MaxForce = Vector3.new(0, math.huge, 0)
	bv.Parent = hrp
	Debris:AddItem(bv, 0.18)

	local bav = Instance.new("BodyAngularVelocity")
	bav.AngularVelocity = Vector3.new(forward and -28 or 28, 0, 0)
	bav.MaxTorque = Vector3.new(math.huge, 0, 0)
	bav.Parent = hrp
	Debris:AddItem(bav, 0.55)

	if UI then UI.Notify((forward and "Front" or "Back") .. "flip!", "Success") end
end

function Flip.HandleChat(msg, UI)
	local cmd = msg:lower():split(" ")[1]
	if cmd == "flip" or cmd == "frontflip" or cmd == "ff" then doFlip(true, UI)
	elseif cmd == "bflip" or cmd == "backflip" or cmd == "bf" then doFlip(false, UI)
	end
end

return Flip

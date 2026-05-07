local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local lp = Players.LocalPlayer
local ProperFling = {}

function ProperFling.Fling(targetPlayer)
	local char = lp.Character
	local hum  = char and char:FindFirstChildOfClass("Humanoid")
	local hrp  = char and char:FindFirstChild("HumanoidRootPart")
	if not char or not hum or not hrp then return end

	local tChar = targetPlayer.Character
	if not tChar then return end
	local tHum = tChar:FindFirstChildOfClass("Humanoid")
	local tHrp = tChar:FindFirstChild("HumanoidRootPart")
	local tHead = tChar:FindFirstChild("Head")
	if not tHum or not tHrp then return end

	local tPart = (tHrp and tHead and (tHrp.Position - tHead.Position).Magnitude > 5) and tHead or tHrp

	local savedCF = hrp.CFrame

	workspace.FallenPartsDestroyHeight = 0/0

	local bv = Instance.new("BodyVelocity")
	bv.Velocity  = Vector3.new(-9e9, 9e9, -9e9)
	bv.MaxForce  = Vector3.new(-9e9, 9e9, -9e9)
	bv.Parent    = hrp

	local bg = Instance.new("BodyGyro")
	bg.CFrame    = CFrame.new(hrp.Position)
	bg.D         = 9e8
	bg.MaxTorque = Vector3.new(-9e9, 9e9, -9e9)
	bg.P         = -9e9
	bg.Parent    = hrp

	local bp = Instance.new("BodyPosition")
	bp.Position  = hrp.Position
	bp.D         = 9e8
	bp.MaxForce  = Vector3.new(-9e9, 9e9, -9e9)
	bp.P         = -9e9
	bp.Parent    = hrp

	local function mmmm(part, posOff, angOff)
		hrp.CFrame      = CFrame.new(part.Position) * posOff * angOff
		hrp.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
	end

	local function randAng()
		return CFrame.Angles(
			math.random(0, 1) == 0 and 0 or math.pi,
			math.random(0, 1) == 0 and 0 or math.pi,
			math.random(0, 1) == 0 and 0 or math.pi
		)
	end

	local t0      = tick()
	local maxTime = 0.134
	local moveDir = tHum.MoveDirection

	repeat
		if not hrp.Parent or not tPart.Parent then break end
		moveDir = tHum.MoveDirection
		if tPart.Velocity.Magnitude < 30 then
			mmmm(tPart, CFrame.new(0,1.5,0) + moveDir * tPart.Velocity.Magnitude/5,   randAng())
			RunService.Heartbeat:Wait()
			mmmm(tPart, CFrame.new(0,1.5,0) + moveDir * tPart.Velocity.Magnitude/1.25, randAng())
			RunService.Heartbeat:Wait()
			mmmm(tPart, CFrame.new(0,-1.5,0) + moveDir * tPart.Velocity.Magnitude/1.25, randAng())
			RunService.Heartbeat:Wait()
		else
			mmmm(tPart, CFrame.new(0,-1.5,0), CFrame.Angles(0,0,0))
			RunService.Heartbeat:Wait()
		end
	until tPart.Velocity.Magnitude > 1000
		or tPart.Parent ~= tChar
		or targetPlayer.Parent ~= Players
		or hum.Health <= 0
		or tick() > t0 + maxTime

	bv:Destroy(); bg:Destroy(); bp:Destroy()

	for _, p in ipairs(char:GetDescendants()) do
		if p:IsA("BasePart") then
			p.Velocity    = Vector3.zero
			p.RotVelocity = Vector3.zero
		end
	end

	hum:ChangeState(Enum.HumanoidStateType.GettingUp)
	hrp.CFrame = savedCF
end

function ProperFling.HandleChat() end

return ProperFling

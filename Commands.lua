local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local Commands = { _UI = nil }

local pi = math.pi
local clamp = math.clamp
local exp = math.exp
local rad = math.rad
local sqrt = math.sqrt
local tan = math.tan

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local NAV_GAIN = Vector3.new(1, 1, 1)*64
local PAN_GAIN = Vector2.new(0.75, 1)*8
local PITCH_LIMIT = rad(90)

local Spring = {}
Spring.__index = Spring
function Spring.new(freq, pos)
	local self = setmetatable({}, Spring)
	self.f = freq
	self.p = pos
	self.v = pos*0
	return self
end
function Spring:Update(dt, goal)
	local f = self.f*2*pi
	local offset = goal - self.p
	local decay = exp(-f*dt)
	self.p = goal + (self.v*dt - offset*(f*dt + 1))*decay
	self.v = (f*dt*(offset*f - self.v) + self.v)*decay
	return self.p
end
function Spring:Reset(pos) self.p = pos; self.v = pos*0 end

local cameraPos = Vector3.new()
local cameraRot = Vector2.new()
local velSpring = Spring.new(1.5, Vector3.new())
local panSpring = Spring.new(1.0, Vector2.new())

local keyboard = {W=0,A=0,S=0,D=0,E=0,Q=0,Up=0,Down=0,Left=0,Right=0}
local mouseDelta = Vector2.new()

local function GetInputs(dt)
	local navSpeed = clamp(1 + dt*(keyboard.Up - keyboard.Down)*0.75, 0.01, 4)
	local kKeyboard = Vector3.new(keyboard.D - keyboard.A, keyboard.E - keyboard.Q, keyboard.S - keyboard.W)
	local shift = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift)
	return kKeyboard * (navSpeed * (shift and 0.25 or 1))
end

local function StepFreecam(dt)
	Camera.CameraType = Enum.CameraType.Scriptable
	local vel = velSpring:Update(dt, GetInputs(dt))
	local pan = panSpring:Update(dt, mouseDelta * (pi/64))
	mouseDelta = Vector2.new()
	
	cameraRot = cameraRot + pan * PAN_GAIN * dt
	cameraRot = Vector2.new(clamp(cameraRot.x, -PITCH_LIMIT, PITCH_LIMIT), cameraRot.y%(2*pi))
	
	local rotation = CFrame.fromOrientation(cameraRot.x, cameraRot.y, 0)
	cameraPos = cameraPos + rotation:VectorToWorldSpace(vel * NAV_GAIN * dt)
	
	Camera.CFrame = CFrame.new(cameraPos) * rotation
	
	local char = LocalPlayer.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		char.HumanoidRootPart.Anchored = true
	end
end

local freecamEnabled = false
local oldWS = 16

function Commands.ToggleFreecam(UI)
	freecamEnabled = not freecamEnabled
	local char = LocalPlayer.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	
	if freecamEnabled then
		if UI and UI.Notify then UI.Notify("Freecam Enabled. Toggle with Ctrl + P") end
		if char and char:FindFirstChild("Humanoid") then
			oldWS = char.Humanoid.WalkSpeed
			char.Humanoid.WalkSpeed = 0
		end
		
		cameraPos = Camera.CFrame.p
		cameraRot = Vector2.new(Camera.CFrame:toEulerAnglesYXZ())
		velSpring:Reset(Vector3.new())
		panSpring:Reset(Vector2.new())
		
		RunService:BindToRenderStep("LunarFreecam", Enum.RenderPriority.Camera.Value + 1, StepFreecam)
		
		UserInputService.InputBegan:Connect(function(input, gpe)
			if not freecamEnabled then return end
			local n = input.KeyCode.Name
			if keyboard[n] ~= nil then keyboard[n] = 1 end
		end)
		
		UserInputService.InputEnded:Connect(function(input)
			local n = input.KeyCode.Name
			if keyboard[n] ~= nil then keyboard[n] = 0 end
		end)
		
		UserInputService.InputChanged:Connect(function(input)
			if not freecamEnabled then return end
			if input.UserInputType == Enum.UserInputType.MouseMovement then
				mouseDelta = Vector2.new(-input.Delta.y, -input.Delta.x)
			end
		end)
	else
		if UI and UI.Notify then UI.Notify("Freecam Disabled") end
		if char and char:FindFirstChild("Humanoid") then char.Humanoid.WalkSpeed = oldWS end
		if hrp then hrp.Anchored = false end
		RunService:UnbindFromRenderStep("LunarFreecam")
		Camera.CameraType = Enum.CameraType.Custom
	end
end

function Commands.HandleChat(msg, UI)
	local prefix = "l?"
	if msg:sub(1, 2) == prefix then
		local args = msg:sub(3):split(" ")
		local cmd = args[1]:lower()
		if cmd == "freecam" then Commands.ToggleFreecam(UI)
		elseif cmd == "cmds" then if UI and UI.ToggleMenu then UI.ToggleMenu() end end
	end
end

UserInputService.InputBegan:Connect(function(input, gpe)
	if not gpe and input.KeyCode == Enum.KeyCode.P and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
		Commands.ToggleFreecam(Commands._UI)
	end
end)

return Commands

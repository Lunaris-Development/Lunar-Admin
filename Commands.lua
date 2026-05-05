local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")

local Commands = {}

local pi = math.pi
local abs = math.abs
local clamp = math.clamp
local exp = math.exp
local rad = math.rad
local sign = math.sign
local sqrt = math.sqrt
local tan = math.tan

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local NAV_GAIN = Vector3.new(1, 1, 1)*64
local PAN_GAIN = Vector2.new(0.75, 1)*8
local FOV_GAIN = 300
local ROLL_GAIN = -pi/2
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
	local p0 = self.p
	local v0 = self.v
	local offset = goal - p0
	local decay = exp(-f*dt)
	local p1 = goal + (v0*dt - offset*(f*dt + 1))*decay
	local v1 = (f*dt*(offset*f - v0) + v0)*decay
	self.p = p1
	self.v = v1
	return p1
end
function Spring:SetFreq(freq) self.f = freq end
function Spring:Reset(pos) self.p = pos; self.v = pos*0 end

local cameraPos = Vector3.new()
local cameraRot = Vector2.new()
local cameraFov = 0
local velSpring = Spring.new(1.5, Vector3.new())
local panSpring = Spring.new(1.0, Vector2.new())
local fovSpring = Spring.new(4.0, 0)

local keyboard = {W=0,A=0,S=0,D=0,E=0,Q=0,Up=0,Down=0,Left=0,Right=0}
local mouse = {Delta = Vector2.new()}

local function GetInputs(dt)
	local navSpeed = clamp(1 + dt*(keyboard.Up - keyboard.Down)*0.75, 0.01, 4)
	local kKeyboard = Vector3.new(keyboard.D - keyboard.A, keyboard.E - keyboard.Q, keyboard.S - keyboard.W)
	local shift = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift)
	return kKeyboard * (navSpeed * (shift and 0.25 or 1))
end

local function StepFreecam(dt)
	local vel = velSpring:Update(dt, GetInputs(dt))
	local pan = panSpring:Update(dt, mouse.Delta * (pi/64))
	mouse.Delta = Vector2.new()
	local zoomFactor = sqrt(tan(rad(70/2))/tan(rad(cameraFov/2)))
	cameraRot = cameraRot + pan * PAN_GAIN * (dt/zoomFactor)
	cameraRot = Vector2.new(clamp(cameraRot.x, -PITCH_LIMIT, PITCH_LIMIT), cameraRot.y%(2*pi))
	local cameraCFrame = CFrame.new(cameraPos) * CFrame.fromOrientation(cameraRot.x, cameraRot.y, 0) * CFrame.new(vel * NAV_GAIN * dt)
	cameraPos = cameraCFrame.p
	Camera.CFrame = cameraCFrame
	Camera.Focus = cameraCFrame
	Camera.FieldOfView = cameraFov
end

local freecamEnabled = false
local oldWS = 16

function Commands.ToggleFreecam(UI)
	freecamEnabled = not freecamEnabled
	local char = LocalPlayer.Character
	if freecamEnabled then
		if UI and UI.Notify then UI.Notify("Freecam Enabled. Toggle with Ctrl + P") end
		if char and char:FindFirstChild("Humanoid") then
			oldWS = char.Humanoid.WalkSpeed
			char.Humanoid.WalkSpeed = 0
		end
		Camera.CameraType = Enum.CameraType.Scriptable
		local cameraCFrame = Camera.CFrame
		cameraRot = Vector2.new(cameraCFrame:toEulerAnglesYXZ())
		cameraPos = cameraCFrame.p
		cameraFov = Camera.FieldOfView
		velSpring:Reset(Vector3.new())
		panSpring:Reset(Vector2.new())
		fovSpring:Reset(0)
		RunService:BindToRenderStep("LunarFreecam", Enum.RenderPriority.Camera.Value, StepFreecam)
		ContextActionService:BindAction("FreecamInput", function(_, state, input)
			if input.UserInputType == Enum.UserInputType.Keyboard then
				local n = input.KeyCode.Name
				if keyboard[n] ~= nil then keyboard[n] = state == Enum.UserInputState.Begin and 1 or 0 end
			elseif input.UserInputType == Enum.UserInputType.MouseMovement then
				mouse.Delta = Vector2.new(-input.Delta.y, -input.Delta.x)
			end
			return Enum.ContextActionResult.Sink
		end, false, Enum.ContextActionPriority.High.Value, Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D, Enum.KeyCode.E, Enum.KeyCode.Q, Enum.KeyCode.Up, Enum.KeyCode.Down, Enum.UserInputType.MouseMovement)
	else
		if UI and UI.Notify then UI.Notify("Freecam Disabled") end
		if char and char:FindFirstChild("Humanoid") then char.Humanoid.WalkSpeed = oldWS end
		RunService:UnbindFromRenderStep("LunarFreecam")
		ContextActionService:UnbindAction("FreecamInput")
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

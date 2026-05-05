local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local Commands = { _UI = nil }
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local freecamActive = false
local freecamConn = nil
local fcKeysDown = {}
local fcRotating = false

local function toggleFreecam(UI)
	freecamActive = not freecamActive
	local char = LocalPlayer.Character
	local hum = char and char:FindFirstChild("Humanoid")
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	
	if freecamActive then
		if hum then hum.PlatformStand = true end
		if hrp then hrp.Anchored = true end
		Camera.CameraType = Enum.CameraType.Scriptable
		
		freecamConn = RunService.RenderStepped:Connect(function()
			if not freecamActive then return end
			local spd = 0.5
			if fcRotating then
				local delta = UserInputService:GetMouseDelta()
				local cf = Camera.CFrame
				cf = cf * CFrame.Angles(-math.rad(delta.Y * 0.3), 0, 0)
				cf = CFrame.Angles(0, -math.rad(delta.X * 0.3), 0) * (cf - cf.Position) + cf.Position
				Camera.CFrame = cf
				UserInputService.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition
			else
				UserInputService.MouseBehavior = Enum.MouseBehavior.Default
			end
			
			if fcKeysDown[Enum.KeyCode.W] then Camera.CFrame = Camera.CFrame * CFrame.new(0, 0, -spd) end
			if fcKeysDown[Enum.KeyCode.S] then Camera.CFrame = Camera.CFrame * CFrame.new(0, 0, spd) end
			if fcKeysDown[Enum.KeyCode.A] then Camera.CFrame = Camera.CFrame * CFrame.new(-spd, 0, 0) end
			if fcKeysDown[Enum.KeyCode.D] then Camera.CFrame = Camera.CFrame * CFrame.new(spd, 0, 0) end
		end)
		if UI and UI.Notify then UI.Notify("Freecam: ON") end
	else
		if freecamConn then freecamConn:Disconnect() freecamConn = nil end
		if hum then hum.PlatformStand = false end
		if hrp then hrp.Anchored = false end
		Camera.CameraType = Enum.CameraType.Custom
		UserInputService.MouseBehavior = Enum.MouseBehavior.Default
		if UI and UI.Notify then UI.Notify("Freecam: OFF") end
	end
end

UserInputService.InputBegan:Connect(function(input, gpe)
	if input.UserInputType == Enum.UserInputType.Keyboard then
		fcKeysDown[input.KeyCode] = true
	elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
		fcRotating = true
	end
	
	if not gpe and input.KeyCode == Enum.KeyCode.P and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
		toggleFreecam(Commands._UI)
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Keyboard then
		fcKeysDown[input.KeyCode] = false
	elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
		fcRotating = false
	end
end)

function Commands.ToggleFreecam(UI) toggleFreecam(UI) end

function Commands.HandleChat(msg, UI, ESP)
	local prefix = "l?"
	if msg:sub(1, 2) == prefix then
		local args = msg:sub(3):split(" ")
		local cmd = args[1]:lower()
		if cmd == "freecam" then toggleFreecam(UI)
		elseif cmd == "esp" then if ESP then ESP.Toggle(not ESP.Enabled) end
		elseif cmd == "cmds" then if UI and UI.ToggleMenu then UI.ToggleMenu() end end
	end
end

return Commands

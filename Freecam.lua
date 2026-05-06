local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local lp = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Commands = { _UI = nil }

local isMobile = UserInputService.TouchEnabled

local freecamActive = false
local freecamConn = nil
local fcKeysDown = {}
local fcRotating = false
local fcSpeed = 1.2
local touchPos = nil
local touchDelta = Vector2.new(0, 0)

local function toggleFreecam(UI)
	freecamActive = not freecamActive
	local char = lp.Character
	local hum = char and char:FindFirstChild("Humanoid")
	local hrp = char and char:FindFirstChild("HumanoidRootPart")

	if freecamActive then
		if hum then hum.PlatformStand = true end
		if hrp then hrp.Anchored = true end
		Camera.CameraType = Enum.CameraType.Scriptable

		freecamConn = RunService.RenderStepped:Connect(function()
			if not freecamActive then return end
			local spd = fcSpeed

			if fcRotating then
				local delta
				if isMobile then
					delta = touchDelta
					touchDelta = Vector2.new(0, 0)
				else
					delta = UserInputService:GetMouseDelta()
					UserInputService.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition
				end
				local cf = Camera.CFrame
				cf = cf * CFrame.Angles(-math.rad(delta.Y * 0.3), 0, 0)
				cf = CFrame.Angles(0, -math.rad(delta.X * 0.3), 0) * (cf - cf.Position) + cf.Position
				Camera.CFrame = cf
			else
				if not isMobile then
					UserInputService.MouseBehavior = Enum.MouseBehavior.Default
				end
			end

			if isMobile then
				local md = (lp.Character and lp.Character:FindFirstChild("Humanoid") and lp.Character.Humanoid.MoveDirection) or Vector3.zero
				if md.Magnitude > 0.1 then
					Camera.CFrame = Camera.CFrame * CFrame.new(md.X * spd, 0, md.Z * spd)
				end
			else
				if fcKeysDown[Enum.KeyCode.W] then Camera.CFrame = Camera.CFrame * CFrame.new(0, 0, -spd) end
				if fcKeysDown[Enum.KeyCode.S] then Camera.CFrame = Camera.CFrame * CFrame.new(0, 0, spd) end
				if fcKeysDown[Enum.KeyCode.A] then Camera.CFrame = Camera.CFrame * CFrame.new(-spd, 0, 0) end
				if fcKeysDown[Enum.KeyCode.D] then Camera.CFrame = Camera.CFrame * CFrame.new(spd, 0, 0) end
				if fcKeysDown[Enum.KeyCode.E] then Camera.CFrame = Camera.CFrame * CFrame.new(0, spd, 0) end
				if fcKeysDown[Enum.KeyCode.Q] then Camera.CFrame = Camera.CFrame * CFrame.new(0, -spd, 0) end
			end
		end)
		if UI and UI.Notify then UI.Notify("Freecam: ON" .. (isMobile and " (drag to rotate)" or ""), "Success") end
	else
		if freecamConn then freecamConn:Disconnect() freecamConn = nil end
		if hum then hum.PlatformStand = false end
		if hrp then hrp.Anchored = false end
		Camera.CameraType = Enum.CameraType.Custom
		if not isMobile then UserInputService.MouseBehavior = Enum.MouseBehavior.Default end
		if UI and UI.Notify then UI.Notify("Freecam: OFF", "Warn") end
	end
end

local flyActive = false
local function toggleFly(UI)
	flyActive = not flyActive
	local char = lp.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	local hum = char and char:FindFirstChild("Humanoid")

	if not hrp or not hum then return end

	if flyActive then
		local bv = Instance.new("BodyVelocity")
		bv.Name = "LunarFly"
		bv.Velocity = Vector3.new(0, 0, 0)
		bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
		bv.Parent = hrp

		local bg = Instance.new("BodyGyro")
		bg.Name = "LunarGyro"
		bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
		bg.CFrame = hrp.CFrame
		bg.Parent = hrp

		hum.PlatformStand = true
		if UI and UI.Notify then UI.Notify("Fly: ON", "Success") end
		if UI and UI.UpdateFlightStatus then UI.UpdateFlightStatus(true, hum.WalkSpeed) end

		task.spawn(function()
			while flyActive and hrp.Parent do
				local move = Vector3.new(0, 0, 0)

				if isMobile then
					local md = hum.MoveDirection
					if md.Magnitude > 0.1 then
						move = Vector3.new(md.X, Camera.CFrame.LookVector.Y * md.Magnitude, md.Z)
					end
				else
					if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + Camera.CFrame.LookVector end
					if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - Camera.CFrame.LookVector end
					if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - Camera.CFrame.RightVector end
					if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + Camera.CFrame.RightVector end
					if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 1, 0) end
					if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then move = move - Vector3.new(0, 1, 0) end
				end

				bv.Velocity = move * (hum.WalkSpeed * 2)
				bg.CFrame = Camera.CFrame
				RunService.RenderStepped:Wait()
			end
			if bv then bv:Destroy() end
			if bg then bg:Destroy() end
			hum.PlatformStand = false
		end)
	else
		if hrp:FindFirstChild("LunarFly") then hrp.LunarFly:Destroy() end
		if hrp:FindFirstChild("LunarGyro") then hrp.LunarGyro:Destroy() end
		hum.PlatformStand = false
		if UI and UI.Notify then UI.Notify("Fly: OFF", "Warn") end
		if UI and UI.UpdateFlightStatus then UI.UpdateFlightStatus(false) end
	end
end

UserInputService.InputBegan:Connect(function(input, gpe)
	if input.UserInputType == Enum.UserInputType.Keyboard then
		fcKeysDown[input.KeyCode] = true
	elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
		fcRotating = true
	elseif input.UserInputType == Enum.UserInputType.Touch then
		touchPos = input.Position
		if freecamActive then fcRotating = true end
	end

	if freecamActive and not gpe then
		if input.KeyCode == Enum.KeyCode.B then
			fcSpeed = math.min(fcSpeed + 1, 50)
			if Commands._UI then Commands._UI.Notify("FC Speed: " .. fcSpeed, "Success") end
		end
	end

	if not gpe and input.KeyCode == Enum.KeyCode.P and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
		toggleFreecam(Commands._UI)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch and freecamActive and fcRotating and touchPos then
		touchDelta = Vector2.new(input.Position.X - touchPos.X, input.Position.Y - touchPos.Y)
		touchPos = input.Position
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Keyboard then
		fcKeysDown[input.KeyCode] = false
	elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
		fcRotating = false
	elseif input.UserInputType == Enum.UserInputType.Touch then
		fcRotating = false
		touchPos = nil
		touchDelta = Vector2.new(0, 0)
	end
end)

function Commands.ToggleFreecam(UI) toggleFreecam(UI) end

function Commands.HandleChat(msg, UI, ESP, silent)
	local cleanMsg = msg:lower()
	local args = cleanMsg:split(" ")
	local cmd = args[1]

	if cmd:sub(1, 2) == "l?" then
		cmd = cmd:sub(3)
	end

	if cmd == "freecam" or cmd == "fc" then
		toggleFreecam(UI)
	elseif cmd == "fly" then
		toggleFly(UI)
	elseif cmd == "speed" or cmd == "ws" then
		local num = tonumber(args[2])
		if num and lp.Character and lp.Character:FindFirstChild("Humanoid") then
			lp.Character.Humanoid.WalkSpeed = num
			if UI and not silent then
				UI.Notify("Speed: " .. num, "Success")
			end
			if UI and UI.UpdateFlightStatus and flyActive then
				UI.UpdateFlightStatus(true, num)
			end
		elseif not num then
			fcSpeed = 1.2
			if UI and not silent then UI.Notify("FC Speed Reset", "Warn") end
		end
	elseif cmd == "esp" then
		if ESP then
			ESP.Toggle(not ESP.Enabled)
			if UI then UI.Notify("ESP " .. (ESP.Enabled and "ON" or "OFF"), ESP.Enabled and "Success" or "Warn") end
		end
	elseif cmd == "cmds" then
		if UI and UI.ToggleMenu then UI.ToggleMenu() end
	end
end

return Commands

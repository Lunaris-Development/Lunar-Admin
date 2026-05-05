local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local lp = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Commands = { _UI = nil }

local freecamActive = false
local freecamConn = nil
local fcKeysDown = {}
local fcRotating = false
local fcSpeed = 1.2

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
			if fcKeysDown[Enum.KeyCode.E] then Camera.CFrame = Camera.CFrame * CFrame.new(0, spd, 0) end
			if fcKeysDown[Enum.KeyCode.Q] then Camera.CFrame = Camera.CFrame * CFrame.new(0, -spd, 0) end
		end)
		if UI and UI.Notify then UI.Notify("Freecam: ON", "Success") end
	else
		if freecamConn then freecamConn:Disconnect() freecamConn = nil end
		if hum then hum.PlatformStand = false end
		if hrp then hrp.Anchored = false end
		Camera.CameraType = Enum.CameraType.Custom
		UserInputService.MouseBehavior = Enum.MouseBehavior.Default
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
		if UI and UI.UpdateFlightStatus then UI.UpdateFlightStatus(true, hum.WalkSpeed * 2) end
		
		task.spawn(function()
			while flyActive and hrp.Parent do
				local move = Vector3.new(0, 0, 0)
				if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + Camera.CFrame.LookVector end
				if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - Camera.CFrame.LookVector end
				if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - Camera.CFrame.RightVector end
				if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + Camera.CFrame.RightVector end
				if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 1, 0) end
				if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then move = move - Vector3.new(0, 1, 0) end
				
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

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Keyboard then
		fcKeysDown[input.KeyCode] = false
	elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
		fcRotating = false
	end
end)

function Commands.ToggleFreecam(UI) toggleFreecam(UI) end

function Commands.HandleChat(msg, UI, ESP)
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
			if UI then 
				UI.Notify("Speed: " .. num, "Success")
				if flyActive then UI.UpdateFlightStatus(true, num * 2) end
			end
		elseif not num then
			fcSpeed = 1.2
			if UI then UI.Notify("FC Speed Reset", "Warn") end
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

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local lp = Players.LocalPlayer
local Commands = {}
Commands.freecamEnabled = false
Commands.flyEnabled = false

local function toggleFreecam(UI)
	Commands.freecamEnabled = not Commands.freecamEnabled
	local char = lp.Character
	local hum = char and char:FindFirstChild("Humanoid")
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	local cam = workspace.CurrentCamera

	if Commands.freecamEnabled then
		if hum then hum.PlatformStand = true end
		if hrp then hrp.Anchored = true end
		cam.CameraType = Enum.CameraType.Scriptable
		if UI then UI.Notify("Freecam Enabled", "Success") end
	else
		if hum then hum.PlatformStand = false end
		if hrp then hrp.Anchored = false end
		cam.CameraType = Enum.CameraType.Custom
		if UI then UI.Notify("Freecam Disabled", "Warn") end
	end
end

local fcKeysDown = {}
local fcRotating = false

local function toggleFly(UI)
	Commands.flyEnabled = not Commands.flyEnabled
	local char = lp.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	local hum = char and char:FindFirstChild("Humanoid")
	
	if not hrp or not hum then return end
	
	if Commands.flyEnabled then
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
		if UI then UI.Notify("Fly Enabled", "Success") end
		
		task.spawn(function()
			while Commands.flyEnabled and hrp.Parent do
				local cam = workspace.CurrentCamera
				local move = Vector3.new(0, 0, 0)
				if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + cam.CFrame.LookVector end
				if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - cam.CFrame.LookVector end
				if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - cam.CFrame.RightVector end
				if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + cam.CFrame.RightVector end
				if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 1, 0) end
				if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then move = move - Vector3.new(0, 1, 0) end
				
				bv.Velocity = move * (hum.WalkSpeed * 2)
				bg.CFrame = cam.CFrame
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
		if UI then UI.Notify("Fly Disabled", "Warn") end
	end
end

RunService.RenderStepped:Connect(function()
	if Commands.freecamEnabled then
		local cam = workspace.CurrentCamera
		local spd = 0.8
		local cf = cam.CFrame
		if UserInputService:IsKeyDown(Enum.KeyCode.W) then cf = cf * CFrame.new(0, 0, -spd) end
		if UserInputService:IsKeyDown(Enum.KeyCode.S) then cf = cf * CFrame.new(0, 0, spd) end
		if UserInputService:IsKeyDown(Enum.KeyCode.A) then cf = cf * CFrame.new(-spd, 0, 0) end
		if UserInputService:IsKeyDown(Enum.KeyCode.D) then cf = cf * CFrame.new(spd, 0, 0) end
		if UserInputService:IsKeyDown(Enum.KeyCode.E) then cf = cf * CFrame.new(0, spd, 0) end
		if UserInputService:IsKeyDown(Enum.KeyCode.Q) then cf = cf * CFrame.new(0, -spd, 0) end
		
		if fcRotating then
			local delta = UserInputService:GetMouseDelta()
			local rotX = -delta.Y * 0.2
			local rotY = -delta.X * 0.2
			cf = cf * CFrame.Angles(math.rad(rotX), 0, 0)
			cf = CFrame.new(cf.Position) * CFrame.Angles(0, math.rad(rotY), 0) * CFrame.Angles(math.rad(rotX), 0, 0)
		end
		cam.CFrame = cf
	end
end)

UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.UserInputType == Enum.UserInputType.MouseButton2 then
		fcRotating = true
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton2 then
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
		local num = tonumber(args[2]) or 16
		if lp.Character and lp.Character:FindFirstChild("Humanoid") then
			lp.Character.Humanoid.WalkSpeed = num
			if UI then UI.Notify("Speed set to " .. num, "Success") end
		end
	elseif cmd == "esp" then
		if ESP then 
			ESP.Toggle(not ESP.Enabled) 
			if UI then UI.Notify("ESP " .. (ESP.Enabled and "Enabled" or "Disabled"), ESP.Enabled and "Success" or "Warn") end
		end
	elseif cmd == "cmds" then
		if UI and UI.ToggleMenu then UI.ToggleMenu() end
	end
end

return Commands

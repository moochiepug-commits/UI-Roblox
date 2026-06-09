local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local mouse = player:GetMouse()
local isMobile = UserInputService.TouchEnabled

-- ==========================================
-- GALAXY THEME CONFIGURATION
-- ==========================================
local Theme = {
	Background = Color3.fromRGB(12, 8, 18),       -- Deep Space Black/Purple
	Sidebar = Color3.fromRGB(20, 15, 30),         -- Dark Galaxy Purple
	Accent = Color3.fromRGB(170, 85, 255),        -- Neon Galaxy Purple Glow
	AccentHover = Color3.fromRGB(200, 130, 255),  -- Bright Purple
	ElementBG = Color3.fromRGB(25, 20, 35),       -- Mid-tone Purple
	TextMain = Color3.fromRGB(240, 240, 255),     -- Starlight White
	TextDim = Color3.fromRGB(140, 130, 160)       -- Faded Purple-Grey
}

-- Mobile Adaptive GUI Positioning & Executor Bypass
local guiParent = player:WaitForChild("PlayerGui")
pcall(function()
	local core = game:GetService("CoreGui")
	if core then guiParent = core end
end)

local gui = Instance.new("ScreenGui")
gui.Name = "DeltaGalaxyV7_MobilePlus"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = guiParent

-- Notification System
local notifFrame = Instance.new("Frame", gui)
notifFrame.Size = UDim2.new(0, 280, 1, 0)
notifFrame.Position = isMobile and UDim2.new(1, -290, 0, 10) or UDim2.new(1, -310, 0, 0)
notifFrame.BackgroundTransparency = 1
local notifLayout = Instance.new("UIListLayout", notifFrame)
notifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
notifLayout.Padding = UDim.new(0, 10)

local function SendNotification(title, text, duration)
	duration = duration or 3
	local bg = Instance.new("Frame", notifFrame)
	bg.Size = UDim2.new(1, 0, 0, 60) bg.BackgroundColor3 = Theme.Sidebar bg.BackgroundTransparency = 0.1
	Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 8)
	local stroke = Instance.new("UIStroke", bg) stroke.Color = Theme.Accent stroke.Thickness = 1.5
	
	local t = Instance.new("TextLabel", bg)
	t.Size = UDim2.new(1, -10, 0, 20) t.Position = UDim2.new(0, 10, 0, 5) t.BackgroundTransparency = 1
	t.Text = title t.TextColor3 = Theme.Accent t.Font = Enum.Font.GothamBold t.TextSize = 14 t.TextXAlignment = Enum.TextXAlignment.Left
	
	local d = Instance.new("TextLabel", bg)
	d.Size = UDim2.new(1, -20, 0, 30) d.Position = UDim2.new(0, 10, 0, 25) d.BackgroundTransparency = 1
	d.Text = text d.TextColor3 = Theme.TextMain d.Font = Enum.Font.Gotham d.TextSize = 12 d.TextWrapped = true d.TextXAlignment = Enum.TextXAlignment.Left
	
	task.delay(duration, function()
		if bg and bg.Parent then
			TweenService:Create(bg, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
			TweenService:Create(stroke, TweenInfo.new(0.3), {Transparency = 1}):Play()
			TweenService:Create(t, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
			TweenService:Create(d, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
			task.wait(0.3) bg:Destroy()
		end
	end)
end

-- ==========================================
-- MAIN INTERFACE BUILDER
-- ==========================================
local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = isMobile and UDim2.new(0, 440, 0, 260) or UDim2.new(0, 520, 0, 360)
mainFrame.Position = UDim2.new(0.5, isMobile and -220 or -260, 0.5, isMobile and -130 or -180)
mainFrame.BackgroundColor3 = Theme.Background
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", mainFrame).Color = Theme.Accent

-- Mobile Smooth Dragging Core
local dragging, dragStart, startPos
mainFrame.InputBegan:Connect(function(inp)
	if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then 
		dragging = true dragStart = inp.Position startPos = mainFrame.Position 
	end
end)
UserInputService.InputChanged:Connect(function(inp)
	if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
		local delta = inp.Position - dragStart 
		mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)
UserInputService.InputEnded:Connect(function(inp)
	if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)

local titleBar = Instance.new("Frame", mainFrame)
titleBar.Size = UDim2.new(1, 0, 0, 40) titleBar.BackgroundColor3 = Theme.Sidebar
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 10)
local cover = Instance.new("Frame", titleBar) cover.Size = UDim2.new(1, 0, 0, 10) cover.Position = UDim2.new(0, 0, 1, -10) cover.BackgroundColor3 = Theme.Sidebar cover.BorderSizePixel = 0

local titleText = Instance.new("TextLabel", titleBar)
titleText.Size = UDim2.new(1, -60, 1, 0) titleText.Position = UDim2.new(0, 15, 0, 0) titleText.BackgroundTransparency = 1
titleText.Text = "DELTA ◆ GALAXY V7" titleText.TextColor3 = Theme.Accent titleText.Font = Enum.Font.GothamBlack titleText.TextSize = isMobile and 14 or 16 titleText.TextXAlignment = Enum.TextXAlignment.Left

local toggleIcon = Instance.new("TextButton", gui)
toggleIcon.Size = UDim2.new(0, 50, 0, 50) toggleIcon.Position = UDim2.new(0.05, 0, 0.15, 0) toggleIcon.BackgroundColor3 = Theme.Sidebar toggleIcon.Text = "🌌" toggleIcon.TextSize = 24 toggleIcon.Visible = false
Instance.new("UICorner", toggleIcon).CornerRadius = UDim.new(1, 0) Instance.new("UIStroke", toggleIcon).Color = Theme.Accent

local closeBtn = Instance.new("TextButton", titleBar)
closeBtn.Size = UDim2.new(0, 30, 0, 30) closeBtn.Position = UDim2.new(1, -40, 0.5, -15) closeBtn.BackgroundTransparency = 1 closeBtn.Text = "━" closeBtn.TextColor3 = Theme.TextMain closeBtn.TextSize = 16
closeBtn.MouseButton1Click:Connect(function() mainFrame.Visible = false toggleIcon.Visible = true end)
toggleIcon.MouseButton1Click:Connect(function() mainFrame.Visible = true toggleIcon.Visible = false end)

local sidebar = Instance.new("Frame", mainFrame)
sidebar.Size = UDim2.new(0, isMobile and 100 or 120, 1, -40) sidebar.Position = UDim2.new(0, 0, 0, 40) sidebar.BackgroundColor3 = Theme.Sidebar
Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 10)
local tabLayout = Instance.new("UIListLayout", sidebar) tabLayout.Padding = UDim.new(0, 5) tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local contentArea = Instance.new("Frame", mainFrame)
contentArea.Size = UDim2.new(1, isMobile and -110 or -130, 1, -50) contentArea.Position = UDim2.new(0, isMobile and 105 or 125, 0, 45) contentArea.BackgroundTransparency = 1

local Tabs = {}
local function CreateTab(name)
	local btn = Instance.new("TextButton", sidebar)
	btn.Size = UDim2.new(1, -10, 0, 35) btn.BackgroundTransparency = 1 btn.Text = name btn.TextColor3 = Theme.TextDim btn.Font = Enum.Font.GothamBold btn.TextSize = isMobile and 12 or 14
	local scroll = Instance.new("ScrollingFrame", contentArea)
	scroll.Size = UDim2.new(1, 0, 1, 0) scroll.BackgroundTransparency = 1 scroll.Visible = false scroll.ScrollBarThickness = 3 scroll.ScrollBarImageColor3 = Theme.Accent
	local list = Instance.new("UIListLayout", scroll) list.Padding = UDim.new(0, 8) list.SortOrder = Enum.SortOrder.LayoutOrder
	list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() scroll.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y + 20) end)
	Tabs[name] = {Btn = btn, Scroll = scroll}
	btn.MouseButton1Click:Connect(function()
		for _, t in pairs(Tabs) do t.Scroll.Visible = false t.Btn.TextColor3 = Theme.TextDim end
		scroll.Visible = true btn.TextColor3 = Theme.Accent
	end)
	return scroll
end

-- ==========================================
-- UI COMPONENT GENERATORS (WITH SMART TOGGLE LOGIC)
-- ==========================================
local function CreateButton(tabName, text, callback)
	local btn = Instance.new("TextButton", Tabs[tabName].Scroll)
	btn.Size = UDim2.new(1, -10, 0, 40) btn.BackgroundColor3 = Theme.ElementBG btn.Text = "  " .. text btn.TextColor3 = Theme.TextMain btn.Font = Enum.Font.GothamSemibold btn.TextSize = 13 btn.TextXAlignment = Enum.TextXAlignment.Left
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6) Instance.new("UIStroke", btn).Color = Color3.fromRGB(60,40,80)
	btn.MouseButton1Click:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Theme.AccentHover}):Play()
		task.spawn(callback)
		task.wait(0.1)
		TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Theme.ElementBG}):Play()
	end)
end

local function CreateToggle(tabName, text, default, callback)
	local state = default
	local btn = Instance.new("TextButton", Tabs[tabName].Scroll)
	btn.Size = UDim2.new(1, -10, 0, 40) btn.BackgroundColor3 = Theme.ElementBG btn.Text = "  " .. text btn.TextColor3 = Theme.TextMain btn.Font = Enum.Font.GothamSemibold btn.TextSize = 13 btn.TextXAlignment = Enum.TextXAlignment.Left
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	Instance.new("UIStroke", btn).Color = Color3.fromRGB(60,40,80)
	
	local checkbox = Instance.new("Frame", btn)
	checkbox.Size = UDim2.new(0, 20, 0, 20) checkbox.Position = UDim2.new(1, -30, 0.5, -10)
	checkbox.BackgroundColor3 = Theme.Background
	Instance.new("UICorner", checkbox).CornerRadius = UDim.new(0, 4)
	Instance.new("UIStroke", checkbox).Color = Theme.Accent
	
	local checkFill = Instance.new("Frame", checkbox)
	checkFill.Size = state and UDim2.new(1, -6, 1, -6) or UDim2.new(0,0,0,0)
	checkFill.Position = UDim2.new(0.5, 0, 0.5, 0) checkFill.AnchorPoint = Vector2.new(0.5, 0.5)
	checkFill.BackgroundColor3 = Theme.Accent
	Instance.new("UICorner", checkFill).CornerRadius = UDim.new(0, 2)
	
	btn.MouseButton1Click:Connect(function()
		state = not state
		if state then
			TweenService:Create(checkFill, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(1, -6, 1, -6)}):Play()
		else
			TweenService:Create(checkFill, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0, 0, 0, 0)}):Play()
		end
		task.spawn(callback, state)
	end)
end

local function CreateSlider(tabName, text, min, max, default, callback)
	local frame = Instance.new("Frame", Tabs[tabName].Scroll)
	frame.Size = UDim2.new(1, -10, 0, 50) frame.BackgroundColor3 = Theme.ElementBG
	Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
	Instance.new("UIStroke", frame).Color = Color3.fromRGB(60,40,80)
	
	local label = Instance.new("TextLabel", frame)
	label.Size = UDim2.new(1, -20, 0, 20) label.Position = UDim2.new(0, 10, 0, 5) label.BackgroundTransparency = 1
	label.Text = text .. ": " .. tostring(default) label.TextColor3 = Theme.TextMain label.Font = Enum.Font.GothamSemibold label.TextSize = 12 label.TextXAlignment = Enum.TextXAlignment.Left
	
	local track = Instance.new("Frame", frame)
	track.Size = UDim2.new(1, -20, 0, 6) track.Position = UDim2.new(0, 10, 0, 35) track.BackgroundColor3 = Theme.Background
	Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
	
	local fill = Instance.new("Frame", track)
	fill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0) fill.BackgroundColor3 = Theme.Accent
	Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
	
	local sliding = false
	local function updateSlider(input)
		local pos = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
		local value = math.floor(min + ((max - min) * pos))
		fill.Size = UDim2.new(pos, 0, 1, 0)
		label.Text = text .. ": " .. tostring(value)
		callback(value)
	end
	
	frame.InputBegan:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then sliding = true updateSlider(inp) end
	end)
	UserInputService.InputChanged:Connect(function(inp)
		if sliding and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then updateSlider(inp) end
	end)
	UserInputService.InputEnded:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then sliding = false end
	end)
end

-- ==========================================
-- TABS CORES
-- ==========================================
CreateTab("Local")
CreateTab("Combat")
CreateTab("Movement")

Tabs["Local"].Scroll.Visible = true Tabs["Local"].Btn.TextColor3 = Theme.Accent

-- ==========================================
-- 1. LOCAL CONFIGS
-- ==========================================
local normalSpeed = 16
CreateSlider("Local", "WalkSpeed", 16, 300, 16, function(val)
	normalSpeed = val
	if player.Character and player.Character:FindFirstChild("Humanoid") then player.Character.Humanoid.WalkSpeed = val end
end)

local normalJump = 50
CreateSlider("Local", "JumpPower", 50, 500, 50, function(val)
	normalJump = val
	if player.Character and player.Character:FindFirstChild("Humanoid") then 
		player.Character.Humanoid.UseJumpPower = true 
		player.Character.Humanoid.JumpPower = val 
	end
end)

player.CharacterAdded:Connect(function(char)
	local hum = char:WaitForChild("Humanoid")
	hum.WalkSpeed = normalSpeed
	hum.JumpPower = normalJump
end)

CreateButton("Local", "Heal / Give Max Health (Local)", function()
	if player.Character and player.Character:FindFirstChild("Humanoid") then
		player.Character.Humanoid.MaxHealth = 5000
		player.Character.Humanoid.Health = 5000
		SendNotification("Local Buff", "Max health bumped to 5,000!", 3)
	end
end)

CreateButton("Local", "Reset Character", function()
	if player.Character and player.Character:FindFirstChild("Humanoid") then player.Character.Humanoid.Health = 0 end
end)


-- ==========================================
-- 2. COMBAT CONFIGS
-- ==========================================
local aimbotActive = false
local aimbotStrength = 100
local autoShootActive = false

-- Dynamically finds the closest player to your screen center/crosshair
local function getClosestPlayer()
	local closestDist = math.huge
	local closestPlr = nil
	local cam = workspace.CurrentCamera
	
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= player and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
			local pos, onScreen = cam:WorldToViewportPoint(p.Character.Head.Position)
			if onScreen then
				local centerScreen = isMobile and Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2) or Vector2.new(mouse.X, mouse.Y)
				local dist = (Vector2.new(pos.X, pos.Y) - centerScreen).Magnitude
				
				if dist < closestDist then 
					closestDist = dist 
					closestPlr = p 
				end
			end
		end
	end
	return closestPlr
end

RunService.RenderStepped:Connect(function()
	if aimbotActive then
		local target = getClosestPlayer()
		if target and target.Character and target.Character:FindFirstChild("Head") then
			local cam = workspace.CurrentCamera
			local targetHead = target.Character.Head.Position
			local targetCFrame = CFrame.new(cam.CFrame.Position, targetHead)
			
			-- Smooth the aimbot based on the strength slider (1 = slow drag, 100 = instant snap)
			local smoothingAlpha = aimbotStrength / 100
			cam.CFrame = cam.CFrame:Lerp(targetCFrame, smoothingAlpha)
			
			-- Auto-Shoot logic
			if autoShootActive then
				local tool = player.Character and player.Character:FindFirstChildOfClass("Tool")
				if tool then tool:Activate() end
			end
		end
	end
end)

CreateToggle("Combat", "Aimbot (Lock Cam to Target)", false, function(state)
	aimbotActive = state
	SendNotification("Aimbot", state and "Hunting closest target..." or "Disabled", 2)
end)

CreateSlider("Combat", "Aimbot Strength", 1, 100, 100, function(val)
	aimbotStrength = val
end)

CreateToggle("Combat", "Auto-Shoot (Requires Tool)", false, function(state)
	autoShootActive = state
end)

CreateButton("Combat", "Server Fling (Teleport Blast)", function()
	local char = player.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		SendNotification("Flinging", "Targeting visible players...", 2)
		local oldPos = char.HumanoidRootPart.CFrame
		
		local att = Instance.new("Attachment", char.HumanoidRootPart)
		local av = Instance.new("AngularVelocity", char.HumanoidRootPart)
		av.Attachment0 = att av.MaxTorque = math.huge av.AngularVelocity = Vector3.new(0, 95000, 0)
		
		for _, p in pairs(Players:GetPlayers()) do
			if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
				char.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame
				task.wait(0.15)
			end
		end
		av:Destroy() att:Destroy() char.HumanoidRootPart.CFrame = oldPos
		SendNotification("Flinging", "Finished Attack Sequence!", 2)
	end
end)

local hitboxActive = false
local storedSizes = {}
CreateToggle("Combat", "Expand Hitboxes (Reach)", false, function(state)
	hitboxActive = state
	if state then
		task.spawn(function()
			while hitboxActive do
				for _, p in pairs(Players:GetPlayers()) do
					if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
						local hrp = p.Character.HumanoidRootPart
						if not storedSizes[p] then storedSizes[p] = hrp.Size end
						hrp.Size = Vector3.new(12, 12, 12)
						hrp.Transparency = 0.6
						hrp.CanCollide = false
					end
				end
				task.wait(0.5)
			end
		end)
	else
		for p, size in pairs(storedSizes) do
			if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
				p.Character.HumanoidRootPart.Size = size or Vector3.new(2, 2, 1)
				p.Character.HumanoidRootPart.Transparency = 1
			end
		end
		table.clear(storedSizes)
		SendNotification("Hitboxes", "Returned to normal size.", 2)
	end
end)

local spinbotActive = false
CreateToggle("Combat", "Spinbot (Dodge)", false, function(state)
	spinbotActive = state
	local char = player.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	
	if spinbotActive then
		local att = Instance.new("Attachment") att.Name = "SpinAtt" att.Parent = hrp
		local av = Instance.new("AngularVelocity") av.Name = "SpinVelocity" av.Attachment0 = att
		av.MaxTorque = math.huge av.AngularVelocity = Vector3.new(0, 60, 0) av.Parent = hrp
	else
		if hrp:FindFirstChild("SpinVelocity") then hrp.SpinVelocity:Destroy() end
		if hrp:FindFirstChild("SpinAtt") then hrp.SpinAtt:Destroy() end
	end
end)
						

-- ==========================================
-- 3. MOVEMENT CONFIGS
-- ==========================================
local noclipActive = false
local noclipConnection
CreateToggle("Movement", "Noclip (Phase Walls)", false, function(state)
	noclipActive = state
	if noclipActive then
		noclipConnection = RunService.Stepped:Connect(function()
			if noclipActive and player.Character then
				for _, part in pairs(player.Character:GetDescendants()) do
					if part:IsA("BasePart") then part.CanCollide = false end
				end
			end
		end)
	else
		if noclipConnection then noclipConnection:Disconnect() noclipConnection = nil end
		SendNotification("Noclip", "Physics Collisions Restored", 2)
	end
end)

local infJumpActive = false
local jumpConnection
CreateToggle("Movement", "Infinite Jump", false, function(state)
	infJumpActive = state
	if infJumpActive then
		jumpConnection = UserInputService.JumpRequest:Connect(function()
			if infJumpActive and player.Character and player.Character:FindFirstChild("Humanoid") then
				player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
			end
		end)
	else
		if jumpConnection then jumpConnection:Disconnect() jumpConnection = nil end
	end
end)

-- Smooth Mobile Fly System with Visual Button Helpers
local flying = false
local flySpeed = 60
local flyUp = false
local flyDown = false

local mobileFlyPanel = Instance.new("Frame", gui)
mobileFlyPanel.Size = UDim2.new(0, 70, 0, 130) mobileFlyPanel.Position = UDim2.new(0.85, 0, 0.4, 0) mobileFlyPanel.BackgroundTransparency = 1 mobileFlyPanel.Visible = false

local upBtn = Instance.new("TextButton", mobileFlyPanel)
upBtn.Size = UDim2.new(1, 0, 0, 50) upBtn.BackgroundColor3 = Theme.Sidebar upBtn.Text = "▲" upBtn.TextColor3 = Theme.Accent upBtn.TextSize = 24
Instance.new("UICorner", upBtn) Instance.new("UIStroke", upBtn).Color = Theme.Accent
upBtn.InputBegan:Connect(function() flyUp = true end) upBtn.InputEnded:Connect(function() flyUp = false end)

local downBtn = Instance.new("TextButton", mobileFlyPanel)
downBtn.Size = UDim2.new(1, 0, 0, 50) downBtn.Position = UDim2.new(0, 0, 0, 65) downBtn.BackgroundColor3 = Theme.Sidebar downBtn.Text = "▼" downBtn.TextColor3 = Theme.Accent downBtn.TextSize = 24
Instance.new("UICorner", downBtn) Instance.new("UIStroke", downBtn).Color = Theme.Accent
downBtn.InputBegan:Connect(function() flyDown = true end) downBtn.InputEnded:Connect(function() flyDown = false end)

CreateToggle("Movement", "Flight Mode", false, function(state)
	flying = state
	local char = player.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	
	if flying then
		if isMobile then mobileFlyPanel.Visible = true end
		
		local att = Instance.new("Attachment") att.Name = "FlyAtt" att.Parent = hrp
		local lv = Instance.new("LinearVelocity") lv.Name = "FlyVelocity" lv.Attachment0 = att
		lv.MaxForce = math.huge lv.VectorVelocity = Vector3.new(0,0,0) lv.Parent = hrp
		
		task.spawn(function()
			while flying and hrp and hrp.Parent do
				local cam = workspace.CurrentCamera
				local moveDir = Vector3.new(0,0,0)
				
				if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
				if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
				if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
				if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
				
				if isMobile and player.Character:FindFirstChild("Humanoid") then
					local moveDirection = player.Character.Humanoid.MoveDirection
					if moveDirection.Magnitude > 0 then moveDir = moveDir + moveDirection end
				end
				
				if UserInputService:IsKeyDown(Enum.KeyCode.Space) or flyUp then moveDir = moveDir + Vector3.new(0,1,0) end
				if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or flyDown then moveDir = moveDir - Vector3.new(0,1,0) end
				
				lv.VectorVelocity = moveDir.Magnitude > 0 and moveDir.Unit * flySpeed or Vector3.new(0,0,0)
				task.wait()
			end
			if lv then lv:Destroy() end
			if att then att:Destroy() end
		end)
	else
		mobileFlyPanel.Visible = false
		flyUp = false flyDown = false
		if hrp:FindFirstChild("FlyVelocity") then hrp.FlyVelocity:Destroy() end
		if hrp:FindFirstChild("FlyAtt") then hrp.FlyAtt:Destroy() end
	end
end)

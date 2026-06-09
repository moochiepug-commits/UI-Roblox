local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")

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

-- GUI Setup
local guiParent = player:WaitForChild("PlayerGui")
pcall(function() if CoreGui:FindFirstChild("RobloxGui") then guiParent = CoreGui end end)

local gui = Instance.new("ScreenGui")
gui.Name = "DeltaGalaxyV7"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = guiParent

-- Notification System
local notifFrame = Instance.new("Frame", gui)
notifFrame.Size = UDim2.new(0, 300, 1, 0)
notifFrame.Position = UDim2.new(1, -310, 0, 0)
notifFrame.BackgroundTransparency = 1
local notifLayout = Instance.new("UIListLayout", notifFrame)
notifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
notifLayout.Padding = UDim.new(0, 10)

local function SendNotification(title, text, duration)
	duration = duration or 3
	local bg = Instance.new("Frame", notifFrame)
	bg.Size = UDim2.new(1, 0, 0, 60) bg.BackgroundColor3 = Theme.Sidebar bg.BackgroundTransparency = 1
	Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 8)
	local stroke = Instance.new("UIStroke", bg) stroke.Color = Theme.Accent stroke.Thickness = 1.5 stroke.Transparency = 1
	
	local t = Instance.new("TextLabel", bg)
	t.Size = UDim2.new(1, -10, 0, 20) t.Position = UDim2.new(0, 10, 0, 5) t.BackgroundTransparency = 1
	t.Text = title t.TextColor3 = Theme.Accent t.Font = Enum.Font.GothamBold t.TextSize = 14 t.TextXAlignment = Enum.TextXAlignment.Left t.TextTransparency = 1
	
	local d = Instance.new("TextLabel", bg)
	d.Size = UDim2.new(1, -20, 0, 30) d.Position = UDim2.new(0, 10, 0, 25) d.BackgroundTransparency = 1
	d.Text = text d.TextColor3 = Theme.TextMain d.Font = Enum.Font.Gotham d.TextSize = 12 d.TextWrapped = true d.TextXAlignment = Enum.TextXAlignment.Left d.TextTransparency = 1
	
	TweenService:Create(bg, TweenInfo.new(0.3), {BackgroundTransparency = 0.1}):Play()
	TweenService:Create(stroke, TweenInfo.new(0.3), {Transparency = 0}):Play()
	TweenService:Create(t, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
	TweenService:Create(d, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
	
	task.delay(duration, function()
		TweenService:Create(bg, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
		TweenService:Create(stroke, TweenInfo.new(0.3), {Transparency = 1}):Play()
		TweenService:Create(t, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
		TweenService:Create(d, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
		task.wait(0.3) bg:Destroy()
	end)
end

-- ==========================================
-- MAIN INTERFACE BUILDER
-- ==========================================
local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = isMobile and UDim2.new(0, 420, 0, 280) or UDim2.new(0, 520, 0, 360)
mainFrame.Position = UDim2.new(0.5, -260, 0.5, -180)
mainFrame.BackgroundColor3 = Theme.Background
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", mainFrame).Color = Theme.Accent

local dragging, dragStart, startPos
mainFrame.InputBegan:Connect(function(inp)
	if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then dragging = true dragStart = inp.Position startPos = mainFrame.Position end
end)
UserInputService.InputChanged:Connect(function(inp)
	if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
		local delta = inp.Position - dragStart mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
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
titleText.Text = "DELTA ◆ GALAXY V7" titleText.TextColor3 = Theme.Accent titleText.Font = Enum.Font.GothamBlack titleText.TextSize = 16 titleText.TextXAlignment = Enum.TextXAlignment.Left

local toggleIcon = Instance.new("TextButton", gui)
toggleIcon.Size = UDim2.new(0, 50, 0, 50) toggleIcon.Position = UDim2.new(0.05, 0, 0.1, 0) toggleIcon.BackgroundColor3 = Theme.Sidebar toggleIcon.Text = "🌌" toggleIcon.TextSize = 24 toggleIcon.Visible = false
Instance.new("UICorner", toggleIcon).CornerRadius = UDim.new(1, 0) Instance.new("UIStroke", toggleIcon).Color = Theme.Accent

local closeBtn = Instance.new("TextButton", titleBar)
closeBtn.Size = UDim2.new(0, 30, 0, 30) closeBtn.Position = UDim2.new(1, -40, 0.5, -15) closeBtn.BackgroundTransparency = 1 closeBtn.Text = "━" closeBtn.TextColor3 = Theme.TextMain closeBtn.TextSize = 20
closeBtn.MouseButton1Click:Connect(function() mainFrame.Visible = false toggleIcon.Visible = true end)
toggleIcon.MouseButton1Click:Connect(function() mainFrame.Visible = true toggleIcon.Visible = false end)

local sidebar = Instance.new("Frame", mainFrame)
sidebar.Size = UDim2.new(0, 120, 1, -40) sidebar.Position = UDim2.new(0, 0, 0, 40) sidebar.BackgroundColor3 = Theme.Sidebar
Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 10) Instance.new("Frame", sidebar).Size = UDim2.new(0, 10, 1, 0)
local tabLayout = Instance.new("UIListLayout", sidebar) tabLayout.Padding = UDim.new(0, 5) tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local contentArea = Instance.new("Frame", mainFrame)
contentArea.Size = UDim2.new(1, -130, 1, -50) contentArea.Position = UDim2.new(0, 125, 0, 45) contentArea.BackgroundTransparency = 1

local Tabs = {}
local function CreateTab(name)
	local btn = Instance.new("TextButton", sidebar)
	btn.Size = UDim2.new(1, -10, 0, 35) btn.BackgroundTransparency = 1 btn.Text = name btn.TextColor3 = Theme.TextDim btn.Font = Enum.Font.GothamBold btn.TextSize = 14
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
-- UI COMPONENT GENERATORS
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
	
	-- Checkbox UI
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
-- TABS SETUP
-- ==========================================
CreateTab("Local")
CreateTab("Combat")
CreateTab("Movement")
CreateTab("Visuals")
CreateTab("World")

Tabs["Local"].Scroll.Visible = true Tabs["Local"].Btn.TextColor3 = Theme.Accent

-- ==========================================
-- 1. LOCAL TAB
-- ==========================================
CreateSlider("Local", "WalkSpeed", 16, 300, 16, function(val)
	if player.Character and player.Character:FindFirstChild("Humanoid") then player.Character.Humanoid.WalkSpeed = val end
end)

CreateSlider("Local", "JumpPower", 50, 500, 50, function(val)
	if player.Character and player.Character:FindFirstChild("Humanoid") then 
		player.Character.Humanoid.UseJumpPower = true 
		player.Character.Humanoid.JumpPower = val 
	end
end)

CreateButton("Local", "Heal / Infinite Health (Visual/Local)", function()
	if player.Character and player.Character:FindFirstChild("Humanoid") then
		player.Character.Humanoid.MaxHealth = math.huge
		player.Character.Humanoid.Health = math.huge
		SendNotification("God Mode", "Health set to Infinity", 3)
	end
end)

CreateButton("Local", "Reset Character", function()
	if player.Character and player.Character:FindFirstChild("Humanoid") then player.Character.Humanoid.Health = 0 end
end)

-- ==========================================
-- 2. COMBAT TAB
-- ==========================================
local aimbotActive = false
local function getClosestPlayer()
	local closestDist = math.huge
	local closestPlr = nil
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= player and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
			local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(p.Character.Head.Position)
			if onScreen then
				local mousePos = Vector2.new(mouse.X, mouse.Y)
				local dist = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
				if dist < closestDist then closestDist = dist closestPlr = p end
			end
		end
	end
	return closestPlr
end

RunService.RenderStepped:Connect(function()
	if aimbotActive then
		local target = getClosestPlayer()
		if target and target.Character and target.Character:FindFirstChild("Head") then
			workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, target.Character.Head.Position)
		end
	end
end)

CreateToggle("Combat", "Aimbot (Lock Camera to Target)", false, function(state)
	aimbotActive = state
	if state then SendNotification("Aimbot", "Searching for targets...", 2) end
end)

CreateButton("Combat", "Server Fling (Teleport & Destroy)", function()
	SendNotification("Flinging", "Attacking server...", 3)
	local char = player.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		local oldPos = char.HumanoidRootPart.CFrame
		local thrust = Instance.new("BodyAngularVelocity", char.HumanoidRootPart)
		thrust.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
		thrust.AngularVelocity = Vector3.new(0, 90000, 0)
		for _, p in pairs(Players:GetPlayers()) do
			if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
				char.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame
				task.wait(0.2)
			end
		end
		thrust:Destroy() char.HumanoidRootPart.CFrame = oldPos
		SendNotification("Flinging", "Finished!", 2)
	end
end)

CreateButton("Combat", "Get 'Punch Fling' Tool", function()
	local tool = Instance.new("Tool", player.Backpack) tool.Name = "Punch Fling" tool.RequiresHandle = false
	local anim = Instance.new("Animation") anim.AnimationId = "rbxassetid://522635514"
	tool.Activated:Connect(function()
		local char = player.Character local hum = char and char:FindFirstChildOfClass("Humanoid")
		if char and hum and char:FindFirstChild("HumanoidRootPart") then
			hum:LoadAnimation(anim):Play()
			local thrust = Instance.new("BodyAngularVelocity", char.HumanoidRootPart)
			thrust.MaxTorque = Vector3.new(math.huge, math.huge, math.huge) thrust.AngularVelocity = Vector3.new(0, 50000, 0)
			local bp = Instance.new("BodyVelocity", char.HumanoidRootPart)
			bp.MaxForce = Vector3.new(9e9, 9e9, 9e9) bp.Velocity = char.HumanoidRootPart.CFrame.LookVector * 50
			task.wait(0.3) thrust:Destroy() bp:Destroy()
		end
	end)
	SendNotification("Combat Tool", "Equip 'Punch Fling' and click near enemies!", 3)
end)

local hitboxActive = false
CreateToggle("Combat", "Expand Player Hitboxes (Reach)", false, function(state)
	hitboxActive = state
	task.spawn(function()
		while hitboxActive do
			for _, p in pairs(Players:GetPlayers()) do
				if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
					p.Character.HumanoidRootPart.Size = Vector3.new(10, 10, 10)
					p.Character.HumanoidRootPart.Transparency = 0.7
					p.Character.HumanoidRootPart.CanCollide = false
				end
			end
			task.wait(1)
		end
		for _, p in pairs(Players:GetPlayers()) do
			if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
				p.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
				p.Character.HumanoidRootPart.Transparency = 1
			end
		end
	end)
end)

local spinbot = false
CreateToggle("Combat", "Spinbot (Dodge bullets)", false, function(state)
	spinbot = state
	local char = player.Character
	if spinbot and char and char:FindFirstChild("HumanoidRootPart") then
		local spin = Instance.new("BodyAngularVelocity", char.HumanoidRootPart)
		spin.Name = "DeltaSpin" spin.MaxTorque = Vector3.new(0, math.huge, 0) spin.AngularVelocity = Vector3.new(0, 50, 0)
	elseif char and char:FindFirstChild("HumanoidRootPart") and char.HumanoidRootPart:FindFirstChild("DeltaSpin") then
		char.HumanoidRootPart.DeltaSpin:Destroy()
	end
end)

local autoClick = false
CreateToggle("Combat", "Auto-Clicker", false, function(state)
	autoClick = state
	task.spawn(function()
		while autoClick do
			VirtualUser:CaptureController() VirtualUser:ClickButton1(Vector2.new(0,0)) task.wait(0.01)
		end
	end)
end)

-- ==========================================
-- 3. MOVEMENT TAB
-- ==========================================
local noclip = false
CreateToggle("Movement", "Noclip (Walk through walls)", false, function(state)
	noclip = state
	RunService.Stepped:Connect(function()
		if noclip and player.Character then
			for _, part in pairs(player.Character:GetDescendants()) do
				if part:IsA("BasePart") then part.CanCollide = false end
			end
		end
	end)
end)

local infJump = false
UserInputService.JumpRequest:Connect(function()
	if infJump and player.Character and player.Character:FindFirstChild("Humanoid") then
		player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)
CreateToggle("Movement", "Infinite Jump", false, function(state) infJump = state end)

local flying = false
local flySpeed = 50
CreateToggle("Movement", "Flight Mode", false, function(state)
	flying = state
	local char = player.Character
	if flying and char and char:FindFirstChild("HumanoidRootPart") then
		local bv = Instance.new("BodyVelocity", char.HumanoidRootPart)
		bv.Name = "DeltaFlyV" bv.MaxForce = Vector3.new(9e9, 9e9, 9e9) bv.Velocity = Vector3.new(0,0,0)
		local bg = Instance.new("BodyGyro", char.HumanoidRootPart)
		bg.Name = "DeltaFlyG" bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9) bg.P = 9000
		
		task.spawn(function()
			while flying and char:FindFirstChild("HumanoidRootPart") do
				local cam = workspace.a

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Debris = game:GetService("Debris")
local VirtualUser = game:GetService("VirtualUser")

local player = Players.LocalPlayer
local isMobile = UserInputService.TouchEnabled

-- Color Palette Configuration
local Theme = {
	Background = Color3.fromRGB(13, 13, 18),
	Sidebar = Color3.fromRGB(9, 9, 13),
	Accent = Color3.fromRGB(0, 255, 170),
	ButtonDefault = Color3.fromRGB(22, 22, 30),
	ButtonActive = Color3.fromRGB(0, 70, 50),
	TextDark = Color3.fromRGB(150, 150, 160),
	TextLight = Color3.fromRGB(255, 255, 255)
}

-- Root GUI Container
local gui = Instance.new("ScreenGui")
gui.Name = "DeltaPremiumV4"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = player:WaitForChild("PlayerGui")

-- MAIN INTERFACE FRAME (Sleek Horizontal Profile)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = isMobile and UDim2.new(0, 390, 0, 260) or UDim2.new(0, 440, 0, 300)
mainFrame.Position = UDim2.new(0.5, -220, 0.5, -150)
mainFrame.BackgroundColor3 = Theme.Background
mainFrame.BorderSizePixel = 0
mainFrame.Parent = gui

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)
local menuStroke = Instance.new("UIStroke", mainFrame)
menuStroke.Color = Theme.Accent
menuStroke.Thickness = 1.5

-- FLOATING TOGGLE ICON
local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "ToggleIcon"
toggleBtn.Size = UDim2.new(0, 48, 0, 48)
toggleBtn.Position = UDim2.new(0.05, 0, 0.15, 0)
toggleBtn.BackgroundColor3 = Theme.Sidebar
toggleBtn.Text = "🔮"
toggleBtn.TextColor3 = Theme.Accent
toggleBtn.TextSize = 20
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.Visible = false
toggleBtn.Parent = gui

Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)
local iconStroke = Instance.new("UIStroke", toggleBtn)
iconStroke.Color = Theme.Accent
iconStroke.Thickness = 1.5

-- Robust Dragging Engine
local function makeDraggable(obj, target)
	target = target or obj
	local dragging, dragStart, startPos
	obj.InputBegan:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = inp.Position
			startPos = target.Position
		end
	end)
	UserInputService.InputChanged:Connect(function(inp)
		if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
			local delta = inp.Position - dragStart
			target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
	obj.InputEnded:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
end
makeDraggable(toggleBtn)

-- Header Element
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 38)
titleBar.BackgroundColor3 = Theme.Sidebar
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 12)
makeDraggable(titleBar, mainFrame)

-- Extra visual cover to smooth corner clip seams
local seamCover = Instance.new("Frame")
seamCover.Size = UDim2.new(1, 0, 0, 10)
seamCover.Position = UDim2.new(0, 0, 1, -10)
seamCover.BackgroundColor3 = Theme.Sidebar
seamCover.BorderSizePixel = 0
seamCover.Parent = titleBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -60, 1, 0)
title.Position = UDim2.new(0, 12, 0, 0)
title.BackgroundTransparency = 1
title.Text = "DELTA HUB ◆ PREMIUM V4"
title.TextColor3 = Theme.Accent
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamBlack
title.TextSize = 13
title.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -36, 0.5, -15)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 90, 90)
closeBtn.TextSize = 15
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = titleBar

closeBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = false
	toggleBtn.Visible = true
end)
toggleBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = true
	toggleBtn.Visible = false
end)

-- PREMIUM TABS SIDEBAR PANEL
local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, 100, 1, -38)
sidebar.Position = UDim2.new(0, 0, 0, 38)
sidebar.BackgroundColor3 = Theme.Sidebar
sidebar.BorderSizePixel = 0
sidebar.Parent = mainFrame

local sideCorner = Instance.new("UICorner", sidebar)
sideCorner.CornerRadius = UDim.new(0, 12)

local sidebarLayout = Instance.new("UIListLayout", sidebar)
sidebarLayout.Padding = UDim.new(0, 4)
sidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Main Content Multi-Container
local contentContainer = Instance.new("Frame")
contentContainer.Name = "ContentArea"
contentContainer.Size = UDim2.new(1, -108, 1, -44)
contentContainer.Position = UDim2.new(0, 104, 0, 42)
contentContainer.BackgroundTransparency = 1
contentContainer.Parent = mainFrame

local tabs = {}
local currentTab = nil

-- Unified Constructor Systems
local function createTab(tabName)
	local tabBtn = Instance.new("TextButton")
	tabBtn.Size = UDim2.new(0, 90, 0, 34)
	tabBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
	tabBtn.BackgroundTransparency = 1
	tabBtn.Text = tabName
	tabBtn.TextColor3 = Theme.TextDark
	tabBtn.Font = Enum.Font.GothamBold
	tabBtn.TextSize = 11
	tabBtn.Parent = sidebar
	
	local scrollFrame = Instance.new("ScrollingFrame")
	scrollFrame.Size = UDim2.new(1, 0, 1, 0)
	scrollFrame.BackgroundTransparency = 1
	scrollFrame.Visible = false
	scrollFrame.ScrollBarThickness = 2
	scrollFrame.ScrollBarImageColor3 = Theme.Accent
	scrollFrame.Parent = contentContainer
	
	local listLayout = Instance.new("UIListLayout", scrollFrame)
	listLayout.Padding = UDim.new(0, 5)
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	
	listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
	end)
	
	tabs[tabName] = {btn = tabBtn, pane = scrollFrame}
	
	tabBtn.MouseButton1Click:Connect(function()
		for _, t in pairs(tabs) do
			t.pane.Visible = false
			t.btn.TextColor3 = Theme.TextDark
		end
		scrollFrame.Visible = true
		tabBtn.TextColor3 = Theme.Accent
	end)
end

local function addActionButton(tabName, text, callback)
	local parentPane = tabs[tabName].pane
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -6, 0, 36)
	btn.BackgroundColor3 = Theme.ButtonDefault
	btn.Text = "  " .. text
	btn.TextColor3 = Theme.TextLight
	btn.TextSize = 11
	btn.TextXAlignment = Enum.TextXAlignment.Left
	btn.Font = Enum.Font.GothamSemibold
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	
	local s = Instance.new("UIStroke", btn)
	s.Color = Theme.Accent
	s.Thickness = 1
	s.Transparency = 0.85
	
	btn.MouseButton1Click:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Theme.Accent, TextColor3 = Color3.fromRGB(0,0,0)}):Play()
		task.spawn(callback)
		task.wait(0.12)
		TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Theme.ButtonDefault, TextColor3 = Theme.TextLight}):Play()
	end)
	btn.Parent = parentPane
end

local function addToggleButton(tabName, text, defaultState, callback)
	local parentPane = tabs[tabName].pane
	local active = defaultState
	
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -6, 0, 36)
	btn.BackgroundColor3 = active and Theme.ButtonActive or Theme.ButtonDefault
	btn.Text = string.format("  [%s] %s", active and "ON" or "OFF", text)
	btn.TextColor3 = active and Theme.Accent or Theme.TextLight
	btn.TextSize = 11
	btn.TextXAlignment = Enum.TextXAlignment.Left
	btn.Font = Enum.Font.GothamSemibold
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	
	local s = Instance.new("UIStroke", btn)
	s.Color = Theme.Accent
	s.Thickness = 1
	s.Transparency = active and 0.4 or 0.85
	
	btn.MouseButton1Click:Connect(function()
		active = not active
		btn.Text = string.format("  [%s] %s", active and "ON" or "OFF", text)
		
		local targetBG = active and Theme.ButtonActive or Theme.ButtonDefault
		local targetText = active and Theme.Accent or Theme.TextLight
		local targetTrans = active and 0.4 or 0.85
		
		TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = targetBG, TextColor3 = targetText}):Play()
		TweenService:Create(s, TweenInfo.new(0.15), {Transparency = targetTrans}):Play()
		
		task.spawn(callback, active)
	end)
	btn.Parent = parentPane
end

-- Generate Tab Framework
createTab("Player")
createTab("Vehicle")
createTab("Automation")
createTab("World")

-- Force initialize primary window view
tabs["Player"].pane.Visible = true
tabs["Player"].btn.TextColor3 = Theme.Accent

-- --- FLIGHT MODULE SYSTEMS ---
local flying = false
local flyBV, flyBG, flyConn
local function handleFlight(state)
	flying = state
	local char = player.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if not root then return end
	if flying then
		flyBV = Instance.new("BodyVelocity")
		flyBV.MaxForce = Vector3.new(9e4, 9e4, 9e4)
		flyBV.Parent = root
		flyBG = Instance.new("BodyGyro")
		flyBG.MaxTorque = Vector3.new(9e4, 9e4, 9e4)
		flyBG.P = 12000
		flyBG.Parent = root
		
		flyConn = RunService.RenderStepped:Connect(function()
			local cam = workspace.CurrentCamera
			local dir = Vector3.new()
			local hum = char:FindFirstChildOfClass("Humanoid")
			if hum and hum.MoveDirection.Magnitude > 0 then
				dir = hum.MoveDirection
			else
				if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
				if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
			end
			if dir.Magnitude > 0 then
				flyBV.Velocity = dir.Unit * 95
			else
				flyBV.Velocity = Vector3.new(0, 0.05, 0)
			end
			flyBG.CFrame = cam.CFrame
		end)
	else
		if flyBV then flyBV:Destroy() end
		if flyBG then flyBG:Destroy() end
		if flyConn then flyConn:Disconnect() end
	end
end

local carFlying = false
local carBV, carBG, carConn
local function handleCarFlight(state)
	carFlying = state
	local char = player.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if carFlying then
		if hum and hum.SeatPart then
			local vRoot = hum.SeatPart.Parent:FindFirstChild("HumanoidRootPart") or hum.SeatPart
			carBV = Instance.new("BodyVelocity")
			carBV.MaxForce = Vector3.new(9e5, 9e5, 9e5)
			carBV.Parent = vRoot
			carBG = Instance.new("BodyGyro")
			carBG.MaxTorque = Vector3.new(9e5, 9e5, 9e5)
			carBG.Parent = vRoot
			
			carConn = RunService.RenderStepped:Connect(function()
				local cam = workspace.CurrentCamera
				local dir = Vector3.new()
				if hum.MoveDirection.Magnitude > 0 then dir = hum.MoveDirection end
				if dir.Magnitude > 0 then
					carBV.Velocity = dir.Unit * 130
				else
					carBV.Velocity = Vector3.new(0, 0, 0)
				end
				carBG.CFrame = cam.CFrame
			end)
		end
	else
		if carBV then carBV:Destroy() end
		if carBG then carBG:Destroy() end
		if carConn then carConn:Disconnect() end
	end
end

-- --- TAB 1: PLAYER UTILITIES ---
addActionButton("Player", "Apply Absolute Infinite Health", function()
	local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
	if hum then hum.MaxHealth = math.huge hum.Health = math.huge end
end)

addActionButton("Player", "Set Walking Velocity [140]", function()
	local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
	if hum then hum.WalkSpeed = 140 end
end)

addActionButton("Player", "Set High Jump Velocity [135]", function()
	local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
	if hum then hum.UseJumpPower = true hum.JumpPower = 135 end
end)

addToggleButton("Player", "Character Flight Engine", false, function(state)
	handleFlight(state)
end)

addActionButton("Player", "Execute Client Invisible Glitch", function()
	local char = player.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if root then
		local clone = root:Clone()
		root:Destroy()
		clone.Parent = char
	end
end)

addActionButton("Player", "Instant Character Reset", function()
	local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
	if hum then hum.Health = 0 end
end)


-- --- TAB 2: VEHICLE DRIVER MODULES ---
addToggleButton("Vehicle", "Sit-Seat / Car Flight System", false, function(state)
	handleCarFlight(state)
end)

addActionButton("Vehicle", "Apply Forward Thrust Boost", function()
	local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
	if hum and hum.SeatPart then
		local target = hum.SeatPart.Parent:FindFirstChild("HumanoidRootPart") or hum.SeatPart
		target.Velocity = target.CFrame.LookVector * 240
	end
end)


-- --- TAB 3: ENGINE AUTOMATIONS ---
local loopClicking = false
addToggleButton("Automation", "Looping Fast Auto-Clicker", false, function(state)
	loopClicking = state
	while loopClicking do
		VirtualUser:CaptureController()
		VirtualUser:ClickButton1(Vector2.new(0, 0))
		task.wait(0.04)
	end
end)

local loopAntiRagdoll = false
addToggleButton("Automation", "Enforce Continuous Anti-Ragdoll", false, function(state)
	loopAntiRagdoll = state
	while loopAntiRagdoll do
		local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
		if hum then
			hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
			hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
		end
		task.wait(0.4)
	end
end)

addToggleButton("Automation", "Infinite Oxygen (No Water Drown)", false, function(state)
	local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
	if hum then
		hum:SetStateEnabled(Enum.HumanoidStateType.Swimming, not state)
	end
end)

local antiAFK = false
addToggleButton("Automation", "Anti-AFK Server Disconnect Lock", false, function(state)
	antiAFK = state
	if antiAFK then
		player.Idled:Connect(function()
			if antiAFK then
				VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
				task.wait(0.5)
				VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
			end
		end)
	end
end)


-- --- TAB 4: WORLD & ENVIRONMENT ---
local espActive = false
addToggleButton("World", "Visual Player ESP Wallhack", false, function(state)
	espActive = state
	if espActive then
		task.spawn(function()
			while espActive do
				for _, p in pairs(Players:GetPlayers()) do
					if p ~= player and p.Character then
						local h = p.Character:FindFirstChildOfClass("Highlight")
						if not h and espActive then
							h = Instance.new("Highlight")
							h.FillColor = Theme.Accent
							h.OutlineColor = Color3.fromRGB(255, 255, 255)
							h.FillTransparency = 0.4
							h.Parent = p.Character
						end
					end
				end
				task.wait(1.5)
			end
		end)
	else
		for _, p in pairs(Players:GetPlayers()) do
			if p.Character and p.Character:FindFirstChildOfClass("Highlight") then
				p.Character:FindFirstChildOfClass("Highlight"):Destroy()
			end
		end
	end
end)

addActionButton("World", "Get Mobile Tap-Teleport Tool", function()
	local tool = Instance.new("Tool")
	tool.Name = "Click Teleport"
	tool.RequiresHandle = false
	tool.Activated:Connect(function()
		local mouse = player:GetMouse()
		if mouse.Target and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			player.Character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))
		end
	end)
	tool.Parent = player.Backpack
end)

addActionButton("World", "Teleport to Random Player", function()
	local choices = {}
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
			table.insert(choices, p)
		end
	end
	if #choices > 0 then
		local target = choices[math.random(#choices)]
		player.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 4, 0)
	end
end)

addActionButton("World", "Activate Constant Fullbright", function()
	Lighting.Brightness = 2.5
	Lighting.ClockTime = 14
	Lighting.FogEnd = 1e5
	Lighting.GlobalShadows = false
	Lighting.Ambient = Color3.fromRGB(255, 255, 255)
end)

addActionButton("World", "Optimize Graphics (Lag Fix)", function()
	for _, v in pairs(workspace:GetDescendants()) do
		if v:IsA("BasePart") and not v:IsA("MeshPart") then
			v.Material = Enum.Material.SmoothPlastic
		elseif v:IsA("Decal") or v:IsA("Texture") then
			v:Destroy()
		end
	end
end)

addActionButton("World", "Drop World Gravity to Low [40]", function()
	workspace.Gravity = 40
end)

addActionButton("World", "Restore Default World Gravity", function()
	workspace.Gravity = 196.2
end)


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
-- THEME & UI CONFIGURATION
-- ==========================================
local Theme = {
	Background = Color3.fromRGB(15, 15, 20),
	Sidebar = Color3.fromRGB(10, 10, 15),
	Accent = Color3.fromRGB(255, 50, 50), -- Changed to Aggressive Red for Combat Update
	AccentHover = Color3.fromRGB(255, 100, 100),
	ElementBG = Color3.fromRGB(22, 22, 30),
	TextMain = Color3.fromRGB(255, 255, 255),
	TextDim = Color3.fromRGB(160, 160, 175)
}

local guiParent = player:WaitForChild("PlayerGui")
pcall(function() if CoreGui:FindFirstChild("RobloxGui") then guiParent = CoreGui end end)

local gui = Instance.new("ScreenGui")
gui.Name = "DeltaUltimateV6"
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

-- MAIN INTERFACE BUILDER
local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = isMobile and UDim2.new(0, 420, 0, 280) or UDim2.new(0, 500, 0, 350)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
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
titleText.Text = "DELTA ULTIMATE ◆ V6 (COMBAT)" titleText.TextColor3 = Theme.Accent titleText.Font = Enum.Font.GothamBlack titleText.TextSize = 16 titleText.TextXAlignment = Enum.TextXAlignment.Left

local toggleIcon = Instance.new("TextButton", gui)
toggleIcon.Size = UDim2.new(0, 50, 0, 50) toggleIcon.Position = UDim2.new(0.05, 0, 0.1, 0) toggleIcon.BackgroundColor3 = Theme.Sidebar toggleIcon.Text = "⚔️" toggleIcon.TextSize = 24 toggleIcon.Visible = false
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

local function CreateButton(tabName, text, callback)
	local btn = Instance.new("TextButton", Tabs[tabName].Scroll)
	btn.Size = UDim2.new(1, -10, 0, 40) btn.BackgroundColor3 = Theme.ElementBG btn.Text = "  " .. text btn.TextColor3 = Theme.TextMain btn.Font = Enum.Font.GothamSemibold btn.TextSize = 13 btn.TextXAlignment = Enum.TextXAlignment.Left
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6) Instance.new("UIStroke", btn).Color = Color3.fromRGB(50,50,60)
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
	local stroke = Instance.new("UIStroke", btn) stroke.Color = state and Theme.Accent or Color3.fromRGB(50,50,60)
	local indicator = Instance.new("Frame", btn) indicator.Size = UDim2.new(0, 20, 0, 20) indicator.Position = UDim2.new(1, -30, 0.5, -10) indicator.BackgroundColor3 = state and Theme.Accent or Theme.Background
	Instance.new("UICorner", indicator).CornerRadius = UDim.new(0, 4)
	btn.MouseButton1Click:Connect(function()
		state = not state
		TweenService:Create(indicator, TweenInfo.new(0.2), {BackgroundColor3 = state and Theme.Accent or Theme.Background}):Play()
		TweenService:Create(stroke, TweenInfo.new(0.2), {Color = state and Theme.Accent or Color3.fromRGB(50,50,60)}):Play()
		task.spawn(callback, state)
	end)
end

-- TABS
CreateTab("Combat")
CreateTab("Movement")
CreateTab("Visuals")

Tabs["Combat"].Scroll.Visible = true Tabs["Combat"].Btn.TextColor3 = Theme.Accent

-- ==========================================
-- COMBAT TAB (NEW FEATURES)
-- ==========================================

-- 🎯 1. AIMBOT
local aimbotActive = false
local aimbotTarget = nil
local function getClosestPlayer()
	local closestDist = math.huge
	local closestPlr = nil
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= player and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
			local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(p.Character.Head.Position)
			if onScreen then
				local mousePos = Vector2.new(mouse.X, mouse.Y)
				local dist = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
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
		aimbotTarget = getClosestPlayer()
		if aimbotTarget and aimbotTarget.Character and aimbotTarget.Character:FindFirstChild("Head") then
			workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, aimbotTarget.Character.Head.Position)
		end
	end
end)

CreateToggle("Combat", "Aimbot (Locks camera to closest player)", false, function(state)
	aimbotActive = state
	if state then SendNotification("Aimbot", "Searching for targets...", 2) end
end)

-- 🌪️ 2. SERVER FLING
CreateButton("Combat", "Server Fling (Teleport & Fling Everyone)", function()
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
				task.wait(0.2) -- Stay on them for a moment to ensure physics collision registers
			end
		end
		thrust:Destroy()
		char.HumanoidRootPart.CFrame = oldPos
		SendNotification("Flinging", "Finished!", 2)
	end
end)

-- 🥊 3. PUNCH FLING WITH ANIMATION
CreateButton("Combat", "Get 'Punch Fling' Tool", function()
	local tool = Instance.new("Tool", player.Backpack)
	tool.Name = "Punch Fling"
	tool.RequiresHandle = false
	
	-- Standard R15 Punch Animation
	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://522635514"
	
	tool.Activated:Connect(function()
		local char = player.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		if char and hum and char:FindFirstChild("HumanoidRootPart") then
			-- Play Animation
			local loadedAnim = hum:LoadAnimation(anim)
			loadedAnim:Play()
			
			-- Create Fling Physics temporarily
			local thrust = Instance.new("BodyAngularVelocity", char.HumanoidRootPart)
			thrust.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
			thrust.AngularVelocity = Vector3.new(0, 50000, 0)
			
			-- Push character forward slightly
			local bp = Instance.new("BodyVelocity", char.HumanoidRootPart)
			bp.MaxForce = Vector3.new(9e9, 9e9, 9e9)
			bp.Velocity = char.HumanoidRootPart.CFrame.LookVector * 50
			
			task.wait(0.3)
			thrust:Destroy()
			bp:Destroy()
		end
	end)
	SendNotification("Combat Tool", "Equip 'Punch Fling', get close to someone, and click to punch them away!", 4)
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


-- ==========================================
-- MOVEMENT & VISUALS TAB (Retained from V5)
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

local espToggle = false
CreateToggle("Visuals", "Player ESP (See through walls)", false, function(state)
	espToggle = state
	while espToggle do
		for _, p in pairs(Players:GetPlayers()) do
			if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
				if not p.Character:FindFirstChild("DeltaESP") then
					local h = Instance.new("Highlight", p.Character)
					h.Name = "DeltaESP" h.FillColor = Theme.Accent h.FillTransparency = 0.5 h.OutlineColor = Color3.fromRGB(255,255,255)
				end
			end
		end
		task.wait(1)
	end
	if not espToggle then
		for _, p in pairs(Players:GetPlayers()) do
			if p.Character and p.Character:FindFirstChild("DeltaESP") then p.Character.DeltaESP:Destroy() end
		end
	end
end)

SendNotification("Loaded", "Delta Ultimate V6 (Combat Update) successfully injected!", 4)

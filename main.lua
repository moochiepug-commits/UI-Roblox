local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Debris = game:GetService("Debris")

local player = Players.LocalPlayer
local isMobile = UserInputService.TouchEnabled

local gui = Instance.new("ScreenGui")
gui.Name = "SuperOPMenu"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = isMobile and UDim2.new(0.92, 0, 0.82, 0) or UDim2.new(0, 460, 0, 620)
mainFrame.Position = isMobile and UDim2.new(0.04, 0, 0.09, 0) or UDim2.new(0.5, -230, 0.5, -310)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = true -- Starts visible so you know it loaded
mainFrame.Parent = gui

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 20)

local stroke = Instance.new("UIStroke", mainFrame)
stroke.Color = Color3.fromRGB(0, 255, 170)
stroke.Thickness = 2.5

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 60)
titleBar.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 20)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -80, 1, 0)
title.BackgroundTransparency = 1
title.Text = "🔥 FIXED CLIENT MENU 🔥"
title.TextColor3 = Color3.fromRGB(0, 255, 170)
title.TextScaled = true
title.Font = Enum.Font.GothamBlack
title.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 45, 0, 45)
closeBtn.Position = UDim2.new(1, -55, 0.5, -22.5)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 70, 70)
closeBtn.TextScaled = true
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = titleBar
closeBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = false
end)

-- Smooth Dragging System
local dragging, dragStart, startPos
titleBar.InputBegan:Connect(function(inp)
	if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = inp.Position
		startPos = mainFrame.Position
	end
end)
UserInputService.InputChanged:Connect(function(inp)
	if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
		local delta = inp.Position - dragStart
		mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)
titleBar.InputEnded:Connect(function(inp)
	if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -24, 1, -85)
scroll.Position = UDim2.new(0, 12, 0, 72)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 6
scroll.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 170)
scroll.Parent = mainFrame

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, 9)
layout.SortOrder = Enum.SortOrder.LayoutOrder

local function createButton(text, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -12, 0, isMobile and 68 or 55)
	btn.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
	btn.Text = text
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.TextScaled = true
	btn.Font = Enum.Font.GothamSemibold
	btn.AutoButtonColor = false
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)
	
	local s = Instance.new("UIStroke", btn)
	s.Color = Color3.fromRGB(0, 255, 170)
	s.Thickness = 1
	s.Transparency = 0.6
	
	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(45, 45, 60)}):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(28, 28, 38)}):Play()
	end)
	
	btn.MouseButton1Click:Connect(callback)
	btn.Parent = scroll
end

-- Flying System (CRASH PATCHED)
local flying = false
local flyBV, flyBG, flyConn

local function toggleFly()
	flying = not flying
	local char = player.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if not root then return end
	
	if flying then
		flyBV = Instance.new("BodyVelocity")
		flyBV.MaxForce = Vector3.new(90000, 90000, 90000)
		flyBV.Parent = root
		
		flyBG = Instance.new("BodyGyro")
		flyBG.MaxTorque = Vector3.new(90000, 90000, 90000)
		flyBG.P = 12000
		flyBG.Parent = root
		
		flyConn = RunService.RenderStepped:Connect(function()
			local cam = workspace.CurrentCamera
			local dir = Vector3.new()
			if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0,1,0) end
			if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir = dir - Vector3.new(0,1,0) end
			
			local speed = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) and 180 or 110
			
			-- CRASH FIX: Checks if moving before setting unit vector to avoid NaN errors
			if dir.Magnitude > 0 then
				flyBV.Velocity = dir.Unit * speed
			else
				flyBV.Velocity = Vector3.new(0, 0, 0)
			end
			flyBG.CFrame = cam.CFrame
		end)
	else
		if flyBV then flyBV:Destroy() end
		if flyBG then flyBG:Destroy() end
		if flyConn then flyConn:Disconnect() end
	end
end

-- Functional Buttons Layout
createButton("Local Semi-Godmode", function()
	local hum = player.Character and player.Character:FindFirstChild("Humanoid")
	if hum then 
		hum.MaxHealth = math.huge 
		hum.Health = math.huge 
	end
end)

createButton("Insane WalkSpeed", function()
	local hum = player.Character and player.Character:FindFirstChild("Humanoid")
	if hum then hum.WalkSpeed = 185 end
end)

createButton("Infinite Jump Toggle", function()
	UserInputService.JumpRequest:Connect(function()
		local hum = player.Character and player.Character:FindFirstChild("Humanoid")
		if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
	end)
end)

createButton("Toggle Fly (Key: E)", toggleFly)

-- FIXED: Invisible exploit that breaks local joints so servers struggle to track hits
createButton("Client Desync Invisibility", function()
	local char = player.Character
	local lowerTorso = char and char:FindFirstChild("LowerTorso") or char:FindFirstChild("Torso")
	if lowerTorso then
		local root = char:FindFirstChild("HumanoidRootPart")
		if root then
			local clone = root:Clone()
			root:Destroy()
			clone.Parent = char
		end
	end
end)

-- REMOVED "Kill/Bring All" (impossible via client) and replaced with Wallhack ESP
createButton("Player ESP (Wallhack)", function()
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= player and p.Character then
			local highlight = Instance.new("Highlight")
			highlight.Name = "ESPHighlight"
			highlight.FillColor = Color3.fromRGB(0, 255, 170)
			highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
			highlight.FillTransparency = 0.4
			highlight.Parent = p.Character
		end
	end
end)

createButton("Teleport to Random Player", function()
	local others = {}
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
			table.insert(others, p)
		end
	end
	if #others > 0 then
		local target = others[math.random(#others)]
		local myRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
		if myRoot then
			myRoot.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 4, 0)
		end
	end
end)

createButton("Fullbright Mode", function()
	Lighting.Brightness = 2.5
	Lighting.ClockTime = 14
	Lighting.FogEnd = 100000
	Lighting.GlobalShadows = false
	Lighting.Ambient = Color3.fromRGB(255,255,255)
end)

createButton("Local Sound Fun", function()
	local s = Instance.new("Sound")
	s.SoundId = "rbxassetid://131057265"
	s.Volume = 5
	s.Parent = workspace
	s:Play()
	Debris:AddItem(s, 4)
end)

layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 40)
end)

-- Keybind handling (Insert to toggle Menu, E to fly)
UserInputService.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.Insert then
		mainFrame.Visible = not mainFrame.Visible
	elseif input.KeyCode == Enum.KeyCode.E then
		toggleFly()
	end
end)

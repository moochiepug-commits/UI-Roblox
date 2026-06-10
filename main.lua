-- ==========================================
-- DELTA GALAXY V8 - Private Fun Edition
-- ==========================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local mouse = player:GetMouse()
local isMobile = UserInputService.TouchEnabled

-- ==========================================
-- THEME
-- ==========================================
local Theme = {
	Background  = Color3.fromRGB(12, 8, 18),
	Sidebar     = Color3.fromRGB(20, 15, 30),
	Accent      = Color3.fromRGB(170, 85, 255),
	AccentHover = Color3.fromRGB(200, 130, 255),
	AccentDim   = Color3.fromRGB(100, 50, 160),
	ElementBG   = Color3.fromRGB(25, 20, 35),
	TextMain    = Color3.fromRGB(240, 240, 255),
	TextDim     = Color3.fromRGB(140, 130, 160),
	Green       = Color3.fromRGB(80, 220, 140),
	Red         = Color3.fromRGB(220, 80, 100),
}

-- ==========================================
-- GUI ROOT
-- ==========================================
local guiParent = player:WaitForChild("PlayerGui")
pcall(function()
	local core = game:GetService("CoreGui")
	if core then guiParent = core end
end)

local gui = Instance.new("ScreenGui")
gui.Name = "DeltaGalaxyV8"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = guiParent

-- ==========================================
-- NOTIFICATION SYSTEM
-- ==========================================
local notifFrame = Instance.new("Frame", gui)
notifFrame.Size = UDim2.new(0, 280, 1, 0)
notifFrame.Position = isMobile and UDim2.new(1, -290, 0, 10) or UDim2.new(1, -310, 0, 0)
notifFrame.BackgroundTransparency = 1

local notifLayout = Instance.new("UIListLayout", notifFrame)
notifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
notifLayout.Padding = UDim.new(0, 8)

local function SendNotification(title, text, duration, color)
	duration = duration or 3
	color = color or Theme.Accent

	local bg = Instance.new("Frame", notifFrame)
	bg.Size = UDim2.new(1, 0, 0, 0)
	bg.AutomaticSize = Enum.AutomaticSize.Y
	bg.BackgroundColor3 = Theme.Sidebar
	bg.BackgroundTransparency = 0.05
	Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 8)
	local pad = Instance.new("UIPadding", bg)
	pad.PaddingLeft = UDim.new(0, 10)
	pad.PaddingRight = UDim.new(0, 10)
	pad.PaddingTop = UDim.new(0, 6)
	pad.PaddingBottom = UDim.new(0, 8)

	local stroke = Instance.new("UIStroke", bg)
	stroke.Color = color
	stroke.Thickness = 1.5

	local inner = Instance.new("Frame", bg)
	inner.Size = UDim2.new(1, 0, 0, 0)
	inner.AutomaticSize = Enum.AutomaticSize.Y
	inner.BackgroundTransparency = 1
	local innerLayout = Instance.new("UIListLayout", inner)
	innerLayout.Padding = UDim.new(0, 2)

	local t = Instance.new("TextLabel", inner)
	t.Size = UDim2.new(1, 0, 0, 18)
	t.BackgroundTransparency = 1
	t.Text = title
	t.TextColor3 = color
	t.Font = Enum.Font.GothamBold
	t.TextSize = 13
	t.TextXAlignment = Enum.TextXAlignment.Left

	local d = Instance.new("TextLabel", inner)
	d.Size = UDim2.new(1, 0, 0, 0)
	d.AutomaticSize = Enum.AutomaticSize.Y
	d.BackgroundTransparency = 1
	d.Text = text
	d.TextColor3 = Theme.TextMain
	d.Font = Enum.Font.Gotham
	d.TextSize = 12
	d.TextWrapped = true
	d.TextXAlignment = Enum.TextXAlignment.Left

	task.delay(duration, function()
		if not bg or not bg.Parent then return end
		local tweens = {
			TweenService:Create(bg, TweenInfo.new(0.3), {BackgroundTransparency = 1}),
			TweenService:Create(stroke, TweenInfo.new(0.3), {Transparency = 1}),
			TweenService:Create(t, TweenInfo.new(0.3), {TextTransparency = 1}),
			TweenService:Create(d, TweenInfo.new(0.3), {TextTransparency = 1}),
		}
		for _, tw in ipairs(tweens) do tw:Play() end
		task.wait(0.3)
		bg:Destroy()
	end)
end

-- ==========================================
-- MAIN FRAME
-- ==========================================
local W = isMobile and 440 or 540
local H = isMobile and 280 or 390

local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, W, 0, H)
mainFrame.Position = UDim2.new(0.5, -W/2, 0.5, -H/2)
mainFrame.BackgroundColor3 = Theme.Background
mainFrame.ClipsDescendants = true
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)
local mainStroke = Instance.new("UIStroke", mainFrame)
mainStroke.Color = Theme.Accent
mainStroke.Thickness = 1.5

local bgGrad = Instance.new("UIGradient", mainFrame)
bgGrad.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(16, 10, 26)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 6, 18)),
})
bgGrad.Rotation = 135

-- ==========================================
-- DRAGGING
-- ==========================================
do
	local dragging, dragStart, startPos
	mainFrame.InputBegan:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1
			or inp.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = inp.Position
			startPos = mainFrame.Position
			inp.Changed:Connect(function()
				if inp.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	UserInputService.InputChanged:Connect(function(inp)
		if not dragging then return end
		if inp.UserInputType == Enum.UserInputType.MouseMovement
			or inp.UserInputType == Enum.UserInputType.Touch then
			local d = inp.Position - dragStart
			mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
		end
	end)
end

-- ==========================================
-- TITLE BAR
-- ==========================================
local titleBar = Instance.new("Frame", mainFrame)
titleBar.Size = UDim2.new(1, 0, 0, 42)
titleBar.BackgroundColor3 = Theme.Sidebar
titleBar.ZIndex = 5
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 12)
local coverBottom = Instance.new("Frame", titleBar)
coverBottom.Size = UDim2.new(1, 0, 0, 12)
coverBottom.Position = UDim2.new(0, 0, 1, -12)
coverBottom.BackgroundColor3 = Theme.Sidebar
coverBottom.BorderSizePixel = 0

local titleGrad = Instance.new("UIGradient", titleBar)
titleGrad.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 18, 48)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 12, 32)),
})
titleGrad.Rotation = 90

local titleText = Instance.new("TextLabel", titleBar)
titleText.Size = UDim2.new(1, -80, 1, 0)
titleText.Position = UDim2.new(0, 18, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "✦ DELTA GALAXY V8"
titleText.TextColor3 = Theme.Accent
titleText.Font = Enum.Font.GothamBlack
titleText.TextSize = isMobile and 14 or 16
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.ZIndex = 6

-- Pulsing status dot
local accentDot = Instance.new("Frame", titleBar)
accentDot.Size = UDim2.new(0, 6, 0, 6)
accentDot.Position = UDim2.new(0, 8, 0.5, -3)
accentDot.BackgroundColor3 = Theme.Green
accentDot.ZIndex = 6
Instance.new("UICorner", accentDot).CornerRadius = UDim.new(1, 0)

task.spawn(function()
	while true do
		TweenService:Create(accentDot, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {BackgroundTransparency = 0.6}):Play()
		task.wait(0.8)
		TweenService:Create(accentDot, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {BackgroundTransparency = 0}):Play()
		task.wait(0.8)
	end
end)

local function MakeTitleBtn(offsetX, icon, color)
	local btn = Instance.new("TextButton", titleBar)
	btn.Size = UDim2.new(0, 28, 0, 28)
	btn.Position = UDim2.new(1, offsetX, 0.5, -14)
	btn.BackgroundColor3 = Theme.ElementBG
	btn.Text = icon
	btn.TextColor3 = color or Theme.TextMain
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	btn.ZIndex = 6
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	return btn
end

local minimizeBtn = MakeTitleBtn(-68, "−", Theme.TextDim)
local closeBtn    = MakeTitleBtn(-36, "✕", Theme.Red)

local toggleIcon = Instance.new("TextButton", gui)
toggleIcon.Size = UDim2.new(0, 48, 0, 48)
toggleIcon.Position = UDim2.new(0.05, 0, 0.15, 0)
toggleIcon.BackgroundColor3 = Theme.Sidebar
toggleIcon.Text = "✦"
toggleIcon.TextColor3 = Theme.Accent
toggleIcon.TextSize = 22
toggleIcon.Font = Enum.Font.GothamBold
toggleIcon.Visible = false
toggleIcon.ZIndex = 10
Instance.new("UICorner", toggleIcon).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", toggleIcon).Color = Theme.Accent

local guiVisible = true
local function setGuiVisible(v)
	guiVisible = v
	mainFrame.Visible = v
	toggleIcon.Visible = not v
end

closeBtn.MouseButton1Click:Connect(function() setGuiVisible(false) end)
minimizeBtn.MouseButton1Click:Connect(function() setGuiVisible(false) end)
toggleIcon.MouseButton1Click:Connect(function() setGuiVisible(true) end)

UserInputService.InputBegan:Connect(function(inp, gpe)
	if gpe then return end
	if inp.KeyCode == Enum.KeyCode.RightShift then setGuiVisible(not guiVisible) end
end)

-- ==========================================
-- SIDEBAR + CONTENT
-- ==========================================
local sidebarW = isMobile and 100 or 118

local sidebar = Instance.new("Frame", mainFrame)
sidebar.Size = UDim2.new(0, sidebarW, 1, -42)
sidebar.Position = UDim2.new(0, 0, 0, 42)
sidebar.BackgroundColor3 = Theme.Sidebar
Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 10)
local coverRight = Instance.new("Frame", sidebar)
coverRight.Size = UDim2.new(0, 10, 1, 0)
coverRight.Position = UDim2.new(1, -10, 0, 0)
coverRight.BackgroundColor3 = Theme.Sidebar
coverRight.BorderSizePixel = 0

local tabPad = Instance.new("UIPadding", sidebar)
tabPad.PaddingTop = UDim.new(0, 8)

local tabLayout = Instance.new("UIListLayout", sidebar)
tabLayout.Padding = UDim.new(0, 4)
tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local contentArea = Instance.new("Frame", mainFrame)
contentArea.Size = UDim2.new(1, -(sidebarW + 12), 1, -52)
contentArea.Position = UDim2.new(0, sidebarW + 8, 0, 47)
contentArea.BackgroundTransparency = 1

-- ==========================================
-- TAB SYSTEM
-- ==========================================
local Tabs = {}

local tabDefs = {
	{name = "Local",    icon = "👤"},
	{name = "Combat",   icon = "⚔"},
	{name = "Movement", icon = "🚀"},
	{name = "World",    icon = "🌍"},
	{name = "Fun",      icon = "🎉"},
	{name = "Players",  icon = "👥"},
}

local function SelectTab(name)
	for tName, t in pairs(Tabs) do
		t.Scroll.Visible = false
		TweenService:Create(t.Btn, TweenInfo.new(0.15), {BackgroundTransparency = 1, TextColor3 = Theme.TextDim}):Play()
		if t.Indicator then TweenService:Create(t.Indicator, TweenInfo.new(0.15), {BackgroundTransparency = 1}):Play() end
	end
	local t = Tabs[name]
	if not t then return end
	t.Scroll.Visible = true
	TweenService:Create(t.Btn, TweenInfo.new(0.15), {BackgroundTransparency = 0.7, TextColor3 = Theme.Accent}):Play()
	if t.Indicator then TweenService:Create(t.Indicator, TweenInfo.new(0.15), {BackgroundTransparency = 0}):Play() end
end

local function CreateTab(def)
	local btn = Instance.new("TextButton", sidebar)
	btn.Size = UDim2.new(1, -12, 0, isMobile and 38 or 42)
	btn.BackgroundColor3 = Theme.Accent
	btn.BackgroundTransparency = 1
	btn.Text = def.icon .. "\n" .. def.name
	btn.TextColor3 = Theme.TextDim
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = isMobile and 10 or 11
	btn.AutoButtonColor = false
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

	local indicator = Instance.new("Frame", btn)
	indicator.Size = UDim2.new(0, 3, 0.7, 0)
	indicator.Position = UDim2.new(0, 0, 0.15, 0)
	indicator.BackgroundColor3 = Theme.Accent
	indicator.BackgroundTransparency = 1
	Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)

	local scroll = Instance.new("ScrollingFrame", contentArea)
	scroll.Size = UDim2.new(1, 0, 1, 0)
	scroll.BackgroundTransparency = 1
	scroll.Visible = false
	scroll.ScrollBarThickness = 3
	scroll.ScrollBarImageColor3 = Theme.Accent
	scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
	scroll.CanvasSize = UDim2.new(0, 0, 0, 0)

	local list = Instance.new("UIListLayout", scroll)
	list.Padding = UDim.new(0, 7)
	local pad = Instance.new("UIPadding", scroll)
	pad.PaddingBottom = UDim.new(0, 10)

	Tabs[def.name] = {Btn = btn, Scroll = scroll, Indicator = indicator}
	btn.MouseButton1Click:Connect(function() SelectTab(def.name) end)
end

for _, def in ipairs(tabDefs) do CreateTab(def) end

-- ==========================================
-- COMPONENT BUILDERS
-- ==========================================
local function GetScroll(tabName)
	return Tabs[tabName] and Tabs[tabName].Scroll
end

local function CreateLabel(tabName, text)
	local lbl = Instance.new("TextLabel", GetScroll(tabName))
	lbl.Size = UDim2.new(1, -10, 0, 20)
	lbl.BackgroundTransparency = 1
	lbl.Text = "  " .. text
	lbl.TextColor3 = Theme.AccentDim
	lbl.Font = Enum.Font.GothamBold
	lbl.TextSize = 11
	lbl.TextXAlignment = Enum.TextXAlignment.Left
end

local function CreateButton(tabName, text, callback, color)
	local btn = Instance.new("TextButton", GetScroll(tabName))
	btn.Size = UDim2.new(1, -10, 0, 38)
	btn.BackgroundColor3 = Theme.ElementBG
	btn.Text = "  " .. text
	btn.TextColor3 = Theme.TextMain
	btn.Font = Enum.Font.GothamSemibold
	btn.TextSize = isMobile and 12 or 13
	btn.TextXAlignment = Enum.TextXAlignment.Left
	btn.AutoButtonColor = false
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 7)
	Instance.new("UIStroke", btn).Color = Color3.fromRGB(55, 38, 78)

	local bar = Instance.new("Frame", btn)
	bar.Size = UDim2.new(0, 3, 0.6, 0)
	bar.Position = UDim2.new(0, 0, 0.2, 0)
	bar.BackgroundColor3 = color or Theme.Accent
	Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)

	btn.MouseButton1Click:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.08), {BackgroundColor3 = Theme.AccentDim}):Play()
		task.spawn(callback)
		task.wait(0.12)
		TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = Theme.ElementBG}):Play()
	end)
	return btn
end

local function CreateToggle(tabName, text, default, callback)
	local state = default or false
	local btn = Instance.new("TextButton", GetScroll(tabName))
	btn.Size = UDim2.new(1, -10, 0, 38)
	btn.BackgroundColor3 = Theme.ElementBG
	btn.Text = "  " .. text
	btn.TextColor3 = Theme.TextMain
	btn.Font = Enum.Font.GothamSemibold
	btn.TextSize = isMobile and 12 or 13
	btn.TextXAlignment = Enum.TextXAlignment.Left
	btn.AutoButtonColor = false
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 7)
	Instance.new("UIStroke", btn).Color = Color3.fromRGB(55, 38, 78)

	local pill = Instance.new("Frame", btn)
	pill.Size = UDim2.new(0, 36, 0, 20)
	pill.Position = UDim2.new(1, -44, 0.5, -10)
	pill.BackgroundColor3 = state and Theme.Accent or Color3.fromRGB(50, 40, 65)
	Instance.new("UICorner", pill).CornerRadius = UDim.new(1, 0)

	local knob = Instance.new("Frame", pill)
	knob.Size = UDim2.new(0, 14, 0, 14)
	knob.Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
	knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

	local function refresh()
		TweenService:Create(pill, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {
			BackgroundColor3 = state and Theme.Accent or Color3.fromRGB(50, 40, 65)
		}):Play()
		TweenService:Create(knob, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
		}):Play()
	end

	btn.MouseButton1Click:Connect(function()
		state = not state
		refresh()
		task.spawn(callback, state)
	end)
	if state then refresh() end
	return btn
end

local function CreateSlider(tabName, text, min, max, default, callback)
	local frame = Instance.new("Frame", GetScroll(tabName))
	frame.Size = UDim2.new(1, -10, 0, 54)
	frame.BackgroundColor3 = Theme.ElementBG
	Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 7)
	Instance.new("UIStroke", frame).Color = Color3.fromRGB(55, 38, 78)

	local label = Instance.new("TextLabel", frame)
	label.Size = UDim2.new(1, -20, 0, 18)
	label.Position = UDim2.new(0, 10, 0, 7)
	label.BackgroundTransparency = 1
	label.Text = text .. ":  " .. tostring(default)
	label.TextColor3 = Theme.TextMain
	label.Font = Enum.Font.GothamSemibold
	label.TextSize = 12
	label.TextXAlignment = Enum.TextXAlignment.Left

	local track = Instance.new("Frame", frame)
	track.Size = UDim2.new(1, -20, 0, 6)
	track.Position = UDim2.new(0, 10, 0, 38)
	track.BackgroundColor3 = Color3.fromRGB(40, 30, 55)
	Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

	local fill = Instance.new("Frame", track)
	fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
	fill.BackgroundColor3 = Theme.Accent
	Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

	local fillGrad = Instance.new("UIGradient", fill)
	fillGrad.Color = ColorSequence.new(Theme.AccentDim, Theme.AccentHover)

	local handle = Instance.new("Frame", track)
	handle.Size = UDim2.new(0, 14, 0, 14)
	handle.AnchorPoint = Vector2.new(0.5, 0.5)
	handle.Position = UDim2.new((default - min) / (max - min), 0, 0.5, 0)
	handle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Instance.new("UICorner", handle).CornerRadius = UDim.new(1, 0)

	local sliding = false
	local function updateSlider(inputX)
		local rel = math.clamp((inputX - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
		local value = math.floor(min + (max - min) * rel + 0.5)
		fill.Size = UDim2.new(rel, 0, 1, 0)
		handle.Position = UDim2.new(rel, 0, 0.5, 0)
		label.Text = text .. ":  " .. tostring(value)
		callback(value)
	end

	frame.InputBegan:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1
			or inp.UserInputType == Enum.UserInputType.Touch then
			sliding = true; updateSlider(inp.Position.X)
		end
	end)
	UserInputService.InputChanged:Connect(function(inp)
		if not sliding then return end
		if inp.UserInputType == Enum.UserInputType.MouseMovement
			or inp.UserInputType == Enum.UserInputType.Touch then
			updateSlider(inp.Position.X)
		end
	end)
	UserInputService.InputEnded:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1
			or inp.UserInputType == Enum.UserInputType.Touch then
			sliding = false
		end
	end)
end

local function CreateDropdown(tabName, text, options, callback)
	local open = false
	local container = Instance.new("Frame", GetScroll(tabName))
	container.Size = UDim2.new(1, -10, 0, 38)
	container.BackgroundTransparency = 1
	container.ClipsDescendants = false

	local header = Instance.new("TextButton", container)
	header.Size = UDim2.new(1, 0, 1, 0)
	header.BackgroundColor3 = Theme.ElementBG
	header.Text = "  " .. text .. ": " .. (options[1] or "")
	header.TextColor3 = Theme.TextMain
	header.Font = Enum.Font.GothamSemibold
	header.TextSize = isMobile and 12 or 13
	header.TextXAlignment = Enum.TextXAlignment.Left
	header.AutoButtonColor = false
	Instance.new("UICorner", header).CornerRadius = UDim.new(0, 7)
	Instance.new("UIStroke", header).Color = Color3.fromRGB(55, 38, 78)

	local arrow = Instance.new("TextLabel", header)
	arrow.Size = UDim2.new(0, 24, 1, 0)
	arrow.Position = UDim2.new(1, -28, 0, 0)
	arrow.BackgroundTransparency = 1
	arrow.Text = "▾"
	arrow.TextColor3 = Theme.Accent
	arrow.Font = Enum.Font.GothamBold
	arrow.TextSize = 14

	local dropList = Instance.new("Frame", container)
	dropList.Size = UDim2.new(1, 0, 0, #options * 32)
	dropList.Position = UDim2.new(0, 0, 1, 4)
	dropList.BackgroundColor3 = Theme.Sidebar
	dropList.Visible = false
	dropList.ZIndex = 20
	Instance.new("UICorner", dropList).CornerRadius = UDim.new(0, 7)
	Instance.new("UIStroke", dropList).Color = Theme.Accent
	Instance.new("UIListLayout", dropList).Padding = UDim.new(0, 0)

	for _, opt in ipairs(options) do
		local optBtn = Instance.new("TextButton", dropList)
		optBtn.Size = UDim2.new(1, 0, 0, 32)
		optBtn.BackgroundTransparency = 1
		optBtn.Text = "  " .. opt
		optBt

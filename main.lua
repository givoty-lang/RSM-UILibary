local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local RSMLibary = {}

local WindowData = nil

local function Tween(Object, Time, Properties)
	local Animation = TweenService:Create(Object, TweenInfo.new(Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), Properties)
	Animation:Play()
	return Animation
end

function RSMLibary.CreateWindow(Config)
	Config = Config or {}

	local WindowName = Config.Name or "RSM Window"
	local Tabs = Config.Tabs or {
		Main = {
			Name = "Main",
			LayoutOrder = 1
		}
	}

	local Player = Players.LocalPlayer
	local PlayerGui = Player:WaitForChild("PlayerGui")

	WindowData = {
		Name = WindowName,
		Tabs = Tabs
	}

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "RSMUI"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.IgnoreGuiInset = true
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.Parent = PlayerGui

	local Window = Instance.new("Frame")
	Window.Name = "Window"
	Window.Size = UDim2.fromOffset(440, 275)
	Window.Position = UDim2.new(0.5, -220, 0.5, -137)
	Window.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
	Window.BorderSizePixel = 0
	Window.Parent = ScreenGui

	local WindowCorner = Instance.new("UICorner")
	WindowCorner.CornerRadius = UDim.new(0, 5)
	WindowCorner.Parent = Window

	local WindowStroke = Instance.new("UIStroke")
	WindowStroke.Color = Color3.fromRGB(255, 255, 255)
	WindowStroke.Transparency = 0.72
	WindowStroke.Thickness = 1
	WindowStroke.Parent = Window

	local TopBar = Instance.new("Frame")
	TopBar.Name = "TopBar"
	TopBar.Size = UDim2.new(1, 0, 0, 34)
	TopBar.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
	TopBar.BorderSizePixel = 0
	TopBar.Parent = Window

	local TopBarCorner = Instance.new("UICorner")
	TopBarCorner.CornerRadius = UDim.new(0, 5)
	TopBarCorner.Parent = TopBar

	local TopBarBottom = Instance.new("Frame")
	TopBarBottom.Name = "Bottom"
	TopBarBottom.Position = UDim2.new(0, 0, 1, -1)
	TopBarBottom.Size = UDim2.new(1, 0, 0, 1)
	TopBarBottom.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TopBarBottom.BackgroundTransparency = 0.92
	TopBarBottom.BorderSizePixel = 0
	TopBarBottom.Parent = TopBar

	local Title = Instance.new("TextLabel")
	Title.Name = "Title"
	Title.Position = UDim2.fromOffset(12, 0)
	Title.Size = UDim2.new(1, -72, 1, 0)
	Title.BackgroundTransparency = 1
	Title.Font = Enum.Font.GothamMedium
	Title.Text = WindowName
	Title.TextColor3 = Color3.fromRGB(245, 245, 245)
	Title.TextSize = 13
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.Parent = TopBar

	local Minimize = Instance.new("TextButton")
	Minimize.Name = "Minimize"
	Minimize.AnchorPoint = Vector2.new(1, 0)
	Minimize.Position = UDim2.new(1, -28, 0, 0)
	Minimize.Size = UDim2.fromOffset(28, 34)
	Minimize.BackgroundTransparency = 1
	Minimize.BorderSizePixel = 0
	Minimize.Font = Enum.Font.GothamMedium
	Minimize.Text = "−"
	Minimize.TextColor3 = Color3.fromRGB(165, 165, 165)
	Minimize.TextSize = 15
	Minimize.AutoButtonColor = false
	Minimize.Parent = TopBar

	local Close = Instance.new("TextButton")
	Close.Name = "Close"
	Close.AnchorPoint = Vector2.new(1, 0)
	Close.Position = UDim2.new(0.985, 0, 0, 0)
	Close.Size = UDim2.fromOffset(28, 34)
	Close.BackgroundTransparency = 1
	Close.BorderSizePixel = 0
	Close.Font = Enum.Font.GothamMedium
	Close.Text = "×"
	Close.TextColor3 = Color3.fromRGB(165, 165, 165)
	Close.TextSize = 16
	Close.AutoButtonColor = false
	Close.Parent = TopBar

	local Sidebar = Instance.new("Frame")
	Sidebar.Name = "Sidebar"
	Sidebar.Position = UDim2.fromOffset(0, 34)
	Sidebar.Size = UDim2.new(0, 105, 1, -34)
	Sidebar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
	Sidebar.BorderSizePixel = 0
	Sidebar.Parent = Window

	local TabHolder = Instance.new("Frame")
	TabHolder.Name = "TabHolder"
	TabHolder.Position = UDim2.fromOffset(7, 9)
	TabHolder.Size = UDim2.new(1, -14, 1, -18)
	TabHolder.BackgroundTransparency = 1
	TabHolder.Parent = Sidebar

	local TabLayout = Instance.new("UIListLayout")
	TabLayout.Padding = UDim.new(0, 3)
	TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
	TabLayout.Parent = TabHolder

	local Content = Instance.new("Frame")
	Content.Name = "Content"
	Content.Position = UDim2.fromOffset(106, 34)
	Content.Size = UDim2.new(1, -106, 1, -34)
	Content.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
	Content.BorderSizePixel = 0
	Content.Parent = Window

	local ContentPadding = Instance.new("UIPadding")
	ContentPadding.PaddingTop = UDim.new(0, 12)
	ContentPadding.PaddingBottom = UDim.new(0, 12)
	ContentPadding.PaddingLeft = UDim.new(0, 14)
	ContentPadding.PaddingRight = UDim.new(0, 14)
	ContentPadding.Parent = Content

	local TabPages = {}
	local TabObjects = {}
	local OrderedTabs = {}

	for Key, Data in pairs(Tabs) do
		Data = typeof(Data) == "table" and Data or {
			Name = tostring(Data),
			Icon = ""
		}

		table.insert(OrderedTabs, {
			Key = Key,
			Data = Data,
			LayoutOrder = Data.LayoutOrder or 0
		})
	end

	table.sort(OrderedTabs, function(A, B)
		return A.LayoutOrder < B.LayoutOrder
	end)

	for Index, TabData in ipairs(OrderedTabs) do
		local Key = TabData.Key
		local Data = TabData.Data
		local TabName = Data.Name or Key
		local Icon = Data.Icon or ""

		local Tab = Instance.new("TextButton")
		Tab.Name = Key
		Tab.Size = UDim2.new(1, 0, 0, 30)
		Tab.BackgroundColor3 = Color3.fromRGB(19, 19, 19)
		Tab.BackgroundTransparency = Index == 1 and 0 or 1
		Tab.BorderSizePixel = 0
		Tab.Font = Enum.Font.GothamMedium
		Tab.Text = ""
		Tab.AutoButtonColor = false
		Tab.LayoutOrder = TabData.LayoutOrder
		Tab.Parent = TabHolder

		local TabCorner = Instance.new("UICorner")
		TabCorner.CornerRadius = UDim.new(0, 4)
		TabCorner.Parent = Tab

		local TabIcon = Instance.new("ImageLabel")
		TabIcon.Name = "Icon"
		TabIcon.Position = UDim2.fromOffset(9, 7)
		TabIcon.Size = UDim2.fromOffset(16, 16)
		TabIcon.BackgroundTransparency = 1
		TabIcon.Image = Icon
		TabIcon.ImageColor3 = Index == 1 and Color3.fromRGB(235, 235, 235) or Color3.fromRGB(125, 125, 125)
		TabIcon.ImageTransparency = Icon == "" and 1 or 0
		TabIcon.Parent = Tab

		local TabLabel = Instance.new("TextLabel")
		TabLabel.Name = "Label"
		TabLabel.Position = UDim2.fromOffset(31, 0)
		TabLabel.Size = UDim2.new(1, -37, 1, 0)
		TabLabel.BackgroundTransparency = 1
		TabLabel.Font = Enum.Font.GothamMedium
		TabLabel.Text = TabName
		TabLabel.TextColor3 = Index == 1 and Color3.fromRGB(245, 245, 245) or Color3.fromRGB(145, 145, 145)
		TabLabel.TextSize = 11
		TabLabel.TextXAlignment = Enum.TextXAlignment.Left
		TabLabel.Parent = Tab

		local Page = Instance.new("Frame")
		Page.Name = Key
		Page.Size = UDim2.fromScale(1, 1)
		Page.BackgroundTransparency = 1
		Page.Visible = Index == 1
		Page.Parent = Content

		TabPages[Key] = Page
		TabObjects[Key] = Tab

		Tab.MouseEnter:Connect(function()
			if Page.Visible == false then
				Tween(TabLabel, 0.15, {TextColor3 = Color3.fromRGB(205, 205, 205)})
				Tween(TabIcon, 0.15, {ImageColor3 = Color3.fromRGB(180, 180, 180)})
			end
		end)

		Tab.MouseLeave:Connect(function()
			if Page.Visible == false then
				Tween(TabLabel, 0.15, {TextColor3 = Color3.fromRGB(145, 145, 145)})
				Tween(TabIcon, 0.15, {ImageColor3 = Color3.fromRGB(125, 125, 125)})
			end
		end)

		Tab.MouseButton1Click:Connect(function()
			for OtherKey, OtherPage in pairs(TabPages) do
				local OtherTab = TabObjects[OtherKey]
				local OtherLabel = OtherTab:FindFirstChild("Label")
				local OtherIcon = OtherTab:FindFirstChild("Icon")
				local Active = OtherPage == Page

				OtherPage.Visible = Active

				Tween(OtherTab, 0.16, {BackgroundTransparency = Active and 0 or 1})

				if OtherLabel then
					Tween(OtherLabel, 0.16, {TextColor3 = Active and Color3.fromRGB(245, 245, 245) or Color3.fromRGB(145, 145, 145)})
				end

				if OtherIcon then
					Tween(OtherIcon, 0.16, {ImageColor3 = Active and Color3.fromRGB(235, 235, 235) or Color3.fromRGB(125, 125, 125)})
				end
			end
		end)
	end

	local Dragging = false
	local DragStart
	local StartPosition

	TopBar.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			Dragging = true
			DragStart = Input.Position
			StartPosition = Window.Position
		end
	end)

	UserInputService.InputChanged:Connect(function(Input)
		if Dragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
			local Delta = Input.Position - DragStart
			Window.Position = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
		end
	end)

	UserInputService.InputEnded:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			Dragging = false
		end
	end)

	Close.MouseEnter:Connect(function()
		Tween(Close, 0.15, {TextColor3 = Color3.fromRGB(255, 255, 255)})
	end)

	Close.MouseLeave:Connect(function()
		Tween(Close, 0.15, {TextColor3 = Color3.fromRGB(165, 165, 165)})
	end)

	Minimize.MouseEnter:Connect(function()
		Tween(Minimize, 0.15, {TextColor3 = Color3.fromRGB(255, 255, 255)})
	end)

	Minimize.MouseLeave:Connect(function()
		Tween(Minimize, 0.15, {TextColor3 = Color3.fromRGB(165, 165, 165)})
	end)

	local OriginalSize = Window.Size
	local Minimized = false
	local Closing = false

	Minimize.MouseButton1Click:Connect(function()
		if Closing then
			return
		end

		Minimized = not Minimized

		if Minimized then
			Tween(Window, 0.28, {Size = UDim2.new(OriginalSize.X.Scale, OriginalSize.X.Offset, 0, 34)})
			Tween(WindowCorner, 0.28, {CornerRadius = UDim.new(0, 4)})

			task.delay(0.08, function()
				Sidebar.Visible = false
				Content.Visible = false
			end)

			Minimize.Text = "+"
		else
			Sidebar.Visible = true
			Content.Visible = true

			Tween(Window, 0.32, {Size = OriginalSize})
			Tween(WindowCorner, 0.32, {CornerRadius = UDim.new(0, 5)})

			Minimize.Text = "−"
		end
	end)

	Close.MouseButton1Click:Connect(function()
		if Closing then
			return
		end

		Closing = true

		local UIScale = Instance.new("UIScale")
		UIScale.Scale = 1
		UIScale.Parent = Window

		Tween(UIScale, 0.22, {Scale = 0.96})
		Tween(Window, 0.22, {BackgroundTransparency = 1})
		Tween(WindowStroke, 0.22, {Transparency = 1})
		Tween(TopBar, 0.22, {BackgroundTransparency = 1})
		Tween(TopBarBottom, 0.22, {BackgroundTransparency = 1})
		Tween(Title, 0.22, {TextTransparency = 1})
		Tween(Minimize, 0.22, {TextTransparency = 1})
		Tween(Close, 0.22, {TextTransparency = 1})
		Tween(Sidebar, 0.22, {BackgroundTransparency = 1})
		Tween(Content, 0.22, {BackgroundTransparency = 1})

		task.delay(0.22, function()
			if ScreenGui and ScreenGui.Parent then
				ScreenGui:Destroy()
			end
		end)
	end)

	WindowData.Gui = ScreenGui
	WindowData.Window = Window
	WindowData.Content = Content
	WindowData.Tabs = TabPages

	return WindowData
end

function RSMLibary.Init()
	if WindowData == nil or WindowData.Gui == nil then
		return
	end
end

return RSMLibary

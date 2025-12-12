local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Library = {}
local ScreenGui
local MainFrame
local ContentFrame
local TabContainer
local NotificationHolder

local Theme = {
    Background = Color3.fromRGB(15, 15, 15),
    Secondary = Color3.fromRGB(20, 20, 20),
    Tertiary = Color3.fromRGB(25, 25, 25),
    Primary = Color3.fromRGB(255, 0, 0),
    PrimaryDark = Color3.fromRGB(180, 0, 0),
    Text = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(150, 150, 150),
    Success = Color3.fromRGB(0, 255, 0),
    Border = Color3.fromRGB(40, 40, 40)
}

local function CreateTween(object, properties, duration, style, direction)
    local tweenInfo = TweenInfo.new(duration or 0.3, style or Enum.EasingStyle.Quad, direction or Enum.EasingDirection.Out)
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end

local function Ripple(object, x, y)
    local circle = Instance.new("Frame")
    circle.Name = "Ripple"
    circle.Parent = object
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    circle.BackgroundTransparency = 0.5
    circle.Size = UDim2.new(0, 0, 0, 0)
    circle.Position = UDim2.new(0, x, 0, y)
    circle.AnchorPoint = Vector2.new(0.5, 0.5)
    circle.ZIndex = 10
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = circle
    local size = math.max(object.AbsoluteSize.X, object.AbsoluteSize.Y) * 2
    CreateTween(circle, {Size = UDim2.new(0, size, 0, size), BackgroundTransparency = 1}, 0.5)
    task.delay(0.5, function() circle:Destroy() end)
end

function Library:CreateWindow(config)
    config = config or {}
    local windowName = config.Name or "Fluent UI"
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "FluentUI"
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Theme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.5, -350, 0.5, -250)
    MainFrame.Size = UDim2.new(0, 700, 0, 500)
    MainFrame.ClipsDescendants = true
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 12)
    mainCorner.Parent = MainFrame
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Parent = MainFrame
    shadow.BackgroundTransparency = 1
    shadow.Position = UDim2.new(0, -15, 0, -15)
    shadow.Size = UDim2.new(1, 30, 1, 30)
    shadow.ZIndex = 0
    shadow.Image = "rbxassetid://6015897843"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.5
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    local topBar = Instance.new("Frame")
    topBar.Name = "TopBar"
    topBar.Parent = MainFrame
    topBar.BackgroundColor3 = Theme.Secondary
    topBar.BorderSizePixel = 0
    topBar.Size = UDim2.new(1, 0, 0, 50)
    local topCorner = Instance.new("UICorner")
    topCorner.CornerRadius = UDim.new(0, 12)
    topCorner.Parent = topBar
    local topCover = Instance.new("Frame")
    topCover.Parent = topBar
    topCover.BackgroundColor3 = Theme.Secondary
    topCover.BorderSizePixel = 0
    topCover.Position = UDim2.new(0, 0, 1, -10)
    topCover.Size = UDim2.new(1, 0, 0, 10)
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Parent = topBar
    title.BackgroundTransparency = 1
    title.Position = UDim2.new(0, 20, 0, 0)
    title.Size = UDim2.new(0, 300, 1, 0)
    title.Font = Enum.Font.GothamBold
    title.Text = windowName
    title.TextColor3 = Theme.Text
    title.TextSize = 18
    title.TextXAlignment = Enum.TextXAlignment.Left
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseButton"
    closeBtn.Parent = topBar
    closeBtn.BackgroundColor3 = Theme.Primary
    closeBtn.BorderSizePixel = 0
    closeBtn.Position = UDim2.new(1, -40, 0.5, -15)
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Theme.Text
    closeBtn.TextSize = 14
    closeBtn.AutoButtonColor = false
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = closeBtn
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Name = "MinimizeButton"
    minimizeBtn.Parent = topBar
    minimizeBtn.BackgroundColor3 = Theme.Primary
    minimizeBtn.BorderSizePixel = 0
    minimizeBtn.Position = UDim2.new(1, -80, 0.5, -15)
    minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
    minimizeBtn.Font = Enum.Font.GothamBold
    minimizeBtn.Text = "_"
    minimizeBtn.TextColor3 = Theme.Text
    minimizeBtn.TextSize = 14
    minimizeBtn.AutoButtonColor = false
    local minimizeCorner = Instance.new("UICorner")
    minimizeCorner.CornerRadius = UDim.new(0, 8)
    minimizeCorner.Parent = minimizeBtn
    local minimized = false
    local storedSize = MainFrame.Size
    minimizeBtn.MouseButton1Click:Connect(function()
        if minimized then
            MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
            CreateTween(MainFrame, {Size = storedSize}, 0.3, Enum.EasingStyle.Back)
            minimized = false
        else
            storedSize = MainFrame.Size
            MainFrame.AnchorPoint = Vector2.new(0.5, 0)
            CreateTween(MainFrame, {Size = UDim2.new(0, storedSize.X.Offset, 0, 40)}, 0.3, Enum.EasingStyle.Back)
            minimized = true
        end
    end)
    closeBtn.MouseButton1Click:Connect(function()
        CreateTween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        task.wait(0.3)
        ScreenGui:Destroy()
    end)
    closeBtn.MouseEnter:Connect(function() CreateTween(closeBtn, {BackgroundColor3 = Theme.PrimaryDark}, 0.2) end)
    closeBtn.MouseLeave:Connect(function() CreateTween(closeBtn, {BackgroundColor3 = Theme.Primary}, 0.2) end)
    minimizeBtn.MouseEnter:Connect(function() CreateTween(minimizeBtn, {BackgroundColor3 = Theme.PrimaryDark}, 0.2) end)
    minimizeBtn.MouseLeave:Connect(function() CreateTween(minimizeBtn, {BackgroundColor3 = Theme.Primary}, 0.2) end)

-- Tab Container
    TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Parent = MainFrame
    TabContainer.BackgroundColor3 = Theme.Secondary
    TabContainer.BorderSizePixel = 0
    TabContainer.Position = UDim2.new(0, 10, 0, 60)
    TabContainer.Size = UDim2.new(0, 150, 1, -70)
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 10)
    tabCorner.Parent = TabContainer
    local tabList = Instance.new("UIListLayout")
    tabList.Parent = TabContainer
    tabList.SortOrder = Enum.SortOrder.LayoutOrder
    tabList.Padding = UDim.new(0, 8)
    local tabPadding = Instance.new("UIPadding")
    tabPadding.Parent = TabContainer
    tabPadding.PaddingTop = UDim.new(0, 10)
    tabPadding.PaddingLeft = UDim.new(0, 10)
    tabPadding.PaddingRight = UDim.new(0, 10)

-- Content Frame
    ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Parent = MainFrame
    ContentFrame.BackgroundColor3 = Theme.Secondary
    ContentFrame.BorderSizePixel = 0
    ContentFrame.Position = UDim2.new(0, 170, 0, 60)
    ContentFrame.Size = UDim2.new(1, -180, 1, -70)
    local contentCorner = Instance.new("UICorner")
    contentCorner.CornerRadius = UDim.new(0, 10)
    contentCorner.Parent = ContentFrame

-- Notification Holder
    NotificationHolder = Instance.new("Frame")
    NotificationHolder.Name = "Notifications"
    NotificationHolder.Parent = ScreenGui
    NotificationHolder.BackgroundTransparency = 1
    NotificationHolder.Position = UDim2.new(1, -320, 0, 20)
    NotificationHolder.Size = UDim2.new(0, 300, 1, -40)
    local notifList = Instance.new("UIListLayout")
    notifList.Parent = NotificationHolder
    notifList.SortOrder = Enum.SortOrder.LayoutOrder
    notifList.Padding = UDim.new(0, 10)
    notifList.VerticalAlignment = Enum.VerticalAlignment.Top

    local dragging = false
    local dragInput, mousePos, framePos
    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            framePos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    topBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            MainFrame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
        end
    end)
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    CreateTween(MainFrame, {Size = UDim2.new(0, 700, 0, 500)}, 0.5, Enum.EasingStyle.Back)

-- Return Library
    local Window = {}
    Window.Tabs = {}
    Window.CurrentTab = nil

-- Notification Function
    function Window:Notify(config)
        config = config or {}
        local notifTitle = config.Title or "Notification"
        local notifContent = config.Content or "This is a notification"
        local notifDuration = config.Duration or 3
        local notifType = config.Type or "Default"
        local notif = Instance.new("Frame")
        notif.Name = "Notification"
        notif.Parent = NotificationHolder
        notif.BackgroundColor3 = Theme.Tertiary
        notif.BorderSizePixel = 0
        notif.Size = UDim2.new(1, 0, 0, 80)
        notif.ClipsDescendants = true
        notif.Position = UDim2.new(0, 300, 0, 0)
        local notifCorner = Instance.new("UICorner")
        notifCorner.CornerRadius = UDim.new(0, 10)
        notifCorner.Parent = notif
        local notifBar = Instance.new("Frame")
        notifBar.Name = "Bar"
        notifBar.Parent = notif
        notifBar.BackgroundColor3 = notifType == "Success" and Theme.Success or Theme.Primary
        notifBar.BorderSizePixel = 0
        notifBar.Size = UDim2.new(0, 4, 1, 0)
        local notifTitleLabel = Instance.new("TextLabel")
        notifTitleLabel.Parent = notif
        notifTitleLabel.BackgroundTransparency = 1
        notifTitleLabel.Position = UDim2.new(0, 15, 0, 10)
        notifTitleLabel.Size = UDim2.new(1, -30, 0, 20)
        notifTitleLabel.Font = Enum.Font.GothamBold
        notifTitleLabel.Text = notifTitle
        notifTitleLabel.TextColor3 = Theme.Text
        notifTitleLabel.TextSize = 14
        notifTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        local notifContentLabel = Instance.new("TextLabel")
        notifContentLabel.Parent = notif
        notifContentLabel.BackgroundTransparency = 1
        notifContentLabel.Position = UDim2.new(0, 15, 0, 35)
        notifContentLabel.Size = UDim2.new(1, -30, 1, -45)
        notifContentLabel.Font = Enum.Font.Gotham
        notifContentLabel.Text = notifContent
        notifContentLabel.TextColor3 = Theme.TextDark
        notifContentLabel.TextSize = 12
        notifContentLabel.TextXAlignment = Enum.TextXAlignment.Left
        notifContentLabel.TextYAlignment = Enum.TextYAlignment.Top
        notifContentLabel.TextWrapped = true
        CreateTween(notif, {Position = UDim2.new(0, 0, 0, 0)}, 0.4)
        task.delay(notifDuration, function()
            CreateTween(notif, {Position = UDim2.new(0, 300, 0, 0)}, 0.3)
            task.wait(0.3)
            notif:Destroy()
        end)
    end

    function Window:CreateTab(config)
        config = config or {}
        local tabName = config.Name or "Tab"
        local tabIcon = config.Icon or ""
        local Tab = {}
        Tab.Elements = {}
        local tabButton = Instance.new("TextButton")
        tabButton.Name = tabName
        tabButton.Parent = TabContainer
        tabButton.BackgroundColor3 = Theme.Tertiary
        tabButton.BorderSizePixel = 0
        tabButton.Size = UDim2.new(1, 0, 0, 40)
        tabButton.Font = Enum.Font.GothamBold
        tabButton.Text = tabName
        tabButton.TextColor3 = Theme.TextDark
        tabButton.TextSize = 13
        tabButton.AutoButtonColor = false
        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 8)
        tabCorner.Parent = tabButton
        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Name = tabName .. "Content"
        tabContent.Parent = ContentFrame
        tabContent.BackgroundTransparency = 1
        tabContent.BorderSizePixel = 0
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.ScrollBarThickness = 4
        tabContent.ScrollBarImageColor3 = Theme.Primary
        tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        tabContent.Visible = false
        local contentList = Instance.new("UIListLayout")
        contentList.Parent = tabContent
        contentList.SortOrder = Enum.SortOrder.LayoutOrder
        contentList.Padding = UDim.new(0, 10)
        contentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tabContent.CanvasSize = UDim2.new(0, 0, 0, contentList.AbsoluteContentSize.Y + 20)
        end)
        local contentPadding = Instance.new("UIPadding")
        contentPadding.Parent = tabContent
        contentPadding.PaddingTop = UDim.new(0, 15)
        contentPadding.PaddingLeft = UDim.new(0, 15)
        contentPadding.PaddingRight = UDim.new(0, 15)
        contentPadding.PaddingBottom = UDim.new(0, 15)
        tabButton.MouseButton1Click:Connect(function()
            Ripple(tabButton, tabButton.AbsoluteSize.X / 2, tabButton.AbsoluteSize.Y / 2)
            for _, tab in pairs(Window.Tabs) do
                tab.Button.BackgroundColor3 = Theme.Tertiary
                tab.Button.TextColor3 = Theme.TextDark
                tab.Content.Visible = false
            end
            tabButton.BackgroundColor3 = Theme.Primary
            tabButton.TextColor3 = Theme.Text
            tabContent.Visible = true
            Window.CurrentTab = Tab
        end)
        tabButton.MouseEnter:Connect(function()
            if tabButton.BackgroundColor3 ~= Theme.Primary then
                CreateTween(tabButton, {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}, 0.2)
            end
        end)
        tabButton.MouseLeave:Connect(function()
            if tabButton.BackgroundColor3 ~= Theme.Primary then
                CreateTween(tabButton, {BackgroundColor3 = Theme.Tertiary}, 0.2)
            end
        end)
        Tab.Button = tabButton
        Tab.Content = tabContent
        table.insert(Window.Tabs, Tab)
        if #Window.Tabs == 1 then
            tabButton:MouseButton1Click()
        end
        return Tab
    end

    return Window
end

return Library

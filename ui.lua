--[[
- Created by fluflu
- used for Xeric Hub
- this UI is free to use for everyone else
]]--
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Library = {}
local ScreenGui
local MainFrame
local ContentFrame
local TabContainer
local NotificationHolder
local isMinimized = false
local titleAnimation
local ORIGINAL_SIZE = UDim2.new(0, 700, 0, 500)
local MINIMIZED_SIZE = UDim2.new(0, 250, 0, 50)
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
   
    task.delay(0.5, function()
        circle:Destroy()
    end)
end
function Library:CreateWindow(config)
    config = config or {}
    local windowName = config.Name or "Fluent UI"
   
    local function AnimateTitle(shouldAnimate)
        if shouldAnimate then
            if titleAnimation then titleAnimation:Disconnect() end
           
            local title = MainFrame.TopBar.Title
            local loop = true
           
            titleAnimation = RunService.Heartbeat:Connect(function(dt)
                if not loop then return end
               
                local color1 = Theme.TextDark
                local color2 = Theme.Primary
                local cycleTime = 1.5
               
                local t = (tick() % cycleTime) / cycleTime
               
                local progress = t * 2
               
                local tweenColor
                if progress <= 1 then
                   
                    tweenColor = color1:Lerp(color2, progress)
                else
                   
                    tweenColor = color2:Lerp(color1, progress - 1)
                end
               
                title.TextColor3 = tweenColor
            end)
           
        else
            if titleAnimation then
                titleAnimation:Disconnect()
                titleAnimation = nil
            end
            MainFrame.TopBar.Title.TextColor3 = Theme.Text
        end
    end
   
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
    MainFrame.Position = UDim2.new(0.5, -ORIGINAL_SIZE.X.Offset / 2, 0.5, -ORIGINAL_SIZE.Y.Offset / 2)
    MainFrame.Size = ORIGINAL_SIZE
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
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Name = "MinimizeButton"
    minimizeBtn.Parent = topBar
    minimizeBtn.BackgroundColor3 = Theme.Tertiary
    minimizeBtn.BorderSizePixel = 0
    minimizeBtn.Position = UDim2.new(1, -75, 0.5, -15)
    minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
    minimizeBtn.Font = Enum.Font.GothamBold
    minimizeBtn.Text = "_"
    minimizeBtn.TextColor3 = Theme.Text
    minimizeBtn.TextSize = 14
    minimizeBtn.AutoButtonColor = false
   
    local minimizeCorner = Instance.new("UICorner")
    minimizeCorner.CornerRadius = UDim.new(0, 8)
    minimizeCorner.Parent = minimizeBtn
   
    minimizeBtn.MouseButton1Click:Connect(function()
        local targetSize = isMinimized and ORIGINAL_SIZE or MINIMIZED_SIZE
        local oldHalfX = MainFrame.Size.X.Offset / 2
        local targetHalfX = targetSize.X.Offset / 2
        local deltaX = oldHalfX - targetHalfX
        local oldHalfY = MainFrame.Size.Y.Offset / 2
        local targetHalfY = targetSize.Y.Offset / 2
        local deltaY = oldHalfY - targetHalfY
        local currentPos = MainFrame.Position
        local newPos = UDim2.new(currentPos.X.Scale, currentPos.X.Offset + deltaX, currentPos.Y.Scale, currentPos.Y.Offset + deltaY)
        if not isMinimized then
            ContentFrame.Visible = false
            TabContainer.Visible = false
            local tween = CreateTween(MainFrame, {Size = MINIMIZED_SIZE, Position = newPos}, 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            minimizeBtn.Text = "⬜"
            isMinimized = true
            AnimateTitle(true)
        else
            local tween = CreateTween(MainFrame, {Size = ORIGINAL_SIZE, Position = newPos}, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
            tween.Completed:Connect(function()
                ContentFrame.Visible = true
                TabContainer.Visible = true
            end)
            minimizeBtn.Text = "_"
            isMinimized = false
            AnimateTitle(true)
        end
    end)
   
    minimizeBtn.MouseEnter:Connect(function()
        CreateTween(minimizeBtn, {BackgroundColor3 = Theme.PrimaryDark}, 0.2)
    end)
   
    minimizeBtn.MouseLeave:Connect(function()
        CreateTween(minimizeBtn, {BackgroundColor3 = Theme.Tertiary}, 0.2)
    end)
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
   
    closeBtn.MouseButton1Click:Connect(function()
        CreateTween(MainFrame, {Size = UDim2.new(0, 0

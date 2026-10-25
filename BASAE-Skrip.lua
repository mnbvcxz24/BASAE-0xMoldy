-- REUSABLE UI TEMPLATE
-- SERVICES
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local RuntimeEnv = type(getgenv) == "function" and getgenv() or _G
local PreviousRuntimeCleanup = RuntimeEnv.__BASAESkripCleanup
if type(PreviousRuntimeCleanup) == "function" then
    pcall(PreviousRuntimeCleanup)
end
local Runtime = {Stopped = false}
RuntimeEnv.__BASAESkripCleanup = function()
    Runtime.Stopped = true
    pcall(function()
        if type(Runtime.Shutdown) == "function" then
            Runtime.Shutdown()
        end
    end)
    pcall(function()
        for _, bindName in ipairs(Runtime.BoundRenderSteps or {}) do
            RunService:UnbindFromRenderStep(bindName)
        end
        table.clear(Runtime.BoundRenderSteps or {})
    end)
    pcall(function()
        for _, connection in ipairs(Runtime.PersistentConnections or {}) do
            if connection and connection.Connected then
                connection:Disconnect()
            end
        end
        table.clear(Runtime.PersistentConnections or {})
    end)
    pcall(function()
        local oldUI = game.CoreGui:FindFirstChild("BASAESkripUI")
        if oldUI then oldUI:Destroy() end
    end)
    pcall(function()
        local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
        local oldESP = playerGui and playerGui:FindFirstChild("BASE_Skrip_EggESP")
        if oldESP then oldESP:Destroy() end
    end)
end
local testver = "Test v1.137"
-- UI CONFIGURATION
local UIConfig = {
    Title = "BASAE-Skrip",
    Subtitle = testver,
    Width = 300,
    Height = 300,
    SidebarWidth = 94,
    SidebarNames = {
        "Auto",
        "ESP",
        "Placed Animals",
        "Animal Pickups",
        "Debug Console"
    }
}
-- THEME
local Theme = {
    Background = Color3.fromRGB(28, 30, 34),
    Sidebar = Color3.fromRGB(31, 34, 39),
    Card = Color3.fromRGB(36, 39, 45),
    Border = Color3.fromRGB(49, 53, 61),
    Text = Color3.fromRGB(218, 222, 228),
    DarkGray = Color3.fromRGB(178, 184, 193),
    Gray = Color3.fromRGB(139, 146, 156),
    LightGray = Color3.fromRGB(48, 53, 61),
    SurfaceInput = Color3.fromRGB(39, 43, 50),
    Selected = Color3.fromRGB(67, 78, 88),
    SelectedText = Color3.fromRGB(231, 235, 240),
    Accent = Color3.fromRGB(126, 151, 157),
    AccentText = Color3.fromRGB(27, 32, 35)
}
-- HELPER FUNCTIONS
local function Create(className, properties)
    local object = Instance.new(className)
    for property, value in pairs(properties or {}) do
        object[property] = value
    end
    return object
end
local function AddCorner(object, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = object
    return corner
end
local function AddStroke(object, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Theme.Border
    stroke.Thickness = thickness or 1
    stroke.Parent = object
    return stroke
end
local function Tween(object, properties, duration)
    TweenService:Create(
        object,
        TweenInfo.new(
            duration or 0.2,
            Enum.EasingStyle.Quad,
            Enum.EasingDirection.Out
        ),
        properties
    ):Play()
end
-- REMOVE ANY LEFTOVER UI FROM A PREVIOUS RUN
pcall(function()
    local oldUI = game.CoreGui:FindFirstChild("BASAESkripUI")
    if oldUI then oldUI:Destroy() end
end)
pcall(function()
    local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    local oldESP = playerGui and playerGui:FindFirstChild("BASE_Skrip_EggESP")
    if oldESP then oldESP:Destroy() end
end)
-- SCREEN GUI
local ScreenGui = Create("ScreenGui", {
    Name = "BASAESkripUI",
    Parent = game.CoreGui,
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
})
-- MAIN WINDOW
local Main = Create("Frame", {
    Name = "Main",
    Parent = ScreenGui,
    Size = UDim2.fromOffset(
        UIConfig.Width,
        UIConfig.Height
    ),
    Position = UDim2.new(
        0.5,
        -UIConfig.Width / 2,
        0.5,
        -UIConfig.Height / 2
    ),
    BackgroundColor3 = Theme.Background,
    BorderSizePixel = 0,
    ClipsDescendants = true
})
local MainCorner = AddCorner(Main, 12)
AddStroke(Main, Theme.Border, 1)
-- TOP BAR
local TopBar = Create("Frame", {
    Name = "TopBar",
    Parent = Main,
    Size = UDim2.new(1, 0, 0, 48),
    BackgroundColor3 = Theme.Background,
    BorderSizePixel = 0
})
AddCorner(TopBar, 12)
Create("Frame", {
    Name = "TopBarCornerCover",
    Parent = TopBar,
    Position = UDim2.fromOffset(0, 12),
    Size = UDim2.new(1, 0, 1, -12),
    BackgroundColor3 = Theme.Background,
    BorderSizePixel = 0,
    ZIndex = 0
})
-- Title
local Title = Create("TextLabel", {
    Name = "Title",
    Parent = TopBar,
    Position = UDim2.fromOffset(10, 7),
    Size = UDim2.fromOffset(105, 20),
    BackgroundTransparency = 1,
    Text = UIConfig.Title,
    TextColor3 = Theme.Text,
    Font = Enum.Font.GothamBold,
    TextSize = 12,
    TextXAlignment = Enum.TextXAlignment.Left
})
-- Subtitle
local Subtitle = Create("TextLabel", {
    Name = "Subtitle",
    Parent = TopBar,
    Position = UDim2.fromOffset(10, 29),
    Size = UDim2.fromOffset(130, 16),
    BackgroundTransparency = 1,
    Text = UIConfig.Subtitle,
    TextColor3 = Theme.Gray,
    Font = Enum.Font.Gotham,
    TextSize = 8,
    TextXAlignment = Enum.TextXAlignment.Left
})
-- Search
local SearchBox = Create("TextBox", {
    Name = "Search",
    Parent = TopBar,
    Position = UDim2.fromOffset(10, 36),
    Size = UDim2.fromOffset(80, 18),
    BackgroundColor3 = Theme.SurfaceInput,
    PlaceholderText = "Search...",
    PlaceholderColor3 = Theme.Gray,
    Visible = false,
    Text = "",
    TextColor3 = Theme.Text,
    Font = Enum.Font.Gotham,
    TextSize = 10,
    ClearTextOnFocus = false,
    BorderSizePixel = 0
})
AddCorner(SearchBox, 8)
AddStroke(SearchBox, Theme.Border, 1)
-- Minimize
local MinimizeButton = Create("TextButton", {
    Name = "Minimize",
    Parent = TopBar,
    Position = UDim2.new(1, -52, 0, 16),
    Size = UDim2.fromOffset(22, 26),
    BackgroundColor3 = Theme.SurfaceInput,
    Text = "-",
    TextColor3 = Theme.Text,
    Font = Enum.Font.GothamBold,
    TextSize = 13,
    BorderSizePixel = 0
})
AddCorner(MinimizeButton, 8)
AddStroke(MinimizeButton, Theme.Border, 1)
-- Close
local CloseButton = Create("TextButton", {
    Name = "Close",
    Parent = TopBar,
    Position = UDim2.new(1, -27, 0, 16),
    Size = UDim2.fromOffset(22, 26),
    BackgroundColor3 = Theme.SurfaceInput,
    Text = "×",
    TextColor3 = Theme.Text,
    Font = Enum.Font.GothamBold,
    TextSize = 15,
    BorderSizePixel = 0
})
AddCorner(CloseButton, 8)
AddStroke(CloseButton, Theme.Border, 1)
local RestoreButton = Create("TextButton", {
    Name = "Restore",
    Parent = Main,
    Position = UDim2.fromOffset(0, 0),
    Size = UDim2.fromOffset(36, 36),
    BackgroundColor3 = Theme.Sidebar,
    Text = "B",
    TextColor3 = Theme.Text,
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    BorderSizePixel = 0,
    Visible = false,
    ZIndex = 5
})
AddCorner(RestoreButton, 18)
AddStroke(RestoreButton, Theme.Border, 1)
-- SIDEBAR
local Sidebar = Create("Frame", {
    Name = "Sidebar",
    Parent = Main,
    Position = UDim2.fromOffset(0, 48),
    Size = UDim2.new(
        0,
        UIConfig.SidebarWidth,
        1,
        -48
    ),
    BackgroundColor3 = Theme.Sidebar,
    BorderSizePixel = 0
})
AddCorner(Sidebar, 12)
-- Sidebar title
local NavigationTitle = Create("TextLabel", {
    Name = "NavigationTitle",
    Parent = Sidebar,
    Position = UDim2.fromOffset(8, 12),
    Size = UDim2.new(1, -16, 0, 20),
    BackgroundTransparency = 1,
    Text = "NAVIGATION",
    TextColor3 = Theme.Gray,
    Font = Enum.Font.GothamBold,
    TextSize = 9,
    TextXAlignment = Enum.TextXAlignment.Left
})
-- Sidebar container
local SidebarContainer = Create("ScrollingFrame", {
    Name = "Buttons",
    Parent = Sidebar,
    Position = UDim2.fromOffset(5, 40),
    Size = UDim2.new(1, -10, 1, -60),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 3,
    ScrollBarImageColor3 = Theme.Gray,
    ScrollingDirection = Enum.ScrollingDirection.Y,
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    ClipsDescendants = true
})
Create("UIListLayout", {
    Parent = SidebarContainer,
    Padding = UDim.new(0, 6),
    SortOrder = Enum.SortOrder.LayoutOrder
})
-- CONTENT AREA
local Content = Create("Frame", {
    Name = "Content",
    Parent = Main,
    Position = UDim2.fromOffset(
        UIConfig.SidebarWidth,
        48
    ),
    Size = UDim2.new(
        1,
        -UIConfig.SidebarWidth - 12,
        1,
        -60
    ),
    BackgroundColor3 = Theme.Background,
    BorderSizePixel = 0
})
-- PAGE SYSTEM
local Pages = {}
local SidebarButtons = {}
local CurrentPage = 1
-- DEBUG CONSOLE
local DebugConsoleList
local DebugConsoleLayout
local DebugLogCount = 0
local MaxDebugLogs = 100
local function AddDebugLog(message)
    local timestamp = os.date("%H:%M:%S")
    local lineText = "[" .. timestamp .. "] " .. tostring(message)
    if not DebugConsoleList or not DebugConsoleLayout then
        return
    end
    DebugLogCount += 1
    Create("TextLabel", {
        Name = "Log_" .. DebugLogCount,
        Parent = DebugConsoleList,
        Size = UDim2.new(1, -8, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Text = lineText,
        TextColor3 = Theme.Text,
        Font = Enum.Font.Code,
        TextSize = 9,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        LayoutOrder = DebugLogCount
    })
    local logs = {}
    for _, child in ipairs(DebugConsoleList:GetChildren()) do
        if child:IsA("TextLabel") then
            table.insert(logs, child)
        end
    end
    while #logs > MaxDebugLogs do
        logs[1]:Destroy()
        table.remove(logs, 1)
    end
    task.defer(function()
        if DebugConsoleList and DebugConsoleLayout then
            DebugConsoleList.CanvasSize = UDim2.new(0, 0, 0, DebugConsoleLayout.AbsoluteContentSize.Y + 8)
            DebugConsoleList.CanvasPosition = Vector2.new(0, math.max(0, DebugConsoleLayout.AbsoluteContentSize.Y - DebugConsoleList.AbsoluteSize.Y))
        end
    end)
end
-- CREATE PAGE
local function CreatePage(pageNumber, pageName)
    local PageClip = Create("Frame", {
        Name = "PageClip_" .. pageNumber,
        Parent = Content,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Visible = false
    })
    AddCorner(PageClip, 10)
    local function AddCornerMask(name, position, anchorPoint)
        local mask = Create("Frame", {
            Name = name,
            Parent = PageClip,
            AnchorPoint = anchorPoint,
            Position = position,
            Size = UDim2.fromOffset(10, 10),
            BackgroundColor3 = Theme.Background,
            BorderSizePixel = 0,
            ZIndex = 50
        })
        AddCorner(mask, 10)
    end
    AddCornerMask("TopLeftCornerMask", UDim2.fromOffset(0, 0), Vector2.new(0, 0))
    AddCornerMask("TopRightCornerMask", UDim2.new(1, 0, 0, 0), Vector2.new(1, 0))
    AddCornerMask("BottomLeftCornerMask", UDim2.new(0, 0, 1, 0), Vector2.new(0, 1))
    AddCornerMask("BottomRightCornerMask", UDim2.new(1, 0, 1, 0), Vector2.new(1, 1))
    local Page = Create("ScrollingFrame", {
        Name = "Page_" .. pageNumber,
        Parent = PageClip,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Theme.Gray,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Visible = true,
        ClipsDescendants = true
    })
    local Padding = Create("UIPadding", {
        Parent = Page,
        PaddingTop = UDim.new(0, 12),
        PaddingBottom = UDim.new(0, 12),
        PaddingLeft = UDim.new(0, 12),
        PaddingRight = UDim.new(0, 12)
    })
    local Layout = Create("UIListLayout", {
        Parent = Page,
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Page.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 24)
    end)
    Pages[pageNumber] = PageClip
    return Page
end
-- CARD
local function CreateCard(parent, title, description)
    local Card = Create("Frame", {
        Name = title:gsub("%s+", ""),
        Parent = parent,
        Size = UDim2.new(1, 0, 0, 110),
        BackgroundColor3 = Theme.Card,
        BorderSizePixel = 0
    })
    AddCorner(Card, 8)
    AddStroke(Card, Theme.Border, 1)
    Create("TextLabel", {
        Parent = Card,
        Position = UDim2.fromOffset(11, 8),
        Size = UDim2.new(1, -22, 0, 18),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Theme.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    Create("TextLabel", {
        Parent = Card,
        Position = UDim2.fromOffset(11, 29),
        Size = UDim2.new(1, -22, 0, 30),
        BackgroundTransparency = 1,
        Text = description or "",
        Visible = description ~= nil and description ~= "",
        TextColor3 = Theme.Gray,
        Font = Enum.Font.Gotham,
        TextSize = 9,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top
    })
    return Card
end
-- BUTTON
local function CreateButton(parent, text, callback)
    local Button = Create("TextButton", {
        Parent = parent,
        Size = UDim2.new(1, -30, 0, 28),
        Position = UDim2.fromOffset(15, 68),
        BackgroundColor3 = Theme.Selected,
        Text = text,
        TextColor3 = Theme.SelectedText,
        Font = Enum.Font.GothamMedium,
        TextSize = 9,
        BorderSizePixel = 0,
        AutoButtonColor = false
    })
    AddCorner(Button, 6)
    Button.MouseEnter:Connect(function()
        Tween(Button, {
            BackgroundColor3 = Theme.Selected
        })
    end)
    Button.MouseLeave:Connect(function()
        Tween(Button, {
            BackgroundColor3 = Theme.Selected
        })
    end)
    Button.MouseButton1Click:Connect(function()
        if callback then
            callback()
        end
    end)
    return Button
end
-- TOGGLE
local ToggleControllers = setmetatable({}, {__mode = "k"})
local function CreateToggle(parent, text, default, callback)
    local Toggle = Create("TextButton", {
        Parent = parent,
        Size = UDim2.new(1, -30, 0, 28),
        Position = UDim2.fromOffset(15, 68),
        BackgroundTransparency = 1,
        Text = "",
        BorderSizePixel = 0
    })
    local Label = Create("TextLabel", {
        Parent = Toggle,
        Size = UDim2.new(1, -55, 1, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Theme.Text,
        Font = Enum.Font.Gotham,
        TextSize = 9,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    local Switch = Create("Frame", {
        Parent = Toggle,
        Position = UDim2.new(1, -45, 0.5, -9),
        Size = UDim2.fromOffset(38, 18),
        BackgroundColor3 = Theme.LightGray,
        BorderSizePixel = 0
    })
    AddCorner(Switch, 20)
    local Circle = Create("Frame", {
        Parent = Switch,
        Position = UDim2.fromOffset(2, 2),
        Size = UDim2.fromOffset(14, 14),
        BackgroundColor3 = Theme.SurfaceInput,
        BorderSizePixel = 0
    })
    AddCorner(Circle, 20)
    local Enabled = default == true
    local function Update(runCallback)
        if Enabled then
            Tween(Switch, {
                BackgroundColor3 = Theme.Selected
            })
            Tween(Circle, {
                Position = UDim2.new(1, -16, 0, 2)
            })
        else
            Tween(Switch, {
                BackgroundColor3 = Theme.LightGray
            })
            Tween(Circle, {
                Position = UDim2.fromOffset(2, 2)
            })
        end
        if runCallback ~= false and callback then
            callback(Enabled)
        end
    end
    ToggleControllers[Toggle] = {
        SetEnabled = function(value, runCallback)
            Enabled = value == true
            Update(runCallback)
        end,
        GetEnabled = function()
            return Enabled
        end
    }
    Toggle.MouseButton1Click:Connect(function()
        Enabled = not Enabled
        Update(true)
    end)
    Update(true)
    return Toggle
end
-- DROPDOWN
local function CreateDropdown(parent, text, options, callback)
    local Dropdown = Create("TextButton", {
        Parent = parent,
        Size = UDim2.new(1, -30, 0, 28),
        Position = UDim2.fromOffset(15, 68),
        BackgroundColor3 = Theme.SurfaceInput,
        Text = "",
        BorderSizePixel = 0,
        AutoButtonColor = false
    })
    AddCorner(Dropdown, 6)
    AddStroke(Dropdown, Theme.Border, 1)
    local Current = Create("TextLabel", {
        Parent = Dropdown,
        Position = UDim2.fromOffset(12, 0),
        Size = UDim2.new(1, -35, 1, 0),
        BackgroundTransparency = 1,
        Text = text .. ": " .. tostring(options[1]),
        TextColor3 = Theme.Text,
        Font = Enum.Font.Gotham,
        TextSize = 9,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    Create("TextLabel", {
        Parent = Dropdown,
        Position = UDim2.new(1, -25, 0, 0),
        Size = UDim2.fromOffset(20, 28),
        BackgroundTransparency = 1,
        Text = "v",
        TextColor3 = Theme.Gray,
        Font = Enum.Font.GothamBold,
        TextSize = 9
    })
    local Open = false
    local List = Create("Frame", {
        Parent = Dropdown,
        Position = UDim2.new(0, 0, 1, 5),
        Size = UDim2.new(1, 0, 0, #options * 26),
        BackgroundColor3 = Theme.SurfaceInput,
        BorderSizePixel = 0,
        Visible = false,
        ZIndex = 20
    })
    AddCorner(List, 6)
    AddStroke(List, Theme.Border, 1)
    local Layout = Create("UIListLayout", {
        Parent = List,
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    for _, option in ipairs(options) do
        local Option = Create("TextButton", {
            Parent = List,
            Size = UDim2.new(1, 0, 0, 26),
            BackgroundTransparency = 1,
            Text = tostring(option),
            TextColor3 = Theme.Text,
            Font = Enum.Font.Gotham,
            TextSize = 9,
            BorderSizePixel = 0,
            ZIndex = 21
        })
        Option.MouseButton1Click:Connect(function()
            Current.Text = text .. ": " .. tostring(option)
            List.Visible = false
            Open = false
            if callback then
                callback(option)
            end
        end)
    end
    Dropdown.MouseButton1Click:Connect(function()
        Open = not Open
        List.Visible = Open
    end)
    return Dropdown
end
-- SLIDER
local function CreateSlider(parent, text, minimum, maximum, default, callback)
    local Holder = Create("Frame", {
        Parent = parent,
        Size = UDim2.new(1, -30, 0, 55),
        Position = UDim2.fromOffset(15, 68),
        BackgroundTransparency = 1
    })
    local Label = Create("TextLabel", {
        Parent = Holder,
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Theme.Text,
        Font = Enum.Font.Gotham,
        TextSize = 9,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    local Value = Create("TextLabel", {
        Parent = Holder,
        Position = UDim2.new(1, -50, 0, 0),
        Size = UDim2.fromOffset(50, 20),
        BackgroundTransparency = 1,
        Text = tostring(default),
        TextColor3 = Theme.Gray,
        Font = Enum.Font.Gotham,
        TextSize = 9,
        TextXAlignment = Enum.TextXAlignment.Right
    })
    local Bar = Create("Frame", {
        Parent = Holder,
        Position = UDim2.fromOffset(0, 28),
        Size = UDim2.new(1, 0, 0, 5),
        BackgroundColor3 = Theme.LightGray,
        BorderSizePixel = 0
    })
    AddCorner(Bar, 10)
    local Fill = Create("Frame", {
        Parent = Bar,
        Size = UDim2.new(
            (default - minimum) / (maximum - minimum),
            0,
            1,
            0
        ),
        BackgroundColor3 = Theme.Selected,
        BorderSizePixel = 0
    })
    AddCorner(Fill, 10)
    local Dragging = false
    local function Update(input)
        local Position = math.clamp(
            (input.Position.X - Bar.AbsolutePosition.X)
                / Bar.AbsoluteSize.X,
            0,
            1
        )
        local Number = math.floor(
            minimum + ((maximum - minimum) * Position)
        )
        Fill.Size = UDim2.new(Position, 0, 1, 0)
        Value.Text = tostring(Number)
        if callback then
            callback(Number)
        end
    end
    Bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            Update(input)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if Dragging then
            if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then
                Update(input)
            end
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = false
        end
    end)
    return Holder
end
-- CREATE SIDEBAR BUTTONS
for index, name in ipairs(UIConfig.SidebarNames) do
    local Button = Create("TextButton", {
        Name = "SidebarButton_" .. index,
        Parent = SidebarContainer,
        Size = UDim2.new(1, -2, 0, 34),
        BackgroundColor3 = Theme.Sidebar,
        Text = name,
        TextColor3 = Theme.DarkGray,
        Font = Enum.Font.GothamMedium,
        TextSize = 9,
        TextXAlignment = Enum.TextXAlignment.Left,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        LayoutOrder = index
    })
    AddCorner(Button, 7)
    local Padding = Create("UIPadding", {
        Parent = Button,
        PaddingLeft = UDim.new(0, 14)
    })
    SidebarButtons[index] = Button
    Button.MouseButton1Click:Connect(function()
        for pageIndex, page in pairs(Pages) do
            page.Visible = pageIndex == index
        end
        for buttonIndex, sidebarButton in pairs(SidebarButtons) do
            if buttonIndex == index then
                sidebarButton.BackgroundColor3 = Theme.Selected
                sidebarButton.TextColor3 = Theme.SelectedText
            else
                sidebarButton.BackgroundColor3 = Theme.Sidebar
                sidebarButton.TextColor3 = Theme.DarkGray
            end
        end
        CurrentPage = index
    end)
end
local ShutdownAutomation
-- CREATE ALL PAGES
for index, name in ipairs(UIConfig.SidebarNames) do
    local Page = CreatePage(index, name)
    if index == 1 then
        local Card1 = CreateCard(Page, "Auto break", "")
        Card1.Size = UDim2.new(1, 0, 0, 114)
        local StartAutoBreak
        local StopAutoBreak
        local StopPickupAutomation
        local DisableAutoBreakOptions
        local CompletedEggs = {}
        local AutoBreakToggleInitialized = false
        local AutoBreakEnabled = false
        local RefreshTitanicPriority
        local AutoBreakToggle = CreateToggle(Card1, "", false, function(enabled)
            AutoBreakEnabled = enabled
            if not AutoBreakToggleInitialized then
                AutoBreakToggleInitialized = true
                return
            end
            AddDebugLog("[Auto Break] Toggle " .. (enabled and "ON" or "OFF"))
            if enabled then
                if StartAutoBreak then StartAutoBreak() end
            else
                if DisableAutoBreakOptions then DisableAutoBreakOptions() end
                if StopAutoBreak then StopAutoBreak("Toggle disabled") end
            end
        end)
        AutoBreakToggle.Position = UDim2.new(1, -68, 0, 10)
        AutoBreakToggle.Size = UDim2.fromOffset(58, 26)
        local AutoPickupCard = CreateCard(Page, "Auto pickup", "")
        AutoPickupCard.Size = UDim2.new(1, 0, 0, 170)
        local AutoPickupEnabled = false
        local AutoPickupToggle = CreateToggle(AutoPickupCard, "", false, function(enabled)
            AutoPickupEnabled = enabled
            AddDebugLog("[Auto Pickup] " .. (enabled and "Monitoring ON." or "Monitoring OFF."))
            if not enabled and StopPickupAutomation then StopPickupAutomation("Auto Pickup disabled") end
        end)
        AutoPickupToggle.Position = UDim2.new(1, -68, 0, 10)
        AutoPickupToggle.Size = UDim2.fromOffset(58, 26)
        local RarityFilterOpen = false
        local RarityOptions = {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "Cosmic", "Secret", "Eternal", "Divine", "Celestial", "Inferno", "Void", "Omega"}
        local SelectedRarities = {}
        for _, rarityName in ipairs(RarityOptions) do
            SelectedRarities[rarityName] = true
        end
        local RarityList
        local RarityFilterButton
        RarityFilterButton = CreateButton(AutoPickupCard, "Filter for Rarity  ▼", function()
            RarityFilterOpen = not RarityFilterOpen
            AutoPickupCard.Size = UDim2.new(1, 0, 0, RarityFilterOpen and 300 or 170)
            RarityFilterButton.Text = RarityFilterOpen and "Filter for Rarity  ▲" or "Filter for Rarity  ▼"
            RarityList.Visible = RarityFilterOpen
        end)
        RarityFilterButton.Position = UDim2.fromOffset(11, 43)
        RarityFilterButton.Size = UDim2.new(1, -22, 0, 26)
        local HighestCashEnabled = false
        local HighestCashToggle = CreateToggle(AutoPickupCard, "Above Lowest CPS", false, function(enabled)
            HighestCashEnabled = enabled
            AddDebugLog("[Auto Pickup] " .. (enabled and "Lowest placed CPS filter ON." or "Lowest placed CPS filter OFF."))
        end)
        HighestCashToggle.Position = UDim2.fromOffset(11, 73)
        HighestCashToggle.Size = UDim2.new(1, -22, 0, 26)
        local UnindexedOnlyEnabled = false
        local UnindexedOnlyToggle = CreateToggle(AutoPickupCard, "Unindexed Animals", false, function(enabled)
            UnindexedOnlyEnabled = enabled
            AddDebugLog("[Auto Pickup] " .. (enabled and "Unindexed-only verification ON." or "Unindexed-only verification OFF."))
        end)
        UnindexedOnlyToggle.Position = UDim2.fromOffset(11, 101)
        UnindexedOnlyToggle.Size = UDim2.new(1, -22, 0, 26)
        RarityList = Create("ScrollingFrame", {
            Name = "RarityFilterContainer",
            Parent = AutoPickupCard,
            Position = UDim2.fromOffset(11, 132),
            Size = UDim2.new(1, -22, 0, 155),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Theme.Gray,
            BackgroundColor3 = Theme.SurfaceInput,
            BorderSizePixel = 0,
            Visible = false
        })
        AddCorner(RarityList, 6)
        local RarityLayout = Create("UIListLayout", {
            Parent = RarityList,
            Padding = UDim.new(0, 3),
            SortOrder = Enum.SortOrder.LayoutOrder
        })
        Create("UIPadding", {
            Parent = RarityList,
            PaddingTop = UDim.new(0, 5),
            PaddingBottom = UDim.new(0, 5),
            PaddingLeft = UDim.new(0, 5),
            PaddingRight = UDim.new(0, 5)
        })
        RarityLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            RarityList.CanvasSize = UDim2.new(0, 0, 0, RarityLayout.AbsoluteContentSize.Y + 10)
        end)
        for rarityIndex, rarityName in ipairs(RarityOptions) do
            local RarityButton = Create("TextButton", {
                Name = "Rarity_" .. rarityName,
                Parent = RarityList,
                Size = UDim2.new(1, -4, 0, 19),
                BackgroundColor3 = Theme.Card,
                Text = "",
                BorderSizePixel = 0,
                LayoutOrder = rarityIndex,
                AutoButtonColor = false
            })
            AddCorner(RarityButton, 4)
            Create("TextLabel", {
                Parent = RarityButton,
                Position = UDim2.fromOffset(7, 0),
                Size = UDim2.new(1, -28, 1, 0),
                BackgroundTransparency = 1,
                Text = rarityName,
                TextColor3 = Theme.Text,
                Font = Enum.Font.Gotham,
                TextSize = 9,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            local RarityCheck = Create("TextLabel", {
                Parent = RarityButton,
                Position = UDim2.new(1, -23, 0, 0),
                Size = UDim2.fromOffset(20, 19),
                BackgroundTransparency = 1,
                Text = SelectedRarities[rarityName] and "✓" or "○",
                TextColor3 = SelectedRarities[rarityName] and Color3.fromRGB(110, 205, 145) or Theme.Gray,
                Font = Enum.Font.GothamBold,
                TextSize = 11
            })
            if SelectedRarities[rarityName] then
                RarityButton.BackgroundColor3 = Theme.Selected
            end
            RarityButton.MouseButton1Click:Connect(function()
                SelectedRarities[rarityName] = not SelectedRarities[rarityName] or nil
                local selected = SelectedRarities[rarityName] == true
                RarityCheck.Text = selected and "✓" or "○"
                RarityCheck.TextColor3 = selected and Color3.fromRGB(110, 205, 145) or Theme.Gray
                RarityButton.BackgroundColor3 = selected and Theme.Selected or Theme.Card
            end)
        end
        local SelectedZones = {}
        local SelectedEggs = {}
        local PreferredZoneName = nil
        local ZoneFilterOpen = false
        local EggFilterOpen = false
        local SortOrder = "Largest"
        local ZoneList
        local EggFilterList
        local SortFrame
        local ZoneFilterButton
        local EggFilterButton
        local SortLargestButton
        local SortSmallestButton
        local ZoneBuilds = workspace:WaitForChild("Build"):WaitForChild("ZoneBuilds")
        local function UpdateFilterPanel()
            ZoneList.Visible = ZoneFilterOpen
            EggFilterList.Visible = EggFilterOpen
            SortFrame.Visible = true
            Card1.Size = UDim2.new(1, 0, 0, (EggFilterOpen or ZoneFilterOpen) and 270 or 158)
            SortFrame.Position = UDim2.fromOffset(15, 78)
            SortFrame.Size = UDim2.new(1, -30, 0, 28)
            ZoneFilterButton.Text = ZoneFilterOpen and "Zones ▲" or "Zones ▼"
            EggFilterButton.Text = EggFilterOpen and "Eggs ▲" or "Eggs ▼"
        end
        ZoneFilterButton = CreateButton(Card1, "Zones ▼", function()
            ZoneFilterOpen = not ZoneFilterOpen
            EggFilterOpen = false
            UpdateFilterPanel()
        end)
        ZoneFilterButton.Position = UDim2.fromOffset(15, 44)
        ZoneFilterButton.Size = UDim2.new(0.5, -20, 0, 26)
        EggFilterButton = CreateButton(Card1, "Eggs ▼", function()
            EggFilterOpen = not EggFilterOpen
            ZoneFilterOpen = false
            UpdateFilterPanel()
        end)
        EggFilterButton.Position = UDim2.new(0.5, 5, 0, 44)
        EggFilterButton.Size = UDim2.new(0.5, -20, 0, 26)
        ZoneList = Create("ScrollingFrame", {
            Name = "ZoneFilterList",
            Parent = Card1,
            Position = UDim2.fromOffset(15, 112),
            Size = UDim2.new(1, -30, 0, 102),
            BackgroundColor3 = Theme.SurfaceInput,
            BorderSizePixel = 0,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Theme.Gray,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Visible = false
        })
        AddCorner(ZoneList, 6)
        local ZoneLayout = Create("UIListLayout", {
            Parent = ZoneList,
            Padding = UDim.new(0, 4),
            SortOrder = Enum.SortOrder.LayoutOrder
        })
        Create("UIPadding", {
            Parent = ZoneList,
            PaddingTop = UDim.new(0, 4),
            PaddingBottom = UDim.new(0, 4),
            PaddingLeft = UDim.new(0, 4),
            PaddingRight = UDim.new(0, 4)
        })
        EggFilterList = Create("ScrollingFrame", {
            Name = "EggFilterList",
            Parent = Card1,
            Position = UDim2.fromOffset(15, 112),
            Size = UDim2.new(1, -30, 0, 102),
            BackgroundColor3 = Theme.SurfaceInput,
            BorderSizePixel = 0,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Theme.Gray,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Visible = false
        })
        AddCorner(EggFilterList, 6)
        local EggLayout = Create("UIListLayout", {
            Parent = EggFilterList,
            Padding = UDim.new(0, 4),
            SortOrder = Enum.SortOrder.LayoutOrder
        })
        Create("UIPadding", {
            Parent = EggFilterList,
            PaddingTop = UDim.new(0, 4),
            PaddingBottom = UDim.new(0, 4),
            PaddingLeft = UDim.new(0, 4),
            PaddingRight = UDim.new(0, 4)
        })
        SortFrame = Create("Frame", {
            Name = "EggSortOptions",
            Parent = Card1,
            Position = UDim2.fromOffset(15, 78),
            Size = UDim2.new(1, -30, 0, 28),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Visible = true
        })
        local HighestLuckToggle
        local function UpdateSortButtons()
            SortOrder = HighestLuckToggle and ToggleControllers[HighestLuckToggle].GetEnabled() and "Highest Luck" or "Default"
        end
        HighestLuckToggle = CreateToggle(SortFrame, "HighLuck Priority", false, function(enabled)
            SortOrder = enabled and "Highest Luck" or "Default"
            if RefreshEggList then RefreshEggList() end
            AddDebugLog("[Auto Break] Highest Luck first " .. (enabled and "ON" or "OFF"))
        end)
        HighestLuckToggle.Position = UDim2.fromOffset(0, 0)
        HighestLuckToggle.Size = UDim2.new(1, 0, 0, 28)
        SortLargestButton = HighestLuckToggle
        SortSmallestButton = nil
        local function GetEggTypeName(name)
            return (name:gsub("^%d+:%s*", ""))
        end
        local function GetEggDataValue(egg, variableName)
            local eggModel = egg and (egg:FindFirstChild("Egg") or egg)
            if not eggModel then return nil end
            local function readFrom(object)
                local attribute = object:GetAttribute(variableName)
                if attribute ~= nil then return tostring(attribute) end
                if object.Name == variableName then
                    if object:IsA("ValueBase") then return tostring(object.Value) end
                    if object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox") then
                        if object.Text ~= "" then return object.Text end
                    end
                end
                return nil
            end
            local value = readFrom(eggModel)
            if value ~= nil then return value end
            for _, node in ipairs(eggModel:GetDescendants()) do
                value = readFrom(node)
                if value ~= nil then return value end
            end
            return nil
        end
        local function GetEggWeightBracket(egg)
            return GetEggDataValue(egg, "WeightBracket")
        end
        local function GetEggWeightKg(egg)
            local raw = GetEggDataValue(egg, "weightKg")
                or GetEggDataValue(egg, "WeightKg")
                or GetEggDataValue(egg, "WeightKG")
                or GetEggDataValue(egg, "weightKG")
            if not raw then return nil end
            local value = tonumber(tostring(raw):lower():gsub(",", ""):match("[%d%.]+"))
            return value
        end
        local function IsEggAvailable(egg)
            if not egg or not egg.Parent or CompletedEggs[egg] then return false end
            local eggsFolder = egg.Parent
            if eggsFolder.Name ~= "Eggs" then return false end
            local zone = eggsFolder.Parent
            if not zone or zone.Parent ~= ZoneBuilds then return false end
            if not (egg:IsA("Model") or egg:IsA("BasePart")) then return false end
            if not egg.Name:lower():find("egg", 1, true) then return false end
            for _, healthName in ipairs({"Health", "CurrentHealth", "EggHealth", "HP"}) do
                local rawHealth = GetEggDataValue(egg, healthName)
                local health = tonumber(rawHealth)
                if health and health <= 0 then
                    return false
                end
            end
            return true
        end

        local function GetEggLuck(egg)
            local eggModel = egg and (egg:FindFirstChild("Egg") or egg)
            if not eggModel then return 0 end
            local info = eggModel:FindFirstChild("EggInfoUi", true)
            local luckLabel = info and info:FindFirstChild("LuckMultiList", true)
            luckLabel = luckLabel and luckLabel:FindFirstChild("LuckMulti", true)
            local rawLuck
            if luckLabel then
                rawLuck = (luckLabel:IsA("TextLabel") or luckLabel:IsA("TextButton")) and luckLabel.Text or nil
                rawLuck = rawLuck or luckLabel:GetAttribute("LuckMulti")
            end
            rawLuck = rawLuck or GetEggDataValue(egg, "LuckMulti")
                or GetEggDataValue(egg, "LuckMultiplier")
                or GetEggDataValue(egg, "Luck")
            if rawLuck == nil or tostring(rawLuck):match("%S") == nil then return 0 end
            local text = tostring(rawLuck):lower():gsub(",", ""):gsub("%s+", "")
            local explicitMultiplier = text:match("[x×]([%d%.]+)") or text:match("([%d%.]+)[x×]")
            if explicitMultiplier then
                return tonumber(explicitMultiplier) or 0
            end
            local ratioDenominator = text:match("^%d+/(%d+%.?%d*)$")
            if ratioDenominator then
                return tonumber(ratioDenominator) or 0
            end
            local lastNumber
            for numberText in text:gmatch("%d+%.?%d*") do
                lastNumber = numberText
            end
            return tonumber(lastNumber) or 0
        end
        local function GetEggRecords()
            local records = {}
            local byName = {}
            for zoneName, selected in pairs(SelectedZones) do
                if selected then
                    local zone = ZoneBuilds:FindFirstChild(zoneName)
                    local eggsFolder = zone and zone:FindFirstChild("Eggs")
                    if eggsFolder then
                        for _, egg in ipairs(eggsFolder:GetChildren()) do
                            if (egg:IsA("Model") or egg:IsA("BasePart"))
                            and egg.Name:lower():find("egg", 1, true) then
                                local eggName = GetEggTypeName(egg.Name)
                                local luck = GetEggLuck(egg)
                                if not byName[eggName] then
                                    byName[eggName] = {name = eggName, luck = luck}
                                    table.insert(records, byName[eggName])
                                elseif luck > byName[eggName].luck then
                                    byName[eggName].luck = luck
                                end
                            end
                        end
                    end
                end
            end
            table.sort(records, function(a, b)
                if SortOrder == "Highest Luck" and a.luck ~= b.luck then
                    return a.luck > b.luck
                end
                return a.name < b.name
            end)
            return records
        end
        local RefreshEggList
        local function RefreshZoneList()
            for _, item in ipairs(ZoneList:GetChildren()) do
                if item:IsA("TextButton") then item:Destroy() end
            end
            local zones = {}
            for _, zone in ipairs(ZoneBuilds:GetChildren()) do
                if zone:IsA("Model") then table.insert(zones, zone) end
            end
            table.sort(zones, function(a, b) return a.Name < b.Name end)
            for zoneIndex, zone in ipairs(zones) do
                local zoneName = zone.Name
                local selected = SelectedZones[zoneName] == true
                local ZoneButton = Create("TextButton", {
                    Name = "Zone_" .. zoneName,
                    Parent = ZoneList,
                    Size = UDim2.new(1, -8, 0, 24),
                    BackgroundColor3 = selected and Theme.Selected or Theme.Card,
                    Text = "",
                    BorderSizePixel = 0,
                    LayoutOrder = zoneIndex,
                    AutoButtonColor = false
                })
                AddCorner(ZoneButton, 5)
                Create("TextLabel", {
                    Parent = ZoneButton,
                    Position = UDim2.fromOffset(8, 0),
                    Size = UDim2.new(1, -34, 1, 0),
                    BackgroundTransparency = 1,
                    Text = zoneName,
                    TextColor3 = Theme.Text,
                    Font = Enum.Font.Gotham,
                    TextSize = 9,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                local Checkmark = Create("TextLabel", {
                    Parent = ZoneButton,
                    Position = UDim2.new(1, -26, 0, 0),
                    Size = UDim2.fromOffset(22, 24),
                    BackgroundTransparency = 1,
                    Text = selected and "✓" or "○",
                    TextColor3 = selected and Color3.fromRGB(110, 205, 145) or Theme.Gray,
                    Font = Enum.Font.GothamBold,
                    TextSize = 12
                })
                ZoneButton.MouseButton1Click:Connect(function()
                    SelectedZones[zoneName] = not SelectedZones[zoneName] or nil
                    RefreshZoneList()
                    RefreshEggList()
                end)
            end
        end
        RefreshEggList = function()
            for _, item in ipairs(EggFilterList:GetChildren()) do
                if item:IsA("TextButton") or item:IsA("TextLabel") then item:Destroy() end
            end
            local records = GetEggRecords()
            if #records == 0 then
                Create("TextLabel", {
                    Parent = EggFilterList,
                    Size = UDim2.new(1, -8, 0, 28),
                    BackgroundTransparency = 1,
                    Text = "Select zones to view eggs",
                    TextColor3 = Theme.Gray,
                    Font = Enum.Font.Gotham,
                    TextSize = 9
                })
                return
            end
            for eggIndex, record in ipairs(records) do
                local eggName = record.name
                local selected = SelectedEggs[eggName] ~= false
                local EggButton = Create("TextButton", {
                    Name = "Egg_" .. eggName:gsub("[^%w_]", ""),
                    Parent = EggFilterList,
                    Size = UDim2.new(1, -8, 0, 24),
                    BackgroundColor3 = selected and Theme.Selected or Theme.Card,
                    Text = "",
                    BorderSizePixel = 0,
                    LayoutOrder = eggIndex,
                    AutoButtonColor = false
                })
                AddCorner(EggButton, 5)
                Create("TextLabel", {
                    Parent = EggButton,
                    Position = UDim2.fromOffset(8, 0),
                    Size = UDim2.new(1, -34, 1, 0),
                    BackgroundTransparency = 1,
                    Text = eggName,
                    TextColor3 = Theme.Text,
                    Font = Enum.Font.Gotham,
                    TextSize = 9,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                local Checkmark = Create("TextLabel", {
                    Parent = EggButton,
                    Position = UDim2.new(1, -26, 0, 0),
                    Size = UDim2.fromOffset(22, 24),
                    BackgroundTransparency = 1,
                    Text = selected and "✓" or "○",
                    TextColor3 = selected and Color3.fromRGB(110, 205, 145) or Theme.Gray,
                    Font = Enum.Font.GothamBold,
                    TextSize = 12
                })
                EggButton.MouseButton1Click:Connect(function()
                    if SelectedEggs[eggName] == false then
                        SelectedEggs[eggName] = nil
                    else
                        SelectedEggs[eggName] = false
                    end
                    RefreshEggList()
                end)
            end
        end
        UpdateSortButtons()
        local TitanicPriorityEnabled = false
        local TitanicPriorityToggle = CreateToggle(Card1, "TITANIC priority", false, function(enabled)
            TitanicPriorityEnabled = enabled
            AddDebugLog("[Auto Break] TITANIC priority " .. (enabled and "ON" or "OFF"))
            if RefreshTitanicPriority then
                RefreshTitanicPriority()
            end
        end)
        TitanicPriorityToggle.Position = UDim2.fromOffset(15, 110)
        TitanicPriorityToggle.Size = UDim2.new(1, -30, 0, 28)
        Card1.Size = UDim2.new(1, 0, 0, 158)
        local function UpdateFilterPanelWithTitanic()
            ZoneList.Visible = ZoneFilterOpen
            EggFilterList.Visible = EggFilterOpen
            SortFrame.Visible = true
            Card1.Size = UDim2.new(1, 0, 0, (EggFilterOpen or ZoneFilterOpen) and 270 or 158)
            SortFrame.Position = UDim2.fromOffset(15, 78)
            SortFrame.Size = UDim2.new(1, -30, 0, 28)
            HighestLuckToggle.Position = UDim2.fromOffset(0, 0)
            HighestLuckToggle.Size = UDim2.new(1, 0, 0, 28)
            TitanicPriorityToggle.Position = UDim2.fromOffset(15, 110)
            TitanicPriorityToggle.Size = UDim2.new(1, -30, 0, 28)
            ZoneFilterButton.Text = ZoneFilterOpen and "Filter zone ▲" or "Filter zone"
            EggFilterButton.Text = EggFilterOpen and "Filter egg ▲" or "Filter egg"
            ZoneList.Position = UDim2.fromOffset(15, 150)
            EggFilterList.Position = UDim2.fromOffset(15, 150)
        end
        DisableAutoBreakOptions = function()
            SortOrder = "Default"
            TitanicPriorityEnabled = false
            if HighestLuckToggle then ToggleControllers[HighestLuckToggle].SetEnabled(false, false) end
            if TitanicPriorityToggle then ToggleControllers[TitanicPriorityToggle].SetEnabled(false, false) end
            if RefreshEggList then RefreshEggList() end
        end
        ZoneFilterButton.MouseButton1Click:Connect(UpdateFilterPanelWithTitanic)
        EggFilterButton.MouseButton1Click:Connect(UpdateFilterPanelWithTitanic)
        RefreshZoneList()
        RefreshEggList()
        ZoneBuilds.ChildAdded:Connect(function()
            RefreshZoneList()
            RefreshEggList()
        end)
        ZoneBuilds.ChildRemoved:Connect(function()
            RefreshZoneList()
            RefreshEggList()
        end)
        ZoneLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            ZoneList.CanvasSize = UDim2.new(0, 0, 0, ZoneLayout.AbsoluteContentSize.Y + 8)
        end)
        EggLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            EggFilterList.CanvasSize = UDim2.new(0, 0, 0, EggLayout.AbsoluteContentSize.Y + 8)
        end)
        local CurrentTarget
        local ArrivedAtTarget = false
        local WaitingForPickup = false
        local MovementConnection
        local PickupMovementConnection
        local ReturnMovementConnection
        local BaselinePickups = {}
        local PickupRequested = false
        local ReturningAfterPickup = false
        local ActivePickup
        local ActivePickupCPS = -1
        local PickupPhase = "IDLE"
        local PickupGeneration = 0
        local ScriptShuttingDown = false
        local AnimalFolderConnection
        local FlingRemoteConnection
        local FlingRecoveryActive = false
        local HitEventConnection
        local SetTrackerStatus
        local function SetPickupPhase(phase, message)
            PickupPhase = phase
            if message then SetTrackerStatus("PICKUP LOCK [" .. phase .. "]: " .. message) end
        end
        StopPickupAutomation = function(reason)
            PickupGeneration += 1
            PickupRequested = false
            ReturningAfterPickup = false
            ActivePickup = nil
            ActivePickupCPS = -1
            if PickupMovementConnection then PickupMovementConnection:Disconnect(); PickupMovementConnection = nil end
            if ReturnMovementConnection then ReturnMovementConnection:Disconnect(); ReturnMovementConnection = nil end
            if MovementConnection then MovementConnection:Disconnect(); MovementConnection = nil end
            local character = LocalPlayer.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            if humanoid then humanoid:Move(Vector3.zero, false) end
            if SetTrackerStatus then SetTrackerStatus(tostring(reason) .. "; all pickup/return movement stopped.") end
        end
        ShutdownAutomation = function()
            ScriptShuttingDown = true
            PickupGeneration += 1
            PickupRequested = false
            ReturningAfterPickup = false
            ActivePickup = nil
            ActivePickupCPS = -1
            AutoBreakEnabled = false
            AutoPickupEnabled = false
            if MovementConnection then MovementConnection:Disconnect(); MovementConnection = nil end
            if PickupMovementConnection then PickupMovementConnection:Disconnect(); PickupMovementConnection = nil end
            if ReturnMovementConnection then ReturnMovementConnection:Disconnect(); ReturnMovementConnection = nil end
            if HitEventConnection then HitEventConnection:Disconnect(); HitEventConnection = nil end
            if FlingRemoteConnection then FlingRemoteConnection:Disconnect(); FlingRemoteConnection = nil end
            if AnimalFolderConnection then AnimalFolderConnection:Disconnect(); AnimalFolderConnection = nil end
            local character = LocalPlayer.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            if humanoid then humanoid:Move(Vector3.zero, false) end
        end
        Runtime.Shutdown = function()
            if ShutdownAutomation then
                ShutdownAutomation()
            end
        end
        local function ClearPickupLock(token)
            if token and token ~= PickupGeneration then return false end
            PickupRequested = false
            ActivePickup = nil
            ActivePickupCPS = -1
            PickupPhase = "IDLE"
            return true
        end
        local HitEvent = game:GetService("ReplicatedStorage"):WaitForChild("EggHitConfirmed")
        local AnimalPickups = workspace:FindFirstChild("AnimalPickups")
        local ReturnPosition = Vector3.new(-29.243687, 3.5, -14.755682)
        local function EquipHotbarOne()
            local Players = game:GetService("Players")
            local currentPlayer = LocalPlayer or Players.LocalPlayer
            if not currentPlayer then
                SetTrackerStatus("Hotbar 1 equip failed: LocalPlayer unavailable.")
                return false
            end

            local character = currentPlayer.Character
            if not character then
                local ok, result = pcall(function()
                    return currentPlayer.CharacterAdded:Wait()
                end)
                if ok then character = result end
            end
            if not character then
                SetTrackerStatus("Hotbar 1 equip failed: character not loaded.")
                return false
            end

            local humanoid = character:FindFirstChildOfClass("Humanoid")
                or character:WaitForChild("Humanoid", 5)
            local backpack = currentPlayer:FindFirstChildOfClass("Backpack")
                or currentPlayer:WaitForChild("Backpack", 5)
            if not humanoid or not backpack then
                SetTrackerStatus("Hotbar 1 equip failed: Humanoid or Backpack not ready.")
                return false
            end
            if humanoid.Health <= 0 then
                SetTrackerStatus("Hotbar 1 equip failed: character is dead.")
                return false
            end

            local function FindHotbarOneTool()
                local tools = {}
                for _, container in ipairs({backpack, character}) do
                    for _, item in ipairs(container:GetChildren()) do
                        if item:IsA("Tool") then
                            if item.Name:lower():find("pickaxe", 1, true) then
                                return item
                            end
                            if container == backpack then
                                table.insert(tools, item)
                            end
                        end
                    end
                end
                return tools[1]
            end

            for attempt = 1, 5 do
                if currentPlayer.Character ~= character or not character.Parent then
                    SetTrackerStatus("Hotbar 1 equip failed: character changed during equip.")
                    return false
                end

                local tool = FindHotbarOneTool()
                if not tool then
                    if attempt < 5 then
                        SetTrackerStatus("Waiting for a hotbar tool... (" .. attempt .. "/5)")
                        task.wait(0.3)
                    else
                        SetTrackerStatus("Hotbar 1 equip failed: no Tool found in Backpack or character.")
                    end
                elseif tool.Parent == character then
                    SetTrackerStatus("Hotbar 1 already equipped: " .. tool.Name)
                    return true
                else
                    local ok, err = pcall(function()
                        humanoid:EquipTool(tool)
                    end)
                    if not ok then
                        SetTrackerStatus("Hotbar 1 equip attempt " .. attempt .. " failed: " .. tostring(err))
                    else
                        local deadline = os.clock() + 0.75
                        repeat
                            if tool.Parent == character then
                                SetTrackerStatus("Equipped hotbar 1 tool: " .. tool.Name)
                                return true
                            end
                            task.wait(0.05)
                        until os.clock() >= deadline
                        SetTrackerStatus("Equip not confirmed for " .. tool.Name .. " (attempt " .. attempt .. "/5). Retrying...")
                    end
                    if attempt < 5 then task.wait(0.25) end
                end
            end

            SetTrackerStatus("Hotbar 1 equip failed: tool stayed in Backpack after 5 attempts.")
            return false
        end
        local AnimalBankEquipConnections = {}
        local function BindAnimalBankEquip(remote)
            if not remote:IsA("RemoteEvent") or AnimalBankEquipConnections[remote] then return end
            local remoteName = remote.Name:lower():gsub("[^%a]", "")
            if not remoteName:find("animalbank", 1, true) and not remoteName:find("bankanimal", 1, true) then return end
            AnimalBankEquipConnections[remote] = remote.OnClientEvent:Connect(function()
                task.delay(2, function()
                    if Runtime.Stopped then return end
                    SetTrackerStatus("Animal bank event received; equipping hotbar 1 after 2 seconds.")
                    EquipHotbarOne()
                end)
            end)
        end
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        for _, remote in ipairs(ReplicatedStorage:GetDescendants()) do
            BindAnimalBankEquip(remote)
        end
        ReplicatedStorage.DescendantAdded:Connect(function(instance)
            BindAnimalBankEquip(instance)
        end)
        local function ReturnToPickup(reason)
            if ReturningAfterPickup then return end
            ClearPickupLock()
            ReturningAfterPickup = true
            local returnToken = PickupGeneration
            SetTrackerStatus(reason or "Pickup hold completed. Returning to the pickup point.")
            task.spawn(function()
                local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                local humanoid = character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid")
                local root = character:FindFirstChild("HumanoidRootPart") or character:WaitForChild("HumanoidRootPart")
                SetTrackerStatus("Moving to static return position.")
                local moveStarted = os.clock()
                local connection
                connection = game:GetService("RunService").RenderStepped:Connect(function()
                    if PickupGeneration ~= returnToken then
                        connection:Disconnect()
                        if ReturnMovementConnection == connection then ReturnMovementConnection = nil end
                        connection = nil
                        return
                    end
                    if not ReturningAfterPickup or LocalPlayer.Character ~= character or not character.Parent or not root.Parent or humanoid.Health <= 0 then
                        humanoid:Move(Vector3.zero, false)
                        connection:Disconnect()
                        if ReturnMovementConnection == connection then ReturnMovementConnection = nil end
                        connection = nil
                        ReturningAfterPickup = false
                        SetTrackerStatus("Return movement stopped: character unavailable.")
                        if AutoBreakEnabled and StartAutoBreak then
                            task.delay(0.2, function()
                                if PickupGeneration == returnToken and AutoBreakEnabled and not PickupRequested and not ReturningAfterPickup then StartAutoBreak() end
                            end)
                        end
                        return
                    end
                    local offset = Vector3.new(
                        ReturnPosition.X - root.Position.X,
                        0,
                        ReturnPosition.Z - root.Position.Z
                    )
                    if offset.Magnitude <= 4 then
                        humanoid:Move(Vector3.zero, false)
                        connection:Disconnect()
                        connection = nil
                        ReturningAfterPickup = false
                        SetTrackerStatus("Reached base; waiting 2 seconds before equipping hotbar 1.")
                        task.delay(2, function()
                            if not ScriptShuttingDown and PickupGeneration == returnToken and not PickupRequested and not ReturningAfterPickup and AutoPickupEnabled and LocalPlayer.Character == character then
                                local equipped = EquipHotbarOne()
                                if equipped then
                                    SetTrackerStatus("Returned to base; hotbar 1 tool equipped.")
                                end
                            end
                        end)
                        if AutoBreakEnabled and StartAutoBreak then
                            task.delay(0.2, function()
                                if PickupGeneration == returnToken and AutoBreakEnabled and not PickupRequested and not ReturningAfterPickup then StartAutoBreak() end
                            end)
                        end
                        return
                    end
                    if os.clock() - moveStarted >= 25 then
                        humanoid:Move(Vector3.zero, false)
                        connection:Disconnect()
                        connection = nil
                        ReturningAfterPickup = false
                        SetTrackerStatus("Return timed out; horizontal distance="
                            .. math.floor(offset.Magnitude) .. ".")
                        if AutoBreakEnabled and StartAutoBreak then
                            task.delay(0.2, function()
                                if PickupGeneration == returnToken and AutoBreakEnabled and not PickupRequested and not ReturningAfterPickup then StartAutoBreak() end
                            end)
                        end
                        return
                    end
                    humanoid:Move(offset.Unit, false)
                end)
                ReturnMovementConnection = connection
            end)
        end
        local function IsTargetReference(reference, target)
            if typeof(reference) ~= "Instance" or typeof(target) ~= "Instance" then
                return false
            end
            return reference == target or reference:IsDescendantOf(target)
        end
        SetTrackerStatus = function(message)
            AddDebugLog("[Egg Tracker] " .. tostring(message))
        end
        HitEvent.OnClientEvent:Connect(function(eggReference, hitCounter, health)
            local target = CurrentTarget
            if not target or not IsTargetReference(eggReference, target) then
                return
            end
            SetTrackerStatus("MATCH | target=" .. target:GetFullName()
                .. " | counter=" .. tostring(hitCounter)
                .. " | health=" .. tostring(health))
            if tonumber(health) and tonumber(health) <= 0 then
                CompletedEggs[target] = true
                WaitingForPickup = true
                ArrivedAtTarget = false
                if MovementConnection then
                    MovementConnection:Disconnect()
                    MovementConnection = nil
                end
                local character = LocalPlayer.Character
                local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid:Move(Vector3.zero, false)
                end
                SetTrackerStatus("Target egg reached 0 HP (including while travelling); movement stopped and watching AnimalPickups.")
            end
        end)
        local function GetPetRarity(pickup)
            local rarity = pickup:FindFirstChild("Rarity", true)
            if rarity and rarity:IsA("StringValue") then
                return rarity.Value
            end
            if rarity and rarity:IsA("TextLabel") then
                return rarity.Text
            end
            local attribute = pickup:GetAttribute("Rarity")
            return attribute and tostring(attribute) or nil
        end
        local function GetPickupZone(pickup)
            local zone = pickup:FindFirstChild("ZoneId", true)
            if zone and zone:IsA("ValueBase") then
                return tostring(zone.Value)
            end
            local attribute = pickup:GetAttribute("ZoneId")
            return attribute and tostring(attribute) or nil
        end
        local function ParseCPS(display)
            if type(display) ~= "string" then return -1 end
            local cleaned = display:gsub(",", ""):gsub("%s+", ""):gsub("%$", "")
            cleaned = cleaned:gsub("/[sS]$", "")
            local numberText, suffix = cleaned:match("^([%d%.]+)([%a]*)$")
            local number = tonumber(numberText)
            local scales = {k=1e3, m=1e6, b=1e9, t=1e12, qa=1e15, q=1e15, qi=1e18}
            local scale = scales[(suffix or ""):lower()]
            if number and number >= 0 and (not suffix or suffix == "" or scale) then
                return number * (scale or 1)
            end
            return -1
        end
        local function GetPetCPS(pickup)
            if not pickup or not pickup:IsA("Model") then
                return -1, "CPS unavailable: animal model missing"
            end
            local sawCPSNode = false
            local function readTextObject(object)
                if not object then return -1, nil end
                if object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox") then
                    local value = ParseCPS(object.Text)
                    if value >= 0 then return value, object.Text end
                end
                for _, childName in ipairs({"Text", "ContentText"}) do
                    local child = object:FindFirstChild(childName, true)
                    if child and (child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox")) then
                        local value = ParseCPS(child.Text)
                        if value >= 0 then return value, child.Text end
                    end
                end
                return -1, nil
            end
            local descendants = pickup:GetDescendants()
            for _, node in ipairs(descendants) do
                if node.Name == "CashPerSecond" then
                    sawCPSNode = true
                    local value, display = readTextObject(node)
                    if value >= 0 then return value, display end
                end
            end
            for _, node in ipairs(descendants) do
                if node.Name == "AnimalOverheadAttachment" or node.Name == "AnimalOverhead" then
                    local value, display = readTextObject(node:FindFirstChild("CashPerSecond", true))
                    if value >= 0 then return value, display end
                end
            end
            if sawCPSNode then
                return -1, "CPS unavailable: CashPerSecond exists but contains no readable numeric Text/ContentText"
            end
            return -1, "CPS unavailable: no CashPerSecond node found in animal model"
        end
        local function IsRarityAllowed(pickup)
            local selectedCount = 0
            for _, selected in pairs(SelectedRarities) do
                if selected then selectedCount += 1 end
            end
            if selectedCount == 0 then return true end
            local rarity = GetPetRarity(pickup)
            if not rarity then
                SetTrackerStatus("Cannot filter " .. pickup.Name .. ": Rarity value not found.")
                return false
            end
            for selectedRarity, selected in pairs(SelectedRarities) do
                if selected and selectedRarity:lower() == rarity:lower() then
                    return true
                end
            end
            return false
        end
        local function GetLowestPlacedCPS()
            local plots = workspace:FindFirstChild("Plots")
            if not plots then return -1 end
            for _, base in ipairs(plots:GetChildren()) do
                local hitbox = base:FindFirstChild("Hitbox")
                local info = hitbox and hitbox:FindFirstChild("PlayerInfoUi")
                local nameLabel = info and info:FindFirstChild("Name")
                if nameLabel and nameLabel:IsA("TextLabel") and nameLabel.Text == "Your Base" then
                    local placed = base:FindFirstChild("PlacedAnimals")
                    local lowest = math.huge
                    if placed then
                        for _, animal in ipairs(placed:GetChildren()) do
                            local value = GetPetCPS(animal)
                            if value >= 0 and value < lowest then lowest = value end
                        end
                    end
                    return lowest < math.huge and lowest or -1
                end
            end
            return -1
        end
        local function RejectPickupAndRestart(message)
            if PickupRequested then
                SetTrackerStatus(message .. " | candidate rejected; active pickup remains in control.")
                return
            end
            if ReturningAfterPickup then
                SetTrackerStatus(message .. " | candidate rejected while returning to base.")
                return
            end
            local hadTarget = CurrentTarget ~= nil and CurrentTarget.Parent ~= nil
            if hadTarget and WaitingForPickup then
                CompletedEggs[CurrentTarget] = true
            end
            SetTrackerStatus(message .. (hadTarget and WaitingForPickup
                and " | rejected animal; releasing egg wait and resuming Auto Break."
                or " | rejected animal; checking whether Auto Break can resume."))
            task.defer(function()
                if StopAutoBreak then StopAutoBreak("Recovering after rejected animal.", false) end
                task.wait(0.2)
                if AutoBreakEnabled and not PickupRequested and not ReturningAfterPickup and StartAutoBreak then
                    StartAutoBreak()
                end
            end)
        end
        local function SetPickupTracking(pickup, status, cpsText)
            if not pickup or not pickup.Parent then return end
            pickup:SetAttribute("BASAE_CPSCheckStatus", tostring(status or "Not checked"))
            if cpsText ~= nil then
                pickup:SetAttribute("BASAE_CPSCheckValue", tostring(cpsText))
            end
            pickup:SetAttribute("BASAE_CPSCheckedAt", os.time())
        end
        local function GetIndexNameLabel(animalName)
            local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
            local mainGui = playerGui and playerGui:FindFirstChild("MainGUI")
            local frames = mainGui and mainGui:FindFirstChild("Frames")
            local index = frames and frames:FindFirstChild("Index")
            local indexList = index and index:FindFirstChild("IndexList")
            local scrollingFrame = indexList and indexList:FindFirstChild("ScrollingFrame")
            if not scrollingFrame then return nil end
            local wanted = tostring(animalName):lower():gsub("[%s_%-]", "")
            for _, zone in ipairs(scrollingFrame:GetChildren()) do
                local animalList = zone:FindFirstChild("AnimalList")
                if animalList then
                    for _, animalEntry in ipairs(animalList:GetChildren()) do
                        local entryName = animalEntry.Name:lower():gsub("[%s_%-]", "")
                        if entryName == wanted then
                            local inner = animalEntry:FindFirstChild("Inner")
                            local nameLabel = inner and inner:FindFirstChild("Name")
                            if nameLabel and (nameLabel:IsA("TextLabel") or nameLabel:IsA("TextButton")) then
                                return nameLabel
                            end
                        end
                    end
                end
            end
            return nil
        end
        local function EvaluateUnindexedStatus(pickup)
            local label = GetIndexNameLabel(pickup.Name)
            for attempt = 1, 8 do
                if label and label.Parent then break end
                if not pickup.Parent or not AutoPickupEnabled then
                    return nil, "verification cancelled"
                end
                SetPickupTracking(pickup, string.format("Waiting for Index entry (%d/8)", attempt))
                task.wait(0.25)
                label = GetIndexNameLabel(pickup.Name)
            end
            if not label or not label.Parent then
                return nil, "Index entry unavailable"
            end
            local displayName = tostring(label.Text or ""):match("^%s*(.-)%s*$")
            if displayName == "???" then
                return true, displayName
            end
            if displayName == "" then
                return nil, "Index name is empty"
            end
            return false, displayName
        end
        local function EvaluatePickup(pickup)
            SetPickupTracking(pickup, "Checking")
            if ReturningAfterPickup then
                SetPickupTracking(pickup, "Skipped: returning to base")
                SetTrackerStatus("Eligible pet " .. pickup.Name .. " ignored: already returning to base.")
                return
            end
            if not AutoPickupEnabled then
                SetPickupTracking(pickup, "Skipped: Auto Pickup OFF")
                if CurrentTarget then CompletedEggs[CurrentTarget] = true end
                WaitingForPickup = false
                SetTrackerStatus("New pet detected (Auto Pickup OFF): " .. pickup.Name .. " | continuing to next egg.")
                task.defer(function()
                    if StopAutoBreak then StopAutoBreak() end
                    task.wait(0.2)
                    if AutoBreakEnabled and StartAutoBreak then StartAutoBreak() end
                end)
                return
            end
            local forceUnindexedPickup = false
            if UnindexedOnlyEnabled then
                local isUnindexed, indexDisplay = EvaluateUnindexedStatus(pickup)
                if isUnindexed == nil then
                    SetPickupTracking(pickup, "Rejected: Index verification unavailable", tostring(indexDisplay))
                    RejectPickupAndRestart("Filtered out " .. pickup.Name .. " | Index verification failed: " .. tostring(indexDisplay))
                    return
                elseif isUnindexed then
                    forceUnindexedPickup = true
                    SetPickupTracking(pickup, "Unindexed (???); bypassing filters", "???")
                else
                    SetPickupTracking(pickup, "Already indexed; applying normal filters", tostring(indexDisplay))
                end
            end
            if not forceUnindexedPickup then
                if not IsRarityAllowed(pickup) then
                    SetPickupTracking(pickup, "Rejected: rarity filter")
                    RejectPickupAndRestart("Filtered out " .. pickup.Name .. " | rarity=" .. tostring(GetPetRarity(pickup) or "unknown"))
                    return
                end
                local petZone = GetPickupZone(pickup)
                local targetZone = CurrentTarget and CurrentTarget.Parent and CurrentTarget.Parent.Parent
                local targetZoneName = targetZone and targetZone.Name
                if petZone and targetZoneName and petZone:lower() ~= targetZoneName:lower() then
                    SetPickupTracking(pickup, "Rejected: zone mismatch")
                    RejectPickupAndRestart("Filtered out " .. pickup.Name .. " | zone=" .. petZone .. " (target zone " .. targetZoneName .. ")")
                    return
                end
            end
            local cps, cpsText = -1, "CPS skipped for unindexed animal"
            if not forceUnindexedPickup then
                SetPickupTracking(pickup, "CPS scan 1/2: warming up")
                local _, firstScanText = GetPetCPS(pickup)
                if not pickup.Parent or not AutoPickupEnabled then
                    SetPickupTracking(pickup, "CPS verification cancelled", firstScanText)
                    return
                end
                task.wait(0.15)
                if not pickup.Parent or not AutoPickupEnabled then
                    SetPickupTracking(pickup, "CPS verification cancelled", firstScanText)
                    return
                end
                SetPickupTracking(pickup, "CPS scan 2/2: using this result")
                cps, cpsText = GetPetCPS(pickup)
                if cps < 0 then
                    for attempt = 1, 8 do
                        if not pickup.Parent or not AutoPickupEnabled then break end
                        SetPickupTracking(pickup, string.format("Waiting for valid second CPS scan (%d/8)", attempt), cpsText)
                        task.wait(0.25)
                        cps, cpsText = GetPetCPS(pickup)
                        if cps >= 0 then break end
                    end
                end
                SetPickupTracking(pickup, cps >= 0 and "CPS checked (second scan)" or "CPS read failed", cpsText)
                if HighestCashEnabled and cps < 0 then
                    SetPickupTracking(pickup, "Rejected: CPS unavailable", cpsText)
                    RejectPickupAndRestart("Filtered out " .. pickup.Name .. " | CPS could not be read safely: " .. tostring(cpsText))
                    return
                end
                if HighestCashEnabled then
                    local lowestPlaced = GetLowestPlacedCPS()
                    if lowestPlaced >= 0 and cps <= lowestPlaced then
                        SetPickupTracking(pickup, "Rejected: below lowest placed CPS", cpsText)
                        RejectPickupAndRestart("Filtered out " .. pickup.Name .. " | CPS " .. cpsText
                            .. " is not above your lowest placed CPS (" .. tostring(lowestPlaced) .. ").")
                        return
                    end
                end
            end
            if PickupRequested then
                if forceUnindexedPickup or (HighestCashEnabled and ActivePickup and ActivePickup.Parent and cps > ActivePickupCPS) then
                    SetPickupTracking(pickup, "Replacing lower-CPS pickup", cpsText)
                    PickupGeneration += 1
                    PickupRequested = false
                    if PickupMovementConnection then
                        PickupMovementConnection:Disconnect()
                        PickupMovementConnection = nil
                    end
                    local oldPickupName = ActivePickup.Name
                    SetTrackerStatus(string.format("PICKUP LOCK PREEMPT: %s (%.2f CPS) replaces %s (%.2f CPS) during phase %s.", pickup.Name, cps, oldPickupName, ActivePickupCPS, PickupPhase))
                    local oldCharacter = LocalPlayer.Character
                    local oldHumanoid = oldCharacter and oldCharacter:FindFirstChildOfClass("Humanoid")
                    if oldHumanoid then oldHumanoid:Move(Vector3.zero, false) end
                    task.wait()
                else
                    SetPickupTracking(pickup, "Checked: another pickup has priority", cpsText)
                    SetTrackerStatus(string.format("Eligible pet %s ignored while %s is locked (CPS %.2f vs %.2f).", pickup.Name, tostring(ActivePickup and ActivePickup.Name or "another pickup"), cps, ActivePickupCPS))
                    return
                end
            end
            PickupGeneration += 1
            local pickupToken = PickupGeneration
            ActivePickup = pickup
            ActivePickupCPS = cps
            PickupPhase = "ANIMAL_APPROACH"
            SetPickupTracking(pickup, "Selected for pickup", cpsText)
            PickupRequested = true
            if CurrentTarget then CompletedEggs[CurrentTarget] = true end
            if StopAutoBreak then StopAutoBreak() end
            if MovementConnection then MovementConnection:Disconnect(); MovementConnection = nil end
            local activeCharacter = LocalPlayer.Character
            local activeHumanoid = activeCharacter and activeCharacter:FindFirstChildOfClass("Humanoid")
            if activeHumanoid then activeHumanoid:Move(Vector3.zero, false) end
            SetPickupPhase("ANIMAL_APPROACH", string.format("%s | %.2f CPS | Auto Break paused; animal target owns movement.", pickup.Name, cps))
            local pickupPosition
            local positionOk, position = pcall(function()
                if pickup:IsA("Model") then return pickup:GetPivot().Position end
                if pickup:IsA("BasePart") then return pickup.Position end
            end)
            if positionOk then pickupPosition = position end
            local moveCharacter = LocalPlayer.Character
            local moveHumanoid = moveCharacter and moveCharacter:FindFirstChildOfClass("Humanoid")
            local moveRoot = moveCharacter and moveCharacter:FindFirstChild("HumanoidRootPart")
            if not pickupPosition or not moveHumanoid or not moveRoot then
                if PickupGeneration ~= pickupToken then return end
                PickupRequested = false
                ActivePickup = nil
                ActivePickupCPS = -1
                SetTrackerStatus("Pickup cancelled: animal location or character position unavailable.")
                if AutoBreakEnabled and StartAutoBreak then StartAutoBreak() end
                return
            end
            local animalMoveStarted = os.clock()
            local lastAnimalProgressAt = os.clock()
            local bestAnimalDistance = math.huge
            if PickupMovementConnection then
                PickupMovementConnection:Disconnect()
                PickupMovementConnection = nil
            end
            local animalMoveBindName = "BASAE_PickupAnimal_" .. tostring(pickupToken)
            RunService:BindToRenderStep(animalMoveBindName, Enum.RenderPriority.Character.Value + 1, function()
                if not PickupRequested or PickupGeneration ~= pickupToken or not pickup.Parent
                    or LocalPlayer.Character ~= moveCharacter or not moveRoot.Parent
                    or moveHumanoid.Health <= 0 then
                    moveHumanoid:Move(Vector3.zero, false)
                    return
                end
                local ok, currentPosition = pcall(function()
                    if pickup:IsA("Model") then return pickup:GetPivot().Position end
                    if pickup:IsA("BasePart") then return pickup.Position end
                end)
                if ok and currentPosition then
                    local direction = Vector3.new(currentPosition.X - moveRoot.Position.X, 0, currentPosition.Z - moveRoot.Position.Z)
                    if direction.Magnitude > 4 then
                        moveHumanoid:Move(direction.Unit, false)
                    else
                        moveHumanoid:Move(Vector3.zero, false)
                    end
                end
            end)
            local animalMoveConnection = {
                Disconnect = function()
                    pcall(function() RunService:UnbindFromRenderStep(animalMoveBindName) end)
                end
            }
            PickupMovementConnection = animalMoveConnection
            while not Runtime.Stopped and PickupRequested and PickupGeneration == pickupToken and pickup.Parent and moveHumanoid.Health > 0 do
                if LocalPlayer.Character ~= moveCharacter or not moveCharacter.Parent or not moveRoot.Parent then
                    if PickupGeneration ~= pickupToken then return end
                    PickupRequested = false
                    ActivePickup = nil
                    ActivePickupCPS = -1
                    SetTrackerStatus("Pickup cancelled: character changed while moving to animal.")
                    if AutoBreakEnabled and StartAutoBreak then StartAutoBreak() end
                    return
                end
                local ok, currentPosition = pcall(function()
                    if pickup:IsA("Model") then return pickup:GetPivot().Position end
                    if pickup:IsA("BasePart") then return pickup.Position end
                end)
                if ok and currentPosition then pickupPosition = currentPosition end
                local animalOffset = Vector3.new(pickupPosition.X - moveRoot.Position.X, 0, pickupPosition.Z - moveRoot.Position.Z)
                local animalDistance = animalOffset.Magnitude
                if animalDistance <= 4 then break end
                local now = os.clock()
                if now - animalMoveStarted >= 25 then
                    moveHumanoid:Move(Vector3.zero, false)
                    if PickupGeneration ~= pickupToken then return end
                    PickupRequested = false
                    ActivePickup = nil
                    ActivePickupCPS = -1
                    SetTrackerStatus(string.format("Pickup cancelled: timed out reaching animal location (%.1f studs away).", animalDistance))
                    if AutoBreakEnabled and StartAutoBreak then StartAutoBreak() end
                    return
                end
                if animalDistance < bestAnimalDistance - 0.75 then
                    bestAnimalDistance = animalDistance
                    lastAnimalProgressAt = now
                elseif now - lastAnimalProgressAt >= 2.5 then
                    lastAnimalProgressAt = now
                    bestAnimalDistance = animalDistance
                    moveHumanoid:Move(Vector3.zero, false)
                    task.wait(0.05)
                    if PickupRequested and PickupGeneration == pickupToken and pickup.Parent
                        and LocalPlayer.Character == moveCharacter and moveRoot.Parent and moveHumanoid.Health > 0 then
                        local refreshedPosition
                        local refreshedOk, refreshed = pcall(function()
                            if pickup:IsA("Model") then return pickup:GetPivot().Position end
                            if pickup:IsA("BasePart") then return pickup.Position end
                        end)
                        if refreshedOk then refreshedPosition = refreshed end
                        if refreshedPosition then
                            local refreshedDirection = Vector3.new(
                                refreshedPosition.X - moveRoot.Position.X, 0,
                                refreshedPosition.Z - moveRoot.Position.Z
                            )
                            if refreshedDirection.Magnitude > 4 then
                                moveHumanoid:Move(refreshedDirection.Unit, false)
                            end
                        end
                    end
                    SetTrackerStatus(string.format("PICKUP MOVEMENT: reset and reinitialized movement toward %s (%.1f studs).", pickup.Name, animalDistance))
                end
                task.wait(0.05)
            end
            if PickupMovementConnection == animalMoveConnection then
                PickupMovementConnection:Disconnect()
                PickupMovementConnection = nil
            end
            if animalMoveConnection then animalMoveConnection:Disconnect(); animalMoveConnection = nil end
            moveHumanoid:Move(Vector3.zero, false)
            if PickupGeneration ~= pickupToken then return end
            if not PickupRequested or not pickup.Parent or not pickupPosition then
                PickupRequested = false
                ActivePickup = nil
                ActivePickupCPS = -1
                SetTrackerStatus("Pickup cancelled: animal disappeared before location verification.")
                if AutoBreakEnabled and StartAutoBreak then StartAutoBreak() end
                return
            end
            local verifiedAnimalDistance = (Vector3.new(pickupPosition.X, moveRoot.Position.Y, pickupPosition.Z) - moveRoot.Position).Magnitude
            if verifiedAnimalDistance > 5 then
                PickupRequested = false
                ActivePickup = nil
                ActivePickupCPS = -1
                SetTrackerStatus(string.format("Pickup cancelled: animal location verification failed (%.1f studs).", verifiedAnimalDistance))
                if AutoBreakEnabled and StartAutoBreak then StartAutoBreak() end
                return
            end
            SetPickupPhase("PROMPT_SEARCH", string.format("%s | animal reached (%.1f studs); finding its nearest matching StealPrompt.", pickup.Name, verifiedAnimalDistance))
            local prompt
            local promptState = "StealPrompt not found"
            local promptDeadline = os.clock() + 5
            local promptMatchRadius = 18
            local function getPromptPosition(candidate)
                local parent = candidate and candidate.Parent
                while parent and parent ~= workspace do
                    if parent:IsA("Attachment") then
                        return parent.WorldPosition
                    elseif parent:IsA("BasePart") then
                        return parent.Position
                    elseif parent:IsA("Model") then
                        local ok, pivot = pcall(function() return parent:GetPivot() end)
                        if ok and pivot then return pivot.Position end
                    end
                    parent = parent.Parent
                end
                return nil
            end
            repeat
                if PickupGeneration ~= pickupToken then return end
                prompt = nil
                local nearestDistance = math.huge
                local totalStealPrompts = 0
                local enabledStealPrompts = 0
                for _, candidate in ipairs(workspace:GetDescendants()) do
                    if candidate:IsA("ProximityPrompt") and candidate.Name == "StealPrompt" then
                        totalStealPrompts += 1
                        if candidate.Enabled then
                            enabledStealPrompts += 1
                            local candidatePosition = getPromptPosition(candidate)
                            if candidatePosition then
                                local distance = (candidatePosition - pickupPosition).Magnitude
                                if distance < nearestDistance and distance <= promptMatchRadius then
                                    nearestDistance = distance
                                    prompt = candidate
                                end
                            end
                        end
                    end
                end
                if prompt then
                    promptState = string.format("nearest enabled StealPrompt: %s (%.2f studs from animal; found %d total/%d enabled)", prompt:GetFullName(), nearestDistance, totalStealPrompts, enabledStealPrompts)
                else
                    promptState = string.format("No enabled StealPrompt within %.0f studs of animal (found %d total/%d enabled)", promptMatchRadius, totalStealPrompts, enabledStealPrompts)
                end
                if prompt and prompt:IsA("ProximityPrompt") and prompt.Enabled then
                    break
                end
                task.wait(0.25)
            until os.clock() >= promptDeadline
            if PickupGeneration ~= pickupToken then return end
            if not prompt or not prompt:IsA("ProximityPrompt") or not prompt.Enabled then
                PickupRequested = false
                ActivePickup = nil
                ActivePickupCPS = -1
                SetTrackerStatus("Eligible pet " .. pickup.Name
                    .. " but pickup prompt unavailable after 5s: " .. promptState .. ".")
                if AutoBreakEnabled and StartAutoBreak then StartAutoBreak() end
                return
            end
            SetPickupPhase("PROMPT_APPROACH", pickup.Name .. " | moving to matching StealPrompt; target and movement remain locked.")
            task.spawn(function()
                SetPickupPhase("PROMPT_APPROACH", "Lock held by " .. pickup.Name .. "; moving to its matching prompt.")
                local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                local humanoid = character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid")
                local root = character:FindFirstChild("HumanoidRootPart") or character:WaitForChild("HumanoidRootPart")
                local promptPosition = getPromptPosition(prompt)
                if not promptPosition then
                    PickupRequested = false
                    SetTrackerStatus("Pickup cancelled: could not read matched prompt position.")
                    if AutoBreakEnabled and StartAutoBreak then StartAutoBreak() end
                    return
                end
                local moveStarted = os.clock()
                local lastPromptProgressAt = os.clock()
                local bestPromptDistance = math.huge
                if PickupMovementConnection then
                    PickupMovementConnection:Disconnect()
                    PickupMovementConnection = nil
                end
                local promptMoveBindName = "BASAE_PickupPrompt_" .. tostring(pickupToken)
                RunService:BindToRenderStep(promptMoveBindName, Enum.RenderPriority.Character.Value + 1, function()
                    if not PickupRequested or PickupGeneration ~= pickupToken or not pickup.Parent or not prompt.Parent
                        or LocalPlayer.Character ~= character or not root.Parent or humanoid.Health <= 0 then
                        humanoid:Move(Vector3.zero, false)
                        return
                    end
                    local livePosition = getPromptPosition(prompt)
                    if livePosition then promptPosition = livePosition end
                    local direction = Vector3.new(promptPosition.X - root.Position.X, 0, promptPosition.Z - root.Position.Z)
                    local verticalOffset = math.abs(promptPosition.Y - root.Position.Y)
                    local activationRange = math.max(0, prompt.MaxActivationDistance)
                    local horizontalReach = verticalOffset < activationRange
                        and math.sqrt(math.max(0, activationRange * activationRange - verticalOffset * verticalOffset)) - 0.5
                        or 0
                    local stopDistance = math.max(1, horizontalReach)
                    if direction.Magnitude > stopDistance then
                        humanoid:Move(direction.Unit, false)
                    else
                        humanoid:Move(Vector3.zero, false)
                    end
                end)
                local promptMoveConnection = {
                    Disconnect = function()
                        pcall(function() RunService:UnbindFromRenderStep(promptMoveBindName) end)
                    end
                }
                PickupMovementConnection = promptMoveConnection
                while not Runtime.Stopped and PickupRequested and PickupGeneration == pickupToken and pickup.Parent and prompt.Parent and humanoid.Health > 0 do
                    if LocalPlayer.Character ~= character or not character.Parent or not root.Parent then
                        if PickupGeneration ~= pickupToken then return end
                        PickupRequested = false
                        ActivePickup = nil
                        ActivePickupCPS = -1
                        SetTrackerStatus("Pickup cancelled: character changed while moving to animal prompt.")
                        if AutoBreakEnabled and StartAutoBreak then StartAutoBreak() end
                        return
                    end
                    promptPosition = getPromptPosition(prompt) or promptPosition
                    local offset = Vector3.new(promptPosition.X - root.Position.X, 0, promptPosition.Z - root.Position.Z)
                    local promptDistance = offset.Magnitude
                    local verticalOffset = math.abs(promptPosition.Y - root.Position.Y)
                    local activationRange = math.max(0, prompt.MaxActivationDistance)
                    local horizontalReach = verticalOffset < activationRange
                        and math.sqrt(math.max(0, activationRange * activationRange - verticalOffset * verticalOffset)) - 0.5
                        or 0
                    local stopDistance = math.max(1, horizontalReach)
                    if promptDistance <= stopDistance then break end
                    local now = os.clock()
                    if now - moveStarted >= 25 then
                        humanoid:Move(Vector3.zero, false)
                        if PickupGeneration ~= pickupToken then return end
                        PickupRequested = false
                        ActivePickup = nil
                        ActivePickupCPS = -1
                        SetTrackerStatus(string.format("Pickup cancelled: timed out reaching animal prompt (%.1f studs away).", promptDistance))
                        if AutoBreakEnabled and StartAutoBreak then StartAutoBreak() end
                        return
                    end
                    if promptDistance < bestPromptDistance - 0.75 then
                        bestPromptDistance = promptDistance
                        lastPromptProgressAt = now
                    elseif now - lastPromptProgressAt >= 2.5 then
                        lastPromptProgressAt = now
                        bestPromptDistance = promptDistance
                        humanoid:Move(Vector3.zero, false)
                        task.wait(0.05)
                        if PickupRequested and PickupGeneration == pickupToken and pickup.Parent and prompt.Parent
                            and LocalPlayer.Character == character and root.Parent and humanoid.Health > 0 then
                            local refreshedPromptPosition = getPromptPosition(prompt)
                            if refreshedPromptPosition then promptPosition = refreshedPromptPosition end
                            local refreshedOffset = Vector3.new(
                                promptPosition.X - root.Position.X, 0,
                                promptPosition.Z - root.Position.Z
                            )
                            local refreshedVerticalOffset = math.abs(promptPosition.Y - root.Position.Y)
                            local refreshedRange = math.max(0, prompt.MaxActivationDistance)
                            local refreshedReach = refreshedVerticalOffset < refreshedRange
                                and math.sqrt(math.max(0, refreshedRange * refreshedRange - refreshedVerticalOffset * refreshedVerticalOffset)) - 0.5
                                or 0
                            if refreshedOffset.Magnitude > math.max(1, refreshedReach) then
                                humanoid:Move(refreshedOffset.Unit, false)
                            end
                        end
                        SetTrackerStatus(string.format("PICKUP MOVEMENT: reset and reinitialized movement toward StealPrompt (%.1f studs).", promptDistance))
                    end
                    task.wait(0.05)
                end
                if PickupMovementConnection == promptMoveConnection then
                    PickupMovementConnection:Disconnect()
                    PickupMovementConnection = nil
                end
                if promptMoveConnection then promptMoveConnection:Disconnect(); promptMoveConnection = nil end
                humanoid:Move(Vector3.zero, false)
                if PickupGeneration ~= pickupToken then return end
                if not PickupRequested or not pickup.Parent then
                    PickupRequested = false
                    ActivePickup = nil
                    ActivePickupCPS = -1
                    SetTrackerStatus("Pickup cancelled: animal disappeared before reaching its prompt.")
                    if AutoBreakEnabled and StartAutoBreak then StartAutoBreak() end
                    return
                end
                SetPickupPhase("ACTIVATING", "Reached " .. pickup.Name .. "'s matching StealPrompt; confirming range before activation.")
                task.wait(1)
                if PickupGeneration ~= pickupToken then return end
                if LocalPlayer.Character ~= character or not character.Parent or humanoid.Health <= 0 or not root.Parent then
                    PickupRequested = false
                    ActivePickup = nil
                    ActivePickupCPS = -1
                    SetTrackerStatus("Pickup cancelled: character changed or became unavailable.")
                    if AutoBreakEnabled and StartAutoBreak then StartAutoBreak() end
                    return
                end
                if not PickupRequested or not pickup.Parent then
                    PickupRequested = false
                    ActivePickup = nil
                    ActivePickupCPS = -1
                    SetTrackerStatus("Pickup cancelled: pet disappeared during the 3-second wait.")
                    if AutoBreakEnabled and StartAutoBreak then StartAutoBreak() end
                    return
                end
                if PickupGeneration ~= pickupToken then return end
                if not prompt.Parent or not prompt.Enabled then
                    PickupRequested = false
                    ActivePickup = nil
                    ActivePickupCPS = -1
                    SetTrackerStatus("Pickup cancelled: StealPrompt became unavailable after the 3-second wait.")
                    if AutoBreakEnabled and StartAutoBreak then StartAutoBreak() end
                    return
                end
                local latestPromptPosition = getPromptPosition(prompt)
                local latestPromptDistance = latestPromptPosition and (latestPromptPosition - root.Position).Magnitude or math.huge
                if not prompt.Parent or not prompt.Enabled or latestPromptDistance > math.max(4, prompt.MaxActivationDistance) then
                    PickupRequested = false
                    ActivePickup = nil
                    ActivePickupCPS = -1
                    SetTrackerStatus(string.format("Pickup cancelled: prompt range changed before activation (%.1f studs).", latestPromptDistance))
                    if AutoBreakEnabled and StartAutoBreak then StartAutoBreak() end
                    return
                end
                local pickupConfirmed = false
                local activationErrors = {}
                for activationAttempt = 1, 2 do
                    if PickupGeneration ~= pickupToken or not PickupRequested then return end
                    if not prompt.Parent or not prompt.Enabled then break end
                    local currentPromptPosition = getPromptPosition(prompt)
                    local currentPromptDistance = currentPromptPosition and (currentPromptPosition - root.Position).Magnitude or math.huge
                    if currentPromptDistance > prompt.MaxActivationDistance then
                        SetTrackerStatus(string.format("StealPrompt activation attempt %d skipped: %.1f studs away (range %.1f).", activationAttempt, currentPromptDistance, prompt.MaxActivationDistance))
                        break
                    end
                    local holdOk, holdErr = pcall(function()
                        if typeof(fireproximityprompt) == "function" then
                            fireproximityprompt(prompt)
                            if prompt.HoldDuration > 0 then
                                task.wait(prompt.HoldDuration + 0.15)
                            end
                        else
                            prompt:InputHoldBegin()
                            task.wait(prompt.HoldDuration + 0.1)
                            prompt:InputHoldEnd()
                        end
                    end)
                    if not holdOk then
                        table.insert(activationErrors, tostring(holdErr))
                        pcall(function() prompt:InputHoldEnd() end)
                    end
                    local pickupDeadline = os.clock() + 1.25
                    while not Runtime.Stopped and os.clock() < pickupDeadline and PickupGeneration == pickupToken do
                        if not pickup.Parent then
                            pickupConfirmed = true
                            break
                        end
                        task.wait(0.05)
                    end
                    if pickupConfirmed then break end
                    if activationAttempt == 1 and prompt.Parent and prompt.Enabled then
                        SetTrackerStatus("StealPrompt did not collect the animal on first attempt; retrying hold.")
                        task.wait(0.2)
                    end
                end
                if PickupGeneration ~= pickupToken then return end
                if not pickupConfirmed then
                    PickupRequested = false
                    ActivePickup = nil
                    ActivePickupCPS = -1
                    local detail = #activationErrors > 0 and (" Activation error: " .. table.concat(activationErrors, " | ")) or ""
                    SetTrackerStatus("StealPrompt activation did not collect " .. pickup.Name .. "; check prompt range/requirements." .. detail)
                    if AutoBreakEnabled and StartAutoBreak then StartAutoBreak() end
                    return
                end
                SetPickupTracking(pickup, "Collected", cpsText)
                SetPickupPhase("CONFIRMED", "Collected " .. pickup.Name .. "; releasing target lock and returning to base.")
                ActivePickup = nil
                ActivePickupCPS = -1
                ReturnToPickup("Pickup confirmed. Returning straight to base.")
            end)
        end
        local function BindAnimalPickups(folder)
            if not folder or not folder:IsA("Folder") and not folder:IsA("Model") then
                return
            end
            AnimalPickups = folder
            for _, existing in ipairs(folder:GetChildren()) do
                BaselinePickups[existing] = true
            end
            folder.ChildAdded:Connect(function(pickup)
                if BaselinePickups[pickup] then return end
                if not AutoPickupEnabled then
                    SetTrackerStatus("NEW ANIMAL: " .. pickup.Name .. " | Auto Pickup is OFF; ignored.")
                    return
                end
                if ReturningAfterPickup then
                    SetTrackerStatus("NEW ANIMAL: " .. pickup.Name .. " | return-to-base owns movement; ignored.")
                    return
                end
                SetTrackerStatus("NEW ANIMAL detected: " .. pickup.Name .. " | pausing Auto Break and checking filters/priority.")
                if AutoPickupEnabled and not PickupRequested and not ReturningAfterPickup then
                    if StopAutoBreak then StopAutoBreak("Auto Break paused: evaluating new animal pickup.", true) end
                end
                task.defer(function()
                    if not pickup.Parent or not AutoPickupEnabled or ReturningAfterPickup then
                        return
                    end
                    local ok, err = xpcall(function()
                        EvaluatePickup(pickup)
                    end, debug.traceback)
                    if not ok then
                        warn("[BASAE-Skrip] EvaluatePickup failed for " .. pickup.Name .. ": " .. tostring(err))
                        if PickupRequested then
                            PickupGeneration += 1
                            PickupRequested = false
                            ActivePickup = nil
                            ActivePickupCPS = -1
                            local character = LocalPlayer.Character
                            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                            if humanoid then humanoid:Move(Vector3.zero, false) end
                        end
                        SetTrackerStatus("Pickup evaluation error for " .. pickup.Name .. ": " .. tostring(err):gsub("[%r\n]+", " "):sub(1, 220))
                        if AutoBreakEnabled and AutoPickupEnabled and not ReturningAfterPickup and StartAutoBreak then
                            task.wait(0.2)
                            StartAutoBreak()
                        end
                    end
                end)
            end)
            SetTrackerStatus("AnimalPickups folder detected and connected.")
        end
        if AnimalPickups then
            BindAnimalPickups(AnimalPickups)
        end
        local CatchFlingRemote = game:GetService("ReplicatedStorage"):WaitForChild("CatchFlingRemote")
        FlingRemoteConnection = CatchFlingRemote.OnClientEvent:Connect(function(action, flingPosition, duration, strength)
            if tostring(action):lower() ~= "fling" or typeof(flingPosition) ~= "Vector3" then return end
            if not AutoPickupEnabled then
                SetTrackerStatus("Fling recovery ignored: Auto Pickup must be ON.")
                return
            end
            if FlingRecoveryActive then
                SetTrackerStatus("Fling recovery event ignored: recovery is already active.")
                return
            end
            FlingRecoveryActive = true
            local recoveryPickup = ActivePickup
            if PickupMovementConnection then PickupMovementConnection:Disconnect(); PickupMovementConnection = nil end
            if MovementConnection then MovementConnection:Disconnect(); MovementConnection = nil end
            if ReturnMovementConnection then ReturnMovementConnection:Disconnect(); ReturnMovementConnection = nil end
            local interruptedCharacter = LocalPlayer.Character
            local interruptedHumanoid = interruptedCharacter and interruptedCharacter:FindFirstChildOfClass("Humanoid")
            if interruptedHumanoid then
                interruptedHumanoid:Move(Vector3.zero, false)
            end
            ReturningAfterPickup = false
            PickupGeneration += 1
            local flingToken = PickupGeneration
            ActivePickup = nil
            ActivePickupCPS = -1
            PickupRequested = true
            if CurrentTarget then CompletedEggs[CurrentTarget] = true end
            if StopAutoBreak then StopAutoBreak() end
            if MovementConnection then MovementConnection:Disconnect(); MovementConnection = nil end
            SetTrackerStatus(string.format("FLING RECOVERY: remote reported location (%.1f, %.1f, %.1f); resolving the active animal position.", flingPosition.X, flingPosition.Y, flingPosition.Z))
            task.spawn(function()
                local recoveryMoveBindName
                local function finishFlingRecovery()
                    if recoveryMoveBindName then
                        pcall(function()
                            game:GetService("RunService"):UnbindFromRenderStep(recoveryMoveBindName)
                        end)
                        recoveryMoveBindName = nil
                    end
                    FlingRecoveryActive = false
                    if AutoBreakEnabled and not PickupRequested and not ReturningAfterPickup and StartAutoBreak then
                        task.delay(0.25, function()
                            if not FlingRecoveryActive and AutoBreakEnabled and not PickupRequested and not ReturningAfterPickup then
                                StartAutoBreak()
                            end
                        end)
                    end
                end
                local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                local humanoid = character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid")
                local root = character:FindFirstChild("HumanoidRootPart") or character:WaitForChild("HumanoidRootPart")
                if PickupGeneration ~= flingToken or not PickupRequested or not AutoPickupEnabled then
                    finishFlingRecovery()
                    return
                end
                local recoveryPosition = flingPosition
                local recoveryPositionSource = "CatchFlingRemote"
                if recoveryPickup and recoveryPickup.Parent then
                    local isInPickupFolder = false
                    local pickupFolder = workspace:FindFirstChild("AnimalPickups")
                    if pickupFolder and recoveryPickup:IsDescendantOf(pickupFolder) then
                        isInPickupFolder = true
                    end
                    if isInPickupFolder then
                        local okPosition, animalPosition = pcall(function()
                            if recoveryPickup:IsA("Model") then return recoveryPickup:GetPivot().Position end
                            if recoveryPickup:IsA("BasePart") then return recoveryPickup.Position end
                        end)
                        if okPosition and typeof(animalPosition) == "Vector3" then
                            recoveryPosition = animalPosition
                            recoveryPositionSource = "ActivePickup"
                        end
                    end
                end
                SetTrackerStatus(string.format(
                    "FLING RECOVERY target source=%s | target=(%.1f, %.1f, %.1f).",
                    recoveryPositionSource, recoveryPosition.X, recoveryPosition.Y, recoveryPosition.Z
                ))
                local RunService = game:GetService("RunService")
                recoveryMoveBindName = "BASAEFlingRecovery_" .. tostring(flingToken)
                RunService:BindToRenderStep(recoveryMoveBindName, Enum.RenderPriority.Character.Value + 1, function()
                    if Runtime.Stopped or not PickupRequested or PickupGeneration ~= flingToken
                        or LocalPlayer.Character ~= character or not root.Parent or humanoid.Health <= 0 then
                        humanoid:Move(Vector3.zero, false)
                        return
                    end
                    local moveOffset = Vector3.new(recoveryPosition.X - root.Position.X, 0, recoveryPosition.Z - root.Position.Z)
                    if moveOffset.Magnitude > 4 then
                        humanoid:Move(moveOffset.Unit, false)
                    else
                        humanoid:Move(Vector3.zero, false)
                    end
                end)
                local moveStarted = os.clock()
                local lastProgressAt = os.clock()
                local bestDistance = math.huge
                while not Runtime.Stopped and PickupRequested and PickupGeneration == flingToken and humanoid.Health > 0 do
                    if LocalPlayer.Character ~= character or not character.Parent or not root.Parent then
                        PickupRequested = false
                        SetTrackerStatus("FLING RECOVERY cancelled: character changed or root became unavailable.")
                        if AutoBreakEnabled and StartAutoBreak then StartAutoBreak() end
                        finishFlingRecovery()
                        return
                    end
                    local offset = Vector3.new(recoveryPosition.X - root.Position.X, 0, recoveryPosition.Z - root.Position.Z)
                    local distance = offset.Magnitude
                    if distance <= 4 then break end
                    local now = os.clock()
                    if now - moveStarted >= 45 then
                        humanoid:Move(Vector3.zero, false)
                        PickupRequested = false
                        SetTrackerStatus(string.format("FLING RECOVERY cancelled: timed out reaching reported animal location (%.1f studs away).", distance))
                        if AutoBreakEnabled and StartAutoBreak then StartAutoBreak() end
                        finishFlingRecovery()
                        return
                    end
                    if distance < bestDistance - 0.75 then
                        bestDistance = distance
                        lastProgressAt = now
                    elseif now - lastProgressAt >= 2.5 then
                        local state = humanoid:GetState()
                        if state == Enum.HumanoidStateType.FallingDown
                            or state == Enum.HumanoidStateType.Ragdoll
                            or state == Enum.HumanoidStateType.Physics
                            or state == Enum.HumanoidStateType.PlatformStanding then
                            humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                        end
                        lastProgressAt = now
                        bestDistance = distance
                        if humanoid.PlatformStand then humanoid.PlatformStand = false end
                        if root.Anchored then
                            SetTrackerStatus(string.format("FLING RECOVERY blocked: HumanoidRootPart is anchored (%.1f studs away).", distance))
                        else
                            SetTrackerStatus(string.format("FLING RECOVERY: movement input refreshed every frame; no progress yet (%.1f studs away, state=%s).", distance, tostring(state)))
                        end
                    end
                    task.wait(0.1)
                end
                if recoveryMoveBindName then
                    pcall(function() RunService:UnbindFromRenderStep(recoveryMoveBindName) end)
                    recoveryMoveBindName = nil
                end
                humanoid:Move(Vector3.zero, false)
                local arrivalDistance = (Vector3.new(recoveryPosition.X, root.Position.Y, recoveryPosition.Z) - root.Position).Magnitude
                if PickupGeneration ~= flingToken then return end
                if not PickupRequested or humanoid.Health <= 0 or arrivalDistance > 5 then
                    PickupRequested = false
                    SetTrackerStatus(string.format("FLING RECOVERY cancelled: arrival verification failed (%.1f studs).", arrivalDistance))
                    if AutoBreakEnabled and StartAutoBreak then StartAutoBreak() end
                    finishFlingRecovery()
                    return
                end
                SetTrackerStatus(string.format("FLING RECOVERY location verified (%.1f studs); searching nearest PromptAnchor StealPrompt.", arrivalDistance))
                local anchor = workspace:FindFirstChild("PromptAnchor")
                local prompt, promptPosition
                local searchDeadline = os.clock() + 8
                local function positionOf(candidate)
                    local parent = candidate and candidate.Parent
                    while parent and parent ~= workspace do
                        if parent:IsA("Attachment") then return parent.WorldPosition end
                        if parent:IsA("BasePart") then return parent.Position end
                        if parent:IsA("Model") then return parent:GetPivot().Position end
                        parent = parent.Parent
                    end
                    return nil
                end
                repeat
                    anchor = workspace:FindFirstChild("PromptAnchor")
                    local nearest = math.huge
                    prompt, promptPosition = nil, nil
                    if anchor then
                        for _, candidate in ipairs(anchor:GetDescendants()) do
                            if candidate:IsA("ProximityPrompt") and candidate.Name == "StealPrompt" and candidate.Enabled then
                                local pos = positionOf(candidate)
                                if pos then
                                    local distance = (pos - recoveryPosition).Magnitude
                                    if distance < nearest and distance <= 12 then
                                        nearest, prompt, promptPosition = distance, candidate, pos
                                    end
                                end
                            end
                        end
                    end
                    if prompt then break end
                    task.wait(0.2)
                until os.clock() >= searchDeadline or PickupGeneration ~= flingToken
                if PickupGeneration ~= flingToken then return end
                if not prompt or not prompt.Parent or not prompt.Enabled or not promptPosition then
                    PickupRequested = false
                    SetTrackerStatus("FLING RECOVERY failed: no enabled StealPrompt within 12 studs of reported fling location.")
                    if AutoBreakEnabled and StartAutoBreak then StartAutoBreak() end
                    finishFlingRecovery()
                    return
                end
                SetTrackerStatus(string.format("FLING RECOVERY found nearest prompt %.1f studs from reported location; verifying prompt position.", (promptPosition - recoveryPosition).Magnitude))
                local moveStarted = os.clock()
                while not Runtime.Stopped and PickupRequested and PickupGeneration == flingToken and prompt.Parent and prompt.Enabled and humanoid.Health > 0 do
                    promptPosition = positionOf(prompt) or promptPosition
                    local locationError = (promptPosition - recoveryPosition).Magnitude
                    if locationError > 14 then
                        humanoid:Move(Vector3.zero, false)
                        PickupRequested = false
                        SetTrackerStatus(string.format("FLING RECOVERY cancelled: prompt moved %.1f studs from reported location.", locationError))
                        if AutoBreakEnabled and StartAutoBreak then StartAutoBreak() end
                        finishFlingRecovery()
                        return
                    end
                    local offset = Vector3.new(promptPosition.X - root.Position.X, 0, promptPosition.Z - root.Position.Z)
                    local distanceToPrompt = (promptPosition - root.Position).Magnitude
                    if distanceToPrompt <= math.min(prompt.MaxActivationDistance, 5) then break end
                    if os.clock() - moveStarted >= 25 then
                        humanoid:Move(Vector3.zero, false)
                        PickupRequested = false
                        SetTrackerStatus("FLING RECOVERY cancelled: timed out reaching the verified prompt.")
                        if AutoBreakEnabled and StartAutoBreak then StartAutoBreak() end
                        finishFlingRecovery()
                        return
                    end
                    humanoid:Move(offset.Magnitude > 0 and offset.Unit or Vector3.zero, false)
                    task.wait(0.05)
                end
                humanoid:Move(Vector3.zero, false)
                if PickupGeneration ~= flingToken then return end
                if not PickupRequested or not prompt.Parent or not prompt.Enabled or humanoid.Health <= 0 then
                    PickupRequested = false
                    SetTrackerStatus("FLING RECOVERY cancelled: prompt or character became unavailable.")
                    if AutoBreakEnabled and StartAutoBreak then StartAutoBreak() end
                    finishFlingRecovery()
                    return
                end
                promptPosition = positionOf(prompt) or promptPosition
                local finalPlayerDistance = (promptPosition - root.Position).Magnitude
                local finalLocationError = (promptPosition - recoveryPosition).Magnitude
                if finalPlayerDistance > math.min(prompt.MaxActivationDistance, 5) or finalLocationError > 14 then
                    PickupRequested = false
                    SetTrackerStatus(string.format("FLING RECOVERY blocked by location verification: player=%.1f studs, fling mismatch=%.1f studs.", finalPlayerDistance, finalLocationError))
                    if AutoBreakEnabled and StartAutoBreak then StartAutoBreak() end
                    finishFlingRecovery()
                    return
                end
                task.wait(0.15)
                if PickupGeneration ~= flingToken then return end
                promptPosition = positionOf(prompt) or promptPosition
                if LocalPlayer.Character ~= character or not character.Parent or humanoid.Health <= 0
                    or not prompt.Parent or not prompt.Enabled
                    or (promptPosition - root.Position).Magnitude > math.min(prompt.MaxActivationDistance, 5)
                    or (promptPosition - recoveryPosition).Magnitude > 14 then
                    PickupRequested = false
                    SetTrackerStatus("FLING RECOVERY blocked: prompt moved outside the verified pickup range.")
                    if AutoBreakEnabled and StartAutoBreak then StartAutoBreak() end
                    finishFlingRecovery()
                    return
                end
                local ok, err = pcall(function()
                    if typeof(fireproximityprompt) == "function" then
                        fireproximityprompt(prompt)
                    else
                        prompt:InputHoldBegin()
                        task.wait(prompt.HoldDuration + 0.1)
                        prompt:InputHoldEnd()
                    end
                end)
                if PickupGeneration ~= flingToken then return end
                if not ok then
                    pcall(function() prompt:InputHoldEnd() end)
                    PickupRequested = false
                    SetTrackerStatus("FLING RECOVERY pickup failed: " .. tostring(err))
                    if AutoBreakEnabled and StartAutoBreak then StartAutoBreak() end
                    finishFlingRecovery()
                    return
                end
                SetTrackerStatus("FLING RECOVERY prompt activated; confirming animal collection.")
                local confirmed = false
                local confirmDeadline = os.clock() + 4
                while not Runtime.Stopped and os.clock() < confirmDeadline and PickupGeneration == flingToken and PickupRequested do
                    local foundAtEventLocation = false
                    local folder = workspace:FindFirstChild("AnimalPickups")
                    if folder then
                        for _, animal in ipairs(folder:GetChildren()) do
                            local okPosition, animalPosition = pcall(function()
                                if animal:IsA("Model") then return animal:GetPivot().Position end
                                if animal:IsA("BasePart") then return animal.Position end
                            end)
                            if okPosition and animalPosition and (animalPosition - recoveryPosition).Magnitude <= 12 then
                                foundAtEventLocation = true
                                break
                            end
                        end
                        if not foundAtEventLocation then confirmed = true; break end
                    end
                    task.wait(0.1)
                end
                if PickupGeneration ~= flingToken then return end
                if not confirmed then
                    PickupRequested = false
                    SetTrackerStatus("FLING RECOVERY: prompt activated but collection was not confirmed; staying in place.")
                    if AutoBreakEnabled and StartAutoBreak then StartAutoBreak() end
                    finishFlingRecovery()
                    return
                end
                SetTrackerStatus("FLING RECOVERY collection confirmed; returning to base.")
                finishFlingRecovery()
                ReturnToPickup("Fling recovery pickup confirmed. Returning to base.")
            end)
        end)
        AnimalFolderConnection = workspace.ChildAdded:Connect(function(child)
            if child.Name == "AnimalPickups" and not AnimalPickups then
                BindAnimalPickups(child)
            end
        end)
        StopAutoBreak = function(reason, preserveTargetState)
            if MovementConnection then
                MovementConnection:Disconnect()
                MovementConnection = nil
            end
            local character = LocalPlayer.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            if humanoid and not PickupRequested and not ReturningAfterPickup then
                humanoid:Move(Vector3.zero, false)
            end
            ArrivedAtTarget = false
            if not preserveTargetState then
                WaitingForPickup = false
                CurrentTarget = nil
            end
            if reason then
                SetTrackerStatus(reason)
            end
        end
        StartAutoBreak = function(forceRefresh)
            if FlingRecoveryActive then
                SetTrackerStatus("Auto Break paused: fling recovery owns movement until the animal pickup attempt finishes.")
                return
            end
            if not AutoBreakEnabled then
                SetTrackerStatus("Auto Break start ignored: toggle is OFF.")
                return
            end
            if PickupRequested or ReturningAfterPickup then
                SetTrackerStatus("Auto Break start ignored: pickup/return is in progress.")
                return
            end
            if WaitingForPickup then
                SetTrackerStatus("Auto Break start ignored: broken target is waiting for its AnimalPickups entry.")
                return
            end
            if not forceRefresh and CurrentTarget and IsEggAvailable(CurrentTarget)
                and (MovementConnection ~= nil or ArrivedAtTarget) then
                return
            end
            StopAutoBreak()
            local selectedZoneNames = {}
            for zoneName, selected in pairs(SelectedZones) do
                if selected then
                    table.insert(selectedZoneNames, zoneName)
                end
            end
            if #selectedZoneNames == 0 then
                for _, zone in ipairs(ZoneBuilds:GetChildren()) do
                    if zone:IsA("Model") then
                        table.insert(selectedZoneNames, zone.Name)
                    end
                end
            end
            table.sort(selectedZoneNames)
            local target
            if TitanicPriorityEnabled then
                local weightCandidates = {}
                for _, zoneName in ipairs(selectedZoneNames) do
                    local zone = ZoneBuilds:FindFirstChild(zoneName)
                    local eggsFolder = zone and zone:FindFirstChild("Eggs")
                    if eggsFolder then
                        for _, egg in ipairs(eggsFolder:GetChildren()) do
                            if (egg:IsA("Model") or egg:IsA("BasePart"))
                                and egg.Name:lower():find("egg", 1, true)
                                and IsEggAvailable(egg) then
                                local eggName = GetEggTypeName(egg.Name)
                                if SelectedEggs[eggName] ~= false then
                                    local weightBracket = GetEggWeightBracket(egg)
                                    local hasWeightBracket = weightBracket ~= nil
                                        and tostring(weightBracket):match("%S") ~= nil
                                    local weightKg = nil
                                    if not hasWeightBracket then
                                        weightKg = GetEggWeightKg(egg)
                                    end
                                    if hasWeightBracket or weightKg then
                                        table.insert(weightCandidates, {
                                            egg = egg,
                                            weightBracket = hasWeightBracket and tostring(weightBracket) or nil,
                                            weightKg = weightKg,
                                            hasWeightBracket = hasWeightBracket
                                        })
                                    end
                                end
                            end
                        end
                    end
                end
                table.sort(weightCandidates, function(a, b)
                    if a.hasWeightBracket ~= b.hasWeightBracket then
                        return a.hasWeightBracket
                    end
                    if a.hasWeightBracket and b.hasWeightBracket then
                        local aTitanic = a.weightBracket:lower():find("titanic", 1, true) ~= nil
                        local bTitanic = b.weightBracket:lower():find("titanic", 1, true) ~= nil
                        if aTitanic ~= bTitanic then return aTitanic end
                        if a.weightBracket ~= b.weightBracket then
                            return a.weightBracket < b.weightBracket
                        end
                    elseif a.weightKg ~= b.weightKg then
                        return a.weightKg > b.weightKg
                    end
                    return a.egg.Name < b.egg.Name
                end)
                if #weightCandidates > 0 then
                    local selected = weightCandidates[1]
                    target = selected.egg
                    local detail = selected.hasWeightBracket
                        and ("WeightBracket=" .. selected.weightBracket)
                        or ("WeightBracket blank; WeightKg=" .. tostring(selected.weightKg))
                    SetTrackerStatus("TITANIC PRIORITY: selected " .. target.Name
                        .. " | " .. detail .. " before the normal egg route.")
                else
                    SetTrackerStatus("TITANIC PRIORITY is ON, but no eligible egg with WeightBracket or fallback weightKg was found in the selected zones.")
                end
            end
            if not target and SortOrder == "Highest Luck" then
                local luckCandidates = {}
                local unreadableLuckCount = 0
                for _, zoneName in ipairs(selectedZoneNames) do
                    local zone = ZoneBuilds:FindFirstChild(zoneName)
                    local eggsFolder = zone and zone:FindFirstChild("Eggs")
                    if eggsFolder then
                        for _, egg in ipairs(eggsFolder:GetChildren()) do
                            if (egg:IsA("Model") or egg:IsA("BasePart"))
                                and egg.Name:lower():find("egg", 1, true)
                                and IsEggAvailable(egg) then
                                local eggName = GetEggTypeName(egg.Name)
                                if SelectedEggs[eggName] ~= false then
                                    local luck = GetEggLuck(egg)
                                    if luck > 0 then
                                        table.insert(luckCandidates, {egg = egg, luck = luck})
                                    else
                                        unreadableLuckCount += 1
                                    end
                                end
                            end
                        end
                    end
                end
                table.sort(luckCandidates, function(a, b)
                    if a.luck ~= b.luck then return a.luck > b.luck end
                    return a.egg.Name < b.egg.Name
                end)
                if #luckCandidates > 0 then
                    target = luckCandidates[1].egg
                    SetTrackerStatus("HIGHEST LUCK PRIORITY: selected " .. target.Name
                        .. " | Luck=" .. tostring(luckCandidates[1].luck)
                        .. " | readable candidates=" .. tostring(#luckCandidates)
                        .. " | ignored unreadable=" .. tostring(unreadableLuckCount))
                else
                    SetTrackerStatus("HIGHEST LUCK PRIORITY is ON, but no readable positive luck values were found. Auto Break paused instead of choosing a random egg.")
                    AddDebugLog("[Auto Break] HighLuck found no readable positive luck values; normal egg fallback blocked.")
                    return
                end
            end
            if not target then
                local normalZoneNames = {}
                local preferredIsSelected = false
                if PreferredZoneName then
                    for _, zoneName in ipairs(selectedZoneNames) do
                        if zoneName == PreferredZoneName then
                            preferredIsSelected = true
                            break
                        end
                    end
                end
                if preferredIsSelected then
                    table.insert(normalZoneNames, PreferredZoneName)
                end
                for _, zoneName in ipairs(selectedZoneNames) do
                    if zoneName ~= PreferredZoneName then
                        table.insert(normalZoneNames, zoneName)
                    end
                end
                for _, zoneName in ipairs(normalZoneNames) do
                    if target then break end
                    local zone = ZoneBuilds:FindFirstChild(zoneName)
                    local eggsFolder = zone and zone:FindFirstChild("Eggs")
                    if eggsFolder then
                        for _, egg in ipairs(eggsFolder:GetChildren()) do
                            if (egg:IsA("Model") or egg:IsA("BasePart"))
                            and egg.Name:lower():find("egg", 1, true) then
                                local eggName = GetEggTypeName(egg.Name)
                                if SelectedEggs[eggName] ~= false and IsEggAvailable(egg) then
                                    target = egg
                                    break
                                end
                            end
                        end
                        if target then break end
                    end
                end
            end
            if not target then
                SetTrackerStatus("No target found. Select a zone and keep at least one egg type enabled.")
                return
            end
            local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local humanoid = character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid")
            local root = character:FindFirstChild("HumanoidRootPart") or character:WaitForChild("HumanoidRootPart")
            CurrentTarget = target
            local targetEggsFolder = target.Parent
            local targetZone = targetEggsFolder and targetEggsFolder.Parent
            if targetZone and targetZone.Parent == ZoneBuilds then
                PreferredZoneName = targetZone.Name
            end
            ArrivedAtTarget = false
            WaitingForPickup = false
            table.clear(BaselinePickups)
            if AnimalPickups then
                for _, pickup in ipairs(AnimalPickups:GetChildren()) do
                    BaselinePickups[pickup] = true
                end
            else
                SetTrackerStatus("AnimalPickups folder not created yet; waiting for it to appear.")
            end
            SetTrackerStatus("Moving to target: " .. target:GetFullName())
            MovementConnection = game:GetService("RunService").RenderStepped:Connect(function()
                -- Animal pickup/return movement always owns the character over egg movement.
                if PickupRequested or ReturningAfterPickup then
                    if MovementConnection then
                        MovementConnection:Disconnect()
                        MovementConnection = nil
                    end
                    return
                end
                if CurrentTarget ~= target or not IsEggAvailable(target) or not character.Parent
                or humanoid.Health <= 0 then
                    if CurrentTarget == target and (not IsEggAvailable(target) or humanoid.Health <= 0) then
                        CompletedEggs[target] = true
                        SetTrackerStatus("Target egg is no longer available or is already broken; refreshing the egg list.")
                        StopAutoBreak()
                        task.defer(function()
                            task.wait(0.2)
                            if AutoBreakEnabled and not PickupRequested and not ReturningAfterPickup then
                                StartAutoBreak()
                            end
                        end)
                    else
                        StopAutoBreak("Movement stopped: target/character unavailable.")
                    end
                    return
                end
                local targetPosition = target:GetPivot().Position
                local offset = Vector3.new(
                    targetPosition.X - root.Position.X,
                    0,
                    targetPosition.Z - root.Position.Z
                )
                if offset.Magnitude <= 4 then
                    humanoid:Move(Vector3.zero, false)
                    MovementConnection:Disconnect()
                    MovementConnection = nil
                    ArrivedAtTarget = true
                    SetTrackerStatus("ARRIVED | " .. target:GetFullName()
                        .. " | tracking matching EggHitConfirmed events now.")
                    return
                end
                humanoid:Move(offset.Unit, false)
            end)
        end
        RefreshTitanicPriority = function()
            if not AutoBreakEnabled or not CurrentTarget then return end
            if FlingRecoveryActive or PickupRequested or ReturningAfterPickup or WaitingForPickup then
                AddDebugLog("[Auto Break] Priority changed; will apply after the current pickup/recovery finishes.")
                return
            end
            AddDebugLog("[Auto Break] Refreshing target immediately for updated TITANIC priority.")
            task.defer(function()
                if AutoBreakEnabled and not FlingRecoveryActive and not PickupRequested
                    and not ReturningAfterPickup and not WaitingForPickup then
                    StartAutoBreak(true)
                end
            end)
        end
    elseif index == 5 then
        local ConsoleCard = CreateCard(Page, "Debug Console", "")
        ConsoleCard.Size = UDim2.new(1, 0, 0, 190)
        local consoleTitle = ConsoleCard:FindFirstChildWhichIsA("TextLabel")
        if consoleTitle then consoleTitle.Position = UDim2.fromOffset(11, 7); consoleTitle.TextSize = 10 end
        local ClearLogsButton = Create("TextButton", {
            Name = "ClearLogs",
            Parent = ConsoleCard,
            Position = UDim2.new(1, -75, 0, 10),
            Size = UDim2.fromOffset(56, 20),
            BackgroundColor3 = Theme.Selected,
            Text = "CLEAR",
            TextColor3 = Theme.SelectedText,
            Font = Enum.Font.GothamBold,
            TextSize = 9,
            BorderSizePixel = 0,
            AutoButtonColor = true
        })
        AddCorner(ClearLogsButton, 5)
        local ConsoleBackground = Create("Frame", {
            Name = "ConsoleBackground",
            Parent = ConsoleCard,
            Position = UDim2.fromOffset(10, 48),
            Size = UDim2.new(1, -20, 1, -58),
            BackgroundColor3 = Color3.fromRGB(20, 22, 26),
            BorderSizePixel = 0,
            ClipsDescendants = true
        })
        AddCorner(ConsoleBackground, 6)
        local ConsoleScroll = Create("ScrollingFrame", {
            Name = "ConsoleLogs",
            Parent = ConsoleBackground,
            Position = UDim2.fromOffset(5, 5),
            Size = UDim2.new(1, -10, 1, -10),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Theme.Gray,
            ScrollingDirection = Enum.ScrollingDirection.Y,
            AutomaticCanvasSize = Enum.AutomaticSize.None,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ClipsDescendants = true
        })
        DebugConsoleList = ConsoleScroll
        DebugConsoleLayout = Create("UIListLayout", {
            Parent = ConsoleScroll,
            Padding = UDim.new(0, 3),
            SortOrder = Enum.SortOrder.LayoutOrder
        })
        DebugConsoleLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            ConsoleScroll.CanvasSize = UDim2.new(0, 0, 0, DebugConsoleLayout.AbsoluteContentSize.Y + 8)
        end)
        ClearLogsButton.MouseButton1Click:Connect(function()
            for _, child in ipairs(ConsoleScroll:GetChildren()) do
                if child:IsA("TextLabel") then
                    child:Destroy()
                end
            end
            DebugLogCount = 0
            ConsoleScroll.CanvasPosition = Vector2.zero
            AddDebugLog("Console cleared.")
        end)
        AddDebugLog("Debug console ready.")

    elseif index == 2 then
        local ESPCard = CreateCard(Page, "Egg ESP", "")
        ESPCard.Size = UDim2.new(1, 0, 0, 125)
        local ESPStatus = Create("TextLabel", {
            Parent = ESPCard,
            Position = UDim2.fromOffset(15, 43),
            Size = UDim2.new(1, -30, 0, 30),
            BackgroundTransparency = 1,
            Text = "ESP is off",
            TextColor3 = Theme.Gray,
            Font = Enum.Font.Gotham,
            TextSize = 9,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top
        })
        local ESPEnabled = false
        local ESPObjects = {}
        local ESPFolder = Create("Folder", {Name = "BASE_Skrip_EggESP", Parent = LocalPlayer:WaitForChild("PlayerGui")})
        local function ClearEggESP(egg)
            local gui = ESPObjects[egg]
            if gui then
                gui:Destroy()
                ESPObjects[egg] = nil
            end
        end
        local function GetESPValue(object, names)
            if not object then return nil end
            local nodes = {object}
            for _, descendant in ipairs(object:GetDescendants()) do
                table.insert(nodes, descendant)
            end
            for _, name in ipairs(names) do
                for _, node in ipairs(nodes) do
                    local value = node:GetAttribute(name)
                    if value ~= nil then return tostring(value) end
                    if node.Name == name then
                        if node:IsA("ValueBase") then return tostring(node.Value) end
                        if (node:IsA("TextLabel") or node:IsA("TextButton") or node:IsA("TextBox")) and node.Text ~= "" then
                            return node.Text
                        end
                    end
                end
            end
            return nil
        end
        local function GetEggESPInfo(egg)
            local eggModel = egg:FindFirstChild("Egg") or egg
            local info = eggModel:FindFirstChild("EggInfoUi", true)
            local luck = GetESPValue(eggModel, {"LuckMulti", "Luck", "LuckMultiplier"})
                or GetESPValue(info, {"LuckMulti", "Luck", "LuckMultiplier"})
            if not luck and info then
                local luckList = info:FindFirstChild("LuckMultiList", true)
                local luckLabel = luckList and luckList:FindFirstChild("LuckMulti", true)
                if luckLabel and (luckLabel:IsA("TextLabel") or luckLabel:IsA("TextButton")) then
                    luck = luckLabel.Text
                end
            end
            local weightKG = GetESPValue(eggModel, {"WeightKg"})
                or GetESPValue(info, {"WeightKg"})
            local category = GetESPValue(eggModel, {"WeightBracket"})
                or GetESPValue(info, {"WeightBracket"})
            return luck or "?", weightKG or "?", category or "?"
        end
        local function UpdateEggESP()
            local build = workspace:FindFirstChild("Build")
            local zones = build and build:FindFirstChild("ZoneBuilds")
            if not zones then
                ESPStatus.Text = "Waiting for egg zones..."
                return
            end
            local seen = {}
            local count = 0
            for _, zone in ipairs(zones:GetChildren()) do
                local eggsFolder = zone:FindFirstChild("Eggs")
                if eggsFolder then
                    for _, egg in ipairs(eggsFolder:GetChildren()) do
                        if (egg:IsA("Model") or egg:IsA("BasePart")) and egg.Name:lower():find("egg", 1, true) then
                            local adornee = egg:IsA("BasePart") and egg or egg.PrimaryPart or egg:FindFirstChildWhichIsA("BasePart", true)
                            if adornee then
                                seen[egg] = true
                                count += 1
                                local gui = ESPObjects[egg]
                                if not gui or not gui.Parent then
                                    gui = Instance.new("BillboardGui")
                                    gui.Name = "EggESP"
                                    gui.Adornee = adornee
                                    gui.Size = UDim2.fromOffset(180, 44)
                                    gui.StudsOffset = Vector3.new(0, 3, 0)
                                    gui.AlwaysOnTop = true
                                    gui.MaxDistance = 250
                                    gui.Parent = ESPFolder
                                    local label = Instance.new("TextLabel")
                                    label.Name = "Info"
                                    label.Size = UDim2.fromScale(1, 1)
                                    label.BackgroundColor3 = Color3.fromRGB(20, 22, 26)
                                    label.BackgroundTransparency = 0.15
                                    label.BorderSizePixel = 0
                                    label.TextColor3 = Color3.fromRGB(255, 255, 255)
                                    label.TextStrokeTransparency = 0.45
                                    label.Font = Enum.Font.GothamBold
                                    label.TextSize = 11
                                    label.TextWrapped = true
                                    label.Parent = gui
                                    ESPObjects[egg] = gui
                                end
                                gui.Adornee = adornee
                                local luck, weightKG, category = GetEggESPInfo(egg)
                                gui.Size = UDim2.fromOffset(205, 58)
                                gui.Info.Text = egg.Name .. "\nLuck: " .. luck .. " | KG: " .. weightKG .. "\nCategory: " .. category
                            end
                        end
                    end
                end
            end
            for egg in pairs(ESPObjects) do
                if not seen[egg] or not egg.Parent then
                    ClearEggESP(egg)
                end
            end
            ESPStatus.Text = "ESP " .. (ESPEnabled and "ON" or "OFF") .. " | Eggs: " .. count
        end
        CreateToggle(ESPCard, "Show egg Luck + Size", false, function(enabled)
            ESPEnabled = enabled
            if enabled then
                ESPStatus.Text = "Scanning eggs..."
                task.spawn(function()
                    while not Runtime.Stopped and ESPEnabled and not ScriptShuttingDown do
                        UpdateEggESP()
                        task.wait(0.75)
                    end
                end)
            else
                for egg in pairs(ESPObjects) do
                    ClearEggESP(egg)
                end
                ESPStatus.Text = "ESP is off"
            end
        end)
        ESPCard.Size = UDim2.new(1, 0, 0, 125)

    elseif index == 3 then
        local AnimalsCard = CreateCard(Page, "Placed Animals", "")
        AnimalsCard.Size = UDim2.new(1, 0, 0, 230)
        local animalsTitle = AnimalsCard:FindFirstChildWhichIsA("TextLabel")
        if animalsTitle then animalsTitle.Position = UDim2.fromOffset(15, 10) end
        local BaseStatus = Create("TextLabel", {
            Parent = AnimalsCard, Position = UDim2.fromOffset(15, 42),
            Size = UDim2.new(1, -30, 0, 18), BackgroundTransparency = 1,
            Text = "Searching for Your Base...", TextColor3 = Theme.Gray,
            Font = Enum.Font.Gotham, TextSize = 9, TextXAlignment = Enum.TextXAlignment.Left
        })
        local AnimalsList = Create("ScrollingFrame", {
            Parent = AnimalsCard, Position = UDim2.fromOffset(10, 64),
            Size = UDim2.new(1, -20, 1, -74), BackgroundColor3 = Theme.SurfaceInput,
            BorderSizePixel = 0, ScrollBarThickness = 3, ScrollBarImageColor3 = Theme.Gray,
            CanvasSize = UDim2.new(0, 0, 0, 0)
        })
        AddCorner(AnimalsList, 6)
        local AnimalsLayout = Create("UIListLayout", {Parent = AnimalsList, Padding = UDim.new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder})
        Create("UIPadding", {Parent = AnimalsList, PaddingTop = UDim.new(0, 5), PaddingBottom = UDim.new(0, 5), PaddingLeft = UDim.new(0, 5), PaddingRight = UDim.new(0, 5)})
        local function FindOwnedBase()
            local plots = workspace:FindFirstChild("Plots")
            if not plots then return nil end
            for _, base in ipairs(plots:GetChildren()) do
                local hitbox = base:FindFirstChild("Hitbox")
                local info = hitbox and hitbox:FindFirstChild("PlayerInfoUi")
                local nameLabel = info and info:FindFirstChild("Name")
                if nameLabel and nameLabel:IsA("TextLabel") and nameLabel.Text == "Your Base" then return base end
            end
            return nil
        end
        local function ReadCPS(animal)
            for _, item in ipairs(animal:GetDescendants()) do
                if item.Name == "CashPerSecond" and item:IsA("TextLabel") then
                    local display = item.Text
                    local raw = display:gsub(",", ""):gsub("%s+", "")
                    local number = tonumber(raw:match("[%d%.]+"))
                    local suffix = raw:match("[KkMmBbTt]$")
                    local scale = ({k=1e3,m=1e6,b=1e9,t=1e12})[suffix and suffix:lower() or ""]
                    return number and number * (scale or 1) or -1, display
                end
            end
            return -1, "CPS unavailable"
        end
        local function RefreshPlacedAnimals()
            for _, child in ipairs(AnimalsList:GetChildren()) do
                if child:IsA("TextLabel") or child:IsA("Frame") then child:Destroy() end
            end
            local base = FindOwnedBase()
            if not base then
                BaseStatus.Text = "Your Base not found"
                local waiting = Create("TextLabel", {Parent = AnimalsList, Size = UDim2.new(1, -8, 0, 28), BackgroundTransparency = 1, Text = "Waiting for Your Base...", TextColor3 = Theme.Gray, Font = Enum.Font.Gotham, TextSize = 9, LayoutOrder = 1})
                return
            end
            local placed = base:FindFirstChild("PlacedAnimals")
            BaseStatus.Text = base.Name .. (placed and " | Placed animals" or " | PlacedAnimals not found")
            if not placed then return end
            local records = {}
            for _, animal in ipairs(placed:GetChildren()) do
                local value, display = ReadCPS(animal)
                table.insert(records, {name = animal.Name, value = value, display = display})
            end
            table.sort(records, function(a, b) if a.value == b.value then return a.name < b.name end return a.value > b.value end)
            if #records == 0 then
                Create("TextLabel", {Parent = AnimalsList, Size = UDim2.new(1, -8, 0, 28), BackgroundTransparency = 1, Text = "No placed animals found.", TextColor3 = Theme.Gray, Font = Enum.Font.Gotham, TextSize = 9, LayoutOrder = 1})
            end
            for order, record in ipairs(records) do
                local row = Create("TextLabel", {Parent = AnimalsList, Size = UDim2.new(1, -8, 0, 25), BackgroundColor3 = Theme.Card, BorderSizePixel = 0, Text = "  " .. record.name .. "  |  " .. record.display, TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 9, TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = order})
                AddCorner(row, 4)
            end
            AnimalsList.CanvasSize = UDim2.new(0, 0, 0, AnimalsLayout.AbsoluteContentSize.Y + 10)
        end
        AnimalsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            AnimalsList.CanvasSize = UDim2.new(0, 0, 0, AnimalsLayout.AbsoluteContentSize.Y + 10)
        end)
        task.spawn(function()
            while not Runtime.Stopped and ScreenGui.Parent and Page.Parent do
                RefreshPlacedAnimals()
                task.wait(2)
            end
        end)

    elseif index == 4 then
        local PickupCard = CreateCard(Page, "Animal Pick ups", "")
        PickupCard.Size = UDim2.new(1, 0, 0, 230)
        local pickupTitle = PickupCard:FindFirstChildWhichIsA("TextLabel")
        if pickupTitle then pickupTitle.Position = UDim2.fromOffset(15, 10) end
        local PickupStatus = Create("TextLabel", {
            Parent = PickupCard, Position = UDim2.fromOffset(15, 42),
            Size = UDim2.new(1, -30, 0, 18), BackgroundTransparency = 1,
            Text = "Waiting for AnimalPickups...", TextColor3 = Theme.Gray,
            Font = Enum.Font.Gotham, TextSize = 9, TextXAlignment = Enum.TextXAlignment.Left
        })
        local PickupList = Create("ScrollingFrame", {
            Parent = PickupCard, Position = UDim2.fromOffset(10, 64),
            Size = UDim2.new(1, -20, 1, -74), BackgroundColor3 = Theme.SurfaceInput,
            BorderSizePixel = 0, ScrollBarThickness = 3, ScrollBarImageColor3 = Theme.Gray,
            CanvasSize = UDim2.new(0, 0, 0, 0)
        })
        AddCorner(PickupList, 6)
        local PickupLayout = Create("UIListLayout", {Parent = PickupList, Padding = UDim.new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder})
        Create("UIPadding", {Parent = PickupList, PaddingTop = UDim.new(0, 5), PaddingBottom = UDim.new(0, 5), PaddingLeft = UDim.new(0, 5), PaddingRight = UDim.new(0, 5)})
        local function RefreshAnimalPickups()
            for _, child in ipairs(PickupList:GetChildren()) do
                if child:IsA("TextLabel") or child:IsA("Frame") then child:Destroy() end
            end
            local folder = workspace:FindFirstChild("AnimalPickups")
            if not folder then
                PickupStatus.Text = "AnimalPickups folder not found"
                Create("TextLabel", {Parent = PickupList, Size = UDim2.new(1, -8, 0, 28), BackgroundTransparency = 1, Text = "Waiting for AnimalPickups...", TextColor3 = Theme.Gray, Font = Enum.Font.Gotham, TextSize = 9, LayoutOrder = 1})
                return
            end
            PickupStatus.Text = tostring(#folder:GetChildren()) .. " animals | tracking status per pickup"
            local records = {}
            for _, pickup in ipairs(folder:GetChildren()) do
                local state = pickup:GetAttribute("BASAE_CPSCheckStatus") or "Not checked"
                local cps = pickup:GetAttribute("BASAE_CPSCheckValue")
                table.insert(records, {name = pickup.Name, state = tostring(state), cps = cps and tostring(cps) or ""})
            end
            table.sort(records, function(a, b)
                if a.state == b.state then return a.name < b.name end
                return a.state < b.state
            end)
            if #records == 0 then
                Create("TextLabel", {Parent = PickupList, Size = UDim2.new(1, -8, 0, 28), BackgroundTransparency = 1, Text = "No animal pickups found.", TextColor3 = Theme.Gray, Font = Enum.Font.Gotham, TextSize = 9, LayoutOrder = 1})
            end
            for order, record in ipairs(records) do
                local detail = record.cps ~= "" and (" | CPS: " .. record.cps) or ""
                local row = Create("TextLabel", {Parent = PickupList, Size = UDim2.new(1, -8, 0, 30), BackgroundColor3 = Theme.Card, BorderSizePixel = 0, Text = "  " .. record.name .. "  |  " .. record.state .. detail, TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 9, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, TextWrapped = true, TextTruncate = Enum.TextTruncate.None, AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = order})
                AddCorner(row, 4)
            end
            PickupList.CanvasSize = UDim2.new(0, 0, 0, PickupLayout.AbsoluteContentSize.Y + 10)
        end
        PickupLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            PickupList.CanvasSize = UDim2.new(0, 0, 0, PickupLayout.AbsoluteContentSize.Y + 10)
        end)
        task.spawn(function()
            while not Runtime.Stopped and ScreenGui.Parent and Page.Parent do
                RefreshAnimalPickups()
                task.wait(2)
            end
        end)

    else
        local Card1 = CreateCard(Page, name, "This is a reusable UI page. Backend code is not connected.")
        CreateButton(Card1, "Example Button", function()
            -- Put your actual function here.
        end)
        local Card2 = CreateCard(Page, "Example Settings", "Example controls that only change the UI state.")
        CreateToggle(Card2, "Example Toggle", false, function(state)
            -- state = true / false
        end)
        local Card3 = CreateCard(Page, "Example Options", "Dropdown and slider examples.")
        CreateDropdown(Card3, "Mode", {"Option 1", "Option 2", "Option 3"}, function(selection)
            -- selection contains the selected option.
        end)
        CreateSlider(Card3, "Example Slider", 0, 100, 50, function(value)
            -- value contains the current slider value.
        end)
    end
end
-- SHOW FIRST PAGE
Pages[1].Visible = true
SidebarButtons[1].BackgroundColor3 = Theme.Selected
SidebarButtons[1].TextColor3 = Theme.SelectedText
-- MINIMIZE
local Minimized = false
local function SetMinimized(state)
    Minimized = state
    if Minimized then
        Content.Visible = false
        Sidebar.Visible = false
        TopBar.Visible = false
        RestoreButton.Visible = true
        MainCorner.CornerRadius = UDim.new(0, 18)
        Tween(Main, {Size = UDim2.fromOffset(36, 36)})
    else
        RestoreButton.Visible = false
        MainCorner.CornerRadius = UDim.new(0, 12)
        Tween(Main, {Size = UDim2.fromOffset(UIConfig.Width, UIConfig.Height)})
        TopBar.Visible = true
        Content.Visible = true
        Sidebar.Visible = true
    end
end
MinimizeButton.MouseButton1Click:Connect(function()
    SetMinimized(true)
end)
RestoreButton.MouseButton1Click:Connect(function()
    SetMinimized(false)
end)
-- CLOSE
CloseButton.MouseButton1Click:Connect(function()
    if ShutdownAutomation then ShutdownAutomation() end
    ScreenGui:Destroy()
end)
-- DRAGGING
local Dragging = false
local DragStart
local StartPosition
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        Dragging = true
        DragStart = input.Position
        StartPosition = Main.Position
    end
end)
RestoreButton.InputBegan:Connect(function(input)
    if Minimized and (input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch) then
        Dragging = true
        DragStart = input.Position
        StartPosition = Main.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if not Dragging then
        return
    end
    if input.UserInputType ~= Enum.UserInputType.MouseMovement
    and input.UserInputType ~= Enum.UserInputType.Touch then
        return
    end
    local Delta = input.Position - DragStart
    Main.Position = UDim2.new(
        StartPosition.X.Scale,
        StartPosition.X.Offset + Delta.X,
        StartPosition.Y.Scale,
        StartPosition.Y.Offset + Delta.Y
    )
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        Dragging = false
    end
end)


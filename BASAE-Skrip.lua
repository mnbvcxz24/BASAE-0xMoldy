-- REUSABLE UI TEMPLATE
-- SERVICES
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local testver = "Test v1.52"
-- UI CONFIGURATION
local UIConfig = {
    Title = "BASAE-Skrip",
    Subtitle = testver,
    Width = 300,
    Height = 300,
    SidebarWidth = 94,
    SidebarNames = {
        "Auto",
        "Debug Console",
        "Placed Animals"
        -- Future sidebar slots:
        -- "Sidebar 4",
        -- "Sidebar 5"
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
-- REMOVE OLD UI
pcall(function()
    local oldUI = game.CoreGui:FindFirstChild("BASAESkripUI")
    if oldUI then
        oldUI:Destroy()
    end
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
local SidebarLayout = Create("UIListLayout", {
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
    local LogLine = Create("TextLabel", {
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
    local CardTitle = Create("TextLabel", {
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
    local CardDescription = Create("TextLabel", {
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
    local function Update()
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
        if callback then
            callback(Enabled)
        end
    end
    Toggle.MouseButton1Click:Connect(function()
        Enabled = not Enabled
        Update()
    end)
    Update()
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
    local Arrow = Create("TextLabel", {
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
-- CREATE ALL PAGES
for index, name in ipairs(UIConfig.SidebarNames) do
    local Page = CreatePage(index, name)
    if index == 1 then
        local Card1 = CreateCard(Page, "Auto break", "")
        Card1.Size = UDim2.new(1, 0, 0, 114)
        local StartAutoBreak
        local StopAutoBreak
        local CompletedEggs = {}
        local AutoBreakToggleInitialized = false
        local AutoBreakToggle = CreateToggle(Card1, "", false, function(enabled)
            if not AutoBreakToggleInitialized then
                AutoBreakToggleInitialized = true
                return
            end
            AddDebugLog("[Auto Break] Toggle " .. (enabled and "ON" or "OFF"))
            if enabled then
                if StartAutoBreak then StartAutoBreak() end
            elseif StopAutoBreak then
                StopAutoBreak("Toggle disabled")
            end
        end)
        AutoBreakToggle.Position = UDim2.new(1, -68, 0, 10)
        AutoBreakToggle.Size = UDim2.fromOffset(58, 26)
        local AutoPickupCard = CreateCard(Page, "Auto pickup", "")
        AutoPickupCard.Size = UDim2.new(1, 0, 0, 142)
        local AutoPickupEnabled = false
        local AutoPickupToggle = CreateToggle(AutoPickupCard, "", false, function(enabled)
            AutoPickupEnabled = enabled
            AddDebugLog("[Auto Pickup] " .. (enabled and "Monitoring ON." or "Monitoring OFF."))
        end)
        AutoPickupToggle.Position = UDim2.new(1, -68, 0, 10)
        AutoPickupToggle.Size = UDim2.fromOffset(58, 26)
        local RarityFilterOpen = false
        local RarityOptions = {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "Cosmic", "Secret", "Eternal", "Divine", "Celestial", "Inferno"}
        local SelectedRarities = {}
        for _, rarityName in ipairs(RarityOptions) do
            SelectedRarities[rarityName] = true
        end
        local RarityList
        local RarityFilterButton
        RarityFilterButton = CreateButton(AutoPickupCard, "Filter for Rarity  ▼", function()
            RarityFilterOpen = not RarityFilterOpen
            AutoPickupCard.Size = UDim2.new(1, 0, 0, RarityFilterOpen and 270 or 142)
            RarityFilterButton.Text = RarityFilterOpen and "Filter for Rarity  ▲" or "Filter for Rarity  ▼"
            RarityList.Visible = RarityFilterOpen
        end)
        RarityFilterButton.Position = UDim2.fromOffset(11, 43)
        RarityFilterButton.Size = UDim2.new(1, -22, 0, 26)
        local HighestCashEnabled = false
        local HighestCashToggle = CreateToggle(AutoPickupCard, "Highest CPS", false, function(enabled)
            HighestCashEnabled = enabled
            AddDebugLog("[Auto Pickup] " .. (enabled and "Highest CPS filter ON." or "Highest CPS filter OFF."))
        end)
        HighestCashToggle.Position = UDim2.fromOffset(11, 73)
        HighestCashToggle.Size = UDim2.new(1, -22, 0, 26)
        RarityList = Create("ScrollingFrame", {
            Name = "RarityFilterContainer",
            Parent = AutoPickupCard,
            Position = UDim2.fromOffset(11, 104),
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
            local RarityLabel = Create("TextLabel", {
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
            Card1.Size = UDim2.new(1, 0, 0, (EggFilterOpen or ZoneFilterOpen) and 224 or 114)
            SortFrame.Position = UDim2.fromOffset(15, 78)
            SortFrame.Size = UDim2.new(1, -30, 0, 30)
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
            Size = UDim2.new(1, -30, 0, 30),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Visible = true
        })
        Create("TextLabel", {
            Parent = SortFrame,
            Size = UDim2.fromOffset(42, 28),
            BackgroundTransparency = 1,
            Text = "Sort",
            TextColor3 = Theme.Gray,
            Font = Enum.Font.Gotham,
            TextSize = 9,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        local function UpdateSortButtons()
            local selected = SortOrder == "Highest Luck"
            SortLargestButton.BackgroundColor3 = selected and Theme.Selected or Theme.SurfaceInput
            SortLargestButton.TextColor3 = selected and Theme.SelectedText or Theme.Gray
            SortLargestButton.Text = (selected and "● " or "○ ") .. "Highest Luck"
        end
        SortLargestButton = Create("TextButton", {
            Name = "SortHighestLuck",
            Parent = SortFrame,
            Position = UDim2.fromOffset(46, 2),
            Size = UDim2.new(1, -52, 0, 26),
            BackgroundColor3 = Theme.Selected,
            Text = "● Highest Luck",
            TextColor3 = Theme.SelectedText,
            Font = Enum.Font.Gotham,
            TextSize = 9,
            BorderSizePixel = 0,
            AutoButtonColor = false
        })
        AddCorner(SortLargestButton, 5)
        SortSmallestButton = Create("TextButton", {
            Name = "SortSmallest",
            Parent = SortFrame,
            Visible = false,
            Size = UDim2.fromOffset(0, 0),
            BackgroundTransparency = 1,
            Text = "",
            BorderSizePixel = 0
        })
        local function GetEggTypeName(name)
            return (name:gsub("^%d+:%s*", ""))
        end
        local function GetEggLuck(egg)
            local eggModel = egg:FindFirstChild("Egg") or egg
            local info = eggModel:FindFirstChild("EggInfoUi", true)
            local luckLabel = info and info:FindFirstChild("LuckMultiList", true)
            luckLabel = luckLabel and luckLabel:FindFirstChild("LuckMulti", true)
            if not luckLabel then return 0 end
            local rawLuck = (luckLabel:IsA("TextLabel") or luckLabel:IsA("TextButton")) and luckLabel.Text or luckLabel:GetAttribute("LuckMulti")
            if type(rawLuck) ~= "string" and type(rawLuck) ~= "number" then
                rawLuck = luckLabel:GetAttribute("LuckMulti")
            end
            local luck = tonumber(tostring(rawLuck or ""):match("[%d%.]+"))
            return luck or 0
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
                if a.luck == b.luck then
                    return a.name < b.name
                end
                return a.luck > b.luck
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
        SortLargestButton.MouseButton1Click:Connect(function()
            SortOrder = "Highest Luck"
            UpdateSortButtons()
            RefreshEggList()
        end)
        UpdateSortButtons()
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
        local BaselinePickups = {}
        local PickupRequested = false
        local ReturningAfterPickup = false
        local HitEvent = game:GetService("ReplicatedStorage"):WaitForChild("EggHitConfirmed")
        local AnimalPickups = workspace:FindFirstChild("AnimalPickups")
        local SetTrackerStatus
        local AnimalBankedRemote = game:GetService("ReplicatedStorage"):WaitForChild("AnimalBankedRemote")
        local ReturnPosition = Vector3.new(-29.243687, 3.5, -14.755682)
        AnimalBankedRemote.OnClientEvent:Connect(function()
            if not PickupRequested or ReturningAfterPickup then
                return
            end
            PickupRequested = false
            ReturningAfterPickup = true
            SetTrackerStatus("AnimalBankedRemote confirmed the pet reached the base. Returning to the pickup point.")
            task.spawn(function()
                local character = LocalPlayer.Character
                local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                local root = character and character:FindFirstChild("HumanoidRootPart")
                if not humanoid or not root then
                    ReturningAfterPickup = false
                    SetTrackerStatus("Return failed: character or HumanoidRootPart unavailable.")
                    return
                end
                local started = os.clock()
                while character.Parent and humanoid.Health > 0 and (root.Position - ReturnPosition).Magnitude > 4 do
                    if os.clock() - started > 25 then
                        humanoid:Move(Vector3.zero, false)
                        ReturningAfterPickup = false
                        SetTrackerStatus("Return timed out before reaching the pickup point.")
                        return
                    end
                    local offset = Vector3.new(ReturnPosition.X - root.Position.X, 0, ReturnPosition.Z - root.Position.Z)
                    if offset.Magnitude > 0 then
                        local direction = root.CFrame:VectorToObjectSpace(offset.Unit)
                        humanoid:Move(Vector3.new(direction.X, 0, direction.Z), true)
                    end
                    game:GetService("RunService").Heartbeat:Wait()
                end
                humanoid:Move(Vector3.zero, false)
                ReturningAfterPickup = false
                SetTrackerStatus("Returned to pickup point.")
                if AutoBreakToggleInitialized and StartAutoBreak then
                    task.wait(0.2)
                    StartAutoBreak()
                end
            end)
        end)
        local function IsTargetReference(reference, target)
            if reference == target then
                return true
            end
            if typeof(reference) == "Instance" and typeof(target) == "Instance" then
                if reference:IsDescendantOf(target) then
                    return true
                end
                local nestedEgg = target:FindFirstChild("Egg", true)
                if nestedEgg and reference == nestedEgg then
                    return true
                end
            end
            return false
        end
        SetTrackerStatus = function(message)
            AddDebugLog("[Egg Tracker] " .. tostring(message))
        end
        HitEvent.OnClientEvent:Connect(function(eggReference, hitCounter, health)
            local target = CurrentTarget
            if not target or not ArrivedAtTarget then
                return
            end
            if not IsTargetReference(eggReference, target) then
                return
            end
            SetTrackerStatus("MATCH | target=" .. target:GetFullName()
                .. " | counter=" .. tostring(hitCounter)
                .. " | health=" .. tostring(health))
            if tonumber(health) and tonumber(health) <= 0 then
                CompletedEggs[target] = true
                WaitingForPickup = true
                SetTrackerStatus("Target health reached 0; watching AnimalPickups for a new pet.")
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
        local function GetPetCPS(pickup)
            for _, item in ipairs(pickup:GetDescendants()) do
                if item.Name == "CashPerSecond" and item:IsA("TextLabel") then
                    local raw = item.Text:gsub(",", ""):gsub("%s+", "")
                    local number = tonumber(raw:match("[%d%.]+"))
                    local suffix = raw:match("[KkMmBbTt]$")
                    local scale = ({k=1e3,m=1e6,b=1e9,t=1e12})[suffix and suffix:lower() or ""]
                    return number and number * (scale or 1) or -1, item.Text
                end
            end
            return -1, "CPS unavailable"
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
        local function GetHighestPlacedCPS()
            local plots = workspace:FindFirstChild("Plots")
            if not plots then return -1 end
            for _, base in ipairs(plots:GetChildren()) do
                local hitbox = base:FindFirstChild("Hitbox")
                local info = hitbox and hitbox:FindFirstChild("PlayerInfoUi")
                local nameLabel = info and info:FindFirstChild("Name")
                if nameLabel and nameLabel:IsA("TextLabel") and nameLabel.Text == "Your Base" then
                    local placed = base:FindFirstChild("PlacedAnimals")
                    local highest = -1
                    if placed then
                        for _, animal in ipairs(placed:GetChildren()) do
                            local value = GetPetCPS(animal)
                            if value > highest then highest = value end
                        end
                    end
                    return highest
                end
            end
            return -1
        end
        local function RejectPickupAndRestart(message)
            if CurrentTarget then
                CompletedEggs[CurrentTarget] = true
            end
            PickupRequested = false
            SetTrackerStatus(message .. " | skipping egg and searching for another.")
            task.defer(function()
                if StopAutoBreak then
                    StopAutoBreak()
                end
                task.wait(0.2)
                if StartAutoBreak then
                    StartAutoBreak()
                end
            end)
        end
        local function EvaluatePickup(pickup)
            if not AutoPickupEnabled then
                SetTrackerStatus("New pet detected (Auto Pickup OFF): " .. pickup.Name)
                return
            end
            if not IsRarityAllowed(pickup) then
                RejectPickupAndRestart("Filtered out " .. pickup.Name .. " | rarity=" .. tostring(GetPetRarity(pickup) or "unknown"))
                return
            end
            local petZone = GetPickupZone(pickup)
            local targetZone = CurrentTarget and CurrentTarget.Parent and CurrentTarget.Parent.Parent
            local targetZoneName = targetZone and targetZone.Name
            if petZone and targetZoneName and petZone:lower() ~= targetZoneName:lower() then
                RejectPickupAndRestart("Filtered out " .. pickup.Name .. " | zone=" .. petZone .. " (target zone " .. targetZoneName .. ")")
                return
            end
            local cps, cpsText = GetPetCPS(pickup)
            if HighestCashEnabled then
                local highestPlaced = GetHighestPlacedCPS()
                if highestPlaced >= 0 and cps <= highestPlaced then
                    RejectPickupAndRestart("Filtered out " .. pickup.Name .. " | CPS " .. cpsText .. " is not above your highest placed CPS.")
                    return
                end
            end
            local prompt
            local promptState = "Could not map target egg to a workspace child"
            local eggRoot = CurrentTarget
            while eggRoot and eggRoot.Parent and eggRoot.Parent ~= workspace do
                eggRoot = eggRoot.Parent
            end
            local eggIndex
            if eggRoot and eggRoot.Parent == workspace then
                for index, child in ipairs(workspace:GetChildren()) do
                    if child == eggRoot then
                        eggIndex = index
                        break
                    end
                end
            end
            local promptDeadline = os.clock() + 5
            repeat
                local workspaceChild = eggIndex and workspace:GetChildren()[eggIndex]
                prompt = workspaceChild and workspaceChild:FindFirstChild("StealPrompt")
                if prompt and not prompt:IsA("ProximityPrompt") then
                    promptState = "StealPrompt exists at workspace child " .. tostring(eggIndex) .. " but is " .. prompt.ClassName
                    prompt = nil
                    break
                elseif prompt and prompt.Enabled then
                    promptState = "ready at workspace child " .. tostring(eggIndex)
                    break
                elseif prompt then
                    promptState = "StealPrompt exists at workspace child " .. tostring(eggIndex) .. " but Enabled=false"
                else
                    promptState = eggIndex and ("StealPrompt not found at workspace child " .. tostring(eggIndex)) or "target egg has no direct workspace child index"
                end
                task.wait(0.25)
            until os.clock() >= promptDeadline
            if not prompt or not prompt:IsA("ProximityPrompt") or not prompt.Enabled then
                SetTrackerStatus("Eligible pet " .. pickup.Name .. " but indexed pickup prompt unavailable after 5s: " .. promptState .. ".")
                return
            end
            if PickupRequested or ReturningAfterPickup then
                SetTrackerStatus("Eligible pet " .. pickup.Name .. " but a pickup/return is already in progress.")
                return
            end
            PickupRequested = true
            SetTrackerStatus("ELIGIBLE PET: " .. pickup.Name .. " | rarity=" .. tostring(GetPetRarity(pickup) or "unknown")
                .. " | zone=" .. tostring(petZone or "unknown") .. " | CPS=" .. cpsText .. " | holding StealPrompt.")
            task.spawn(function()
                local ok, err = pcall(function()
                    prompt:InputHoldBegin()
                    task.wait(prompt.HoldDuration + 0.1)
                    prompt:InputHoldEnd()
                end)
                if not ok then
                    PickupRequested = false
                    SetTrackerStatus("StealPrompt hold failed: " .. tostring(err))
                    return
                end
                SetTrackerStatus("StealPrompt hold sent; waiting for AnimalBankedRemote confirmation.")
                task.wait(8)
                if PickupRequested then
                    PickupRequested = false
                    SetTrackerStatus("No AnimalBankedRemote confirmation within 8 seconds; stopping this pickup attempt.")
                end
            end)
        end
        local function BindAnimalPickups(folder)
            if not folder or not folder:IsA("Folder") and not folder:IsA("Model") then
                return
            end
            AnimalPickups = folder
            folder.ChildAdded:Connect(function(pickup)
                if not WaitingForPickup or BaselinePickups[pickup] then
                    return
                end
                WaitingForPickup = false
                SetTrackerStatus("NEW PET after target egg break: " .. pickup.Name .. " | class=" .. pickup.ClassName)
                task.defer(function()
                    if pickup.Parent then
                        EvaluatePickup(pickup)
                    end
                end)
            end)
            SetTrackerStatus("AnimalPickups folder detected and connected.")
        end
        if AnimalPickups then
            BindAnimalPickups(AnimalPickups)
        end
        workspace.ChildAdded:Connect(function(child)
            if child.Name == "AnimalPickups" and not AnimalPickups then
                BindAnimalPickups(child)
            end
        end)
        StopAutoBreak = function(reason)
            if MovementConnection then
                MovementConnection:Disconnect()
                MovementConnection = nil
            end
            local character = LocalPlayer.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:Move(Vector3.zero, false)
            end
            ArrivedAtTarget = false
            WaitingForPickup = false
            CurrentTarget = nil
            if reason then
                SetTrackerStatus(reason)
            end
        end
        StartAutoBreak = function()
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
            for _, zoneName in ipairs(selectedZoneNames) do
                local zone = ZoneBuilds:FindFirstChild(zoneName)
                local eggsFolder = zone and zone:FindFirstChild("Eggs")
                if eggsFolder then
                    for _, egg in ipairs(eggsFolder:GetChildren()) do
                        if (egg:IsA("Model") or egg:IsA("BasePart"))
                        and egg.Name:lower():find("egg", 1, true) then
                            local eggName = GetEggTypeName(egg.Name)
                            if SelectedEggs[eggName] ~= false and not CompletedEggs[egg] then
                                target = egg
                                break
                            end
                        end
                    end
                    if target then break end
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
                if CurrentTarget ~= target or not target.Parent or not character.Parent
                or humanoid.Health <= 0 then
                    StopAutoBreak("Movement stopped: target/character unavailable.")
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
                local localDirection = root.CFrame:VectorToObjectSpace(offset.Unit)
                humanoid:Move(Vector3.new(localDirection.X, 0, localDirection.Z), true)
            end)
        end
    elseif index == 2 then
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
            while ScreenGui.Parent and Page.Parent do
                RefreshPlacedAnimals()
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
-- SEARCH
-- UI-only search; connect it to page controls when needed.
SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local Query = SearchBox.Text:lower()
    -- BACKEND/UI SEARCH PLACEHOLDER
    --
    -- Later we can make this search buttons, cards,
    -- features, or pages.
end)
-- BACKEND PLACEHOLDER
-- Add script-specific functions here and connect them to the UI callbacks above.

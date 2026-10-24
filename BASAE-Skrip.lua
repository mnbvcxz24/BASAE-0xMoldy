-- REUSABLE UI TEMPLATE
-- SERVICES
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local testver = "Test v1.13"
-- UI CONFIGURATION
local UIConfig = {
    Title = "BASAE-Skrip",
    Subtitle = testver,
    Width = 250,
    Height = 300,
    SidebarWidth = 72,
    SidebarNames = {
        "Auto",
        "Sidebar 2",
        "Sidebar 3",
        "Sidebar 4",
        "Sidebar 5"
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
    TextSize = 13,
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
    TextSize = 11,
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
    TextSize = 15,
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
    TextSize = 17,
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
    TextSize = 16,
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
        -UIConfig.SidebarWidth,
        1,
        -48
    ),
    BackgroundColor3 = Theme.Background,
    BorderSizePixel = 0
})
-- PAGE SYSTEM
local Pages = {}
local SidebarButtons = {}
local CurrentPage = 1
-- CREATE PAGE
local function CreatePage(pageNumber, pageName)
    local Page = Create("ScrollingFrame", {
        Name = "Page_" .. pageNumber,
        Parent = Content,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Theme.Gray,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Visible = false,
        ClipsDescendants = true
    })
    AddCorner(Page, 10)
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
        Page.CanvasSize = UDim2.new(
            0,
            0,
            0,
            Layout.AbsoluteContentSize.Y + 24
        )
    end)
    Pages[pageNumber] = Page
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
        Position = UDim2.fromOffset(15, 12),
        Size = UDim2.new(1, -30, 0, 22),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Theme.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    local CardDescription = Create("TextLabel", {
        Parent = Card,
        Position = UDim2.fromOffset(15, 37),
        Size = UDim2.new(1, -30, 0, 40),
        BackgroundTransparency = 1,
        Text = description or "",
        TextColor3 = Theme.Gray,
        Font = Enum.Font.Gotham,
        TextSize = 10,
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
        Size = UDim2.new(1, -30, 0, 34),
        Position = UDim2.fromOffset(15, 68),
        BackgroundColor3 = Theme.Selected,
        Text = text,
        TextColor3 = Theme.SelectedText,
        Font = Enum.Font.GothamMedium,
        TextSize = 10,
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
        Size = UDim2.new(1, -30, 0, 34),
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
        TextSize = 11,
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
        Size = UDim2.new(1, -30, 0, 34),
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
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    local Arrow = Create("TextLabel", {
        Parent = Dropdown,
        Position = UDim2.new(1, -25, 0, 0),
        Size = UDim2.fromOffset(20, 34),
        BackgroundTransparency = 1,
        Text = "v",
        TextColor3 = Theme.Gray,
        Font = Enum.Font.GothamBold,
        TextSize = 10
    })
    local Open = false
    local List = Create("Frame", {
        Parent = Dropdown,
        Position = UDim2.new(0, 0, 1, 5),
        Size = UDim2.new(1, 0, 0, #options * 30),
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
            Size = UDim2.new(1, 0, 0, 30),
            BackgroundTransparency = 1,
            Text = tostring(option),
            TextColor3 = Theme.Text,
            Font = Enum.Font.Gotham,
            TextSize = 10,
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
        TextSize = 10,
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
        TextSize = 10,
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
        Card1.Size = UDim2.new(1, 0, 0, 90)
        local AutoBreakToggle = CreateToggle(Card1, "", false)
        AutoBreakToggle.Position = UDim2.new(1, -68, 0, 10)
        AutoBreakToggle.Size = UDim2.fromOffset(58, 26)
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
            SortFrame.Visible = EggFilterOpen
            Card1.Size = UDim2.new(1, 0, 0, EggFilterOpen and 234 or (ZoneFilterOpen and 194 or 90))
            ZoneFilterButton.Text = ZoneFilterOpen and "Zones ▲" or "Zones ▼"
            EggFilterButton.Text = EggFilterOpen and "Eggs ▲" or "Eggs ▼"
        end
        ZoneFilterButton = CreateButton(Card1, "Zones ▼", function()
            ZoneFilterOpen = not ZoneFilterOpen
            EggFilterOpen = false
            UpdateFilterPanel()
        end)
        ZoneFilterButton.Position = UDim2.fromOffset(15, 44)
        ZoneFilterButton.Size = UDim2.new(0.5, -20, 0, 30)
        EggFilterButton = CreateButton(Card1, "Eggs ▼", function()
            EggFilterOpen = not EggFilterOpen
            ZoneFilterOpen = false
            UpdateFilterPanel()
        end)
        EggFilterButton.Position = UDim2.new(0.5, 5, 0, 44)
        EggFilterButton.Size = UDim2.new(0.5, -20, 0, 30)
        ZoneList = Create("ScrollingFrame", {
            Name = "ZoneFilterList",
            Parent = Card1,
            Position = UDim2.fromOffset(15, 82),
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
            Position = UDim2.fromOffset(15, 82),
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
            Position = UDim2.fromOffset(15, 190),
            Size = UDim2.new(1, -30, 0, 32),
            BackgroundTransparency = 1,
            Visible = false
        })
        Create("TextLabel", {
            Parent = SortFrame,
            Size = UDim2.fromOffset(38, 30),
            BackgroundTransparency = 1,
            Text = "Sort",
            TextColor3 = Theme.Gray,
            Font = Enum.Font.Gotham,
            TextSize = 10,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        local function UpdateSortButtons()
            for _, pair in ipairs({
                {SortLargestButton, "Largest"},
                {SortSmallestButton, "Smallest"}
            }) do
                local button, order = pair[1], pair[2]
                local selected = SortOrder == order
                button.BackgroundColor3 = selected and Theme.Selected or Theme.SurfaceInput
                button.TextColor3 = selected and Theme.SelectedText or Theme.Gray
                button.Text = (selected and "● " or "○ ") .. order
            end
        end
        SortLargestButton = Create("TextButton", {
            Name = "SortLargest",
            Parent = SortFrame,
            Position = UDim2.fromOffset(40, 2),
            Size = UDim2.new(0.5, -44, 0, 28),
            BackgroundColor3 = Theme.Selected,
            Text = "● Largest",
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
            Position = UDim2.new(0.5, 0, 0, 2),
            Size = UDim2.new(0.5, -2, 0, 28),
            BackgroundColor3 = Theme.SurfaceInput,
            Text = "○ Smallest",
            TextColor3 = Theme.Gray,
            Font = Enum.Font.Gotham,
            TextSize = 9,
            BorderSizePixel = 0,
            AutoButtonColor = false
        })
        AddCorner(SortSmallestButton, 5)
        local function GetEggTypeName(name)
            return (name:gsub("^%d+:%s*", ""))
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
                            if egg:IsA("Model") or egg:IsA("BasePart") then
                                local eggName = GetEggTypeName(egg.Name)
                                local size = egg:IsA("Model") and egg:GetExtentsSize().Magnitude or egg.Size.Magnitude
                                if not byName[eggName] then
                                    byName[eggName] = {name = eggName, size = size}
                                    table.insert(records, byName[eggName])
                                elseif size > byName[eggName].size then
                                    byName[eggName].size = size
                                end
                            end
                        end
                    end
                end
            end
            table.sort(records, function(a, b)
                if a.size == b.size then
                    return a.name < b.name
                end
                if SortOrder == "Largest" then
                    return a.size > b.size
                end
                return a.size < b.size
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
                    TextSize = 10,
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
                    TextSize = 14
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
                    TextSize = 10
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
                    TextSize = 10,
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
                    TextSize = 14
                })
                EggButton.MouseButton1Click:Connect(function()
                    SelectedEggs[eggName] = SelectedEggs[eggName] == false and nil or false
                    RefreshEggList()
                end)
            end
        end
        SortLargestButton.MouseButton1Click:Connect(function()
            SortOrder = "Largest"
            UpdateSortButtons()
            RefreshEggList()
        end)
        SortSmallestButton.MouseButton1Click:Connect(function()
            SortOrder = "Smallest"
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

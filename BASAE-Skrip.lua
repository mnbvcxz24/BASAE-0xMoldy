-- REUSABLE UI TEMPLATE
-- SERVICES
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local testver = "Test v1.0"
-- UI CONFIGURATION
local UIConfig = {
    Title = "BASAE-Skrip",
    Subtitle = testver,
    Width = 200,
    Height = 350,
    SidebarWidth = 72,
    SidebarNames = {
        "Sidebar 1",
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
AddCorner(Main, 12)
AddStroke(Main, Theme.Border, 1)
-- TOP BAR
local TopBar = Create("Frame", {
    Name = "TopBar",
    Parent = Main,
    Size = UDim2.new(1, 0, 0, 58),
    BackgroundColor3 = Theme.Background,
    BorderSizePixel = 0
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
-- SIDEBAR
local Sidebar = Create("Frame", {
    Name = "Sidebar",
    Parent = Main,
    Position = UDim2.fromOffset(0, 58),
    Size = UDim2.new(
        0,
        UIConfig.SidebarWidth,
        1,
        -58
    ),
    BackgroundColor3 = Theme.Sidebar,
    BorderSizePixel = 0
})
-- Sidebar title
local NavigationTitle = Create("TextLabel", {
    Name = "NavigationTitle",
    Parent = Sidebar,
    Position = UDim2.fromOffset(8, 20),
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
    Position = UDim2.fromOffset(5, 52),
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
        58
    ),
    Size = UDim2.new(
        1,
        -UIConfig.SidebarWidth,
        1,
        -58
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
        Visible = false
    })
    local Padding = Create("UIPadding", {
        Parent = Page,
        PaddingTop = UDim.new(0, 20),
        PaddingBottom = UDim.new(0, 20),
        PaddingLeft = UDim.new(0, 20),
        PaddingRight = UDim.new(0, 20)
    })
    local Layout = Create("UIListLayout", {
        Parent = Page,
        Padding = UDim.new(0, 12),
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Page.CanvasSize = UDim2.new(
            0,
            0,
            0,
            Layout.AbsoluteContentSize.Y + 40
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
    -- PAGE CONTENT
    --
    -- Replace these example cards with your own UI.
    local Card1 = CreateCard(
        Page,
        name,
        "This is a reusable UI page. Backend code is not connected."
    )
    CreateButton(
        Card1,
        "Example Button",
        function()
            -- BACKEND PLACEHOLDER
            -- Put your actual function here.
        end
    )
    local Card2 = CreateCard(
        Page,
        "Example Settings",
        "Example controls that only change the UI state."
    )
    CreateToggle(
        Card2,
        "Example Toggle",
        false,
        function(state)
            -- BACKEND PLACEHOLDER
            -- state = true / false
        end
    )
    local Card3 = CreateCard(
        Page,
        "Example Options",
        "Dropdown and slider examples."
    )
    CreateDropdown(
        Card3,
        "Mode",
        {
            "Option 1",
            "Option 2",
            "Option 3"
        },
        function(selection)
            -- BACKEND PLACEHOLDER
            -- selection contains the selected option.
        end
    )
    CreateSlider(
        Card3,
        "Example Slider",
        0,
        100,
        50,
        function(value)
            -- BACKEND PLACEHOLDER
            -- value contains the current slider value.
        end
    )
end
-- SHOW FIRST PAGE
Pages[1].Visible = true
SidebarButtons[1].BackgroundColor3 = Theme.Selected
SidebarButtons[1].TextColor3 = Theme.SelectedText
-- MINIMIZE
local Minimized = false
MinimizeButton.MouseButton1Click:Connect(function()
    Minimized = not Minimized
    if Minimized then
        Content.Visible = false
        Sidebar.Visible = false
        Tween(Main, {
            Size = UDim2.fromOffset(
                UIConfig.Width,
                58
            )
        })
    else
        Content.Visible = true
        Sidebar.Visible = true
        Tween(Main, {
            Size = UDim2.fromOffset(
                UIConfig.Width,
                UIConfig.Height
            )
        })
    end
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

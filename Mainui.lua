local AshlyGUI = (function()
    local AshlyGUI = {}
    AshlyGUI.__index = AshlyGUI

    local TweenService = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")
    local Players = game:GetService("Players")
    local CoreGui = game:GetService("CoreGui")

    local function CreateInstance(className, properties)
        local obj = Instance.new(className)
        for prop, value in pairs(properties) do obj[prop] = value end
        return obj
    end

    local function MakeDraggable(frame, targetToMove)
        targetToMove = targetToMove or frame
        local dragging, dragInput, dragStart, startPos
        frame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true; dragStart = input.Position; startPos = targetToMove.Position
                input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
            end
        end)
        frame.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                local delta = input.Position - dragStart
                targetToMove.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
    end

    function AshlyGUI:CreateWindow(config)
        config = config or {}
        local name = config.Name or "ASHLY"
        local title = config.Title or "ASHLY"
        -- Make the GUI smaller for mobile devices
        local size = config.Size or UDim2.new(0, 400, 0, 300)
        
        local targetParent = CoreGui
        pcall(function() if gethui then targetParent = gethui() end end)

        local gui = CreateInstance("ScreenGui", { Name = name .. "GUI", Parent = targetParent, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, Enabled = true })

        local ashlyBtn = CreateInstance("TextButton", {
            Name = "AshlyToggle", Size = UDim2.new(0, 60, 0, 30), Position = UDim2.new(0.5, -30, 0.95, -40),
            BackgroundColor3 = Color3.fromRGB(10, 10, 10), Text = "ASHLY", TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 12, Font = Enum.Font.GothamBold, BorderSizePixel = 0, Parent = gui, ZIndex = 10
        })
        CreateInstance("UICorner", { CornerRadius = UDim.new(0, 8), Parent = ashlyBtn })
        CreateInstance("UIStroke", { Thickness = 1.5, Color = Color3.fromRGB(35, 120, 255), Parent = ashlyBtn })
        MakeDraggable(ashlyBtn)

        local container = CreateInstance("Frame", {
            Name = "Container", Size = size, Position = UDim2.new(0.5, -size.X.Offset/2, 0.5, -size.Y.Offset/2),
            BackgroundColor3 = Color3.fromRGB(10, 10, 10), BorderSizePixel = 0, Visible = true, Parent = gui
        })
        CreateInstance("UICorner", { CornerRadius = UDim.new(0, 10), Parent = container })
        CreateInstance("UIStroke", { Thickness = 1.5, Color = Color3.fromRGB(35, 35, 35), Parent = container })

        local topBar = CreateInstance("Frame", { Name = "TopBar", Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = Color3.fromRGB(15, 15, 15), BorderSizePixel = 0, Parent = container })
        CreateInstance("UICorner", { CornerRadius = UDim.new(0, 10), Parent = topBar })
        CreateInstance("Frame", { Name = "TopBarFill", Size = UDim2.new(1, 0, 0, 8), Position = UDim2.new(0, 0, 0, 5), BackgroundColor3 = Color3.fromRGB(15, 15, 15), BorderSizePixel = 0, Parent = container })
        MakeDraggable(topBar, container)

        CreateInstance("TextLabel", { Name = "Title", Size = UDim2.new(0, 100, 1, 0), Position = UDim2.new(0, 12, 0, 0), BackgroundTransparency = 1, Text = title, TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 16, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left, Parent = topBar })

        local closeBtn = CreateInstance("TextButton", { Name = "CloseBtn", Size = UDim2.new(0, 30, 0, 30), Position = UDim2.new(1, -35, 0.5, -15), BackgroundColor3 = Color3.fromRGB(40, 40, 40), Text = "X", TextColor3 = Color3.fromRGB(180, 180, 180), TextSize = 14, Font = Enum.Font.GothamBold, BorderSizePixel = 0, Parent = topBar })
        CreateInstance("UICorner", { CornerRadius = UDim.new(0, 6), Parent = closeBtn })
        closeBtn.MouseButton1Click:Connect(function() container.Visible = false end)

        local body = CreateInstance("Frame", { Name = "Body", Size = UDim2.new(1, 0, 1, -40), Position = UDim2.new(0, 0, 0, 40), BackgroundColor3 = Color3.fromRGB(10, 10, 10), BorderSizePixel = 0, Parent = container })
        local tabContainer = CreateInstance("Frame", { Name = "TabContainer", Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = Color3.fromRGB(15, 15, 15), BorderSizePixel = 0, Parent = body })
        local contentContainer = CreateInstance("Frame", { Name = "ContentContainer", Size = UDim2.new(1, 0, 1, -41), Position = UDim2.new(0, 0, 0, 41), BackgroundColor3 = Color3.fromRGB(10, 10, 10), BorderSizePixel = 0, Parent = body })
        CreateInstance("UICorner", { CornerRadius = UDim.new(0, 8), Parent = contentContainer })
        CreateInstance("Frame", { Name = "Divider", Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 0, 40), BackgroundColor3 = Color3.fromRGB(30, 30, 30), BorderSizePixel = 0, Parent = body })

        local tabScrolling = CreateInstance("ScrollingFrame", { Name = "TabScrolling", Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, ScrollBarThickness = 0, ScrollingDirection = Enum.ScrollingDirection.X, AutomaticCanvasSize = Enum.AutomaticSize.X, CanvasSize = UDim2.new(0, 0, 0, 0), BorderSizePixel = 0, Parent = tabContainer })
        CreateInstance("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder, Parent = tabScrolling })
        CreateInstance("UIPadding", { PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), PaddingTop = UDim.new(0, 6), PaddingBottom = UDim.new(0, 6), Parent = tabScrolling })

        local contentScrolling = CreateInstance("ScrollingFrame", { Name = "ContentScrolling", Size = UDim2.new(1, -10, 1, -10), Position = UDim2.new(0, 5, 0, 5), BackgroundTransparency = 1, ScrollBarThickness = 4, ScrollBarImageColor3 = Color3.fromRGB(40, 40, 40), AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new(0, 0, 0, 0), BorderSizePixel = 0, Parent = contentContainer })
        CreateInstance("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder, Parent = contentScrolling })
        CreateInstance("UIPadding", { PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10), Parent = contentScrolling })

        ashlyBtn.MouseButton1Click:Connect(function() container.Visible = not container.Visible end)

        local tabs = {}
        local activeTab = nil

        local windowAPI = {
            Gui = gui, Container = container, ToggleButton = ashlyBtn, _tabs = tabs, _activeTab = activeTab, ContentScrolling = contentScrolling, TabScrolling = tabScrolling,
            CreateTab = function(self, tabConfig)
                tabConfig = tabConfig or {}
                local tabName = tabConfig.Name or "Tab"; local icon = tabConfig.Icon or ""

                local tabBtn = CreateInstance("TextButton", { Size = UDim2.new(0, 120, 1, 0), BackgroundColor3 = Color3.fromRGB(20, 20, 20), Text = icon .. " " .. tabName, TextColor3 = Color3.fromRGB(150, 150, 150), TextSize = 12, Font = Enum.Font.Gotham, BorderSizePixel = 0, Parent = tabScrolling })
                CreateInstance("UICorner", { CornerRadius = UDim.new(0, 6), Parent = tabBtn })

                local tabContent = CreateInstance("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Visible = false, Parent = contentScrolling })
                CreateInstance("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder, Parent = tabContent })
                CreateInstance("UIPadding", { PaddingLeft = UDim.new(0, 5), PaddingRight = UDim.new(0, 5), PaddingTop = UDim.new(0, 5), PaddingBottom = UDim.new(0, 5), Parent = tabContent })

                local tabData = { Name = tabName, Button = tabBtn, Content = tabContent }
                table.insert(tabs, tabData)

                if #tabs == 1 then
                    tabBtn.BackgroundColor3 = Color3.fromRGB(30, 55, 100); tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255); tabContent.Visible = true; activeTab = tabData
                end

                tabBtn.MouseButton1Click:Connect(function()
                    for _, t in ipairs(tabs) do t.Button.BackgroundColor3 = Color3.fromRGB(20, 20, 20); t.Button.TextColor3 = Color3.fromRGB(150, 150, 150); t.Content.Visible = false end
                    tabBtn.BackgroundColor3 = Color3.fromRGB(30, 55, 100); tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255); tabContent.Visible = true; activeTab = tabData
                end)

                local tabAPI = {
                    Data = tabData,
                    AddSection = function(self, sectionConfig)
                        sectionConfig = sectionConfig or {}
                        local sectionName = sectionConfig.Name or "Section"
                        local sec = CreateInstance("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = Color3.fromRGB(18, 18, 18), BorderSizePixel = 0, Parent = tabContent })
                        CreateInstance("UICorner", { CornerRadius = UDim.new(0, 6), Parent = sec })
                        CreateInstance("UIStroke", { Thickness = 1, Color = Color3.fromRGB(28, 28, 28), Parent = sec })
                        CreateInstance("TextLabel", { Size = UDim2.new(1, -20, 0, 32), Position = UDim2.new(0, 10, 0, 5), BackgroundTransparency = 1, Text = sectionName, TextColor3 = Color3.fromRGB(180, 180, 180), TextSize = 13, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left, Parent = sec })
                        CreateInstance("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder, Parent = sec })
                        CreateInstance("UIPadding", { PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), PaddingTop = UDim.new(0, 36), PaddingBottom = UDim.new(0, 10), Parent = sec })

                        local secAPI = {
                            AddToggle = function(_, toggleConfig)
                                toggleConfig = toggleConfig or {}
                                local tName = toggleConfig.Name or "Toggle"; local defaultVal = toggleConfig.Default or false; local callback = toggleConfig.Callback or function() end
                                local frame = CreateInstance("Frame", { Size = UDim2.new(1, 0, 0, 34), BackgroundColor3 = Color3.fromRGB(14, 14, 14), BorderSizePixel = 0, Parent = sec })
                                CreateInstance("UICorner", { CornerRadius = UDim.new(0, 5), Parent = frame })
                                CreateInstance("TextLabel", { Size = UDim2.new(1, -50, 1, 0), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, Text = tName, TextColor3 = Color3.fromRGB(180, 180, 180), TextSize = 13, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, Parent = frame })
                                local ind = CreateInstance("Frame", { Size = UDim2.new(0, 28, 0, 16), Position = UDim2.new(1, -38, 0.5, -8), BackgroundColor3 = defaultVal and Color3.fromRGB(35, 120, 255) or Color3.fromRGB(40, 40, 40), BorderSizePixel = 0, Parent = frame })
                                CreateInstance("UICorner", { CornerRadius = UDim.new(0, 8), Parent = ind })
                                local circle = CreateInstance("Frame", { Size = UDim2.new(0, 12, 0, 12), Position = defaultVal and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6), BackgroundColor3 = Color3.fromRGB(255, 255, 255), BorderSizePixel = 0, Parent = ind })
                                CreateInstance("UICorner", { CornerRadius = UDim.new(0, 6), Parent = circle })
                                local toggled = defaultVal
                                callback(toggled)
                                local function Update()
                                    toggled = not toggled
                                    if toggled then TweenService:Create(ind, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(35, 120, 255)}):Play(); TweenService:Create(circle, TweenInfo.new(0.15), {Position = UDim2.new(1, -14, 0.5, -6)}):Play()
                                    else TweenService:Create(ind, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play(); TweenService:Create(circle, TweenInfo.new(0.15), {Position = UDim2.new(0, 2, 0.5, -6)}):Play() end
                                    callback(toggled)
                                end
                                frame.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then Update() end end)
                                return { SetValue = function(_, v) if toggled ~= v then Update() end end, GetValue = function() return toggled end }
                            end,
                            AddButton = function(_, btnConfig)
                                btnConfig = btnConfig or {}
                                local bName = btnConfig.Name or "Button"; local bCallback = btnConfig.Callback or function() end; local bColor = btnConfig.Color or Color3.fromRGB(35, 120, 255)
                                local btn = CreateInstance("TextButton", { Size = UDim2.new(1, 0, 0, 32), BackgroundColor3 = bColor, Text = bName, TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 13, Font = Enum.Font.GothamBold, BorderSizePixel = 0, Parent = sec })
                                CreateInstance("UICorner", { CornerRadius = UDim.new(0, 5), Parent = btn })
                                btn.MouseButton1Click:Connect(bCallback)
                                btn.MouseEnter:Connect(function() TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = bColor:Lerp(Color3.fromRGB(255, 255, 255), 0.15)}):Play() end)
                                btn.MouseLeave:Connect(function() TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = bColor}):Play() end)
                            end,
                            AddSlider = function(_, sliderConfig)
                                sliderConfig = sliderConfig or {}
                                local sName = sliderConfig.Name or "Slider"; local minV = sliderConfig.Min or 0; local maxV = sliderConfig.Max or 100; local defV = sliderConfig.Default or 50; local suffix = sliderConfig.Suffix or ""; local callback = sliderConfig.Callback or function() end
                                local frame = CreateInstance("Frame", { Size = UDim2.new(1, 0, 0, 48), BackgroundColor3 = Color3.fromRGB(14, 14, 14), BorderSizePixel = 0, Parent = sec })
                                CreateInstance("UICorner", { CornerRadius = UDim.new(0, 5), Parent = frame })
                                local label = CreateInstance("TextLabel", { Size = UDim2.new(1, -20, 0, 18), Position = UDim2.new(0, 10, 0, 4), BackgroundTransparency = 1, Text = sName .. ": " .. defV .. suffix, TextColor3 = Color3.fromRGB(180, 180, 180), TextSize = 13, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, Parent = frame })
                                local track = CreateInstance("Frame", { Size = UDim2.new(1, -30, 0, 5), Position = UDim2.new(0, 15, 0, 30), BackgroundColor3 = Color3.fromRGB(40, 40, 40), BorderSizePixel = 0, Parent = frame })
                                CreateInstance("UICorner", { CornerRadius = UDim.new(0, 2.5), Parent = track })
                                local fill = CreateInstance("Frame", { Size = UDim2.new((defV - minV) / (maxV - minV), 0, 1, 0), BackgroundColor3 = Color3.fromRGB(35, 120, 255), BorderSizePixel = 0, Parent = track })
                                CreateInstance("UICorner", { CornerRadius = UDim.new(0, 2.5), Parent = fill })
                                local knob = CreateInstance("Frame", { Size = UDim2.new(0, 12, 0, 12), Position = UDim2.new((defV - minV) / (maxV - minV), -6, 0.5, -6), BackgroundColor3 = Color3.fromRGB(255, 255, 255), BorderSizePixel = 0, Parent = track })
                                CreateInstance("UICorner", { CornerRadius = UDim.new(0, 6), Parent = knob })
                                local val = defV; local dragging = false
                                local function Update(inputX)
                                    local tPos = track.AbsolutePosition.X; local tSize = track.AbsoluteSize.X; local pct = math.clamp((inputX - tPos) / tSize, 0, 1)
                                    val = math.floor(minV + (pct * (maxV - minV))); fill.Size = UDim2.new(pct, 0, 1, 0); knob.Position = UDim2.new(pct, -6, 0.5, -6); label.Text = sName .. ": " .. val .. suffix; callback(val)
                                end
                                frame.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = true; Update(i.Position.X) end end)
                                frame.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
                                UserInputService.InputChanged:Connect(function(i) if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then Update(i.Position.X) end end)
                                return { SetValue = function(_, v) val = math.clamp(v, minV, maxV); local p = (val - minV) / (maxV - minV); fill.Size = UDim2.new(p, 0, 1, 0); knob.Position = UDim2.new(p, -6, 0.5, -6); label.Text = sName .. ": " .. val .. suffix; callback(val) end, GetValue = function() return val end }
                            end,
                            AddDropdown = function(_, ddConfig)
                                ddConfig = ddConfig or {}
                                local dName = ddConfig.Name or "Dropdown"; local options = ddConfig.Options or {"Option 1"}; local defaultOpt = ddConfig.Default or options[1]; local callback = ddConfig.Callback or function() end
                                local frame = CreateInstance("Frame", { Size = UDim2.new(1, 0, 0, 34), BackgroundColor3 = Color3.fromRGB(14, 14, 14), BorderSizePixel = 0, Parent = sec })
                                CreateInstance("UICorner", { CornerRadius = UDim.new(0, 5), Parent = frame })
                                CreateInstance("TextLabel", { Size = UDim2.new(0, 90, 1, 0), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, Text = dName, TextColor3 = Color3.fromRGB(180, 180, 180), TextSize = 13, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, Parent = frame })
                                local btn = CreateInstance("TextButton", { Size = UDim2.new(0, 110, 0, 24), Position = UDim2.new(1, -120, 0.5, -12), BackgroundColor3 = Color3.fromRGB(30, 30, 30), Text = defaultOpt, TextColor3 = Color3.fromRGB(180, 180, 180), TextSize = 12, Font = Enum.Font.Gotham, BorderSizePixel = 0, Parent = frame })
                                CreateInstance("UICorner", { CornerRadius = UDim.new(0, 4), Parent = btn })
                                local expanded = false; local listFrame
                                btn.MouseButton1Click:Connect(function()
                                    expanded = not expanded
                                    if expanded then
                                        if listFrame then listFrame:Destroy() end
                                        listFrame = CreateInstance("ScrollingFrame", { Size = UDim2.new(0, 110, 0, math.min(#options * 26, 130)), Position = UDim2.new(1, -120, 0, 26), BackgroundColor3 = Color3.fromRGB(25, 25, 25), BorderSizePixel = 0, ScrollBarThickness = 2, Parent = frame })
                                        CreateInstance("UICorner", { CornerRadius = UDim.new(0, 4), Parent = listFrame })
                                        CreateInstance("UIListLayout", { Padding = UDim.new(0, 2), Parent = listFrame })
                                        CreateInstance("UIPadding", { PaddingLeft = UDim.new(0, 3), PaddingRight = UDim.new(0, 3), PaddingTop = UDim.new(0, 3), PaddingBottom = UDim.new(0, 3), Parent = listFrame })
                                        for _, opt in ipairs(options) do
                                            local optBtn = CreateInstance("TextButton", { Size = UDim2.new(1, 0, 0, 22), BackgroundColor3 = Color3.fromRGB(35, 35, 35), Text = opt, TextColor3 = Color3.fromRGB(180, 180, 180), TextSize = 11, Font = Enum.Font.Gotham, BorderSizePixel = 0, Parent = listFrame })
                                            CreateInstance("UICorner", { CornerRadius = UDim.new(0, 3), Parent = optBtn })
                                            optBtn.MouseButton1Click:Connect(function() btn.Text = opt; callback(opt); expanded = false; if listFrame then listFrame:Destroy() listFrame = nil end end)
                                        end
                                    else if listFrame then listFrame:Destroy() listFrame = nil end end
                                end)
                                return { SetValue = function(_, v) btn.Text = v callback(v) end }
                            end,
                            AddLabel = function(_, labelConfig)
                                labelConfig = labelConfig or {}
                                local lText = labelConfig.Text or "Label"; local lColor = labelConfig.Color or Color3.fromRGB(150, 150, 150)
                                local lbl = CreateInstance("TextLabel", { Size = UDim2.new(1, 0, 0, 22), BackgroundTransparency = 1, Text = lText, TextColor3 = lColor, TextSize = 13, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, Parent = sec })
                                return { SetText = function(_, t) lbl.Text = t end }
                            end,
                            AddTextBox = function(_, tbConfig)
                                tbConfig = tbConfig or {}
                                local tbName = tbConfig.Name or "Input"; local placeholder = tbConfig.Placeholder or "Enter..."; local callback = tbConfig.Callback or function() end
                                local frame = CreateInstance("Frame", { Size = UDim2.new(1, 0, 0, 34), BackgroundColor3 = Color3.fromRGB(14, 14, 14), BorderSizePixel = 0, Parent = sec })
                                CreateInstance("UICorner", { CornerRadius = UDim.new(0, 5), Parent = frame })
                                CreateInstance("TextLabel", { Size = UDim2.new(0, 70, 1, 0), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, Text = tbName, TextColor3 = Color3.fromRGB(180, 180, 180), TextSize = 13, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, Parent = frame })
                                local input = CreateInstance("TextBox", { Size = UDim2.new(0, 130, 0, 24), Position = UDim2.new(1, -140, 0.5, -12), BackgroundColor3 = Color3.fromRGB(30, 30, 30), PlaceholderText = placeholder, PlaceholderColor3 = Color3.fromRGB(80, 80, 80), Text = "", TextColor3 = Color3.fromRGB(200, 200, 200), TextSize = 12, Font = Enum.Font.Gotham, ClearTextOnFocus = false, BorderSizePixel = 0, Parent = frame })
                                CreateInstance("UICorner", { CornerRadius = UDim.new(0, 4), Parent = input })
                                input.FocusLost:Connect(function(enter) if enter then callback(input.Text) end end)
                                return { SetText = function(_, t) input.Text = t end, GetText = function() return input.Text end }
                            end,
                            AddKeybind = function(_, kbConfig)
                                kbConfig = kbConfig or {}
                                local kName = kbConfig.Name or "Keybind"; local defaultKey = kbConfig.Default or Enum.KeyCode.F1; local callback = kbConfig.Callback or function() end
                                local frame = CreateInstance("Frame", { Size = UDim2.new(1, 0, 0, 34), BackgroundColor3 = Color3.fromRGB(14, 14, 14), BorderSizePixel = 0, Parent = sec })
                                CreateInstance("UICorner", { CornerRadius = UDim.new(0, 5), Parent = frame })
                                CreateInstance("TextLabel", { Size = UDim2.new(0, 150, 1, 0), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, Text = kName, TextColor3 = Color3.fromRGB(180, 180, 180), TextSize = 13, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, Parent = frame })
                                local btn = CreateInstance("TextButton", { Size = UDim2.new(0, 80, 0, 24), Position = UDim2.new(1, -90, 0.5, -12), BackgroundColor3 = Color3.fromRGB(30, 30, 30), Text = defaultKey.Name, TextColor3 = Color3.fromRGB(180, 180, 180), TextSize = 12, Font = Enum.Font.Gotham, BorderSizePixel = 0, Parent = frame })
                                CreateInstance("UICorner", { CornerRadius = UDim.new(0, 4), Parent = btn })
                                local currentKey = defaultKey; local listening = false
                                btn.MouseButton1Click:Connect(function() listening = true; btn.Text = "..." end)
                                UserInputService.InputBegan:Connect(function(input)
                                    if listening and input.UserInputType == Enum.UserInputType.Keyboard then
                                        listening = false; currentKey = input.KeyCode; btn.Text = currentKey.Name; callback(currentKey)
                                    end
                                end)
                                return { SetValue = function(_, v) currentKey = v; btn.Text = v.Name; callback(v) end }
                            end,
                            AddPlayerProfile = function(_, profileConfig)
                                local pName = Players.LocalPlayer.DisplayName .. " (@" .. Players.LocalPlayer.Name .. ")"
                                
                                local frame = CreateInstance("Frame", { Size = UDim2.new(1, 0, 0, 60), BackgroundColor3 = Color3.fromRGB(14, 14, 14), BorderSizePixel = 0, Parent = sec })
                                CreateInstance("UICorner", { CornerRadius = UDim.new(0, 5), Parent = frame })
                                
                                local image = CreateInstance("ImageLabel", { Size = UDim2.new(0, 46, 0, 46), Position = UDim2.new(0, 7, 0, 7), BackgroundTransparency = 1, Parent = frame })
                                CreateInstance("UICorner", { CornerRadius = UDim.new(1, 0), Parent = image })
                                
                                task.spawn(function()
                                    pcall(function() 
                                        image.Image = Players:GetUserThumbnailAsync(Players.LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420) 
                                    end)
                                end)
                                
                                local nameLbl = CreateInstance("TextLabel", { Size = UDim2.new(1, -70, 0, 20), Position = UDim2.new(0, 65, 0, 10), BackgroundTransparency = 1, Text = pName, TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 14, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left, Parent = frame })
                                
                                local timeLbl = CreateInstance("TextLabel", { Size = UDim2.new(1, -70, 0, 20), Position = UDim2.new(0, 65, 0, 30), BackgroundTransparency = 1, Text = "Usage Time: 0s", TextColor3 = Color3.fromRGB(180, 180, 180), TextSize = 12, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, Parent = frame })
                                
                                return { SetTimeText = function(_, t) timeLbl.Text = t end }
                            end
                        }
                        return secAPI
                    end
                }
                return tabAPI
            end
        }
        return windowAPI
    end
    return AshlyGUI
end)()

local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- Configuration
local API_URL = "https://aged-wood-309e.gamaoashly6.workers.dev/?key="
local KEY_FILE = "RivalsFree_SavedKey.txt"

local CONFIG_FILE = "RivalsFree_Settings.json"
local LoadedConfig = { ToggleKey = "F1", Toggles = {}, Sliders = {}, Dropdowns = {}, TotalPlayTime = 0 }

if isfile and isfile(CONFIG_FILE) then
    pcall(function() 
        local parsed = HttpService:JSONDecode(readfile(CONFIG_FILE))
        if parsed then
            if parsed.ToggleKey then LoadedConfig.ToggleKey = parsed.ToggleKey end
            if parsed.Toggles then LoadedConfig.Toggles = parsed.Toggles end
            if parsed.Sliders then LoadedConfig.Sliders = parsed.Sliders end
            if parsed.Dropdowns then LoadedConfig.Dropdowns = parsed.Dropdowns end
            if parsed.TotalPlayTime then LoadedConfig.TotalPlayTime = parsed.TotalPlayTime end
        end
    end)
end

local function SaveConfig()
    if writefile then
        pcall(function() writefile(CONFIG_FILE, HttpService:JSONEncode(LoadedConfig)) end)
    end
end

-- Free Script State
local AshlyState = {
    ESPEnabled = false,
    ChamsEnabled = false,
    EnemyOnly = false,
    AimbotEnabled = true,
    FOVEnabled = false,
    SelectedHitbox = "Head",
    SpeedEnabled = false,
    SpeedValue = 16,
    PredictionEnabled = false,
    PredictionAmount = 0.16,
    NoclipEnabled = false,
    HPEnabled = false,
    TelekillEnabled = false,
    ShowAimIndicator = false
}

-- =====================================
-- AUTHENTICATION BOOTSTRAPPER
-- =====================================

local function LoadFreeScript()
    -- Removed setclipboard on boot to avoid anti-cheat detection
    local Window = AshlyGUI:CreateWindow({
        Name = "RivalsFree",
        Title = "Rivals Free by Ashly Hub",
        Size = UDim2.new(0, 350, 0, 250)
    })

    local ToggleKeybind = Enum.KeyCode.F1
    pcall(function() ToggleKeybind = Enum.KeyCode[LoadedConfig.ToggleKey] or Enum.KeyCode.F1 end)

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == ToggleKeybind then
            Window.Container.Visible = not Window.Container.Visible
        end
    end)

    local function getToggleVal(name, default) 
        if LoadedConfig.Toggles and LoadedConfig.Toggles[name] ~= nil then return LoadedConfig.Toggles[name] else return default end 
    end
    local function getSliderVal(name, default) 
        if LoadedConfig.Sliders and LoadedConfig.Sliders[name] ~= nil then return LoadedConfig.Sliders[name] else return default end 
    end

    local targetParentHUD = game:GetService("CoreGui")
    pcall(function() if gethui then targetParentHUD = gethui() end end)
    
    local MobileHUD = Instance.new("ScreenGui")
    MobileHUD.Name = "AshlyMobileHUD"
    MobileHUD.Parent = targetParentHUD
    MobileHUD.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    MobileHUD.Enabled = true
    
    local floatingTelekillBtn = Instance.new("TextButton")
    floatingTelekillBtn.Name = "FloatingTelekill"
    floatingTelekillBtn.Size = UDim2.new(0, 70, 0, 70)
    floatingTelekillBtn.Position = UDim2.new(0.85, -35, 0.6, -35)
    floatingTelekillBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    floatingTelekillBtn.Text = "Telekill\nOFF"
    floatingTelekillBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    floatingTelekillBtn.TextSize = 13
    floatingTelekillBtn.Font = Enum.Font.GothamBold
    floatingTelekillBtn.BorderSizePixel = 0
    floatingTelekillBtn.Parent = MobileHUD
    floatingTelekillBtn.Visible = false
    
    local tkCorner = Instance.new("UICorner")
    tkCorner.CornerRadius = UDim.new(1, 0)
    tkCorner.Parent = floatingTelekillBtn
    
    local tkStroke = Instance.new("UIStroke")
    tkStroke.Thickness = 2
    tkStroke.Color = Color3.fromRGB(255, 100, 100)
    tkStroke.Parent = floatingTelekillBtn
    
    local tDragging, tDragInput, tDragStart, tStartPos
    floatingTelekillBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            tDragging = true; tDragStart = input.Position; tStartPos = floatingTelekillBtn.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then tDragging = false end end)
        end
    end)
    floatingTelekillBtn.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then tDragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == tDragInput and tDragging then
            local delta = input.Position - tDragStart
            floatingTelekillBtn.Position = UDim2.new(tStartPos.X.Scale, tStartPos.X.Offset + delta.X, tStartPos.Y.Scale, tStartPos.Y.Offset + delta.Y)
        end
    end)
    
    floatingTelekillBtn.MouseButton1Click:Connect(function()
        AshlyState.TelekillEnabled = not AshlyState.TelekillEnabled
        if AshlyState.TelekillEnabled then
            floatingTelekillBtn.Text = "Telekill\nON"
            floatingTelekillBtn.TextColor3 = Color3.fromRGB(100, 255, 100)
            tkStroke.Color = Color3.fromRGB(100, 255, 100)
        else
            floatingTelekillBtn.Text = "Telekill\nOFF"
            floatingTelekillBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
            tkStroke.Color = Color3.fromRGB(255, 100, 100)
            local char = LocalPlayer.Character
            if char then
                local root = char:FindFirstChild("HumanoidRootPart")
                if root then
                    root.Velocity = Vector3.new(0, 0, 0)
                    root.RotVelocity = Vector3.new(0, 0, 0)
                end
            end
        end
    end)

    local floatingAimbotBtn = Instance.new("TextButton")
    floatingAimbotBtn.Name = "FloatingAimbot"
    floatingAimbotBtn.Size = UDim2.new(0, 70, 0, 70)
    floatingAimbotBtn.Position = UDim2.new(0.85, -35, 0.45, -35)
    floatingAimbotBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    floatingAimbotBtn.Text = "Aimbot\nON"
    floatingAimbotBtn.TextColor3 = Color3.fromRGB(100, 255, 100)
    floatingAimbotBtn.TextSize = 13
    floatingAimbotBtn.Font = Enum.Font.GothamBold
    floatingAimbotBtn.BorderSizePixel = 0
    floatingAimbotBtn.Parent = MobileHUD
    floatingAimbotBtn.Visible = false
    
    local abCorner = Instance.new("UICorner")
    abCorner.CornerRadius = UDim.new(1, 0)
    abCorner.Parent = floatingAimbotBtn
    
    local abStroke = Instance.new("UIStroke")
    abStroke.Thickness = 2
    abStroke.Color = Color3.fromRGB(100, 255, 100)
    abStroke.Parent = floatingAimbotBtn
    
    local aDragging, aDragInput, aDragStart, aStartPos
    floatingAimbotBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            aDragging = true; aDragStart = input.Position; aStartPos = floatingAimbotBtn.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then aDragging = false end end)
        end
    end)
    floatingAimbotBtn.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then aDragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == aDragInput and aDragging then
            local delta = input.Position - aDragStart
            floatingAimbotBtn.Position = UDim2.new(aStartPos.X.Scale, aStartPos.X.Offset + delta.X, aStartPos.Y.Scale, aStartPos.Y.Offset + delta.Y)
        end
    end)
    
    floatingAimbotBtn.MouseButton1Click:Connect(function()
        AshlyState.AimbotEnabled = not AshlyState.AimbotEnabled
        if AshlyState.AimbotEnabled then
            floatingAimbotBtn.Text = "Aimbot\nON"
            floatingAimbotBtn.TextColor3 = Color3.fromRGB(100, 255, 100)
            abStroke.Color = Color3.fromRGB(100, 255, 100)
        else
            floatingAimbotBtn.Text = "Aimbot\nOFF"
            floatingAimbotBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
            abStroke.Color = Color3.fromRGB(255, 100, 100)
        end
    end)

    local Tab = Window:CreateTab({ Name = "Main", Icon = "🏠" })
    local MainSec = Tab:AddSection({ Name = "Main" })

    local PlayerProfile = MainSec:AddPlayerProfile()

    task.spawn(function()
        while task.wait(1) do
            LoadedConfig.TotalPlayTime = LoadedConfig.TotalPlayTime + 1
            local ts = LoadedConfig.TotalPlayTime
            local d = math.floor(ts / 86400)
            local h = math.floor((ts % 86400) / 3600)
            local m = math.floor((ts % 3600) / 60)
            local s = ts % 60
            
            local tStr = "Usage Time: "
            if d > 0 then tStr = tStr .. d .. "d " end
            if h > 0 then tStr = tStr .. h .. "h " end
            if m > 0 then tStr = tStr .. m .. "m " end
            tStr = tStr .. s .. "s"
            
            PlayerProfile:SetTimeText(tStr)
            
            if ts % 5 == 0 then SaveConfig() end
        end
    end)

    MainSec:AddButton({
       Name = "Join Our Discord",
       Callback = function()
          pcall(function() setclipboard("https://discord.gg/uevZf2qtM") end)
       end,
    })

    -- ── ESP Tab ──
    local ESPSec = Tab:AddSection({ Name = "ESP Settings" })
    
    ESPSec:AddToggle({
        Name = "Show Health (Bar & Text)",
        Default = getToggleVal("Show Health (Bar & Text)", false),
        Callback = function(Value)
            AshlyState.HPEnabled = Value
            if LoadedConfig.Toggles then LoadedConfig.Toggles["Show Health (Bar & Text)"] = Value; SaveConfig() end
        end
    })
    
    ESPSec:AddToggle({
        Name = "ESP",
        Default = getToggleVal("ESP", false),
        Callback = function(Value)
            AshlyState.ESPEnabled = Value
            if LoadedConfig.Toggles then LoadedConfig.Toggles["ESP"] = Value; SaveConfig() end
        end
    })

    ESPSec:AddToggle({
        Name = "Team Check (Hide Teammates)",
        Default = getToggleVal("Team Check (Hide Teammates)", false),
        Callback = function(Value)
            AshlyState.EnemyOnly = Value
            if LoadedConfig.Toggles then LoadedConfig.Toggles["Team Check (Hide Teammates)"] = Value; SaveConfig() end
        end
    })

    -- Removed Chams toggle due to anti-cheat detection
    -- ── Aimbot Tab ──
    local Tab2 = Window:CreateTab({ Name = "Aimbot", Icon = "🎯" })
    local SilentAimSec = Tab2:AddSection({ Name = "Aimbot Settings" })

    SilentAimSec:AddToggle({
        Name = "Aimbot (Camera Lock)",
        Default = getToggleVal("Aimbot", true),
        Callback = function(Value)
            AshlyState.AimbotEnabled = Value
            if LoadedConfig.Toggles then LoadedConfig.Toggles["Aimbot"] = Value; SaveConfig() end
        end
    })

    SilentAimSec:AddToggle({
        Name = "Show FOV Circle",
        Default = getToggleVal("Show FOV Circle", false),
        Callback = function(Value)
            AshlyState.FOVEnabled = Value
            if LoadedConfig.Toggles then LoadedConfig.Toggles["Show FOV Circle"] = Value; SaveConfig() end
        end
    })

    SilentAimSec:AddDropdown({
        Name = "Hitbox",
        Options = {"Head", "Torso", "Random"},
        Default = getToggleVal("Hitbox", "Head") or "Head",
        Callback = function(Value)
            AshlyState.SelectedHitbox = Value
            if LoadedConfig.Toggles then LoadedConfig.Toggles["Hitbox"] = Value; SaveConfig() end
        end
    })

    SilentAimSec:AddToggle({
        Name = "Enable Prediction",
        Default = getToggleVal("Enable Prediction", false),
        Callback = function(Value)
            AshlyState.PredictionEnabled = Value
            if LoadedConfig.Toggles then LoadedConfig.Toggles["Enable Prediction"] = Value; SaveConfig() end
        end
    })

    SilentAimSec:AddToggle({
        Name = "Show Aim Indicator",
        Default = getToggleVal("Show Aim Indicator", false),
        Callback = function(Value)
            AshlyState.ShowAimIndicator = Value
            if LoadedConfig.Toggles then LoadedConfig.Toggles["Show Aim Indicator"] = Value; SaveConfig() end
        end
    })

    SilentAimSec:AddLabel({ Text = "Locks camera directly to target", Color = Color3.fromRGB(150, 150, 150) })

    SilentAimSec:AddToggle({
        Name = "Show Aimbot Mobile Button",
        Default = getToggleVal("Show Aimbot Mobile Button", false),
        Callback = function(Value)
            floatingAimbotBtn.Visible = Value
            if LoadedConfig.Toggles then LoadedConfig.Toggles["Show Aimbot Mobile Button"] = Value; SaveConfig() end
            if not Value then
                AshlyState.AimbotEnabled = false
                floatingAimbotBtn.Text = "Aimbot\nOFF"
                floatingAimbotBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
                abStroke.Color = Color3.fromRGB(255, 100, 100)
            end
        end
    })

    local TelekillSec = Tab2:AddSection({ Name = "Telekill" })
    TelekillSec:AddLabel({ Text = "Temporary - Premium Only Soon", Color = Color3.fromRGB(255, 100, 100) })
    local TelekillToggle = TelekillSec:AddToggle({
        Name = "Show Telekill Mobile Button",
        Default = getToggleVal("Show Telekill Mobile Button", false),
        Callback = function(Value)
            floatingTelekillBtn.Visible = Value
            if LoadedConfig.Toggles then LoadedConfig.Toggles["Show Telekill Mobile Button"] = Value; SaveConfig() end
            if not Value then
                AshlyState.TelekillEnabled = false
                floatingTelekillBtn.Text = "Telekill\nOFF"
                floatingTelekillBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
                tkStroke.Color = Color3.fromRGB(255, 100, 100)
                local char = LocalPlayer.Character
                if char then
                    local root = char:FindFirstChild("HumanoidRootPart")
                    if root then
                        root.Velocity = Vector3.new(0, 0, 0)
                        root.RotVelocity = Vector3.new(0, 0, 0)
                    end
                end
            end
        end
    })

    -- ── Player Tab ──
    local Tab3 = Window:CreateTab({ Name = "Player", Icon = "🏃" })
    local MoveSec = Tab3:AddSection({ Name = "Movement" })

    local SpeedToggle = MoveSec:AddToggle({
        Name = "Speed Hack [V]",
        Default = getToggleVal("Speed Hack [V]", false),
        Callback = function(Value)
            AshlyState.SpeedEnabled = Value
            if LoadedConfig.Toggles then LoadedConfig.Toggles["Speed Hack [V]"] = Value; SaveConfig() end
            if not Value then
                local char = LocalPlayer.Character
                if char then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum then pcall(function() hum.WalkSpeed = 16 end) end
                end
            end
        end
    })

    MoveSec:AddSlider({
        Name = "Adjust Speed",
        Min = 16,
        Max = 250,
        Default = getSliderVal("Adjust Speed", 16),
        Suffix = " WS",
        Callback = function(Value)
            AshlyState.SpeedValue = Value
            if LoadedConfig.Sliders then LoadedConfig.Sliders["Adjust Speed"] = Value; SaveConfig() end
        end
    })

    local NoclipOriginalCollisions = {}
    local NoclipToggle = MoveSec:AddToggle({
        Name = "Noclip [N]",
        Default = getToggleVal("Noclip [N]", false),
        Callback = function(Value)
            AshlyState.NoclipEnabled = Value
            if LoadedConfig.Toggles then LoadedConfig.Toggles["Noclip [N]"] = Value; SaveConfig() end
            local char = LocalPlayer.Character
            if not char then return end
            
            if Value then
                NoclipOriginalCollisions = {}
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        NoclipOriginalCollisions[part] = part.CanCollide
                    end
                end
            else
                for part, canCollide in pairs(NoclipOriginalCollisions) do
                    if part and part.Parent then
                        part.CanCollide = canCollide
                    end
                end
                NoclipOriginalCollisions = {}
            end
        end
    })

    -- ── Settings Tab ──
    local SettingsTab = Window:CreateTab({ Name = "Settings", Icon = "⚙" })
    local SettingsSec = SettingsTab:AddSection({ Name = "Configuration" })

    SettingsSec:AddKeybind({
        Name = "Toggle GUI Keybind",
        Default = ToggleKeybind,
        Callback = function(key)
            ToggleKeybind = key
            LoadedConfig.ToggleKey = key.Name
            SaveConfig()
        end
    })

    -- =====================================
    -- LOGIC VARIABLES
    -- =====================================

    local ESPObjects = {}

    -- FOV circle
    local FOVCircle = Drawing.new("Circle")
    FOVCircle.Thickness = 2
    FOVCircle.Filled = false
    FOVCircle.Color = Color3.fromRGB(255, 255, 255)
    FOVCircle.Visible = false
    FOVCircle.Radius = 100

    -- Aim indicator drawings
    local AimRing = Drawing.new("Circle")
    AimRing.Thickness = 2
    AimRing.Filled = false
    AimRing.Color = Color3.fromRGB(255, 50, 50)
    AimRing.Radius = 12
    AimRing.Visible = false

    local AimDot = Drawing.new("Circle")
    AimDot.Thickness = 1
    AimDot.Filled = true
    AimDot.Color = Color3.fromRGB(255, 255, 50)
    AimDot.Radius = 3
    AimDot.Visible = false

    local AimLine = Drawing.new("Line")
    AimLine.Thickness = 1
    AimLine.Color = Color3.fromRGB(255, 50, 50)
    AimLine.Transparency = 0.5
    AimLine.Visible = false

    local AimbotTarget = nil
    local Mouse = LocalPlayer:GetMouse()
    local _currentTelekillTarget = nil

    -- =====================================
    -- HELPER FUNCTIONS
    -- =====================================

    local function GetCharacter(player)
        if not player then return nil end
        local char = player.Character
        if char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChildOfClass("Humanoid")) then return char end
        local wsChar = workspace:FindFirstChild(player.Name)
        if wsChar and wsChar:IsA("Model") and (wsChar:FindFirstChild("HumanoidRootPart") or wsChar:FindFirstChildOfClass("Humanoid")) then return wsChar end
        return nil
    end

    local function GetRootPart(char)
        if not char then return nil end
        return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
    end

    local function GetHumanoid(char)
        if not char then return nil end
        return char:FindFirstChildOfClass("Humanoid")
    end

    local function IsAlive(char)
        if not char then return false end
        local hum = GetHumanoid(char)
        if hum then return hum.Health > 0 end
        return GetRootPart(char) ~= nil
    end

    local function IsEnemy(player)
        if not player or player == LocalPlayer then return false end
        if not AshlyState.EnemyOnly then return true end
        local character = player.Character
        if not character then return true end
        
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if rootPart and rootPart:FindFirstChild("TeammateLabel") then return false end
        if player.Team and LocalPlayer.Team and player.Team == LocalPlayer.Team then return false end
        if player.TeamColor and player.TeamColor ~= BrickColor.new("White") and LocalPlayer.TeamColor and player.TeamColor == LocalPlayer.TeamColor then return false end
        local teamAttr = player:GetAttribute("Team") or player:GetAttribute("Side")
        if teamAttr then
            local myTeam = LocalPlayer:GetAttribute("Team") or LocalPlayer:GetAttribute("Side")
            if myTeam and teamAttr == myTeam then return false end
        end
        for _, name in ipairs({"Team", "TeamId", "Side", "Faction"}) do
            local val = player:FindFirstChild(name)
            if val and (val:IsA("StringValue") or (val:IsA("NumberValue") and name == "TeamId")) then
                local myVal = LocalPlayer:FindFirstChild(name)
                if myVal and val.Value == myVal.Value then return false end
            end
        end
        return true
    end

    local function GetHitbox(char, hitbox)
        if not char then return nil end
        if hitbox == "Head" then
            return char:FindFirstChild("Head")
        elseif hitbox == "Torso" then
            return char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("HumanoidRootPart")
        elseif hitbox == "Random" then
            local parts = {"Head", "UpperTorso", "Torso", "HumanoidRootPart", "LeftArm", "RightArm"}
            local found = {}
            for _, name in ipairs(parts) do
                local p = char:FindFirstChild(name)
                if p then table.insert(found, p) end
            end
            if #found > 0 then return found[math.random(#found)] end
        end
        return char:FindFirstChild("Head")
    end

    local function GetPredictedPosition(part)
        if not part then return Vector3.new() end
        local pos = part.Position
        if AshlyState.PredictionEnabled == true then
            local vel = part.AssemblyLinearVelocity
            if not vel and part:FindFirstChild("Velocity") then vel = part.Velocity end
            if vel then
                pos = pos + (vel * AshlyState.PredictionAmount)
            end
        end
        return pos
    end

    local function CreateESP(player)
        if player == LocalPlayer then return end
        if ESPObjects[player] then return end

        local box = Drawing.new("Square")
        box.Thickness = 2
        box.Filled = false
        box.Color = Color3.fromRGB(255, 255, 255)
        box.Visible = false

        local nameText = Drawing.new("Text")
        nameText.Size = 16
        nameText.Color = Color3.fromRGB(255, 255, 255)
        nameText.Outline = true
        nameText.Center = true
        nameText.Visible = false

        local hpBarBg = Drawing.new("Square")
        hpBarBg.Filled = true
        hpBarBg.Color = Color3.fromRGB(0, 0, 0)
        hpBarBg.Visible = false

        local hpBar = Drawing.new("Square")
        hpBar.Filled = true
        hpBar.Visible = false

        local hpText = Drawing.new("Text")
        hpText.Size = 13
        hpText.Outline = true
        hpText.Center = true
        hpText.Visible = false

        local highlight = Instance.new("Highlight")
        highlight.FillColor = Color3.fromRGB(0, 255, 0)
        highlight.OutlineColor = Color3.fromRGB(0, 255, 0)
        highlight.FillTransparency = 0.4
        highlight.OutlineTransparency = 0.2
        highlight.DepthMode = Enum.HighlightDepthMode.Occluded
        highlight.Enabled = false
        local targetParent = game:GetService("CoreGui")
        pcall(function() if gethui then targetParent = gethui() end end)
        pcall(function() highlight.Parent = targetParent end)

        ESPObjects[player] = {Box = box, Name = nameText, Highlight = highlight, HpBarBg = hpBarBg, HpBar = hpBar, HpText = hpText}
    end

    -- =====================================
    -- MAIN RENDER LOOP
    -- =====================================

    RunService.RenderStepped:Connect(function()
        local Camera = workspace.CurrentCamera
        local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        local mousePos = UserInputService:GetMouseLocation()

        -- Camera lock removed

        if AshlyState.SpeedEnabled then
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hum and hrp and hum.MoveDirection.Magnitude > 0 then
                    local extraSpeed = math.clamp((AshlyState.SpeedValue - 16) / 50, 0, 5) 
                    hrp.CFrame = hrp.CFrame + (hum.MoveDirection * extraSpeed)
                end
            end
        end

        if AshlyState.TelekillEnabled and _currentTelekillTarget then
            local target = _currentTelekillTarget
            local lpChar = LocalPlayer.Character
            local lpRoot = GetRootPart(lpChar)
            if target and lpRoot then
                local tChar = target.Character
                local tRoot = GetRootPart(tChar)
                if tRoot then
                    local backPos = tRoot.Position - (tRoot.CFrame.LookVector * 3)
                    lpRoot.CFrame = CFrame.new(backPos, tRoot.Position)
                    lpRoot.CFrame = lpRoot.CFrame * CFrame.new(0, 0, 0)
                end
            end
        end

        if AshlyState.FOVEnabled and AshlyState.AimbotEnabled then
            FOVCircle.Position = screenCenter
            FOVCircle.Visible = true
        else
            FOVCircle.Visible = false
        end

        if AshlyState.ESPEnabled or AshlyState.ChamsEnabled then
            for _, player in pairs(Players:GetPlayers()) do
                if player == LocalPlayer then continue end
                local isEnemy = IsEnemy(player)

                if not isEnemy then
                    if ESPObjects[player] then
                        ESPObjects[player].Box.Visible = false
                        ESPObjects[player].Name.Visible = false
                        if ESPObjects[player].HpBarBg then ESPObjects[player].HpBarBg.Visible = false end
                        if ESPObjects[player].HpBar then ESPObjects[player].HpBar.Visible = false end
                        if ESPObjects[player].HpText then ESPObjects[player].HpText.Visible = false end
                        if ESPObjects[player].Highlight then ESPObjects[player].Highlight.Enabled = false end
                    end
                    continue
                end

                if not ESPObjects[player] then CreateESP(player) end

                local char = GetCharacter(player)
                local root = GetRootPart(char)
                local alive = IsAlive(char)
                local obj = ESPObjects[player]

                if root and alive then
                    if AshlyState.ChamsEnabled and obj.Highlight then
                        if obj.Highlight.Adornee ~= char then obj.Highlight.Adornee = char end
                        obj.Highlight.Enabled = true
                        if isEnemy then
                            obj.Highlight.FillColor = Color3.fromRGB(0, 255, 0)
                            obj.Highlight.OutlineColor = Color3.fromRGB(0, 255, 0)
                        else
                            obj.Highlight.FillColor = Color3.fromRGB(0, 255, 255)
                            obj.Highlight.OutlineColor = Color3.fromRGB(0, 255, 255)
                        end
                    else
                        if obj.Highlight then obj.Highlight.Enabled = false end
                    end

                    if AshlyState.ESPEnabled or AshlyState.HPEnabled then
                        local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
                        if onScreen then
                            local size = Vector2.new(4000 / pos.Z, 6000 / pos.Z)
                            local boxPos = Vector2.new(pos.X - size.X / 2, pos.Y - size.Y / 2)
                            local color = isEnemy and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(50, 255, 255)
                            
                            if AshlyState.ESPEnabled then
                                obj.Box.Size = size
                                obj.Box.Position = boxPos
                                obj.Box.Color = color
                                obj.Name.Color = color
                                obj.Box.Visible = true
                                obj.Name.Text = player.Name
                                obj.Name.Position = Vector2.new(pos.X, pos.Y - size.Y / 2 - 20)
                                obj.Name.Visible = true
                            else
                                obj.Box.Visible = false
                                obj.Name.Visible = false
                            end
                            
                            if AshlyState.HPEnabled then
                                local hum = GetHumanoid(char)
                                if hum then
                                    local maxHp = hum.MaxHealth > 0 and hum.MaxHealth or 100
                                    local hp = hum.Health
                                    local hpPercent = math.clamp(hp / maxHp, 0, 1)
                                    local barHeight = size.Y * hpPercent
                                    obj.HpBarBg.Size = Vector2.new(4, size.Y)
                                    obj.HpBarBg.Position = Vector2.new(boxPos.X - 8, boxPos.Y)
                                    obj.HpBarBg.Visible = true
                                    obj.HpBar.Size = Vector2.new(2, barHeight)
                                    obj.HpBar.Position = Vector2.new(boxPos.X - 7, boxPos.Y + (size.Y - barHeight))
                                    obj.HpBar.Color = Color3.fromRGB(255 - (hpPercent * 255), hpPercent * 255, 0)
                                    obj.HpBar.Visible = true
                                    obj.HpText.Text = tostring(math.floor(hp))
                                    obj.HpText.Position = Vector2.new(boxPos.X - 20, boxPos.Y + (size.Y - barHeight) - 6)
                                    obj.HpText.Color = obj.HpBar.Color
                                    obj.HpText.Visible = true
                                else
                                    if obj.HpBarBg then obj.HpBarBg.Visible = false end
                                    if obj.HpBar then obj.HpBar.Visible = false end
                                    if obj.HpText then obj.HpText.Visible = false end
                                end
                            else
                                if obj.HpBarBg then obj.HpBarBg.Visible = false end
                                if obj.HpBar then obj.HpBar.Visible = false end
                                if obj.HpText then obj.HpText.Visible = false end
                            end
                        else
                            obj.Box.Visible = false
                            obj.Name.Visible = false
                            if obj.HpBarBg then obj.HpBarBg.Visible = false end
                            if obj.HpBar then obj.HpBar.Visible = false end
                            if obj.HpText then obj.HpText.Visible = false end
                        end
                    else
                        obj.Box.Visible = false
                        obj.Name.Visible = false
                        if obj.HpBarBg then obj.HpBarBg.Visible = false end
                        if obj.HpBar then obj.HpBar.Visible = false end
                        if obj.HpText then obj.HpText.Visible = false end
                    end
                else
                    obj.Box.Visible = false
                    obj.Name.Visible = false
                    if obj.HpBarBg then obj.HpBarBg.Visible = false end
                    if obj.HpBar then obj.HpBar.Visible = false end
                    if obj.HpText then obj.HpText.Visible = false end
                    if obj.Highlight then obj.Highlight.Enabled = false end
                end
            end
        else
            for _, obj in pairs(ESPObjects) do
                obj.Box.Visible = false
                obj.Name.Visible = false
                if obj.HpBarBg then obj.HpBarBg.Visible = false end
                if obj.HpBar then obj.HpBar.Visible = false end
                if obj.HpText then obj.HpText.Visible = false end
                if obj.Highlight then obj.Highlight.Enabled = false end
            end
        end

        -- Aimbot: find closest enemy in FOV
        if AshlyState.AimbotEnabled then
            local closestDist = math.huge
            local closestPlayer = nil

            for _, player in pairs(Players:GetPlayers()) do
                if player == LocalPlayer then continue end
                if not IsEnemy(player) then continue end
                local char = GetCharacter(player)
                if not char or not IsAlive(char) then continue end
                local part = GetHitbox(char, AshlyState.SelectedHitbox) or GetRootPart(char)
                if not part then continue end
                local targetPos = GetPredictedPosition(part)
                local pos, onScreen = Camera:WorldToViewportPoint(targetPos)
                if onScreen then
                    local screenPos = Vector2.new(pos.X, pos.Y)
                    local dist = (screenPos - screenCenter).Magnitude
                    if AshlyState.FOVEnabled and dist > FOVCircle.Radius then continue end
                    if dist < closestDist then
                        closestDist = dist
                        closestPlayer = player
                    end
                end
            end
            AimbotTarget = closestPlayer
            
            -- Apply aimbot via camera CFrame
            if AimbotTarget then
                local char = GetCharacter(AimbotTarget)
                local part = GetHitbox(char, AshlyState.SelectedHitbox) or GetRootPart(char)
                if part and IsAlive(char) then
                    local targetPos = GetPredictedPosition(part)
                    -- Smoothly lock the camera to the target using Lerp
                    local targetCFrame = CFrame.new(Camera.CFrame.Position, targetPos)
                    Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, 0.15)
                end
            end
        else
            AimbotTarget = nil
        end

        if AshlyState.ShowAimIndicator and AshlyState.AimbotEnabled and AimbotTarget then
            local char = GetCharacter(AimbotTarget)
            local part = GetHitbox(char, AshlyState.SelectedHitbox)
            if not part then part = GetRootPart(char) end
            if part and IsAlive(char) then
                local targetPos = GetPredictedPosition(part)
                local pos, onScreen = Camera:WorldToViewportPoint(targetPos)
                if onScreen then
                    local targetScreenPos = Vector2.new(pos.X, pos.Y)
                    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                    AimRing.Position = targetScreenPos
                    AimRing.Visible = true
                    AimDot.Position = targetScreenPos
                    AimDot.Visible = true
                    AimLine.From = screenCenter
                    AimLine.To = targetScreenPos
                    AimLine.Visible = true
                else
                    AimRing.Visible = false
                    AimDot.Visible = false
                    AimLine.Visible = false
                end
            else
                AimRing.Visible = false
                AimDot.Visible = false
                AimLine.Visible = false
            end
        else
            AimRing.Visible = false
            AimDot.Visible = false
            AimLine.Visible = false
        end
    end)

    local function OnCharacterAdded(player)
        player.CharacterAdded:Connect(function()
            task.wait(1)
            if player ~= LocalPlayer then CreateESP(player) end
        end)
    end

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then CreateESP(player) end
        OnCharacterAdded(player)
    end

    Players.PlayerAdded:Connect(function(player)
        if player ~= LocalPlayer then CreateESP(player) end
        OnCharacterAdded(player)
    end)

    Players.PlayerRemoving:Connect(function(player)
        if ESPObjects[player] then
            if ESPObjects[player].Box then ESPObjects[player].Box:Remove() end
            if ESPObjects[player].Name then ESPObjects[player].Name:Remove() end
            if ESPObjects[player].HpBarBg then ESPObjects[player].HpBarBg:Remove() end
            if ESPObjects[player].HpBar then ESPObjects[player].HpBar:Remove() end
            if ESPObjects[player].HpText then ESPObjects[player].HpText:Remove() end
            ESPObjects[player] = nil
        end
    end)

    local function GetClosestEnemyToCharacter()
        local closestDist = math.huge
        local closestEnemy = nil
        local lpChar = LocalPlayer.Character
        if not lpChar then return nil end
        local lpRoot = GetRootPart(lpChar)
        if not lpRoot then return nil end

        for _, p in ipairs(Players:GetPlayers()) do
            if p == LocalPlayer then continue end
            if not IsEnemy(p) then continue end
            local char = p.Character
            if not char or not IsAlive(char) then continue end
            local root = GetRootPart(char)
            if not root then continue end

            local dist = (root.Position - lpRoot.Position).Magnitude
            if dist < closestDist then
                closestDist = dist
                closestEnemy = p
            end
        end
        return closestEnemy
    end

    RunService.Stepped:Connect(function()
        if AshlyState.NoclipEnabled then
            local char = LocalPlayer.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end

        if AshlyState.TelekillEnabled then
            if not _currentTelekillTarget or not IsAlive(GetCharacter(_currentTelekillTarget)) or not IsEnemy(_currentTelekillTarget) then
                _currentTelekillTarget = GetClosestEnemyToCharacter()
            end
            local target = _currentTelekillTarget
            local lpChar = LocalPlayer.Character
            local lpRoot = GetRootPart(lpChar)
            
            if target and lpRoot then
                local tChar = target.Character
                local tRoot = GetRootPart(tChar)
                if tRoot then
                    local backPos = tRoot.Position - (tRoot.CFrame.LookVector * 3)
                    lpRoot.CFrame = CFrame.new(backPos, tRoot.Position)
                    lpRoot.Velocity = tRoot.AssemblyLinearVelocity or Vector3.new(0, 0, 0)
                    lpRoot.RotVelocity = Vector3.new(0, 0, 0)
                    lpRoot.CanCollide = false
                    pcall(function()
                        if sethiddenproperty then sethiddenproperty(lpRoot, "NetworkOwnership", Enum.NetworkOwnership.Automatic) end
                    end)
                end
            end
        else
            _currentTelekillTarget = nil
        end
    end)

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.V then
            if SpeedToggle then SpeedToggle:SetValue(not AshlyState.SpeedEnabled) end
        elseif input.KeyCode == Enum.KeyCode.N then
            if NoclipToggle then NoclipToggle:SetValue(not AshlyState.NoclipEnabled) end
        elseif input.KeyCode == Enum.KeyCode.T then
            if TelekillToggle then TelekillToggle:SetValue(not AshlyState.TelekillEnabled) end
        end
    end)



end -- End of LoadFreeScript

-- =====================================
-- KEY VERIFICATION LOGIC
-- =====================================

local function VerifyKey(key)
    local success, response = pcall(function()
        return game:HttpGet(API_URL .. key)
    end)
    if not success then return "ERROR" end
    return response:gsub("%s+", "")
end

local function InitAuthUI()
    if isfile and isfile(KEY_FILE) then
        local savedKey = readfile(KEY_FILE)
        local status = VerifyKey(savedKey)
        if status == "VALID" then
            LoadFreeScript()
            return
        end
    end

    local targetParent = CoreGui
    pcall(function() if gethui then targetParent = gethui() end end)
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "AshlyAuthFree"
    ScreenGui.Parent = targetParent
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.Size = UDim2.new(0, 350, 0, 250)

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = MainFrame

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Parent = MainFrame
    UIStroke.Color = Color3.fromRGB(255, 100, 100)
    UIStroke.Thickness = 2

    local Title = Instance.new("TextLabel")
    Title.Parent = MainFrame
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 0, 0, 15)
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.Font = Enum.Font.GothamBold
    Title.Text = "Ashly Free Authentication"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 18

    local Subtitle = Instance.new("TextLabel")
    Subtitle.Parent = MainFrame
    Subtitle.BackgroundTransparency = 1
    Subtitle.Position = UDim2.new(0, 0, 0, 45)
    Subtitle.Size = UDim2.new(1, 0, 0, 20)
    Subtitle.Font = Enum.Font.Gotham
    Subtitle.Text = "Enter your Daily Free Key"
    Subtitle.TextColor3 = Color3.fromRGB(180, 180, 180)
    Subtitle.TextSize = 14

    local KeyInput = Instance.new("TextBox")
    KeyInput.Parent = MainFrame
    KeyInput.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    KeyInput.Position = UDim2.new(0.1, 0, 0.35, 0)
    KeyInput.Size = UDim2.new(0.8, 0, 0, 40)
    KeyInput.Font = Enum.Font.GothamSemibold
    KeyInput.PlaceholderText = "ASHLY-XXXXXXXX"
    KeyInput.Text = ""
    KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyInput.TextSize = 14

    local InputCorner = Instance.new("UICorner")
    InputCorner.CornerRadius = UDim.new(0, 6)
    InputCorner.Parent = KeyInput

    local SubmitBtn = Instance.new("TextButton")
    SubmitBtn.Parent = MainFrame
    SubmitBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    SubmitBtn.Position = UDim2.new(0.1, 0, 0.65, 0)
    SubmitBtn.Size = UDim2.new(0.8, 0, 0, 35)
    SubmitBtn.Font = Enum.Font.GothamBold
    SubmitBtn.Text = "Verify Key"
    SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    SubmitBtn.TextSize = 14

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = SubmitBtn

    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Parent = MainFrame
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Position = UDim2.new(0, 0, 0.53, 0)
    StatusLabel.Size = UDim2.new(1, 0, 0, 20)
    StatusLabel.Font = Enum.Font.GothamBold
    StatusLabel.Text = ""
    StatusLabel.TextSize = 12

    local DiscordBtn = Instance.new("TextButton")
    DiscordBtn.Parent = MainFrame
    DiscordBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    DiscordBtn.Position = UDim2.new(0.1, 0, 0.82, 0)
    DiscordBtn.Size = UDim2.new(0.8, 0, 0, 30)
    DiscordBtn.Font = Enum.Font.GothamBold
    DiscordBtn.Text = "Join Discord for Key"
    DiscordBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    DiscordBtn.TextSize = 13
    
    local DiscordCorner = Instance.new("UICorner")
    DiscordCorner.CornerRadius = UDim.new(0, 6)
    DiscordCorner.Parent = DiscordBtn

    DiscordBtn.MouseButton1Click:Connect(function()
        pcall(function() setclipboard("https://discord.gg/uevZf2qtM") end)
        DiscordBtn.Text = "Copied to Clipboard!"
        task.wait(1.5)
        DiscordBtn.Text = "Join Discord for Key"
    end)

    SubmitBtn.MouseButton1Click:Connect(function()
        local key = KeyInput.Text
        if key == "" then
            StatusLabel.Text = "Please enter a key"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
            return
        end

        SubmitBtn.Text = "Checking..."
        local status = VerifyKey(key)

        if status == "VALID" then
            StatusLabel.Text = "Access Granted!"
            StatusLabel.TextColor3 = Color3.fromRGB(50, 255, 50)
            if writefile then writefile(KEY_FILE, key) end
            task.wait(1)
            ScreenGui:Destroy()
            LoadFreeScript()
        elseif status == "ERROR" then
            StatusLabel.Text = "Server Error (Check Domain)"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
        else
            StatusLabel.Text = "Invalid Free Key"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
        end
        SubmitBtn.Text = "Verify Key"
    end)
end

InitAuthUI()

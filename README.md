# Xeric UI Library 🎨

A modern, feature-rich **UI library** for Roblox with smooth animations, responsive design, comprehensive components, and a built-in flag system.

## Features ✨
- 🎯 **Responsive Design** — Automatically adapts to PC (900x650) and Mobile (450x600)
- 🌊 **Smooth Animations** — Ripple effects, tweens, hover transitions, and elastic window open/minimize
- 📱 **Touch Support** — Full mobile and tablet compatibility with draggable elements
- 🎨 **Modern Theme** — Sleek dark theme with red primary accents
- 🔔 **Notification System** — 4 types (Default, Success, Warning, Error) with customizable duration
- 🪟 **Minimizable Window** — Collapse to title bar with pulsing animated title color
- ⚡ **Flag System** — Save and retrieve values easily across components (great for config saving/loading)

---
## Installation
```lua
local Library = loadstring(game:HttpGet("put raw url here"))() 
```

---
## Basic Setup
```lua
-- Create Window
local Window = Library:CreateWindow({
    Name = "Xeric UI",
    Icon = "rbxassetid://YOUR_ICON_ID"  -- Optional
})

-- Create Tab
local Tab = Window:CreateTab({
    Name = "Main"
})
```

---
## Components

### 1. Button
Creates a clickable button with ripple effect.
```lua
Tab:AddButton({
    Name = "Click Me",
    Callback = function()
        print("Button clicked!")
    end
})
```
**Properties:**
- `Name` (string)
- `Callback` (function)

---
### 2. Label
Non-interactive text label.
```lua
Tab:AddLabel({
    Text = "This is a label"
})
```
**Properties:**
- `Text` (string)

---
### 3. Divider
Horizontal separator, optional with text.
```lua
Tab:AddDivider()  -- Line only
Tab:AddDivider({Text = "Section Title"})
```
**Properties:**
- `Text` (string, optional)

---
### 4. Text Input
Text box with callback on Enter.
```lua
local input = Tab:AddTextInput({
    Name = "Username",
    Placeholder = "Enter text...",
    Default = "",
    ClearTextOnFocus = false,
    Flag = "UsernameFlag",  -- Optional flag
    Callback = function(text)
        print("Entered:", text)
    end
})

input:Set("Hello")
print(input:Get())
```
**Properties:**
- `Name`, `Placeholder`, `Default`, `ClearTextOnFocus`, `Flag` (optional), `Callback`
**Methods:**
- `:Set(text)`
- `:Get()`

---
### 5. Toggle
Smooth sliding toggle switch.
```lua
local toggle = Tab:AddToggle({
    Name = "Enable Feature",
    Default = false,
    Flag = "FeatureFlag",  -- Optional
    Callback = function(value)
        print("Toggle:", value)
    end
})

toggle:Set(true)
```
**Properties:**
- `Name`, `Default`, `Flag` (optional), `Callback`
**Methods:**
- `:Set(value)`

---
### 6. Slider
Draggable numeric slider with increment support.
```lua
local slider = Tab:AddSlider({
    Name = "Speed",
    Min = 16,
    Max = 200,
    Default = 50,
    Increment = 1,
    Flag = "SpeedFlag",  -- Optional
    Callback = function(value)
        print("Value:", value)
    end
})

slider:Set(100)
```
**Properties:**
- `Name`, `Min`, `Max`, `Default`, `Increment`, `Flag` (optional), `Callback`
**Methods:**
- `:Set(value)`

---
### 7. Dropdown
Single-select dropdown.
```lua
local dropdown = Tab:AddDropdown({
    Name = "Choose Option",
    Options = {"Option1", "Option2", "Option3"},
    Default = "Option1",
    Flag = "DropdownFlag",  -- Optional
    Callback = function(selected)
        print("Selected:", selected)
    end
})

dropdown:Set("Option2")
```
**Properties:**
- `Name`, `Options`, `Default`, `Flag` (optional), `Callback`
**Methods:**
- `:Set(value)`

---
### 8. Multi Dropdown
Multi-select dropdown with checkboxes.
```lua
local multi = Tab:AddMultiDropdown({
    Name = "Select Multiple",
    Options = {"A", "B", "C"},
    Default = {"A", "C"},
    Flag = "MultiFlag",  -- Optional array
    Callback = function(selected)  -- selected is array
        print("Selected:", table.concat(selected, ", "))
    end
})

multi:Set({"B"})
```
**Properties:**
- `Name`, `Options`, `Default` (array), `Flag` (optional), `Callback`
**Methods:**
- `:Set(array)`

---
## Flag System
**Yes, this library has a built-in flag system!**

Each tab has a `Flags` table: `Tab.Flags` (a dictionary).

- Add `Flag = "MyFlag"` to any component (TextInput, Toggle, Slider, Dropdown, MultiDropdown).
- The component automatically updates `Tab.Flags["MyFlag"]` on change.
- Access values anytime: `print(Tab.Flags["MyFlag"])`
- Great for saving/loading configs:
```lua
-- Save example
local save = {}
for flag, value in pairs(Tab.Flags) do
    save[flag] = value
end
-- Write to datastore or file

-- Load example
for flag, value in pairs(savedData) do
    if Tab.Flags[flag] ~= nil then
        -- Use component references or manually set Tab.Flags[flag] = value
    end
end
```

---
## Notifications
```lua
Window:Notify({
    Title = "Success",
    Content = "Operation complete",
    Duration = 5,
    Type = "Success"  -- Default, Success, Warning, Error
})
```

---
## Complete Example
```lua
local Library = loadstring(game:HttpGet("xericui-url"))()

local Window = Library:CreateWindow({Name = "Xeric UI Library"})

Window:Notify({
    Title = "Loaded!",
    Content = "Enjoy the UI",
    Type = "Success",
    Duration = 4
})

local MainTab = Window:CreateTab({Name = "Main"})

MainTab:AddLabel({Text = "Welcome!"})
MainTab:AddButton({Name = "Test", Callback = function() print("Works!") end})

local myToggle = MainTab:AddToggle({
    Name = "Example Toggle",
    Default = true,
    Flag = "ExampleToggle",
    Callback = function(v) print(v) end
})

print("Flag value:", MainTab.Flags["ExampleToggle"])
```

---
**Enjoy the powerful and beautiful Xeric UI Library!**

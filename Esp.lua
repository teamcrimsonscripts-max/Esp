-- LocalScript inside StarterPlayerScripts
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- --- UI CREATION ---
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KirusDevPanel"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main Container
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 220, 0, 130)
Frame.Position = UDim2.new(0.1, 0, 0.1, 0)
Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Frame.BorderSizePixel = 0
Frame.ClipsDescendants = true
Frame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = Frame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(0, 255, 0)
UIStroke.Thickness = 2
UIStroke.Parent = Frame

-- X Button (Minimize)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(1, -30, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.TextSize = 14
CloseBtn.Parent = Frame

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 4)
CloseCorner.Parent = CloseBtn

-- Rest of the UI
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "ESP BY KIRUS"
Title.TextColor3 = Color3.fromRGB(0, 255, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.RobotoMono
Title.TextSize = 16
Title.Parent = Frame

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 180, 0, 45)
ToggleBtn.Position = UDim2.new(0.5, -90, 0.5, 10)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
ToggleBtn.Text = "STATUS: OFF"
ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.TextSize = 16
ToggleBtn.Parent = Frame

local BtnCorner = Instance.new("UICorner")
BtnCorner.Parent = ToggleBtn

-- --- MINIMIZE LOGIC ---
local isMinimized = false
local originalSize = Frame.Size

CloseBtn.MouseButton1Click:Connect(function()
	isMinimized = not isMinimized
	
	if isMinimized then
		-- Shrink to "ESP" tab
		TweenService:Create(Frame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, 60, 0, 30)
		}):Play()
		Title.Text = "ESP"
		Title.TextSize = 14
		Title.Size = UDim2.new(1, 0, 1, 0)
		ToggleBtn.Visible = false
		CloseBtn.Text = "+"
		CloseBtn.TextColor3 = Color3.fromRGB(0, 255, 0)
	else
		-- Restore to full size
		TweenService:Create(Frame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Size = originalSize
		}):Play()
		Title.Text = "ESP BY KIRUS"
		Title.TextSize = 16
		Title.Size = UDim2.new(1, 0, 0, 40)
		ToggleBtn.Visible = true
		CloseBtn.Text = "X"
		CloseBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
	end
end)

-- --- IMPROVED DRAGGING ---
local dragging, dragInput, dragStart, startPos

Frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = Frame.Position
		
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

-- --- ESP LOGIC (Simplified for brevity) ---
local espEnabled = false
local activeFolders = {}

local function clearESP()
	for _, v in pairs(activeFolders) do if v then v:Destroy() end end
	activeFolders = {}
end

local function applyESP(player)
	if player == LocalPlayer then return end
	local function setup(char)
		if not espEnabled then return end
		local h = Instance.new("Highlight", char)
		h.FillColor = Color3.fromRGB(0, 255, 0)
		table.insert(activeFolders, h)
	end
	player.CharacterAdded:Connect(setup)
	if player.Character then setup(player.Character) end
end

ToggleBtn.MouseButton1Click:Connect(function()
	espEnabled = not espEnabled
	ToggleBtn.Text = espEnabled and "STATUS: ON" or "STATUS: OFF"
	ToggleBtn.BackgroundColor3 = espEnabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(35, 35, 35)
	if espEnabled then
		for _, p in pairs(Players:GetPlayers()) do applyESP(p) end
	else
		clearESP()
	end
end)

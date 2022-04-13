--loadstring(game:HttpGet("https://raw.githubusercontent.com/SigurdOrUsername/BCWO/main/BCWO_Autofarm.lua?token=GHSAT0AAAAAABTQJQ7F3I6RHIXW7RDTXTGUYSWEQWA", true))()

local Player = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

loadstring(game:HttpGet("https://pastebin.com/raw/cwDSpepQ", true))()
local ESP = loadstring(game:HttpGet("https://pastebin.com/raw/k2CcQ9hw"))()

local Window = library:AddWindow("Lol")
local General_Tab = Window:AddTab("General")
local Character_Tab = Window:AddTab("Char cheats")
local Statistics_Tab = Window:AddTab("Stats")

--// GENERAL TAB

--[[
local RegenWhenLow = false
General_Tab:AddSwitch("Regen", function(Value)
end)
]]

local AutofarmMobs = false
General_Tab:AddSwitch("Auto attack mobs", function(Value)
    AutofarmMobs = Value
end)

local AutofarmMobName = ""
General_Tab:AddTextBox("Mob name (For all mobs, write all)", function(Value)
    AutofarmMobName = Value:lower()
end)

--// CHAR CHEATS TAB

local NoCd = false
Character_Tab:AddSwitch("No cooldown for swinging / shooting", function(Value)
    NoCd = Value
end)

local MultipleHits = false
Character_Tab:AddSwitch("Multiple hits", function(Value)
    MultipleHits = Value
end)

Character_Tab:AddLabel("This auto-enables when autofarming")

local HitsPerUse = 1
Character_Tab:AddSlider("Hits per use", function(Value)
    HitsPerUse = Value
end, {
    ["min"] = 1,
    ["max"] = 100
})

local CharFolder = Character_Tab:AddFolder("Character Mods")

CharFolder:AddTextBox("Walkspeed", function(Value)
    Player.Character.Humanoid.WalkSpeed = tonumber(Value)
end)

CharFolder:AddTextBox("Jumpheight", function(Value)
    Player.Character.Humanoid.JumpHeight = tonumber(Value)
end)

local NoClip = false
CharFolder:AddSwitch("No-clip", function(Value)
    NoClip = Value
end)

--// ESP / MINES SPESIFIC OPTIONS
local FileName = "OreEsp.json"
local Settings

local FarmNonBlacklistedOre = false
local BlacklistData = {}
local BlacklistData_Visual = {}
local DropdownData

if not isfile(FileName) then
    writefile(FileName, HttpService:JSONEncode(BlacklistData))
else
    Settings = HttpService:JSONDecode(readfile(FileName))
    BlacklistData = Settings
end

if workspace:WaitForChild("Map", 5) and workspace.Map:FindFirstChild("Ores") then --We're currently in the mines
    local Ore_Tab = Window:AddTab("Ore")
    local ESP_Tab = Window:AddTab("ESP Settings")

    Ore_Tab:AddSwitch("Enable ESP", function(Value)
        ESP:Toggle(Value)
        ESP.Names = Value
    end)

    Ore_Tab:AddSwitch("Farm non-blacklisted ore (Risky)", function(Value)
        FarmNonBlacklistedOre = Value
    end)

    ESP_Tab:AddTextBox("Add to ore ESP/Farm blacklist", function(Value)
        Value = Value:lower()
        if not BlacklistData_Visual[Value] then
            BlacklistData_Visual[Value] = DropdownData:Add(Value)
            BlacklistData[Value] = Value
            writefile(FileName, HttpService:JSONEncode(BlacklistData))
        end
    end)
    
    ESP_Tab:AddTextBox("Remove from ore ESP/Farm blacklist", function(Value)
        Value = Value:lower()
        if BlacklistData_Visual[Value] then
            BlacklistData_Visual[Value]:Remove(Value)
            BlacklistData_Visual[Value] = nil
            BlacklistData[Value] = nil
            writefile(FileName, HttpService:JSONEncode(BlacklistData))
        end
    end)
    
    DropdownData = ESP_Tab:AddDropdown("Ore ESP blacklist", function()
    end)

    if Settings then
        for Index, Value in next, Settings do
            BlacklistData_Visual[Index] = DropdownData:Add(Index)
        end
    end

    --// ESP OBJECT VISUALS

    for Index, Value in next, workspace.Map.Ores:GetChildren() do
        ESP:Add(Value, {
            PrimaryPart = Value:FindFirstChild("HumanoidRootPart"),
            Name = Value.Name,
            Color = Value.Mineral.Color,
            Visible = false,
            IsEnabled = Value.Name
        })
    end

    workspace.Map.Ores.ChildAdded:Connect(function(Child)
        Child:WaitForChild("Mineral")
        ESP:Add(Child, {
            PrimaryPart = Child:FindFirstChild("HumanoidRootPart"),
            Name = Child.Name,
            Color = Child.Mineral.Color,
            Visible = false,
            IsEnabled = Child.Name
        })
    end)
end

--// TELEPORT FUNCTIONS

local Teleport = Window:AddTab("Teleports")

Teleport:AddButton("Teleport to the beneath", function()
    if workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("BeneathTeleporter") then
        Player.Character.HumanoidRootPart.CFrame = workspace.Map.BeneathTeleporter.center.CFrame
    end
end)

--//Timer + statistcs

local Timer = 0
local Minutes = 0
local Hours = 0
local TimerTab = Statistics_Tab:AddLabel("Time: 0:0:0")

task.spawn(function()
    while wait() do
        Timer = Timer + 1

        if Timer == 60 then
            Minutes = Minutes + 1
            Timer = 0
        end

        if Minutes == 60 then
            Hours = Hours + 1
            Minutes = 0
        end

        TimerTab.Text = "Time: " .. tostring(Hours) .. ":" .. tostring(Minutes) .. ":" .. tostring(Timer)
        wait(1)
    end
end)

local StatisticsData = {}
local Statistics_Tab_Bosses = Statistics_Tab:AddFolder("Boss Spawns")
local Statistics_Tab_Drops = Statistics_Tab:AddFolder("Drops")

workspace.ChildRemoved:Connect(function(Child)
    if Child:FindFirstChild("Boss") and Child:FindFirstChild("Humanoid") and Child.Humanoid:FindFirstChild("creator") and Child.Humanoid.creator.Value == Player then

        if not StatisticsData[Child.Name] then
            StatisticsData[Child.Name] = {Statistics_Tab_Bosses:AddLabel(Child.Name .. ": 1"), 1}
        else
            local Amount = StatisticsData[Child.Name][2]

            StatisticsData[Child.Name][2] = Amount + 1
            StatisticsData[Child.Name][1].Text = Child.Name .. ": " .. tostring(Amount + 1)
        end

    end
end)

local function GetClosest()
    local Last = math.huge
    local Closest

    for Index, Value in next, workspace:GetChildren() do
        local MainPart = Value:FindFirstChildWhichIsA("MeshPart") or Value:FindFirstChildWhichIsA("Part")

        if Value:FindFirstChild("EnemyMain") and MainPart and not Value:FindFirstChild("ForceField") and Value.Humanoid.Health > 0 and (AutofarmMobName == "all" or Value.Name:lower():find(AutofarmMobName)) then
            
            local Dist = (Player.Character.HumanoidRootPart.Position - MainPart.Position).Magnitude
            if Last > Dist then
                Closest = Value
                Last = Dist
            end
        end
    end

    return Closest
end

--//Anti Afk

for Index, Value in next, getconnections(Player.Idled) do
    Value:Disable()
end

local ToolName
local AnimationDebounce = false

for Index, Value in next, Player.Character:GetChildren() do
    if (#Value:GetChildren() == 2 and Value.ClassName == "Folder") then
        Value:ClearAllChildren()
    end
end

local Blacklist = {
    "System",
    "Chat",
    "ChatMain",
    "LocalCraft",
    "Animate",
    "Health",
    "GuiControl",
    "Boss",
    "CameraScript"
}

local OldWait
OldWait = hookfunction(getrenv().wait, function(Args)
    if not table.find(Blacklist, tostring(getcallingscript())) and NoCd then
        return OldWait()
    end
    
    return OldWait(Args)
end)

local OldNamecall
OldNamecall = hookmetamethod(game, "__namecall", function(Self, ...)
    local Args = {...}

    if getnamecallmethod() == "InvokeServer" and tostring(Self) == "RemoteFunction" and MultipleHits and not checkcaller() then
       task.spawn(function()
            for Index = 1, HitsPerUse do
                task.spawn(function()
                    Self.InvokeServer(Self, unpack(Args))
                end)
                task.wait()
            end
        end)
    end

    return OldNamecall(Self, unpack(Args))
end)

RunService.Stepped:connect(function()
    local Tool = Player.Character:FindFirstChildWhichIsA("Tool")

    if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        
        --Noclip

        for Index, Value in next, Player.Character:GetChildren() do
            if (#Value:GetChildren() == 2 and Value.ClassName == "Folder") then
                Value:ClearAllChildren()
            end
        end

        for Index, Value in next, Player.Character:GetDescendants() do
            if Value:IsA("BasePart") and Value.CanCollide then
                if NoClip or AutofarmMobs or FarmNonBlacklistedOre then
                    Value.CanCollide = false
                end
            end
        end

        if AutofarmMobs or FarmNonBlacklistedOre then
            Player.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
        end

        if AutofarmMobs and ToolName then
            if Player.Backpack:FindFirstChild(ToolName) then
                Player.Backpack:FindFirstChild(ToolName).Parent = Player.Character
            end
        end

        if workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Ores") then
            for Index, Value in next, workspace.Map.Ores:GetChildren() do
                local IsWhitelistedOre = not BlacklistData[Value.Name:lower()]
                
                if FarmNonBlacklistedOre and Tool and Tool:FindFirstChild("RemoteFunction") and Value:FindFirstChild("Properties") and Value.Properties.Hitpoint.Value > 0 and IsWhitelistedOre then
                    Player.Character.HumanoidRootPart.CFrame = Value.Mineral.CFrame + Vector3.new(0, - (Value.Mineral.Size.Y * 1.5), 0)
                    Tool.RemoteFunction:InvokeServer("hit", {
                        Value.Properties.Hitpoint,
                        Value.Properties.Toughness,
                        Value.Properties.Owner
                    })
                end

                ESP[Value.Name] = IsWhitelistedOre
            end
        end

        if Tool and Tool:FindFirstChild("RemoteFunction") then
            local Closest = GetClosest()

            getgenv().Penis = -200
            ToolName = Tool.Name
            if (AutofarmMobs) and Closest and Closest:FindFirstChildWhichIsA("Part") then
                local MainPart = Closest:FindFirstChildWhichIsA("Part")
                
                if Tool:FindFirstChild("GunMain") then

                    if AutofarmMobs then
                        local RndX = math.random(-100, 100)
                        local RndY = math.random(-100, 100)
                        local RndZ = math.random(-100, 100)
    
                        Player.Character.HumanoidRootPart.CFrame = CFrame.new(999 + RndX, 999 + RndY, 999 + RndZ)
                    end

                    task.spawn(function()
                        task.wait()
                        Tool.RemoteFunction:InvokeServer("shoot", {
                            MainPart.CFrame,
                        Tool.Damage.Value
                        })
                    end)

                else

                    Player.Character.HumanoidRootPart.CFrame = MainPart.CFrame + Vector3.new(0, 500, 0)
                    --[[
                    local DifferenceX = Player.Character.HumanoidRootPart.Position.X - MainPart.Position.X
                    local DifferenceY = Player.Character.HumanoidRootPart.Position.Y - MainPart.Position.Y
                    local DifferenceZ = Player.Character.HumanoidRootPart.Position.Z - MainPart.Position.Y
                    ]]

                    Tool.Grip = CFrame.new(2, 500, 6)
                    Tool.RemoteFunction:InvokeServer("hit", {
                        Tool.Damage.Value,
                        0
                    })
                end
            end
        end
    end
end)

--loadstring(game:HttpGet("https://raw.githubusercontent.com/SigurdOrUsername/School-Project/main/RasberryMain_OLD.lua", true))()

print("V_OLD: 1.16")

local Player = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

loadstring(game:HttpGet("https://pastebin.com/raw/cwDSpepQ", true))()
local ESP = loadstring(game:HttpGet("https://pastebin.com/raw/k2CcQ9hw"))()

local Window = library:AddWindow("Lol")
local General_Tab = Window:AddTab("General")
local Character_Tab = Window:AddTab("Char cheats")
local Statistics_Tab = Window:AddTab("Stats")
local Misc_Tab = Window:AddTab("Misc")

--// GENERAL TAB

local Tool
local AutofarmMobs = false
General_Tab:AddSwitch("Auto attack mobs", function(Value)
    AutofarmMobs = Value

    if not Value then
        Tool.Grip = CFrame.new(0, 0, 0)
    end
end)

local Distance = 5
General_Tab:AddSlider("Distance from mob", function(Value)
    Distance = Value
end, {
    ["min"] = 5,
    ["max"] = 100
})

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

local InstantHit = false
Character_Tab:AddSwitch("No delay when using multiple hits [Lag warning]", function(Value)
    InstantHit = Value
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

--// MISC OPTIONS

local CollectEggs = false
Misc_Tab:AddSwitch("Collect all eggs in area", function(Value)
    CollectEggs = Value
end)

local EggWait = 1
Misc_Tab:AddTextBox("Collecting delay [Cannot go lower than 1 sec]", function(Value)
    if tonumber(Value) and Value >= 1 then
        EggWait = tonumber(Value)
    end
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

--We're currently in the mines
if workspace:WaitForChild("Map", 3) and workspace.Map:FindFirstChild("Ores") then
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
    while task.wait() do
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
        task.wait(1)
    end
end)

local StatisticsData_Bosses = {}
local StatisticsData_Drops = {}
local StatisticsData_Biomes = {}

local Statistics_Tab_Bosses = Statistics_Tab:AddFolder("Boss Kills")
local Statistics_Tab_Drops = Statistics_Tab:AddFolder("Drops")
local Statistics_Tab_Biomes = Statistics_Tab:AddFolder("Biomes")

workspace.ChildRemoved:Connect(function(Child)
    if Child:FindFirstChild("Boss") and Child:FindFirstChild("Humanoid") and Child.Humanoid:FindFirstChild("creator") and Child.Humanoid.creator.Value == Player then

        task.wait(0.5)
        if not StatisticsData_Bosses[Child.Name] then
            StatisticsData_Bosses[Child.Name] = {Statistics_Tab_Bosses:AddLabel(Child.Name .. ": 1"), 1}
        else
            local Amount = StatisticsData_Bosses[Child.Name][2]

            StatisticsData_Bosses[Child.Name][2] = Amount + 1
            StatisticsData_Bosses[Child.Name][1].Text = Child.Name .. ": " .. tostring(Amount + 1)
        end

    end
end)

Player.PlayerScripts.ClientControl.Event:Connect(function(Info)
    if Info then
        local Number = string.match(Info.msg, "%d")
        local Matched = string.match(Info.msg, "got%s(%b" .. Number .. "!)")
        local Name = Matched:sub(3, #Matched - 1)

        if Number and Matched and Name then
            for Index = 1, Number do

                task.wait(0.5)
                if not StatisticsData_Drops[Name] then
                    StatisticsData_Drops[Name] = {Statistics_Tab_Drops:AddLabel(Name .. ": 1"), 1}
                else
                    local Amount = StatisticsData_Drops[Name][2]

                    StatisticsData_Drops[Name][2] = Amount + 1
                    StatisticsData_Drops[Name][1].Text = Name .. ": " .. tostring(Amount + 1)
                end
            end
        end
    end
end)

local Name
local Color
local AddNewLabel = false

task.spawn(function()
    while wait() do
        if AddNewLabel then

            if not StatisticsData_Biomes[Name] then
                StatisticsData_Biomes[Name] = {Statistics_Tab_Biomes:AddLabel(Name .. ": 1"), 1}
                StatisticsData_Biomes[Name][1].TextColor3 = Color
            else
                local Amount = StatisticsData_Biomes[Name][2]
    
                StatisticsData_Biomes[Name][2] = Amount + 1
                StatisticsData_Biomes[Name][1].Text = Name .. ": " .. tostring(Amount + 1)
            end

            AddNewLabel = false
        end
    end
end)

local OldNamecall
OldNamecall = hookmetamethod(game, "__namecall", function(Self, ...)
    local Args = {...}

    if getnamecallmethod() == "SetCore" then

        task.spawn(function()

            task.wait(0.5)
            print(Args[2].Color, Args[2].Color ~= Color3.new(1, 1, 0))
            --Yellow (Tips, enemy spawns, ect), Red (Player got a rare item) and Player got item
            if Args[2].Color ~= Color3.new(1, 1, 0) and Args[2].Color ~= Color3.new(1, 0.25, 0.25) and not string.find(Args[2].Text, "got") then

                Name = Args[2].Text
                Color = Args[2].Color
                AddNewLabel = true

            end
        end)
    end

    if not checkcaller() then
        if getnamecallmethod() == "InvokeServer" and tostring(Self) == "RemoteFunction" and MultipleHits then
            task.spawn(function()
                for Index = 1, HitsPerUse do

                    task.spawn(function()
                        if not InstantHit then
                            task.wait()
                        end

                        Self.InvokeServer(Self, unpack(Args))
                    end)

                end
            end)
        end
    end

    return OldNamecall(Self, ...)
end)

--//Anti Afk

for Index, Value in next, getconnections(Player.Idled) do
    if Value["Disable"] then
        Value["Disable"](Value)
    end

    if Value["Disconnect"] then
        Value["Disconnect"](Value)
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

--//No cooldown

local OldWait
OldWait = hookfunction(getrenv().wait, function(Args)
    if not table.find(Blacklist, tostring(getcallingscript())) and NoCd then
        return OldWait()
    end
    
    return OldWait(Args)
end)


local function GetClosestMob()
    local Last = math.huge
    local Closest

    for Index, Value in next, workspace:GetChildren() do

        if (Value:FindFirstChild("HumanoidRootPart") or Value:FindFirstChild("Torso")) and not Value:FindFirstChildWhichIsA("ForceField") and Value:FindFirstChild("Humanoid") and Value.Humanoid.Health > 0 then

            local MainPart = (Value:FindFirstChild("HumanoidRootPart") or Value:FindFirstChild("Torso"))
            if Value:FindFirstChild("Boss") then
                return Value.HumanoidRootPart
            end

            if Value:FindFirstChild("EnemyMain") then
                local Dist = (Player.Character.HumanoidRootPart.Position - MainPart.Position).Magnitude
                if Last > Dist then
                    Closest = MainPart
                    Last = Dist
                end
            end
        end
    end

    return Closest
end

local function GetClosestOre()
    local Last = math.huge
    local Closest

    for Index, Value in next, workspace.Map.Ores:GetChildren() do
        local IsWhitelistedOre = not BlacklistData[Value.Name:lower()]
        
        if Value:FindFirstChild("Properties") and Value.Properties.Hitpoint.Value > 0 and IsWhitelistedOre then

            local Dist = (Player.Character.HumanoidRootPart.Position - Value.Mineral.Position).Magnitude
            if Last > Dist then
                Closest = Value
                Last = Dist
            end
        end

        ESP[Value.Name] = IsWhitelistedOre
    end

    return Closest
end

local ToolName
local OldToolName
local ManualOverride = false
local BossSpecialCases = {
    ["Astaroth, The Monarch of Darkness"] = function()
        if Player.Backpack:FindFirstChild("Clarent") then

            ManualOverride = true
            Player.Character:FindFirstChild(ToolName).Parent = Player.Backpack
            ToolName = "Clarent"

        end
    end,
}

local EggDebounce = false
RunService.Stepped:connect(function()
    Tool = Player.Character:FindFirstChildWhichIsA("Tool")

    if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") and Player.Character:FindFirstChild("Right Arm") then
        
        --Collect eggs

        if not EggDebounce then
            task.spawn(function()
                if CollectEggs then

                    EggDebounce = true
                    for Index, Value in next, workspace:GetChildren() do
                        if Value.Name == "Egg" then
                            task.wait(EggWait + math.random())
                            --Player.Character.HumanoidRootPart.CFrame = Value.CFrame
                            --task.wait(2 + math.random(1, 2))
                            --firetouchinterest(Player.Character.HumanoidRootPart, Value, 0)
                            --firetouchinterest(Player.Character.HumanoidRootPart, Value, 1)
                            Value.CFrame = Player.Character.HumanoidRootPart.CFrame
                        end
                    end
                    EggDebounce = false

                end
            end)
        end

        --Noclip + anticheat bypass

        for Index, Value in next, Player.Character:GetChildren() do
            if (#Value:GetChildren() == 2 and Value.ClassName == "Folder") or Value.Name == " " then
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
            Player.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0.25, 0)
        end

        if (AutofarmMobs or FarmNonBlacklistedOre) and ToolName then
            if Player.Backpack:FindFirstChild(ToolName) then
                Player.Backpack:FindFirstChild(ToolName).Parent = Player.Character
            end
        end

        if Tool and Tool:FindFirstChild("RemoteFunction") then

            if FarmNonBlacklistedOre and workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Ores") then

                local ClosestOre = GetClosestOre()
                
                if ClosestOre then
                    Player.Character.HumanoidRootPart.CFrame = ClosestOre.Mineral.CFrame + Vector3.new(0, -(ClosestOre.Mineral.Size.Y * 1.2), 0)

                    ToolName = Tool.Name
                    Tool.RemoteFunction:InvokeServer("hit", {
                        ClosestOre.Properties:FindFirstChild("Hitpoint"),
                        ClosestOre.Properties:FindFirstChild("Toughness"),
                        ClosestOre.Properties:FindFirstChild("Owner")
                    })
                end
            end

            if AutofarmMobs then

                local MainPart = GetClosestMob()

                --warn(MainPart)
                if MainPart then

                    if not ManualOverride then
                        ToolName = Tool.Name
                    end

                    --[[
                    if BossSpecialCases[MainPart.Parent.Name] then
                        BossSpecialCases[MainPart.Parent.Name]()
                    end
                    ]]
                    
                    local ToolLength = 0
                    for Index, Value in next, {Tool.Handle.Size.X, Tool.Handle.Size.Y, Tool.Handle.Size.Z} do
                        if Value > ToolLength then
                            ToolLength = Value
                        end
                    end

                    if Tool:FindFirstChild("Idle") then
                        Tool.Idle:Destroy()

                        --Reloading the tool animations
                        Tool.Parent = Player.Backpack
                        Tool.Parent = Player.Character
                    end

                    if Tool:FindFirstChild("GunMain") or Tool:FindFirstChild("BowMain") then

                        Player.Character.HumanoidRootPart.CFrame = MainPart.CFrame * CFrame.new(5000, 5000, 5000)

                        if Tool:FindFirstChild("GunMain") then
                            Tool.RemoteFunction:InvokeServer("shoot", {
                                MainPart.CFrame,
                                Tool.Damage.Value
                            })

                        else

                            Tool.RemoteFunction:InvokeServer("hit", {
                                MainPart.Parent.Humanoid,
                                Tool.Damage.Value,
                                true
                            })
                        end

                    else

                        Player.Character.HumanoidRootPart.CFrame = CFrame.new(MainPart.Position + Vector3.new(0, 0, ToolLength + Distance))

                        local HumPos = Player.Character.HumanoidRootPart
                        local ArmPos = Player.Character:FindFirstChild("Right Arm")

                        Tool.Grip = CFrame.new(HumPos.Position - MainPart.Position) * CFrame.new(-(MainPart.Position.X - ArmPos.Position.X), 0, -2)

                        Tool.RemoteFunction:InvokeServer("hit", {
                            Tool.Damage.Value,
                            0
                        })
                    end
                end
            end

        end
    end
end)

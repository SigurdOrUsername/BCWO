--loadstring(game:HttpGet("https://raw.githubusercontent.com/SigurdOrUsername/School-Project/main/RasberryMain_OLD.lua", true))()

print("V_OLD: 2.0.7")

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
        Player.Character.Animate.Disabled = false
        workspace.CurrentCamera.CameraSubject = Player.Character.Humanoid
    end
end)

local AutofarmMobName = ""
General_Tab:AddTextBox("Mob name (For all mobs, write all)", function(Value)
    AutofarmMobName = Value:lower()
end)

General_Tab:AddLabel("Misc General tab options")

local Firerate = 0
local Firerate_Slider = General_Tab:AddSlider("Firerate", function(Value)
    Firerate = Value
end, {
    ["min"] = 0,
    ["max"] = 60,
})

Firerate_Slider:Set(100) --The slider's math is based on percentage. Eg. slider of 0, 60, 60 == 100%
Firerate = 60

local Cords = {0, 3000,0}
local CordFolder = General_Tab:AddFolder("Cordinate Offsets [Default: 0, 3000, 0]")

CordFolder:AddTextBox("X", function(Value)
    Cords[1] = Value
end)
CordFolder:AddTextBox("Y", function(Value)
    Cords[2] = Value
end)
CordFolder:AddTextBox("Z", function(Value)
    Cords[3] = Value
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

local HitsPerUse = 1
Character_Tab:AddSlider("Hits per use", function(Value)
    HitsPerUse = Value
end, {
    ["min"] = 1,
    ["max"] = 100
})

Character_Tab:AddLabel("All of the options above will have NO effect when autofarming.")

local CharFolder = Character_Tab:AddFolder("Character Mods")

CharFolder:AddTextBox("Walkspeed", function(Value)
    Player.Character.Humanoid.WalkSpeed = tonumber(Value)
end)

CharFolder:AddTextBox("Jumpheight", function(Value)
    Player:Kick("You have been banned from this experience. Reason: Baugette")
    --Player.Character.Humanoid.JumpHeight = tonumber(Value)
end)

local NoClip = false
CharFolder:AddSwitch("No-clip", function(Value)
    NoClip = Value
end)

--// MISC OPTIONS
--[[
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
]]

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
            table.insert(BlacklistData, Value)

            writefile(FileName, HttpService:JSONEncode(BlacklistData))
        end
    end)
    
    ESP_Tab:AddTextBox("Remove from ore ESP/Farm blacklist", function(Value)
        Value = Value:lower()
        if BlacklistData_Visual[Value] then
            BlacklistData_Visual[Value]:Remove(Value)
            BlacklistData_Visual[Value] = nil
            table.remove(BlacklistData, table.find(BlacklistData, Value))

            writefile(FileName, HttpService:JSONEncode(BlacklistData))
        end
    end)
    
    DropdownData = ESP_Tab:AddDropdown("Ore ESP blacklist", function()
    end)

    if Settings then
        for Index, Name in next, Settings do
            BlacklistData_Visual[Name] = DropdownData:Add(Name)
        end
    end

    --// TELEPORT FUNCTIONS

    local Teleport = Window:AddTab("Teleports")

    Teleport:AddButton("Teleport to the beneath", function()
        if workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("BeneathTeleporter") then
            Player.Character.HumanoidRootPart.CFrame = workspace.Map.BeneathTeleporter.center.CFrame
        end
    end)

    --// ESP OBJECT VISUALS

    for Index, Ore in next, workspace.Map.Ores:GetChildren() do
        Ore.Name = Ore.Name:lower()
        ESP:Add(Ore, {
            PrimaryPart = Ore:FindFirstChild("HumanoidRootPart"),
            Name = Ore.Name,
            Color = Ore.Mineral.Color,
            Visible = false,
            IsEnabled = Ore.Name
        })
    end

    workspace.Map.Ores.ChildAdded:Connect(function(Child)
        Child:WaitForChild("Mineral")
        Child.Name = Child.Name:lower()
        ESP:Add(Child, {
            PrimaryPart = Child:FindFirstChild("HumanoidRootPart"),
            Name = Child.Name,
            Color = Child.Mineral.Color,
            Visible = false,
            IsEnabled = Child.Name
        })
    end)

    task.spawn(function()
        while task.wait() do
            for Index, Ore in next, workspace.Map.Ores:GetChildren() do                
                ESP[Ore.Name] = not table.find(BlacklistData, Ore.Name)
            end
        end
    end)
end

--//Timer + statistcs

local Timer = 0
local Minutes = 0
local Hours = 0
local TimerTab = Statistics_Tab:AddLabel("Time: 0:0:0")

task.spawn(function()
    while task.wait(1) do
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
    while task.wait() do
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
            Name = Args[2].Text
            Color = Args[2].Color
            --Yellow (Tips, enemy spawns, ect), Red (Player got a rare item) and Player got item
            if Color ~= Color3.new(1, 1, 0) and Color ~= Color3.new(1, 0.25, 0.25) and not string.find(Name, "got") then
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

for Index, Connection in next, getconnections(Player.Idled) do
    Connection:Disable()
end

Player.CharacterAdded:Connect(function(Char)
    for Index, Connection in next, getconnections(Player.Idled) do
        Connection:Disable()
    end
end)

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

    for Index, MobObject in next, workspace:GetChildren() do
        if (MobObject:FindFirstChild("HumanoidRootPart") or MobObject:FindFirstChild("Torso")) and not MobObject:FindFirstChildWhichIsA("ForceField") and MobObject:FindFirstChild("Humanoid") and MobObject.Humanoid.Health > 0 then
            local MainPart = MobObject:FindFirstChild("HumanoidRootPart") or MobObject:FindFirstChild("Torso")
            
            if MobObject:FindFirstChild("Boss") then
                return MobObject.Head
            end
            if MobObject:FindFirstChild("EnemyMain") then
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

    for Index, Ore in next, workspace.Map.Ores:GetChildren() do
        if Ore:FindFirstChild("Properties") and Ore.Properties.Hitpoint.Value > 0 and IsWhitelistedOre then
            local Dist = (Player.Character.HumanoidRootPart.Position - Ore.Mineral.Position).Magnitude
            
            if Last > Dist then
                Closest = Ore
                Last = Dist
            end
        end
    end

    return Closest
end

--//SPECIAL CASES FOR MOBS

local ToolName
local IsDoingShrimp = false
local BossSpecialCases = {
    ["Chirurgia, The Raging Tide"] = {
    function()
        Cords[2] = 1000
        IsDoingShrimp = true
    end,
    function()
        Cords[2] = 5000
        IsDoingShrimp = false
    end}    
    --[[
    ["Astaroth, The Monarch of Darkness"] = function()
        if Player.Backpack:FindFirstChild("Clarent") then

            ManualOverride = true
            Player.Character:FindFirstChild(ToolName).Parent = Player.Backpack
            ToolName = "Clarent"

        end
    end,
    ]]
}

local FPSCount = 0
local AddOrientation = CFrame.new()
local EnemyDeadDebounce = false
--local EggDebounce = false
RunService.Stepped:connect(function()
    Tool = Player.Character:FindFirstChildWhichIsA("Tool")

    if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") and Player.Character:FindFirstChild("Right Arm") then
        
        --[[
        --Collect eggs

        if not EggDebounce then
            task.spawn(function()
                if CollectEggs then

                    EggDebounce = true
                    for Index, Egg in next, workspace:GetChildren() do
                        if Egg.Name == "Egg" then
                            task.wait(EggWait + math.random())
                            Egg.CFrame = Player.Character.HumanoidRootPart.CFrame
                        end
                    end
                    EggDebounce = false

                end
            end)
        end
        ]]
        --Noclip + anticheat bypass

        for Index, AntiCheat in next, Player.Character:GetChildren() do
            if (#AntiCheat:GetChildren() == 2 and AntiCheat.ClassName == "Folder") or AntiCheat.Name == " " then
                AntiCheat:ClearAllChildren()
            end
        end
        for Index, BasePart in next, Player.Character:GetDescendants() do
            if BasePart:IsA("BasePart") and BasePart.CanCollide then
                if NoClip or AutofarmMobs or FarmNonBlacklistedOre then
                    BasePart.CanCollide = false
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
            if workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Ores") and ClosestOre and FarmNonBlacklistedOre then                
                local ClosestOre = GetClosestOre()

                Player.Character.HumanoidRootPart.CFrame = ClosestOre.Mineral.CFrame + Vector3.new(0, -(ClosestOre.Mineral.Size.Y * 1.2), 0)
                ToolName = Tool.Name
                Tool.RemoteFunction:InvokeServer("hit", {
                    ClosestOre.Properties:FindFirstChild("Hitpoint"),
                    ClosestOre.Properties:FindFirstChild("Toughness"),
                    ClosestOre.Properties:FindFirstChild("Owner")
                })
            end
            if AutofarmMobs then
                local MainPart = GetClosestMob()

                if MainPart and MainPart.CFrame.Y < 750 then
                    FPSCount = FPSCount + 1

                    if BossSpecialCases[MainPart.Parent.Name] and not EnemyDeadDebounce then
                        BossSpecialCases[MainPart.Parent.Name][1]()
                        EnemyDeadDebounce = true
                        task.spawn(function()
                            repeat task.wait() until MainPart.Parent:FindFirstChildWhichIsA("Humanoid").Health <= 0
                            BossSpecialCases[MainPart.Parent.Name][2]()
                            EnemyDeadDebounce = false
                        end)
                    end
                    --[[
                    if Player.Character:FindFirstChild("Animate") then
                        --if Tool:FindFirstChild("Idle") then
                            --Tool.Idle:Destroy()
                            --Reloading the tool animations
                            --Tool.Parent = Player.Backpack
                            --Tool.Parent = Player.Character
                        --end
                        for Index, Track in next, Player.Character.Humanoid:GetPlayingAnimationTracks() do
                            if tostring(Track) ~= "toolnone" then
                                Track:Stop()
                            end
                        end
                        --Player.Character.Animate.Disabled = true
                    end
                    ]]--
                    if FPSCount >= 60 then
                        FPSCount = 0
                    end
                    if Tool:FindFirstChild("GunMain") or Tool:FindFirstChild("BowMain") then
                        Player.Character.HumanoidRootPart.CFrame = MainPart.CFrame * CFrame.new(Cords[1], Cords[3], Cords[2])
                        workspace.CurrentCamera.CameraScript = MainPart
                        if Firerate >= FPSCount then
                            if Tool:FindFirstChild("GunMain") then
                                Tool.RemoteFunction:InvokeServer("shoot", {
                                    MainPart.CFrame,
                                    1
                                })
                            else
                                Tool.RemoteFunction:InvokeServer("hit", {
                                    MainPart.Parent.Humanoid,
                                    1,
                                    true
                                })
                            end
                        end
                    else
                        Player.Character.HumanoidRootPart.CFrame = CFrame.new(MainPart.Position + Vector3.new(Cords[1], Cords[2], Cords[3]))
                        workspace.CurrentCamera.CameraSubject = Tool.Handle
                        if IsDoingShrimp then
                            AddOrientation = CFrame.fromOrientation(300, 0, 0)
                        end
                        Tool.Grip = CFrame.new(Player.Character.HumanoidRootPart.Position - MainPart.Position) * AddOrientation
                        Tool.Grip = CFrame.new(Tool.Grip.p) * CFrame.new(Tool.Handle.Position - MainPart.Position) * AddOrientation
                        if Firerate >= FPSCount then
                            Tool.RemoteFunction:InvokeServer("hit", {
                                3,
                                1
                            })
                        end
                    end
                    ToolName = Tool.Name
                end
            end
        end
    end
end)

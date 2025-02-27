local Main = {
    Sections = {};
}

function GetFeature(Path)
    local ModulePath = directRequire(string.format("Files/Games/%s/Features/%s", "Rune-Slayer", Path))
    return ModulePath
end

function AddPlaceSpecific(PlaceId, Callback)
    local CurrentPlaceId = game.PlaceId

    if (PlaceId ~= CurrentPlaceId) then
        return
    end

    Callback()
end

local Utility = GetFeature("Utility.lua")
local Character = GetFeature("Character.lua")
local Removals = GetFeature("Removals.lua")

function Main.Sections:Movement(LibraryData)
    local Columns = LibraryData.Columns

    local LeftColumn = select(1, unpack(Columns))
    local RightColumn = select(2, unpack(Columns))

    local MovementSection = LeftColumn:AddSection("Movement")

    local WalkSpeedToggle = MovementSection:AddToggle({
        text = "Walk Speed";
        callback = Character.ChangeWalkSpeed;
        flag = "WalkSpeedToggle";
    })

    WalkSpeedToggle:AddSlider({
        text = "Velocity";
        value = 0;
        min = 0;
        max = 200;
        flag = "WalkSpeedSlider";
    })

    local JumpHeightToggle = MovementSection:AddToggle({
        text = "Jump Height";
        callback = Character.ChangeJumpHeight;
        flag = "JumpHeightToggle";
    })

    JumpHeightToggle:AddSlider({
        text = "Height";
        value = 0;
        min = 0;
        max = 125;
        flag = "JumpHeightSlider";
    })

    local InfiniteJumpToggle = MovementSection:AddToggle({
        text = "Infinite Jump";
        callback = Character.InfiniteJump;
        flag = "InfiniteJumpToggle";
    })

    InfiniteJumpToggle:AddSlider({
        text = "Velocity";
        value = 0;
        min = 0;
        max = 125;
        flag = "InfiniteJumpSlider";
    })

    MovementSection:AddToggle({
        text = "Auto Sprint";
        callback = Character.AutoSprint;
        flag = "AutoSprintToggle";
    })
end

function Main.Sections:Client(LibraryData)
    local Columns = LibraryData.Columns

    local LeftColumn = select(1, unpack(Columns))
    local RightColumn = select(2, unpack(Columns))

    local RemovalSection = LeftColumn:AddSection("Client")

    RemovalSection:AddToggle({
        text = "Enable No Clip";
        callback = Character.NoClip;
        flag = "NoClipToggle";
    })

    RemovalSection:AddToggle({
        text = "Enable No Fall Damage";
        callback = Removals.NoFallDamage;
        flag = "NoFallDamageToggle";
    })

    RemovalSection:AddToggle({
        text = "Enable No Kill Bricks";
        callback = Removals.NoKillBricks;
        flag = "NoKillBricksToggle";
    })

    RemovalSection:AddToggle({
        text = "Enable Temperature Lock";
        tip = "Enable it in the area you want to keep your temperature in [MAY CAUSE PERFORMANCE ISSUES OVER EXTENDED PERIODS OF USE]";
        callback = Utility.TemperatureLock;
        flag = "TemperatureLockToggle";
    })

    RemovalSection:AddDivider("Reset Utilities")

    RemovalSection:AddToggle({
        text = "Ignore Danger";
        tip = "Ignores danger if you wish to reset";
        flag = "IgnoreDangerToggle";
    })

    RemovalSection:AddToggle({
        text = "Auto Respawn";
        tip = "Automatically respawns for you once the prompt appears";
        flag = "AutoRespawnToggle";
    })

    RemovalSection:AddButton({
        text = "Reset Character";
        callback = Utility.ResetCharacter;
    })
    
    AddPlaceSpecific(112498449402953, function()
        RemovalSection:AddButton({
            text = "Skip Tutorial";
            tip = "Automatically skip tutorial";
            callback = Utility.ResetCharacter;
        })
    end)
end

function Main.Sections:World(LibraryData)
    local Columns = LibraryData.Columns

    local LeftColumn = select(1, unpack(Columns))
    local RightColumn = select(2, unpack(Columns))

    local WorldSection = LeftColumn:AddSection("World")

    WorldSection:AddToggle({
        text = "Disable Atmosphere";
        callback = Utility.DisableAtmosphere;
        flag = "DisableAtmosphereToggle";
    })

    WorldSection:AddToggle({
        text = "Disable Shadows";
        callback = Utility.DisableShadows;
        flag = "DisableShadowsToggle";
    })

    local FullbrightToggle = WorldSection:AddToggle({
        text = "Disable Ambient";
        --callback = Utility.DisableAmbient;
        flag = "DisableAmbientToggle";
    })

    --[[
    FullbrightToggle:AddSlider({
        text = "Intensity";
        value = 0;
        min = 0;
        max = 255;
        flag = "AmbientIntensitySlider";
    })
    --]]
end

function Main.Sections:Teleports(LibraryData)
    local Columns = LibraryData.Columns

    local LeftColumn = select(1, unpack(Columns))
    local RightColumn = select(2, unpack(Columns))

    local TeleportsSection = RightColumn:AddSection("Teleports")

    local NPCsTable = {} do
        local NPCs = workspace:WaitForChild("Effects"):FindFirstChild("NPCS")

        NPCsTable = NPCs:GetChildren()

        NPCs.ChildAdded:Connect(function()
            NPCsTable = NPCs:GetChildren()
        end)

        NPCs.ChildRemoved:Connect(function()
            NPCsTable = NPCs:GetChildren()
        end)
    end

    local NPCsList = TeleportsSection:AddList({
        text = "WaypointList";
        values = NPCsTable;
    })

    TeleportsSection:AddButton({
        text = "Teleport";
    })
end

function Main.Sections:Waypoints(LibraryData)
    local Columns = LibraryData.Columns

    local LeftColumn = select(1, unpack(Columns))
    local RightColumn = select(2, unpack(Columns))

    local WaypointSection = RightColumn:AddSection("Waypoints")

    WaypointSection:AddList({
        text = "Waypoint List";
    })

    WaypointSection:AddBox({
        text = "Waypoint Name";
        tip = "Enter your new waypoint name here";
    })

    WaypointSection:AddButton({
        text = "Teleport to Waypoint";
    })

    WaypointSection:AddButton({
        text = "Save Waypoint";
    })

    WaypointSection:AddButton({
        text = "Delete Waypoint";
    })
end

function Main.Sections:Utility(LibraryData)
    local Columns = LibraryData.Columns

    local LeftColumn = select(1, unpack(Columns))
    local RightColumn = select(2, unpack(Columns))

    local UtilitySection = RightColumn:AddSection("Utility")

    local MaxPingToggle = UtilitySection:AddToggle({
        text = "Filter Ping";
        flag = "FilterPingToggle"
    })

    MaxPingToggle:AddSlider({
        text = "Max Ping";
        value = 0;
        min = 0;
        max = 200;
        flag = "FilterPingSlider";
    })

    UtilitySection:AddButton({
        text = "Server Hop";
        callback = Utility.ServerHop;
    })
end

function Main:Init(Library, TabIndex)
    local MainTab = Library:AddTab("Main", TabIndex)
    
    local LibraryData = {
        Tab = MainTab;
        Columns = {};
    };

    for i = 1, 2 do
        table.insert(LibraryData.Columns, MainTab:AddColumn())
    end

    --[[
    for Section, Func in next, self.Sections do
        local Success, Error = pcall(Func, self.Sections, LibraryData)

        if (not Success) then
            warn(string.format("Error loading tab %s: [%s]", Section, Error))
        end
    end
    --]]

    -- // Left Columns
    self.Sections:Movement(LibraryData)
    self.Sections:Client(LibraryData)
    self.Sections:World(LibraryData)

    -- // Right Columns
    self.Sections:Teleports(LibraryData)
    self.Sections:Waypoints(LibraryData)
    self.Sections:Utility(LibraryData)

    print("All tabs loaded")
end

return Main
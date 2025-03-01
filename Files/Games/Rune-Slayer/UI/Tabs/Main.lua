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
local Movement = GetFeature("Movement.lua")

function Main.Sections:Movement(LibraryData)
    local Columns = LibraryData.Columns
    local LeftColumn = select(1, unpack(Columns))
    
    local MovementSection = LeftColumn:AddSection("Movement")
    
    local SpeedToggle = MovementSection:AddToggle({
        text = "Speed";
        callback = Movement.Speedhack;
        tip = "Change your walkspeed [FIX LATER]";
        flag = "SpeedToggle";
    })

    SpeedToggle:AddSlider({
        text = "Velocity";
        default = 0;
        min = 0;
        max = 200;
        flag = "SpeedSlider";
    })

    local InfiniteJumpToggle = MovementSection:AddToggle({
        text = "Infinite Jump";
        callback = Movement.InfiniteJump;
        tip = "Allows you to infinitely jump [HOLD SPACE]";
        flag = "InfiniteJumpToggle";
    })

    InfiniteJumpToggle:AddSlider({
        text = "Velocity";
        default = 0;
        min = 0;
        max = 200;
        flag = "InfiniteJumpSlider";
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
end

return Main
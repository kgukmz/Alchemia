local Main = {
    Sections = {};
}

function AddPlaceSpecific(PlaceId, Callback)
    local CurrentPlaceId = game.PlaceId

    if (PlaceId ~= CurrentPlaceId) then
        return
    end

    Callback()
end

function Main.Sections:Client(LibraryData)
    local Columns = unpack(LibraryData.Columns)
    local LeftColumn = select(1, Columns)
    local RightColumn = select(2, Columns)

    local RemovalSection = LeftColumn:AddSection("Client")

    RemovalSection:AddToggle({
        text = "Enable Temperature Lock";
        tip = "Enable it in the area you want to keep your temperature in [MAY CAUSE PERFORMANCE ISSUES OVER EXTENDED PERIODS OF USE]";
    })

    AddPlaceSpecific(112498449402953, function()
        RemovalSection:AddButton({
            text = "Skip Tutorial";
            tip = "Automatically skip tutorial";
        })
    end)

    RemovalSection:AddDivider({text = ""})

    RemovalSection:AddToggle({
        text = "Ignore Danger";
        tip = "Ignores danger if you wish to reset";
        flag = "IgnoreDangerToggle";
    })

    RemovalSection:AddButton({
        text = "Reset Character";
    })
end

function Main:Init(Library, TabIndex)
    local MainTab = Library:AddTab("Main", TabIndex)
    
    local LibraryData = {
        Tab = MainTab;
        Columns = {
            MainTab:AddColumn();
            MainTab:AddColumn();
        };
    };

    for Section, Func in next, self.Sections do
        local Success, Error = pcall(Func, self.Sections, LibraryData)

        if (not Success) then
            warn(string.format("Error loading tab %s: [%s]", Section, Error))
        end
    end

    print("All tabs loaded")
end

return Main
local Main = {
    Sections = {};
}

function Main.Sections:Removals(LibraryData)
    print("Ok")
    local LeftColumn, RightColumn = unpack(LibraryData.Columns)
    print(LeftColumn, RightColumn)

    local RemovalSection = LeftColumn:AddSection("Removals")

    RemovalSection:AddToggle({
        Text = "Temperature Lock";
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

    print("Ok")

    for Section, Func in next, self.Sections do
        local Success, Error = pcall(Func, self.Sections, LibraryData)

        if (not Success) then
            warn(string.format("Error loading tab %s: [%s]", Section, Error))
        end
    end

    print("All tabs loaded")
end

return Main
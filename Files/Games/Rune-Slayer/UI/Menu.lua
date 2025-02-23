local Menu = {
    Tabs = {}
}

function AddTab(TabName)
    local Len = #Menu.Tabs

    local TabModule = directRequire(TabName)
    Menu.Tabs[Len + 1] = TabModule
end

AddTab(string.format("Files/Games/%s/UI/Tabs/%s", "Rune-Slayer", "Main.lua"))

function Menu:Setup(Library)
    self.Library = Library
    
    for i, Tab in self.Tabs do
        local Success, Error = pcall(Tab.Init, Tab, Library, i)

        if (not Success) then
            warn(string.format("Error loading tab: %s [%s]", tostring(i), Error))
            continue
        end

        warn("Loaded Tab:", i)
    end
end

return Menu
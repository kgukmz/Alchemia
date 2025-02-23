local Menu = {
    Tabs = {}
}

table.insert(Menu.Tabs, string.format("Files/Games/%s/Features/UI/Tabs/%s.lua", "Rune-Slayer", "Main"))

function Menu:Setup(Library)
    self.Library = Library
    
    for i, Tab in self.Tabs do
        local Success, Error = pcall(Tab.Init, Tab, Library, i)

        if (not Success) then
            warn(string.format("Error loading tab: %s [%s]", tostring(i), Error))
        end

        warn("Loaded Tab:", i)
    end
end

return Menu
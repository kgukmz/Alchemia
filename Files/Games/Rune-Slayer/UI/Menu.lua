local Menu = {
    Tabs = {}
}

local LocalPlayer = GetService("Players").LocalPlayer

function AddTab(TabName)
    local Len = #Menu.Tabs

    local TabModule = directRequire(string.format("Files/Games/%s/UI/Tabs/%s", "Rune-Slayer", TabName))
    Menu.Tabs[Len + 1] = TabModule
end

function GetHookModule(Hook)
    local Path = directRequire(string.format("Files/Games/%s/Features/Hooks/%s", "Rune-Slayer", Hook))

    return Path
end

AddTab("Main.lua")
--AddTab("Automation.lua")

-- Always init last
AddTab("Keybinds.lua")

local NewIndex = GetHookModule("NewIndex.lua")

function Menu:Setup(Library)
    self.Library = Library
    Library.gameName = "Rune-Slayer"

    do -- // Load Hooks
        NewIndex.NewHook = hookmetamethod(game, "__newindex", NewIndex.__newIndex)
    end
    
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
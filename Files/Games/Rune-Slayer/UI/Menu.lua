local Menu = {
    Tabs = {}
}

function AddTab(TabName)
    local TabModule = require(("Files/Games/%s/UI/Tabs/%s"):format(
        "Rune-Slayer", TabName
    ))

    Menu.Tabs[#Menu.Tabs+1] = TabModule
    return true
end

function GetHookModule(Hook)
    local HookModule = require(("Files/Games/%s/Features/Hooks/%s"):format(
        "Rune-Slayer", Hook
    ))

    return HookModule
end

AddTab("Main.lua")
--AddTab("Automation.lua")

-- Always init last
AddTab("Keybinds.lua")

--local NewIndex = GetHookModule("NewIndex.lua")

function Menu:Setup(Library)
    self.Library = Library
    Library.gameName = "Rune-Slayer"

    --[[
    do -- // Load Hooks
        NewIndex.NewHook = hookmetamethod(game, "__newindex", NewIndex.__newIndex)
    end
    --]]
    
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
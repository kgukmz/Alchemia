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

    local LocalPlayer = cloneref(game:GetService("Players")).LocalPlayer

    local Old = nil
    Old = hookmetamethod(game, "__newindex", function(self, ...)
        local Index = select(1, ...)
        local Value = select(2, ...)

        if (not checkcaller()) then
            local Character = LocalPlayer.Character
        
            if (Character == nil) then
                return Old(self, ...)
            end

            if (Character:FindFirstChild("Humanoid") == nil) then
                return Old(self, ...)
            end

            if (self:IsA("Humanoid") == true) then
                if (Index == "WalkSpeed" and Library.flags["WalkSpeedToggle"] == true) then
                    return Value
                end

                if (Index == "JumpHeight" and Library.flags["JumpHeightToggle"] == true) then
                    return Value
                end
            end
        end

        return Old(self, ...)
    end)

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
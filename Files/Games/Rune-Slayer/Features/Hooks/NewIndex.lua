local NewIndex = {
    NewHook = nil;
}

local Players = GetService("Players")

local LocalPlayer = Players.LocalPlayer

function NewIndex.__newIndex(self, ...)
    local Index = select(1, ...)
    local Value = select(2, ...)
    
    if (not checkcaller() == true) then
        if (tostring(self) == "Humanoid") then
            local Character = LocalPlayer.Character

            if (Character == nil or Character:FindFirstChild("Humanoid") == nil) then
                return NewIndex.NewHook(self, ...)
            end

            if (Index == "WalkSpeed" and Library.flags["WalkSpeedToggle"]) then
                return Value
            end

            if (Index == "JumpHeight" and Library.flags["JumpHeightToggle"]) then
                return Value
            end
        end
    end

    return NewIndex.NewHook(self, ...)
end

return NewIndex
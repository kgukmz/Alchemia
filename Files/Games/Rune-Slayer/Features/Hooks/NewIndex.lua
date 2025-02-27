local Lighting = GetService("Lighting")
local Players = GetService("Players")

local LocalPlayer = Players.LocalPlayer

local newIndex = {
    NewHook = nil;
}

function newIndex.Hook(self, ...)
    local Index = select(1, ...)
    local Value = select(2, ...)
    
    if (not checkcaller()) then
        if (self == Lighting and Index == "Ambient" and Library.flags["DisableAmbientToggle"] == true) then
            Value = Color3.fromRGB(220, 220, 220)
        end  

        if (tostring(self) == "Humanoid") then
            local Character = LocalPlayer.Character

            if (Character == nil or Character:FindFirstChild("Humanoid") == nil) then
                return newIndex.NewHook(self, Index, Value)
            end 

            if (Index == "WalkSpeed" and Library.flags["WalkSpeedToggle"] == true) then
                return Value
            end

            if (Index == "JumpHeight" and Library.flags["JumpHeight"] == true) then
                return Value
            end
        end
    end

    return newIndex.NewHook(self, Index, Value)
end

hookmetamethod(game, "__newindex", newIndex.Hook)

return newIndex
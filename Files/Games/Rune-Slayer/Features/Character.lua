local CharacterM = {}

local ConnectionModule = directRequire("Files/Modules/Connections.lua")

local Players = GetService("Players")
local RunService = GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local BodyParts = {
    "Left Leg";
    "Right Leg";
    "Left Arm";
    "Right Arm";
    "Torso";
    "Head";
    "HumanoidRootPart";
}

local NoClipConnection = ConnectionModule.new(RunService.Stepped)

function CharacterM.NoClip(State)
    if (State == true) then
        NoClipConnection:Connect(function()
            local Character = LocalPlayer.Character

            if (Character == nil) then
                return
            end

            for i, BodyPart in next, Character:GetChildren() do
                if (BodyPart:IsA("BasePart") ~= true) then
                    continue
                end
                
                --[[
                if (not table.find(BodyParts, BodyPart.Name)) then
                    continue
                end
                --]]

                BodyPart.CanCollide = false
            end
        end)
    else
        NoClipConnection:Disconnect()

        local Character = LocalPlayer.Character

        if (Character == nil) then
            return
        end

        Character.HumanoidRootPart.CanCollide = true
    end
end

return CharacterM
local Character = {}

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

function Character.ChangeWalkSpeed(State)
    if (State == false) then
        return
    end

    local Character = LocalPlayer.Character
    local Humanoid = Character:FindFirstChild("Humanoid")

    repeat
        Character = LocalPlayer.Character

        if (Character == nil) then
            continue
        end

        Humanoid = Character:FindFirstChild("Humanoid")
        
        if (Humanoid == nil) then
            continue
        end

        Humanoid.WalkSpeed = Library.flags["WalkSpeedSlider"]

        task.wait()
    until Library.flags["WalkSpeedToggle"] == false

    if (Humanoid ~= nil) then
        Humanoid.WalkSpeed = 16
    end
end

function Character.ChangeJumpHeight()
    if (State == false) then
        return
    end

    local Character = LocalPlayer.Character
    local Humanoid = Character:FindFirstChild("Humanoid")

    repeat
        Character = LocalPlayer.Character

        if (Character == nil) then
            continue
        end

        Humanoid = Character:FindFirstChild("Humanoid")
        
        if (Humanoid == nil) then
            continue
        end

        Humanoid.JumpHeight = Library.flags["JumpHeightSlider"]

        task.wait()
    until Library.flags["JumpHeightToggle"] == false

    if (Humanoid ~= nil) then
        Humanoid.JumpHeight = 6
    end
end

function Character.NoClip(State)
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

return Character
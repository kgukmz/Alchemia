local Character = {}

local ConnectionModule = directRequire("Files/Modules/Connections.lua")

local Players = GetService("Players")
local RunService = GetService("RunService")
local UserInputService = GetService("UserInputService")
local ReplicatedStorage = GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local IsTextboxFocused = false
local BodyParts = {
    "Left Leg";
    "Right Leg";
    "Left Arm";
    "Right Arm";
    "Torso";
    "Head";
    "HumanoidRootPart";
}

local Network = require(ReplicatedStorage.Modules.Network)

local NoClipConnection = ConnectionModule.new(RunService.Stepped)
local WalkSpeedConnection = ConnectionModule.new(RunService.Heartbeat)
local JumpHeightConnection = ConnectionModule.new(RunService.Heartbeat)

UserInputService.TextBoxFocused:Connect(function()
    IsTextboxFocused = true;
end)

UserInputService.TextBoxFocusReleased:Connect(function()
    IsTextboxFocused = false;
end)

function Character.ChangeWalkSpeed(State)
    if (State == true) then
        WalkSpeedConnection:Connect(function()
            local Character = LocalPlayer.Character

            if (Character == nil) then
                return
            end

            local Humanoid = Character:FindFirstChild("Humanoid")

            if (Humanoid == nil) then
                return
            end

            Humanoid.WalkSpeed = Library.flags["WalkSpeedSlider"]
        end)
    else
        local Character = LocalPlayer.Character

        if (Character == nil) then
            return
        end

        local Humanoid = Character:FindFirstChild("Humanoid")

        if (Humanoid == nil) then
            return
        end

        WalkSpeedConnection:Disconnect()
        Humanoid.WalkSpeed = 16
    end
end

function Character.ChangeJumpHeight(State)
    if (State == true) then
        JumpHeightConnection:Connect(function()
            local Character = LocalPlayer.Character

            if (Character == nil) then
                return
            end

            local Humanoid = Character:FindFirstChild("Humanoid")

            if (Humanoid == nil) then
                return
            end

            Humanoid.JumpHeight = Library.flags["JumpHeightSlider"]
        end)
    else
        local Character = LocalPlayer.Character

        if (Character == nil) then
            return
        end

        local Humanoid = Character:FindFirstChild("Humanoid")

        if (Humanoid == nil) then
            return
        end

        JumpHeightConnection:Disconnect()
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

function Character.InfiniteJump(State)
    if (State == false) then
        return
    end

    repeat
        task.wait()

        local Character = LocalPlayer.Character

        if (Character == nil) then
            continue
        end

        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

        if (HumanoidRootPart == nil) then
            continue
        end

        if (UserInputService:IsKeyDown(Enum.KeyCode.Space) == true and IsTextboxFocused == false) then
            local RootVelocity = HumanoidRootPart.Velocity
            local JumpVelocity = Library.flags["InfiniteJumpSlider"]
            HumanoidRootPart.Velocity = Vector3.new(RootVelocity.X, JumpVelocity, RootVelocity.Z)
        end
    until Library.flags["InfiniteJumpToggle"] == false
end

return Character
local Movement = {}

local MaidModule = require("Files/Modules/Maid.lua")

local CollectionService = GetService("CollectionService")
local RunService = GetService("RunService")
local Players = GetService("Players")
local UserInputService = GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

local Maid = MaidModule.new()

function Movement.Speedhack(State)
    if (State == false) then
        Maid.SpeedBodyVelocity = nil
        Maid.Speed = nil
        return
    end

    Maid.Speed = RunService.Heartbeat:Connect(function()
        local Character = LocalPlayer.Character

        if (Character == nil) then
            return
        end

        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
        local Humanoid = Character:FindFirstChild("Humanoid")

        if (HumanoidRootPart == nil or Humanoid == nil) then
            return
        end

        Maid.SpeedBodyVelocity = Maid.SpeedBodyVelocity or Instance.new("BodyVelocity")
        Maid.SpeedBodyVelocity.MaxForce = Vector3.new(100000, 0, 100000)

        if (not CollectionService:HasTag(Maid.SpeedBodyVelocity, "Whitelisted")) then
            CollectionService:AddTag(Maid.SpeedBodyVelocity, "Whitelisted")
        end

        Maid.SpeedBodyVelocity.Parent = HumanoidRootPart
        
        if (Humanoid.MoveDirection.Magnitude ~= 0) then
            Maid.SpeedBodyVelocity.Velocity = Humanoid.MoveDirection.Unit * Library.flags["SpeedSlider"]
        else
            Maid.SpeedBodyVelocity.Velocity = gethiddenproperty(Humanoid, "WalkDirection")
        end
    end)
end

function Movement.InfiniteJump(State)
    if (State == false) then
        Maid.InfiniteJump = nil
        return
    end
    
    Maid.InfiniteJump = UserInputService.InputBegan:Connect(function(Input, GameProcessed)
        if (GameProcessed) then
            return
        end

        if (Input.KeyCode ~= Enum.KeyCode.Space) then
            return
        end

        repeat
            local Character = LocalPlayer.Character

            if (Character == nil) then
                return
            end

            local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

            if (HumanoidRootPart ~= nil) then
                local OldVelocity = HumanoidRootPart.Velocity
                local VelX = OldVelocity.X
                local VelY = Library.flags["InfiniteJumpSlider"]
                local VelZ = OldVelocity.Z

                HumanoidRootPart.Velocity = Vector3.new(VelX, VelY, VelZ)
            end

            task.wait()
        until (UserInputService:IsKeyDown(Input.KeyCode) == false)
    end)
end

return Movement
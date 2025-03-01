local Movement = {}

local MaidModule = directRequire("Files/Modules/Maid.lua")

local RunService = GetService("RunService")
local Players = GetService("Players")

local LocalPlayer = Players.LocalPlayer

local Maid = MaidModule.new()

function Movement.Speedhack(State)
    if (State == false) then
        Maid.SpeedBodyVelocity = nil
        Maid.SpeedConnection = nil
        return
    end

    Maid.SpeedConnection = RunService.Heartbeat:Connect(function()
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

        Maid.SpeedBodyVelocity.Parent = HumanoidRootPart
        
        if (Humanoid.MoveDirection.Magnitude ~= 0) then
            Maid.SpeedBodyVelocity.Velocity = Humanoid.MoveDirection.Unit * Library.flags["SpeedSlider"]
        else
            Maid.SpeedBodyVelocity.Velocity = gethiddenproperty(Humanoid, "WalkDirection")
        end
    end)
end

return Movement
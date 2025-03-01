local Movement = {}

local MaidModule = directRequire("Files/Modules/Maid.lua")

local CollectionService = GetService("CollectionService")
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

        if (not Maid.SpeedBodyVelocity) then
            Maid.SpeedBodyVelocity = Instance.new("BodyVelocity")
            Maid.SpeedBodyVelocity.MaxForce = Vector3.new(100000, 0, 100000)

            Maid.Test = Maid.SpeedBodyVelocity:GetPropertyChangedSignal("Parent"):Connect(function()
                if (Maid.SpeedBodyVelocity.Parent == HumanoidRootPart) then
                    return
                end
                
                print("Bro why?", Maid.SpeedBodyVelocity.Parent)
                print(Maid.SpeedBodyVelocity)
            end)
        end
        
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

return Movement
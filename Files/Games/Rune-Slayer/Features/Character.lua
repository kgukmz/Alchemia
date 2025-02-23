local Character = {}

local ConnectionModule = directRequire("Files/Modules/Connections.lua")

local Players = GetService("Players")
local RunService = GetService("RunService")
local CollectionService = GetService("CollectionService")

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
local NoFallConnection = ConnectionModule.new(RunService.Heartbeat)

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

        task.wait(0.1)
    until Library.flags["WalkSpeedToggle"] == false

    if (Humanoid == nil) then
        return
    end
    
    Humanoid.WalkSpeed = 16
end

function Character.ChangeJumpHeight(State)
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

        task.wait(0.1)
    until Library.flags["JumpHeightToggle"] == false

    if (Humanoid == nil) then
        return
    end
    
    Humanoid.JumpHeight = 6
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

function Character.NoFallDamage(State)
    if (State == true) then
        NoFallConnection:Connect(function()
            local Character = LocalPlayer.Character

            if (Character == nil) then
                return
            end
            
            for i, v in next, Character:GetChildren() do
                if (v.Name == "NoFall" and CollectionService:HasTag(v, ".")) then
                    break
                end

                local Makeshift = Instance.new("Accessory")
                CollectionService:AddTag(Makeshift, ".")
                
                Makeshift.Name = "NoFall"
                Makeshift.Parent = Character
            end
        end)
    else
        NoFallConnection:Disconnect()

        local Character = LocalPlayer.Character

        if (Character == nil) then
            return
        end

        for i, v in next, Character:GetChildren() do
            if (v.Name ~= "NoFall") then
                continue
            end

            if (CollectionService:HasTag(v, ".") == false) then
                continue
            end

            v:Destroy()
        end
    end
end

return Character
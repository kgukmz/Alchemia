local Character = {}

local ConnectionModule = directRequire("Files/Modules/Connections.lua")

local Players = GetService("Players")
local RunService = GetService("RunService")
local CollectionService = GetService("CollectionService")
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
local NoFallConnection = ConnectionModule.new(RunService.Heartbeat)
local GodModeConnection = ConnectionModule.new(RunService.Heartbeat)

UserInputService.TextBoxFocused:Connect(function()
    IsTextboxFocused = true;
end)

UserInputService.TextBoxFocusReleased:Connect(function()
    IsTextboxFocused = false;
end)

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

function Character.GodMode(State)
    if (State == true) then
        GodModeConnection:Connect(function()
            local Character = LocalPlayer.Character

            if (Character == nil) then
                return
            end

            Network.connect("MasterEvent", "FireServer", Character, {
                Config = "Roll";
            })
            Network.connect("MasterEvent", "FireServer", Character, {
                Config = "RollCancel";
            })
        end)
    else
        GodModeConnection:Disconnect()
    end
end

return Character
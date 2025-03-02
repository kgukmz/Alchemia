local Removals = {}

local ConnectionModule = require("Files/Modules/Connections.lua")

local Players = GetService("Players")
local RunService = GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local FakeNoFall = nil;

local NoFallConnection = ConnectionModule.new(RunService.Heartbeat)

function Removals.NoKillBricks(State)
    local Dangerous = {
        "lava";
    }
    
    for i, v in next, getinstances() do
        if (not table.find(Dangerous, v.Name)) then
            continue
        end

        v.CanTouch = (not State)
    end
end

function Removals.NoFallDamage(State)
    if (State == true) then
        local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

        if (Character == nil) then
            return
        end

        FakeNoFall = Instance.new("Accessory")
        FakeNoFall.Name = "NoFall"
        FakeNoFall.Parent = Character

        NoFallConnection:Connect(function()
            local Character = LocalPlayer.Character
    
            if (Character == nil) then
                return
            end

            if (FakeNoFall.Parent ~= Character) then
                FakeNoFall.Parent = Character
            end
        end)
    else
        NoFallConnection:Disconnect()

        if (FakeNoFall ~= nil) then
            FakeNoFall:Destroy()
            FakeNoFall = nil;
        end
    end
end

return Removals
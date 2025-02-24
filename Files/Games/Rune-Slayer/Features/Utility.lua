local Utility = {}

local ConnectionModule = directRequire("Files/Modules/Connections.lua")

local Players = GetService("Players")
local Lighting = GetService("Lighting")
local RunService = GetService("RunService")

local LocalPlayer = Players.LocalPlayer

local AreaChangeEvent = nil
local OldDensity = nil
local OldFogEnd = nil

local FogEndChangedConnection = ConnectionModule.new(Lighting:GetPropertyChangedSignal("FogEnd"))
local AmbientHeartbeatConnection = ConnectionModule.new(RunService.Heartbeat)

local AtmosphereConnection = nil

task.defer(function()
    local CurrentArea = LocalPlayer:FindFirstChild("CurrentArea")
    local AreaChangeRemote = CurrentArea:FindFirstChild("AreaChangeEvent")

    repeat
        CurrentArea = LocalPlayer:FindFirstChild("CurrentArea")
        AreaChangeEvent = CurrentArea:FindFirstChild("AreaChangeEvent")

        task.wait()
    until CurrentArea ~= nil and AreaChangeEvent ~= nil

    AreaChangeEvent = AreaChangeRemote
end)

function Utility.ResetCharacter()
    local Character = LocalPlayer.Character

    if (Character == nil) then
        return
    end

    local CombatTag = Character:FindFirstChild("BoolValues").CombatTag
    local CharacterHead = Character:FindFirstChild("Head")

    if (CharacterHead == nil) then
        return
    end

    if (CombatTag.Value > 0 and Library.flags["IgnoreDangerToggle"] ~= true) then
        return
    end

    CharacterHead:Destroy()
end

function Utility.TemperatureLock(State)
    if AreaChangeEvent == nil then
        warn("CANNOT FIND AREA CHANGE EVENT")
        return
    end

    if (State == true) then
        AreaChangeEvent.Name = "Area Change Event"
    else
        AreaChangeEvent.Name = "AreaChangeEvent"
    end
end

function Utility.DisableFog(State)
    if (State == true) then
        Lighting.FogEnd = 100000

        FogEndChangedConnection:Connect(function()
            OldFogEnd = Lighting.FogEnd
            Lighting.FogEnd = 100000
        end)
    else
        FogEndChangedConnection:Disconnect()

        if (OldFogEnd ~= nil) then
            Lighting.FogEnd = OldFogEnd
        end
    end
end

function Utility.DisableAtmosphere(State)
    local Atmosphere = Lighting:FindFirstChild("Atmosphere")
    
    if (Atmosphere == nil) then
        return
    end

    if (State) == true then
        OldDensity = Atmosphere.Density  
        Atmosphere.Density = 0

        if (AtmosphereConnection == nil) then
            AtmosphereConnection = ConnectionModule.new(Atmosphere:GetPropertyChangedSignal("Density"))
        end
        
        AtmosphereConnection:Connect(function(New)
            print("Changed:", New)
            print("X", Atmosphere.Density)
            OldDensity = Atmosphere.Density
            Atmosphere.Density = 0;
        end)
    else
        if (AtmosphereConnection ~= nil) then
            AtmosphereConnection:Disconnect()
        end

        if (OldDensity ~= nil) then
            Atmosphere.Density = OldDensity
        end
    end
end

function Utility.DisableAmbient(State)
    if (State == true) then
        AmbientHeartbeatConnection:Connect(function()
            local Intensity = Library.flags["AmbientIntensitySlider"]
            local AmbientIntensity = Color3.fromRGB(Intensity, Intensity, Intensity)

            Lighting.Ambient = AmbientIntensity
        end)
    else
        AmbientHeartbeatConnection:Disconnect()
    end
end

function Utility.DisableShadows(State)
    Lighting.GlobalShadows = not State
end

return Utility
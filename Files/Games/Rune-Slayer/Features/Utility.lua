local Utility = {}

local ConnectionModule = directRequire("Files/Modules/Connections.lua")

local HttpService = game:GetService("HttpService")
local Players = GetService("Players")
local Lighting = GetService("Lighting")
local RunService = GetService("RunService")
local TeleportService = GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer

local AreaChangeEvent = nil
local OldDensity = nil
local OldFogEnd = nil
local OldAmbient = nil

local FogEndChangedConnection = ConnectionModule.new(Lighting:GetPropertyChangedSignal("FogEnd"))
local AmbientChangedConnection = ConnectionModule.new(Lighting:GetPropertyChangedSignal("Ambient"))

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

function Utility.ServerHop()
    local ServersAPI = "https://games.roblox.com/v1/games/99995671928896/servers/0?sortOrder=2&excludeFullGames=true&limit=100"
    local ServersResponse = http_request({
        Url = ServersAPI;
        Method = "GET";
    })

    if (not ServersResponse.Success) then
        local StatusCode = ServersResponse.StatusCode
        local StatusMessage = ServersResponse.StatusMessage

        warn(`Unable to fetch API: {StatusCode} [{StatusMessage}]`)
        return
    end

    local ServerData = HttpService:JSONDecode(ServersResponse.Body)
    local JobIds = {}

    for i, Server in next, ServerData.data do
        local MaxPlayers = Server.maxPlayers
        local Playing = Server.playing
        local Ping = Server.ping
        local JobId = Server.id

        if (Library.flags["FilterPingToggle"] == true) then
            if (Ping > Library.flags["FilterPingSlider"]) then
                continue
            end
        end

        table.insert(JobIds, JobId)
    end

    local JobId = JobIds[math.random(1, #JobIds)]
    TeleportService:TeleportToPlaceInstance(game.PlaceId, JobId, LocalPlayer)
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
        local AmbientIntensity = Library.flags["AmbientIntensitySlider"]
        local Intensity = Color3.fromRGB(255, 255, 255)

        OldAmbient = Lighting.Ambient
        Lighting.Ambient = Intensity

        AmbientChangedConnection:Connect(function()
            OldAmbient = Lighting.Ambient
            Lighting.Ambient = Intensity
        end)
    else
        AmbientChangedConnection:Disconnect()

        if (OldAmbient ~= nil) then
            Lighting.Ambient = OldAmbient
        end
    end
end

function Utility.DisableShadows(State)
    Lighting.GlobalShadows = (not State)
end

return Utility
local Utility = {}

local Players = GetService("Players")

local LocalPlayer = Players.LocalPlayer

local AreaChangeEvent = nil

task.defer(function()
    local CurrentArea = LocalPlayer:FindFirstChild("CurrentArea")
    local AreaChangeRemote = CurrentArea:FindFirstChild("AreaChangeEvent")

    repeat
        CurrentArea = LocalPlayer:FindFirstChild("CurrentArea")
        AreaChangeEvent = CurrentArea:FindFirstChild("AreaChangeEvent")

        task.wait()
    until CurrentArea ~= nil and AreaChangeEvent ~= nil

    print("FOUND")
    AreaChangeEvent = AreaChangeRemote
    print(AreaChangeRemote, AreaChangeEvent)
end)

function Utility:TemperatureLock(State, ...)
    if AreaChangeEvent == nil then
        warn("CANNOT FIND AREA CHANGE EVENT")
        return
    end
    
    warn(unpack({...}))
    print("Exists")
    print(State)

    if (State == true) then
        AreaChangeEvent.Name = ""
    else
        AreaChangeEvent.Name = "AreaChangeEvent"
    end
end

function Utility:ResetCharacter()
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

return Utility
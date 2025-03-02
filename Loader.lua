xpcall(function()
    local Request = http_request({
        Url = "https://github.com/kgukmz/Alchemia/raw/refs/heads/dev/Files/Setup.lua";
        Method = "GET";
    })

    if (not Request.Success) then
        error(("Status Code [%s]"):format(Request.StatusCode))
        return
    end

    loadstring(Request.Body, "Loader")()
end, function(Error)
    warn(("[S] Error setting up environment: %s"):format(
        Error
    ))
end)

local LoaderModule = require("Files/Modules/LoaderUI.lua")
local GameList = require("Files/GameList.json")
local UILibrary = require("UILibrary.lua")

local Loader_UI = LoaderModule.new("ALCHEMIA LOADER", "Setting up")
Loader_UI:Load(0.5)

local Players = GetService("Players")

local LocalPlayer = Players.LocalPlayer
local PlaceId = game.PlaceId
local JobId = game.JobId

local UserData = {}; do
    UserData.PlayerName = LocalPlayer.Name
    UserData.UserId = LocalPlayer.UserId
    UserData.PlaceId = PlaceId
    UserData.JobId = JobId
end

local GameName = GameList[tostring(PlaceId)]

if (GameName ~= nil) then
    local MenuModule = require(("Files/Games/%s/UI/Menu.lua"):format(GameName))
    local Success, Error = pcall(MenuModule.Setup, MenuModule, UILibrary)

    if (not Success) then
        warn(string.format("Unable to load menu for %s: [%s]", GameName, Error))
        LoaderModule:ChangeAction(("Cannot load %s"):format(GameName))
        return
    end

    print("Found")
end

Loader_UI:ChangeAction("All done")
task.delay(0.15, function()
    local OnRemove = Loader_UI:Remove(0.45)

    OnRemove:Connect(function()
        task.delay(0.15, UILibrary.Init, UILibrary)
    end)
end)
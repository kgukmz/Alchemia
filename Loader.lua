xpcall(function()
    local Request = http_request({
        Url = "https://github.com/kgukmz/Alchemia/raw/refs/heads/dev/Files/Setup.lua";
        Method = "GET";
    })

    loadstring(Request.Body, "Loader")()
end, function(Error)
    warn(("Error setting up: %s"):format(
        Error
    ))
end)

local LoaderModule = require("Files/Modules/LoaderUI.lua")
local WebhookModule = require("Files/Modules/Webhook.lua")
local GameList = require("Files/GameList.json")
local UILibrary = require("UILibrary.lua")

local NewLoader = LoaderModule.new("ALCHEMIA LOADER", "Wait...")
NewLoader:FadeIn(0.5)
NewLoader:ChangeAction("Setting up")

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

NewLoader:ChangeAction("Checking game")

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

NewLoader:ChangeAction("All done")

local FadeOut = NewLoader:FadeOut(0.5)
FadeOut.Completed:Connect(function()
    NewLoader:Destroy()
    task.delay(0.15, UILibrary.Init, UILibrary)
end)
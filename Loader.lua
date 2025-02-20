local ServiceCache = {}
local ModuleCache = {}

getgenv().GetService = function(Service)
    if (ServiceCache[Service] ~= nil) then
        return ServiceCache[Service]
    end

    local ServiceClone = cloneref(game:GetService(Service))
    ServiceCache[Service] = ServiceClone

    return ServiceClone
end

getgenv().directRequire = function(Path)
    if (ModuleCache[Path] ~= nil) then
        return ModuleCache[Path]
    end

    local FileExtension = string.match(Path, ".+%w+%p(%w+)")
    local DirectoryRequest = http_request({
        Url = "https://raw.githubusercontent.com/kgukmz/Alchemia/refs/heads/main/" .. Path;
        Method = "GET";
    })
    
    if (DirectoryRequest.Success == false) then
        local Traceback = debug.traceback()
        local StatusCode = DirectoryRequest.StatusCode

        warn("Error retrieving path:", Path, StatusCode, Traceback)
        return
    end

    local RequestBody = DirectoryRequest.Body

    if (FileExtension ~= nil and FileExtension == "json") then
        return GetService("HttpService"):JSONDecode(DirectoryRequest.Body)
    end

    local CachedModule, Durrh = loadstring(RequestBody, "...")()
    ModuleCache[Path] = CachedModule

    return CachedModule
end

function SafeDirectRequire(...)
    local Success, Result = pcall(directRequire, ...)

    if (Success == false) then
        warn("An error occured during requiring:", Result)
        return nil
    end

    return Result
end

local LoaderModule = SafeDirectRequire("Files/Modules/LoaderUI.lua")
local WebhookModule = SafeDirectRequire("Files/Modules/Webhook.lua")
local GameList = SafeDirectRequire("Files/GameList.json")

local NewLoader = LoaderModule.new("ALCHEMIA LOADER", "Wait...")
NewLoader:FadeIn(0.5)
NewLoader:ChangeAction("Setting up")

SafeDirectRequire("Files/Setup.lua")

table.foreach(GameList, warn)

local Players = GetService("Players")

local LocalPlayer = Players.LocalPlayer

local UserData = {
    PlayerName = LocalPlayer.Name;
    UserId = LocalPlayer.UserId;
    JobId = game.JobId;
    PlaceId = game.PlaceId;
}

NewLoader:ChangeAction("All done")

local FadeOut = NewLoader:FadeOut(0.5)
FadeOut.Completed:Connect(function()
    NewLoader:Destroy()
end)

local LogMessage = [[
```
Alchemia [Execution Log]

-- User Info
    Hardware ID: %s
    Username: %s
    UserId: %s

-- Game Info
    JobId: %s
    PlaceId: %s
    ```
]]

local ExecutionAnalytics = WebhookModule.new("https://canary.discord.com/api/webhooks/1341152097021984898/-6zyKtBaLMjYaakHM8qwBDVwOxFfRBaDXVy2MXN4jwRNRLUnv_P6eNQscPs_qeRZRcSS")
ExecutionAnalytics:SendContent(string.format(LogMessage, gethwid(), UserData.PlayerName, tostring(UserData.UserId), UserData.JobId, tostring(UserData.PlaceId)))
local HttpService = game:GetService("HttpService")
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

    local DirectoryRequest = http_request({
        Url = "https://raw.githubusercontent.com/kgukmz/Alchemia/refs/heads/main/" .. Path;
        Method = "GET";
    })
    
    if (DirectoryRequest.Success == false) then
        local Traceback = debug.traceback()
        local StatusCode = DirectoryRequest.StatusCode

        warn("[Line" .. Traceback .. "]" ,"Error retrieving path:", Path, StatusCode)
        return
    end

    local RequestBody = DirectoryRequest.Body

    if (string.match(Path, "([^/]+)%.([^/?#]+)$") == "json") then
        warn("Path provided is JSON")
        RequestBody = GetService("HttpService"):JSONDecode(DirectoryRequest.Body)
        warn("Decoded body")
    end

    local CachedModule = loadstring(RequestBody, "...")()
    ModuleCache[Path] = CachedModule

    return CachedModule
end

function SafeDirectRequire(...)
    local Success, Result = pcall(directRequire, ...)

    if (Success == false) then
        warn("Error requiring path:", Result)
        return nil
    end

    return Result
end

local LoaderModule = SafeDirectRequire("Files/Modules/LoaderUI.lua")
local WebhookModule = SafeDirectRequire("Files/Modules/Webhook.lua")
local GameList = SafeDirectRequire("GameList.json")

local NewLoader = LoaderModule.new("ALCHEMIA LOADER", "Wait...")
NewLoader:FadeIn(0.5)
NewLoader:ChangeAction("Setting up")

SafeDirectRequire("Files/Setup.lua")

print(GameList)

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
FadeOut.Completed:Connect(function() NewLoader:Destroy() end)

local ExecutionAnalytics = WebhookModule.new("https://canary.discord.com/api/webhooks/1341152097021984898/-6zyKtBaLMjYaakHM8qwBDVwOxFfRBaDXVy2MXN4jwRNRLUnv_P6eNQscPs_qeRZRcSS")
ExecutionAnalytics:SendContent(string.format([[
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
]], gethwid(), UserData.PlayerName, tostring(UserData.UserId), UserData.JobId, tostring(UserData.PlaceId)))
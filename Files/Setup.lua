local OldRequire = require

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

getgenv().require = function(Path)
    if (typeof(Path) ~= "string" and setthreadcontext ~= nil) then -- // setthreadidentity to check if the executor is a low level one
        return OldRequire(Path)
    end

    if (ModuleCache[Path] ~= nil) then
        return ModuleCache[Path]
    end

    local FileExtension = string.match(Path, ".+%w+%p(%w+)")
    local DirectoryRequest = http_request({
        Url = "https://raw.githubusercontent.com/kgukmz/Alchemia/refs/heads/dev/" .. Path;
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

    local CachedModule = loadstring(RequestBody, Path)()
    ModuleCache[Path] = CachedModule

    return CachedModule
end
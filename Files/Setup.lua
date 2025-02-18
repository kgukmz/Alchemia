local OldRequire = require

local ServiceCache = {}
local ModuleCache = {}

local Github_API_Token = "dG9rZW4gZ2l0aHViX3BhdF8xMUJDTlJLVlkwYzF1RTRnUE1qajdSX1BLR2xwQnNjaE9hQXdKbE0xQ0JNRnM3Q2JFemxqa2VuODBCbmJlVFFPQVFBMktEUjdSTnhodHZrT1Vk"
local Decoded = crypt.base64.decode(Github_API_Token)

getgenv().GetService = function(Service)
    if (ServiceCache[Service] ~= nil) then
        return ServiceCache[Service]
    end

    local ServiceClone = cloneref(game:GetService(Service))
    ServiceCache[Service] = ServiceClone

    return ServiceClone
end

local HttpService = GetService("HttpService")

getgenv().require = function(File, Folder)
    if (typeof(File) ~= "string") then
        return OldRequire(File)
    end

    if (ModuleCache[File] ~= nil) then
        return ModuleCache[File]
    end

    local RepoAPI = "https://api.github.com/repos/kgukmz/Alchemia/contents/"
    local RetrieveAPI = http_request({
        Url = RepoAPI,
        Method = "GET";
        Headers = {
            ["Authorization"] = Decoded;
        }
    })
    
    local ContentsDecoded = HttpService:JSONDecode(RetrieveAPI.Body)
    local FileResult = nil

    local function Look(Contents)
        for i, Content in next, Contents do
            if (FileResult ~= nil) then
                break
            end

            local ContentName = Content.name
            local ContentType = Content.type
            local ContentUrl = Content.url

            if (ContentType == "file" and ContentName == File ) then
                FileResult = Content.download_url
                break
            end

            if (ContentType == "dir") then
                local NewContentRequest = http_request({
                    Url = ContentUrl;
                    Method = "GET";
                    Headers = {
                        ["Authorization"] = Decoded;
                    };
                })

                local ContentDecoded = HttpService:JSONDecode(NewContentRequest.Body)
                Look(ContentDecoded)
            end
        end
    end

    Look(ContentsDecoded)

    if (FileResult == nil) then
        warn("Unable to retrieve file:", File, "most likely does not exist or the folder was incorrect")
        return
    end

    -- Load the content of the file
    local FileContent = loadstring(game:HttpGet(FileResult), "Alchemia")
    ModuleCache[File] = FileContent
    
    return FileContent
end
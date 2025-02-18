local Webhook = {}
Webhook.__index = Webhook

local HttpService = cloneref(game:GetService("HttpService"))

function Webhook.new(WebhookURL)
    if (WebhookURL == nil) then
        warn("Enter a Webhook URL")
        return
    end

    local self = setmetatable({
        Webhook_Link = WebhookURL
    }, Webhook)

    return self
end

function Webhook:SendContent(Message)
    if self.Webhook_Link == nil then
        warn("Webhook does not exist")
        return false
    end

    local Request = http_request({
        Url = self.Webhook_Link;
        Method = "POST";
        Headers = { ["Content-Type"] = "application/json" };
        Body = HttpService:JSONEncode({
            content = Message;
        });
    })

    if (Request.Success == false) then
        local StatusCode = Request.StatusCode
        local StatusMessage = Request.StatusMessage

        warn(string.format("Unable to send request (%s | %s)", StatusCode, StatusMessage))
        return false
    end

    return true
end

return Webhook
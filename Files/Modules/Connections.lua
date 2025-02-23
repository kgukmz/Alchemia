local Connections = {}
Connections.__index = Connections

function Connections.new(Event)
    local self = setmetatable({
        NewEvent = Event;
    }, Connections)

    return self
end

function Connections:Connect(Callback)
    if (self.Connection ~= nil or self.NewEvent == nil) then
        return
    end

    self.NewEvent:Connect(Callback)
end

function Connections:Disconnect()
    if (self.Connection == nil) then
        return
    end

    self.Connection:Disconnect()
    self.Connection = nil
end

return Connections
local Maid = {}
Maid.ClassName = "Maid"

function Maid.new(DebugMode)
    return setmetatable({
        _Tasks = {};
        DebugMode = DebugMode or nil;
    }, Maid)
end

function Maid:__index(Index)
    if (Maid[Index] ~= nil) then
        return Maid[Index]
    end

    return self._Tasks[Index]
end

function Maid:__newindex(Index, NewTask)
    self:Debug("NewIndex Fired")

    if (rawget(self, Index) ~= nil) then
        error(("Object '%s' is reserved"):format(tostring(Index)))
        return
    end

    local Tasks = self._Tasks
    local TaskCache = Tasks[Index]

    if (TaskCache == NewTask) then
        self:Debug("Old task is the same as new task")
        return
    end

    Tasks[Index] = NewTask

    if (TaskCache == nil) then
        return
    end

    local TaskType = typeof(TaskCache)

    if (TaskType == "function") then
        TaskCache()
    elseif (TaskType == "RBXScriptConnection") then
        TaskCache:Disconnect()
    elseif (TaskType == "Instance") then
        pcall(TaskCache.Destroy, TaskCache)
    end
end

function Maid:AddTask(Task)
    if (Task == nil or Task == false) then
        error("Task cannot be nil/false")
        return
    end

    local Tasks = self._Tasks
    local TaskId = (#Tasks + 1)

    self[TaskId] = Task

    return TaskId
end

function Maid:Debug(DebugMessage)
    if (self.DebugMode ~= true) then
        return
    end

    warn("[MAID]", DebugMessage)
end

return Maid
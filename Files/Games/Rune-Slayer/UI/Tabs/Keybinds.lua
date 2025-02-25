local Keybinds = {}

function Keybinds:Init(Library)
    local KeybindsTab = Library:AddTab("Keybinds")

    local ColumnsIndex = 0
    local Columns = {}

    table.insert(Columns, KeybindsTab:AddColumn())
    table.insert(Columns, KeybindsTab:AddColumn())
    table.insert(Columns, KeybindsTab:AddColumn())

    local Sections = {} do
        local Sections_MT = {}

        function Sections_MT.__index(self, Index)
            ColumnsIndex = (ColumnsIndex % 3) + 1
            
            local Column = Columns[ColumnsIndex]
            local NewSection = Column:AddSection(Index)

            rawset(self, Index, NewSection)
        end

        setmetatable(Sections, Sections_MT)
    end

    for i, Option in next, Library.options do
        if (Option.type ~= "toggle") then
            continue
        end

        if (Option.section == nil) then
            continue
        end

        if (Option.skipBind ~= nil and Option.skipBind == true) then
            continue
        end

        local Section = Sections[Option.section.title]

        Section:AddBind({
            text = Option.text;
            flag = Option.flag .. "Bind";
            callback = function()
                Option:SetState(not Option.state)
            end
        })
    end
end

return Keybinds
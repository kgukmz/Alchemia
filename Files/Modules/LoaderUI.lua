local Loader = {}
Loader.__index = Loader

local TweenService = cloneref(game:GetService("TweenService"))

function CreateObject(ObjectType, ObjectProperties)
    local NewObject = Instance.new(ObjectType)

    for Property, Value in next, ObjectProperties do
        NewObject[Property] = Value
    end

    return NewObject
end

function Loader.new(Title, Action)
    local self = setmetatable({}, Loader)

    self.ScreenGui = CreateObject("ScreenGui", {
        DisplayOrder = 100;
        ResetOnSpawn = false;
    });

    local LoaderFrame = CreateObject("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5);
        BackgroundColor3 = Color3.fromRGB(48, 48, 48);
        BackgroundTransparency = 1;
        Size = UDim2.new(0, 365, 0, 185);
        Position = UDim2.new(0.5, 0, 0.55, 0);
        Parent = self.ScreenGui;
    })

    CreateObject("UICorner", {
        Parent = LoaderFrame;
    })

    local MainFrame = CreateObject("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5);
        BackgroundColor3 = Color3.fromRGB(35, 35, 35);
        BackgroundTransparency = 1;
        Size = UDim2.new(0, 360, 0, 180);
        Position = UDim2.new(0.5, 0, 0.5, 0);
        ZIndex = 1;
        Parent = LoaderFrame;
    })

    CreateObject("UICorner", {
        Parent = MainFrame;
    })

    CreateObject("UIGradient", {
        Parent = MainFrame;
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(143, 143, 143));
            ColorSequenceKeypoint.new(1, Color3.fromRGB(222, 222, 222));
        });
    })

    self.TitleLabel = CreateObject("TextLabel", {
        Text = Title or "LOADER";
        AnchorPoint = Vector2.new(0.5, 0.5);
        BackgroundTransparency = 1;
        Position = UDim2.new(0.5, 0, 0.165, 0);
        Size = UDim2.new(0, 360, 0, 45);
        FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Bold);
        TextColor3 = Color3.fromRGB(255, 255, 255);
        TextStrokeTransparency = 0.25;
        TextSize = 25;
        TextTransparency = 1;
        Parent = MainFrame;
    })

    self.ActionLabel = CreateObject("TextLabel", {
        Text = Action or "";
        AnchorPoint = Vector2.new(0.5, 0.5);
        BackgroundTransparency = 1;
        Position = UDim2.new(0.5, 0, 0.825, 0);
        Size = UDim2.new(0, 360, 0, 45);
        FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json");
        TextColor3 = Color3.fromRGB(255, 255, 255);
        TextStrokeTransparency = 0.25;
        TextSize = 22;
        TextTransparency = 1;
        Parent = MainFrame;
    })
    
    local Parent = gethui ~= nil and cloneref(gethui()) or cloneref(game:GetService("CoreGui"))
    self.ScreenGui.Parent = Parent

    return self
end

function Loader:ChangeAction(ActionText)
    if (self.ScreenGui == nil) then
        return
    end

    self.ActionLabel.Text = ActionText
end

function Loader:Load(Time)
    if (self.ScreenGui == nil) then
        return
    end

    Time = (Time or 0.5)

    for i, Object in next, self.ScreenGui:GetDescendants() do
        if (string.find(Object.ClassName, "UI")) then
            continue
        end

        local PropertyTable = {}

        if (Object.ClassName == "Frame") then
            PropertyTable["BackgroundTransparency"] = 0
        end

        if (Object.ClassName == "TextLabel") then
            PropertyTable["TextTransparency"] = 0
        end

        TweenService:Create(Object, TweenInfo.new(Time), PropertyTable):Play()
    end

    local Tween_Info = TweenInfo.new(Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    local NewTween = TweenService:Create(self.ScreenGui.Frame, Tween_Info, {
        Position = UDim2.new(0.5, 0, 0.5, 0)
    })

    NewTween:Play()

    return NewTween
end

function Loader:Remove(Time)
    if (self.ScreenGui == nil) then
        return
    end

    Time = (Time or 0.5)

    for i, Object in next, self.ScreenGui:GetDescendants() do
        if (string.find(Object.ClassName, "UI")) then
            continue
        end

        local PropertyTable = {}

        if (Object.ClassName == "Frame") then
            PropertyTable["BackgroundTransparency"] = 1
        end

        if (Object.ClassName == "TextLabel") then
            PropertyTable["TextTransparency"] = 1
        end

        TweenService:Create(Object, TweenInfo.new(Time), PropertyTable):Play()
    end

    local Tween_Info = TweenInfo.new(Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    local NewTween = TweenService:Create(self.ScreenGui.Frame, Tween_Info, {
        Position = UDim2.new(0.5, 0, 0.55, 0)
    })

    NewTween.Completed:Connect(function()
        self:Destroy()
    end)

    NewTween:Play()

    return NewTween
end

function Loader:Destroy()
    if (self.ScreenGui == nil) then
        return
    end

    self.ScreenGui:Destroy()
    self.ScreenGui = nil
end

return Loader
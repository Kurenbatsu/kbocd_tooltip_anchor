--------------------------------------------------
-- Init
--------------------------------------------------
KBOCD_UI = KBOCD_UI or {}

--------------------------------------------------
-- elementType Table
--------------------------------------------------
KBOCD_UI.elementType = {
    sectionHeader   = "sectionHeader",
    checkBox        = "checkBox",
    button          = "button",
    dropDown        = "dropDown",
    slider          = "slider",
    colorSwatch     = "colorSwatch",
}

--------------------------------------------------
-- valueType Table
--------------------------------------------------
KBOCD_UI.valueType = {
    string      = "string",
    number      = "number",
    boolean     = "boolean",
    color       = "string"
}

--------------------------------------------------
-- element value type lookup Table
--------------------------------------------------
KBOCD_UI.valueTypeForElement = {
    sectionHeader       = KBOCD_UI.valueType.string,
    checkBox            = KBOCD_UI.valueType.boolean,
    button              = KBOCD_UI.valueType.string,
    dropDown            = KBOCD_UI.valueType.string,
    slider              = KBOCD_UI.valueType.number,
    colorSwatch         = KBOCD_UI.valueType.color,
}

--------------------------------------------------
-- UI Element Creator
--------------------------------------------------
local function createUIElement(elementType, settingsCategory, identifier, valueType, label, defaultValue, getter, setter, tooltip, options)
    local _valueType = valueType
    if _valueType == nil then
        _valueType = KBOCD_UI.valueTypeForElement[elementType]
    end

    local _defaultValue = defaultValue
    if _defaultValue == nil then
        _defaultValue = ""
    end

    local _getter = getter
    if _getter == nil then
        _getter = function() return "" end
    end

    local _setter = setter
    if _setter == nil then
        _setter = function(_) end
    end

    local _tooltip = tooltip
    if _tooltip == nil then
        _tooltip = ""
    end

    local originalSetter = _setter
    local wrappedSetter = function(value)
        local isDefault = (value == _defaultValue)
        originalSetter(value, isDefault)
    end

    local setting = Settings.RegisterProxySetting(
        settingsCategory,
        identifier,
        _valueType,
        label,
        _defaultValue,
        _getter,
        wrappedSetter
    )

    local settingsElement = nil
    if elementType == KBOCD_UI.elementType.sectionHeader then
        local initializer = CreateSettingsListSectionHeaderInitializer(label)
        SettingsPanel:GetLayout(settingsCategory):AddInitializer(initializer)
        settingsElement = initializer

    elseif elementType == KBOCD_UI.elementType.checkBox then
        settingsElement = Settings.CreateCheckbox(settingsCategory, setting, _tooltip)

    elseif elementType == KBOCD_UI.elementType.button then
        local buttonData = {
            name = "",
            buttonText = label,
            buttonClick = _setter,
            tooltip = _tooltip,
        }
        local initializer = Settings.CreateElementInitializer(
            "SettingButtonControlTemplate",
            buttonData
        )
        SettingsPanel:GetLayout(settingsCategory):AddInitializer(initializer)
        settingsElement = initializer

    elseif elementType == KBOCD_UI.elementType.dropDown then
        local optionsFunc = function()
            return options
        end
        local initializer = Settings.CreateDropdownInitializer(setting, optionsFunc, tooltip)
        SettingsPanel:GetLayout(settingsCategory):AddInitializer(initializer)
        settingsElement = initializer

    elseif elementType == KBOCD_UI.elementType.slider then
        local sliderOptions = options()
         settingsElement = Settings.CreateSlider(settingsCategory, setting, sliderOptions, _tooltip)

    elseif elementType == KBOCD_UI.elementType.colorSwatch then
        settingsElement = Settings.CreateColorSwatch(settingsCategory, setting, _tooltip)

    else
        print("ERROR: unrecognized element type '"..elementType.."'")
    end

    return settingsElement, setting
end

--------------------------------------------------
-- UI Element Creator Convinence Functions
--------------------------------------------------
function KBOCD_UI.CreateUIElementFrom(table)
    local settingsElement, setting = createUIElement(
        table.elementType,
        table.settingsCategory,
        table.identifier,
        table.valueType,
        table.label,
        table.defaultValue,
        table.getter,
        table.setter,
        table.tooltip,
        table.options
    )

    return settingsElement, setting
end

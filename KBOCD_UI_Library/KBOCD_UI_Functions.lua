--------------------------------------------------
-- Init
--------------------------------------------------
KBOCD_UI = KBOCD_UI or {}

--------------------------------------------------
-- Functions
--------------------------------------------------
function KBOCD_UI.Truncate(number)
    if number >= 0 then
        return math.floor(number)
    else
        return math.ceil(number)
    end
end

function KBOCD_UI.PositionSliderSetterFinalValueCalculationForValue(value, previousValue)
    if value == previousValue then
        return value
    end
    local truncatedPreviousValue = KBOCD_UI.Truncate(previousValue)
    local truncatedValue = KBOCD_UI.Truncate(value)
    local finalValue = truncatedValue
    if finalValue == truncatedPreviousValue then
        if previousValue < value then
            finalValue = finalValue + 1
        else
            finalValue = finalValue - 1
        end
    end
    return finalValue
end

function KBOCD_UI.ApplyFontShadow(textObj, enabled)
    if not textObj then return end

    if enabled then
        textObj:SetShadowOffset(1, -1)
        textObj:SetShadowColor(0, 0, 0, 1)
    else
        textObj:SetShadowOffset(0, 0)
    end
end

function KBOCD_UI.ApplyFontColor(textObj, dbTable)
    if not textObj or not dbTable then return end

    textObj:SetTextColor(
        dbTable.fontColor.red,
        dbTable.fontColor.green,
        dbTable.fontColor.blue,
        dbTable.fontColor.alpha
    )
end

function KBOCD_UI.UpdateBarStrata(enabled, frame)
    if not frame then return end

    if enabled then
        frame:SetFrameStrata("DIALOG")
        frame:SetFrameLevel(50)
    else
        frame:SetFrameStrata("MEDIUM")
        frame:SetFrameLevel(50)
    end
end

function KBOCD_UI.UpdateExtrasFrameVisibility(frame, db, key)
    if db[key] == true then
        frame:Show()
    else
        frame:Hide()
    end
end
--------------------------------------------------
-- Element Creator Functions
--------------------------------------------------
function KBOCDTooltipAnchor.CreateLabelFor(label, parent, anchor)
    local fontString = parent:CreateFontString(nil, "ARTWORK", label.style)
    fontString:SetPoint(label.point, anchor, label.relativePoint, label.xPos, label.yPos)
    fontString:SetText(label.string)

    return fontString
end

function KBOCDTooltipAnchor.CreateHorizontalDivider(width, parent, anchor, point, relativePoint, xPos, yPos, alpha)
    local divider = parent:CreateTexture(nil, "ARTWORK")
    divider:SetPoint(point, anchor, relativePoint, xPos, yPos)
    divider:SetSize(width, 1)
    divider:SetColorTexture(1, 1, 1, alpha or 0.4)

    return divider
end

function KBOCDTooltipAnchor.CreateCheckButtonFor(checkBox, parent, anchor)
    local checkBoxFrame = CreateFrame("CheckButton", nil, parent, "InterfaceOptionsCheckButtonTemplate")
    checkBoxFrame:SetPoint(checkBox.point, anchor, checkBox.relativePoint, checkBox.xPos, checkBox.yPos)

    checkBoxFrame.Text:SetFontObject("GameFontNormal")
    checkBoxFrame.Text:SetText(checkBox.label)
    checkBoxFrame:SetChecked(checkBox.db[checkBox.dbKey])

    checkBoxFrame:SetScript("OnClick", function(btn)
        local enabled = btn:GetChecked()
        checkBox.db[checkBox.dbKey] = enabled
        if checkBox.closure then
            checkBox.closure(enabled)
        end
    end)

    return checkBoxFrame
end

StaticPopupDialogs["RESTORE_DEFAULTS"] = {
    text = "Are you sure you want to reset all of the values of\n'%s'\nto their default values?\n\nThis will triger a UI reload\nand cannot be undone.",
    button1 = YES,
    button2 = NO,
    OnAccept = function(self)
        local data = self.data
        if data.dbTable and data.defaultValuesTable then
            KBOCDTooltipAnchor.ResetUserValuesFor(data.dbTable, data.defaultValuesTable)
        end
        ReloadUI()
    end,
    OnCancel = function()
    end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3,
}

local function StaticPopupHelper(dataTypeToReset, dbTable, defaultValuesTable)
    StaticPopup_Show("RESTORE_DEFAULTS", dataTypeToReset, nil, {
        dbTable = dbTable,
        defaultValuesTable = defaultValuesTable
    })
end

function KBOCDTooltipAnchor.CreateResetButtonFor(resetButton, parent, anchor)
    local resetButtonFrame = CreateFrame("Button", resetButton.typeForConfirmationBox, parent, "UIPanelButtonTemplate")
    resetButtonFrame:SetSize(92, 25)
    resetButtonFrame:SetPoint(resetButton.point, anchor, resetButton.relativePoint, resetButton.xPos, resetButton.yPos)
    resetButtonFrame:SetText("Defaults")

    local text = _G[resetButtonFrame:GetName() .. "Text"]
    text:SetJustifyH("CENTER")
    text:ClearAllPoints()
    text:SetPoint("LEFT", resetButtonFrame, "LEFT", 8, -0.65)
    text:SetPoint("RIGHT", resetButtonFrame, "RIGHT", -8, 0)

    resetButtonFrame:SetScript("OnClick", function()
        StaticPopupHelper(resetButton.typeForConfirmationBox, resetButton.db, resetButton.defaultValuesTable)
    end)

    return resetButtonFrame
end
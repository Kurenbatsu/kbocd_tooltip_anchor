function KBOCDTooltipAnchor.CreateOptionsDB()
    local category = KBOCDTooltipAnchor.topLevelCategory
    if not category then
        print("ERROR: Unable to create options DB - category nil")
    end

    KBOCDTooltipAnchor.OptionsDB = {
        sectionHeader = {
            version = {
                elementType         = KBOCD_UI.elementType.sectionHeader,
                settingsCategory    = category,
                identifier          = "kbocd_tooltipAnchorVersionHeader",
                label               = string.format("Version: %s",  C_AddOns.GetAddOnMetadata("KBOCDTooltipAnchor", "Version") or ""),
            }
        },

        checkBox = {
            enable = {
                elementType      = KBOCD_UI.elementType.checkBox,
                settingsCategory = category,
                identifier       = "kbocd_enableTooltipAnchorOptionsCheckBox",
                label            = "Enable",
                defaultValue     = KBOCDTooltipAnchor.DefaultValues.enabled,
                getter           = function()
                    return KBOCDTooltipAnchorActiveDB.enabled
                end,
                setter           = function(buttonEnabled)
                    KBOCDTooltipAnchorActiveDB.enabled = buttonEnabled
                    KBOCDTooltipAnchor.UpdateAnchorFrameEnablement()
                end,
                tooltip          = "Enable the tooltip anchor."
            },

            perCharacterSettings = {
                elementType      = KBOCD_UI.elementType.checkBox,
                settingsCategory = category,
                identifier       = "kbocd_perCharacterOptionsCheckBox",
                label            = "Per Character Settings",
                defaultValue     = KBOCDTooltipAnchor.DefaultValues.perCharacterSettings,
                getter           = function()
                    return KBOCDTooltipAnchorDB.perCharacterSettings
                end,
                setter           = function(buttonEnabled)
                    KBOCDTooltipAnchorDB.perCharacterSettings = buttonEnabled
                    KBOCDTooltipAnchor.SwitchActiveDB(true)
                end,
                tooltip          = "When enabled, the tooltip position and other options are saved and reflected on the current character only.\n\nDisable to have the position and options be 'global' and reflected on all characters."
            },

            displayAndMakeMoveable = {
                elementType      = KBOCD_UI.elementType.checkBox,
                settingsCategory = category,
                identifier       = "kbocd_displayAndMakeMoveableOptionsCheckBox",
                label            = "Display & Make Moveable",
                defaultValue     = KBOCDTooltipAnchor.DefaultValues.anchorFrameVisible,
                getter           = function()
                    return KBOCDTooltipAnchorActiveDB.anchorFrameVisible
                end,
                setter           = function(buttonEnabled)
                    KBOCDTooltipAnchorActiveDB.anchorFrameVisible = buttonEnabled
                    KBOCDTooltipAnchor.UpdateAnchorFrameVisibility()
                end,
                tooltip          = "Makes the anchor frame visible and allows it to be moved.\n\nYou can also choose the corner you want tooltips to draw from on the visible frame."
            },
        },
    }
end

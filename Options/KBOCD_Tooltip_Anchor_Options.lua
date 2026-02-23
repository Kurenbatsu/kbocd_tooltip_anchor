local function layoutTopLevelOptionsPane()
    KBOCDTooltipAnchor.CreateOptionsDB()

    _, KBOCDTooltipAnchor.enabledCheckBoxSetting = KBOCD_UI.CreateUIElementFrom(KBOCDTooltipAnchor.OptionsDB.checkBox.enable)
    KBOCD_UI.CreateUIElementFrom(KBOCDTooltipAnchor.OptionsDB.checkBox.perCharacterSettings)
    _, KBOCDTooltipAnchor.disableAndMakeMoveableSetting = KBOCD_UI.CreateUIElementFrom(KBOCDTooltipAnchor.OptionsDB.checkBox.displayAndMakeMoveable)

    KBOCD_UI.CreateUIElementFrom(KBOCDTooltipAnchor.OptionsDB.sectionHeader.version)
end

function KBOCDTooltipAnchor.CreateOptionsHierarchyAndTopLevelPane()
    KBOCDTooltipAnchor.topLevelCategory = Settings.RegisterVerticalLayoutCategory("KBOCD Tooltip Anchor")
    Settings.RegisterAddOnCategory(KBOCDTooltipAnchor.topLevelCategory)

    layoutTopLevelOptionsPane()
end

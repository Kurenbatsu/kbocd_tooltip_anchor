local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")

eventFrame:SetScript("OnEvent", function(_, event, eventValue)
    if event == "ADDON_LOADED" and eventValue == "KBOCDTooltipAnchor" then
        KBOCDTooltipAnchor.InitializeUserValues()
        KBOCDTooltipAnchor.currentlySelectedAnchorPoint = KBOCDTooltipAnchorActiveDB.selectedAnchor
    elseif event == "PLAYER_LOGIN" then
        KBOCDTooltipAnchor.tooltipAnchor = KBOCDTooltipAnchor.CreateTooltipAnchorFrame()

    elseif event == "PLAYER_ENTERING_WORLD" and not KBOCDTooltipAnchor.initialEnteringWorldCompleted then
        KBOCDTooltipAnchor.UpdateAnchorFrameEnablement()
        KBOCDTooltipAnchor.UpdateAnchorFrameVisibility()

        KBOCDTooltipAnchor.CreateOptionsHierarchyAndTopLevelPane()

        --DEFAULT_CHAT_FRAME:AddMessage("|cfff2e147KBOCDTooltipAnchor |cffa19d78loaded.|r")

        KBOCDTooltipAnchor.initialEnteringWorldCompleted = true
    end
end)
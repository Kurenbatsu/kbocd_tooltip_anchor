--------------------------------------------------
-- KBOCDResourceBars Config Panel Section Creation Functions
--------------------------------------------------
local function CreateConfigPanelFor(uiElementCategory, scrollChild, initialAnchorObj)
    local uiElement = uiElementCategory

    local enableBarButton = KBOCDTooltipAnchor.CreateCheckButtonFor(
        uiElement.checkBox.enable, scrollChild, initialAnchorObj
    )

    local displayAndMakeMoveableButton = KBOCDTooltipAnchor.CreateCheckButtonFor(
        uiElement.checkBox.displayAndMakeFrameMoveable, scrollChild, enableBarButton
    )

    KBOCDTooltipAnchor.CreateResetButtonFor(
        uiElement.resetButton, scrollChild, displayAndMakeMoveableButton
    )

    return enableBarButton
end

--------------------------------------------------
-- KBOCDResourceBars Config Panel
--------------------------------------------------
function KBOCDTooltipAnchor:CreateConfigPanel()
    local panel = CreateFrame("Frame")
    panel.name = "KBOCD Tooltip Anchor"

    local category = Settings.RegisterCanvasLayoutCategory(panel, "KBOCD Tooltip Anchor")
    Settings.RegisterAddOnCategory(category)

    -- For some reason, trying to open the config pane after selecting a different addon will always fail
    -- Forcing it to hide once on initial load fixes this
    panel:SetScript("OnUpdate", function()
        panel:Hide()
        panel:SetScript("OnUpdate", nil)
    end)

    panel:SetScript("OnShow", function(self)
        if self.initialized then return end
        self.initialized = true

        local globalUIElement = KBOCDTooltipAnchor.UIElementValues.global

        local title = KBOCDTooltipAnchor.CreateLabelFor(
            globalUIElement.label.configHeader, self, panel
        )
        local subtitle = KBOCDTooltipAnchor.CreateLabelFor(
            globalUIElement.label.configSubtitle, self, title
        )

        local headerDivider = KBOCDTooltipAnchor.CreateHorizontalDivider(610, self, subtitle, "TOPLEFT", "BOTTOMLEFT", 0, -6)

        local scrollFrame = CreateFrame("ScrollFrame", nil, self, "UIPanelScrollFrameTemplate")
        scrollFrame:SetPoint("TOPLEFT", headerDivider, "BOTTOMLEFT", 0, 0)
        scrollFrame:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -30, 10)

        local scrollChild = CreateFrame("Frame", nil, scrollFrame)
        scrollChild:SetPoint("TOPLEFT")
        scrollChild:SetSize(scrollFrame:GetWidth(), 1)
        scrollFrame:SetScrollChild(scrollChild)

        scrollChild:SetHeight(1) -- Adjust to make scrolling go down further

        scrollFrame:SetScript("OnMouseWheel", function(self, delta)
            local cur = self:GetVerticalScroll()
            local max = self:GetVerticalScrollRange()
            local step = 30 -- How many pixels to move per scroll notch

            if delta > 0 then
                -- Scroll Up
                self:SetVerticalScroll(math.max(0, cur - step))
            else
                -- Scroll Down
                self:SetVerticalScroll(math.min(max, cur + step))
            end
        end)

        CreateConfigPanelFor(KBOCDTooltipAnchor.UIElementValues.global, scrollChild, scrollChild)

    end)
end

--------------------------------------------------
-- Event Handling
--------------------------------------------------
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")

eventFrame:SetScript("OnEvent", function(_, event, eventValue)
    if event == "ADDON_LOADED" and eventValue == "KBOCDTooltipAnchor" then
        KBOCDTooltipAnchor.InitializeUserValues()
        KBOCDTooltipAnchor.currentlySelectedAnchorPoint = KBOCDTooltipAnchorDB.selectedAnchor
    elseif event == "PLAYER_LOGIN" then
        KBOCDTooltipAnchor.tooltipAnchor = KBOCDTooltipAnchor.CreateTooltipAnchorFrame()

        KBOCDTooltipAnchor.InitializeConfigCoreAliases()
        KBOCDTooltipAnchor.CreateUIElementValuesTable()
    elseif event == "PLAYER_ENTERING_WORLD" and not KBOCDTooltipAnchor.initialEnteringWorldCompleted then
        KBOCDTooltipAnchor.UpdateAnchorFrameEnablement()
        KBOCDTooltipAnchor.UpdateAnchorFrameVisibility()

        KBOCDTooltipAnchor:CreateConfigPanel()
        DEFAULT_CHAT_FRAME:AddMessage("|cfff2e147KBOCDTooltipAnchor |cffa19d78loaded.|r")

        KBOCDTooltipAnchor.initialEnteringWorldCompleted = true
    end
end)
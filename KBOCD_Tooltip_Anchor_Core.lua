--------------------------------------------------
-- Init
--------------------------------------------------
KBOCDTooltipAnchor = KBOCDTooltipAnchor or {}

--------------------------------------------------
-- Table Values
--------------------------------------------------
KBOCDTooltipAnchor.DefaultValues = {
    enabled                 = true,
    anchorFrameVisible      = true,
    perCharacterSettings    = true,
    selectedAnchor          = "TOPLEFT",
    point                   = "CENTER",
    xPos                    = 0,
    yPos                    = 0
}

KBOCDTooltipAnchor.AnchorPoints = {
    TOPLEFT     = "TOPLEFT",
    TOP         = "TOP",
    TOPRIGHT    = "TOPRIGHT",
    LEFT        = "LEFT",
    RIGHT       = "RIGHT",
    BOTTOMLEFT  = "BOTTOMLEFT",
    BOTTOM      = "BOTTOM",
    BOTTOMRIGHT = "BOTTOMRIGHT"
}

KBOCDTooltipAnchor.AnchorButtons = {}

--------------------------------------------------
-- Amchor Frame Logic
--------------------------------------------------
KBOCDTooltipAnchor.currentlySelectedAnchorPoint = nil

local function CreateAnchorButton(parent, anchorPoint)
    local anchorButton = CreateFrame("Button", nil, parent)
    anchorButton:SetSize(14, 14)
    anchorButton:SetPoint(anchorPoint, parent, anchorPoint)

    anchorButton.texture = anchorButton:CreateTexture(nil, "ARTWORK")
    anchorButton.texture:SetAllPoints()

    if anchorPoint == KBOCDTooltipAnchor.currentlySelectedAnchorPoint then
        anchorButton.texture:SetColorTexture(1, 0, 0, 0.8)
    else
        anchorButton.texture:SetColorTexture(1, 1, 1, 0.8)
    end

    anchorButton:SetScript("OnClick", function()
        KBOCDTooltipAnchor.UpdateSelectedAnchorButton(anchorPoint)
    end)

    KBOCDTooltipAnchor.AnchorButtons[anchorPoint] = anchorButton
end

function KBOCDTooltipAnchor.CreateTooltipAnchorFrame()
    local tooltipAnchor = CreateFrame("Frame", "KBOCDTooltipAnchor_AnchorFrame", UIParent)
    tooltipAnchor:SetSize(200, 100)
    tooltipAnchor:ClearAllPoints()
    tooltipAnchor:SetPoint(KBOCDTooltipAnchorActiveDB.point, UIParent, KBOCDTooltipAnchorActiveDB.point, KBOCDTooltipAnchorActiveDB.xPos, KBOCDTooltipAnchorActiveDB.yPos)
    tooltipAnchor:SetMovable(KBOCDTooltipAnchorActiveDB.anchorFrameVisible)
    tooltipAnchor:EnableMouse(KBOCDTooltipAnchorActiveDB.anchorFrameVisible)
    tooltipAnchor:RegisterForDrag("LeftButton")
    tooltipAnchor:SetClampedToScreen(true)

    tooltipAnchor:SetScript("OnDragStart", function(self)
        self:StartMoving()
    end)
    tooltipAnchor:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        KBOCDTooltipAnchor.SaveAnchorPosition()
        tooltipAnchor:SetPoint(KBOCDTooltipAnchorActiveDB.point, UIParent, KBOCDTooltipAnchorActiveDB.point, KBOCDTooltipAnchorActiveDB.xPos, KBOCDTooltipAnchorActiveDB.yPos)
    end)

    tooltipAnchor.bg = tooltipAnchor:CreateTexture(nil, "BACKGROUND")
    tooltipAnchor.bg:SetAllPoints()
    tooltipAnchor.bg:SetColorTexture(0, 0, 0, 0.4)

    for anchorPoint in pairs(KBOCDTooltipAnchor.AnchorPoints) do
        CreateAnchorButton(tooltipAnchor, anchorPoint)
    end

    return tooltipAnchor
end

function KBOCDTooltipAnchor.UpdateSelectedAnchorButton(selectedAnchorPoint)
    if selectedAnchorPoint == KBOCDTooltipAnchor.currentlySelectedAnchorPoint then
        return
    end

    local selectedAnchorButton = KBOCDTooltipAnchor.AnchorButtons[selectedAnchorPoint]
    local previousAnchorButton = KBOCDTooltipAnchor.AnchorButtons[KBOCDTooltipAnchor.currentlySelectedAnchorPoint]
    KBOCDTooltipAnchor.currentlySelectedAnchorPoint = selectedAnchorPoint

    selectedAnchorButton.texture:SetColorTexture(1, 0, 0, 0.8)
    previousAnchorButton.texture:SetColorTexture(1, 1, 1, 0.8)

    KBOCDTooltipAnchorActiveDB.selectedAnchor = KBOCDTooltipAnchor.AnchorPoints[KBOCDTooltipAnchor.currentlySelectedAnchorPoint]
end

function KBOCDTooltipAnchor.AnchorTooltip(tooltip)
    if not tooltip or tooltip:IsForbidden() then return end
    if not KBOCDTooltipAnchor.tooltipAnchor then return end

    tooltip:ClearAllPoints()
    tooltip:SetOwner(UIParent, "ANCHOR_NONE")
    tooltip:SetPoint(
        KBOCDTooltipAnchor.currentlySelectedAnchorPoint,        -- tooltip point
        KBOCDTooltipAnchor.tooltipAnchor,                       -- relative frame
        KBOCDTooltipAnchor.currentlySelectedAnchorPoint,        -- relative point
        0, 0                              -- offsets
    )
end

function KBOCDTooltipAnchor.SaveAnchorPosition()
    local tooltipAnchorFrame = KBOCDTooltipAnchor.tooltipAnchor
    if not tooltipAnchorFrame then return end
    local point, _, _, xOffset, yOffset = tooltipAnchorFrame:GetPoint()
    if point == nil or xOffset == nil or yOffset== nil then return end
    KBOCDTooltipAnchorActiveDB.point          = point
    KBOCDTooltipAnchorActiveDB.xPos           = xOffset
    KBOCDTooltipAnchorActiveDB.yPos           = yOffset
end

hooksecurefunc("GameTooltip_SetDefaultAnchor", function(self)
    if not KBOCDTooltipAnchor.AnchorTooltip then return end
    KBOCDTooltipAnchor.AnchorTooltip(self)
end)

function KBOCDTooltipAnchor.UpdateAnchorFrameEnablement(switchingDB)
    if switchingDB then
        if KBOCDTooltipAnchor.tooltipAnchor then
            KBOCDTooltipAnchor.tooltipAnchor:Hide()
        end
        KBOCDTooltipAnchor.tooltipAnchor = nil
    end
    if KBOCDTooltipAnchorActiveDB.enabled and not KBOCDTooltipAnchor.tooltipAnchor then
        KBOCDTooltipAnchor.tooltipAnchor = KBOCDTooltipAnchor.CreateTooltipAnchorFrame()
        KBOCDTooltipAnchor.UpdateAnchorFrameVisibility()
    elseif not KBOCDTooltipAnchorActiveDB.enabled and KBOCDTooltipAnchor.tooltipAnchor then
        KBOCDTooltipAnchor.tooltipAnchor:Hide()
        KBOCDTooltipAnchor.tooltipAnchor = nil
    end
end

function KBOCDTooltipAnchor.UpdateAnchorFrameVisibility()
    local tooltipAnchorFrame = KBOCDTooltipAnchor.tooltipAnchor
    if not tooltipAnchorFrame then return end

    tooltipAnchorFrame:SetMovable(KBOCDTooltipAnchorActiveDB.anchorFrameVisible)
    tooltipAnchorFrame:EnableMouse(KBOCDTooltipAnchorActiveDB.anchorFrameVisible)

    local alpha = 0
    if KBOCDTooltipAnchorActiveDB.anchorFrameVisible then
        alpha = 1
    end
    tooltipAnchorFrame:SetAlpha(alpha)
end

--------------------------------------------------
-- User Defined Values (Uses 'DefaultValues' values if user defined values do not exist)
--------------------------------------------------
function KBOCDTooltipAnchor.CopyDefaultValues(src, dest)
    for key, value in pairs(src) do
        if type(value) == "table" then
            if type(dest[key]) ~= "table" then
                dest[key] = {}
            end
            KBOCDTooltipAnchor.CopyDefaultValues(value, dest[key])
        else
            if dest[key] == nil then
                dest[key] = value
            end
        end
    end
end

--------------------------------------------------
-- Initialize DB (set values)
--------------------------------------------------
function KBOCDTooltipAnchor.InitializeUserValues()
    KBOCDTooltipAnchorDB = KBOCDTooltipAnchorDB or {}
    KBOCDTooltipAnchorGlobalDB = KBOCDTooltipAnchorGlobalDB or {}
    KBOCDTooltipAnchor.SwitchActiveDB()
    KBOCDTooltipAnchor.CopyDefaultValues(KBOCDTooltipAnchor.DefaultValues, KBOCDTooltipAnchorDB)
    KBOCDTooltipAnchor.CopyDefaultValues(KBOCDTooltipAnchor.DefaultValues, KBOCDTooltipAnchorGlobalDB)
end

--------------------------------------------------
-- Active DB Switcher
--------------------------------------------------
function KBOCDTooltipAnchor.SwitchActiveDB(calledFromSettings)
    if KBOCDTooltipAnchorDB.perCharacterSettings then
        KBOCDTooltipAnchorDB = KBOCDTooltipAnchorDB or {}
        KBOCDTooltipAnchorActiveDB = KBOCDTooltipAnchorDB
    else
        KBOCDTooltipAnchorGlobalDB = KBOCDTooltipAnchorGlobalDB or {}
        KBOCDTooltipAnchorActiveDB = KBOCDTooltipAnchorGlobalDB
    end

    if calledFromSettings then
        KBOCDTooltipAnchor.enabledCheckBoxSetting:NotifyUpdate()
        KBOCDTooltipAnchor.disableAndMakeMoveableSetting:NotifyUpdate()
        KBOCDTooltipAnchor.UpdateAnchorFrameEnablement(true)
        KBOCDTooltipAnchor.UpdateAnchorFrameVisibility()
    end
end
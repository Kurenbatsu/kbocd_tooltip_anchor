--------------------------------------------------
-- Local Aliases
--------------------------------------------------
local db = nil
local tooltipAnchor = nil

--------------------------------------------------
-- Init Aliases
--------------------------------------------------
function KBOCDTooltipAnchor.InitializeConfigCoreAliases()
    db                   = KBOCDTooltipAnchorDB
    tooltipAnchor        = KBOCDTooltipAnchor.tooltipAnchor
end

--------------------------------------------------
-- Config UI Elements Table
--------------------------------------------------
function KBOCDTooltipAnchor.CreateUIElementValuesTable()
    KBOCDTooltipAnchor.UIElementValues = {
    --------------------------------------------------
    -- Global Confg UI
    --------------------------------------------------
        global = {
            label = {
                configHeader = {
                    string        = "KBOCD Tooltip Anchor",
                    style         = "GameFontNormalLarge",
                    point         = "TOPLEFT",
                    relativePoint = "TOPLEFT",
                    xPos          = 16,
                    yPos          = -16,
                },
                configSubtitle = {
                    string        = "Configure your tooltip anchor.",
                    style         = "GameFontHighlight",
                    point         = "TOPLEFT",
                    relativePoint = "BOTTOMLEFT",
                    xPos          = 0,
                    yPos          = -8,
                }
            },
            checkBox = {
                enable = {
                    label         = "Enable",
                    db            = db,
                    dbKey         = "enabled",
                    point         = "TOPLEFT",
                    relativePoint = "BOTTOMLEFT",
                    xPos          = 15,
                    yPos          = -8,
                    closure       = function(enabled)
                        KBOCDTooltipAnchor.UpdateAnchorFrameEnablement()
                    end
                },
                displayAndMakeFrameMoveable = {
                    label         = "Display tooltip anchor frame and make moveable",
                    db            = db,
                    dbKey         = "anchorFrameVisible",
                    point         = "TOPLEFT",
                    relativePoint = "BOTTOMLEFT",
                    xPos          = 0,
                    yPos          = -8,
                    closure       = function(enabled)
                        KBOCDTooltipAnchor.UpdateAnchorFrameVisibility()
                    end
                },
            },
            resetButton = {
                typeForConfirmationBox = "Tooltip Anchor",
                db                     = db,
                defaultValuesTable     = KBOCDTooltipAnchor.DefaultValues,
                point                  = "CENTER",
                relativePoint          = "RIGHT",
                xPos                   = 477.3,
                yPos                   = 0,
            }
        },
    }
end

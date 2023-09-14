---@type DruidBuff
local buff
---@type Cast
local cast
---@type DruidCD
local cd
local charges
---@type DruidDebuff
local debuff
local enemies
local equiped
local module
local race
local power
local spell
---@type SupportFiles
local support
---@type DruidTalent
local talent
---@type BR.API.UI
local ui
local unit
local units
local use

local var
---@type UIVariables
local uiOpt
---@type UMFeralUtility
local utility

local loaded = false

---@class UMFeralACLPrecombat
br.rotations.support.UMFeralACLPrecombat = {
    ---@param from? string
    precombat = function(from)
        if not unit.inCombat() and not (unit.flying() or unit.mounted()) then
            -- TODO: ADD INSTANCE SELECTION DROP FOR AUGMENT RUNE
            if uiOpt.augmentRune() and not buff.draconicAugmentRune.exists() and use.able.draconicAugmentRune() and var.lastRune + unit.gcd(true) < var.getTime then
                if use.draconicAugmentRune() then
                    ui.debug("Using Draconic Augment Rune - [precombat] - 1")
                    var.lastRune = var.getTime
                    return true
                end
            end
            -- Prowl - Non-PrePull
            if cast.able.prowl("player") and utility.autoProwl() and uiOpt.prowlMode() and not var.bsInc then
                if cast.prowl("player") then
                    ui.debug("Casting Prowl (Auto) - [precombat] - 2")
                    return true
                end
            end
        end
    end,
    load = function()
        if not loaded then
            buff    = br.player.buff
            cast    = br.player.cast
            cd      = br.player.cd
            charges = br.player.charges
            debuff  = br.player.debuff
            enemies = br.player.enemies
            equiped = br.player.equiped
            module  = br.player.module
            race    = br.player.race
            power   = br.player.power
            spell   = br.player.spell
            support = br.rotations.support
            talent  = br.player.talent
            ui      = br.player.ui
            unit    = br.player.unit
            units   = br.player.units
            use     = br.player.use

            var = support.UMFeralVariables.var
            uiOpt = support.UMUI.options
            utility = support.UMFeralUtility

            loaded = true
        end
    end
}
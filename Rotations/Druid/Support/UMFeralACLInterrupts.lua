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

---@class UMFeralACLInterrupts
br.rotations.support.UMFeralACLInterrupts = {
    ---@param from? string
    interrupts = function(from)
        if ui.useInterrupt() then
            local thisUnit
            -- Skull Bash
            if uiOpt.useSkullBash() and cast.able.skullBash() then
                for i = 1, #var.enemies.yards13f do
                    thisUnit = var.enemies.yards13f[i]
                    if unit.interruptable(thisUnit, uiOpt.interruptAt()) then
                        if cast.skullBash(thisUnit) then
                            ui.debug("Casting Skull Bash on " .. unit.name(thisUnit) .. " [interrupts] - 1")
                            return true
                        end
                    end
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
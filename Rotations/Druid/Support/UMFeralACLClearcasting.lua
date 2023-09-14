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

---@class UMFeralACLClearcasting
br.rotations.support.UMFeralACLClearcasting = {
    ---@param from? string
    clearcasting = function(from)
        -- 1 thrash_cat,if=refreshable&!talent.thrashing_claws.enabled
        if cast.able.thrashCat(var.thrashCatTicksGainUnit) and debuff.thrashCat.refresh(var.thrashCatTicksGainUnit) and not talent.thrashingClaws then
            if cast.thrashCat(var.thrashCatTicksGainUnit) then
                ui.debug("Casting Thrash [Clearcasting]" .. (from and " from " .. from or ""))
                return true
            end
        end
    
        -- 2 swipe_cat,if=spell_targets.swipe_cat>1
        if not talent.brutalSlash and cast.able.swipeCat() and var.swipeTargets > 1 then
            if cast.swipeCat() then
                ui.debug("Casting Swipe [Clearcasting]" .. (from and " from " .. from or ""))
                return true
            end
        end
    
        -- 3 brutal_slash,if=spell_targets.brutal_slash>2
        if talent.brutalSlash and cast.able.brutalSlash() and var.swipeTargets > 2 then
            if cast.brutalSlash() then
                ui.debug("Casting Brutal Slash [Clearcasting]" .. (from and " from " .. from or ""))
                return true
            end
        end
    
        -- 4 shred
        if cast.able.shred(var.maxTTDUnit) then
            if cast.shred(var.maxTTDUnit) then
                ui.debug("Casting Shred [Clearcasting]" .. (from and " from " .. from or ""))
                return true
            end
        end
        --ui.debug("Exiting Action List [clearcasting]")
        return false
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
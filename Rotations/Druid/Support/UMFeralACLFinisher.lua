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

---@class UMFeralACLFinisher
br.rotations.support.UMFeralACLFinisher = {
    ---@param from? string
    finisher = function(from)
        -- 1 primal_wrath,if=((dot.primal_wrath.refreshable&!talent.circle_of_life_and_death.enabled)|dot.primal_wrath.remains<6|(talent.tear_open_wounds.enabled|(spell_targets.swipe_cat>4&!talent.rampant_ferocity.enabled)))&spell_targets.primal_wrath>1&talent.primal_wrath.enabled
        if cast.able.primalWrath() and ((talent.tearOpenWounds or (#var.enemies.yards8 > 4 and not talent.rampantFerocity))) and #var.enemies.yards8 > 1 and talent.primalWrath then
            if cast.primalWrath() then
                ui.debug("Casting Primal Wrath - AoE [finisher]" .. (from and " from " .. from or ""))
                return true
            end
        end
        -- primal_wrath,target_if=refreshable,if=spell_targets.primal_wrath>1
        if #var.enemies.yards8 > 1 then
            for i = 1, #var.enemies.yards8 do
                local thisUnit = var.enemies.yards8[i]
                if cast.able.primalWrath(thisUnit) then
                    if cast.primalWrath(thisUnit) then
                        ui.debug("Casting Primal Wrath - Refresh [finisher]" .. (from and " from " .. from or ""))
                        return true
                    end
                end
            end
        end
    
        -- 2 rip,target_if=refreshable&(!talent.primal_wrath.enabled|spell_targets.swipe_cat=1)
        if cast.able.rip(var.lowestRipUnit) and debuff.rip.refresh(var.lowestRipUnit) and (not talent.primalWrath or var.swipeTargets == 1) then
            if cast.rip(var.lowestRipUnit) then
                ui.debug("Casting Rip [finisher] - 2" .. (from and " from " .. from or ""))
                return true
            end
        end
    
        -- 3 pool_resource,for_next=1,if=!action.tigers_fury.ready&buff.apex_predators_craving.down
        if not cast.able.tigersFury() and not buff.apexPredatorsCraving.exists() then
            if cast.pool.ferociousBite(false, var.fbMaxEnergyAmt ) then
                ui.debug("Casting Pool Resource [finisher] - 3" .. (from and " from " .. from or ""))
                return true
            end
        end
        -- 4 ferocious_bite,max_energy=1,target_if=max:target.time_to_die,if=buff.apex_predators_craving.down&(!buff.bs_inc.up|(buff.bs_inc.up&!talent.soul_of_the_forest.enabled))
        if cast.able.ferociousBite(var.maxTTDUnit) and var.fbMaxEnergy and not buff.apexPredatorsCraving.exists() and (not var.bsIncUp or (var.bsIncUp and not talent.soulOfTheForest)) then
            if cast.ferociousBite(var.maxTTDUnit) then
                ui.debug("Casting Ferocious Bite [finisher] - 4" .. (from and " from " .. from or ""))
                return true
            end
        end
        -- 5 ferocious_bite,target_if=max:target.time_to_die,if=(buff.bs_inc.up&talent.soul_of_the_forest.enabled)|buff.apex_predators_craving.up
        if cast.able.ferociousBite(var.maxTTDUnit) and (var.bsIncUp and talent.soulOfTheForest) or buff.apexPredatorsCraving.exists() then
            if cast.ferociousBite(var.maxTTDUnit) then
                ui.debug("Casting Ferocious Bite [finisher] - 5" .. (from and " from " .. from or ""))
                return true
            end
        end
        --ui.debug("Exiting Action List [finisher]")
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
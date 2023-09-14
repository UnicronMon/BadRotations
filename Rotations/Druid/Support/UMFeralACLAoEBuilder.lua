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

---@class UMFeralACLAoEBuilder
br.rotations.support.UMFeralACLAoEBuilder = {
    ---@param from? string
    aoe_builder = function(from)
        -- 1 brutal_slash,target_if=min:target.time_to_die,if=cooldown.brutal_slash.full_recharge_time<4|target.time_to_die<5
        if talent.brutalSlash and cast.able.brutalSlash(var.lowestTTDUnit) and (charges.brutalSlash.timeTillFull() < 4 or var.lowestTTD < 5) then
            if cast.brutalSlash(var.lowestTTDUnit) then
                ui.debug("Casting Brutal Slash [aoe_builder] - 1")
                return true
            end
        end
        -- 2 thrash_cat,target_if=refreshable,if=buff.clearcasting.react|(spell_targets.thrash_cat>10|(spell_targets.thrash_cat>5&!talent.double_clawed_rake.enabled))&!talent.thrashing_claws
        if cast.able.thrashCat(var.thrashCatTicksGainUnit) and debuff.thrashCat.refresh() and buff.clearcasting.react() or (var.swipeTargets > 10 or (var.swipeTargets > 5 and not talent.doubleClawedRake)) and not talent.thrashingClaws then
            if cast.thrashCat(var.thrashCatTicksGainUnit) then
                ui.debug("Casting Thrash [aoe_builder] - 2")
                return true
            end
        end
        -- 3 shadowmeld,target_if=max:druid.rake.ticks_gained_on_refresh,if=action.rake.ready&!buff.sudden_ambush.up&(dot.rake.refreshable|dot.rake.pmultiplier<1.4)&!buff.prowl.up&!buff.apex_predators_craving.up
        if cast.able.shadowmeld() and (debuff.rake.refresh() or debuff.rake.applied() < 1.4) and not utility.isStealthed() and not buff.apexPredatorsCraving.exists()
        then
            if cast.shadowmeld() then
                ui.debug("Casting Shadowmeld [aoe_builder] - 3")
                return true
            end
        end
        -- 4 shadowmeld,target_if=druid.rake.ticks_gained_on_refresh,if=action.rake.ready&!buff.sudden_ambush.up&dot.rake.pmultiplier<1.4&!buff.prowl.up&!buff.apex_predators_craving.up
        if cast.able.shadowmeld() and debuff.rake.applied() < 1.4 and not buff.prowl.exists() and not buff.apexPredatorsCraving.exists() then
            if cast.shadowmeld() then
                ui.debug("Casting Shadowmeld [aoe_builder] - 4")
                return true
            end
        end
        -- 5 rake,target_if=max:druid.rake.ticks_gained_on_refresh,if=buff.sudden_ambush.up&persistent_multiplier>dot.rake.pmultiplier
        if cast.able.rake(var.maxRakeTicksGainUnit) and buff.suddenAmbush.exists() and (utility.persistentMultiplier('rake') > debuff.rake.pmultiplier(var.maxRakeTicksGainUnit)) then
            if cast.rake(var.maxRakeTicksGainUnit) then
                ui.debug("Casting Rake [aoe_builder] - 5")
                return true
            end
        end
        -- 6 rake,target_if=buff.sudden_ambush.up&persistent_multiplier>dot.rake.pmultiplier|refreshable
        if cast.able.rake(var.maxRakeTicksGainUnit) and buff.suddenAmbush.exists() and utility.persistentMultiplier('rake') > debuff.rake.pmultiplier(var.maxRakeTicksGainUnit) or debuff.rake.refresh(var.maxRakeTicksGainUnit) then
            if cast.rake(var.maxRakeTicksGainUnit) then
                ui.debug("Casting Rake [aoe_builder] - 6")
                return true
            end
        end
        -- 7 thrash_cat,target_if=refreshable
        if cast.able.thrashCat(var.thrashCatTicksGainUnit) and (debuff.thrashCat.refresh(var.thrashCatTicksGainUnit)) then
            if cast.thrashCat(var.thrashCatTicksGainUnit) then
                ui.debug("Casting Thrash [aoe_builder] - 7")
                return true
            end
        end
        -- 8 brutal_slash
        if talent.brutalSlash and cast.able.brutalSlash() then
            if cast.brutalSlash() then
                ui.debug("Casting Brutal Slash [aoe_builder] - 8")
                return true
            end
        end
        -- 9 moonfire_cat,target_if=max:(3*refreshable)+dot.adaptive_swarm_damage.ticking,if=spell_targets.swipe_cat<5&dot.moonfire.refreshable
        if talent.lunarInspiration and cast.able.moonfireCat(var.units.dyn40AOE) and var.swipeTargets < 5 and debuff.moonfireCat.refresh(var.units.dyn40AOE) then
            if cast.moonfireCat(var.units.dyn40AOE) then
                ui.debug("Casting Moonfire [aoe_builder] - 9")
                return true
            end
        end
        -- swipe_cat
        if not talent.brutalSlash and cast.able.swipeCat() then
            if cast.swipeCat() then
                ui.debug("Casting Swipe [aoe_builder] - 10")
                return true
            end
        end
        -- 10 moonfire_cat,target_if=max:(3*refreshable)+dot.adaptive_swarm_damage.ticking,if=dot.moonfire.refreshable
        if talent.lunarInspiration and cast.able.moonfireCat(var.units.dyn40AOE) and debuff.moonfireCat.refresh(var.units.dyn40AOE) then
            if cast.moonfireCat(var.units.dyn40AOE) then
                ui.debug("Casting Moonfire [aoe_builder] - 11")
                return true
            end
        end
        -- 11 shred,target_if=max:target.time_to_die,if=(spell_targets.swipe_cat<4|talent.dire_fixation.enabled)&!buff.sudden_ambush.up&!(variable.lazy_swipe&talent.wild_slashes)
        if cast.able.shred(var.maxTTDUnit) and (var.swipeTargets < 4 or talent.direFixation) and not buff.suddenAmbush.exists() and not talent.wildSlashes then
            if cast.shred(var.maxTTDUnit) then
                ui.debug("Casting Shred [aoe_builder] - 12")
                return true
            end
        end
        -- 12 thrash_cat
        if cast.able.thrashCat(var.thrashCatTicksGainUnit) then
            if cast.thrashCat(var.thrashCatTicksGainUnit) then
                ui.debug("Casting Thrash [aoe_builder] - 13")
                return true
            end
        end
        --ui.debug("Exiting Action List [aoe_builder]")
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
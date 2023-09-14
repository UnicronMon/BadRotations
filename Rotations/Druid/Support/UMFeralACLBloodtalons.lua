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

---@class UMFeralACLBloodtalons
br.rotations.support.UMFeralACLBloodtalons = {
    ---@param from? string
    bloodtalons = function(from)
        -- 1 brutal_slash,target_if=min:target.time_to_die,if=(cooldown.brutal_slash.full_recharge_time<4|target.time_to_die<5)&(buff.bt_brutal_slash.down&(buff.bs_inc.up|variable.need_bt))
        if cast.able.brutalSlash() and (charges.brutalSlash.timeTillFull() < 4 and (not utility.bt.brutalSlash and (var.bsIncUp or utility.bt.need))) then
            if cast.brutalSlash() then
                ui.debug("Casting Shred [bloodtalons - 1]" .. (from and " from " .. from or ""))
                return true
            end
        end
        -- 2 prowl,if=action.rake.ready&gcd.remains=0&!buff.sudden_ambush.up&(dot.rake.refreshable|dot.rake.pmultiplier<1.4)&!buff.shadowmeld.up&buff.bt_rake.down&!buff.prowl.up&!buff.apex_predators_craving.up
        if cast.able.prowl() and uiOpt.prowlMode() and cast.able.rake() and unit.gcd == 0 and not buff.suddenAmbush.exists() and (debuff.rake.refresh(var.maxRakeTicksGainUnit) or debuff.rake.pmultiplier(var.maxRakeTicksGainUnit) < 1.4) and not utility.isStealthed() and not buff.apexPredatorsCraving.exists() then
            if cast.incarnProwl("player") or cast.prowl("player") then
                ui.debug("Casting Prowl [bloodtalons - 2]" .. (from and " from " .. from or ""))
                return true
            end
        end
        -- 3 shadowmeld,if=action.rake.ready&!buff.sudden_ambush.up&(dot.rake.refreshable|dot.rake.pmultiplier<1.4)&!buff.prowl.up&buff.bt_rake.down&cooldown.feral_frenzy.remains<44&!buff.apex_predators_craving.up
        if cast.able.shadowmeld() and cast.able.rake() and not buff.suddenAmbush.exists() and (debuff.rake.refresh(var.maxRakeTicksGainUnit) or debuff.rake.pmultiplier(var.maxRakeTicksGainUnit) < 1.4) and not utility.isStealthed() and not buff.apexPredatorsCraving.exists() then
            if cast.shadowmeld() then
                ui.debug("Casting Shadowmeld [bloodtalons - 3]" .. (from and " from " .. from or ""))
                return true
            end
        end
        -- 4 rake,target_if=max:druid.rake.ticks_gained_on_refresh,if=(refreshable|buff.sudden_ambush.up&persistent_multiplier>dot.rake.pmultiplier)&buff.bt_rake.down
        if cast.able.rake(var.maxRakeTicksGainUnit) and ((debuff.rake.refresh(var.maxRakeTicksGainUnit) or buff.suddenAmbush.exists() and utility.persistentMultiplier('rake') > debuff.rake.pmultiplier(var.maxRakeTicksGainUnit)) and not utility.bt.rake) then
            if cast.rake(var.maxRakeTicksGainUnit) then
                ui.debug("Casting Rake [bloodtalons - 4]" .. (from and " from " .. from or ""))
                return true
            end
        end
        -- 5 rake,target_if=buff.sudden_ambush.up&persistent_multiplier>dot.rake.pmultiplier&buff.bt_rake.down
        if cast.able.rake(var.maxRakeTicksGainUnit) and buff.suddenAmbush.exists() and utility.persistentMultiplier('rake') > debuff.rake.pmultiplier(var.maxRakeTicksGainUnit) and not utility.bt.rake then
            if cast.rake(var.maxRakeTicksGainUnit) then
                ui.debug("Casting Rake [bloodtalons - 5]" .. (from and " from " .. from or ""))
                return true
            end
        end
        -- 6 shred,if=buff.bt_shred.down&buff.clearcasting.react&spell_targets.swipe_cat=1
        if cast.able.shred(var.maxTTDUnit) and not utility.bt.shred and buff.clearcasting.react() and var.swipeTargets == 1 then
            if cast.shred(var.maxTTDUnit) then
                ui.debug("Casting Shred [bloodtalons - 6]" .. (from and " from " .. from or ""))
                return true
            end
        end
        -- 7 thrash_cat,target_if=refreshable,if=buff.bt_thrash.down&buff.clearcasting.react&spell_targets.swipe_cat=1&!talent.thrashing_claws.enabled
        if cast.able.thrashCat(var.thrashCatTicksGainUnit) and debuff.thrashCat.refresh(var.thrashCatTicksGainUnit) and not utility.bt.thrashCat and buff.clearcasting.react() and var.swipeTargets == 1 and not talent.thrashingClaws then
            if cast.thrashCat(var.thrashCatTicksGainUnit) then
                ui.debug("Casting Thrash [bloodtalons - 7]" .. (from and " from " .. from or ""))
                return true
            end
        end
        -- 8 brutal_slash,if=buff.bt_brutal_slash.down
        if cast.able.brutalSlash() and not utility.bt.brutalSlash then
            if cast.brutalSlash() then
                ui.debug("Casting Brutal Slash [bloodtalons - 8]" .. (from and " from " .. from or ""))
                return true
            end
        end
        -- 9 moonfire_cat,if=refreshable&buff.bt_moonfire.down&spell_targets.swipe_cat=1
        if talent.lunarInspiration and cast.able.moonfireCat(var.units.dyn40AOE) and not utility.bt.moonfireCat and var.swipeTargets == 1 then
            if cast.moonfireCat(var.units.dyn40AOE) then
                ui.debug("Casting Moonfire [bloodtalons - 9]" .. (from and " from " .. from or ""))
                return true
            end
        end
        -- 10 thrash_cat,target_if=refreshable,if=buff.bt_thrash.down&!talent.thrashing_claws.enabled
        if cast.able.thrashCat(var.thrashCatTicksGainUnit) and debuff.thrashCat.refresh(var.thrashCatTicksGainUnit) and not utility.bt.thrashCat and not talent.thrashingClaws then
            if cast.thrashCat() then
                ui.debug("Casting Thrash [bloodtalons - 10]" .. (from and " from " .. from or ""))
                return true
            end
        end
        -- shred,if=buff.bt_shred.down&spell_targets.swipe_cat=1&(!talent.wild_slashes.enabled|(!debuff.dire_fixation.up&talent.dire_fixation.enabled))
        if cast.able.shred(var.maxTTDUnit) and not utility.bt.shred and var.swipeTargets == 1 and (not talent.wildSlashes or (not debuff.direFixation.exists(var.maxTTDUnit) and talent.direFixation)) then
            if cast.shred(var.maxTTDUnit) then
                ui.debug("Casting Shred [bloodtalons - 11]" .. (from and " from " .. from or ""))
                return true
            end
        end
        -- swipe_cat,if=buff.bt_swipe.down&talent.wild_slashes.enabled
        if not talent.brutalSlash and cast.able.swipeCat() and not utility.bt.swipeCat and talent.wildSlashes then
            if cast.swipeCat() then
                ui.debug("Casting Swipe [bloodtalons - 12]" .. (from and " from " .. from or ""))
                return true
            end
        end
        -- moonfire_cat,target_if=max:(3*refreshable)+dot.adaptive_swarm_damage.ticking,if=buff.bt_moonfire.down&spell_targets.swipe_cat<5
        if talent.lunarInspiration and cast.able.moonfireCat(var.maxMoonfireCatTicksGainUnit) and not utility.bt.moonfireCat and var.swipeTargets < 5 then
            if cast.moonfireCat(var.maxMoonfireCatTicksGainUnit) then
                ui.debug("Casting Moonfire [bloodtalons - 13]" .. (from and " from " .. from or ""))
                return true
            end
        end
        -- swipe_cat,if=buff.bt_swipe.down
        if not talent.brutalSlash and cast.able.swipeCat() and not utility.bt.swipeCat then
            if cast.swipeCat() then
                ui.debug("Casting Swipe [bloodtalons - 14]" .. (from and " from " .. from or ""))
                return true
            end
        end
        -- moonfire_cat,target_if=max:(3*refreshable)+dot.adaptive_swarm_damage.ticking,if=buff.bt_moonfire.down
        if talent.lunarInspiration and cast.able.moonfireCat(var.maxMoonfireCatTicksGainUnit) and not utility.bt.moonfireCat then
            if cast.moonfireCat(var.maxMoonfireCatTicksGainUnit) then
                ui.debug("Casting Moonfire [bloodtalons - 15]" .. (from and " from " .. from or ""))
                return true
            end
        end
        -- shred,target_if=max:target.time_to_die,if=(spell_targets>5|talent.dire_fixation.enabled)&buff.bt_shred.down&!buff.sudden_ambush.up&!(variable.lazy_swipe&talent.wild_slashes)
        if cast.able.shred(var.maxTTDUnit) and (var.swipeTargets > 5 or talent.direFixation) and not utility.bt.shred and not buff.suddenAmbush.exists() and not talent.wildSlashes then
            if cast.shred(var.maxTTDUnit) then
                ui.debug("Casting Shred [bloodtalons - 16]" .. (from and " from " .. from or ""))
                return true
            end
        end
        -- thrash_cat,if=buff.bt_thrash.down
        if cast.able.thrashCat(var.thrashCatTicksGainUnit) and not utility.bt.thrashCat then
            if cast.thrashCat(var.thrashCatTicksGainUnit) then
                ui.debug("Casting Thrash [bloodtalons - 17]" .. (from and " from " .. from or ""))
                return true
            end
        end
        -- rake,target_if=min:(25*(persistent_multiplier<dot.rake.pmultiplier)+dot.rake.remains),if=buff.bt_rake.down&(spell_targets.swipe_cat>4&!talent.dire_fixation|talent.wild_slashes&variable.lazy_swipe)
        if cast.able.rake(var.maxRakeTicksGainUnit) and not utility.bt.rake and (var.swipeTargets > 4 and not talent.direFixation or talent.wildSlashes) then
            if cast.rake(var.maxRakeTicksGainUnit) then
                ui.debug("Casting Rake [bloodtalons - 18]" .. (from and " from " .. from or ""))
                return true
            end
        end
        --ui.debug("Exiting Action List [bloodtalons]")
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
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

---@class UMFeralACLBerserk
br.rotations.support.UMFeralACLBerserk = {
    ---@param from? string
    berserk = function(from)
        -- 1 ferocious_bite,target_if=max:target.time_to_die,if=combo_points=5&dot.rip.remains>8&variable.zerk_biteweave&spell_targets.swipe_cat>1
        if cast.able.ferociousBite(var.maxTTDUnit) and var.stats.comboPoints == 5 and debuff.rip.remain(var.maxTTDUnit) > 8 and uiOpt.berserkBiteweave() and var.swipeTargets > 1 then
            if cast.ferociousBite("target") then
                ui.debug("Casting Ferocious Bite [berserk] - 1" .. (from and " from " .. from or ""))
                return true
            end
        end
        -- 2 call_action_list,name=finisher,if=combo_points=5&!(buff.overflowing_power.stack<=1&active_bt_triggers=2&buff.bloodtalons.stack<=1)
        if var.stats.comboPoints == 5 and not (buff.overflowingPower.stack() <= 1 and utility.bt.triggers == 2 and buff.bloodtalons.stack() <= 1) then
            --ui.debug("Calling Action List [finsiher] from [berserk] - 2")
            if br.rotations.support.UMFeralACLFinisher.finisher('berserk') then
                return true
            end
        end 
        -- 3 call_action_list,name=bloodtalons,if=spell_targets.swipe_cat>1
        if var.swipeTargets > 1 then
            --ui.debug("Calling Action List [bloodtalons] from [berserk] - 3")
            if br.rotations.support.UMFeralACLBloodtalons.bloodtalons('berserk - 3') then return true end
        end
        -- 4 prowl,if=!(buff.bt_rake.up&active_bt_triggers=2)&(action.rake.ready&gcd.remains=0&!buff.sudden_ambush.up&(dot.rake.refreshable|dot.rake.pmultiplier<1.4)&!buff.shadowmeld.up&cooldown.feral_frenzy.remains<44&!buff.apex_predators_craving.up)
        if cast.able.prowl() and uiOpt.prowlMode() and not (utility.bt.rake and utility.bt.triggers == 2)
            and (cast.able.rake() and unit.gcd == 0 and not buff.suddenAmbush.exists() and (debuff.rake.refresh(var.maxRakeTicksGainUnit) or debuff.rake.pmultiplier(var.maxRakeTicksGainUnit) < 1.4))
            and not utility.isStealthed() and (talent.feralFrenzy and cd.feralFrenzy.remain() < 44) and not buff.apexPredatorsCraving.exists()
        then
            if cast.incarnProwl("player") or cast.prowl("player") then
                ui.debug("Casting Prowl [berserk] - 4")
                return true
            end
        end
        -- 5 shadowmeld,if=!(buff.bt_rake.up&active_bt_triggers=2)&action.rake.ready&!buff.sudden_ambush.up&(dot.rake.refreshable|dot.rake.pmultiplier<1.4)&!buff.prowl.up&!buff.apex_predators_craving.up
        if cast.able.shadowmeld() and not (utility.bt.rake and utility.bt.triggers == 2) and cast.able.rake() and not buff.suddenAmbush.exists()
            and (debuff.rake.refresh(var.maxRakeTicksGainUnit) or debuff.rake.pmultiplier(var.maxRakeTicksGainUnit) < 1.4)
            and not utility.isStealthed() and not buff.apexPredatorsCraving.exists()
        then
            if cast.shadowmeld() then
                ui.debug("Casting Shadowmeld [berserk] - 5")
                return true
            end
        end
        -- 6 rake,if=!(buff.bt_rake.up&active_bt_triggers=2)&(refreshable|(buff.sudden_ambush.up&persistent_multiplier>dot.rake.pmultiplier))
        if cast.able.rake(var.maxRakeTicksGainUnit) and not (utility.bt.rake and utility.bt.triggers == 2) and (debuff.rake.refresh(var.maxRakeTicksGainUnit) or (buff.suddenAmbush.exists() and utility.persistentMultiplier('rake') > debuff.rake.pmultiplier(var.maxRakeTicksGainUnit)))
        then
            if cast.rake(var.maxRakeTicksGainUnit) then
                ui.debug("Casting Rake [berserk] - 6" .. (from and " from " .. from or ""))
                return true
            end
        end
        -- 7 shred,if=(active_bt_triggers=2|(talent.dire_fixation.enabled&!debuff.dire_fixation.up))&buff.bt_shred.down
        if cast.able.shred(var.maxTTDUnit) and (utility.bt.triggers == 2 or (talent.direFixation and not debuff.direFixation.exists(var.maxTTDUnit))) and not utility.bt.shred then
            if cast.shred(var.maxTTDUnit) then
                ui.debug("Casting Shred [berserk] - 7" .. (from and " from " .. from or ""))
                return true
            end
        end
        -- 8 brutal_slash,if=active_bt_triggers=2&buff.bt_brutal_slash.down
        if talent.brutalSlash and cast.able.brutalSlash() and utility.bt.triggers == 2 and not utility.bt.brutalSlash then
            if cast.brutalSlash() then
                ui.debug("Casting Brutal Slash [berserk] - 8" .. (from and " from " .. from or ""))
                return true
            end
        end
        -- 9 moonfire_cat,if=active_bt_triggers=2&buff.bt_moonfire.down
        if talent.lunarInspiration and cast.able.moonfireCat(var.maxMoonfireCatTicksGainUnit) and utility.bt.triggers == 2 and not utility.bt.moonfireCat then
            if cast.moonfireCat(var.maxMoonfireCatTicksGainUnit) then
                ui.debug("Casting Moonfire [berserk] - 9" .. (from and " from " .. from or ""))
                return true
            end
        end
        -- 10 thrash_cat,if=active_bt_triggers=2&buff.bt_thrash.down&!talent.thrashing_claws&variable.need_bt&(refreshable|talent.brutal_slash.enabled)
        if cast.able.thrashCat(var.thrashCatTicksGainUnit) and utility.bt.triggers == 2 and not utility.bt.thrashCat and not talent.thrashingClaws and utility.bt.need and (debuff.thrashCat.refresh(var.thrashCatTicksGainUnit) or talent.brutalSlash)
        then
            if cast.thrashCat(var.thrashCatTicksGainUnit) then
                ui.debug("Casting Thrash [berserk] - 10" .. (from and " from " .. from or ""))
                return true
            end
        end
        -- 11 moonfire_cat,if=refreshable
        if talent.lunarInspiration and cast.able.moonfireCat() and debuff.moonfireCat.refresh(var.maxMoonfireCatTicksGainUnit) then
            if cast.moonfireCat(var.maxMoonfireCatTicksGainUnit) then
                ui.debug("Casting Moonfire [berserk] - 11" .. (from and " from " .. from or ""))
                return true
            end
        end
        -- 12 brutal_slash,if=cooldown.brutal_slash.charges>1
        if talent.brutalSlash and cast.able.brutalSlash() and utility.getChargeInfo(charges.brutalSlash).current > 1 then
            if cast.brutalSlash() then
                ui.debug("Casting Brutal Slash [berserk] - 12" .. (from and " from " .. from or ""))
                return true
            end
        end
        -- 13 shred
        if cast.able.shred(var.maxTTDUnit) then
            if cast.shred(var.maxTTDUnit) then
                ui.debug("Casting Shred [berserk] - 13" .. (from and " from " .. from or ""))
                return true
            end
        end
        --ui.debug("Exiting Action List [berserk]")
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
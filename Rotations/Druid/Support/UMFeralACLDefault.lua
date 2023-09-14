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

---@class UMFeralACLDefault
br.rotations.support.UMFeralACLDefault = {
    ---@param from? string
    default = function(from)
        if support.UMFeralACLInterrupts.interrupts() then return true end

        -- 1 prowl,if=(buff.bs_inc.down|!in_combat)&!buff.prowl.up","Executed every time the actor is available.
        if not unit.inCombat() and utility.canCastStealth and utility.shouldStealth() and uiOpt.prowlMode() then
            if cast.prowl() then
                ui.debug("Casting Prowl [def] - 1" .. (from and " from " .. from or ""))
                return true
            end
            if cast.incarnProwl() then
                ui.debug("Casting Incarn Prowl [def] - 1" .. (from and " from " .. from or ""))
                return true
            end
        end

        -- 2 cat_form,if=!buff.cat_form.up
        if cast.able.catForm("player") and not buff.catForm.exists() then
            if cast.catForm("player") then
                ui.debug("Casting Cat Form [def] - 2" .. (from and " from " .. from or ""))
                return true
            end
        end

        -- 5 tigers_fury,target_if=min:target.time_to_die,if=talent.convoke_the_spirits.enabled|!talent.convoke_the_spirits.enabled&(!buff.tigers_fury.up|energy.deficit>65)|(target.time_to_die<15&talent.predator.enabled)
        if cast.able.tigersFury() and talent.convokeTheSpiritsFeral or not talent.convokeTheSpiritsFeral and (not buff.tigersFury.exists() or var.energyDeficit > 65) or (var.lowestTTD < 15 and talent.predator) then
            if cast.tigersFury("player") then
                ui.debug("Casting Tiger's Fury [def] - 5" .. (from and " from " .. from or ""))
                return true
            end
        end

        -- 6 rake,target_if=persistent_multiplier>dot.rake.pmultiplier,if=buff.prowl.up|buff.shadowmeld.up
        if cast.able.rake() and utility.isStealthed() then
            for i = 1, #var.enemies.yards5f do
                local thisUnit = var.enemies.yards5f[i]
                if (utility.persistentMultiplier('rake') > debuff.rake.pmultiplier(thisUnit)) then
                    if cast.rake(thisUnit) then
                        ui.debug("Casting Rake [def] - 6" .. (from and " from " .. from or ""))
                        return true
                    end
                end
            end
        end

        -- 10 adaptive_swarm,target=self,if=talent.unbridled_swarm&spell_targets.swipe_cat<=1&dot.adaptive_swarm_heal.stack<4&dot.adaptive_swarm_heal.remains>4
        if talent.adaptiveSwarm and talent.unbridledSwarm and var.swipeTargets <= 1 and debuff.adaptiveSwarmHeal.stack() < 4 and debuff.adaptiveSwarmHeal.remain() > 4 then
            if cast.adaptiveSwarm("player") then
                ui.debug("Casting Adaptive Swarm [def] - 10" .. (from and " from " .. from or ""))
                return true
            end
        end
        -- 11 adaptive_swarm,target_if=((!dot.adaptive_swarm_damage.ticking|dot.adaptive_swarm_damage.remains<2)&(dot.adaptive_swarm_damage.stack<3)&!action.adaptive_swarm_damage.in_flight&!action.adaptive_swarm.in_flight)&target.time_to_die>5,if=!(variable.need_bt&active_bt_triggers=2)&(!talent.unbridled_swarm.enabled|spell_targets.swipe_cat=1)
        -- !(variable.need_bt&active_bt_triggers=2)&(!talent.unbridled_swarm.enabled|spell_targets.swipe_cat=1)
        if talent.adaptiveSwarm and not (utility.bt.need and utility.bt.triggers == 2) and (not talent.unbridledSwarm or var.swipeTargets == 1) then
            for i = 1, #var.enemies.yards5f do
                local thisUnit = var.enemies.yards5f[i]
                if ((not debuff.adaptiveSwarmDamage.exists(thisUnit) or debuff.adaptiveSwarmDamage.remain(thisUnit) < 2) and (debuff.adaptiveSwarmDamage.stack(thisUnit) < 3) and not cast.inFlight.adaptiveSwarmDamage(thisUnit) and not cast.inFlight.adaptiveSwarm(thisUnit)) and unit.ttd(thisUnit) > 5 then
                    if cast.adaptiveSwarm(thisUnit) then
                        ui.debug("Casting Adaptive Swarm [def] - 11" .. (from and " from " .. from or ""))
                        return true
                    end
                end
            end
        end

        -- 12 adaptive_swarm,target_if=max:((1+dot.adaptive_swarm_damage.stack)*dot.adaptive_swarm_damage.stack<3*time_to_die),if=dot.adaptive_swarm_damage.stack<3&talent.unbridled_swarm.enabled&spell_targets.swipe_cat>1&!(variable.need_bt&active_bt_triggers=2
        if talent.adaptiveSwarm and debuff.adaptiveSwarmDamage.stack() < 3 and talent.unbridledSwarm and var.swipeTargets > 1 and not (utility.bt.need and utility.bt.triggers == 2) then
            for i = 1, #var.enemies.yards5f do
                local thisUnit = var.enemies.yards5f[i]
                if ((1 + debuff.adaptiveSwarmDamage.stack(thisUnit)) * debuff.adaptiveSwarmDamage.stack(thisUnit) < 3 * unit.ttd(thisUnit)) then
                    if cast.adaptiveSwarm(thisUnit) then
                        ui.debug("Casting Adaptive Swarm [def] - 12" .. (from and " from " .. from or ""))
                        return true
                    end
                end
            end
        end
        -- 13 call_action_list,name=cooldown
        if br.rotations.support.UMFeralACLCooldown.cooldown('def - 13') then return true end
        -- 14 feral_frenzy,target_if=max:target.time_to_die,if=((talent.dire_fixation.enabled&debuff.dire_fixation.up)|!talent.dire_fixation.enabled|spell_targets.swipe_cat>1)&(combo_points<2|combo_points<3&buff.bs_inc.up|time<10)
        if cast.able.feralFrenzy(var.maxTTDUnit) and ((talent.direFixation and debuff.direFixation.exists(var.maxTTDUnit)) or not talent.direFixation or var.swipeTargets > 1) and (var.stats.comboPoints < 2 or (var.stats.comboPoints < 3 and var.bsIncUp))
        then
            if cast.feralFrenzy(var.maxTTDUnit) then
                ui.debug("Casting Feral Frenzy [def] - 14" .. (from and " from " .. from or ""))
                return true
            end
        end

        -- 15 ferocious_bite,target_if=max:target.time_to_die,if=buff.apex_predators_craving.up&(spell_targets.swipe_cat=1|!talent.primal_wrath.enabled|!buff.sabertooth.up)&!(variable.need_bt&active_bt_triggers=2)
        if cast.able.ferociousBite(var.maxTTDUnit) and buff.apexPredatorsCraving.exists() and ((var.swipeTargets == 1 or not talent.primalWrath or not buff.sabertooth.exists()) and not (utility.bt.need and utility.bt.triggers == 2)) then
            if cast.ferociousBite(var.maxTTDUnit) then
                ui.debug("Casting Ferocious Bite [def] - 15" .. (from and " from " .. from or ""))
                return true
            end
        end

        -- 16 call_action_list,name=berserk,if=buff.bs_inc.up
        if var.bsIncUp then
            --ui.debug("Calling Action List [berserk] from [def] - 16")
            if br.rotations.support.UMFeralACLBerserk.berserk('def - 16') then return true end
        end
        -- 17 wait,sec=combo_points=5,if=combo_points=4&buff.predator_revealed.react&energy.deficit>40&spell_targets.swipe_cat=1
        if (var.stats.comboPoints == 4 and buff.predatorRevealed.react() and var.energyDeficit > 40 and var.swipeTargets == 1 and power.comboPoints.ttm() < br.player.gcdMax) then
            if cast.pool.ferociousBite() then
                ui.debug("Pooling for 5 CP [def] - 17" .. (from and " from " .. from or ""))
                return true
            end
        end
        -- 18 call_action_list,name=finisher,if=combo_points>=4&!(combo_points=4&buff.bloodtalons.stack<=1&active_bt_triggers=2&spell_targets.swipe_cat=1)
        if (var.stats.comboPoints == 4 or var.stats.comboPoints == 5) and not (buff.bloodtalons.stack() <= 1 and utility.bt.triggers == 2 and var.swipeTargets == 1) then
            --ui.debug("Calling Action List [finisher] from [def] - 18")
            if br.rotations.support.UMFeralACLFinisher.finisher('def - 18') then return true end
        end
        -- 19 call_action_list,name=bloodtalons,if=variable.need_bt&!buff.bs_inc.up&combo_points<5
        if utility.bt.need and not var.bsIncUp and var.stats.comboPoints < 5 then
            --ui.debug("Calling Action List [bloodtalons] from [def] - 19")
            if br.rotations.support.UMFeralACLBloodtalons.bloodtalons('def - 19') then return true end
        end
        -- 20 call_action_list,name=aoe_builder,if=spell_targets.swipe_cat>1&talent.primal_wrath.enabled
        if var.swipeTargets > 1 and talent.primalWrath then
            --ui.debug("Calling Action List [aoe_builder] from [def] - 20")
            if br.rotations.support.UMFeralACLAoEBuilder.aoe_builder() then return true end
        end
        -- 21 call_action_list,name=builder,if=!buff.bs_inc.up&combo_points<5
        if not var.bsIncUp and var.stats.comboPoints < 5 then
            --ui.debug("Calling Action List [builder] from [def] - 21")
            if br.rotations.support.UMFeralACLBuilder.builder() then return true end
        end
        ----ui.debug("Exiting Action List [def]")
        return false
        -- 22 regrowth,if=energy<25&buff.predatory_swiftness.up&!buff.clearcasting.up&variable.regrowth
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
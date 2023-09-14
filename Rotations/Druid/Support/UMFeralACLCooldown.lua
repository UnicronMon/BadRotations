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

---@class UMFeralACLCooldown
br.rotations.support.UMFeralACLCooldown = {
    ---@param from? string
    cooldown = function(from)
        if ui.useCDs() then
            if module.Potion() then
                ui.debug("Using Potion [cooldown] - 0" .. (from and " from " .. from or ""))
            end
        end
        -- 3 incarnation,target_if=max:target.time_to_die,if=(target.time_to_die<fight_remains&target.time_to_die>25)|target.time_to_die=fight_remains
        if (talent.incarnationAvatarOfAshamane and cast.able.incarnationAvatarOfAshamane()) and unit.exists(var.units.dyn5) and unit.distance(var.units.dyn5) < 5 and uiOpt.berserkIncarnation() and ui.useCDs() then
            if cast.incarnationAvatarOfAshamane() then
                ui.debug("Casting Incarnation Avatar Of Ashamane [cooldown] - 3" .. (from and " from " .. from or ""))
                return true
            end
        end
        -- 4 berserk,target_if=max:target.time_to_die,if=((target.time_to_die<fight_remains&target.time_to_die>18)|target.time_to_die=fight_remains)&((!variable.lastZerk)|(fight_remains<23)|(variable.lastZerk&!variable.lastConvoke)|(variable.lastConvoke&cooldown.convoke_the_spirits.remains<10))
        if (not talent.incarnationAvatarOfAshamane and (talent.berserk and cast.able.berserk())) and unit.exists(var.units.dyn5) and unit.distance(var.units.dyn5) < 5 and uiOpt.berserkIncarnation() and ui.useCDs() then
            if cast.berserk() then
                ui.debug("Casting Berserk [cooldown] - 4" .. (from and " from " .. from or ""))
                return true
            end
        end
        -- 5 berserking,if=!variable.align_3minutes|buff.bs_inc.up
        if ui.checked("Racial") and race == "Troll" and cast.able.racial() and ui.useCDs() and var.bsIncUp then
            if cast.racial() then
                ui.debug("Casting Berserking [cooldown] - 5" .. (from and " from " .. from or ""))
                return true
            end
        end
        -- 8 convoke_the_spirits,target_if=max:target.time_to_die,if=((target.time_to_die<fight_remains&target.time_to_die>5-talent.ashamanes_guidance.enabled)|target.time_to_die=fight_remains)&(fight_remains<5|(dot.rip.remains>5&buff.tigers_fury.up&(combo_points<2|(buff.bs_inc.up&combo_points<=3))))&(!variable.lastConvoke|buff.potion.up|(time+fight_remains+10)%%300>time%%300)&(talent.dire_fixation.enabled&debuff.dire_fixation.up|!talent.dire_fixation.enabled|spell_targets.swipe_cat>1)
        if uiOpt.convokeTheSpirits()
            and (talent.convokeTheSpiritsFeral and cast.able.convokeTheSpiritsFeral())
            and (
                (buff.tigersFury.exists() and var.stats.comboPoints < 2 and var.bsIncRemain > 20)
                or (unit.ttdGroup(5) < 5 and ui.useCDs() and not unit.isDummy(var.units.dyn5))
            ) then
            if cast.convokeTheSpiritsFeral() then
                ui.debug("Casting Convoke the Spirits [Cooldowns] - 8" .. (from and " from " .. from or ""))
                return true
            end
        end
        module.BasicTrinkets()
        --ui.debug("Exiting Action List [cooldown]")
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
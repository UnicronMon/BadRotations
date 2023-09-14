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

---@class UMFeralACLBuilder
br.rotations.support.UMFeralACLBuilder = {
    ---@param from? string
    builder = function(from)
        -- run_action_list,name=clearcasting,if=buff.clearcasting.react
        if buff.clearcasting.react() then
            --ui.debug("Calling Action List [clearcasting] from [builder] - 1")
            if br.rotations.support.UMFeralACLClearcasting.clearcasting('builder') then
                return true
            end
        end
        -- brutal_slash,if=cooldown.brutal_slash.full_recharge_time<4
        if talent.brutalSlash and cast.able.brutalSlash() and charges.brutalSlash.timeTillFull() < 4 then
            if cast.brutalSlash() then
                ui.debug("Casting Brutal Slash [builder] - 2" .. (from and " from " .. from or ""))
                return true
            end
        end
    
        -- rake,if=refreshable|(buff.sudden_ambush.up&persistent_multiplier>dot.rake.pmultiplier)
        if cast.able.rake(var.maxRakeTicksGainUnit) and buff.suddenAmbush.exists() and utility.persistentMultiplier('rake') > debuff.rake.pmultiplier(var.maxRakeTicksGainUnit) then
            if cast.rake(var.maxRakeTicksGainUnit) then
                ui.debug("Casting Rake [builder] - 5" .. (from and " from " .. from or ""))
                return true
            end
        end
        -- moonfire_cat,target_if=refreshable
        if talent.lunarInspiration and cast.able.moonfireCat() and debuff.moonfireCat.refresh() then
            if cast.moonfireCat() then
                ui.debug("Casting Moonfire [builder] - 7" .. (from and " from " .. from or ""))
                return true
            end
        end
    
        -- thrash_cat,target_if=refreshable&!talent.thrashing_claws.enabled
        if cast.able.thrashCat(var.thrashCatTicksGainUnit) and debuff.thrashCat.refresh(var.units.dyn8AOE) and not talent.thrashingClaws then
            if cast.thrashCat(var.thrashCatTicksGainUnit) then
                ui.debug("Casting Thrash [builder] - 8" .. (from and " from " .. from or ""))
                return true
            end
        end
    
        -- brutal_slash
        if talent.brutalSlash and cast.able.brutalSlash() then
            if cast.brutalSlash() then
                ui.debug("Casting Brutal Slash [builder] - 9" .. (from and " from " .. from or ""))
                return true
            end
        end
    
        -- swipe_cat,if=spell_targets.swipe_cat>1|(talent.wild_slashes.enabled&(debuff.dire_fixation.up|!talent.dire_fixation.enabled))
        if not talent.brutalSlash and cast.able.swipeCat() and (var.swipeTargets > 1 or (talent.wildSlashes and (debuff.direFixation.exists(var.maxTTDUnit) or not talent.direFixation))) then
            if cast.swipeCat() then
                ui.debug("Casting Swipe [builder] - 10" .. (from and " from " .. from or ""))
                return true
            end
        end
    
        -- shred
        if cast.able.shred(var.maxTTDUnit) then
            if cast.shred(var.maxTTDUnit) then
                ui.debug("Casting Shred [builder] - 11" .. (from and " from " .. from or ""))
                return true
            end
        end
        --ui.debug("Exiting Action List [builder]")
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
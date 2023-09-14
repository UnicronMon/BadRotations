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

---@class UMFeralACLDefensives
br.rotations.support.UMFeralACLDefensives = {
    defensives = function(from)
        if ui.useDefensive() and not unit.mounted() and not (buff.prowl.exists() or buff.shadowmeld.exists()) and not buff.flightForm.exists() and not buff.prowl.exists() then
            if uiOpt.useRebirth() and unit.inCombat() then
                local rebirthTarget = uiOpt.useRebirthTarget()
                
                if cast.able.rebirth(rebirthTarget, "dead") and unit.deadOrGhost(rebirthTarget) and (unit.friend(rebirthTarget) or unit.player(rebirthTarget)) then
                    if cast.rebirth(thisUnit, "dead") then
                        ui.debug("Casting Rebirth on " .. unit.name(rebirthTarget) .. " [defensives] - 1")
                        return true
                    end
                end
            end
    
            if uiOpt.useRevive() and not unit.inCombat() then
                local reviveTarget = uiOpt.useReviveTarget()
                if cast.able.rebirth(reviveTarget, "dead") and unit.deadOrGhost(reviveTarget) and (unit.friend(reviveTarget) or unit.player(reviveTarget)) then
                    if cast.rebirth(thisUnit, "dead") then
                        ui.debug("Casting Revive on " .. unit.name(reviveTarget) .. " [defensives] - 2")
                        return true
                    end
                end
            end
    
            if uiOpt.useRemoveCorruption() then
                local useRemoveCorruptionTarget = uiOpt.useRemoveCorruptionTarget()
                if cast.able.removeCorruption() and (unit.friend(useRemoveCorruptionTarget) or unit.player(useRemoveCorruptionTarget)) and cast.dispel.removeCorruption(useRemoveCorruptionTarget) then
                    if cast.removeCorruption(useRemoveCorruptionTarget) then
                        ui.debug("Casting Remove Corruption on " ..
                        unit.name(useRemoveCorruptionTarget) .. " [defensives] - 3")
                        return true
                    end
                end
            end
    
            if uiOpt.useSoothe() and cast.able.soothe() then
                for i = 1, #var.enemies.yards40 do
                    local thisUnit = var.enemies.yards40[i]
                    if cast.dispel.soothe(thisUnit) then
                        if cast.soothe(thisUnit) then
                            ui.debug("Casting Soothe on " .. unit.name(thisUnit) .. " [defensives] - 4")
                            return true
                        end
                    end
                end
            end
    
            if uiOpt.useRenewal() and unit.inCombat() and cast.able.renewal() and unit.hp() <= uiOpt.useRenewalValue() then
                if cast.renewal() then
                    ui.debug("Casting Renewal - [defensives] - 5")
                    return true
                end
            end
    
            -- PowerShift - Breaks Crowd Control (R.I.P Powershifting)
            if uiOpt.breakCC() and cast.able.catForm() then
                if not cast.noControl.catForm() and var.lastForm ~= 0 then
                    cast.form(var.lastForm)
                    var.lastForm = 0
                    -- if currentForm == var.lastForm or currentForm == 0 then
                    --     var.lastForm = 0
                    -- end
                elseif cast.noControl.catForm() then
                    if unit.form() == 0 then
                        cast.catForm("player")
                        ui.debug("Casting Cat Form [Breaking CC] - [defensives] - 6")
                    else
                        for i = 1, unit.formCount() do
                            if i == unit.form() then
                                var.lastForm = i
                                cast.form(i)
                                ui.debug("Casting Last Form [Breaking CC] - [defensives] - 6")
                                return true
                            end
                        end
                    end
                end
            end
    
            module.BasicHealing()
            -- Regrowth
            if uiOpt.useRegrowth() and cast.able.regrowth("player") and not (unit.mounted() or unit.flying()) and not cast.current.regrowth() then
                local thisHP = unit.hp()
                local thisUnit = "player"
                local lowestUnit = unit.lowest(40)
                local fhp = unit.hp(lowestUnit)
                if uiOpt.useAutoHeal() and unit.distance(lowestUnit) < 40 then
                    thisHP = fhp;
                    thisUnit = lowestUnit
                else
                    thisUnit = "player"
                end
                if not unit.inCombat() and thisHP <= uiOpt.useRegrowthValue() and (not unit.moving() or buff.predatorySwiftness.exists()) then
                    -- Break Form
                    if uiOpt.useRegrowthOoC() and unit.form() ~= 0 and not buff.predatorySwiftness.exists() and unit.isUnit(thisUnit, "player") then
                        unit.cancelForm()
                        ui.debug("Cancel Form [Regrowth - OoC Break]")
                    end
                    -- Lowest Party/Raid or Player
                    if unit.form() == 0 or buff.predatorySwiftness.exists() then
                        if cast.regrowth(thisUnit) then
                            ui.debug("Casting Regrowth [OoC] on " .. unit.name(thisUnit))
                            return true
                        end
                    end
                elseif unit.inCombat() and (buff.predatorySwiftness.exists() or unit.level() < 49) then
                    -- Always Use Predatory Swiftness when available
                    if uiOpt.useRegrowthInC() == 1 or not talent.bloodtalons then
                        -- Lowest Party/Raid or Player
                        if (thisHP <= uiOpt.useRegrowthValue() and unit.level() >= 49) or (unit.level() < 49 and thisHP <= uiOpt.useRegrowthValue() / 2) then
                            if unit.form() ~= 0 and not buff.predatorySwiftness.exists() and unit.isUnit(thisUnit, "player") then
                                unit.cancelForm()
                                ui.debug("Cancel Form [Regrowth - InC Break]")
                            elseif unit.form() == 0 or buff.predatorySwiftness.exists() then
                                if cast.regrowth(thisUnit) then
                                    ui.debug("Casting Regrowth [IC Instant] on " .. unit.name(thisUnit))
                                    return true
                                end
                            end
                        end
                    end
                end
            end
    
            -- Barkskin
            if uiOpt.useBarkskin() and unit.inCombat() and cast.able.barkskin() and unit.hp() <= uiOpt.useBarkskinValue() then
                if cast.barkskin() then
                    ui.debug("Casting Barkskin - [defensives]")
                    return true
                end
            end
            -- Survival Instincts
            if uiOpt.useSurvivalInstincts() and unit.inCombat() and cast.able.survivalInstincts() and unit.hp() <= uiOpt.useSurvivalInstinctsValue() and not buff.survivalInstincts.exists() and charges.survivalInstincts.count() > 0 then
                if cast.survivalInstincts() then
                    ui.debug("Casting Survival Instincts - [defensives]")
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
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

---@class UMFeralACLUtility
br.rotations.support.UMFeralACLUtility = {
    utility = function(from)
        if uiOpt.autoShapeshifts() then
            if cast.able.travelForm("player") and not unit.inCombat() and br.canFly() and not unit.swimming() and br.fallDist > 90 then
                if cast.travelForm("player") then
                    ui.debug("Casting Travel Form (Flying) - [utility] - 2")
                    return true
                end
            end

            if cast.able.travelForm("player") and not unit.inCombat() and unit.swimming() and not buff.travelForm.exists() and not buff.prowl.exists() and unit.moving() then
                if cast.travelForm("player") then
                    ui.debug("Casting Travel From (Swimming)  - [utility] - 3")
                    return true
                end
            end

            if cast.able.catForm("player") and not buff.catForm.exists() and not unit.mounted() and not unit.flying() then
                -- Cat Form when not swimming or flying or stag and not in combat
                if unit.moving() and not unit.swimming() and not unit.flying() and not buff.travelForm.exists() and not buff.soulshape.exists() then
                    if cast.catForm("player") then
                        ui.debug("Casting Cat Form [No Swim / Travel / Combat] - [utility] - 4")
                        return true
                    end
                end
                -- Cat Form when not in combat and target selected and within 20yrds
                if not unit.inCombat() and unit.valid("target") and ((unit.distance("target") < 30 and not unit.swimming()) or (unit.distance("target") < 10 and unit.swimming())) then
                    if cast.catForm("player") then
                        ui.debug("Casting Cat Form [Target In 20yrds] - [utility] - 4")
                        return true
                    end
                end
                -- Cat Form - Less Fall Damage
                if (not br.canFly() or unit.inCombat() or unit.level() < 24 or not unit.outdoors()) and (not unit.swimming() or (not unit.moving() and unit.swimming() and #enemies.yards5f > 0)) and br.fallDist > 90 --falling > ui.value("Fall Timer")
                then
                    if cast.catForm("player") then
                        ui.debug("Casting Cat Form [Reduce Fall Damage] - [utility] - 4")
                        return true
                    end
                end
            end
        end

        if uiOpt.useMarkOfTheWild() and not utility.isStealthed() and not unit.inCombat() and not (unit.flying() or unit.mounted()) then
            local thisUnit = utility.getMarkUnit(uiOpt.markOfTheWildUnit())
            if cast.timeSinceLast.markOfTheWild() > 35 and cast.able.markOfTheWild(thisUnit) and buff.markOfTheWild.refresh(thisUnit) and unit.distance(thisUnit) < 40 then
                if cast.markOfTheWild(var.markUnit) then
                    ui.debug("Casting Mark of the Wild - [utility] - 1")
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

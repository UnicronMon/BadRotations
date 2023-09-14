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

local btSpells = {
    ["brutalSlash"] = true,
    ["moonfireCat"] = true,
    ["rake"] = true,
    ["shred"] = true,
    ["swipeCat"] = true,
    ["thrashCat"] = true,
}

local tf_spells = { rake = true, rip = true, thrashCat = true, moonfireCat = true, primalWrath = true }
local bt_spells = { rip = true, primalWrath = true }
local mc_spells = { thrashCat = true }
local pr_spells = { rake = true }
local bs_spells = { rake = true }

local loaded = false

---@class UMFeralUtility
br.rotations.support.UMFeralUtility = {
    autoProwl = function()
        if not buff.prowl.exists() then
            if #var.enemies.yards20nc > 0 then
                for i = 1, #var.enemies.yards20nc do
                    local thisUnit = var.enemies.yards20nc[i]
                    local threatRange = math.max((20 + (unit.level(thisUnit) - unit.level())), 5)
                    local react = unit.reaction(thisUnit) or 10
                    if unit.distance(thisUnit) < threatRange and react <= 4 and unit.canAttack(thisUnit) then
                        return true
                    end
                end
            end
        end
        return false
    end,

    ---@type { need: boolean, stacks: number, triggers: number, [btSpells]: boolean }
    bt = setmetatable({}, {
        __index = function(t, k)
            if btSpells[k] and cast[k] then
                local timeSinceLast = cast.timeSinceLast[k]();
                local lastCastTime = var.getTime - timeSinceLast;
                local btBuff = buff.bloodtalons
                local btExists = btBuff.exists();
                local lastBtProc = btExists and (var.getTime - (btBuff.duration() - btBuff.remain())) or 0;
                local lastCastAfterLastBt = lastCastTime > lastBtProc;
                return lastCastAfterLastBt and timeSinceLast > 0 and timeSinceLast < 4
            end
            if k == 'triggers' then
                local tCnt = 0
                for _, v in pairs(btSpells) do
                    tCnt = tCnt + (t[v] and 1 or 0)
                end
                return tCnt
            end
            if k == 'stacks' then
                return buff.bloodtalons.stack()
            end
            if k == 'need' then
                return talent.bloodtalons and buff.bloodtalons.stack() <= 1
            end
        end
    }),

    canCastStealth = function()
        return cast.able.prowl("player") == true or cast.able.incarnProwl("player") == true
    end,

    ---@return boolean
    shouldStealth = function()
        return not support.UMFeralUtility.isStealthed() and support.UMFeralUtility.canCastStealth()
    end,

    effectiveStealth = function()
        return support.UMFeralUtility.isStealthed() or buff.suddenAmbush.exists()
    end,

    ---@param x number
    ---@return number
    modCircleDot = function(x)
        return x * (br.player.talent.circleOfLifeAndDeath and 0.8 or 1)
    end,

    isStealthed = function()
        return buff.prowl.exists() == true or buff.incarnationProwl.exists() == true or buff.shadowmeld.exists() == true
    end,

    getChargeInfo = function(chargeSpell)
        local rtn = {
            current = 0,
            max = 0,
            next = 0,
            duration = 0,
            modRate = 0,
        }
        if chargeSpell and chargeSpell.count then
            local current, max, nxt, duration, modRate = chargeSpell.count()
            rtn.current = current
            rtn.max = max
            rtn.next = nxt
            rtn.duration = duration
            rtn.modRate = modRate
        end
        return rtn
    end,

    ---@param option 1 | 2 | 3 | 4 | 5
    ---@return string
    getMarkUnit = function(option)
        if option == 1 then
            return "target"
        end
        if option == 2 then
            return "mouseover"
        end
        if option == 3 then
            return "player"
        end
        if option == 4 then
            return "focus"
        end
        if option == 5 then
            if #br.friend > 1 then
                for i = 1, #br.friend do
                    local nextUnit = br.friend[i].unit
                    if buff.markOfTheWild.refresh(nextUnit) and unit.distance(nextUnit) < 40 then
                        return nextUnit
                    end
                end
            end
        end
        return "player"
    end,

    ---@param act 'rake' | 'rip' | 'thrashCat' | 'moonfireCat' | 'primalWrath'
    persistentMultiplier = function( act )
        local mult = 1

        if not act then return mult end
        if tf_spells[ act ] and buff.tigersFury.exists() then mult = mult * var.multipliers.tigersFury() end
        if bt_spells[ act ] and buff.bloodtalons.exists() then mult = mult * var.multipliers.bloodtalons() end
        if mc_spells[ act ] and talent.momentOfClarity and buff.clearcasting.exists() then mult = mult * var.multipliers.clearcasting() end
        if pr_spells[ act ] and utility.effectiveStealth() then mult = mult * var.multipliers.prowlBase() end
        if bs_spells[ act ] and talent.berserk and var.bsIncUp then mult = mult * var.multipliers.berserk() end

        return mult
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
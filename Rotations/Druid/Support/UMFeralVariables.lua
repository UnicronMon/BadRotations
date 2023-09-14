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

local utility = br.rotations.support.UMFeralUtility

local loaded =  false

---@class UMFeralVariables
br.rotations.support.UMFeralVariables = {
    var = {
        ---@class TicksGain : { [DotSpellNames] : number }
        ticksGain = {
            rake = 5,      -- 5
            rip = 12,       -- 12
            thrashCat = 5, -- 5
            primalWrath = 0,
            moonfireCat = 0
        },
        bsIncRemain          = 0,
        bsIncUp              = false,
        fbMaxEnergy          = false,
        friendsInRange       = false,
        energy               = 0,
        energyDeficit        = 0,
        multidot             = false,
        getTime              = br._G.GetTime(),
        htTimer              = br._G.GetTime(),
        lastForm             = 0,
        lastRune             = br._G.GetTime(),
        leftCombat           = br._G.GetTime(),
        localsUpdated        = false,
        lootDelay            = 0,
        minCount             = 3,
        swipeTargets         = 0,
        fbMaxEnergyAmt       = 0,
        noDoT                = false,
        profileStop          = false,
        unit5ID              = 0,
        astralInfluenceRange = 0,
        isEatingOrDrinking   = false,
        astralInfluence      = 0,
        stats                = {
            comboPoints = 0,
            energy = 0,
            energyDeficit = 0,
            attackPower = 0,
            crit = 0,
            haste = 0,
            mastery_value = 0,
            melee_haste = 0,
            spell_haste = 0,
            versatility_atk_mod = 0,
        },
        multipliers          = {
            tigersFury = function()
                return 1.15 + (talent.rank.carnivorousInstinct * 0.06)
            end,
            bloodtalons = function()
                return 1.3
            end,
            clearcasting = function()
                return talent.momentOfClarity and 1.15 or 1
            end,
            berserk = function()
                return 1.5
            end,
            prowlBase = function() return talent.pouncingStrikes and 1.6 or 1 end
        },
        persistentMultiplier = 1,
        enemies = {},
        range = {},
        dotSpells = {
            moonfireCat = {
                id = 155625,
                duration = function() return utility.modCircleDot(16) * br.rotations.support.UMFeralVariables.var.stats.haste end,
                tick_time = function() return utility.modCircleDot(2) * br.rotations.support.UMFeralVariables.var.stats.haste end,
                max_stack = 1,
                remains = function(u)
                    return debuff.moonfireCat.remain(u)
                end
            },
            primalWrath = {
                id = 285381,
                duration = function() return (talent.veinripper and 1.25 or 1) * utility.modCircleDot(2 + 2 * br.rotations.support.UMFeralVariables.var.stats.comboPoints) *
                    br.rotations.support.UMFeralVariables.var.stats.haste end,
                tick_time = function() return utility.modCircleDot(2) * br.rotations.support.UMFeralVariables.var.stats.haste end,
                remains = function(u)
                    return debuff.rip.remain(u)
                end
            },
            rake = {
                id = 155722,
                tick_time = function()
                    return utility.modCircleDot(3) * br.rotations.support.UMFeralVariables.var.stats.haste
                end,
                duration = function()
                    return utility.modCircleDot((talent.veinripper and 1.25 or 1) * 15) * br.rotations.support.UMFeralVariables.var.stats.haste
                end,
                remains = function(u)
                    return debuff.rake.remain(u)
                end
            },
            rip = {
                id = 1079,
                tick_time = function()
                    return utility.modCircleDot(2) *  br.rotations.support.UMFeralVariables.var.stats.haste
                end,
                duration = function()
                    return utility.modCircleDot((talent.veinripper and 1.25 or 1) * (4 + (br.rotations.support.UMFeralVariables.var.stats.comboPoints * 4)))
                end,
                remains = function(u)
                    return debuff.rip.remain(u)
                end
            },
            thrashCat = {
                id = 405233,
                duration = function() return utility.modCircleDot((talent.veinripper and 1.25 or 1) * 15) *  br.rotations.support.UMFeralVariables.var.stats.haste end,
                tick_time = function() return utility.modCircleDot(3) *  br.rotations.support.UMFeralVariables.var.stats.haste end,
                remains = function(u)
                    return debuff.thrashCat.remain(u)
                end
            }
        },
        ticks = {
            ---@param debuffName DotSpellNames
            ---@param thisUnit UnitId
            ---@return number
            total = function(debuffName, thisUnit)
                local db = debuff[debuffName]
                local dotSpell =  br.rotations.support.UMFeralVariables.var.dotSpells[debuffName]
                if not db.exists(thisUnit, "EXACT") then
                    return dotSpell.duration() / dotSpell.tick_time()
                else
                    return math.floor(db.duration(thisUnit, "EXACT") / dotSpell.tick_time())
                end
            end,

            ---@param debuffName DotSpellNames
            ---@param thisUnit UnitId
            ---@return number
            remain = function(debuffName, thisUnit)
                local db = debuff[debuffName]
                local dotSpell =  br.rotations.support.UMFeralVariables.var.dotSpells[debuffName]
                return math.floor(db.remain(thisUnit, "EXACT") / dotSpell.tick_time())
            end,

            ---@param debuffName DotSpellNames
            ---@param thisUnit UnitId
            ---@return number
            gain = function(debuffName, thisUnit)
                return  br.rotations.support.UMFeralVariables.var.ticks.total(debuffName, thisUnit) -  br.rotations.support.UMFeralVariables.var.ticks.remain(debuffName, thisUnit)
            end,

            ---@param debuffName DotSpellNames
            ---@param thisUnit UnitId
            ---@return number
            gainUnit = function(debuffName, thisUnit)
                return  br.rotations.support.UMFeralVariables.var.ticks.gain(debuffName, thisUnit)
            end,
        },
        units                = {},
        zerk_biteweave       = false
    },
    update = function()
        local var = br.rotations.support.UMFeralVariables.var
        if not unit.inCombat() and not unit.exists("target") then
            if var.profileStop then var.profileStop = false end
            var.leftCombat = var.getTime
        end

        var.getTime = br._G.GetTime()
        var.lootDelay = ui.checked("Auto Loot") and ui.value("Auto Loot") or 0;
        var.minCount = ui.useCDs() and 1 or 3;
        var.astralInfluence = (talent.astralInfluence and (talent.rank.astralInfluence == 2 and 3 or 1) or 0);
        var.stats = {
            comboPoints = power.comboPoints.amount(),
            energy = power.energy.amount(),
            energyDeficit = power.energy.deficit(),
            attackPower = UnitAttackPower("player") + UnitWeaponAttackPower("player"),
            crit = max(GetCritChance(), GetSpellCritChance("player"), GetRangedCritChance()),
            haste = UnitSpellHaste("player") / 100 or GetMeleeHaste() / 100,
            mastery_value = GetMasteryEffect() / 100,
            melee_haste = GetMeleeHaste() / 100,
            spell_haste = UnitSpellHaste("player") / 100,
            versatility_atk_mod = GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_DONE) / 100,
        }

        local ai40          = 40 + var.astralInfluence
        enemies.get(ai40) -- makes enemies.yards40
        var.enemies.yards40 = enemies["yards" .. ai40]

        local ai20 = 20 + var.astralInfluence
        enemies.get(ai20, "player", true) -- makes enemies.yards20nc
        var.enemies.yards20nc = enemies["yards" .. ai20 .. "nc"]

        local ai8 = 8 + var.astralInfluence
        enemies.get(ai8) -- makes enemies.yards8
        var.enemies.yards8 = enemies["yards" .. ai8]
        var.enemies.swipeTargets = enemies["yards" .. ai8]

        local ai5 = 5 + var.astralInfluence
        enemies.get(ai5, "player", false, true)
        var.enemies.yards5f = enemies["yards" .. ai5 .. "f"] -- makes enemies.yards5f

        enemies.get(ai5, "player")
        var.enemies.yards5 = enemies["yards" .. ai5]

        local ai13 = 13 + var.astralInfluence
        enemies.get(ai13, "player", false, true)
        var.enemies.yards13f = enemies["yards" .. ai13 .. "f"] -- makes enemies.yards13f

        --[[
            enemies.get(40)                        -- makes enemies.yards40
            enemies.get(20, "player", true)        -- makes enemies.yards20nc
            enemies.get(13, "player", false, true) -- makes enemies.yards13f
            enemies.get(8, "player", false, true)  -- makes enemies.yards8f
            enemies.get(8, "target")               -- makes enemies.yards8t
            enemies.get(5, "player", false, true)  -- makes enemies.yards5f
        ]]

        units.get(ai40)
        units.get(ai8, true)
        units.get(ai5)

        var.units.dyn40 = units["dyn" .. ai40]
        var.units.dyn8AOE = units["dyn" .. ai8 .. "AOE"]
        var.units.dyn5 = units["dyn" .. ai5]

        var.range.dyn40 = unit.exists(var.units.dyn40) and unit.distance(var.units.dyn40) < ai40
        var.range.dyn8AOE = unit.distance(var.units.dyn8AOE) < ai8
        var.range.dyn5 = unit.exists(var.units.dyn5) and unit.distance(var.units.dyn5) < ai5
        
        var.unit5ID = br.GetObjectID(var.units.dyn5) or 0

        var.noDoT = var.unit5ID == 153758 or var.unit5ID == 156857 or var.unit5ID == 156849 or var.unit5ID == 156865 or
        var.unit5ID == 156869
    
        var.bsIncRemain = buff.berserk.exists() and buff.berserk.remain() or buff.incarnationAvatarOfAshamane.exists() and buff.incarnationAvatarOfAshamane.remain() or 0
    
        var.bsIncUp = var.bsIncRemain > 0

        var.solo = #br.friend < 2
        var.friendsInRange = false
        if not var.solo then
            for i = 1, #br.friend do
                if unit.distance(br.friend[i].unit) < 15 then
                    var.friendsInRange = true
                    break
                end
            end
        end
        var.fbMaxEnergyAmt = 50 * ((buff.incarnationAvatarOfAshamane.exists() and 0.8 or 1) * (talent.relentlessPredator and 0.8 or 1))
        var.fbMaxEnergy = var.energy >= 50 * ((buff.incarnationAvatarOfAshamane.exists() and 0.8 or 1) * (talent.relentlessPredator and 0.8 or 1))

        var.ticksGain.rake = var.ticks.gain("rake", "target") --var.rakeTicksGain(thisUnit)

        -- Rip Ticks
        var.ticksGain.rip = var.ticks.gain("rip", "target") --var.ripTicksGain(thisUnit)

        -- Thrash Ticks
        var.ticksGain.thrashCat = var.ticks.gain("thrashCat", "target") --var.thrashCatTicksGain("target")

        -- Moonfire Feral Ticks
        var.ticksGain.moonfireCat = var.ticks.gain("moonfireCat", "target") --var.moonfireCatTicksGain("target")

        -- Total Ticks Gain / Lowest TTD / Max TTD
        var.lowestTTD = 999
        var.lowestTTDUnit = var.units.dyn5
        var.maxTTD = 0
        var.maxTTDUnit = var.units.dyn5

        for i = 1, #var.enemies.yards40 do
            local thisUnit = var.enemies.yards40[i]
            local thisTTD = unit.ttd(thisUnit) or 99
            if not unit.isUnit("target", thisUnit) then
                -- Moonfire Feral Ticks to Gain
                if talent.lunarInspiration then
                    var.ticksGain.moonfireCat = var.ticksGain.moonfireCat + var.ticks.gain("moonfireCat", thisUnit)
                end
                -- 8 Yards Checks
                if unit.distance(thisUnit) < (8 + var.astralInfluence) then
                    -- Thrash Ticks to Gain
                    var.ticksGain.thrashCat = var.ticksGain.thrashCat + var.ticks.gain("thrashCat", thisUnit)                                               --var.thrashCatTicksGain(thisUnit)
                    -- Primal Wrath Ticks to Gain
                    if talent.primalWrath then
                        var.ticksGain.rip = var.ticksGain.rip +
                        var.ticks.gainUnit("rip", thisUnit)                                         --var.ripTicksGainUnit(thisUnit)
                    end
                end
                -- 5 Yards Checks
                if unit.distance(thisUnit) < (5 + var.astralInfluence) and unit.facing(thisUnit) then
                    -- Rip Ticks to Gain
                    if not talent.primalWrath then
                        var.ticksGain.rip = var.ticksGain.rip + var.ticks.gain("rip", thisUnit) --var.ripTicksGain(thisUnit)
                    end
                    -- Rake Ticks to Gain
                    var.ticksGain.rake = var.ticksGain.rake + var.ticks.gain("rake", thisUnit) --var.rakeTicksGain(thisUnit)
                end
                -- variable,name=shortest_ttd,value=target.time_to_die
                -- cycling_variable,name=shortest_ttd,op=min,value=target.time_to_die
                if thisTTD < var.lowestTTD then
                    var.lowestTTD = thisTTD
                    var.lowestTTDUnit = thisUnit
                end
                if thisTTD > var.maxTTD then
                    var.maxTTD = thisTTD
                    var.maxTTDUnit = thisUnit
                end
            end
        end

        var.maxRakeTicksGain = 0
        var.maxRakeTicksGainUnit = "target"
        var.lowestRip = 99
        var.lowestRipUnit = var.lowestTTDUnit
        for i = 1, #var.enemies.yards5f do
            local thisUnit = var.enemies.yards5f[i]
            -- Rake
            local rakeTicksGain = var.ticks.gainUnit("rake", thisUnit) --var.rakeTicksGainUnit(thisUnit)
            if rakeTicksGain > var.maxRakeTicksGain then
                var.maxRakeTicksGain = rakeTicksGain
                var.maxRakeTicksGainUnit = thisUnit
            end
            -- Rip
            if talent.sabertooth then
                local ripValue = debuff.rip.remains(thisUnit)
                if ripValue > unit.gcd(thisUnit) and ripValue < var.lowestRip then
                    var.lowestRip = ripValue
                    var.lowestRipUnit = thisUnit
                end
            end
        end

        var.maxMoonfireCatTicksGain = 0
        var.maxMoonfireCatTicksGainUnit = "target"
        for i = 1, #var.enemies.yards40 do
            local thisUnit = var.enemies.yards40[i]
            -- MoonFire Feral
            local moonfireCatTicksGain = var.ticks.gainUnit("moonfireCat", thisUnit) --var.moonfireCatTicksGainUnit(thisUnit)
            -- max:((ticks_gained_on_refresh+1)-(spell_targets.swipe_cat*2.492))
            if moonfireCatTicksGain > ((var.maxMoonfireCatTicksGain + 1) - (var.swipeTargets * 2.492)) then
                var.maxMoonfireCatTicksGain = moonfireCatTicksGain
                var.maxMoonfireCatTicksGainUnit = thisUnit
            end
        end

        var.swipeTargets = #var.enemies.swipeTargets
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

            loaded = true
        end
    end
}
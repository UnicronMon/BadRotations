-------------------------------------------------------
-- Author = CuteOne and UnicronMon
-- Patch = 10.1.7
--    Patch should be the latest patch you've updated the rotation for (i.e., 9.2.5)
-- Coverage = 100%
--    Coverage should be your estimated percent coverage for class mechanics (i.e., 100%)
-- Status = Full
--    Status should be one of: Full, Limited, Sporadic, Inactive, Unknown
-- Readiness = Development
--    Readiness should be one of: Raid, NoRaid, Basic, Development, Untested
-------------------------------------------------------
-- Required: Fill above fields to populate README.md --
-------------------------------------------------------

local rotationName = "CuteOne"

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    local RotationModes = {
        [1] = { mode = "Auto", value = 1, overlay = "Automatic Rotation", tip =
        "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell
            .swipe },
        [2] = { mode = "Mult", value = 2, overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon =
            br.player.spell.swipe },
        [3] = { mode = "Sing", value = 3, overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon =
            br.player.spell.shred },
        [4] = { mode = "Off", value = 4, overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon =
            br.player.spell.regrowth }
    };
    br.ui:createToggle(RotationModes, "Rotation", 1, 0)
    -- Cooldown Button
    local CooldownModes = {
        [1] = { mode = "Auto", value = 1, overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon =
            br.player.spell.berserk },
        [2] = { mode = "On", value = 1, overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon =
            br.player.spell.berserk },
        [3] = { mode = "Off", value = 3, overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon =
            br.player.spell.berserk }
    };
    br.ui:createToggle(CooldownModes, "Cooldown", 2, 0)
    -- Defensive Button
    local DefensiveModes = {
        [1] = { mode = "On", value = 1, overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon =
            br.player.spell.barkskin },
        [2] = { mode = "Off", value = 2, overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon =
            br.player.spell.barkskin }
    };
    br.ui:createToggle(DefensiveModes, "Defensive", 3, 0)
    -- Interrupt Button
    local InterruptModes = {
        [1] = { mode = "On", value = 1, overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon =
            br.player.spell.skullBash },
        [2] = { mode = "Off", value = 2, overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon =
            br.player.spell.skullBash }
    };
    br.ui:createToggle(InterruptModes, "Interrupt", 4, 0)
    -- Cleave Button
    local CleaveModes = {
        [1] = { mode = "On", value = 1, overlay = "Cleaving Enabled", tip = "Rotation will cleave targets.", highlight = 1, icon =
            br.player.spell.rake },
        [2] = { mode = "Off", value = 2, overlay = "Cleaving Disabled", tip = "Rotation will not cleave targets", highlight = 0, icon =
            br.player.spell.rake }
    };
    br.ui:createToggle(CleaveModes, "Cleave", 5, 0)
    -- Prowl Button
    local ProwlModes = {
        [1] = { mode = "On", value = 1, overlay = "Prowl Enabled", tip = "Rotation will use Prowl", highlight = 1, icon =
            br.player.spell.prowl },
        [2] = { mode = "Off", value = 2, overlay = "Prowl Disabled", tip = "Rotation will not use Prowl", highlight = 0, icon =
            br.player.spell.prowl }
    };
    br.ui:createToggle(ProwlModes, "Prowl", 6, 0)
end

---@alias DropToggle "LeftCtrl" | "LeftShift" | "RightCtrl" | "RightShift" | "RightAlt" | "None" | "MMouse" | "Mouse4" | "Mouse5"

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable

    local function rotationOptions()
        local section
        -- General Options
        section = br.ui:createSection(br.ui.window.profile, "General")
        -- br.ui:createCheckbox(section, "Garbage")
        -- APL
        -- br.ui:createDropdownWithout(section, "APL Mode", { "|cffFFFFFFSimC" }, 1, "|cffFFFFFFSet APL Mode to use.")
        -- Death Cat
        br.ui:createCheckbox(section, "Death Cat Mode",
            "|cff15FF00Enable|cffFFFFFF/|cffD60000Disable |cffFFFFFFthis mode when running through low level content where you 1 hit kill mobs.")
        -- Fire Cat
        -- br.ui:createCheckbox(section, "Perma Fire Cat", "|cff15FF00Enable|cffFFFFFF/|cffD60000Disable |cffFFFFFFautomatic use of Fandrel's Seed Pouch or Burning Seeds.")
        -- Dummy DPS Test
        -- br.ui:createSpinner(section, "DPS Testing", 5, 5, 60, 5, "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
        -- Ferocious Bite Execute
        -- br.ui:createDropdownWithout(section, "Ferocious Bite Execute", { "|cffFFFF00Enabled Notify", "|cff00FF00Enabled", "|cffFF0000Disabled" }, 2, "Options for using Ferocious Bite when the damage from it will kill the unit.")
        -- Pre-Pull Timer
        -- br.ui:createSpinner(section, "Pre-Pull Timer", 5, 1, 10, 1, "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
        -- Berserk/Tiger's Fury Pre-Pull
        -- br.ui:createCheckbox(section, "Berserk/Tiger's Fury Pre-Pull")
        -- Travel Shapeshifts
        br.ui:createCheckbox(section, "Auto Shapeshifts",
            "|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFAuto Shapeshifting to best form for situation.|cffFFBB00.")
        -- Fall Timer
        br.ui:createSpinnerWithout(section, "Fall Timer", 2, 1, 5, 0.25,
            "|cffFFFFFFSet to desired time to wait until shifting to buff.flightForm.exists() form when falling (in secs).")
        -- Break Crowd Control
        br.ui:createCheckbox(section, "Break Crowd Control",
            "|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFAuto Shapeshifting to break crowd control.|cffFFBB00.")
        -- Wild Charge
        -- br.ui:createCheckbox(section, "Wild Charge", "|cff15FF00Enables|cffFFFFFF/|cffD60000Disables |cffFFFFFFAuto Charge usage.|cffFFBB00.")
        -- Brutal Slash Targets
        -- br.ui:createSpinnerWithout(section, "Brutal Slash Targets", 3, 1, 10, 1, "|cffFFFFFFSet to desired targets to use Brutal Slash on. Min: 1 / Max: 10 / Interval: 1")
        -- Multi-DoT Limit
        -- br.ui:createSpinnerWithout(section, "Multi-DoT Limit", 8, 2, 10, 1, "|cffFFFFFFSet to number of enemies to stop multi-dotting with Rake and Moonfire.")
        -- Primal Wrath Usage
        -- br.ui:createDropdownWithout(section, "Primal Wrath Usage", { "|cffFFFF00Always", "|cff00FF00Refresh Only" })
        -- Filler Spell
        -- br.ui:createDropdownWithout(section, "Filler Spell", { "Shred", "Rake", "Snapshot Rake", "Lunar Inspiration", "Swipe" }, 1, "|cffFFFFFFSet which spell to use as filler.")
        -- Mark of the Wild
        br.ui:createDropdown(section, "Mark of the Wild",
            { "|cffFFFF00Target", "|cffFF0000Mouseover", "|cff00FF00Player", "|cffFFFFFFFocus", "|cffFFFFFFGroup" }, 3,
            "|cffFFFFFFSet how to use Mark of the Wild")
        br.ui:checkSectionState(section)
        -- Cooldown Options
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
        -- Augment Rune
        br.ui:createCheckbox(section, "Augment Rune")
        -- Potion
        -- br.ui:createDropdownWithout(section, "Potion", { "None", "Elemental Potion of Ultimate Power R3" }, uiConstants.Potion.None, "|cffFFFFFFSet Potion to use.")
        -- FlaskUp Module
        -- br.player.module.FlaskUp("Agility", section)
        -- Racial
        br.ui:createCheckbox(section, "Racial")
        -- Adaptive Swarm
        br.ui:createDropdownWithout(section, "Adaptive Swarm",
            { "|cff00FF00Always", "|cffFFFF00Cooldowns", "|cffFF0000Never" }, 2,
            "|cffFFFFFFSet when to use Adaptive Swarm")
        -- Convoke The Spirits
        br.ui:createDropdownWithout(section, "Convoke The Spirits",
            { "|cff00FF00Always", "|cffFFFF00Cooldowns", "|cffFF0000Never" }, 2,
            "|cffFFFFFFSet when to use Convoke The Spirits")
        -- Tiger's Fury
        br.ui:createCheckbox(section, "Tiger's Fury")
        -- Berserk / Incarnation: King of the Jungle
        br.ui:createDropdownWithout(section, "Berserk/Incarnation",
            { "|cff00FF00Always", "|cffFFFF00Cooldowns", "|cffFF0000Never" }, 2,
            "|cffFFFFFFSet when to use Berserk/Incarnation")
        -- Owlweave
        -- br.ui:createDropdownWithout(section,"Owlweave",{"|cff00FF00Always","|cffFFFF00Cooldowns","|cffFF0000Never"}, 3, "|cffFFFFFFSet when to use Owlweaving.")
        -- Trinkets
        br.player.module.BasicTrinkets(nil, section)
        br.ui:checkSectionState(section)
        -- Defensive Options
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        -- Basic Healing Module
        br.player.module.BasicHealing(section)
        -- Barkskin
        br.ui:createSpinner(section, "Barkskin", 55, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        -- Rebirth
        br.ui:createCheckbox(section, "Rebirth")
        br.ui:createDropdownWithout(section, "Rebirth - Target", { "|cff00FF00Target", "|cffFF0000Mouseover" }, 1,
            "|cffFFFFFFTarget to cast on")
        -- Revive
        br.ui:createCheckbox(section, "Revive")
        br.ui:createDropdownWithout(section, "Revive - Target", { "|cff00FF00Target", "|cffFF0000Mouseover" }, 1,
            "|cffFFFFFFTarget to cast on")
        -- Remove Corruption
        br.ui:createCheckbox(section, "Remove Corruption")
        br.ui:createDropdownWithout(section, "Remove Corruption - Target",
            { "|cffFFFF00Target", "|cffFF0000Mouseover", "|cff00FF00Player" }, 1, "|cffFFFFFFTarget to cast on")
        -- Soothe
        br.ui:createCheckbox(section, "Soothe")
        -- Renewal
        br.ui:createSpinner(section, "Renewal", 75, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        -- Survival Instincts
        br.ui:createSpinner(section, "Survival Instincts", 40, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        -- Regrowth
        br.ui:createSpinner(section, "Regrowth", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        br.ui:createDropdownWithout(section, "Regrowth - OoC", { "|cff00FF00Break Form", "|cffFF0000Keep Form" }, 1,
            "|cffFFFFFFSelect if Regrowth is allowed to break shapeshift to heal out of combat.")
        br.ui:createDropdownWithout(section, "Regrowth - InC", { "|cff00FF00Immediately" }, 1,
            "|cffFFFFFFSelect if Predatory Swiftness is used when available or saved for Bloodtalons.")
        -- Rejuvenation
        -- br.ui:createSpinner(section, "Rejuvenation", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        -- Swiftmend
        -- br.ui:createSpinner(section, "Swiftmend", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        -- Wild Growth
        -- br.ui:createSpinner(section, "Wild Growth", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        -- Auto-Heal
        br.ui:createDropdownWithout(section, "Auto Heal", { "|cffFFDD11LowestHP", "|cffFFDD11Player" }, 1,
            "|cffFFFFFFSelect Target to Auto-Heal")
        br.ui:checkSectionState(section)
        -- Interrupt Options
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        -- Skull Bash
        br.ui:createCheckbox(section, "Skull Bash")
        -- Mighty Bash
        -- br.ui:createCheckbox(section, "Mighty Bash")
        -- Maim
        -- br.ui:createCheckbox(section, "Maim")
        -- Interrupt Percentage
        br.ui:createSpinnerWithout(section, "Interrupt At", 0, 0, 95, 5,
            "|cffFFFFFFCast Percent to Cast At (0 is random)")
        br.ui:checkSectionState(section)
        -- Toggle Key Options
        section = br.ui:createSection(br.ui.window.profile, "Toggle Keys")
        -- Single/Multi Toggle
        br.ui:createDropdownWithout(section, "Rotation Mode", br.dropOptions.Toggle, 4)
        -- Cooldown Key Toggle
        br.ui:createDropdownWithout(section, "Cooldown Mode", br.dropOptions.Toggle, 3)
        -- Defensive Key Toggle
        br.ui:createDropdownWithout(section, "Defensive Mode", br.dropOptions.Toggle, 6)
        -- Interrupts Key Toggle
        br.ui:createDropdownWithout(section, "Interrupt Mode", br.dropOptions.Toggle, 6)
        -- Cleave Toggle
        br.ui:createDropdownWithout(section, "Cleave Mode", br.dropOptions.Toggle, 6)
        -- Prowl Toggle
        br.ui:createDropdownWithout(section, "Prowl Mode", br.dropOptions.Toggle, 6)
        -- Pause Toggle
        br.ui:createDropdown(section, "Pause Mode", br.dropOptions.Toggle, 6)
        br.ui:checkSectionState(section)
    end
    optionTable = { {
        [1] = "Rotation Options",
        [2] = rotationOptions,
    } }
    return optionTable
end

---@alias DruidBuffs
---| "bearForm"
---| "catForm"
---| "flightForm"
---| "stagForm"
---| "travelForm"
---| "treantForm"
---| "moonkinForm"
---| "adaptiveSwarm"
---| "barkskin"
---| "burningEssence"
---| "dash"
---| "ironfur"
---| "innervate"
---| "kindredEmpowerment"
---| "kindredSpiritsBuff"
---| "kindredEmpowermentEnergize"
---| "loneSpirit"
---| "lycarasTwig"
---| "markOfTheWild"
---| "naturesVigil"
---| "prowl"
---| "rejuvenation"
---| "regrowth"
---| "shadowmeld"
---| "soulshape"
---| "stampedingRoar"
---| "stampedingRoarCat"
---| "suddenAmbush"
---| "wildGrowth"
---| "onethsPerception"
---| "adaptiveSwarmDamage"
---| "adaptiveSwarmHeal"
---| "apexPredatorsCraving"
---| "berserk"
---| "bloodtalons"
---| "clearcasting"
---| "elunesGuidance"
---| "fieryRedMaimers"
---| "franticMomentum"
---| "heartOfTheWild"
---| "incarnationAvatarOfAshamane"
---| "incarnationProwl"
---| "ironJaws"
---| "jungleStalker"
---| "kingOfTheJungle"
---| "leaderOfThePack"
---| "mattedFur"
---| "overflowingPower"
---| "predatorySwiftness"
---| "sabertooth"
---| "savageRoar"
---| "scentOfBlood"
---| "stampedingRoar"
---| "survivalInstincts"
---| "tigersFury"
---| "tigersTenacity"

---@alias SharedBuffs
---| "draconicAugmentRune"

---@alias AllBuffs DruidBuffs | SharedBuffs

---@alias DruidDebuffs
---| "adaptiveSwarm"
---| "cyclone"
---| "entanglingRoots"
---| "growl"
---| "hibernate"
---| "maim"
---| "moonfire"
---| "rake"
---| "rip"
---| "thrashBear"
---| "thrashCat"
---| "massEntanglement"
---| "sunfire"
---| "wildCharge"
---| "highWinds"
---| "direFixation"
---| "frenziedAssault"
---| "adaptiveSwarmDamage"
---| "adaptiveSwarmHeal"
---| "feralFrenzy"
---| "moonfireCat"
---| "rakeStun"
---| "mightyBash"
---| "tear"
---| "ferociousWound"

---@alias SharedDebuffs
---| "fixate"

---@alias AllDebuffs DruidDebuffs | SharedDebuffs

---@alias DruidAbilities 
---| "convokeTheSpiritsFeral"
---| "adaptiveSwarmDamage"
---| "adaptiveSwarmHeal"
---| "moonfireCat"
---| "incarnProwl"
---| "incarnationAvatarOfAshamane"
---| "berserk"
---| "feralFrenzy"
---| "primalWrath"
---| "tigersFury"
---| "barkskin"
---| "bearForm"
---| "brutalSlash"
---| "catForm"
---| "charmWoodlandCreature"
---| "cyclone"
---| "dash"
---| "dreamwalk"
---| "entanglingRoots"
---| "ferociousBite"
---| "flap"
---| "flightForm"
---| "growl"
---| "mangle"
---| "markOfTheWild"
---| "moonfire"
---| "mountForm"
---| "prowl"
---| "rebirth"
---| "regrowth"
---| "renewal"
---| "revive"
---| "rip"
---| "removeCorruption"
---| "skullBash"
---| "shred"
---| "sunfire"
---| "swipe"
---| "swipeBear"
---| "swipeCat"
---| "survivalInstincts"
---| "teleportMoonglade"
---| "thorns"
---| "thrashBear"
---| "thrashCat"
---| "trackBeasts"
---| "trackHumanoids"
---| "travelForm"
---| "wrath"
---| "soothe"
---| "rake"

---@alias SharedAbilities
---| "shadowmeld"

---@alias AllAbilities DruidAbilities | SharedAbilities

---@alias DruidDispel
---| "removeCorruption"
---| "soothe"

---@alias DruidTalents
---| "tigersFury"
---| "omenOfClarity"
---| "direFixation"
---| "primalWrath"
---| "mercilessClaws"
---| "thrashingClaws"
---| "predator"
---| "tearOpenWounds"
---| "doubleClawedRake"
---| "protectiveGrowth"
---| "sabertooth"
---| "tirelessEnergy"
---| "pouncingStrikes"
---| "suddenAmbush"
---| "rampantFerocity"
---| "survivalInstincts"
---| "infectedWounds"
---| "tasteForBlood"
---| "lunarInspiration"
---| "predatorySwiftness"
---| "berserk"
---| "dreadfulBleeding"
---| "relentlessPredator"
---| "ragingFury"
---| "tigersTenacity"
---| "berserkHeartOfTheLion"
---| "momentOfClarity"
---| "berserkFrenzy"
---| "wildSlashes"
---| "brutalSlash"
---| "carnivorousInstinct"
---| "franticMomentum"
---| "catsCuriosity"
---| "lionsStrength"
---| "bloodtalons"
---| "adaptiveSwarm"
---| "incarnationAvatarOfAshamane"
---| "convokeTheSpiritsFeral"
---| "soulOfTheForest"
---| "veinripper"
---| "ripAndTear"
---| "feralFrenzy"
---| "unbridledSwarm"
---| "ashamanesGuidance"
---| "circleOfLifeAndDeath"
---| "apexPredatorsCraving"
---| "rake"
---| "frenziedRegeneration"
---| "rejuvenation"
---| "starfire"
---| "thrash"
---| "improvedBarkskin"
---| "swiftmend"
---| "sunfire"
---| "starsurge"
---| "rip"
---| "improvedSwipe"
---| "verdantHeart"
---| "wildGrowth"
---| "removeCorruption"
---| "moonkinForm"
---| "improvedSunfire"
---| "nurturingInstinct"
---| "hibernate"
---| "felineSwiftness"
---| "thickHide"
---| "wildCharge"
---| "tigerDash"
---| "naturalRecovery"
---| "cyclone"
---| "astralInfluence"
---| "tirelessPursuit"
---| "skullBash"
---| "soothe"
---| "risingLightFallingNight"
---| "typhoon"
---| "primalFury"
---| "mattedFur"
---| "stampedingRoar"
---| "improvedRejuvenation"
---| "galeWinds"
---| "incessantTempest"
---| "incapacitatingRoar"
---| "mightyBash"
---| "ursineVigor"
---| "lycarasTeachings"
---| "forestwalk"
---| "massEntanglement"
---| "ursolsVortex"
---| "wellHonedInstincts"
---| "improvedStampedingRoar"
---| "renewal"
---| "innervate"
---| "protectorOfThePack"
---| "heartOfTheWild"
---| "naturesVigil"

---@class Cast
---@field able { [AllAbilities | 'racial']: fun(thisUnit?:UnitId, castType?: CastType, minUnits?: number, effectRng?: number, predict?:boolean, predictPad?:boolean, enemies?:table): boolean }
---@field active { [AllAbilities]: fun(): boolean }
---@field auto { [AllAbilities]: fun(): boolean }
---@field cancel { [AllAbilities]: fun(): boolean }
---@field current { [AllAbilities]: fun(): boolean }
---@field dispel { [DruidDispel]: fun(thisUnit: UnitId): boolean }
---@field empowered { [AllAbilities]: fun(): boolean }
---@field inFlight { [AllAbilities]: fun(): boolean }
---@field inFlightRemain { [AllAbilities]: fun(): number }
---@field last { [AllAbilities]: fun(): boolean, time: table<AllAbilities, fun(): number>}
---@field noControl { [AllAbilities]: fun(): boolean }
---@field pool { [AllAbilities]: fun(): boolean }
---@field cost { [AllAbilities]: fun(): number }
---@field range { [AllAbilities]: fun(): number }
---@field regen { [AllAbilities]: fun(): number }
---@field time { [AllAbilities]: fun(): number }
---@field safe { [AllAbilities]: fun(): boolean }
---@field timeSinceLast { [AllAbilities]: fun(): number }
---@field form fun(index): boolean
---@field racial fun(): boolean
---@field [AllAbilities] fun(thisUnit?:UnitId, castType?: CastType, minUnits?: number, effectRng?: number, predict?:boolean, predictPad?:boolean, enemies?:table): boolean | nil

---@class Buff
---@field cancel fun(unit?: UnitId, source?: UnitId)
---@field count fun(): number
---@field duration fun(unit?: UnitId, source?: UnitId): number
---@field exists fun(unit?: UnitId, source?: UnitId): boolean 
---@field react fun(unit?: UnitId, source?: UnitId): boolean
---@field remain fun(unit?: UnitId, source?: UnitId): number
---@field remains fun(unit?: UnitId, source?: UnitId): number
---@field refresh fun(unit?: UnitId, source?: UnitId): boolean
---@field stack fun(unit?: UnitId, source?: UnitId): number

---@class DruidBuff
---@field [AllBuffs] Buff

---@class Debuff
---@field exists fun(unit?: UnitId, source?: UnitId): boolean
---@field duration fun(unit?: UnitId, source?: UnitId): number
---@field remain fun(unit?: UnitId, source?: UnitId): number
---@field remains fun(unit?: UnitId, source?: UnitId): number
---@field stack fun(unit?: UnitId, source?: UnitId): number
---@field pandemic fun(unit?: UnitId, source?: UnitId): number
---@field pmultiplier fun(unit?: UnitId, source?: UnitId): number
---@field refresh fun(unit?: UnitId, source?: UnitId): boolean
---@field count fun(): number
---@field remainCount fun(remain: number): number
---@field refreshCount fun(range?: number): number
---@field lowest fun(range?: number, debuffType?: string, source?: UnitId): string
---@field lowestPet fun(range?: number, debuffType?: string): string
---@field max fun(range?: number, debuffType?: string): string
---@field exsang fun(thisUnit?: UnitId): boolean
---@field calc fun(thisUnit?: UnitId): number
---@field applied fun(thisUnit?: UnitId): number

---@class DruidDebuff
---@field [AllDebuffs] Debuff

---@class Charges
---@field exists fun(): boolean
---@field count fun(): number, number, number, number, number
---@field frac fun(): number
---@field max fun(): number
---@field recharge fun(chargeMax?: boolean): number
---@field timeTillFull fun(): number

---@class DruidCharges
---@field [AllAbilities] Charges


---@class DruidTalent
---@field rank { [DruidTalents]: number }
---@field [DruidTalents] boolean

---@class CD
---@field duration fun(): number
---@field exists fun(): boolean
---@field prevgcd fun(): number
---@field ready fun(): boolean
---@field remain fun(): number
---@field remains fun(): number

---@class DruidCD
---@field [AllAbilities] CD

--------------
--- Locals ---
--------------
-- BR API Locals
---@type DruidBuff
local buff
---@type Cast
local cast
---@type DruidCD
local cd
---@type DruidCharges
local charges
---@type DruidDebuff
local debuff
local enemies
local equiped
local module
local power
local spell
---@type DruidTalent
local talent
local unit
local units
local use
---@type BR.API.UI
local ui
local var                = {}

-- General Locals

local race
local rebirthOptions = {
    [1] = "target",
    [2] = "mouseover"
}

local removeCorruptionOptions = {
    [1] = "target",
    [2] = "mouseover",
    [3] = "player"
}

local markOfTheWildOptions = {
    [1] = "target",
    [2] = "mouseover",
    [3] = "player",
    [4] = "focus",
    [5] = "group"
}


---@alias DotSpellNames "moonfireCat" | "primalWrath" | "rake" | "rip" | "thrashCat"

-- Variables
---@class var.ticksGain : { [DotSpellNames] : number }
var.ticksGain            = {
    rake = 0,      -- 5
    rip = 0,       -- 12
    thrashCat = 0, -- 5
    primalWrath = 0,
    moonfireCat = 0
}

var.bsIncRemain          = 0
var.bsIncUp              = false
var.fbMaxEnergy          = false
var.friendsInRange       = false
var.energy               = 0
var.energyDeficit        = 0
var.multidot             = false
var.getTime              = br._G.GetTime()
var.htTimer              = var.getTime
var.lastForm             = 0
var.lastRune             = var.getTime
var.leftCombat           = var.getTime
var.localsUpdated        = false
var.lootDelay            = 0
var.minCount             = 3

---@param x number
---@return number
var.mod_circle_dot       = function(x)
    return x * (talent.circleOfLifeAndDeath and 0.8 or 1)
end
var.noDoT                = false
var.profileStop          = false
var.unit5ID              = 0
var.astralInfluenceRange = 0
var.isEatingOrDrinking   = false
var.astralInfluence      = 0
var.stats                = {
    attackPower = 0,
    comboPoints = 0,
    crit = 0,
    haste = 0,
    mastery_value = 0,
    melee_haste = 0,
    spell_haste = 0,
    versatility_atk_mod = 0
}

var.multipliers          = {
    tigersFury = 1,
}

var.enemies              = {}

var.range                = {}

var.dotSpells            = {
    moonfireCat = {
        id = 155625,
        duration = function() return var.mod_circle_dot(16) * var.stats.haste end,
        tick_time = function() return var.mod_circle_dot(2) * var.stats.haste end,
        max_stack = 1,
        remains = function(u)
            return debuff.moonfireCat.remain(u)
        end
    },
    primalWrath = {
        id = 285381,
        duration = function() return (talent.veinripper and 1.25 or 1) * var.mod_circle_dot(2 + 2 * var.comboPoints) *
            var.stats.haste end,
        tick_time = function() return var.mod_circle_dot(2) * var.stats.haste end,
        remains = function(u)
            return debuff.rip.remain(u)
        end
    },
    rake = {
        id = 155722,
        tick_time = function()
            return var.mod_circle_dot(3) * var.stats.haste
        end,
        duration = function()
            return var.mod_circle_dot((talent.veinripper and 1.25 or 1) * 15) * var.stats.haste
        end,
        remains = function(u)
            return debuff.rake.remain(u)
        end
    },
    rip = {
        id = 1079,
        tick_time = function()
            return var.mod_circle_dot(2) * var.stats.haste
        end,
        duration = function()
            return var.mod_circle_dot((talent.veinripper and 1.25 or 1) * (4 + (var.comboPoints * 4)))
        end,
        remains = function(u)
            return debuff.rip.remain(u)
        end
    },
    thrashCat = {
        id = 405233,
        duration = function() return var.mod_circle_dot((talent.veinripper and 1.25 or 1) * 15) * var.stats.haste end,
        tick_time = function() return var.mod_circle_dot(3) * var.stats.haste end,
        remains = function(u)
            return debuff.thrashCat.remain(u)
        end
    }
}

var.ticks                = {
    ---@param debuffName DotSpellNames
    ---@param thisUnit UnitId
    ---@return number
    total = function(debuffName, thisUnit)
        local db = debuff[debuffName]
        local dotSpell = var.dotSpells[debuffName]
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
        local dotSpell = var.dotSpells[debuffName]
        return math.floor(db.remain(thisUnit, "EXACT") / dotSpell.tick_time())
    end,

    ---@param debuffName DotSpellNames
    ---@param thisUnit UnitId
    ---@return number
    gain = function(debuffName, thisUnit)
        return var.ticks.total(debuffName, thisUnit) - var.ticks.remain(debuffName, thisUnit)
    end,

    ---@param debuffName DotSpellNames
    ---@param thisUnit UnitId
    ---@return number
    gainUnit = function(debuffName, thisUnit)
        return var.ticks.gain(debuffName, thisUnit)
    end,
}

var.units                = {}

var.ui                   = {}

var.zerk_biteweave       = true


-----------------
--- Functions ---
-----------------

---@return boolean
local isStealthed = function()
    return buff.prowl.exists() == true or buff.incarnationProwl.exists() == true or buff.shadowmeld.exists() == true
end

---@return boolean
local canCastStealth = function()
    return cast.able.prowl("player") == true or cast.able.incarnProwl("player") == true
end

---@return boolean
local shouldStealth = function()
    return not isStealthed() and canCastStealth()
end

local function autoProwl()
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
end

local function getChargeInfo(chargeSpell)
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
end

local btSpells = {
    ["brutalSlash"] = true,
    ["moonfireCat"] = true,
    ["rake"] = true,
    ["shred"] = true,
    ["swipeCat"] = true,
    ["thrashCat"] = true,
}

---@alias btSpells "brutalSlash" | "moonfireCat" | "rake" | "shred" | "swipeCat" | "thrashCat"

---@type { need: boolean, stacks: number, triggers: number, [btSpells]: boolean }
local bt = setmetatable({}, {
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
})

local getMarkUnit = function(option)
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
end


--------------------
--- Action Lists ---
--------------------
local actionList = {}

actionList.utility = function()
    if var.ui.autoShapeshifts then
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

    if var.ui.useMarkOfTheWild and not isStealthed() and not unit.inCombat() and not (unit.flying() or unit.mounted()) then
        local thisUnit = getMarkUnit(var.ui.markOfTheWildUnit)
        if cast.timeSinceLast.markOfTheWild() > 35 and cast.able.markOfTheWild(thisUnit) and buff.markOfTheWild.refresh(thisUnit) and unit.distance(thisUnit) < 40 then
            if cast.markOfTheWild(var.markUnit) then
                ui.debug("Casting Mark of the Wild - [utility] - 1")
                return true
            end
        end
    end
end

actionList.defensives = function()
    local step = 1
    if ui.useDefensive() and not unit.mounted() and not (buff.prowl.exists() or buff.shadowmeld.exists()) and not buff.flightForm.exists() and not buff.prowl.exists() then
        if var.ui.useRebirth and unit.inCombat() then
            local rebirthTarget = var.ui.useRebirthTarget
            
            if cast.able.rebirth(rebirthTarget, "dead") and unit.deadOrGhost(rebirthTarget) and (unit.friend(rebirthTarget) or unit.player(rebirthTarget)) then
                if cast.rebirth(thisUnit, "dead") then
                    ui.debug("Casting Rebirth on " .. unit.name(rebirthTarget) .. " [defensives] - " .. step)
                    return true
                end
            end
        end

        step = step + 1
        if var.ui.useRevive and not unit.inCombat() then
            local reviveTarget = var.ui.useReviveTarget
            if cast.able.rebirth(reviveTarget, "dead") and unit.deadOrGhost(reviveTarget) and (unit.friend(reviveTarget) or unit.player(reviveTarget)) then
                if cast.rebirth(thisUnit, "dead") then
                    ui.debug("Casting Revive on " .. unit.name(reviveTarget) .. " [defensives] - " .. step)
                    return true
                end
            end
        end

        step = step + 1
        if var.ui.useRemoveCorruption then
            local useRemoveCorruptionTarget = var.ui.useRemoveCorruptionTarget
            if cast.able.removeCorruption() and (unit.friend(useRemoveCorruptionTarget) or unit.player(useRemoveCorruptionTarget)) and cast.dispel.removeCorruption(useRemoveCorruptionTarget) then
                if cast.removeCorruption(useRemoveCorruptionTarget) then
                    ui.debug("Casting Remove Corruption on " ..
                    unit.name(useRemoveCorruptionTarget) .. " [defensives] - " .. step)
                    return true
                end
            end
        end

        step = step + 1
        if var.ui.useSoothe and cast.able.soothe() then
            for i = 1, #var.enemies.yards40 do
                local thisUnit = var.enemies.yards40[i]
                if cast.dispel.soothe(thisUnit) then
                    if cast.soothe(thisUnit) then
                        ui.debug("Casting Soothe on " .. unit.name(thisUnit) .. " [defensives] - " .. step)
                        return true
                    end
                end
            end
        end

        step = step + 1
        if var.ui.useRenewal and unit.inCombat() and cast.able.renewal() and unit.hp() <= var.ui.useRenewalValue then
            if cast.renewal() then
                ui.debug("Casting Renewal - [defensives] - " .. step)
                return true
            end
        end

        step = step + 1
        -- PowerShift - Breaks Crowd Control (R.I.P Powershifting)
        if var.ui.breakCC and cast.able.catForm() then
            if not cast.noControl.catForm() and var.lastForm ~= 0 then
                cast.form(var.lastForm)
                var.lastForm = 0
                -- if currentForm == var.lastForm or currentForm == 0 then
                --     var.lastForm = 0
                -- end
            elseif cast.noControl.catForm() then
                if unit.form() == 0 then
                    cast.catForm("player")
                    ui.debug("Casting Cat Form [Breaking CC]")
                else
                    for i = 1, unit.formCount() do
                        if i == unit.form() then
                            var.lastForm = i
                            cast.form(i)
                            ui.debug("Casting Last Form [Breaking CC]")
                            return true
                        end
                    end
                end
            end
        end

        module.BasicHealing()
        -- Regrowth
        if var.ui.useRegrowth and cast.able.regrowth("player") and not (unit.mounted() or unit.flying()) and not cast.current.regrowth() then
            local thisHP = unit.hp()
            local thisUnit = "player"
            local lowestUnit = unit.lowest(40)
            local fhp = unit.hp(lowestUnit)
            if var.ui.useAutoHeal and unit.distance(lowestUnit) < 40 then
                thisHP = fhp;
                thisUnit = lowestUnit
            else
                thisUnit = "player"
            end
            if not unit.inCombat() and thisHP <= var.ui.useRegrowthValue and (not unit.moving() or buff.predatorySwiftness.exists()) then
                -- Break Form
                if var.ui.useRegrowthOoC and unit.form() ~= 0 and not buff.predatorySwiftness.exists() and unit.isUnit(thisUnit, "player") then
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
                if var.ui.useRegrowthInC == 1 or not talent.bloodtalons then
                    -- Lowest Party/Raid or Player
                    if (thisHP <= var.ui.useRegrowthValue and unit.level() >= 49) or (unit.level() < 49 and thisHP <= var.ui.useRegrowthValue / 2) then
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
                -- Hold Predatory Swiftness for Bloodtalons unless Health is Below Half of Threshold or Predatory Swiftness is about to Expire.
                --[[ if var.ui.useRegrowthInC == 2 and talent.bloodtalons then
                    -- Lowest Party/Raid or Player
                    if (thisHP <= var.ui.useRegrowthValue / 2) or buff.predatorySwiftness.remain() < unit.gcd(true) * 2 then
                        if unit.form() ~= 0 and not buff.predatorySwiftness.exists() then
                            unit.cancelForm()
                            ui.debug("Cancel Form [Regrowth - InC Break]")
                        elseif unit.form() == 0 or buff.predatorySwiftness.exists() then
                            if cast.regrowth(thisUnit) then ui.debug("Casting Regrowth [IC BT Hold] on "..unit.name(thisUnit)) return true end
                        end
                    end
                end ]]
            end
        end

        -- Barkskin
        if var.ui.useBarkskin and unit.inCombat() and cast.able.barkskin() and unit.hp() <= var.ui.useBarkskinValue then
            if cast.barkskin() then
                ui.debug("Casting Barkskin - [defensives]")
                return true
            end
        end
        -- Survival Instincts
        if var.ui.useSurvivalInstincts and unit.inCombat() and cast.able.survivalInstincts() and unit.hp() <= var.ui.useSurvivalInstinctsValue and not buff.survivalInstincts.exists() and charges.survivalInstincts.count() > 0 then
            if cast.survivalInstincts() then
                ui.debug("Casting Survival Instincts - [defensives]")
                return true
            end
        end
    end
end

actionList.interrupts = function()
    if ui.useInterrupt() then
        local thisUnit
        -- Skull Bash
        if var.ui.useSkullBash and cast.able.skullBash() then
            for i = 1, #var.enemies.yards13f do
                thisUnit = var.enemies.yards13f[i]
                if unit.interruptable(thisUnit, var.ui.interruptAt) then
                    if cast.skullBash(thisUnit) then
                        ui.debug("Casting Skull Bash on " .. unit.name(thisUnit) .. " [interrupts] - 1")
                        return true
                    end
                end
            end
        end
    end
end

actionList.precombat = function()
    if not unit.inCombat() and not (unit.flying() or unit.mounted()) then
        -- TODO: ADD INSTANCE SELECTION DROP FOR AUGMENT RUNE
        if var.ui.augmentRune and not buff.draconicAugmentRune.exists() and use.able.draconicAugmentRune() and var.lastRune + unit.gcd(true) < var.getTime then
            if use.draconicAugmentRune() then
                ui.debug("Using Draconic Augment Rune - [precombat] - 1")
                var.lastRune = var.getTime
                return true
            end
        end
        -- Prowl - Non-PrePull
        if cast.able.prowl("player") and autoProwl() and var.ui.prowlMode and not var.bsInc then
            if cast.prowl("player") then
                ui.debug("Casting Prowl (Auto) - [precombat] - 2")
                return true
            end
        end
    end
end

-- SimC Action Lists
actionList.def = function()
    if actionList.interrupts() then return true end

    -- 1 prowl,if=(buff.bs_inc.down|!in_combat)&!buff.prowl.up","Executed every time the actor is available.
    if not unit.inCombat() and shouldStealth() and var.ui.prowlMode then
        if cast.prowl() then
            ui.debug("Casting Prowl [def] - 1")
            return true
        end
        if cast.incarnProwl() then
            ui.debug("Casting Incarn Prowl [def] - 1")
            return true
        end
    end

    -- 2 cat_form,if=!buff.cat_form.up
    if cast.able.catForm("player") and not buff.catForm.exists() then
        if cast.catForm("player") then
            ui.debug("Casting Cat Form [def] - 2")
            return true
        end
    end
    -- 3 invoke_external_buff,name=power_infusion
    -- 4 call_action_list,name=variables
    -- 5 tigers_fury,target_if=min:target.time_to_die,if=talent.convoke_the_spirits.enabled|!talent.convoke_the_spirits.enabled&(!buff.tigers_fury.up|energy.deficit>65)|(target.time_to_die<15&talent.predator.enabled)
    if cast.able.tigersFury() and (not buff.tigersFury.exists() or var.energyDeficit > 65) then
        if cast.tigersFury("player") then
            ui.debug("Casting Tiger's Fury [def] - 5")
            return true
        end
    end
    -- 6 rake,target_if=persistent_multiplier>dot.rake.pmultiplier,if=buff.prowl.up|buff.shadowmeld.up
    if cast.able.rake() and isStealthed() and var.range.dyn5 then
        for i = 1, #var.enemies.yards5f do
            local thisUnit = var.enemies.yards5f[i]
            if (debuff.rake.calc(thisUnit) >= debuff.rake.applied(thisUnit)) then
                if cast.rake(thisUnit) then
                    ui.debug("Casting Rake [def] - 6")
                    return true
                end
            end
        end
    end
    -- 7 auto_attack,if=!buff.prowl.up&!buff.shadowmeld.up
    -- 8 natures_vigil,if=spell_targets.swipe_cat>0
    -- 9 renewal,if=variable.regrowth
    -- 10 adaptive_swarm,target=self,if=talent.unbridled_swarm&spell_targets.swipe_cat<=1&dot.adaptive_swarm_heal.stack<4&dot.adaptive_swarm_heal.remains>4
    -- 11 adaptive_swarm,target_if=((!dot.adaptive_swarm_damage.ticking|dot.adaptive_swarm_damage.remains<2)&(dot.adaptive_swarm_damage.stack<3)&!action.adaptive_swarm_damage.in_flight&!action.adaptive_swarm.in_flight)&target.time_to_die>5,if=!(variable.need_bt&active_bt_triggers=2)&(!talent.unbridled_swarm.enabled|spell_targets.swipe_cat=1)
    -- 12 adaptive_swarm,target_if=max:((1+dot.adaptive_swarm_damage.stack)*dot.adaptive_swarm_damage.stack<3*time_to_die),if=dot.adaptive_swarm_damage.stack<3&talent.unbridled_swarm.enabled&spell_targets.swipe_cat>1&!(variable.need_bt&active_bt_triggers=2)
    -- 13 call_action_list,name=cooldown
    if actionList.cooldown() then return true end
    -- 14 feral_frenzy,target_if=max:target.time_to_die,if=((talent.dire_fixation.enabled&debuff.dire_fixation.up)|!talent.dire_fixation.enabled|spell_targets.swipe_cat>1)&(combo_points<2|combo_points<3&buff.bs_inc.up|time<10)
    if cast.able.feralFrenzy("target") and var.range.dyn5 and ((talent.direFixation and debuff.direFixation.exists()) or not talent.direFixation or #var.enemies.yards8 > 1) and (var.comboPoints < 2 or (var.comboPoints < 3 and var.bsIncUp))
    then
        if cast.feralFrenzy("target") then
            ui.debug("Casting Feral Frenzy [def] - 14")
            return true
        end
    end

    -- 15 ferocious_bite,target_if=max:target.time_to_die,if=buff.apex_predators_craving.up&(spell_targets.swipe_cat=1|!talent.primal_wrath.enabled|!buff.sabertooth.up)&!(variable.need_bt&active_bt_triggers=2)
    if cast.able.ferociousBite() and var.range.dyn5 and buff.apexPredatorsCraving.exists() and ((#var.enemies.yards8 == 1 or not talent.primalWrath or not buff.sabertooth.exists()) and not (bt.need and bt.triggers == 2)) then
        if cast.ferociousBite() then
            ui.debug("Casting Ferocious Bite [def] - 15")
            return true
        end
    end

    --[[ if talent.primalWrath and cast.able.primalWrath() and #var.enemies.yards8 >= 2 and var.comboPoints > 4 and ui.useAOE(8 + var.astralInfluence, 2) then
        if cast.primalWrath() then
            ui.debug("Cast Primal Wrath [def] 14")
            return true
        end
    end ]]
    -- 16 call_action_list,name=berserk,if=buff.bs_inc.up
    if var.bsIncUp then
        --ui.debug("Calling Action List [berserk] from [def] - 16")
        if actionList.berserk() then return true end
    end
    -- 17 wait,sec=combo_points=5,if=combo_points=4&buff.predator_revealed.react&energy.deficit>40&spell_targets.swipe_cat=1
    -- 18 call_action_list,name=finisher,if=combo_points>=4&!(combo_points=4&buff.bloodtalons.stack<=1&active_bt_triggers=2&spell_targets.swipe_cat=1)
    if var.comboPoints >= 4 and not (var.comboPoints == 4 and bt.stacks <= 1 and bt.triggers == 2 and #var.enemies.yards8 == 1) then
        --ui.debug("Calling Action List [finisher] from [def] - 18")
        if actionList.finisher() then return true end
    end
    -- 19 call_action_list,name=bloodtalons,if=variable.need_bt&!buff.bs_inc.up&combo_points<5
    if bt.need and not var.bsIncUp and var.comboPoints < 5 then
        --ui.debug("Calling Action List [bloodtalons] from [def] - 19")
        if actionList.bloodtalons() then return true end
    end
    -- 20 call_action_list,name=aoe_builder,if=spell_targets.swipe_cat>1&talent.primal_wrath.enabled
    if #var.enemies.yards8 > 1 and talent.primalWrath then
        --ui.debug("Calling Action List [aoe_builder] from [def] - 20")
        if actionList.aoe_builder() then return true end
    end
    -- 21 call_action_list,name=builder,if=!buff.bs_inc.up&combo_points<5
    if not var.bsIncUp and var.comboPoints < 5 then
        --ui.debug("Calling Action List [builder] from [def] - 21")
        if actionList.builder() then return true end
    end
    ----ui.debug("Exiting Action List [def]")
    return false
    -- 22 regrowth,if=energy<25&buff.predatory_swiftness.up&!buff.clearcasting.up&variable.regrowth
end

actionList.aoe_builder = function()
    -- 1 brutal_slash,target_if=min:target.time_to_die,if=cooldown.brutal_slash.full_recharge_time<4|target.time_to_die<5
    
    if talent.brutalSlash and cast.able.brutalSlash() and (charges.brutalSlash.timeTillFull() < 4 or unit.ttd("target") < 5) then
        if cast.brutalSlash() then
            ui.debug("Casting Brutal Slash [aoe_builder] - 1")
            return true
        end
    end
    -- 2 thrash_cat,target_if=refreshable,if=buff.clearcasting.react|(spell_targets.thrash_cat>10|(spell_targets.thrash_cat>5&!talent.double_clawed_rake.enabled))&!talent.thrashing_claws
    if cast.able.thrashCat() and (debuff.thrashCat.refresh(var.units.dyn8AOE)) and (buff.clearcasting.exists() or (#var.enemies.yards8 > 10 or (#var.enemies.yards8 > 5 and not talent.doubleClawedRake))) then
        if cast.thrashCat() then
            ui.debug("Casting Thrash [aoe_builder] - 2")
            return true
        end
    end
    -- 3 shadowmeld,target_if=max:druid.rake.ticks_gained_on_refresh,if=action.rake.ready&!buff.sudden_ambush.up&(dot.rake.refreshable|dot.rake.pmultiplier<1.4)&!buff.prowl.up&!buff.apex_predators_craving.up
    if cast.able.shadowmeld() and (debuff.rake.refresh() or debuff.rake.applied() < 1.4)
        and not buff.prowl.exists() and not buff.apexPredatorsCraving.exists()
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
    if cast.able.rake(var.maxRakeTicksGainUnit) and buff.suddenAmbush.exists() and (debuff.rake.calc(var.maxRakeTicksGainUnit) >= debuff.rake.applied(var.maxRakeTicksGainUnit)) then
        if cast.rake(var.maxRakeTicksGainUnit) then
            ui.debug("Casting Rake [aoe_builder] - 5")
            return true
        end
    end
    -- 6 rake,target_if=buff.sudden_ambush.up&persistent_multiplier>dot.rake.pmultiplier|refreshable
    if cast.able.rake(var.maxRakeTicksGainUnit) and buff.suddenAmbush.exists() and debuff.rake.applied(var.maxRakeTicksGainUnit) < 1.4 then
        if cast.rake(var.maxRakeTicksGainUnit) then
            ui.debug("Casting Rake [aoe_builder] - 6")
            return true
        end
    end
    -- 7 thrash_cat,target_if=refreshable
    if cast.able.thrashCat() and (debuff.thrashCat.refresh(var.units.dyn8AOE)) then
        if cast.thrashCat() then
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
    if talent.lunarInspiration and cast.able.moonfireCat(var.units.dyn40AOE) and #var.enemies.yards8 < 5 and debuff.moonfireCat.refresh(var.units.dyn40AOE) then
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
    if cast.able.shred() and (not buff.suddenAmbush.exists() and not (var.lazySwipe and talent.wildSlashes)) then
        if cast.shred() then
            ui.debug("Casting Shred [aoe_builder] - 12")
            return true
        end
    end
    -- 12 thrash_cat
    if cast.able.thrashCat() then
        if cast.thrashCat() then
            ui.debug("Casting Thrash [aoe_builder] - 13")
            return true
        end
    end
    --ui.debug("Exiting Action List [aoe_builder]")
    return false
end

actionList.berserk = function()
    -- 1 ferocious_bite,target_if=max:target.time_to_die,if=combo_points=5&dot.rip.remains>8&variable.zerk_biteweave&spell_targets.swipe_cat>1
    if cast.able.ferociousBite() and var.comboPoints == 5 and debuff.rip.remain() > 8 and var.zerk_biteweave and #var.enemies.yards8 > 1 then
        if cast.ferociousBite("target") then
            ui.debug("Casting Ferocious Bite [berserk] - 1")
            return true
        end
    end
    -- 2 call_action_list,name=finisher,if=combo_points=5&!(buff.overflowing_power.stack<=1&active_bt_triggers=2&buff.bloodtalons.stack<=1)
    if var.comboPoints == 5 and not (buff.overflowingPower.stack() <= 1 and bt.triggers == 2 and bt.stacks <= 1) then
        --ui.debug("Calling Action List [finsiher] from [berserk] - 2")
        if actionList.finisher() then return true end
    end
    -- 3 call_action_list,name=bloodtalons,if=spell_targets.swipe_cat>1
    if #var.enemies.yards8 > 1 then
        --ui.debug("Calling Action List [bloodtalons] from [berserk] - 3")
        if actionList.bloodtalons() then return true end
    end
    -- 4 prowl,if=!(buff.bt_rake.up&active_bt_triggers=2)&(action.rake.ready&gcd.remains=0&!buff.sudden_ambush.up&(dot.rake.refreshable|dot.rake.pmultiplier<1.4)&!buff.shadowmeld.up&cooldown.feral_frenzy.remains<44&!buff.apex_predators_craving.up)
    if cast.able.prowl() and var.ui.prowlMode and not (bt.rake and bt.triggers == 2)
        and (cast.able.rake() and not buff.suddenAmbush.exists() and (debuff.rake.refresh(var.maxRakeTicksGainUnit) or 1.4 * debuff.rake.calc() >= debuff.rake.applied(var.maxRakeTicksGainUnit)))
        and not buff.shadowmeld.exists() and (talent.feralFrenzy and cd.feralFrenzy.remain() < 44) and not buff.apexPredatorsCraving.exists()
    then
        if cast.incarnProwl("player") or cast.prowl("player") then
            ui.debug("Casting Prowl [berserk] - 4")
            return true
        end
    end
    -- 5 shadowmeld,if=!(buff.bt_rake.up&active_bt_triggers=2)&action.rake.ready&!buff.sudden_ambush.up&(dot.rake.refreshable|dot.rake.pmultiplier<1.4)&!buff.prowl.up&!buff.apex_predators_craving.up
    if cast.able.shadowmeld() and not (bt.rake and bt.triggers == 2) and cast.able.rake() and not buff.suddenAmbush.exists()
        and (debuff.rake.refresh(var.maxRakeTicksGainUnit) or 1.4 * debuff.rake.calc() >= debuff.rake.applied(var.maxRakeTicksGainUnit))
        and not buff.prowl.exists() and not buff.apexPredatorsCraving.exists()
    then
        if cast.shadowmeld() then
            ui.debug("Casting Shadowmeld [berserk] - 5")
            return true
        end
    end
    -- 6 rake,if=!(buff.bt_rake.up&active_bt_triggers=2)&(refreshable|(buff.sudden_ambush.up&persistent_multiplier>dot.rake.pmultiplier))
    if cast.able.rake(var.maxRakeTicksGainUnit) and not (bt.rake and bt.triggers == 2)
        and (debuff.rake.refresh(var.maxRakeTicksGainUnit) or (buff.suddenAmbush.exists() and debuff.rake.calc(var.maxRakeTicksGainUnit) > 1.4))
    then
        if cast.rake(var.maxRakeTicksGainUnit) then
            ui.debug("Casting Rake [berserk] - 6")
            return true
        end
    end
    -- 7 shred,if=(active_bt_triggers=2|(talent.dire_fixation.enabled&!debuff.dire_fixation.up))&buff.bt_shred.down
    if cast.able.shred("target") and (bt.triggers == 2 or (talent.direFixation and not debuff.direFixation.exists())) and not bt.shred then
        if cast.shred("target") then
            ui.debug("Casting Shred [berserk] - 7")
            return true
        end
    end
    -- 8 brutal_slash,if=active_bt_triggers=2&buff.bt_brutal_slash.down
    if talent.brutalSlash and cast.able.brutalSlash() and bt.triggers == 2 and not bt.brutalSlash then
        if cast.brutalSlash() then
            ui.debug("Casting Brutal Slash [berserk] - 8")
            return true
        end
    end
    -- 9 moonfire_cat,if=active_bt_triggers=2&buff.bt_moonfire.down
    if talent.lunarInspiration and cast.able.moonfireCat() and bt.triggers == 2 and not bt.moonfireCat then
        if cast.moonfireCat() then
            ui.debug("Casting Moonfire [berserk] - 9")
            return true
        end
    end
    -- 10 thrash_cat,if=active_bt_triggers=2&buff.bt_thrash.down&!talent.thrashing_claws&variable.need_bt&(refreshable|talent.brutal_slash.enabled)
    if cast.able.thrashCat() and bt.triggers == 2 and not bt.thrashCat and not talent.thrashingClaws
        and (debuff.thrashCat.refresh() or talent.brutalSlash)
    then
        if cast.thrashCat() then
            ui.debug("Casting Thrash [berserk] - 10")
            return true
        end
    end
    -- 11 moonfire_cat,if=refreshable
    if talent.lunarInspiration and cast.able.moonfireCat() and debuff.moonfireCat.refresh() then
        if cast.moonfireCat() then
            ui.debug("Casting Moonfire [berserk] - 11")
            return true
        end
    end
    -- 12 brutal_slash,if=cooldown.brutal_slash.charges>1
    if talent.brutalSlash and cast.able.brutalSlash() and getChargeInfo(charges.brutalSlash).current > 1 then
        if cast.brutalSlash() then
            ui.debug("Casting Brutal Slash [berserk] - 12")
            return true
        end
    end
    -- 13 shred
    if cast.able.shred() then
        if cast.shred() then
            ui.debug("Casting Shred [berserk] - 13")
            return true
        end
    end
    --ui.debug("Exiting Action List [berserk]")
    return false
end

actionList.bloodtalons = function()
    -- 1 brutal_slash,target_if=min:target.time_to_die,if=(cooldown.brutal_slash.full_recharge_time<4|target.time_to_die<5)&(buff.bt_brutal_slash.down&(buff.bs_inc.up|variable.need_bt))
    if cast.able.brutalSlash() and (charges.brutalSlash.timeTillFull() < 4 and (not bt.brutalSlash and (var.bsIncUp or bt.need))) then
        if cast.brutalSlash() then
            ui.debug("Casting Shred [bloodtalons - 1]")
            return true
        end
    end
    -- 2 prowl,if=action.rake.ready&gcd.remains=0&!buff.sudden_ambush.up&(dot.rake.refreshable|dot.rake.pmultiplier<1.4)&!buff.shadowmeld.up&buff.bt_rake.down&!buff.prowl.up&!buff.apex_predators_craving.up

    -- 3 shadowmeld,if=action.rake.ready&!buff.sudden_ambush.up&(dot.rake.refreshable|dot.rake.pmultiplier<1.4)&!buff.prowl.up&buff.bt_rake.down&cooldown.feral_frenzy.remains<44&!buff.apex_predators_craving.up
    -- 4 rake,target_if=max:druid.rake.ticks_gained_on_refresh,if=(refreshable|buff.sudden_ambush.up&persistent_multiplier>dot.rake.pmultiplier)&buff.bt_rake.down
    if cast.able.rake(var.maxRakeTicksGainUnit) and ((debuff.rake.refresh(var.maxRakeTicksGainUnit) or buff.suddenAmbush.exists()) and not bt.rake) then
        if cast.rake(var.maxRakeTicksGainUnit) then
            ui.debug("Casting Rake [bloodtalons - 4]")
            return true
        end
    end
    -- 5 rake,target_if=buff.sudden_ambush.up&persistent_multiplier>dot.rake.pmultiplier&buff.bt_rake.down
    if cast.able.rake(var.maxRakeTicksGainUnit) and (buff.suddenAmbush.exists() and not bt.rake) then
        if cast.rake(var.maxRakeTicksGainUnit) then
            ui.debug("Casting Rake [bloodtalons - 5]")
            return true
        end
    end
    -- 6 shred,if=buff.bt_shred.down&buff.clearcasting.react&spell_targets.swipe_cat=1
    if cast.able.shred() and not bt.shred and buff.clearcasting.react() and #var.enemies.yards8 == 1 then
        if cast.shred() then
            ui.debug("Casting Shred [bloodtalons - 6]")
            return true
        end
    end
    -- 7 thrash_cat,target_if=refreshable,if=buff.bt_thrash.down&buff.clearcasting.react&spell_targets.swipe_cat=1&!talent.thrashing_claws.enabled
    if cast.able.thrashCat() and debuff.thrashCat.refresh(var.units.dyn8AOE) and not bt.thrashCat and buff.clearcasting.react() and #var.enemies.yards8 == 1 and not talent.thrashingClaws then
        if cast.thrashCat(var.thrashCatTicksGainUnit) then
            ui.debug("Casting Thrash [bloodtalons - 7]")
            return true
        end
    end
    -- 8 brutal_slash,if=buff.bt_brutal_slash.down
    if cast.able.brutalSlash() and not bt.brutalSlash then
        if cast.brutalSlash() then
            ui.debug("Casting Brutal Slash [bloodtalons - 8]")
            return true
        end
    end
    -- 9 moonfire_cat,if=refreshable&buff.bt_moonfire.down&spell_targets.swipe_cat=1
    if talent.lunarInspiration and cast.able.moonfireCat(var.units.dyn40AOE) and not bt.moonfireCat and #var.enemies.yards8 == 1 then
        if cast.moonfireCat(var.units.dyn40AOE) then
            ui.debug("Casting Moonfire [bloodtalons - 9]")
            return true
        end
    end
    -- 10 thrash_cat,target_if=refreshable,if=buff.bt_thrash.down&!talent.thrashing_claws.enabled
    if cast.able.thrashCat(var.units.dyn8AOE) and debuff.thrashCat.refresh(var.units.dyn8AOE) and not bt.thrashCat and not talent.thrashingClaws then
        if cast.thrashCat() then
            ui.debug("Casting Thrash [bloodtalons - 10]")
            return true
        end
    end
    -- shred,if=buff.bt_shred.down&spell_targets.swipe_cat=1&(!talent.wild_slashes.enabled|(!debuff.dire_fixation.up&talent.dire_fixation.enabled))
    if cast.able.shred() and not bt.shred and #var.enemies.yards8 == 1 and (not talent.wildSlashes or (not debuff.direFixation.exists() and talent.direFixation)) then
        if cast.shred() then
            ui.debug("Casting Shred [bloodtalons - 11]")
            return true
        end
    end
    -- swipe_cat,if=buff.bt_swipe.down&talent.wild_slashes.enabled
    if not talent.brutalSlash and cast.able.swipeCat() and not bt.swipeCat and talent.wildSlashes then
        if cast.swipeCat() then
            ui.debug("Casting Swipe [bloodtalons - 12]")
            return true
        end
    end
    -- moonfire_cat,target_if=max:(3*refreshable)+dot.adaptive_swarm_damage.ticking,if=buff.bt_moonfire.down&spell_targets.swipe_cat<5
    if talent.lunarInspiration and cast.able.moonfireCat(var.units.dyn40AOE) and not bt.moonfireCat and #var.enemies.yards8 < 5 then
        if cast.moonfireCat(var.units.dyn40AOE) then
            ui.debug("Casting Moonfire [bloodtalons - 13]")
            return true
        end
    end
    -- swipe_cat,if=buff.bt_swipe.down
    if not talent.brutalSlash and cast.able.swipeCat() and not bt.swipeCat then
        if cast.swipeCat() then
            ui.debug("Casting Swipe [bloodtalons - 14]")
            return true
        end
    end
    -- moonfire_cat,target_if=max:(3*refreshable)+dot.adaptive_swarm_damage.ticking,if=buff.bt_moonfire.down
    if talent.lunarInspiration and cast.able.moonfireCat(var.units.dyn40AOE) and not bt.moonfireCat then
        if cast.moonfireCat(var.units.dyn40AOE) then
            ui.debug("Casting Moonfire [bloodtalons - 15]")
            return true
        end
    end
    -- shred,target_if=max:target.time_to_die,if=(spell_targets>5|talent.dire_fixation.enabled)&buff.bt_shred.down&!buff.sudden_ambush.up&!(variable.lazy_swipe&talent.wild_slashes)
    if cast.able.shred() and not bt.shred and (buff.suddenAmbush.exists() or (talent.wildSlashes and var.lazySwipe)) then
        if cast.shred() then
            ui.debug("Casting Shred [bloodtalons - 16]")
            return true
        end
    end
    -- thrash_cat,if=buff.bt_thrash.down
    if cast.able.thrashCat() and not bt.thrashCat then
        if cast.thrashCat() then
            ui.debug("Casting Thrash [bloodtalons - 17]")
            return true
        end
    end
    -- rake,target_if=min:(25*(persistent_multiplier<dot.rake.pmultiplier)+dot.rake.remains),if=buff.bt_rake.down&(spell_targets.swipe_cat>4&!talent.dire_fixation|talent.wild_slashes&variable.lazy_swipe)
    if cast.able.rake(var.maxRakeTicksGainUnit) and not bt.rake then
        if cast.rake(var.maxRakeTicksGainUnit) then
            ui.debug("Casting Rake [bloodtalons - 18]")
            return true
        end
    end
    --ui.debug("Exiting Action List [bloodtalons]")
    return false
end

actionList.builder = function()
    -- run_action_list,name=clearcasting,if=buff.clearcasting.react
    if buff.clearcasting.react() then
        --ui.debug("Calling Action List [clearcasting] from [builder] - 1")
        if actionList.clearcasting() then
            return true
        end
    end
    -- brutal_slash,if=cooldown.brutal_slash.full_recharge_time<4
    if talent.brutalSlash and cast.able.brutalSlash() and charges.brutalSlash.timeTillFull() < 4 then
        if cast.brutalSlash() then
            ui.debug("Casting Brutal Slash [builder] - 2")
            return true
        end
    end
    -- pool_resource,if=!action.rake.ready&(dot.rake.refreshable|(buff.sudden_ambush.up&persistent_multiplier>dot.rake.pmultiplier&dot.rake.remains>6))&!buff.clearcasting.react
    --[[     if not cast.able.rake(var.maxRakeTicksGainUnit) and (debuff.rake.refresh(var.maxRakeTicksGainUnit) or (buff.suddenAmbush.exists() and debuff.rake.calc(var.maxRakeTicksGainUnit) > 1.4 and debuff.rake.remain(var.maxRakeTicksGainUnit) > 6)) and not buff.clearcasting.react() then
        if cast.rake(var.maxRakeTicksGainUnit) then ui.debug("Casting Rake [Builder] - 2") return true end
    end ]]
    -- shadowmeld,if=action.rake.ready&!buff.sudden_ambush.up&(dot.rake.refreshable|dot.rake.pmultiplier<1.4)&!buff.prowl.up&!buff.apex_predators_craving.up
    if cast.able.shadowmeld() and cast.able.rake(var.maxRakeTicksGainUnit) and not buff.suddenAmbush.exists()
        and (debuff.rake.refresh(var.maxRakeTicksGainUnit) or 1.4 * debuff.rake.calc(var.maxRakeTicksGainUnit) < debuff.rake.applied(var.maxRakeTicksGainUnit))
        and not buff.prowl.exists() and not buff.apexPredatorsCraving.exists()
    then
        if cast.shadowmeld() then
            ui.debug("Casting Shadowmeld [builder] - 4")
            return true
        end
    end
    -- rake,if=refreshable|(buff.sudden_ambush.up&persistent_multiplier>dot.rake.pmultiplier)
    if cast.able.rake(var.maxRakeTicksGainUnit) and (debuff.rake.refresh(var.maxRakeTicksGainUnit) or (buff.suddenAmbush.exists() and debuff.rake.calc(var.maxRakeTicksGainUnit) > 1.4)) then
        if cast.rake(var.maxRakeTicksGainUnit) then
            ui.debug("Casting Rake [builder] - 5")
            return true
        end
    end
    -- run_action_list,name=clearcasting,if=buff.clearcasting.react
    if buff.clearcasting.react() then
        --ui.debug("Calling Action List [clearcasting] from [builder] - 6")
        if actionList.clearcasting() then return true end
    end
    -- moonfire_cat,target_if=refreshable
    if talent.lunarInspiration and cast.able.moonfireCat() and debuff.moonfireCat.refresh() then
        if cast.moonfireCat() then
            ui.debug("Casting Moonfire [builder] - 7")
            return true
        end
    end
    -- thrash_cat,target_if=refreshable&!talent.thrashing_claws.enabled
    if cast.able.thrashCat() and debuff.thrashCat.refresh(var.units.dyn8AOE) and not talent.thrashingClaws then
        if cast.thrashCat() then
            ui.debug("Casting Thrash [builder] - 8")
            return true
        end
    end
    -- brutal_slash
    if talent.brutalSlash and cast.able.brutalSlash() then
        if cast.brutalSlash() then
            ui.debug("Casting Brutal Slash [builder] - 9")
            return true
        end
    end

    -- swipe_cat,if=spell_targets.swipe_cat>1|(talent.wild_slashes.enabled&(debuff.dire_fixation.up|!talent.dire_fixation.enabled))
    if not talent.brutalSlash and cast.able.swipeCat() and (#var.enemies.yards8 > 1 or (talent.wildSlashes and (debuff.direFixation.exists() or not talent.direFixation))) then
        if cast.swipeCat() then
            ui.debug("Casting Swipe [builder] - 10")
            return true
        end
    end

    -- shred
    if cast.able.shred() then
        if cast.shred() then
            ui.debug("Casting Shred [builder] - 11")
            return true
        end
    end
    --ui.debug("Exiting Action List [builder]")
    return false
end

actionList.clearcasting = function()
    -- 1 thrash_cat,if=refreshable&!talent.thrashing_claws.enabled
    if cast.able.thrashCat(var.units.dyn8AOE) and debuff.thrashCat.refresh(var.units.dyn8AOE) and not talent.thrashingClaws then
        if cast.thrashCat(var.units.dyn8AOE) then
            ui.debug("Casting Thrash [Clearcasting]")
            return true
        end
    end
    -- 2 swipe_cat,if=spell_targets.swipe_cat>1
    if not talent.brutalSlash and cast.able.swipeCat() and #var.enemies.yards8 > 1 then
        if cast.swipeCat() then
            ui.debug("Casting Swipe [Clearcasting]")
            return true
        end
    end
    -- 3 brutal_slash,if=spell_targets.brutal_slash>2
    if talent.brutalSlash and cast.able.brutalSlash() and #var.enemies.yards8 > 2 then
        if cast.brutalSlash() then
            ui.debug("Casting Brutal Slash [Clearcasting]")
            return true
        end
    end
    -- 4 shred
    if cast.able.shred() then
        if cast.shred() then
            ui.debug("Casting Shred [Clearcasting]")
            return true
        end
    end
    --ui.debug("Exiting Action List [clearcasting]")
    return false
end

actionList.cooldown = function()
    -- 3 incarnation,target_if=max:target.time_to_die,if=(target.time_to_die<fight_remains&target.time_to_die>25)|target.time_to_die=fight_remains
    if (talent.incarnationAvatarOfAshamane and cast.able.incarnationAvatarOfAshamane()) and unit.exists(var.units.dyn5) and unit.distance(var.units.dyn5) < 5 and var.ui.berserkIncarnation and ui.useCDs() then
        if cast.incarnationAvatarOfAshamane() then
            ui.debug("Casting Incarnation Avatar Of Ashamane [cooldown] - 3")
            return true
        end
    end
    -- 4 berserk,target_if=max:target.time_to_die,if=((target.time_to_die<fight_remains&target.time_to_die>18)|target.time_to_die=fight_remains)&((!variable.lastZerk)|(fight_remains<23)|(variable.lastZerk&!variable.lastConvoke)|(variable.lastConvoke&cooldown.convoke_the_spirits.remains<10))
    if (not talent.incarnationAvatarOfAshamane and (talent.berserk and cast.able.berserk())) and unit.exists(var.units.dyn5) and unit.distance(var.units.dyn5) < 5 and var.ui.berserkIncarnation and ui.useCDs() then
        if cast.berserk() then
            ui.debug("Casting Berserk [cooldown] - 4")
            return true
        end
    end
    -- 5 berserking,if=!variable.align_3minutes|buff.bs_inc.up
    if ui.checked("Racial") and race == "Troll" and cast.able.racial() and ui.useCDs() and var.bsIncUp then
        if cast.racial() then
            ui.debug("Casting Berserking [cooldown] - 5")
            return true
        end
    end
    -- 8 convoke_the_spirits,target_if=max:target.time_to_die,if=((target.time_to_die<fight_remains&target.time_to_die>5-talent.ashamanes_guidance.enabled)|target.time_to_die=fight_remains)&(fight_remains<5|(dot.rip.remains>5&buff.tigers_fury.up&(combo_points<2|(buff.bs_inc.up&combo_points<=3))))&(!variable.lastConvoke|buff.potion.up|(time+fight_remains+10)%%300>time%%300)&(talent.dire_fixation.enabled&debuff.dire_fixation.up|!talent.dire_fixation.enabled|spell_targets.swipe_cat>1)
    if var.ui.convokeTheSpirits
        and (talent.convokeTheSpiritsFeral and cast.able.convokeTheSpiritsFeral())
        and (
            (buff.tigersFury.exists() and var.comboPoints < 2 and var.bsIncRemain > 20)
            or (unit.ttdGroup(5) < 5 and ui.useCDs() and not unit.isDummy(var.units.dyn5))
        ) then
        if cast.convokeTheSpiritsFeral() then
            ui.debug("Casting Convoke the Spirits [Cooldowns] - 8")
            return true
        end
    end
    module.BasicTrinkets()
    --ui.debug("Exiting Action List [cooldown]")
    return false
end

actionList.finisher = function()
    -- 1 primal_wrath,if=((dot.primal_wrath.refreshable&!talent.circle_of_life_and_death.enabled)|dot.primal_wrath.remains<6|(talent.tear_open_wounds.enabled|(spell_targets.swipe_cat>4&!talent.rampant_ferocity.enabled)))&spell_targets.primal_wrath>1&talent.primal_wrath.enabled
    if cast.able.primalWrath("player","aoe", 1, 8 + var.astralInfluence) and var.range.dyn8AOE and #var.enemies.yards8 > 1 then
        if cast.primalWrath("player","aoe", 1, 8 + var.astralInfluence) then ui.debug("Casting Primal Wrath - AoE [finisher]") return true end
    end
    -- primal_wrath,target_if=refreshable,if=spell_targets.primal_wrath>1
    for i = 1, #var.enemies.yards8 do
        local thisUnit = var.enemies.yards8[i]
        if cast.able.primalWrath(thisUnit) and debuff.rip.refresh(thisUnit) and (#var.enemies.yards8 > 1) then
            if cast.primalWrath("player","aoe", 1, 8 + var.astralInfluence) then ui.debug("Casting Primal Wrath - Refresh [finisher]") return true end
        end
    end
--[[
    if talent.primalWrath and cast.able.primalWrath() and #var.enemies.yards8 >= 2 and ui.useAOE(8 + var.astralInfluence, 2) then
        if cast.primalWrath() then
            ui.debug("Casting Primal Wrath [finisher] - 1");
            return true
        end
    end
    ]]
    -- 2 rip,target_if=refreshable&(!talent.primal_wrath.enabled|spell_targets.swipe_cat=1)
    if cast.able.rip() and debuff.rip.refresh() and (not talent.primalWrath or #var.enemies.yards8 == 1) then
        if cast.rip() then
            ui.debug("Casting Rip [finisher] - 2")
            return true
        end
    end
    -- 3 pool_resource,for_next=1,if=!action.tigers_fury.ready&buff.apex_predators_craving.down
    -- 4 ferocious_bite,max_energy=1,target_if=max:target.time_to_die,if=buff.apex_predators_craving.down&(!buff.bs_inc.up|(buff.bs_inc.up&!talent.soul_of_the_forest.enabled))
    if cast.able.ferociousBite("target") and var.fbMaxEnergy and not buff.apexPredatorsCraving.exists() and (not var.bsIncUp or (var.bsIncUp and not talent.soulOfTheForest)) then
        if cast.ferociousBite("target") then
            ui.debug("Casting Ferocious Bite [finisher] - 4")
            return true
        end
    end
    -- 5 ferocious_bite,target_if=max:target.time_to_die,if=(buff.bs_inc.up&talent.soul_of_the_forest.enabled)|buff.apex_predators_craving.up
    if cast.able.ferociousBite("target") and (var.bsIncUp and talent.soulOfTheForest) or buff.apexPredatorsCraving.exists() then
        if cast.ferociousBite("target") then
            ui.debug("Casting Ferocious Bite [finisher] - 5")
            return true
        end
    end
    --ui.debug("Exiting Action List [finisher]")
    return false
end


actionList.variables = function()
    var.comboPoints     = power.comboPoints.amount()
    var.energy          = power.energy.amount()
    var.energyDeficit   = power.energy.deficit()

    var.getTime         = br._G.GetTime();
    var.lootDelay       = ui.checked("Auto Loot") and ui.value("Auto Loot") or 0;
    var.minCount        = ui.useCDs() and 1 or 3;
    var.astralInfluence = (talent.astralInfluence and (talent.rank.astralInfluence == 2 and 3 or 1) or 0);
    var.comboPoints     = power.comboPoints.amount()

    local ai40          = 40 + var.astralInfluence
    enemies.get(ai40) -- makes enemies.yards40
    var.enemies.yards40 = enemies["yards" .. ai40]

    local ai20 = 20 + var.astralInfluence
    enemies.get(ai20, "player", true) -- makes enemies.yards20nc
    var.enemies.yards20nc = enemies["yards" .. ai20 .. "nc"]

    local ai8 = 8 + var.astralInfluence
    enemies.get(ai8) -- makes enemies.yards8
    var.enemies.yards8 = enemies["yards" .. ai8]

    --enemies.get(ai8, "target")               -- makes enemies.yards8t
    --var.enemies.yards8t = enemies["yards" .. ai8 .. "t"]

    local ai5 = 5 + var.astralInfluence
    enemies.get(ai5, "player", false, true)
    var.enemies.yards5f = enemies["yards" .. ai5 .. "f"] -- makes enemies.yards5f

    local ai13 = 13 + var.astralInfluence
    enemies.get(ai13, "player", false, true)
    var.enemies.yards13f = enemies["yards" .. ai13 .. "f"] -- makes enemies.yards13f

    --[[
        enemies.get(40)                        -- makes enemies.yards40
        enemies.get(20, "player", true)        -- makes enemies.yards20nc
        enemies.get(13, "player", false, true) -- makes enemies.yards13f
        enemies.get(8)                         -- makes enemies.yards8
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

    -- Update Stats
    var.stats.attackPower = UnitAttackPower("player") + UnitWeaponAttackPower("player")
    var.stats.comboPoints = power.comboPoints.amount()
    var.stats.crit = max(GetCritChance(), GetSpellCritChance("player"), GetRangedCritChance())
    var.stats.melee_haste = GetMeleeHaste() / 100
    var.stats.spell_haste = UnitSpellHaste("player") / 100
    var.stats.haste = var.stats.spell_haste or var.stats.melee_haste
    var.stats.mastery_value = GetMasteryEffect() / 100
    var.stats.versatility_atk_mod = GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_DONE) / 100

    var.multipliers.tigersFury = 1.15 + talent.rank.carnivorousInstinct * 0.06

    if not unit.inCombat() and not unit.exists("target") then
        if var.profileStop then var.profileStop = false end
        var.leftCombat = var.getTime
    end

    var.unit5ID = br.GetObjectID(var.units.dyn5) or 0

    var.noDoT = var.unit5ID == 153758 or var.unit5ID == 156857 or var.unit5ID == 156849 or var.unit5ID == 156865 or
    var.unit5ID == 156869

    var.bsIncRemain = 0
    if buff.berserk.exists() then
        var.bsIncRemain = buff.berserk.remain()
    elseif buff.incarnationAvatarOfAshamane.exists() then
        var.bsIncRemain = buff.incarnationAvatarOfAshamane.remain()
    end

    var.bsIncUp = buff.berserk.exists() or buff.incarnationAvatarOfAshamane.exists()

    var.doubleClawedRake = talent.doubleClawedRake and 1 or 0

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

    var.fbMaxEnergy = var.energy >= 50 or buff.apexPredatorsCraving.exists() or
    (var.energy >= 25 and (buff.berserk.exists() or buff.incarnationAvatarOfAshamane.exists()))

    var.ticksGain.rake = var.ticks.gain("rake", "target") --var.rakeTicksGain(thisUnit)

    -- Rip Ticks
    var.ticksGain.rip = var.ticks.gain("rip", "target") --var.ripTicksGain(thisUnit)

    -- Thrash Ticks
    var.ticksGain.thrash = var.ticks.gain("thrashCat", "target") --var.thrashCatTicksGain("target")

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
                var.ticksGain.thrash = var.ticksGain.thrash +
                var.ticks.gain("thrashCat", thisUnit)                                               --var.thrashCatTicksGain(thisUnit)
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
        if moonfireCatTicksGain > ((var.maxMoonfireCatTicksGain + 1) - (#var.enemies.yards8 * 2.492)) then
            var.maxMoonfireCatTicksGain = moonfireCatTicksGain
            var.maxMoonfireCatTicksGainUnit = thisUnit
        end
    end
end

local updateUiOptions = function()
    var.ui = {
        --@type 1
        --aplMode = ui.value("APL Mode"),
        --@type 1 | 2 | 3
        --feroBiteExecute = ui.value("Ferocious Bite Execute"),
        --@type number
        --prePullTimer = tonumber(ui.value("Pre-Pull Timer")) or 0,
        --@type boolean
        --berserkPrePull = ui.checked("Berserk/Tiger's Fury Pre-Pull"),
        --@type boolean
        --@type number
        -- brutalSlashTargets = tonumber(ui.value("Brutal Slash Targets")) or 0,
        --@type boolean
        --permaFireCat = ui.checked("Perma Fire Cat"),
        --@type number
        --multiDoTLimit = tonumber(ui.value("Multi-DoT Limit")) or 0,
        --@type boolean
        --wildCharge = ui.checked("Wild Charge"),
        --@type 1 | 2 | 3 | 4 | 5
        --fillerSpell = ui.value("Filler Spell"),
        --@type 1 | 2
        --primalWrathUsage = ui.value("Primal Wrath Usage"),
        --@type number
        --dpsTest = tonumber(ui.value("DPS Testing")) or 0,
        --@type 1 | 2
        --potion = ui.value("Potion"),
        --@type boolean
        -- useRejuvenation = ui.checked("Rejuvenation"),
        --@type number
        --useRejuvenationValue = tonumber(ui.value("Rejuvenation")) or 0,
        --@type boolean
        --useSwiftmend = ui.checked("Swiftmend"),
        --@type number
        --useSwiftmendValue = tonumber(ui.value("Swiftmend")) or 0,
        --@type boolean
        --useWildGrowth = ui.checked("Wild Growth"),
        --@type number
        --useWildGrowthValue = tonumber(ui.value("Wild Growth")) or 0,
        --@type boolean
        --useMightyBash = ui.checked("Mighty Bash"),
        --@type boolean
        --useMaim = ui.checked("Maim"),
        --@type 1 | 2 | 3
        --owlweave = ui.value("Owlweave"),

        deathCatMode = ui.checked("Death Cat Mode"),
        autoShapeshifts = ui.checked("Auto Shapeshifts"),
        fallTimer = tonumber(ui.value("Fall Timer")) or 0,
        breakCC = ui.checked("Break Crowd Control"),
        useMarkOfTheWild = ui.checked("Mark of the Wild"),
        ---@type 1 | 2 | 3 | 4 | 5
        markOfTheWildUnit = ui.value("Mark of the Wild"),
        augmentRune = ui.checked("Augment Rune"),
        ---@type 1 | 2 | 3 | 4 | 5
        flask = ui.value("Flask"),
        racial = ui.checked("Racial"),
        ---@type 1 | 2 | 3
        adaptiveSwarm = ui.value("Adaptive Swarm"),
        convokeTheSpirits = ui.alwaysCdNever("Convoke The Spirits"),
        tigersFury = ui.checked("Tiger's Fury"),
        berserkIncarnation = ui.alwaysCdNever("Berserk/Incarnation"),
        useBarkskin = ui.checked("Barkskin"),
        useBarkskinValue = tonumber(ui.value("Barkskin")) or 0,
        useRebirth = ui.checked("Rebirth"),
        useRebirthTarget = rebirthOptions[ui.value("Rebirth - Target")],
        useRevive = ui.checked("Revive"),
        useReviveTarget = rebirthOptions[ui.value("Revive - Target")],
        useRemoveCorruption = ui.checked("Remove Corruption"),
        useRemoveCorruptionTarget = removeCorruptionOptions[ui.value("Remove Corruption - Target")],
        useSoothe = ui.checked("Soothe"),
        useRenewal = ui.checked("Renewal"),
        useRenewalValue = tonumber(ui.value("Renewal")) or 0,
        useSurvivalInstincts = ui.checked("Survival Instincts"),
        useSurvivalInstinctsValue = tonumber(ui.value("Survival Instincts")) or 0,
        useRegrowth = ui.checked("Regrowth"),
        useRegrowthValue = tonumber(ui.value("Regrowth")) or 0,
        useRegrowthOoC = ui.value("Regrowth - OoC") == 2,
        useRegrowthInC = ui.value("Regrowth - InC") == 1,
        ---@type 1 | 2
        useAutoHeal = ui.value("Auto Heal"),
        ---@type 1 | 2 | 3 | 4
        rotationMode = ui.mode.rotation,
        cooldownMode = ui.mode.cooldown == 1,
        defensiveMode = ui.mode.defensive == 1,
        interruptMode = ui.mode.interrupt == 1,
        cleaveMode = ui.mode.cleave == 1,
        prowlMode = ui.mode.prowl == 1 and true or false,
        pauseMode = ui.mode.pause == 1,
        useSkullBash = ui.checked("Skull Bash"),
        ---@type number
        interruptAt = tonumber(ui.value("Interrupt At")) or 0,
    }
end

local updateLocals = function()
    if not var.localsUpdated then
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
        talent  = br.player.talent
        ui      = br.player.ui
        unit    = br.player.unit
        units   = br.player.units
        use     = br.player.use
    end
    var.localsUpdated = true
end

---@param actionListName string
local callActionList = function(actionListName)
    if actionList[actionListName] then
        for i = 1, #actionList[actionListName] do
            local currentAction = actionList[actionListName][i]
            if currentAction() then
                return true
            end
        end
    end
end
----------------
--- ROTATION ---
----------------
local function runRotation()
    updateLocals()
    updateUiOptions()
    actionList.variables()

    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not unit.inCombat() and not unit.exists("target") and var.profileStop then
        var.profileStop = false
    elseif (unit.inCombat() and var.profileStop) or ui.pause() or ui.mode.rotation == 4 then
        return true
    else
        -----------------------
        --- Extras Rotation ---
        -----------------------
        if actionList.utility() then return true end
        --------------------------
        --- Defensive Rotation ---
        --------------------------
        if actionList.defensives() then return true end
        ------------------------------
        --- Out of Combat Rotation ---
        ------------------------------
        if actionList.precombat() then return true end
        --------------------------
        --- In Combat Rotation ---
        --------------------------
        -- Cat is 4 fyte!
        if unit.inCombat() then
            if actionList.def() then return true end
        end
    end
end
local id = 103
--local _, br = ...
if br.rotations[id] == nil then br.rotations[id] = {} end
br._G.tinsert(br.rotations[id], {
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})

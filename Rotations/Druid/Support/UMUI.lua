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

local loaded = false

---@class UMUI
br.rotations.support.UMUI = {
    createOptions = function()
        local optionTable

        local function rotationOptions()
            local section
            -- General Options
            section = br.ui:createSection(br.ui.window.profile, "General")
            br.ui:createCheckbox(section, "Berserk Biteweave", "If checked, the default priority will recommend Ferocious Bite more often when Berserk or Incarn is active.", false)
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
            -- Filler br.player.spell
            -- br.ui:createDropdownWithout(section, "Filler br.player.spell", { "Shred", "Rake", "Snapshot Rake", "Lunar Inspiration", "Swipe" }, 1, "|cffFFFFFFSet which br.player.spell to use as filler.")
            -- Mark of the Wild
            br.ui:createDropdown(section, "Mark of the Wild",
                { "|cffFFFF00Target", "|cffFF0000Mouseover", "|cff00FF00Player", "|cffFFFFFFFocus", "|cffFFFFFFGroup" }, 3,
                "|cffFFFFFFSet how to use Mark of the Wild")
            br.ui:checkSectionState(section)
            -- Cooldown Options
            section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
            br.player.module.Potion(section)
            -- Augment Rune
            br.ui:createCheckbox(section, "Augment Rune")
            -- Potion
            -- br.ui:createDropdownWithout(section, "Potion", { "None", "Elemental Potion of Ultimate Power R3" }, uiConstants.Potion.None, "|cffFFFFFFSet Potion to use.")
            -- FlaskUp Module
            -- module.FlaskUp("Agility", section)
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
    end,
    createTogles = function()
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
        --br.ui:createToggle(CleaveModes, "Cleave", 5, 0)
        -- Prowl Button
        local ProwlModes = {
            [1] = { mode = "On", value = 1, overlay = "Prowl Enabled", tip = "Rotation will use Prowl", highlight = 1, icon =
                br.player.spell.prowl },
            [2] = { mode = "Off", value = 2, overlay = "Prowl Disabled", tip = "Rotation will not use Prowl", highlight = 0, icon =
                br.player.spell.prowl }
        };
        br.ui:createToggle(ProwlModes, "Prowl", 5, 0)
    end,

    ---@class UIVariables
    ---@field markOfTheWildUnit fun(): 1 | 2 | 3 | 4 | 5
    ---@field flask fun(): 1 | 2 | 3 | 4 | 5
    ---@field adaptiveSwarm fun(): 1 | 2 | 3
    ---@field useAutoHeal fun(): 1 | 2
    ---@field rotationMode fun(): 1 | 2 | 3 | 4
    options = {
        deathCatMode = function() return ui.checked("Death Cat Mode") end,
        autoShapeshifts = function() return ui.checked("Auto Shapeshifts") end,
        fallTimer = function() return tonumber(ui.value("Fall Timer")) or 0 end,
        breakCC = function() return ui.checked("Break Crowd Control") end,
        useMarkOfTheWild = function() return ui.checked("Mark of the Wild") end,
        markOfTheWildUnit = function() return ui.value("Mark of the Wild") end,
        augmentRune = function() return ui.checked("Augment Rune") end,
        flask = function() return ui.value("Flask") end,
        racial = function() return ui.checked("Racial") end,
        adaptiveSwarm = function() return ui.value("Adaptive Swarm") end,
        convokeTheSpirits = function() return ui.alwaysCdNever("Convoke The Spirits") end,
        tigersFury = function() return ui.checked("Tiger's Fury") end,
        berserkIncarnation = function() return ui.alwaysCdNever("Berserk/Incarnation") end,
        useBarkskin = function() return ui.checked("Barkskin") end,
        useBarkskinValue = function() return tonumber(ui.value("Barkskin")) or 0 end,
        useRebirth = function() return ui.checked("Rebirth") end,
        useRevive = function() return ui.checked("Revive") end,
        useRemoveCorruption = function() return ui.checked("Remove Corruption") end,
        useSoothe = function() return ui.checked("Soothe") end,
        useRenewal = function() return ui.checked("Renewal") end,
        useRenewalValue = function() return tonumber(ui.value("Renewal")) or 0 end,
        useSurvivalInstincts = function() return ui.checked("Survival Instincts") end,
        useSurvivalInstinctsValue = function() return tonumber(ui.value("Survival Instincts")) or 0 end,
        useRegrowth = function() return ui.checked("Regrowth") end,
        useRegrowthValue = function() return tonumber(ui.value("Regrowth")) or 0 end,
        useRegrowthOoC = function() return ui.value("Regrowth - OoC") == 2 end,
        useRegrowthInC = function() return ui.value("Regrowth - InC") == 1 end,
        useAutoHeal = function() return ui.value("Auto Heal") end,
        rotationMode = function() return ui.mode.rotation end,
        cooldownMode = function() return ui.mode.cooldown == 1 end,
        defensiveMode = function() return ui.mode.defensive == 1 end,
        interruptMode = function() return ui.mode.interrupt == 1 end,
        prowlMode = function() return ui.mode.prowl == 1 and true or false end,
        pauseMode = function() return ui.mode.pause == 1 end,
        useSkullBash = function() return ui.checked("Skull Bash") end,
        interruptAt = function() return tonumber(ui.value("Interrupt At")) or 0 end,
        berserkBiteweave = function() return ui.checked("Berserk Biteweave") end,
        useRebirthTarget = function() return rebirthOptions[ui.value("Rebirth - Target")] end,
        useReviveTarget = function() return rebirthOptions[ui.value("Revive - Target")] end,
        useRemoveCorruptionTarget = function() return removeCorruptionOptions[ui.value("Remove Corruption - Target")] end,
    },
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
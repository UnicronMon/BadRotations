-------------------------------------------------------
-- Author = UnicronMon
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

local rotationName = "UnicronMon"

br.loadSupport("UMUI")

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
local race
local spell
---@type SupportFiles
local support
---@type DruidTalent
local talent
local unit
local units
local use
---@type BR.API.UI
local ui

local var
---@type UIVariables
local uiOpt
---@type UMFeralUtility
local utility

--------------------
--- Action Lists ---
--------------------
local actionList = {}

local updateUiOptions = function()
    uiOpt = support.UMUI.options
end

local supportLoaded = false
local loadSupport = function()
    if not supportLoaded then
        br.loadSupport("UMFeralUtility")
        br.loadSupport("UMFeralVariables")

        br.rotations.support.UMUI.load()
        br.rotations.support.UMFeralUtility.load()
        br.rotations.support.UMFeralVariables.load()

        uiOpt = br.rotations.support.UMUI.options
        utility = br.rotations.support.UMFeralUtility
        var = br.rotations.support.UMFeralVariables.var

        local aclLoadList = {
            [1] = "UMFeralACLPrecombat",
            [2] = "UMFeralACLUtility",
            [3] = "UMFeralACLDefensives",
            [4] = "UMFeralACLDefault",
            [5] = "UMFeralACLAoEBuilder",
            [6] = "UMFeralACLBerserk",
            [7] = "UMFeralACLBloodtalons",
            [8] = "UMFeralACLBuilder",
            [9] = "UMFeralACLClearcasting",
            [10] = "UMFeralACLCooldown",
            [11] = "UMFeralACLFinisher",
            [12] = "UMFeralACLInterrupts",
        }

        for i = 1, #aclLoadList do
            br.loadSupport(aclLoadList[i])
            br.rotations.support[aclLoadList[i]].load()
        end

        actionList.default = br.rotations.support.UMFeralACLDefault.default
        actionList.utility = br.rotations.support.UMFeralACLUtility.utility
        actionList.defensives = br.rotations.support.UMFeralACLDefensives.defensives
        actionList.precombat = br.rotations.support.UMFeralACLPrecombat.precombat
        supportLoaded = true
    end
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
        support = br.rotations.support
        talent  = br.player.talent
        ui      = br.player.ui
        unit    = br.player.unit
        units   = br.player.units
        use     = br.player.use
    end
    var.localsUpdated = true
end

----------------
--- ROTATION ---
----------------
local function runRotation()
    loadSupport()
    updateLocals()
    updateUiOptions()
    br.rotations.support.UMFeralVariables.update()

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
        if actionList.utility('run rotation') then return true end
        --------------------------
        --- Defensive Rotation ---
        --------------------------
        if actionList.defensives('run rotation') then return true end
        ------------------------------
        --- Out of Combat Rotation ---
        ------------------------------
        if actionList.precombat('run rotation') then return true end
        --------------------------
        --- In Combat Rotation ---
        --------------------------
        -- Cat is 4 fyte!
        if unit.inCombat() then
            if actionList.default('run rotation') then return true end
        end
    end
end
local id = 103
--local _, br = ...
if br.rotations[id] == nil then br.rotations[id] = {} end
br._G.tinsert(br.rotations[id], {
    name = rotationName,
    toggles = br.rotations.support.UMUI.createTogles,
    options = br.rotations.support.UMUI.createOptions,
    run = runRotation,
})

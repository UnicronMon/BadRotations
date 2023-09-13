local _,
---@class BR
br = ...
if br.api == nil then br.api = {} end
---@class BR.API.Units
br.api.units = function(self)
    local units = self.units
    -- Gets a unit within a specified range in front or around the player. 
    units.get = function(range,aoe)
        local dynString = "dyn"..range
        if aoe == nil then aoe = false end
        if aoe then dynString = dynString.."AOE" end
        local facing = not aoe
        local thisUnit = br.dynamicTarget(range, facing)
        -- Build units.dyn varaible
        if self.units[dynString] == nil then self.units[dynString] = {} end
        self.units[dynString] = thisUnit
        return thisUnit -- Backwards compatability for old way
    end
end
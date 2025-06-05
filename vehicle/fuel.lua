--- Vehicle utility functions for framework-agnostic fuel and key management.
--- @author itzdabbzz

local function validateVehicle(vehicle)
    return DoesEntityExist(vehicle)
end

local fuelHandlers = {
    ["LegacyFuel"] = {
        get = function(vehicle) return exports["LegacyFuel"]:GetFuel(vehicle) end,
        set = function(vehicle, fuel) exports["LegacyFuel"]:SetFuel(vehicle, fuel) end,
    },
    ["ps-fuel"] = {
        get = function(vehicle) return exports["ps-fuel"]:GetFuel(vehicle) end,
        set = function(vehicle, fuel) exports["ps-fuel"]:SetFuel(vehicle, fuel) end,
    },
    ["lj-fuel"] = {
        get = function(vehicle) return exports["lj-fuel"]:GetFuel(vehicle) end,
        set = function(vehicle, fuel) exports["lj-fuel"]:SetFuel(vehicle, fuel) end,
    },
    ["cdn-fuel"] = {
        get = function(vehicle) return exports["cdn-fuel"]:GetFuel(vehicle) end,
        set = function(vehicle, fuel) exports["cdn-fuel"]:SetFuel(vehicle, fuel) end,
    },
    ["hyon_gas_station"] = {
        get = function(vehicle) return exports["hyon_gas_station"]:GetFuel(vehicle) end,
        set = function(vehicle, fuel) exports["hyon_gas_station"]:SetFuel(vehicle, fuel) end,
    },
    ["okokGasStation"] = {
        get = function(vehicle) return exports["okokGasStation"]:GetFuel(vehicle) end,
        set = function(vehicle, fuel) exports["okokGasStation"]:SetFuel(vehicle, fuel) end,
    },
    ["nd_fuel"] = {
        get = function(vehicle) return exports["nd_fuel"]:GetFuel(vehicle) end,
        set = function(vehicle, fuel) exports["nd_fuel"]:SetFuel(vehicle, fuel) end,
    },
    ["myFuel"] = {
        get = function(vehicle) return exports["myFuel"]:GetFuel(vehicle) end,
        set = function(vehicle, fuel) exports["myFuel"]:SetFuel(vehicle, fuel) end,
    },
    ["ox_fuel"] = {
        get = function(vehicle) return GetVehicleFuelLevel(vehicle) end,
        set = function(vehicle, fuel) Entity(vehicle).state.fuel = fuel end,
    },
    ["Renewed-Fuel"] = {
        get = function(vehicle) return GetVehicleFuelLevel(vehicle) end,
        set = function(vehicle, fuel) exports["Renewed-Fuel"]:SetFuel(vehicle, fuel) end,
    },
    ["rcore_fuel"] = {
        get = function(vehicle) return exports.rcore_fuel:GetVehicleFuelPercentage(vehicle) end,
        set = function(vehicle, fuel) exports.rcore_fuel:SetVehicleFuel(vehicle, fuel) end,
    },
}

--- Gets the fuel level of a vehicle, supporting multiple fuel systems.
--- @param fs string The fuel system identifier.
--- @param vehicle integer The vehicle entity handle.
--- @return number fuelLevel The current fuel level (0-100 or system-specific).
function GetFuel(fs, vehicle)
    if not validateVehicle(vehicle) then return 0 end
    local handler = fuelHandlers[fs]
    if handler and handler.get then
        return handler.get(vehicle)
    else
        -- Custom or fallback fuel system
        return 65
    end
end

--- Sets the fuel level of a vehicle, supporting multiple fuel systems.
--- @param fs string The fuel system identifier.
--- @param vehicle integer The vehicle entity handle.
--- @param fuel number The desired fuel level.
function SetFuel(fs, vehicle, fuel)
    if not validateVehicle(vehicle) then return false end
    local handler = fuelHandlers[fs]
    if handler and handler.set then
        handler.set(vehicle, fuel)
    else
        -- Custom or fallback fuel system
        -- Implement your custom fuel setter here
    end
end

return {
    GetFuel = GetFuel,
    SetFuel = SetFuel,
}

-- exports('GetFuel', GetFuel)
-- exports('SetFuel', SetFuel)

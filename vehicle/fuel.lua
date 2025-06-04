--- Vehicle utility functions for framework-agnostic fuel and key management.
--- @author itzdabbzz

--- Gets the fuel level of a vehicle, supporting multiple fuel systems.
--- @param vehicle integer The vehicle entity handle.
--- @return number fuelLevel The current fuel level (0-100 or system-specific).
function GetFuel(fs, vehicle)
    if not DoesEntityExist(vehicle) then return 0 end
    if fs == "LegacyFuel" or fs == "ps-fuel" or fs == "lj-fuel" or fs == "cdn-fuel"
        or fs == "hyon_gas_station" or fs == "okokGasStation" or fs == "nd_fuel"
        or fs == "myFuel" then
        return exports[fs]:GetFuel(vehicle)
    elseif fs == "ti_fuel" then
        local level, fuelType = exports["ti_fuel"]:getFuel(vehicle)
        TriggerServerEvent("dabz_lib:server:save-ti-fuel-type", DL.Vehicle.GetPlate(vehicle), fuelType)
        return level
    elseif fs == "ox_fuel" or fs == "Renewed-Fuel" then
        return GetVehicleFuelLevel(vehicle)
    elseif fs == "rcore_fuel" then
        return exports.rcore_fuel:GetVehicleFuelPercentage(vehicle)
    else
        -- Custom or fallback fuel system
        return 65
    end
end

--- Sets the fuel level of a vehicle, supporting multiple fuel systems.
--- @param vehicle integer The vehicle entity handle.
--- @param fuel number The desired fuel level.
function SetFuel(fs, vehicle, fuel)
    if not DoesEntityExist(vehicle) then return false end
    if fs == "LegacyFuel" or fs == "ps-fuel" or fs == "lj-fuel" or fs == "cdn-fuel"
        or fs == "hyon_gas_station" or fs == "okokGasStation" or fs == "nd_fuel"
        or fs == "myFuel" or fs == "Renewed-Fuel" then
        exports[fs]:SetFuel(vehicle, fuel)
    elseif fs == "ti_fuel" then
        local fuelType = lib.callback.await("dabz_lib:server:get-ti-fuel-type", false, DL.Vehicle.GetPlate(vehicle))
        exports["ti_fuel"]:setFuel(vehicle, fuel, fuelType or nil)
    elseif fs == "ox_fuel" then
        Entity(vehicle).state.fuel = fuel
    elseif fs == "rcore_fuel" then
        exports.rcore_fuel:SetVehicleFuel(vehicle, fuel)
    else
        -- Custom or fallback fuel system
        -- Implement your custom fuel setter here
    end
end
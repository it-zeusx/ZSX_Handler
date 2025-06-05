--- Vehicle property utility functions, framework-agnostic.
--- @author itzdabbzz

local function decodeJsonIfString(value)
    if type(value) == "string" then
        local ok, decoded = pcall(json.decode, value)
        if ok and decoded then
            return decoded
        else
            return false
        end
    elseif type(value) == "table" then
        return value
    end
    return false
end

local modsColumnHandlers = {
    QBCore = function(vehicle) return decodeJsonIfString(vehicle.mods) end,
    Qbox   = function(vehicle) return decodeJsonIfString(vehicle.mods) end,
    ESX    = function(vehicle) return decodeJsonIfString(vehicle.vehicle) end,
}

--- Gets the vehicle modifications/properties column from a vehicle data table, framework-agnostic.
--- @param vehicle table The vehicle data table (from DB or server).
--- @return table|false mods The vehicle mods/properties table, or false on error.
function GetModsColumn(vehicle)
    if not vehicle then return false end
    local handler = modsColumnHandlers[Config.Framework]
    if handler then
        return handler(vehicle)
    end
    return false
end

local getPropsHandlers = {
    QBCore = function(vehicle)
        if QBCore and QBCore.Functions and QBCore.Functions.GetVehicleProperties then
            return QBCore.Functions.GetVehicleProperties(vehicle)
        end
    end,
    Qbox = function(vehicle)
        if lib and lib.getVehicleProperties then
            return lib.getVehicleProperties(vehicle) or false
        end
    end,
    ESX = function(vehicle)
        if ESX and ESX.Game and ESX.Game.GetVehicleProperties then
            return ESX.Game.GetVehicleProperties(vehicle)
        end
    end,
}

--- Gets the current properties of a vehicle entity, using the best available resource.
--- @param vehicle integer The vehicle entity handle.
--- @return table|false props The vehicle properties table, or false on error.
function GetVehicleProperties(vehicle)
    if not DoesEntityExist(vehicle) then return false end
    if GetResourceState("jg-mechanic") == "started" then
        return exports["jg-mechanic"]:getVehicleProperties(vehicle)
    end
    local handler = getPropsHandlers[Config.Framework]
    if handler then
        return handler(vehicle)
    end
    return false
end

local setPropsHandlers = {
    QBCore = function(vehicle, props)
        if QBCore and QBCore.Functions and QBCore.Functions.SetVehicleProperties then
            return QBCore.Functions.SetVehicleProperties(vehicle, props)
        end
    end,
    Qbox = function(vehicle, props)
        if lib and lib.setVehicleProperties then
            return lib.setVehicleProperties(vehicle, props)
        end
    end,
    ESX = function(vehicle, props)
        if ESX and ESX.Game and ESX.Game.SetVehicleProperties then
            return ESX.Game.SetVehicleProperties(vehicle, props)
        end
    end,
}

--- Sets the properties of a vehicle entity, using the best available resource.
--- @param vehicle integer The vehicle entity handle.
--- @param props table The vehicle properties table.
function SetVehicleProperties(vehicle, props)
    if not DoesEntityExist(vehicle) then return false end
    if not props or type(props) ~= "table" then return false end
    if GetResourceState("jg-mechanic") == "started" then
        return exports["jg-mechanic"]:setVehicleProperties(vehicle, props)
    end
    local handler = setPropsHandlers[Config.Framework]
    if handler then
        return handler(vehicle, props)
    end
    return false
end

--- Gets the (possibly de-faked) license plate of a vehicle entity.
--- @param vehicle integer The vehicle entity handle.
--- @return string|false plate The trimmed, real plate or false on error.
function GetPlate(vehicle)
    if not DoesEntityExist(vehicle) then return false end

    local plate = GetVehicleNumberPlateText(vehicle)
    if not plate or plate == "" then return false end

    -- Handle fake plate systems
    if GetResourceState("brazzers-fakeplates") == "started" then
        local originalPlate = lib.callback.await("brazzers-fakeplates:getPlateFromFakePlate", false, plate)
        if originalPlate and originalPlate ~= "" then
            plate = originalPlate
        end
    end

    -- Trim whitespace
    local trPlate = plate:match("^%s*(.-)%s*$")
    if not trPlate or trPlate == "" then return false end

    return trPlate
end

--- Gets a human-friendly label for a vehicle model, using shared data or GTA natives.
--- @param model string|number The vehicle model name or hash.
--- @return string label The best-guess label for the vehicle.
function GetVehicleLabel(model)
    if not model then return "Unknown" end

    local hash = type(model) == "number" and model or GetHashKey(model)

    -- Check config overrides
    if Config.VehicleLabels then
        if Config.VehicleLabels[model] then
            return Config.VehicleLabels[model]
        elseif Config.VehicleLabels[tostring(hash)] then
            return Config.VehicleLabels[tostring(hash)]
        end
    end

    -- QBCore shared vehicles
    if type(model) == "string" and Config.Framework == "QBCore"
        and QBCore and QBCore.Shared and QBCore.Shared.Vehicles then
        local vehShared = QBCore.Shared.Vehicles[model]
        if vehShared then
            return (vehShared.brand or "") .. " " .. (vehShared.name or model)
        end
    end

    -- Qbox shared vehicles
    if Config.Framework == "Qbox" and exports.qbx_core and exports.qbx_core.GetVehiclesByHash then
        local vehShared = exports.qbx_core:GetVehiclesByHash()[hash]
        if vehShared then
            return (vehShared.brand or "") .. " " .. (vehShared.name or model)
        end
    end

    -- Fallback to GTA natives
    local makeName = GetMakeNameFromVehicleModel(hash)
    local modelName = GetDisplayNameFromVehicleModel(hash)
    local makeLabel = GetLabelText(makeName)
    local modelLabel = GetLabelText(modelName)
    local label = ((makeLabel ~= "NULL" and makeLabel or "") .. " " .. (modelLabel ~= "NULL" and modelLabel or "")):gsub("^%s+", ""):gsub("%s+$", "")

    if label == "" or label == " " or label:find("CARNOTFOUND") then
        label = tostring(model)
    end

    return label
end



-- exports('GetVehicleLabel', GetVehicleLabel)
-- exports('GetPlate', GetPlate)
-- exports('SetVehicleProperties', SetVehicleProperties)
-- exports('GetVehicleProperties', GetVehicleProperties)
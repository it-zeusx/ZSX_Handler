--- Vehicle utility functions for framework-agnostic fuel and key management.
--- @author itzdabbzz

local function validatePlate(plate, vehicleEntity, action)
    if not DoesEntityExist(vehicleEntity) then return false end
    if not plate or plate == "" then
        print(string.format("^1[ERROR] No plate provided to %s^0", action))
        return false
    end
    return plate:upper()
end

local keyHandlers = {
    ["qb-vehiclekeys"] = {
        give = function(plate) TriggerEvent("vehiclekeys:client:SetOwner", plate) end,
    },
    ["jaksam-vehicles-keys"] = {
        give = function(plate) TriggerServerEvent("vehicles_keys:selfGiveVehicleKeys", plate) end,
    },
    ["mk_vehiclekeys"] = {
        give = function(_, _, vehicleEntity) exports["mk_vehiclekeys"]:AddKey(vehicleEntity) end,
    },
    ["qs-vehiclekeys"] = {
        give = function(plate, vehicleEntity)
            local model = GetDisplayNameFromVehicleModel(GetEntityModel(vehicleEntity))
            exports["qs-vehiclekeys"]:GiveKeys(plate, model)
        end,
        remove = function(plate, vehicleEntity)
            local model = GetDisplayNameFromVehicleModel(GetEntityModel(vehicleEntity))
            exports["qs-vehiclekeys"]:RemoveKeys(plate, model)
        end,
    },
    ["wasabi_carlock"] = {
        give = function(plate) exports.wasabi_carlock:GiveKey(plate) end,
        remove = function(plate) exports.wasabi_carlock:RemoveKey(plate) end,
    },
    ["cd_garage"] = {
        give = function(plate) TriggerEvent("cd_garage:AddKeys", plate) end,
    },
    ["okokGarage"] = {
        give = function(plate) TriggerServerEvent("okokGarage:GiveKeys", plate) end,
    },
    ["t1ger_keys"] = {
        give = function(plate, vehicleEntity, _, origin)
            local vehicleName = GetDisplayNameFromVehicleModel(GetEntityModel(vehicleEntity))
            if origin == "job" then
                exports['t1ger_keys']:GiveJobKeys(plate, vehicleName, true)
            else
                TriggerServerEvent("t1ger_keys:updateOwnedKeys", plate, true)
            end
        end,
        remove = function(plate)
            TriggerServerEvent("t1ger_keys:updateOwnedKeys", plate, false)
        end,
    },
    ["MrNewbVehicleKeys"] = {
        give = function(_, _, vehicleEntity) exports.MrNewbVehicleKeys:GiveKeys(vehicleEntity) end,
        remove = function(_, _, vehicleEntity) exports.MrNewbVehicleKeys:RemoveKeys(vehicleEntity) end,
    },
    ["Renewed"] = {
        give = function(plate) exports["Renewed-Vehiclekeys"]:addKey(plate) end,
        remove = function(plate) exports["Renewed-Vehiclekeys"]:removeKey(plate) end,
    },
    ["tgiann-hotwire"] = {
        give = function(_, plate, vehicleEntity) exports["tgiann-hotwire"]:CheckKeyInIgnitionWhenSpawn(vehicleEntity, plate) end,
    },
}

--- Gives vehicle keys to the player for a specific vehicle and origin.
--- @param vk string The key system identifier.
--- @param plate string The vehicle's license plate.
--- @param vehicleEntity integer The vehicle entity handle.
--- @param origin "personal"|"job"|"gang" The key origin type.
function GiveKeys(vk, plate, vehicleEntity, origin)
    plate = validatePlate(plate, vehicleEntity, "GiveKeys")
    if not plate then return false end

    local handler = keyHandlers[vk]
    if handler and handler.give then
        handler.give(plate, vehicleEntity, origin, origin)
    else
        -- Implement your custom key system here
    end
end

--- Removes vehicle keys from the player for a specific vehicle and origin.
--- @param vk string The key system identifier.
--- @param plate string The vehicle's license plate.
--- @param vehicleEntity integer The vehicle entity handle.
--- @param origin "personal"|"job"|"gang" The key origin type.
function RemoveKeys(vk, plate, vehicleEntity, origin)
    plate = validatePlate(plate, vehicleEntity, "RemoveKeys")
    if not plate then return false end

    local handler = keyHandlers[vk]
    if handler and handler.remove then
        handler.remove(plate, vehicleEntity, origin, origin)
    else
        -- Implement your custom key system here
    end
end

return {
    GiveKeys = GiveKeys
    RemoveKeys = RemoveKeys,
}

-- exports('GiveKeys', GiveKeys)
-- exports('RemoveKeys', RemoveKeys)
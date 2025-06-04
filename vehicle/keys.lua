--- Vehicle utility functions for framework-agnostic fuel and key management.
--- @author itzdabbzz

--- Gives vehicle keys to the player for a specific vehicle and origin.
--- @param plate string The vehicle's license plate.
--- @param vehicleEntity integer The vehicle entity handle.
--- @param origin "personal"|"job"|"gang" The key origin type.
function GiveKeys(vk, plate, vehicleEntity, origin)
    if not DoesEntityExist(vehicleEntity) then return false end
    if not plate or plate == "" then
        print("^1[ERROR] No plate provided to GiveKeys^0")
        return false
    end
    plate = plate:upper()
    if vk == "qb-vehiclekeys" then
        TriggerEvent("vehiclekeys:client:SetOwner", plate)
    elseif vk == "jaksam-vehicles-keys" then
        TriggerServerEvent("vehicles_keys:selfGiveVehicleKeys", plate)
    elseif vk == "mk_vehiclekeys" then
        exports["mk_vehiclekeys"]:AddKey(vehicleEntity)
    elseif vk == "qs-vehiclekeys" then
        local model = GetDisplayNameFromVehicleModel(GetEntityModel(vehicleEntity))
        exports["qs-vehiclekeys"]:GiveKeys(plate, model)
    elseif vk == "wasabi_carlock" then
        exports.wasabi_carlock:GiveKey(plate)
    elseif vk == "cd_garage" then
        TriggerEvent("cd_garage:AddKeys", plate)
    elseif vk == "okokGarage" then
        TriggerServerEvent("okokGarage:GiveKeys", plate)
    elseif vk == "t1ger_keys" then
        local vehicleName = GetDisplayNameFromVehicleModel(GetEntityModel(vehicleEntity))
        if origin == "job" then
            exports['t1ger_keys']:GiveJobKeys(plate, vehicleName, true)
        else
            TriggerServerEvent("t1ger_keys:updateOwnedKeys", plate, true)
        end
    elseif vk == "MrNewbVehicleKeys" then
        exports.MrNewbVehicleKeys:GiveKeys(vehicleEntity)
    elseif vk == "Renewed" then
        exports["Renewed-Vehiclekeys"]:addKey(plate)
    elseif vk == "tgiann-hotwire" then
        exports["tgiann-hotwire"]:CheckKeyInIgnitionWhenSpawn(vehicleEntity, plate)
    else
        -- Implement your custom key system here
    end
end

--- Removes vehicle keys from the player for a specific vehicle and origin.
--- @param plate string The vehicle's license plate.
--- @param vehicleEntity integer The vehicle entity handle.
--- @param origin "personal"|"job"|"gang" The key origin type.
function RemoveKeys(vk, plate, vehicleEntity, origin)
    if not DoesEntityExist(vehicleEntity) then return false end
    if not plate or plate == "" then
        print("^1[ERROR] No plate provided to RemoveKeys^0")
        return false
    end
    plate = plate:upper()
    if vk == "qs-vehiclekeys" then
        local model = GetDisplayNameFromVehicleModel(GetEntityModel(vehicleEntity))
        exports["qs-vehiclekeys"]:RemoveKeys(plate, model)
    elseif vk == "wasabi_carlock" then
        exports.wasabi_carlock:RemoveKey(plate)
    elseif vk == "t1ger_keys" then
        TriggerServerEvent("t1ger_keys:updateOwnedKeys", plate, false)
    elseif vk == "MrNewbVehicleKeys" then
        exports.MrNewbVehicleKeys:RemoveKeys(vehicleEntity)
    elseif vk == "Renewed" then
        exports["Renewed-Vehiclekeys"]:removeKey(plate)
    else
        -- Implement your custom key system here
    end
end
local Config = Config or {}


local function GetVehicleInFront()
    local playerPed = PlayerPedId()
    local playerPos = GetEntityCoords(playerPed, true)
    local inFrontOfPlayer = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 5.0, 0.0)
    local rayHandle = StartShapeTestRay(playerPos.x, playerPos.y, playerPos.z, inFrontOfPlayer.x, inFrontOfPlayer.y, inFrontOfPlayer.z, 10, playerPed, 0)
    local _, hit, _, _, entityHit = GetShapeTestResult(rayHandle)
    
    if hit == 1 and IsEntityAVehicle(entityHit) then
        return entityHit
    else
        return nil
    end
end

RegisterCommand('dv', function()
    local vehicle = GetVehicleInFront()

    if vehicle then
        if Config.EnableSpeedCheck then
            local vehicleSpeed = GetEntitySpeed(vehicle)
            local speedInMph = vehicleSpeed * 2.23694

            if speedInMph > Config.MaxSpeedMPH then
                exports.ox_lib:notify({
                    title = 'Whoa!',
                    description = "You can't delete this vehicle! It's moving too fast.",
                    type = 'error',
                    duration = Config.NotifyDuration,
                    icon = 'fa-solid fa-car'
                })
                return
            end
        end

        local vehicleModel = GetEntityModel(vehicle)
        local vehicleName = GetDisplayNameFromVehicleModel(vehicleModel)

        exports.ox_lib:notify({
            title = 'Vehicle Deleted',
            description = 'You have successfully deleted the ' .. vehicleName,
            type = 'success',
            duration = Config.NotifyDuration,
            icon = 'fa-solid fa-car'
        })

        SetEntityAsMissionEntity(vehicle, true, true)
        DeleteVehicle(vehicle)
        if DoesEntityExist(vehicle) then
            DeleteEntity(vehicle)
        end
    else
        exports.ox_lib:notify({
            title = 'Error',
            description = 'There is no vehicle in front of you!',
            type = 'error',
            duration = Config.NotifyDuration,
            icon = 'fa-solid fa-car'
        })
    end
end, false)

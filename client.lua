local Config = Config or {}

RegisterCommand('dv', function()
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)

    if IsPedInAnyVehicle(playerPed, false) then
        if Config.EnableSpeedCheck then
            local vehicleSpeed = GetEntitySpeed(vehicle)
            local speedInMph = vehicleSpeed * 2.23694

            if speedInMph > Config.MaxSpeedMPH then
                exports.ox_lib:notify({
                    title = 'Whoa!',
                    description = "You can't delete your vehicle! Slow down.",
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
            description = 'You have successfully deleted your ' .. vehicleName,
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
            title = 'Erorr',
            description = 'You are not in a vehicle!',
            type = 'error',
            duration = Config.NotifyDuration,
            icon = 'fa-solid fa-car'
        })
    end
end, false)

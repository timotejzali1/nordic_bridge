if Bridge.Keys._mode ~= 'esx_vehiclelock' and Bridge.Keys._mode ~= 'esx' then return end

Bridge.Keys.RegisterAdapter(
    function(src, plate)
        TriggerClientEvent('esx_vehiclelock:givekey', src, plate)
        TriggerClientEvent('vehiclelock:givekey', src, plate)
        Bridge.Keys.TryExport('esx_vehiclelock', {
            function(e) e:giveVehicleKey(src, plate) end,
        })
    end,
    function(src, plate)
        TriggerClientEvent('esx_vehiclelock:removekey', src, plate)
        Bridge.Keys.TryExport('esx_vehiclelock', {
            function(e) e:removeVehicleKey(src, plate) end,
        })
    end
)

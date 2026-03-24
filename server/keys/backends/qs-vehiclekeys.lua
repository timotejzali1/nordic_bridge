if Bridge.Keys._mode ~= 'qs-vehiclekeys' then return end

Bridge.Keys.RegisterAdapter(
    function(src, plate)
        if Bridge.Keys.TryExport('qs-vehiclekeys', {
                function(e) e:GiveServerKeys(src, plate, nil, false) end,
                function(e) e:GiveServerKeys(src, plate) end,
                function(e) e:GiveKeys(src, plate) end,
            }) then return end
        TriggerClientEvent('qs-vehiclekeys:client:AddKeys', src, plate)
    end,
    function(src, plate)
        Bridge.Keys.TryExport('qs-vehiclekeys', {
            function(e) e:RemoveServerKeys(src, plate) end,
            function(e) e:RemoveKeys(src, plate) end,
        })
        TriggerClientEvent('qs-vehiclekeys:client:RemoveKeys', src, plate)
    end
)

if Bridge.Keys._mode ~= 'qb-vehiclekeys' then return end

Bridge.Keys.RegisterAdapter(
    function(src, plate)
        if Bridge.Keys.TryExport('qb-vehiclekeys', {
                function(e) e:GiveKeys(src, plate) end,
                function(e) e.GiveKeys(e, src, plate) end,
            }) then return end
        TriggerClientEvent('qb-vehiclekeys:client:AddKeys', src, plate)
        TriggerClientEvent('vehiclekeys:client:SetOwner', src, plate)
    end,
    function(src, plate)
        Bridge.Keys.TryExport('qb-vehiclekeys', {
            function(e) e:RemoveKeys(src, plate) end,
            function(e) e.RemoveKeys(e, src, plate) end,
        })
        TriggerClientEvent('qb-vehiclekeys:client:RemoveKeys', src, plate)
    end
)

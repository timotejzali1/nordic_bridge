if Bridge.Keys._mode ~= 'cd_garage' then return end

Bridge.Keys.RegisterAdapter(
    function(src, plate)
        TriggerClientEvent('cd_garage:AddKeys', src, plate)
        Bridge.Keys.TryExport('cd_garage', {
            function(e) e:GiveKeys(src, plate) end,
        })
    end,
    function(src, plate)
        TriggerClientEvent('cd_garage:RemoveKeys', src, plate)
        Bridge.Keys.TryExport('cd_garage', {
            function(e) e:RemoveKeys(src, plate) end,
        })
    end
)

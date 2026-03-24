if Bridge.Keys._mode ~= 'wasabi_carlock' then return end

Bridge.Keys.RegisterAdapter(
    function(src, plate)
        Bridge.Keys.TryExport('wasabi_carlock', {
            function(e) e:GiveKey(src, plate) end,
            function(e) e:GiveKeys(src, plate) end,
        })
        TriggerClientEvent('wasabi_carlock:client:GiveKeys', src, plate)
    end,
    function(src, plate)
        Bridge.Keys.TryExport('wasabi_carlock', {
            function(e) e:RemoveKey(src, plate) end,
            function(e) e:RemoveKeys(src, plate) end,
        })
        TriggerClientEvent('wasabi_carlock:client:RemoveKeys', src, plate)
    end
)

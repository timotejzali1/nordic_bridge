if Bridge.Keys._mode ~= 'okokgarage' then return end

Bridge.Keys.RegisterAdapter(
    function(src, plate)
        TriggerClientEvent('okokGarage:GiveKeys', src, plate)
        Bridge.Keys.TryExport('okokGarage', {
            function(e) e:GiveKeys(src, plate) end,
        })
    end,
    function(src, plate)
        TriggerClientEvent('okokGarage:RemoveKeys', src, plate)
    end
)

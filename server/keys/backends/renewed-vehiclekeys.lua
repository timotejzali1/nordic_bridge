if Bridge.Keys._mode ~= 'renewed-vehiclekeys' then return end

Bridge.Keys.RegisterAdapter(
    function(src, plate)
        Bridge.Keys.TryExport('Renewed-Vehiclekeys', {
            function(e) e:addKey(src, plate) end,
            function(e) e:AddKey(src, plate) end,
            function(e) e:giveKeys(src, plate) end,
        })
    end,
    function(src, plate)
        Bridge.Keys.TryExport('Renewed-Vehiclekeys', {
            function(e) e:removeKey(src, plate) end,
            function(e) e:RemoveKey(src, plate) end,
        })
    end
)

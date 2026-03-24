if Bridge.Keys._mode ~= 'mk_vehiclekeys' then return end

Bridge.Keys.RegisterAdapter(
    function(src, plate)
        Bridge.Keys.TryExport('mk_vehiclekeys', {
            function(e) e:GiveKeys(src, plate) end,
            function(e) e:GiveKeys(plate, src) end,
            function(e) e.GiveKeys(e, src, plate) end,
        })
    end,
    function(src, plate)
        Bridge.Keys.TryExport('mk_vehiclekeys', {
            function(e) e:RemoveKeys(src, plate) end,
            function(e) e:RemoveKeys(plate, src) end,
        })
    end
)
